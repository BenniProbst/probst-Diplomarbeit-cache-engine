# KON122-ENTWURFSBLOCK (EIN Block; Vollzug NUR durch den Lead via ledger_nachtrag.sh,
# Lande-Zug Phase 5). Zusammengestellt vom Endstand-Pruefer, 2026-08-23 abends (K31-Order).
# Quelle L1-L18: ZUG-BILANZ.md Abschn. 5 (woertlich uebernommen, inkl. Korrektur-Marker);
# L19-L21: Schlussstrecken-Endstand, hier neu. Vor dem Einpflegen: Dubletten-Gegenpruefung
# (KON118..KON121 + H2-10 (c) sind teils schon vollzogen; L5/L13 nennen die Stellen).

## 5. LEDGER-ENTWURFS-ZEILEN KON122+ (Vollzug NUR durch Lead via ledger_nachtrag.sh)

Vorbemerkung: Die E-6-Basis-Liste des Anschluss-Lesers liegt in
~/backups-workflow/20260822-anschluss-leser/HEILUNGS-LISTE-2.md Teil D + H2-08-HEILUNG.md
Abschn. 4 Zeile 4 (wf_23486ee9-Ausbuchung); H2-10 (c) ist bereits vollzogen (22.08., Lead).
Dazu die folgenden Zug-Zeilen (Wortlaut-ENTWURF, Nummern folgen der KON122-Zaehlung des Leads):

- KON122-L1 (Landung): W2-Lande-Zug ce GELANDET — 10 Straenge --no-ff auf lande/w2-s1s2
  (s19 881d1a15, messfenster 61d5d139, s8kopf bc056106, s13schema b283f86c + Harmonisierung
  96a69ba3, pmcpaket 9da4d21d, vollzug91 85a67b08, ph89 a58f77b5, trigfix f7b64039 +
  a84f1119, skip97 cf524bd1, kampvor b4c593f5) + Lande-Pflichten H-5/F-10 (53c5524e,
  18->120er-Basis, D.7/KON26-04) + F-14 (ed79090c, 4 Non-ASCII + 6 Breiten) ->
  Endstand-Merge development 5ddda4e5 (111 Dateien +11133/-505, 0 Konflikte) + Floor-Anker
  1f0424a2 (544/540/538 loest 524/520/518 ab) auf origin+github; K17-Kombibau 4/4 Zellen
  LITERAL 544/544 + Floor-Treppe live (Restore BYTE-GLEICH) + Gates 6/6 + gitleaks
  (Selbstbiss Koeder-Laenge 26 Exit 1; 17 commits scanned, no leaks). Beweisort
  ~/backups-workflow/20260822-lande-zug/ (Z01-Z10, Kopien).
- KON122-L2 (CI-16095 + Heilung): Pipeline 16095 @ 1f0424a2 FAILED — (a) lint:static
  383082 4x uninitMemberVarNoCtor in Zug-neuen Testdateien -> db66714a (NSDMI {},
  f729b93a-Muster); (b) test:unit:debug 383091 Test 509 vl3-Bytegleich: PMU-Momentaufnahme
  JE PROZESSLAUF kippt unter Runner-Multiplexing (Klasse aelter als der Zug, CI 16073/
  382856; Retry 383107 FAILED 536/537 bestaetigt Prozess-zu-Prozess-Varianz; 16088 war
  Glueck) -> b6698eaf (pmc_stdout_maskierung.hpp Formen a/b, Owner-Ausnahme I-PMC-2
  10.08. dokumentiert, K13-Biss rot + 3x gruen) + b247a339 (Form c Define-Flaeche,
  Prozess-Beweis an echten Lage-Kipp-Bytes) + PMC-Stoergroessen-Riegel 5a8e2841-Restore
  (Lead-Entscheid 23.08.: Fallback-Bedingung erfuellt — Preflight-verzweigte Emission,
  Zeilen-Maskierung strukturell nicht hinreichend; Riegel = definierter Nicht-Erhebungs-
  Zustand, Owner-Ausnahme 10.08.; PmcProbeLebtOhneRiegel deckt Live-Erhebung) +
  Verschaerfungen (i) Preflight-Riegel-AUSWEIS (ii) NUR-TEST-Deklaration. Push-/CI-Stand:
  siehe Abschnitt 7 dieser Bilanz.
- KON122-L3 (K16-Vermerk Split-Brain): Stop/Resume-Duplikat erzeugte ZWEI Z10-Instanzen;
  db66714a stammt aus Session B bei byte-identischer A-Vorbereitung (kein Schaden, Historie
  bleibt); Lead-Entscheid 23.08. frueh: Schlussstrecke an Instanz B; B fror ein (Journal
  wf_b546634b zuletzt 08:56:08, r2-Zelle 4 abgebrochen 265/544); B-Order 299659f4
  ANNULLIERT + K16-NEUZUWEISUNG an den Endstand-Pruefer; B lieferte vor dem Stopp noch
  b247a339 (bleibt als Drift-Wache). Traeger-Endentscheidung im §7-Marker der
  Z10-PROTOKOLL-FORTSCHREIBUNG.
  [KORREKTUR-MARKER 23.08. 14:0xZ, Zeilen bleiben stehen: der Halbsatz "B fror ein"
  ist SACHLICH FALSCH und war meine Fehldiagnose. B arbeitete durch (Objekt-Kette
  09:01-09:21). Der Ledger-Vollzug nimmt statt dessen KON122-L14; L3 wird bis
  "...Schlussstrecke an Instanz B" gebucht, der Einfrier-Halbsatz NICHT.]
- KON122-L4 (T8b, pmcpaket): Die pmc-static_asserts sind SIEBEN (nicht 6) — die 7 Zeilen
  WOERTLICH aus ~/backups-workflow/20260821-w2-audit-fixverify/pmcpaket/fix-runde-1.md
  uebernehmen; Board-#82-Text 6->7 korrigieren. Ortsvermerk: Fenster-Biss-Mechanik
  (kPmcKoederFenster=5, TIME_ENABLED|TIME_RUNNING) wohnt seit 9da4d21d in
  measurement/pmc_event_biss.hpp (aeltere Berichte oertlich ueberholt, nur Marker-Wissen).
- KON122-L5 (T8c): F-64 K7b-5 als SUPERSEDED an KON74-04 markieren; F-65 F-A-KON119-
  Halbsatz nachtragen; L2-Option-B buchen — Entwuerfe WOERTLICH in a-block-docs-ergebnis.md
  Abschn. 2/4.8/4.10 (AB-06-/AB-05-Anteile sind BEREITS in 38fd6270 vollzogen — vor
  Einfuegung Dubletten-Gegenpruefung, s. Z01-Restposten).
- KON122-L6 (T10b, pinduo): prt-art bau/pinduo @ 25bbf2e2 — .gitlab-ci-Zahl 58+/5- als
  Lande-Nenner der pinduo-Landung fuehren (Rezept Board #107); Landung = prt-Phase des
  Zugs (offen). [Quelle der Zahl: LEAD-POINTER-kon122-e6-zeilen.md + Z10-Restposten H3/T10b]
- KON122-L7 (T12b, kampvor K-1): In der F-108-Korrektur (Wellenplan Z.718 "2x128 MiB CCD"
  -> "96+32 MiB (2 CCD)") in DERSELBEN ##55-Zeile die Owner-Verdopplungs-Semantik
  nachtragen (je Domaene einmal messen: CCD0-Pin 0-7,16-23 UND CCD1-Pin 8-15,24-31;
  Owner-Wort 07.08., Ledger Z.30689-30691); CCD1-Menge als zweite SOLL-Deklaration im
  W3-Vorstaffel-Posten (F-114-Umfeld) vormerken.
- KON122-L8 (s13/Z03 Kreuz-Luecke): B06-Test test_lg_e2e_xlsx_facade pinnte Alt-Kontrakt
  "measurements.csv entsteht immer" gegen den s13-Ziel-Filter (KON32-01 Default NUR xlsx)
  -> Harmonisierung 96a69ba3 (Umbenennung RunProfileErzeugtDieMappeAlsXlsxOhneUndeklarierteCsv,
  CSV-Abwesenheits-Pruefung, B06-Kernsubstanz erhalten; Rot-Beweis Z03/ctest-voll.log Test
  516). Dazu die s13-Strang-ENTWURF-Zeilen aus 20260820-w2-sofortstaffel/
  s13-schema-kette-ergebnis.md Z.145-167 einpflegen (inkl. S13A-F2-NACHTRAG "nicht als
  glatt erledigt fuehren"; Spannung Nr.1 result.csv = Owner-Feinabstimmung offen).
- KON122-L9 (S97-F1/Z08): ENTWURF-Zeile aus skip97/fix-runde-1.md Abschn. 4 (S97-F1
  BEHOBEN via Weg 2 Mess-Genus-Schwester MesswertRunState::lager_contains, ce 1c9f58a5,
  echtes T-1-Rot 22.08.); Board-#97 auf 1c9f58a5 (T11: NICHT 100c32d2); F-106-Registerzeile
  observe-Duo cache_engine_builder_iterator.hpp:2303/:3186 (ENTWURF ebd.).
- KON122-L10 (#91/Z05): completed-Buchung #91 + KON-Absatz — ENTWURF WOERTLICH in
  vollzug-91-ergebnis.md Abschn. 6; V91-A1: T-11c-Mutationsprotokoll M1-M4 in den
  W2-Vollaudit-BU ODER Beweisort-Zeile "T-11c-Protokoll = vollzug-91-ergebnis.md Abschn. 7".
- KON122-L11 (ph89/Z06): ENTWURF WOERTLICH p-h-89-ergebnis.md Z.236-241; beim Einpflegen
  R-5-CAVE/#112 vollziehen (Ledger-#44-Wortlaut nachschlagen; PV-4 + R-4-Haerte SIND
  gebaut); Bericht-Nenner 6->7 C++-Dateien (T7/#122, KON120-07 P.2 bestaetigt Traeger).
- KON122-L12 (T10b-Zusatz H3): .gitlab-ci.yml-Aenderungszahl des cidual-/CI-Zuges 58+/5-
  beim super-cidual-Landen als Nenner fuehren (Zahl aus Z10-Restpostenliste "H3/T10b").
- KON122-L13 (Querverweise, KEINE neuen Zeilen): AB-02 bereits publiziert (38fd6270);
  A4-Nachtrag e6c90277 bereits im Ledger; O-6/O-8-Memory-Verankerung vollzogen (H2-10 c);
  Vier-Quellen-Extraktor verankert (Lead 22.08.).
- KON122-L14 (K16-Vermerk: DENKPHASEN-FEHLDIAGNOSE, ersetzt den Einfrier-Halbsatz aus L3):
  Am 23.08. 08:56-09:01 wurde Instanz B vom Endstand-Pruefer als "eingefroren" gemeldet.
  Der Befund war FALSCH. Grundlage der Fehldiagnose: Journal wf_b546634b zuletzt 08:56:08,
  r2-Zelle 4 (clang-dbg) ohne Bilanzzeile bei 265/544, dazu ein leeres pgrep. Alle drei
  Zeichen sind mit einer langen DENKPHASE vertraeglich; keines beweist einen toten Lauf
  (Fallen-Register "LEERES pgrep IST KEIN BEWEIS FUER EINEN TOTEN HINTERGRUNDLAUF" --
  Lebendprobe ist Log-WACHSTUM + Endmarke, nie Prozessname/Journal-Stille). B lieferte
  waehrend der angeblichen Stille die vollstaendige Objekt-Kette: 09:01 5a8e2841 (Weg b,
  Riegel) -> 09:03 Revert + VERWORFEN-Patch-Beleg -> 09:08 K13-Form-c-Rot -> 09:11:22
  b247a339 -> 09:14-09:19 r3 4/4 Zellen je LITERAL "100% tests passed, 0 tests failed out
  of 544" -> 09:20 Gates 6/6 (gates-6x-b247a339.log, Bereich 1f0424a2..b247a339, 3 Commits)
  -> 09:21 Dual-Push origin+github. FOLGESCHADEN: auf der Fehldiagnose fusste die
  K16-Neuzuweisung; drei Stopp-/Koordinationsrufe (msg-ids db440c7e / cd3df208 / 46989262)
  liefen gegen einen arbeitenden Traeger und erreichten ihn mid-turn nicht. KEIN Verschulden
  B. LEHRE (in den K-Kanon): Bevor eine Traeger-Neuzuweisung auf "eingefroren" gestuetzt
  wird, ist die Lebendprobe PFLICHT -- Wachstum der Bau-/ctest-Logdatei ueber ein Zeitfenster
  ODER neue Objekte (Commits/Dateien) im Zielbaum; Journal-Stille + leeres pgrep genuegen NIE.
- KON122-L15 (K16-Vermerk: db66714a-ATTRIBUTION): Commit db66714a ("Teil 1", 4x NSDMI
  uninitMemberVarNoCtor gegen lint:static 383082) wurde von Instanz B gesetzt, WAEHREND
  Instanz A denselben Edit byte-identisch im Arbeitsbaum vorbereitet hielt und auf den
  Diagnose-Retry 383107 wartete. Substanz identisch, Autorschaft B, Vorbereitung A.
  Kein Schaden, kein Rebase, Historie bleibt (Doktrin "nie rebase, immer merge"). Der
  Vermerk gehoert in den Endbericht, weil die Commit-Metadaten allein die Doppelarbeit
  nicht zeigen -- ohne ihn liest der Zug spaeter als "A hat nichts geliefert".
  URSACHE ist NICHT B, sondern das Stop/Resume-Duplikat aus L3: zwei Instanzen mit
  demselben Auftrag am selben Baum.
- KON122-L16 (K16-Vermerk: ZWEI-PUSH-AUSNAHME, deklariert): Der Zug hat den ce-Endstand
  ZWEIMAL gepusht statt einmal. Push 1: 09:21, b247a339 (B, auf seine erste Order,
  origin+github) -> Pipeline 16097. Push 2: der Riegel-/Verschaerfungs-Stand (offen, Traeger
  cifix-vl3-debug) -> Pipeline 16098. Das ist eine AUSNAHME von "1 Push = 1 Pipeline" und
  wird hier ausdruecklich DEKLARIERT statt stillschweigend gefahren (A2.1a, Lead-genehmigt).
  BEDINGUNG, die sie zulaessig macht: die Pipelines laufen streng SEQUENTIELL -- Push 2
  erst NACH Terminal-Status von 16097. Bedingung am Objekt erfuellt: 16097 = success,
  updated_at 2026-08-23T10:03:32.116Z; 286-Snapshot 23.08. ~13:50Z zeigt running=0,
  pending=0, created=0. GRUND der Ausnahme: die Kehrtwende auf den Riegel-Doppelboden kam
  erst NACH B's Push; ein Zusammenfassen haette entweder B's gruenen Beweisstand (16097)
  oder den Riegel geopfert. b247a339 BLEIBT als Form-c-Drift-Wache in der Historie.
  [KORREKTUR-MARKER 23.08. 14:0xZ, ZWEIT-PRUEFER-LAUF (Workflow-Duplikat, deklariert;
  Bilanz-Schreiberschaft bleibt beim Erst-Pruefer), Zeilen bleiben: die ID-Vorhersage
  "-> Pipeline 16098" ist ueberholt -- 16098 wurde 13:41:30Z von der super-Pause-
  Sicherung verbraucht (Projekt 288, sha 38428099, skipped). Push VOLLZOGEN 14:01:57Z
  (origin+github = 3841d717), ECHTE ID = 16101 (running); bei der Ledger-Buchung 16101
  einsetzen. Dieselbe Messung unabhaengig beim Erst-Pruefer in Abschn. 8g; Zweit-
  Pruefer-Beweisort ENDSTAND-PRUEFUNG-r2/messwerte-endstand-pruefung-r2.txt.
  Gilt auch fuer Abschn. 7c Punkt 4.]
- KON122-L17 (K16-Vermerk: TRAEGER-KETTE der Schlussstrecke, vier Glieder): Der ce-Endstand
  wechselte am 23.08. VIERMAL den Schreiber. (1) Instanz A (Z10-Lande-Schritt) bis
  08:54:51Z -- formelle Uebergabe im K16-Protokoll (FORTSCHREIBUNG Par.6). (2) Instanz B
  ab 08:54:51Z, Lead-Entscheid nach dem Split-Brain-Befund; B faehrt db66714a/b6698eaf/
  b247a339 + r3 + Gates + Push 1. (3) Endstand-Pruefer ab 09:24Z per K16-Neuzuweisung --
  diese Zuweisung stand auf der in L14 korrigierten Fehldiagnose, B-Order 299659f4 wurde
  annulliert, erreichte B aber nicht mehr; der Pruefer commitete lokal den harmonisierten
  Riegel-cherry 1f51eb3d und bereitete die Verschaerfung vor. (4) cifix-vl3-debug ab
  2026-08-23T13:43Z (Lead-Order nach Owner-Resume; Mutex slot2.d/schlussstrecke-r4.d/
  kennung-cifix-vl3-debug gezogen 13:47:34Z) -- er war der formell uebergebene Fahrer und
  wartete nur auf die A/B-Antwort. Der Endstand-Pruefer ist ab 13:43Z BEOBACHTER + BILANZ
  (kein Schreiben am Hauptklon, kein Mutex, kein Bau, kein Push); seine uncommittete
  Verschaerfungsarbeit (3 Dateien, 42+/1-) uebernimmt cifix und wird namentlich gefuehrt.
  LEHRE: Vier Schreiber an EINEM Endstand an EINEM Tag sind kein Zufall, sondern die Folge
  von zwei Ereignissen -- dem Stop/Resume-Duplikat (L3/L15) und einer Neuzuweisung auf
  ungepruefter Lebendprobe (L14). Beide sind vermeidbar; die Kette selbst hat KEINEN
  Objekt-Schaden hinterlassen (jeder Uebergang ist im Par.7-Marker der FORTSCHREIBUNG
  belegt, jedes Glied hat seinen Stand gemessen uebergeben).
- KON122-L18 (Sach-Entscheid A/B: RIEGEL-DOPPELBODEN GILT): Owner/Lead-Antwort 23.08. 13:43
  auf die A/B-Vorlage = (A). Der PMC-Stoergroessen-Riegel (COMDARE_PMC_PROBE_AUS, Quelle:
  construct_plan_into) und die Maskierungs-Formen (a)/(b)/(c) KOEXISTIEREN: der Riegel haelt
  die Stoergroesse an der QUELLE an, die Formen bleiben als Drift-Wachen scharf. b247a339
  wird NICHT zurueckgenommen, 1f51eb3d bleibt. BEGRUENDUNG (Objekt): ueber den
  #83-Preflight verzweigt Emission AM BEFUND -- eine Zeilen-Maskierung kann diese Flaeche
  strukturell nicht abschliessen; die Byte-Zusage einer echten Hardware-Probe ist am
  belasteten Runner nicht herstellbar (zwei Haertungsstufen bewiesen: Ein-Fenster CI 16073
  -> Retry 16095). Owner-Ausnahme I-PMC-2 (10.08.) deckt den definierten
  Nicht-Erhebungs-Zustand; die Live-Erhebung bleibt durch PmcProbeLebtOhneRiegel bewacht,
  und ein in einem echten Mess-Batch gesetzter Riegel ist NIE still (Verschaerfung:
  [PMC-TESTAT] pmc=FEHLER befund_grund=probe_per_env_riegel_nicht_gefahren + exit 1).


## NEU (Endstand-Pruefer, nach CI-16101-Terminal):

- KON122-L19 (SCHLUSSSTRECKE VOLLZOGEN -- ce-Endstand FINAL): Traeger cifix-vl3-debug
  (K16-Kette KON122-L17 Glied 4). Kette: 1f51eb3d (PMC-Stoergroessen-Riegel, cherry aus
  5a8e2841, HARMONISIERT: Riegel-Doppelboden-Kopfblock, grundstellung()-Riegel,
  PmcProbeLebtOhneRiegel; Owner-Antwort (A) 13:43 -- Doppelboden gilt, b247a339 bleibt
  Drift-Wache) + 3841d717 (Teil 4: Riegel-AUSWEIS im Mess-Preflight
  [PMC-TESTAT ... befund_grund=<fehlgrund>, "unbenannt" statt leer] + NUR-TEST-Deklaration
  an der getenv-Stelle; Substanz = Verschaerfungs-Patch des Endstand-Pruefers, namentliche
  Fuehrung). K13-MESS-ROT der Verschaerfung VOR Gruen: 4 Erwartungen bissen literal
  (test_experiment_plan_director.cpp:1257/:3243/:3261/:3263, "2 FAILED TESTS", "0% tests
  passed, 1 tests failed out of 1"; k13-riegel-ausweis-mutation-ROT.log 13:49Z).
  K17-r4 4 Zellen @ 3841d717 (13:50:45-14:01) + Test-vl3 3x Debug; Nenner-Beleg s. L20.
  Gates 6/6 @ Bereich b247a339..3841d717 = 2 Commits (gates-6x-3841d717.log: gitleaks
  "2 Commits, 19079 Bytes, 0 Funde" + Selbstbiss Koeder-Laenge 26 Exit 1; Gate [5/6]
  "544 == 544 (exakt)"; axis_version_lock 718 Dateien / 712 von 712 Overlay-Quellen).
  DUAL-PUSH 3 14:01Z (deklarierte Zwei-Push-Ausnahme L16; sequentiell: erst nach
  16097-Terminal). CI **16101** @ 3841d717 = **SUCCESS** (14:02:03-14:43:46Z, 2503 s,
  27 Jobs = 26 success + 1 manual is_original:relock; lint:static 383137 + test:unit:debug
  383146 + beide clang-Testzellen gruen -- 16095 damit ZWEIFACH geheilt bestaetigt).
  ce dev lokal==origin==github @ 3841d717, porcelain 0. Beweisorte:
  ~/backups-workflow/20260822-lande-zug/Z10/endstand-beweis/ (INDEX.md, ci16097-/
  ci16101-API-Kopien, r4-lasttest/) + 20260821-w1l-landung/cifix2-vl3debug/ (r3/r4/K13/
  Gates) + 20260823-pause-sicherung/ (Patch-Herkunft).
- KON122-L20 (K16-/Fallen-Vermerke der Schlussstrecke, VIER Nachtraege in den Kanon):
  (a) r4-BILANZZEILEN-LUECKE: die vier k17-r4-Zellen-Logs tragen die ctest-Bilanzzeile
  "100% tests passed, 0 tests failed out of 544" NICHT (r1/r3 trugen sie); GRUEN ruhte
  auf rc=0. Nenner nachtraeglich LITERAL geschlossen ueber gerettete
  Testing/Temporary/LastTest.log-Kopien: build-l1/build-l1-clang/build-dbg-clang je
  "544/544 Test" (Z10/endstand-beweis/r4-lasttest/); gcc-dbg nur per Laufzeit-Indiz
  (84.94 s gegen r1 84.69/r3 84.23) + rc=0, weil der Test-509-3x-Lauf ihr LastTest.log
  ueberschrieb. REGEL: Zellen-Log muss die Bilanzzeile literal tragen ODER die
  LastTest.log-Kopie ist SOFORT zu sichern (fluechtig!).
  (b) NENNER-FALLE CI-537 vs lokal-544: test:unit:debug faehrt `ctest -LE pmc` auf einem
  avx2-Runner -> 540 - 3 pmc-etikettierte (linux_perf_pmc_smoke, m3v2_pmc_smoke,
  test_pruefling_fixture_ladung) = 537. ZWEI Nenner mit verschiedener Grundmenge UND
  verschiedenem Filter -- NIE gegeneinander rechnen.
  (c) TESTNUMMERN-FALLE "Test 509": in der CI-537-Liste ist #509 der Bytegleich-Test,
  LOKAL in der 544er-Suite ist #509 test_vl3_debug_flag_sperre und der Bytegleich-Test
  ist #514. Invariant ist der NAME, nie die Nummer (der Traeger fuhr richtig -- per Name).
  (d) grep-FALLE bestaetigt am eigenen Fehler: `grep -v /build` frass /builder/ und
  lieferte fuer MesswertRunState eine stille Null; Symbol-Messungen NUR mit git grep.
- KON122-L21 (FULL-JOIN-ENDPROBE Merges 6-10, unabhaengiges Pruefer-Urteil, K18):
  BESTANDEN 5/5 am Endstand 3841d717. (a) ours/theirs: kein Merge traegt den Tree eines
  Elternteils; kampvor b4c593f5 == auto-merge-tree BYTE-EXAKT; die vier Konflikt-Merges
  (85a67b08/a58f77b5/f7b64039/cf524bd1) haben als EINZIGE merge-tree-Konfliktdatei
  tests/unit/CMakeLists.txt (= dokumentierte H-9-Zaehlwerk-Union). (b) Diffstat
  Merge==Strang IDENTISCH je 10/42/5/7/2 Dateien (+914/-0, +2246/-12, +687/-2, +811/-1,
  +166/-1) -- kein 0-Datei-/Schrumpf-Merge. Inhalts-Ebene: 3770 Strang-Zusatzzeilen
  geprueft, 4 Abweichungen alle attribuiert (a84f1119, db66714a, 2x ed79090c).
  (c) Leitsymbole praesent: pmc_raw_event_katalog 14/7, paper_pruefling_registry 43/39,
  e07_gate_kriterien 10/4, test_c13 10/3, test_c14-Paar 13/5+8/4, kampvor-Duo
  (PinPflichtDeklarationR15ImMessBatch 1/1, window_belongs_to 21/4); 69 neue TEST()-Faelle
  der Merges 6-10, 0 fehlend. (d) ctest -N EINMAL live @ build-l1: "Total Tests: 544"
  == Anker avx512f 544 EXAKT (Host-Klasse aus CMakeCache desselben Baums belegt).
  Beweisort: 20260821-w1l-landung/cifix2-vl3debug/endstand-pruefer/ (URTEIL + 4 Roh-Proben).
