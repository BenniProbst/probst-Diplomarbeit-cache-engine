# SYNTHESE — Owner-Fragen F2/F3/F4, Bauwellen-SOLL W1-W5, Roadmap vor Abgabe (05.08.2026)

Quellen: die 6 Lens-Berichte in diesem Ordner (f2-r2-modulschnitt.md, f3-r1-so-abi.md,
f4-fork-a-ceb-kompilation.md, f5-pruefstand-tests.md, f6-54-xml-anweisung.md,
f7-rueck-leser-feedback.md) — alle VOLLSTAENDIG gelesen; ledger-hits.txt als Roh-Grep-Beileger.
Methodik: adversarial gegen eigenes Wunschdenken — jede Aussage traegt Fundstelle; wo der Korpus
schweigt, steht OFFEN mit entscheidungsreifer Rueckfrage. Abkuerzungen wie in den Lenses
(LEDGER = super docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md; BAUPLAN =
docs/plaene/20260719-planer-ceb-tier-topdown-BAUPLAN.md; AUDIT = docs/sessions/backups/
20260805-planer-ceb-kette-audit/; AUDIT-20.07. = docs/sessions/2026-07-20-SESSION-DEPRECATED-AUDIT-
kuratierte-wiederverwendung.md).

Owner-Rahmen heute (Ledger mittag-1, verbatim persistiert LEDGER:4030-4032):
F1 = HARTES GO Planer-Binary-Split VOR Abgabe Fr 08.08. ("sonst werden die Binaries aller Stufen
nicht korrekt gebaut") · F5 = Pruefstand-Doktrin (reale Implementierungen, alle Interfaces,
deep-research-Tests nach Compile) · F6 = "Wir waehlen immer den saubersten Weg nach Plan, NIE RATEN"
· F7 = Planer-Rueck-Leser JA ("er ist eine eigene Binary und die CEB laeuft eigenstaendig").
F2/F3/F4 erhielten "Mehr Kontext bitte" — genau den liefert Teil 1.

---

## TEIL 1 — F2/F3/F4: Korpus-Antworten mit Zitat-Kern

### F2 (R2 Driver-Split: zwei Module vs. Unter-Klassen) — BEANTWORTET, kein Rest fuer den Owner

**ANTWORT: ZWEI MODULE. Keine Vererbung, keine Konsolidierung zu einer Klassenhierarchie —
geboten ist die physische Trennung an der Rollen-Naht des Directors.**

Zitat-Kern (LEDGER:3252, PV-2, seit 20.07. Status ANALYSE-BEANTWORTET):
> "Haupt/Unter-DELEGATION zweier Rollen, keine Vererbung; Konsolidierung NICHT geboten —
> konstruktiver Schritt IST der .so-Schnitt"

Langform AUDIT-20.07.:35/:85: die User-Hypothese war in der Verantwortungs-Haelfte RICHTIG
(Mess-Achsen des Planers bestimmen CEB-TYP/Ausstattung; der eigentliche Mess-Vollzug liegt
vollstaendig in der CEB: run_lazy_static_then_dynamic, Zwei-Phasen-Loop, Observer-Pull, CSV),
im Klassenmodell FALSCH ("es gibt keine Vererbung zwischen Planer und CEB; Vererbung existiert
nur planer-intern: IPlanBuilder-Familie, GoF Director+Builder").

Verantwortungs-Kartierung (LEDGER:2251/2258/2403; AUDIT-20.07. Anhang B:81-85):
- Planer = Mess-Achsen-Stufe, rein lesend/enumerierend/emittierend, KEIN Bau, KEINE Messung;
  "Der Planer bestimmt das Messsystem und kompiliert HART ein effizientes CEB" (§30.6:2259).
- CEB = "NUR Kompilation + System + Scheduling" (§30-V7.2:2251) + der eigentliche
  measurement_driver + Tier-Bau + Selbst-Rueckschrieb (EIN CSV je Zelle, §42.b).
- "Der Experiment-Planer steuert die Bau-Jobs von CEBs und die CEBs steuern Bau-Jobs von
  Tier-Binaries" (§40.b:2403) — Tier-Job-Emission ist CEB-Hoheit, keine Stufe ueberspringt.

Vollzugs-Spezifikation des Schnitts (AUDIT synthese.md:113; ist-planer.md:22; AUDIT-20.07.:72):
"physischer Split (eigenes add_executable, Planer-Subkommandos wandern, CEB-Rolle bleibt im
Treiber)"; die Naht ist CLI-sichtbar: `plan ci|cmake` = Planer-Rolle (planer_block-Gate),
`tier ci|cmake` = CEB-Rolle (kein planer_block). Repo-Zuordnung: CE-Welt traegt die Arbeit
("Eigentlich erhaelt die Cache Engine die XML und uebernimmt die gesamte Arbeit", §42:2421;
super-CI NUR Delegation + Ergebnis-Holen, :2426); BAUPLAN Phase 1 nennt das Target woertlich:
"ein comdare_experiment_planner-App-Target schaffen" nach catalog_codegen-Blaupause (BAUPLAN:32/40)
— per F6 ("sauberster Weg nach Plan") ist damit auch der Zielort entschieden, KEINE Owner-Frage.
CI-Cache haelt NUR den statischen Planer (§31-A4:2273); Planer anspruchslos/universal mit
Warnungs-Semantik (§62-A:3306); kein dritter Parallel-Engine-Bau — bestehenden Code UMZIEHEN,
keinen zweiten Walk anlegen (soll.md 1.7 / BAUPLAN-Phase-0-Doktrin).

Der Owner-KERN 05.08. ("Planer ZWINGEND eigene Binary", F1 HART vor Abgabe) ist die
Terminierung dieses seit 20.07. feststehenden Verdikts — kein Widerspruch in der Kette,
die Supersessionen verschaerfen monoton Richtung Zwei-Modul-Schnitt (Lens f2, Chronologie D).

### F3 (R1 .so-ABI-Vertrag Planer<->CEB) — BEANTWORTET durch geschlossene Entscheidungskette

**ANTWORT: Die Dock-.so-Doktrin wurde NIE verworfen, nur bewusst sequenziert. Fuer die
Abgabe-Kette gilt TEXTEMISSION (im Code als bewusster Entscheid markiert, kein stiller
Doktrin-Verlust); der .so-Schnitt ist als Task #35 fertig geplant, ge-GOt und als erste
groessere NACH-Abgabe-Position sequenziert. Der F1-Planer-Split braucht kein .so.**

Die Kette (Lens f3, Chronologie 1-10):
1. 17.07. Dock-Doktrin dekretiert ("jede Ebene = C++23-ABI-stabile .so + Vertrag",
   feedback_recursive_dock_planer_ceb_tier_abi_stable_so.md:10-19; LEDGER:1985).
2. 19.07. Fork A verschaerft zu ZIEL-Design; Fork C: "vor Deadline evtl. nur die Vertragsform"
   (BAUPLAN:183-186/210/244).
3. 20.07. S5-P4-Ruling deprecatet NUR das in-process POD als Live-Wire, NICHT die .so-Idee
   (experiment_dock_payload.hpp:57-65: die LIVE-Kette reicht Ranges "ueber den EMITTIERTEN
   CMake-/YAML-TEXT"; POD bleibt never-delete als Referenz-Serialisierung fuer #19).
4. 20.07. dep-Audit beantwortet den §60-R1-Pruef-Auftrag: "R1 (.so-ABI): DEFERRED, definitiv
   nicht verworfen" — Steuerung LOHNT (dlopen-Callback fuer mid-run Replan), Daten LOHNT NICHT
   ("131k Zeilen CSV kosten Sekunden gegen Tage Messung", CSV bleibt Persistenz-Pflicht);
   C++23-modules liefern KEINE ABI-Stabilitaet — Vertrag = extern-C+POD+Major-Gate nach
   Muster anatomy_module_abi_v1 (AUDIT-20.07.:33/:72).
5. 20.07. Owner-GO verbatim "Ich stimme der Post-v3-Reihenfolge voll zu. GO" (LEDGER:3247):
   #35-.so-Schnitt = Position 2 NACH der R3-CLI-Haertung; NUR Steuerungs-Seite; Vertrag =
   ExperimentSubtreePayload-POD + ProgressSinkFn-Callback, Versions-Gate = W12-Stempel;
   KEIN Daten-Transport-Umbau.
6. 05.08. Kette-Audit: Glied 4 = BEWUSST-DEFERRED, "R1-Textemission ist BEWUSSTER Stand ...
   kein stiller Doktrin-Verlust" (LEDGER:4024; AUDIT synthese.md:43).
7. 05.08. Owner ruled NICHT neu ("Frage 3: Mehr Kontext bitte") und verwies auf den Korpus —
   d.h. der ge-GOte Stand gilt weiter; F1-GO aendert Glied 1/3 (Binary + harte Kompilation),
   nicht Glied 4 (Vertragsform).

Konsequenz fuer JETZT: Der F7-Rueck-Leser laeuft NICHT uebers Dock (Experiment-Dock
eindimensional, "KEIN Rueckkanal hier"; Messwert-Rueckschrieb macht die CEB SELBST ans
XML-Ziel, LEDGER:1724; §38-Cursor = sparse, messdatenfrei) — er liest die zurueckgeschriebenen
Artefakte (progress.cursor/result.csv-Stamps/Bestandslog). .so ist dafuer keine Voraussetzung.

Formaler Rest (Rueckfrage 2 in Teil 4): dem Owner die rekonstruierte Kette mit der
Ja/Nein-Frage vorlegen — "Abgabe-Kette = Textemission, #35-.so bleibt erste Nach-Abgabe-
Position nach R3 — bestaetigt?" Die Korpus-Antwort ist eindeutig; nur die formale
Owner-Bestaetigung mit Kontext fehlt.

### F4 (Fork-A-Haerte: WIE die harte CEB-Kompilation materialisieren) — ZIEL BEANTWORTET, INTERIM-FORM OFFEN

**ANTWORT (Ziel-Form, beantwortet): PLANER-CODEGEN zur Configure-/Pre-Build-Zeit — nicht
-D-only, nicht Env.** Zitat-Kern:
> "Der Planer bestimmt das Messsystem und kompiliert HART ein effizientes CEB" (§30.6, LEDGER:2259)
> "messsystem-HART kompiliert, nicht runtime-konfiguriert" (LEDGER:2263)
> "Configure-/Pre-Build-Zeit-Codegen nach catalog_codegen.cmake-Blaupause — kein
> Runtime-Konfigurieren" (BAUPLAN:243)
> "FORK A VERSCHAERFT ENTSCHIEDEN: die CEB ist ... eine vom Planer GENERIERTE+kompilierte
> Binary je Messsystem" (LEDGER:2264 / BAUPLAN:244)

Praezisierungen aus dem Korpus (Lens f4 A3-A7):
- Je Tooling-Wahl EINE eigene hart kompilierte CEB-Strecke ceb:build:[a,b,c] mit
  kMeasurementAxisVersionLine-Stempel (§47:2497; Kette ceb:build->emit->trigger, :2815).
- Default per §64 GESETZ supersediert den N->N-Fanout: ohne XML-Angabe alle 3 Verfahren
  {wallclock,macro,micro} GEMEINSAM in EINER CEB per METAPROGRAMMIERUNG; Teilmengen/N>1 nur
  als XML-Option (LEDGER:3381/3383/3387); der LIVE-Default [all] ist gehalten und ist damit
  sogar SOLL-Default — die EINE vereinte Vollmengen-CEB ist KEIN Interim (LEDGER:3077/3388).
- Compile/Runtime-Grenze: Mess-HAUPT-Achse FEST EINKOMPILIERT; Env/Call-Kanaele kanonisch NUR
  fuer Mess-UNTER-Achsen/Planer-Variablen; Modi = CALL-Parameter der XML, nie Binary-Merkmal
  (§57-S1:3095; §62-C:3339; §61:3291).
- Stempel-Pflicht: CEB = ARRAY je einkompilierter Mess-Achse ohne Gesamt-Version (§58-V:3116);
  K7b-VORZUG=PFLICHT: Array-Form + G1 immer-expliziter Compile-Stempel auch Planer/CEB +
  SHA512-Fingerprint (LEDGER:3395); +bt= = cmake-Compile-TYP je Binary (§61:3285).

IST-VERSTOSS (Audit 05.08., verifiziert, nicht neu erhoben): ceb:build baut stets den
GENERISCHEN Treiber; die [a,b,c]-Differenzierung kommt zur LAUFZEIT per Env
COMDARE_MEASUREMENT_COMBO — "exakt die von §30.6 ausgeschlossene Runtime-Konfiguration",
durch KEINEN markierten Deferred-Posten gedeckt (AUDIT synthese:36-38/78; LEDGER:4024 Glied 3
= KERNSATZ-VERSTOSS). F1-Begruendung ("sonst werden die Binaries aller Stufen nicht korrekt
gebaut") zielt genau hierauf — die Haerte-Materialisierung gehoert zur Vor-Abgabe-Welle.

**OFFEN (die eigentliche F4-Rueckfrage, praezisiert):** Der INTERIM-Mechanismus bis zur echten
Codegen-Generierung ist durch KEINEN Owner-Entscheid gedeckt (Owner-Rueckfrage #4 registriert,
LEDGER:4026). Korpus-Leitplanken: (a) Interims gelten NUR explizit ausgesprochen (§62-A/§62-G-
Muster, LEDGER:3306/3360/3316); (b) Runtime-Konfiguration der HAUPT-Wahl ist zweifach
ausgeschlossen; (c) die [all]-Vollmengen-CEB ist zulaessiger Soll-Default. Eine -D-Compile-
Define-Minimalform im emittierten ceb:build-Job waere kanon-naeher als Env (Wahl liegt im
Kompilat + Stempel greift), ist aber nirgends als zulaessig ausgesprochen. => Entscheidungsreife
Frage in Teil 4, Rueckfrage 1, mit Empfehlung.

---

## TEIL 2 — SOLL-SPEZIFIKATION der Vor-Abgabe-Bauwellen (nur Korpus, nichts erfunden)

### W1 — Planer-Binary-Split (+R2-Schnitt) [F1 HART, KOPF aller Wellen]

- UMFANG: Eigenes App-Target `comdare_experiment_planner` in der CE-Welt nach
  catalog_codegen-Blaupause (BAUPLAN:32/40); Code-UMZUG (kein Duplikat, soll.md 1.7) an der
  Rollen-Naht des Directors: ES WANDERN Director + Stufe-1-Builder (PlanText/PlanSize/
  CMakeGraph/CiYaml + plan_legend), RegistryTrio-Resolve + validate-Gate, measurement_combos_of,
  planner_version.hpp (X.Y.Z+ISA/OS, KEINE Achsen-Arrays, §43.b:3444/§64:3392),
  Bestandslog-planer_block (§62-B:3323). ES BLEIBT beim Treiber/der CEB: TierCiYaml/
  TierCmakeGraph (`tier ci|cmake`, §40.b Tier-Emission = CEB-Hoheit), run_lazy_static_then_
  dynamic, SlicePlanner 4096, ram_spool 256MB, Pruef-Dock-Gate, BuildOrchestrator,
  EIN-CSV-je-Zelle-Rueckschrieb, Freigabe-Auswertung (LEDGER:2358). CLI der neuen Binary:
  validate | plan dump/ci/cmake | cache-key | fingerprint | run | version | help
  (+ kuenftig status, s. W5); Exit-Grammatik 0/1/2/5/6/7 bleibt.
- ORTE: ce libs/cache_engine/profile_facade/planner/ (Director, Builder), profile_run_facade.cpp,
  super Code/02_messung_driver main.cpp:293-430 (Rollen-Naht), ce apps/ (neues Target),
  CI-YAML-Emission.
- GATES: Planer universal/anspruchslos mit Warnungs-Semantik (§62-A:3306); CI-Cache haelt NUR
  den statischen Planer (§31-A4:2273); super bleibt Delegation+Holen (§42:2421/2426);
  R-G2-Registry-Kanon beim Umzug vereinheitlichen (validate=2er vs plan=3er); Pipeline hart
  gruen; golden-neutral.
- ABHAENGIGKEITEN: Vorbedingung fuer W4 (saubere #54-Form setzt getrennte Rollen voraus,
  R-G1 KOPF, LEDGER:4025) und W5 (Rueck-Leser lebt in der Planer-Binary). Braucht KEIN .so
  (R1 getrennt, Lens f3). Schnitt so fuehren, dass #35 spaeter billiger wird (Rollen-Naht =
  exakte kuenftige .so-Schnittstelle, AUDIT-20.07.:72) — Bau-Detail, kein Gate.

### W2 — Harte CEB-Kompilation (Fork-A-Materialisierung) [F1-Begruendungs-Kern]

- UMFANG: Die Mess-HAUPT-Wahl aus der Laufzeit in den Compile heben. Minimalform vor Abgabe
  (nach Owner-Antwort Rueckfrage 1): Combo-Haerte im vom Planer emittierten ceb:build-Job
  (Default-Empfehlung: -D-Compile-Define + Stempel-Wirkung) — Ziel-Form bleibt Configure-/
  Pre-Build-Codegen (BAUPLAN:243). Der [all]-Vollmengen-Default ist bereits SOLL-konform
  (§64) — Verstoss ist NUR die Runtime-Differenzierung von Teilmengen in dieselbe Binary.
  Stempel: CEB-Mess-ARRAY (§58-V) + G1-Compile-Stempel + SHA512-Fingerprint (K7b PFLICHT,
  LEDGER:3395) + +bt=.
- ORTE: experiment_plan_director.hpp (:769-770 generischer Build-Befehl; :816-822
  Combo-Selektor), CiYamlBuilder/CMakeGraphBuilder-Emission, CEB-CMake, Stempel-Traeger
  (measurement_stamp_line/kMeasurementAxisVersionLine).
- GATES: "nicht runtime-konfiguriert" (§30.6/§62-C) fuer die HAUPT-Wahl; N>1-Scharfschaltung
  bleibt gated hinter D1->D2->D4 + golden-Topologie-GO (§56-T2:3077); Cache-Key-Einfaltung
  der Combo (W-11) ist offener Klaerungsposten — beim Bau NICHT stillschweigend entscheiden.
- ABHAENGIGKEITEN: in derselben Welle wie W1 (der NEUE Planer emittiert die Jobs — die Haerte
  gehoert in seine Emission, nicht doppelt in den Alt-Pfad); Form haengt an Owner-Rueckfrage 1.

### W3 — Pruefstand-Ausbau nach F5-Doktrin [Umfang = Owner-Schnitt noetig]

- UMFANG (Voll-Doktrin, LEDGER:4031/4032): (a) Post-Compile-Interface-Testate am Dock fuer
  ALLE getragenen Interfaces der Tier-Binary (abi_adapter.hpp:229-247: IObservableTier,
  IMeasurableWorkload V1-V3 inkl. erforschter Invariante "Summe(seg)==seg_run_total EXAKT"
  LEDGER:855, IRollbackableTier memento/rollback-Roundtrip, IMigratableTier, IResource-
  ControllableTier, AllocatorProxy-Vertiefung) gegen die REALE metaprogrammierte
  SearchAlgorithmBase; (b) per-Binary-Post-Compile-Beleg ALLER Achsen-Algorithmen (Muster:
  S5-Familien-Gates s5_family_alloc_conformance.hpp; Schnitt-Regel 04.08.: NUR ueber
  Achsen-Interfaces); (c) Deep-Research-Test-Katalog je Achse/Interface (Eigenschaften aus
  Papern/Design-Docs erheben, LEDGER:241, F6 NIE RATEN) — existiert nirgends; (d) GTest-
  Werkzeug-Nachzug am Dock (§62-B "GOOGLE-TESTS" nirgends supersediert; grep gtest in
  pruef_dock/ = 0); (e) gemischte Mess-Tauglichkeits-Abnahme §64 (wallclock+macro/micro
  "in einem Rutsch", LEDGER:3400); (f) Drive-Voll-API V5-§8 = deklariertes Zukunfts-SOLL.
- ORTE: ce builder/pruef_dock/ (conformance_gate TABU-additiv LEDGER:1265, genus_conformance_
  gate, pruef_only, 5 Docks, Sequencer, Registry, Fehlerklassen), tests/ als Substanz-Quelle
  (test_v41_axis_*-Serie, S5-Familien-Gates), abi_adapter.hpp.
- GATES: Reihenfolge import -> GATE -> messen bindend (measure()-Vertrag pruef_dock.hpp:74-79,
  §75-aufraeum-TABU:3598); §68b Test-Skip-Gesetz + Test-Log=Lagerhaltung (:3548); Oracle-
  Bestand nur ERWEITERN, nie aendern.
- ABHAENGIGKEITEN: Dock-seitig unabhaengig von W1/W2 baubar; die Tooling-Konsistenz
  CEB<->Tier (statischer Draht LEDGER:3400) koppelt an die W2-Stempel. VOR ABGABE IST DER
  VOLLUMFANG NICHT BAUBAR (ehrliche Einschaetzung Teil 3) — Kern-Schnitt-Vorschlag:
  Mess-Interface-Testate (a) am Dock nach dem S5-Muster; (b)-(f) strukturierte Nach-Abgabe-
  Strecke. F5 selbst traegt KEINE Vor-Abgabe-Terminierung — nur F1 ist terminiert.

### W4 — #54-XML-Anweisung [Endform NACH Abgabe; vor Abgabe keine Erzwingung]

- UMFANG: Planer instrumentiert die CEB "per XML-ANWEISUNG" statt Env/Job-Text (§62-B:3315
  verbatim); Status-Pipe-Haelfte: CEB piped Shell-/Status-Ausgaben an den Planer. Plan-
  naechster, bereits gebauter Traeger: die R5-XML-Serialisierung des §38-Teilbaum-Payloads
  (ExperimentSubtreePayload/AxisRangeEntry + Byte-Roundtrip-Gate, LEDGER:2783), heute
  Band-C-#19-deferred/inert. Es gibt KEINE dritte, neue XML-Datei-Gattung im Korpus; die
  Anweisung ist die XML-serialisierte Teilbaum-/Range-Anweisung aus der autoritativen
  Anwender-XML (§30.3-Steuerbefehle; Task #54/§24.E-Invariante: XML/B+-Baum einzige
  Steuerquelle, kein Bypass).
- GATES: §63-GO deckt Paket #54 (LEDGER:3375); ABER §63-Nachtrag sequenziert: "Nachdem die
  CI steht, wird die emit-Vertrags-Kette KORREKT AUFGEBAUT (koppelt an R1/#35-.so-Schnitt +
  #36-Resolver)" (LEDGER:3372) — die Endform haengt an #35, das NACH der Abgabe liegt.
- ABHAENGIGKEITEN: setzt W1 voraus (getrennte Rollen); Materialisierungs-Entscheid (a/b/c,
  Rueckfrage 4) beim Owner. Vor Abgabe zulaessig: nichts erzwingen — R-G5b bleibt als
  BENANNTE Wortlaut-Regression stehen (der Audit hat sie registriert; die Env-Anweisungen
  SIND XML-abgeleitet und pinnen die XML — semantisch nah, Wortlaut offen).

### W5 — Planer-Rueck-Leser / User-Feedback [F7 JA; Kern in die W1-Welle]

- UMFANG: Status-Aggregator in der NEUEN Planer-Binary (Name offen — heutige Grammatik hat
  kein status-Subkommando; "--status" ist Spezifikation, nicht Benennung): liest die
  fragmentierten Zustands-Artefakte ZURUECK — progress.cursor, .version-Sidecars,
  per-Binary-result.csv-Stamps, minio-Teil-Marker, Bestandslog (Reservierungen/ETA/avg_size/
  done, doc_revision monoton), complete-heuristik.log, Testat-Zeilen (deprecated-Audit:41/
  91-96; LEDGER:3318ff). Parser-Gesetz steht: Marker-Familie v2, Aggregator-Schluessel =
  TUPEL (zelle,fenster), NIE Zeilen-Reihenfolge; Renderer-Single-Source slice_marker.hpp
  (LEDGER:3652). Ausbau danach: %/ETA (braucht Fenster-Gesamtgroesse in ProgressDelta —
  geplante, ungebaute Draht-Erweiterung) + JSON-Marker/Exit-Codes (freigegebene R3-Reihen-
  folge LEDGER:3247). CLI-ON-DEMAND — ein residenter Polling-Daemon ist NIRGENDS
  spezifiziert; Live-Callback statt Datei-Polling = R1, bewusst nach Abgabe.
- GATES: Rueck-Kanal traegt NIE Messdaten (LEDGER:2368; CEB schreibt SELBST, :1724);
  Sequenzierung bleibt vorerst resource_group ceb-measure-<host> (§61 PRO Maschine, :3274) —
  "CEB laeuft eigenstaendig" (F7) legt den Verbleib nahe, ist aber Auslegung (Rueckfrage 6).
- ABHAENGIGKEITEN: lebt in W1; schliesst Regression R-G4/5 (progress.cursor konsumentenlos)
  und §52-B14-Rest (1); planer_block-Reaper wird mit dem realen Zweit-Planer-Konsumenten
  (profile_run_facade.hpp:248) akut — als Folge-Posten einplanen. Vor-Abgabe-KERN: Zell-/
  Fenster-Bilanz aus cursor+CSV-Stamps+Bestandslog (die E-04-Ur-Anforderung "wie viele
  Rekombinationen noch offen"); %/ETA/JSON nur bei Zeitreserve (Rueckfrage 7 = Schnitt).

---

## TEIL 3 — ROADMAP gegen die Frist (ehrlich; Abgabe Fr 08.08., Trigger-Ziel Do 07.08., heute Di 05.08. mittags)

Verfuegbares Budget: ~2,5 Arbeitstage. Parallel laeuft Phase B (abi_adapter-Treiber,
wf_487f8f24); danach war ANKER -> Phasen 3-5 geplant; Messung Phase 6 = USER-GO-STOPP.

1. SOFORT (heute, parallel zu Phase B, blockiert nichts): Rueckfragen-Paket aus Teil 4 an den
   Owner — die Antworten auf Rueckfrage 1 (Interim-Form W2), 3 (W3-Schnitt) und 7 (R3-Rest-
   Schnitt W5) bestimmen den Wellen-Umfang; alle mit Default-Empfehlung, damit ein kurzes
   GO/anders genuegt.
2. Phase B landen lassen (Working-Tree-Freeze nach Paketmeldung respektieren), dann ANKER
   wie geplant.
3. W1 direkt nach dem ANKER (Di nachmittag - Mi): comdare_experiment_planner-Target, Umzug an
   der Rollen-Naht, R-G2-Vereinheitlichung, Pipeline hart gruen. W1 ist der KOPF — W4/W5
   haengen daran, und F1 ist der einzige explizit vor-Abgabe-terminierte Owner-Punkt.
4. W2-Minimalhaerte IN der W1-Welle (Mi): Combo-Haerte in der Emission des neuen Planers
   (Form nach Owner-Antwort; Empfehlungs-Default -D + Stempel), [all]-Default unangetastet,
   Cache-Key-Frage NICHT stillschweigend mitentscheiden.
5. W5-Kern (Mi abend - Do vormittag): status-Kommando im neuen Binary — Zell-/Fenster-Bilanz
   per (zelle,fenster)-Tupel aus cursor/CSV-Stamps/Bestandslog; %/ETA/JSON nur bei Reserve.
6. Phasen 3-5 gemaess bestehendem Plan dazwischen/danach; Trigger Do 07.08. NUR mit gruener
   W1/W2-Emission (der Trigger baut die Binaries — exakt die F1-Begruendung); Phase 6 bleibt
   USER-GO-STOPP.
7. W3-Kern-Schnitt (Do, NUR bei Reserve oder per Owner-Priorisierung gegen Phasen-3-5-Posten):
   Post-Compile-Testate der Mess-Interfaces am Dock nach S5-Muster. NICHT vor Abgabe
   realistisch: Deep-Research-Katalog aller 18 Achsen, per-Binary-Vollbeleg aller
   Achsen-Algorithmen, GTest-Harness-Integration am Dock, Drive-Voll-API, gemischte
   §64-Abnahme — das ist eine strukturierte Nach-Abgabe-Strecke (mehrere Tage bis Wochen).
8. NACH Abgabe (ge-GOte Reihenfolge LEDGER:3247 + §63-Nachtrag): R3-Rest-Haertung ->
   #35-.so-Schnitt (Steuerung) -> W4-#54-Endform (+#19-Resolver/Band-C) -> W3-Vollausbau.

EHRLICHE RISIKO-ANSAGE: W1+W2-Minimal+W5-Kern fuellen das Budget bis Do bereits gut, WENN
Phase B punktlich landet und keine Pipeline-Regression dazwischenkommt. Kollidiert W1 mit
Phasen 3-5 zeitlich, muss der Owner priorisieren — F1 ist hart terminiert, die Phasen-Posten
sind es teils nicht. W3 vor Abgabe ist ohne Owner-Schnitt eine Wunschdenken-Falle: die
F5-Doktrin definiert den UMFANG, terminiert ihn aber nicht auf Freitag.

---

## TEIL 4 — ECHTE RUECKFRAGEN-RESTMENGE (nur was der Korpus nachweislich NICHT beantwortet; dedupliziert ueber alle 6 Lenses)

1. **W2-Interim-Form (F4-Kern; LEDGER:4026):** Bis zur echten Codegen-Generierung je
   Messsystem — ist die Env-Differenzierung COMDARE_MEASUREMENT_COMBO interim geduldet, oder
   muss mindestens ein -D-Compile-Define in den emittierten ceb:build-Job? Kontext: §30.6/
   BAUPLAN:243 schliessen Runtime-Konfiguration aus; Interims gelten im Korpus nur explizit
   ausgesprochen; die [all]-Vollmengen-CEB ist per §64 Soll-Default. EMPFEHLUNG: -D-Minimal-
   form in der W1/W2-Welle (Wahl im Kompilat, Stempel greift), Ziel-Codegen nach Abgabe.
2. **F3-Formalbestaetigung:** Abgabe-Kette faehrt Textemission (S5-P4, im Code markiert);
   #35-.so-Schnitt (NUR Steuerung, POD+ProgressSinkFn, W12-Gate, KEIN Daten-Umbau) bleibt
   erste Nach-Abgabe-Position nach der R3-CLI-Haertung — bestaetigt? (Korpus-Kette eindeutig,
   Owner-Antwort war "Mehr Kontext bitte".)
3. **W3-Schnitt vor Abgabe:** Der F5-Vollumfang (alle Interfaces + alle Achsen-Algorithmen +
   Deep-Research-Katalog + GTest-Nachzug + §64-Misch-Abnahme) ist bis Fr 08.08. nicht baubar.
   Vorschlag: VOR Abgabe die Post-Compile-Testate der Mess-Interfaces am Dock (IObservable/
   IMeasurableWorkload-Invariante/IRollbackable/IMigratable/IRC) nach S5-Familien-Muster;
   Katalog + Achsen-Vollbeleg + Harness als strukturierte Nach-Abgabe-Strecke — GO?
4. **#54-Materialisierung (F6-Rest):** XML-Anweisung als (a) Reaktivierung der R5-XML-Payload-
   Serialisierung (§38/#19-Deferral aufheben — plan-naechster, bereits gebauter Traeger),
   (b) neue dedizierte Anweisungs-Datei, oder (c) XML zusaetzlich zum Profil-Pin? Kein
   Korpus-Paragraph legt Name/Schema/Ablageort fest; Empfehlung (a), Endform nach Abgabe.
5. **W5-Benennung + Lese-Pfad:** Name/Form des Status-Kommandos (status-Subkommando in der
   clig.dev-Grammatik?) · Lese-Kadenz (on-demand vs watch) · autoritativer Messwert-Lese-Pfad
   fuers User-Feedback (measure_out-CSV direkt vs Bestandslog-XML via doc_revision vs
   measurement/<ts>/ git — alle drei existieren). Empfehlung: status-Subkommando, on-demand,
   Bestandslog-XML als autoritative Aggregat-Quelle mit measure_out als Detail-Drilldown.
6. **§38.b-Takt (Audit-Rueckfrage-7-Rest):** Bleibt die resource_group-Sequentialisierung
   (ceb-measure-<host>) dauerhaft der Traeger, oder soll der Planer die CEB-Sequenz kuenftig
   selbst takten? F7 "CEB laeuft eigenstaendig" legt resource_group-Verbleib nahe — Auslegung,
   nicht Wortlaut.
7. **R3-Rest-Schnitt fuer W1/W5:** Welcher R3-Umfang muss VOR Abgabe in die Welle
   (--print-env? %/ETA? JSON-Marker? lokales Stufe-1->2-Kommando?), was darf auf die
   Nach-Abgabe-Haertung? (FAHRPLAN L18 heftete die Reste an Phase 5/6; F1/F7 sind spaeter
   und heben Split+Rueck-Leser-KERN vor die Abgabe — der Rest-Umfang ist ungeschnitten.)
8. **Niedrigere Prioritaet (Nach-Abgabe-Klaerung, nur der Vollstaendigkeit halber):**
   (a) Cache-Key-Einfaltung der Combo (+mtool im MinIO-Key vs .version-Sidecar; W-11) ·
   (b) Generierungs-Granularitaet bei N>1 (eigener CEB-Quelltext je [a,b,c] vs Codegen der
   Konfig-/Stempel-Traeger + harte Rekompilation) — akut erst mit der XML-Teilmengen-Option,
   die hinter D1->D2->D4 + golden-Topologie-GO gated bleibt · (c) GTest-Harness-Integrations-
   Design am Dock (wie GTest im CEB-Batch-Runtime-Kontext je geladener .so laeuft).

KEINE Rueckfragen (adversarial aussortiert, weil der Plan sie beantwortet): Zielort/Name des
Planer-Targets (BAUPLAN Phase 1 nennt comdare_experiment_planner in der CE-Welt woertlich;
F6 macht den Plan zur Antwort) · Fenster-Gesamtgroesse-Wire-Form, E-04-P2/P4-Reste,
planer_block-Reaper (Bau-/Manager-Posten, keine Owner-Entscheide) · "braucht der Split das
.so?" (NEIN, belegt Lens f2/f3).
