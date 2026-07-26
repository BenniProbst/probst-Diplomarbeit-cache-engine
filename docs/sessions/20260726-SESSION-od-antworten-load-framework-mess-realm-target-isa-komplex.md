# SESSION-DOC 26.07.2026 (~18:40) -- OD-1..OD-10-ANTWORTEN + NEUE REGRESSION load_framework=MESS-REALM + target_isa=KOMPLEX-IN-SICH

> ZWECK: Wahrheits-Sicherung der Owner-Antworten auf die gebuendelte OD-Liste (E-21 verbose,
> vorgelegt nach Bauplan-v3/PLAN BAUFAEHIG). Owner-Zitate mit transliterierten Umlauten
> (ASCII-Auflage), Wortlaut sonst unveraendert. AUTORITAET: neueste Owner-Aussage = Gesetz;
> dieses Dokument SUPERSEDIERT in den benannten Punkten Teile von Kanon A-04/A-05,
> Ledger-V7.2-Teilsatz, heutige Ledger-Vermerke (0661a6f3) und Bauplan-v3-D2.5-ZIEL.

===============================================================================
## 1. NEUE REGRESSION (KERN, vorangestellt): load_framework = MESS-ACHSEN-TYP
===============================================================================
Owner verbatim (transliteriert):
> "Hinweis: Das load_framework ist doch eher eine Achse fuer Planer und delegiert die loads
> nach dem Generiern an das CEB interface, welches gesagt bekommt, welche binary Rekombination
> es gegen welche Lasten messen soll. Daher weitere Regression festgestellt: load_framework
> wird rein den Mess-Achsen-Typen als weitere Meta-Meta-Hauptachse zugeordnet. Wir
> verschlanken damit die System-Achsen auf ihre thematisch passenden Funktionen."

BINDENDE FOLGE:
- load_framework ist eine META-META-HAUPT-ACHSE der MESS-ACHSEN (Planer-Stufe), NICHT mehr
  Meta-Meta unter dem System-Hub external_utils. Der Planer GENERIERT die Loads und
  DELEGIERT sie an das CEB-INTERFACE (CEB bekommt gesagt: welche Binary-Rekombination
  gegen welche Lasten gemessen wird).
- Der Bauplan-v3-Teil "load_framework RAUS aus kSystemAxisOrder/kSystemAxisCodeVersions,
  kCount 5->3" (D2.5) BLEIBT unveraendert gueltig; NUR das UMZUGS-ZIEL aendert sich:
  Mess-Realm/Planer-Registry statt external_utils-Hub. external_utils bleibt HUB der
  SYSTEM-Meta-Metas (SIMD/AVX, externe HW, GPU/FPGA/NPU); das Mess-Framework gehoert dort
  NICHT mehr hinein ("Mess-Framework als erster Einbau" am Hub ist SUPERSEDED).
- SUPERSEDED-Stellen (additiv nachzuziehen, Kartierung via ultracode-Workflow):
  Kanon A-04/A-05-Teilsatz (Anker ab4642c1), Ledger V7.2-Teilsatz LED:84, heutige Vermerke
  aus 0661a6f3 (L-08/L-10/§68a-Teilsaetze "erste Meta-Meta unter dem Hub"), Bauplan-v3
  D2.5-Ziel + A3->C-1-Abhaengigkeits-Begruendung, system_axis_registry.xml:114-Einhaengung.

===============================================================================
## 2. OD-ANTWORTEN (alle 10 ENTSCHIEDEN; Owner-Wortlaut + operative Folge)
===============================================================================
META-DIREKTIVE des Owners zu den Bauplan-Gates: "Bezueglich aller owner Entscheide sind
diese bereits getroffen und sollten mit Explore Agenten ausfindig gemacht und gezielt
gegengelesen werden." -> O-1r/O-2/O-3(CSV)/O-4/O-5/O-6(CI)/O-9 werden NICHT neu gefragt,
sondern per Explore-Straengen aus den Quellen (jsonl/verlauf/Ledger/Docs) belegt.

- **OD-1 RATIFIZIERT (golden-NEUTRAL)** mit Praezisierung: "die Binary ID und Stempel
  bleiben weiterhin wie geplant, nur dass sich die Achsen je Achsen-Typ aendern, das
  Prinzip bleibt dasselbe wie geplant. Tier-Binaries fuehren daher auch weiterhin
  System-Achsen, Organ-Achsen, je Achsen-Algorithmus Versionen und final einen compile
  time SHA512 fingerprint wie beschrieben." PLUS telemetry-KERN: "telemetry ist weiterhin
  eine runtime Unter-Achse im Mess-Tooling und eine Haupt-System-Achse weil etwa pmc zum
  Messen eingebaut sein muss und andere IObservable Tier ebenfalls ZWEIGETEILT sind."
  -> Dual-Natur-Register erhaelt telemetry als weiteren Fall (Mess-RT-Unter im Tooling +
  System-CT-Haupt); IObservableTier-Faelle generell zweigeteilt. "Die neue Lesart ist
  ratifiziert und erfordert umfassendes refactoring nach den Plaenen im Auftrag, ledger
  und der neuen Ordnung der Achsen."
- **OD-2 ENTSCHIEDEN (target_isa = KOMPLEX-ACHSE IN SICH):** "Die target_isa ist auch eine
  Komplex-Achse in sich, die rekursiv durch die Komplex-Achse target_isa x operating_system
  x ... gewrappt wird. Die target_isa bildet also eine feste Rekombination aus RAM-Frequenz
  und CAS und CPU-Fabrikation als 'neue statische Komplex-Haupt-System-Achse', die allein
  als Komplex-Wrapper die zugehoerigen target_isa Unter-System-Achsen erhaelt, die zuvor
  vereinbart waren. Also nichts von deinen Vorschlaegen." -> RAM-Frequenz+CAS+CPU-Fabrikation
  = FESTE GLIEDER der target_isa-Komplex-Identitaet (statisch); die vereinbarten Unter-Achsen
  (scheduling, NUMA/numa_node, page) haengen am target_isa-Komplex-Wrapper.
- **OD-3 ENTSCHIEDEN (Infra-Delegations-Regel):** "Fable 5 unterbindet infra Themen
  generell, das blockiert die API, verwende dafuer immer einen Agenten Opus 5 xhigh,
  recherchiere gerne die limits von Fable 5." -> Infra-Arbeit IMMER an Opus-5-xhigh-Agenten
  delegieren; Fable-5-xhigh-Direktive gilt fuer alles andere unveraendert.
- **OD-4 VOLLES GO** (C-3b-Kanal-Merge-Wortlaut exakt bestaetigt). Owner-Rueckfrage "Was ist
  mit C-3a passiert?" -> Antwort in Abschnitt 3.
- **OD-5 VOLLES GO** (Dual-Natur-Lesart ratifiziert): "Konfiguration auf der vorangegangenen
  Ebene in einer Unter-Achse wie auf Planer fuer Haupt-Achse CEB oder Haupt-Achsen-
  Konfiguration-Experiment-Baum (im Prinzip Unter-Achsen Freigabe fuer naechsthoehere
  Stufe) im CEB fuer Haupt-Achsen Annahme-compile-time der Tier-Binary Typen."
- **OD-6 VOLLES GO** fuer Lane A/C: byte-neutrale Pakete duerfen bauen (Lane C C-1/C-2
  (additiv)/C-5/C-3b, P5 A7'+A9a, P6); Byte-Fenster weiter hinter O-8-GO.
- **OD-7 ENTSCHIEDEN (NEUE Runner-Zahlen, ersetzt Ist 3/2):** "24 Worker fuer prod1 und
  alle Threads fuer prod2 bei Tier-Binary build oder Messung bei concurrency 1, sonst
  prod1 concurrency 2 mit je 12 Threads und prod2 concurrency 2 mit je 12 Threads."
  -> heavy-Modus: concurrency=1, prod1=24 Worker, prod2=alle Threads; normal-Modus:
  BEIDE concurrency=2 x 12 Threads. Umsetzung = Infra-Thema -> Opus-5-xhigh-Handover.
- **OD-8 VOLLES GO** (Manager-Eigenentscheide SessKons ratifiziert: Transkript-Schema
  eigene Gattung, Backup-Baeume unangetastet, neue Docs YYYY-MM-DD).
- **OD-9 VOLLES GO:** "Bauplan V3 liegt im session Backup und deckt deinen Vorschlaeg
  vollstaendig ab, bitte ultracode um das auseinanderzuhalten und zieh es durch, volles
  GO." -> per ultracode auseinanderhalten (Alt-Forderung 'V3 direkt mit rein'
  jsonl:79891 vs. Bauplan-v3-Abdeckung) und DURCHZIEHEN.
- **OD-10 FREIGABE, VOLLES GO** (F5-Lesart: NUMA/page-Umbau VOR Voll-Bau-4-Trigger).

===============================================================================
## 3. ANTWORT AUF DIE OWNER-RUECKFRAGE "Was ist mit C-3a passiert?"
===============================================================================
C-3a (Scharfschaltung des SIMD-Freigabe-Gates) wurde in der V3-Runde UMKLASSIFIZIERT:
- Die v2 trug einen inneren Widerspruch (Nachtrag: "Folge-Paket nach Trigger" vs. Body:
  "faehrt im EINEN Fenster mit, Agent 5 baut sie jetzt"). V3-D2.3 loest ihn auf: es gilt
  die Nachtrag-Linie. C-3 baut nur den MECHANISMUS (byte-neutral); die SCHARFSCHALTUNG
  C-3a ist ein benanntes FOLGE-Paket in einem EIGENEN spaeteren GO-Fenster.
- Grund (V3-Befund): Das Gate ist DREIFACH inert (Stubs :185/:186/:187 alle leer); Stub
  :187 allein fuellen waere ein No-Op. Alle drei GEMEINSAM zu fuellen ist BYTE-TRAGEND --
  die Gate-Flags fliessen in jede rsp-Compile-Zeile, und der Orchestrator beginnt Binaries
  mit status=-4 abzulehnen, sobald ein Organ required-Flags erklaert.
- C-3a ist deshalb aus dem Agent-5-Umfang und der MUSS-MITFAHREN-Liste GESTRICHEN und
  gegatet auf: C-3b-Kanal-Merge-Beleg (heute per OD-4 freigegeben) + O-4
  (Maschinen-Identifikation). C-3a ist NICHT verloren -- nur sauber verschoben.

===============================================================================
## 4. UNMITTELBARE FOLGE-ARBEIT (dieser Abend)
===============================================================================
1. ultracode-Workflow (3 Straenge + Synthese): (a) Explore: die bereits getroffenen
   Owner-Entscheide zu O-1r/O-2/O-3/O-4/O-5/O-6/O-9 in den Quellen finden + gegenlesen;
   (b) OD-9 auseinanderhalten (Alt-V3-Byte-Schnitt vs. Bauplan-v3-Abdeckung);
   (c) load_framework-Mess-Realm + target_isa-Komplex + telemetry-Zweiteilung als
   V4-DELTA kartieren (alle betroffenen Doc-/Ledger-/Memory-/Code-Stellen).
2. Opus-5-xhigh-Infra-Agent: OD-7-Runner-Handover ins Cluster-git (fetch+merge,
   gitlab-only, keine Secrets).
3. Nach Workflow: V4-Delta additiv ans Bauplan-Doc, Ledger-Nachzug-2 (load_framework-
   Stellen aus 0661a6f3 additiv ueberschichten), Memory nachgezogen, dann Bau-Start
   der byte-neutralen Pakete (OD-6-GO) mit korrigiertem C-1-Zuschnitt.

Selbstcheck: ASCII bis auf Paragraph-Zeichen; Owner-Wortlaute transliteriert-verbatim;
0 Loeschungen an Bestands-Doku; Erstellung 26.07. ~18:45.
