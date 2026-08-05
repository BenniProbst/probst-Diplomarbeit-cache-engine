# LENS f6-54-xml-anweisung — Einlese-Bericht (05.08.2026)

FRAGE 6 / Task #54: Was ist der PLAN-Weg, wie der Planer die CEB "per XML-ANWEISUNG instrumentiert"?
Quellen: SSOT-Ledger, Bauplaene, Kette-Audit 05.08., Sessions, Memories, 982er-Anker, Chunk-Delta.
Alle Pfade relativ zu /home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/ (kurz: LED = docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md).

## 0. Vorklaerung: ZWEI verschiedene "#54" im Korpus

1. **Task #54 (§24.E, LED:2135/2660/3027)** = VERIFIKATIONS-Task: belegen, dass Organ-/System-/Mess-Achsen
   weiterhin NUR durch den XML-gespeisten Experiment-B+-Baum gesteuert werden ("kein hartkodierter Bypass,
   keine Runtime-Umgehung"). User-Wortlaut LED:2135: der Experiment-B+-Baum ist "Prototyp und Vorlaeufer,
   sowie weiterhin zentrale Konfigurations-Repraesentation des Experiment-Planer-Programms und Interpreters
   des Systems."
2. **Paket #54 (§62-B, LED:3315)** = UMSETZUNGS-Paket der Planer-Instrumentierung ("emit-Vertrags-Kette").
   Die Lens-Frage zielt auf (2); (1) liefert die Invariante dahinter: XML/B+-Baum = einzige Steuerquelle.

## 1. DIE autoritative Plan-Definition (User 21.07., §62-B — LED:3315, verbatim)

> "Die CEB PIPED die Shell-/Status-Ausgaben an den PLANER weiter — der Planer ruft die emittete CEB auf
> und STEUERT sie: **der Planer wird aufgerufen, die CEB per XML-ANWEISUNG zu INSTRUMENTIEREN**, um mit
> ihr Batches von Tier-Binaries zu bauen und auf Mess-Tauglichkeit zu pruefen. (= Kern-Baustein der
> emit-VERTRAGS-KETTE aus dem §63-Nachtrag; koppelt an §38-Rueck-Kanal [sparse Fortschritt],
> R2-Driver-Split [#35-Naehe], Pruef-Dock-Registry und den 3-Modi-CEB-Betrieb; Umsetzung = Paket #54.)"

Kontext im selben Absatz (LED:3315): Batch laeuft CEB-INTERN (kein Shell-Loop); Runtime-Batch-Bau ->
GTest-PRUEFSTAND am Pruefdock ("GOOGLE-TESTS ... auf alle Funktionen getestet ... BEVOR gemessen wird") ->
erst danach Messung; Tooling-Konsistenz CEB<->Tier (einkompilierte Prueftools der CEB bestimmen die
Pflicht-Ausstattung des Tier-Binaries). Memory-Spiegel: project_62_planer_universal_cache_log_claim_compare.md:22
("CEB piped Status an den Planer, der die CEB per XML-Anweisung INSTRUMENTIERT (direkte Steuer-Kette =
Kern der emit-Vertrags-Kette, Task #54; koppelt §38-Rueck-Kanal + R2/#35)").

Vorstufe (LED:3316): Emissions-Umbau — je Maschine EIN Build+Pruef-Batch-Job + EIN Mess-Batch-Job,
"Job-Anzahl O(Maschinen), nie O(Perms x Chunks)"; Perm-Kombis werden Log-Legende. Laut Kette-Audit 05.08.
(synthese.md, Glied 5 KONFORM-Liste) ist dieser Umbau BEHOBEN (kGnBatchSlice==4096, director:541/542).

GO-Lage: §63-GO-Stempel (LED:3375) deckt "§62-B-Batch-Mechanik/#54 (CEB-interner Pruefstand-Batch +
Planer-Instrumentierung)"; Position im Fahrplan: "Cache warm -> 320er -> S7 -> S8 -> emit-Vertrags-Kette/#54
-> Post-v3" und §63-Nachtrag LED:3372: "Nachdem die CI steht, wird die emit-Vertrags-Kette
(Planer->CEB->Tier-Vertraege) KORREKT AUFGEBAUT (koppelt an R1/#35-.so-Schnitt + #36-Resolver)."
Sessions: 20260722-SESSION-KONTEXTUEBERGABE-abend-k7b-komplett.md:71 (Punkt 9: "#54 emit-Vertrags-Kette
(CEB-interner Pruefstand-Batch + Status-Pipe + Planer-Instrumentierung; baut auf Batch-Emission auf)");
20260722-SESSION-REIHENFOLGE-UPDATE-praezisierungen.md:38 ("#54 emit-Vertrags-Kette (Pruefstand-Batch,
von #46b-Reservierungen abgedeckt)").

## 2. Was die "XML-ANWEISUNG" materiell IST — der Plan-Weg aus den bestehenden Paragraphen

Der Korpus definiert KEINE neue, separate "XML-Anweisungs-Datei" mit eigenem Schema-Paragraphen.
Der PLAN-Weg setzt sich stattdessen aus BEREITS SPEZIFIZIERTEN Bausteinen zusammen — das ist der
"sauberste Weg nach Plan" im Sinne der Owner-F6-Antwort:

a) **Steuerbefehls-Semantik = die XML selbst (§30.3, LED:2256, verbatim):** "Mess-Modi des Systems = die
   **Steuerbefehle in der XML**, welche je Achse oder per Gesamtexperiment eine enumerierte Range oder
   bestimmte Algorithmus-Bezeichnungen je Achse auflisten und permutiert durchtesten koennen.
   (-> verknuepft mit Resolver-Fork R5 Range-Syntax + Anwender-XML-ANZEIGE §27/§28.)"
   Die autoritative Anwender-XML (heute kanonisch: experiment_golden_kern.xml, LED-§62-F-Nachtrag 03.08.)
   traegt also die Anweisungs-Inhalte; Modi sind CALL-Parameter der XML (§62-C run_methodology,
   "EIN Modus je Call", LED-Auszug §61/§62-C).

b) **Uebergabe-Form Planer->CEB = §38-Teilbaum-Serialisierung (LED:2363, verbatim):** "die zusammenhaengenden
   unteren Teilbaeume der System-Achsen mit nachfolgenden freigegebenen und regulaeren Organ-Achsen werden
   per SERIALISIERUNG vom Experiment-Planer an die CEB uebergeben ... nicht nur beliebige Configs, sondern
   direkt die RANGES jeder System- und Organ-Achse". Einordnung LED:2367: Ranges "deckungsgleich mit
   §32-F1-Mess-Modi/R5-Range-Syntax + AxisKind-Faerbung §30".
   **Diese Serialisierung existiert bereits ALS XML:** LED:2783 (§52-B14): "beide PODs (`AxisRangeEntry`+
   `ExperimentSubtreePayload` ...), **R5-XML-Serialisierung + Byte-Roundtrip-Gate**, mixed-radix-Delta-Logik"
   (ce d7d35c36). Das XML-serialisierte Teilbaum-Payload IST die im Plan angelegte XML-foermige Anweisung
   des Planers an die CEB. IST-Stand: per S5-P4-Ruling DEPRECATED/inert, "Band-C DEFERRED (Task #19)"
   im Code markiert (Audit synthese.md Glied 4; ist-ceb.md:100-104) — bewusster Stand, kein stiller Verlust.

c) **Steuer-Ketten-Topologie (§40.b, LED:2403, verbatim):** "Der Experiment-Planer steuert die Bau-Jobs von
   CEBs und die CEBs steuern Bau-Jobs von Tier-Binaries" — zweistufig, keine Stufe ueberspringt die andere;
   Tier-Job-Emission = CEB-Hoheit. Architektur-Klarstellung §56/D4 (LED:3077): "der Planer emittiert CEB,
   das CEB emittiert ALLE Tier-Binaries; jede Schicht verifiziert/steuert NUR die naechste, strikt durch
   die VERTRAEGE getrennt (DAS WAR SCHON IMMER SO)."

d) **Vertragsform-Rahmen:** R1 (§60-R1, LED:3241/Audit 4.4): der Planer<->CEB-Vertrag ist derzeit BEWUSST
   Textemission (kein .so-ABI); .so-Schnitt = Post-v3-Pruefstrang #35. Die #54-XML-Anweisung ist davon
   getrennt: sie betrifft den INHALT der Instrumentierung (XML statt Env/Shell-Text), nicht die ABI-Frage.

## 3. Profil-Pin / IST-Stand (Kette-Audit 05.08. — NICHT neu erheben)

- ist-planer.md:65: "IST = der Planer instrumentiert die CEB ueber den EMITTIERTEN Job-Text (**Profil-Pin
  COMDARE_GOLDEN_N_PROFILE** auf das aktive Profil, director :764/:797-799; Range-Fenster, ccache,
  Storage-Aktivierung :810; Combo-Selektor :816-822). Status-Rueckfluss = `[CEB-TESTAT]`-Zeilen (:781) +
  `[progress]`-Zeilen im CI-Log — Konsument ist der CI-Log-Aggregator/Mensch, NICHT ein laufender
  Planer-Prozess. Ein Status-PIPE-EINGANG am Planer EXISTIERT NICHT."
- ist-ceb.md:105-130: Live-Eingaenge der CEB = argv (Config-Dir + Ziel-Dir), COMDARE_THESIS_PROFILE=
  "$COMDARE_GOLDEN_N_PROFILE" (CEB liest die Anwender-XML SELBST erneut), COMDARE_GN_OPT/_SIMD
  (System-Einzelwerte), COMDARE_GOLDEN_N_RANGE="start:count" (lineares Index-Fenster, 4096er-Scheiben),
  COMDARE_MEASUREMENT_COMBO, Modus-Schalter (PROVISION_ONLY/PRUEF_ONLY/BUILD_TYPE/LANE/HEARTBEAT ...).
  "Die 'Instrumentierung der CEB' (#54) geschieht per **Env-Variablen im emittierten Shell-Text**, nicht
  per XML-Anweisung; der 'aufgeschluesselte untere Teilbaum' reist als (Einzelwert-Perm x lineares
  Index-Fenster), das getestete Achsen-Range-POD liegt inert daneben."
- synthese.md Abweichung 2: "#54-Instrumentierung per Env/Job-Text statt 'per XML-ANWEISUNG' — ...
  Semantisch nah (die Anweisungen SIND aus der XML abgeleitet und pinnen die XML), Wortlaut nicht erfuellt."
  => Regressions-Register R-G5b (LED:4025): "#54-Form (Env statt XML-Anweisung)".

## 4. Kopplung an §38-Rueck-Kanal (Status-Pipe-Haelfte von #54)

- §38.2 (LED:2364/2368): Rueck-Kanal = sparses FORTSCHRITTS-/Cursor-Protokoll, nur Achsen-Konfigurations-
  DELTAS je naechster Permutation (mixed-radix), **KEIN Mess-Daten-Rueckfluss** (Messwerte schreibt die CEB
  selbst ans Ziel). §38.b (LED:2376): "der §38-Fortschritts-Rueck-Kanal liefert dem Planer genau das
  Fertig-Signal, mit dem er die naechste CEB erst nach Abschluss der vorigen startet (Sequenzierung ueber
  den Rueck-Kanal — ohne ihn keine Allein-Lauf-Garantie)." Die #54-Status-Pipe ("CEB PIPED die Shell-/
  Status-Ausgaben an den PLANER") ist die betriebliche Traeger-Schicht genau dieses Kanals.
- IST: Cursor sparse+messdatenfrei KONFORM, aber "REINER BEOBACHTER" — progress.cursor hat KEINEN
  Rueck-Leser, kein residenter Planer-Prozess (synthese.md Abweichung 3; Regression R-G4/5, LED:4025).
- **OWNER-ENTSCHEID 05.08. (LED:4031-4032, F7 verbatim):** "Ja klar, er ist eine eigene Binary und die CEB
  laeuft eigenstaendig, wie soll sonst der Planer dem User feedback ueber die zurueckgeschriebenen Messwerte
  und durch CEB kompilierten Tier-Binaries geben?" => Planer-Rueck-Leser = JA (bindend); zusammen mit
  F1 = HARTES GO Planer-Binary-Split VOR Abgabe 08.08. ("sonst werden die Binaries aller Stufen nicht
  korrekt gebaut").

## 5. Kopplung an R2-Driver-Split / #35

- §60-R2 (LED:3242): measurement_driver ist auf Planer und CEB VERTEILT; "die Mess-Achsen des Planers
  steuern die AUSSTATTUNG der CEB, und die CEB enthaelt genau genommen den eigentlichen measurement_driver
  zu den Festlegungen des Planers."
- PV-2 (LED:3252): "Driver-Split = ANALYSE-BEANTWORTET (R2-Verdikt: Haupt/Unter-DELEGATION zweier Rollen,
  keine Vererbung; Konsolidierung NICHT geboten — konstruktiver Schritt IST der .so-Schnitt) -> kein
  eigener Bau-Task, feeds #35."
- Bedeutung fuer #54: die Instrumentierung setzt getrennte ROLLEN voraus (Planer ruft die emittete CEB auf
  und steuert sie) — deshalb "R2-Driver-Split [#35-Naehe]" in LED:3315 und deshalb ist der F1-Split die
  Vorbedingung der sauberen #54-Form (Audit: R-G1 "KOPF; koppelt R2-Modul-Schnitt", LED:4025).

## 6. Ehrliches Fazit: DER Plan-Weg (Synthese, chronologisch konsolidiert)

Der im Korpus niedergelegte #54-Plan-Weg ist: **(1)** Planer (eigene Binary, F1-GO) interpretiert die
autoritative Anwender-XML (Steuerbefehle/R5-Range-Syntax, §30.3) in den Experiment-B+-Baum; **(2)** er
emittiert/kompiliert die CEB (Steuer-Kette §40.b) und instrumentiert sie mit einer XML-FOERMIGEN ANWEISUNG —
plan-naechster, bereits gebauter Traeger: die **R5-XML-Serialisierung des §38-Teilbaum-Payloads**
(ExperimentSubtreePayload/AxisRangeEntry: Ranges je System-/Organ-Achse), heute Band-C-#19-deferred/inert,
waehrend interimistisch Profil-Pin + Env-Schalter im emittierten Job-Text dieselbe Semantik tragen
(R-G5b = benannte Wortlaut-Regression); **(3)** die CEB baut CEB-intern 4096er-Batches, prueft am
Pruef-Dock (Pruefstand-Doktrin F5) und **(4)** piped Status zurueck ueber den §38-Rueck-Kanal
(sparse Deltas, kein Messdaten-Rueckfluss), den der Planer als Rueck-Leser konsumiert (F7) und zur
§38.b-Sequenzierung + User-Feedback nutzt. Keine Stelle des Korpus spezifiziert eine DRITTE, neue
XML-Datei-Gattung; die "XML-Anweisung" ist die XML-serialisierte Teilbaum-/Range-Anweisung aus der
autoritativen XML — konsistent mit Task #54/§24.E (XML/B+-Baum = einzige Steuerquelle, kein Bypass).

## 7. Wirklich OFFEN (nach ehrlicher Trennung)

1. **Exakte Materialisierungs-Entscheidung:** Ob die #54-XML-Anweisung als (a) Reaktivierung der
   deprecateden R5-XML-Payload-Serialisierung (§38/#19-Deferral aufheben), (b) eigene neue Anweisungs-Datei
   oder (c) XML-Datei zusaetzlich zum Profil-Pin materialisiert wird — Owner-Rueckfrage 6 ("#54-Wortlaut",
   LED:4026) erhielt am 05.08. KEINE direkte Sachantwort, sondern den Methoden-KERN F6 ("Wir waehlen immer
   den saubersten Weg nach Plan, NIE RATEN", LED:4031) + Verweis auf den Korpus. Der Korpus enthaelt keinen
   Paragraphen, der eine dedizierte Anweisungs-Datei (Name/Schema/Ablageort) festlegt.
2. **IPC-Mechanik der Status-Pipe:** F7 entscheidet Rueck-Leser=JA, aber der TRAEGER (echte Pipe/IPC vs.
   progress.cursor-Datei vs. CI-Log-Parsing) ist nirgends festgeschrieben (Rueckfrage "§38.b-Fertig-
   Signal-Traeger", LED:4026, offen).
3. **Verhaeltnis Interim-Env zu Endform:** ob die Env-Injektion (COMDARE_GOLDEN_N_PROFILE etc.) nach dem
   #54-Ausbau vollstaendig entfaellt oder als Transport unter der XML-Anweisung bestehen bleibt — nicht
   spezifiziert (haengt an 1.).
4. Negativ-Befunde (Vollstaendigkeit): der topdown-Bauplan 20260719 (docs/plaene/20260719-planer-ceb-tier-
   topdown-BAUPLAN.md) enthaelt KEINE #54/Instrumentierungs-Stelle (er datiert VOR der 21.07.-Praezisierung);
   der 982er-Wahrheits-Anker und die Chunk-Delta-Dokumente (D-01..D-17) enthalten KEINE #54-/XML-Anweisungs-
   Treffer — die Spezifikation lebt ausschliesslich in §62-B/§63 + §30/§38/§40.b + Audit 05.08.
