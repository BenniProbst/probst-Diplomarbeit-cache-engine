# WAHRHEITS-ANKER-VOLL-ABGLEICH: 982 getippte Owner-Nachrichten, finale Delta-Liste E-01..E-26 (26.07.2026)

> ultracode-Workflow wf_0874d74a-003 (16 Batch-Pruefer + Ist-Code-Nachpruefung + Synthese).
> Quelle: redigierte queued_command-Ergaenzung (Commit 7af70f88). Owner-Auftrag: Wahrheits-Anker vollstaendig wiederherstellen.
> AUTORITAET: Owner-Wortlaut-Kerne (K) sind KERN=Gesetz; Konsequenzen (F) sind Manager-Analyse.

WAHRHEITS-ANKER-SYNTHESE 982 GETIPPTE OWNER-NACHRICHTEN (queued_command) - FINALER DELTA-REPORT

=== (a) VOLLSTAENDIGKEITS-BILANZ (1:1 auf 982, Summe geprueft) ===
Roh (16 Batch-Pruefer): 173 verankert / 735 operativ / 31 obsolet / 32 delta / 11 duplikat = 982 (exakt, keine Nachricht ohne Klasse).
NACH IST-CODE-NACHPRUEFUNG (2 Rueckstufungen): 174 verankert | 735 operativ | 32 obsolet | 30 DELTA-SUBSTANZEN | 11 duplikat = 982.
  30 Substanzen -> 26 gefuehrte Punkte E-01..E-26 (8 Merges gleicher Substanz, Buendel nr798 in 5 Punkte geteilt).
RUECKSTUFUNG 1: nr37 MeasurementVisitable = OBSOLET/ERLEDIGT. Literal LEDGER:747 (10.07.) "CMD-1-b eingeloest: MeasurementVisitable (das
  seit 06.07. geparkte Concept) constrained axis_accept_measurement"; Ist-Code aktiv ce/libs/cache_engine/topics/axis_command_base.hpp:30.
RUECKSTUFUNG 2: nr676 Layout-Schwelle = VERANKERT im Code. ce/tests/unit/CMakeLists.txt:1788-1795 traegt die Owner-Begruendung wortnah
  ("NUR UNTER Optimierung >5% sichtbar ... unoptimiert ~3-4% < Schwelle -> CI-Rot ... -O3, NICHT Ofast") + comdare_apply_optimization_
  level_flags(test_all19_segment_timer O3). Nur Doku-Nachtrag fehlt.
SCHON EINGEPLANT, hier NICHT erneut gelistet (nur referenziert): D-01..D-17 + NACHTRAG. Beruehrt: E-12 (praezisiert D-01/D-10/D-11),
  E-14 (D-04), E-18 (D-03), E-19 (D-02).

=== (b) FINALE DELTA-LISTE  (K = Owner-Wortlaut-Kern, F = Konsequenz) ===
--- VOR-TRIGGER (15) ---
E-01 [DELTA] nr564 PAT auf Branch development + Cluster-Sync-Pflicht. K: "Der gitlab pat ist im cred vault und auf branch development,
  braucht git sync von Projekte/Cluster nach einem commit auf unserer Seite". F: Dossier 1 nennt nur Vault-Pfad+grep|tail-1; ohne Pull
  greift ein Agent stale -> 401 bei Dual-Push/API, obwohl D-08 den PAT als NEU fuehrt.
E-02 [DELTA] nr574 ALLE VIER Repo-Ledger lesen, dann Audit. K: "alle 4 Projekte [haben] vermutlich ein eigenes Ledger, bitte lies daher
  auch alle 4 ledger". F: BELEGT ce/docs/ledger-sections/architektur-ziele-offene-punkte-ledger.md; Dossier 2 kennt nur DAS super-Ledger
  -> ce/prt-art/thesis-Offenpunkte fallen systematisch aus jedem Audit (direkt vor Voll-Bau-4/Abgabe).
E-03 [DELTA] nr312 Rote Pipeline NIE als transient annehmen. K: "es war falsch anzunehmen, das waeren transiente Fehler ... schon seit 9
  Stunden". F: Persistiert nur "hart gruen" + 1x-Retry fuer Cold-ICE; Transienz muss BELEGT werden, sonst Root-Cause-Pflicht.
E-04 [DELTA] nr38 CI-LIVE-Fortschritt + generische Interface-Tests je Tier-Binary. K: "ich [muss] live sehen ... ob der CacheEngineBuilder
  Orchestrator gebaut wird und exakt welche Tier-Binary Rekombinationen und wie viele davon noch offen sind ... nachgelagerten Schritt ...
  generischen Tests ueber ihre interfaces bestehen". F: complete-heuristik.log ist Cache-Claim, kein CI-Report; Nachtest fehlt -> 2^17 blind.
E-05 [DELTA] nr703 System-Achsen steuern Kompilation UND Auspraegung der Mess-Achsen. K: "die System-Achsen steuern die gesamte Kompilation
  und Auspraegung der Mess-Achsen". F: 3.1 setzt MESS-TOOLING auf Pos.1 vor target_isa, 3.5-E1 macht Mess/System gleichrangig -> Lane A
  generiert kSystemAxisOrder ohne die Steuer-Relation.
E-06 [DELTA] nr889 System/Organ strikt getrennt AUCH in der CEB-LAUFZEIT. K: "wir trennen sie strikt als Layer in der Tier-Binary zwischen
  Hardware und Anwendungs-Logik" + "Und wir trennen sie auch strikt in der laufzeit der CEB aus der die Tier-Binaries kompiliert werden".
  F: verankert nur als Stempel-Klammer 3.5 + Tier-Zwei-Array; ein gemeinsamer Achsen-Walk im CEB-Emit-Pfad waere heute regelkonform.
E-07 [DELTA] nr734 Stehendes Ledger-TODO: Nachweis der B+-Baum-Steuerung. K: "liste das TODO, dass ein ultracode Agent pruefen muss, ob die
  Konfiguration der Organ-, System- und Mess-Achsen weiterhin NACHWEISLICH durch den Experiment-B+-Baum gesteuert wird ... Bitte ins Ledger".
  F: TEIL-ANKER gefunden (Pruefer sagte 0 Treffer): LEDGER:314 "E3 = Permutations-B+-Baum PRO ACHSEN-TYP" + LEDGER:146(f). FEHLT der stehende
  Nachweis-Auftrag als Abnahme-Kriterium (Kandidat 5. lokaler Beweis) - Lane A/C/F + ORG-18 aendern genau diese Konfiguration.
E-08 [DELTA] nr798-B8/B10/B3 Achsen-Taxonomie: 7. System-Achse NUMA/locking, page_type, je HW-Typ eigene Achse, Meta-Meta-DEFINITION.
  K: "die 6 Achsen ... muessen durch eine SIEBTE NUMA/locking-System-Achse erweitert werden, sofern compile-statisch erkennbar; ansonsten
  dynamische System-Unter-Achse ... unter der ISA-Achse"; "page_type ... fuer Cache-Awareness PFLICHT"; "jeder Typ Erweiterungshardware
  bekommt EINE EIGENE ACHSE"; DEFINITION "Haupt-Achsen eines statischen Arrays unter einer Manager-Haupt-Achse heissen Meta-Meta-Achsen".
  F: Ist-Stand belegt Luecke (NUMA nur in _ce-scratch/thesis_profiles, page_type-Achse nur im Scratch-Split); R-A..R-F kennen beides nicht.
  ACHTUNG golden-brechend -> Schnitt/Zeitpunkt owner-bestaetigen (D-01 zieht auf VOR-Trigger).
E-09 [DELTA] nr798-B4 ISA-Achse per Fork A, Alt-Version AUSBAUEN, Cross-Compile-Raum, erweiterbare Stempel. K: "ISA-Achse per Fork A bauen
  und die alte Version ausbauen ... FREIGABE-Haupt-Achse fuer durchfuehrbare Organ-Achsen ... in den Organ-Achsen als RAUM ausgearbeitet,
  der in der Regel nur der einen lokalen ISA entspricht, fuer explizite Cross-Compile-Jobs aber erweitert sein kann; die Versionierungs-
  stempel muessen als System ERWEITERBAR sein". F: kein Board-Posten; Lane A hat weder Alt-Ausbau- noch Cross-Compile-Posten.
E-10 [DELTA] nr798-B3org ORGAN-analoges Meta-Meta-Haupt-Achsen-Array + eigener Compile-Raum-Stempel. K: "haben die ORGAN-Achsen entsprechend
  ein ANALOGES Haupt-Achsen-Array UND Versionierungs-Stempel fuer den durch CEB materialisierten Compile-Raum". F: 3.5 kennt nur die drei
  Typklammern + SHA512-Overlay -> Lane F/A-II/A-III zu klein geschnitten (Stempel muss bei NEUEN System-Achsen systemisch erweiterbar sein).
E-11 [DELTA] nr786 std::variant im Hybrid-Tier LIMITIERT frei, nur via Abstract Factory. K: "die std::variant im hybrid Tier ist nur
  LIMITIERT freigegeben, sofern das Einbinden der Tier-Binary-Unter-Pruef-Docks per Abstract-Factory-Methode gelesen und verarbeitet wird ...
  nicht die Haupt-Kommunikation zu den Tier-Binary-Observern". F: Beweis 3 (Variant-Gate-E2E) ist ohne die Ausnahme spezifiziert -> sperrt
  den legitimen Hybrid-Pfad oder ueberdehnt sie unbemerkt; Abstract Factory als Pflicht-Pattern fehlt im S7-Hybrid-Band.
E-12 [DELTA] nr981 Lane-C-Vorbedingung + OS-Unter-Achsen final DREI (praezisiert D-01/D-10/D-11). K: "Frage 3: Musst du erst untersuchen, ob
  diese Lane vorher keine Blocker bei A und B hat. Sonst volles GO." / "Frage 2: Wir mergen den Update Zustand in Build." F: (a) D-01 gilt
  NUR unter Blocker-Freiheits-Pruefung ggue Lane A/B - nicht persistiert. (b) OS-Unter = FINAL 3 -> D-10 beantwortet, Dossier 3.2 anpassen.
  (c) D-11 (Schreibweise external_utils) bleibt UNBEANTWORTET ("von mir aus als eine Unter-Achse" trifft eine andere Frage) -> verbose neu.
E-13 [DELTA] nr324+nr333 Layer-Modell MUSS Projekt-Bezug haben; die 2 obersten Schichten liegen im Diplomarbeit-Code. K: "wir arbeiten ja an
  den 2 Schichten oben drueber an der Diplomarbeit code" + "die Layer Architektur ist immer noch falsch, weil sie nichts mit den Projekten
  zu tun hat". F: Anker project_e1_e4 sagt das Gegenteil -> ohne Repo-Verortung je Schicht werden Lane-/Band-Pakete im falschen Repo geschnitten.
E-14 [DELTA] nr839 NAS-Credentials backup1/backup2 (neu) im Cred-Vault. K: "die neuen credentials von backup1 und backup2 liegen im cred
  vault". F: ergaenzt D-04 (Mess-CSV -> PR4100 Cluster_NFS): NAS-Seite des Dual-ccache/Mess-Ziel scharfschalten heisst Vault ziehen, nicht raten.
E-15 [PLAUSIBEL] nr677 Optimierungs-Flags an der Hardware-Achse, Richtung O3. K: "mit flags je hardware Achse richtung O3". F: Teil-Anker im
  Code (opt_level=O3 der Compiler-System-Achse, optimization_level_sub_axis.hpp, "voller XML-permutierter opt_level-Raum folgt mit dem Planer
  2c.opt-g/h"). OFFEN: mit welcher Stufe Voll-Bau-4 + Cache-Line-Beweise laufen - unoptimiert sind Layout-Messwerte nicht aussagefaehig.
--- VOR-01.08. (7) ---
E-16 [PLAUSIBEL] nr798-B9 Thesis-Mess-Profile WAS/WIE uebernehmen + Mess-Tooling-Unter-Achsen fuer Mess-FRAMEWORKS + Workload-Delegation an
  die CEB per XML-Schema. K: "die geforderten Thesis-Profile WAS und WIE zu messen ist muessen VOLLSTAENDIG uebernommen werden, ebenso die
  Mess-Tooling-UNTERACHSEN fuer Mess-Frameworks und deren WORKLOAD-DELEGATION an die CEB ... Mittel/Werkzeuge im Experiment-Planer und ALLEN
  Stufen". F: Teil-Anker ce/libs/cache_engine/algorithm_profiles/{thesis_profiles,load_profiles} + test_kf1_thesis_profile_parser existieren;
  DELTA = kein Arbeitspaket fuer Planer-Uebernahme, keine Framework-Unter-Achsen, keine Delegations-Naht (Voraussetzung verwertbarer Messungen).
E-17 [DELTA] nr307 Runtime-Profile muessen CT/RT-HYBRID werden (Fork-Aufloesung #31/F7). K: "Die runtime Profile muessen ein hybrid aus
  compile time und runtime werden, um dem Experiment Baum zu entsprechen". F: reine CT-Option A verworfen -> CT-enumerierbare Achsen/Werte +
  RT-WorkloadConfig(Seed/Ops) an StaticAxisNode/DynamicVariableNode. NEBENBEFUND: workload_matrix.* existiert im aktiven ce NICHT mehr, der
  als "einziger aktiver Fehlbau" gefuehrte Zustand ist mindestens verschoben -> Ist-Stand vor Lane-Schnitt verifizieren.
E-18 [DELTA] nr529+nr541 LaTeX-Anhang-Generierung ist HAUPT-ZIEL des Gesamt-Systems + Vorwaerts-Kanal bei JEDEM CI. K: "Das Generieren der
  Latex-Anhaenge im Diplomarbeit-Code ist HAUPT-ZIEL des Gesamt-Systems und kombiniert das automatische Erstellen der Ergebnisse in die
  Diplomarbeit-PDF mit Auswertungsautomatisierung aus der xml-Kette bis zu den fertigen Ergebnissen (Voll-Matrix mit Tabellen, Formeln und
  Diagrammen der echten Messwerte) ... konsolidiere die xml-bis-pdf-Kette gegen die im cache-engine-Tool gemessenen Messwerte" + "Ja B1/B2
  auto befuellen bzw. bei jedem CI neu setzen" + "A wird eingebaut, das schliesst aber B nicht logisch aus (beides umsetzen mit Prio A)".
  F: Board #5 fuehrt G8/S8 nur als Rest-Band; persistiert ist nur der Rueckwaerts-Kanal (persist:measurements -> measurement/<ts>/). Der
  VORWAERTS-Kanal (anhang/{de,en}/tabellen/*.tex je CI ins Overleaf-Submodul, Projekt 289, eigener Write-Token, Post-measure-Rebuild) fehlt
  -> PDF-Tabellen bleiben stale. Auch unpersistiert: generische Regel "A schliesst B nicht aus, beides mit Prio A". Koppelt an D-03.
E-19 [DELTA] nr17+nr56 Runner-Fleet-Vollstaendigkeit + Poll-Verhalten. K: "Laufen weiterhin alle im cluster geplanten gitlab runner ueber
  alle Architekturen nach der Cluster gitlab runner Beschreibung? Ansonsten aktiviere das bitte nachtraeglich" + "alle 2+rand(0.0 ... 1.0)
  Sekunden nach neuen jobs pollen". F: (a) stehende Ist-Soll-Verifikation der Fleet + Nachaktivierung ist kein Board-Punkt (Referenz kennt
  nur prod1/prod2/node7, concurrency=1) -> Voll-Plattform-Matrix #276 ohne verifizierte Abdeckung; ergaenzt D-02. (b) Jitter offen -> BAND-C.
E-20 [DELTA] nr506+nr744+nr975 Infra-Kommunikation. K: "Fuer alle Probleme schreibe dem Infra Agenten ein Handover unter den
  Cluster/docs/sessions und pushe es nach remote" + "Du musst an den infra agenten pushen sonst sieht er es nicht." + "cluster docs/sessions
  und cluster sessions sind gedriftet und sollten ... konsolidiert werden". F: (a) Problem-Handover-Ort = Cluster/docs/sessions + Push
  (bereichsbegrenzte Schreib-Erlaubnis); Referenz kennt nur super/docs/sessions. (b) BRING-Pflicht: nur im Manager-Kontext/in Dateien liegende
  Ergebnisse gelten falsch als kommuniziert (Board #2 kann still ins Leere laufen). (c) Konsolidierung ausgefuehrt (Cluster 185bb913, 10 git
  mv, 7 Datums-Stempel), aber 2 Konventions-Entscheide offen: 667 Transkript-Exporte eigene Gattung? Backup-Baeume (628 Dateien) mitziehen?
E-21 [DELTA] nr316+nr448+nr814 Prozess/Kommunikation. K: "Bitte lege dazu eine sichtbare TODO Liste in stack form an" + "bitte stelle die
  Fragen verbose, ich verstehe dich nicht" + "weise den Agenten an, nicht nur den Kern zu persistieren, sondern alles aus diesem
  Kontext-Session-Log". F: (a) STACK-Form (LIFO, Rest-Stack = offen) fehlt in der Tasks-Direktive. (b) Rueckfragen AUSFORMULIERT (betrifft
  Q-0..Q-14, Q-A..Q-F, D-11/D-15). (c) Persistenz = ALLE Owner-Nachrichten + Manager-Fragen je Kontext - genau die Luecke dieses Nachlaufs.
E-22 [PLAUSIBEL] nr196 Goal traegt MEHRERE aktuelle Ziele als Voll-Pfad-Referenzen, nur ERGAENZEN. K: "verankere das zusaetzliche matrix goal
  als Voll-Pfad Referenz im Ledger Goal V3 ... weil beides aktuell ist, bitte nur ergaenzen". F: Referenz kennt nur das Diplom-Ziel ->
  Goal-Umschreibungen verlieren das comdare-Matrix-Ziel still. PLAUSIBEL: Goal-Datei nicht geprueft (Stand 08.07., ggf. eingeloest).
--- BAND-C (3) ---
E-23 [DELTA] nr452+nr539 measurement-all: Such-vor-Anlage-Pflicht + G5-Forks F0-F5=A. K: "erst gitlab fuer die Modulmigration durchsuchen
  weil die repos schon unter measurement-all begonnen wurden und dann konsolidieren, arbeite auch hier autonom per API" + "Ich gebe alle
  offenen Punkten wie empfohlen frei." F: (a) vor JEDER Modul-Migration GitLab per API durchsuchen + KONSOLIDIEREN (Teil-Anker
  comdare-measurement-all LEDGER:191) -> sonst Wiederholung der 6 Pseudo-Spiegel (#12 deferred). (b) "wie empfohlen" = G5-Forks F0-F5=A:
  Umbrella-Stufe baseline_3-analysis, belang-genaue Extraktion, source-only INTERFACE-Zellen, bottom-up, EINE Research-Instanziierungs-Zelle,
  stale Umbrella-README - erteilter Migrations-Auftrag ohne Board-Posten.
E-24 [DELTA] nr798-B2 Gattung SearchAlgorithm+Container als LETZTER ABI-Schritt mit eigener ultracode-Planung. K: "diese Gattung als
  ABI-Schritt als LETZTEN Schritt mit eigener ultracode-Planung anhaengen und mit der Vervollstaendigung der Gattung SearchAlgorithm und
  Container erweitern ... bei weitem nicht erfuellt, gigantische Erweiterung ueber parallele Achsensysteme weiterer Gattungen". F: fehlt in
  der Gate-Reihenfolge; Organ-Haupt-/Unter-Achsen exakt nach SearchAlgorithm-Schema identifizieren.
E-25 [PLAUSIBEL] nr262 Es gibt auch generische SERVER- und CLIENT-Module. K: "Es gibt auch server und client generische Module". F: Ledger
  nennt nur comdare-cacheengine-all/-config-all/-foundation-all/-measurement-all (grep-belegt) -> Reuse-Landschaft unvollstaendig kartiert,
  Doppel-Eigenbau-Gefahr. PLAUSIBEL: GitLab nicht abgefragt - gehoert in denselben API-Suchlauf wie E-23(a).
--- KLAERUNG (1) ---
E-26 [DELTA] nr26 Lazy-Cache auf ALLEN Pipeline-Ebenen und je Submodul, inkl. TEST-Skip. K: "die Pipeline sollte lazy cachen auf allen Ebenen
  der Diplomarbeit und der 3 Untermodule, sofern sich in diesen Modulen nichts aendert. Wir kompilieren und Testen nur Aenderungen neu".
  F: verankert nur Tier-/CEB-Binary-Caching je Organ-Algorithmus + Dual-ccache; der TEST-Skip kollidiert mit "GESAMTE Pipeline hart gruen"
  und Voll-ctest N/N je Welle -> Owner-Entscheid: Skip mit Fingerprint-Beweis erlaubt, oder Voll-ctest bleibt Pflicht?

=== (c) WIDERSPRUECHE ZWISCHEN OWNER-AUSSAGEN VERSCHIEDENER KONTEXTE ===
W1 LANE C: Dossier 5/9 "inert, Scharfschaltung erst NACH Trigger" vs D-01 "vor dem voll Build behoben" vs nr981 "volles GO, aber erst
   untersuchen, ob die Lane keine Blocker bei A und B hat". Neueste Aussage gewinnt: scharf VOR Trigger, GATED. -> E-12.
W2 LAYER vs REPO: project_e1_e4 "Layer-Modell hat NICHTS mit Projekt-/Repo-Grenzen zu tun" vs nr333/nr324 "falsch, weil sie nichts mit den
   Projekten zu tun hat" + "2 Schichten oben drueber an der Diplomarbeit code". Direkter Sach-Widerspruch, owner-seitig zu schlichten. -> E-13.
W3 STD::VARIANT: pauschales Verbot (Dossier 2 / N3 "in CEB UND Tier STRIKT verboten") vs nr786 limitierte Hybrid-Ausnahme via Abstract
   Factory. Chronologie unklar (N3 evtl. juenger) -> Vorrang muss der Owner setzen. -> E-11.
W4 MESS vs SYSTEM: nr703 Unterordnung der Mess-Auspraegung vs Sortierung 3.1 (MESS auf Pos.1) + 3.5-E1 (gleichrangige Typen). Ordnung und
   Steuer-Relation zusammen entscheiden, BEVOR kSystemAxisOrder generiert wird. -> E-05.
W5 CLUSTER-SCHREIBRECHT: "Cluster-git wird NIE redigiert" + Handover-Ort super/docs/sessions vs nr506 "schreibe ... unter den
   Cluster/docs/sessions und pushe es". Aufloesbar als bereichsbegrenzte Schreib-Erlaubnis, nicht als Aufhebung. -> E-20.
W6 TEST-SKIP: nr26 "nur Aenderungen neu kompilieren UND testen" vs "GESAMTE Pipeline hart gruen"/Voll-ctest N/N. -> E-26.
W7 DOSSIER-SELBSTAUSSAGE: Abschn.6 "ALLE Owner-Entscheide des Tages sind eingeholt und persistiert" war zum Erstellungszeitpunkt FALSCH -
   nr981 Fragen 4+5 waren unbeantwortet an ultracode delegiert; erst der MEMORY-NACHTRAG loest sie. Satz entschaerfen.

=== (d) "HABE ICH JETZT ALLE 982 WIEDER?" ===
Ja - fuer diesen Kontext vollstaendig und lueckenlos: alle 982 verworfenen queued_command-Records sind gelesen und 1:1 klassifiziert
(174 verankert + 735 operativ + 32 obsolet + 30 Delta-Substanzen + 11 Duplikate = 982, Summe exakt, keine Nachricht ohne Klasse). Inhaltlich:
735 waren operative Anweisungen ohne dauerhafte Regel-Substanz, 174 sind in Dossier/Memory/Ledger schon korrekt verankert, 32 sind durch
spaetere Entscheide ueberholt - und 30 Substanzen (26 Punkte E-01..E-26) waren echt verloren, davon 15 mit Wirkung VOR dem Voll-Bau-4-Trigger.
Zwei Batch-Verdikte habe ich am Ist-Code widerlegt (nr37 ist seit LEDGER:747/10.07. wieder eingebaut und aktiv; nr676 ist in
ce/tests/unit/CMakeLists.txt:1788-1795 wortnah verankert), die Batch-Trefferquote lag also bei ~93 Prozent, und die Restliste ist konservativ
gehalten (4 Punkte nur PLAUSIBEL, weil ich einen Anker nicht ausschliessen konnte: E-15, E-16, E-22, E-25). EINSCHRAENKUNG, damit die Antwort
ehrlich ist: die 982 sind die getippten Nachrichten DIESES einen Kontext-jsonl; queued_command-Records frueherer Kontexte sind nicht geprueft,
und die Ursache wirkt weiter, solange der Plaintext-Extraktor attachment.queued_command.prompt nicht dauerhaft mitzieht - dieser Extraktor-Fix
(NACHTRAG) ist die einzige Massnahme, die verhindert, dass die naechste Kompaktierung wieder Entscheid-Antworten verschluckt.

SELBSTCHECK: 7-Bit-ASCII (grep -P '[^\x00-\x7F]' = 0 Treffer); 26 Delta-Punkte; 7 Widersprueche; Bilanz-Summe 982 verifiziert.
