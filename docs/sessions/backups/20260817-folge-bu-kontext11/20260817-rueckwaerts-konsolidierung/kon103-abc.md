# RUECKWAERTS-KONSOLIDIERUNG KON103 (A-1 / B-1 / C-1 / C-2 / C-3) — ERGEBNIS

Quellenbasis: Ledger `docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md` (30693 Z.), `docs/sessions/20260817-OWNER-VORLAGE-fragenbuendel-parallelstart.md` (die heute beantwortete 20er-Vorlage, mit STAND/EMPFEHLUNG je Frage), `docs/sessions/20260817-INFRA-MELDUNG-...md`, `docs/plaene/20260813-OWNER-VORLAGE-c3a-comp-gate-paket-entscheid.md`, `docs/sessions/backups/20260817-drift-konsolidierung-rohdaten/rest_karte_r3.md`/`r4.md` (die von der heutigen Vorlage selbst zitierten Anker), `docs/sessions/20260809-KONFORMITAETS-REGISTER-teil2-...md`, Code am Objekt (`best_binary_selector.hpp`, `test_best_binary_selector_parse_rank.cpp`).

---

## A-1 — Token-Rotation via Infra-Orchestrierung

**Owner heute (KON103-01, Ledger:214-216):** „Bitte sofort dem Infra melden und ueber mich synchronisieren, weil 5 Agenten parallel arbeiten muessen und infra orchestrieren kann, wir koennen so gesteuert ein Wartungsfenster sperren."

**VORGESCHICHTE (Fundstellen):**
- **KON22-01(6) „GO zur Rotation"** (Ledger:8040-8046, Nachtrag 12.08., Quelle Transkript-Zeile Z.35912): erstes „volles GO" fuer Rotation der 7 CI/CD-Variablen UND der (damals) „776 Runner-Registration-Token" via `reset_registration_token` je Projekt. Status seinerzeit: nur die 7 Variablen rotiert, die 776 Runner-Token **UNGEPRUEFT**.
- **KON58-04** (Ledger:3875-3907, vor 14.08.): praezisiert den Fund und legt den bis heute entscheidenden Fork offen — NEBENBEFUND: „die Instanz akzeptiert Registration-Tokens weiterhin (`allow_runner_registration_token=true`), der Reset-Weg ist ein Owner-Entscheid (je Projekt zuruecksetzen vs. instanzweit abschalten)." Zusatz: „die '776' ist keine Runner-/Projekt-ID, sondern die Zahl der gitleaks-Treffer" — eine Korrektur, die spaeter (17.08., r3 C11) durch eine echte Zaehlung (390 distinkte Token, 1552 Vorkommen) bestaetigt UND ergaenzt wird.
- **KON64-01 / A4** (Ledger:2737-2755, Nachtrag 15.08. ueber Owner-Antworten 14.08. abends/nachts): „A4 Rotation: AUFGESCHOBEN bis Arbeits-Pause ('Fortschritt geht vor') — Vormerkliste: **776er**, 06.08.-Aera, 4 MinIO-Alt-Svcaccts, Root-Identitaets-Umzug (Rails/Registry), id=98-Turnus." Das ist die im Auftrag genannte „A4-Pausen-Regel 14.08.".
- **Task #54** (15.08.): baut/beweist den infra-seitigen Rotationsmechanismus (`rotate_gitlab_pat.sh`, Scheduled Job im Cluster-Repo) fuer eine ANDERE Kredential-Klasse (Bot-PAT id=54/98) — etabliert das Muster „Rotation als Cluster-Infra-Job statt Session-Handarbeit", bleibt DORMANT (0 scharfe Calls).
- **KON105-03** (heute, spaeter am Tag, Ledger:105-107): fasst A-1/D-3 bereits als „Erinnerungs-Posten ohne Entscheid-Charakter: Infra-Meldung ... an Infra uebergeben (liegt, KON103)" zusammen.

**DELTA der heutigen Antwort:** Der Owner waehlt WEDER die A4-Vertagung (KON64-01: warten bis Pause) NOCH die eigene EMPFEHLUNG der heutigen Vorlage selbst („Rotieren, und zwar jetzt — aber als Ein-Punkt-Zug in einem eigenen seriellen Slot, NICHT parallel zu einem Workflow", Zeile 51-56 der Vorlage). Er fuehrt einen DRITTEN, in der gesamten Vorgeschichte unbelegten Mechanismus ein: Infra-orchestriert, Owner-synchronisiert, gesperrtes Fenster — explizit begruendet mit der Parallel-Agenten-Lage („5 Agenten parallel"), die zur Zeit von KON22/KON58-04/KON64-01 (12.-15.08., vor der Fuenf-Agenten-Parallelisierung) noch nicht bestand. Der harte Beleg, der A4 heute kippt, ist selbst neu: **rest_karte_r3.md C11** (Anker Z.440-460) hat ERSTMALS den Mengentest gegen die HEUTIGEN Live-Token gefahren — „HEUTIGER TOKEN IST IN DER LECK-MENGE -> NICHT ROTIERT" fuer alle drei Projekte 286/288/289 — eine Verifikation, die weder KON22 noch KON58-04 noch KON64-01 durchgefuehrt hatten (dort blieb der Status durchgehend „ungeprueft", nie „geprueft und aktiv kompromittiert").

**UEBERHOLT-Marker-Liste:**
1. Ledger:3906-3907 (KON58-04, Fork „je Projekt vs. instanzweit"): UEBERHOLT durch D-3 (KON104-02, Ledger:134-136, „Wie empfohlen — instanzweit abschalten"). Marker fehlt an der Fundstelle.
2. Ledger:2753 (KON64-01, A4-Vormerkliste): NUR das Teilstueck „776er" ist durch A-1 (KON103-02) UEBERHOLT; der Rest der Liste (06.08.-Aera, 4 MinIO-Alt-Svcaccts, Root-Identitaets-Umzug, id=98-Turnus) bleibt gueltig aufgeschoben. Ohne Differenzierungs-Marker liest sich die Zeile heute so, als gelte die Pause fuer alle fuenf Positionen.
3. Ledger:8043-8046 (KON22-02, „Status ... UNGEPRUEFT"): UEBERHOLT durch die haertere 17.08.-Messung (aktiv nicht rotiert statt bloss ungeprueft) — genau dieser Unterschied traegt die heutige Eskalation.
4. `rest_karte_r3.md:459-460` selbst traegt bereits den Satz „Der Massstab kennt nur den offenen Posten ... (KON58-04) — nicht diesen Beleg" — dieser Ruecklauf ist nur im Backup verankert, nicht im Ledger an KON58-04 gespiegelt.

**Fehlende Bau-Folgen:** (a) keine der drei aelteren Ledger-Stellen traegt einen Vorwaertsverweis auf die Infra-Meldung vom 17.08.; (b) Task #54s bereits gebautes Rotations-Skript wird fuer die Runner-Registration-Tokens weder erwaehnt noch auf Wiederverwendbarkeit geprueft; (c) die A4-Vormerkliste braucht eine TEIL-Ausbuchung (nur „776er" raus).

---

## B-1 — C-3a-Tripwire ausloesen

**Owner heute (KON103-01, Ledger:216):** „B-1: Ja genau so wie empfohlen."

**VORGESCHICHTE (Fundstellen, chronologisch):**
- **KON45-02** (Ledger:5197-5221, vor 12.08.): ERSTE Dokumentation — „Der Code nennt die Luecke selbst: `active_organ_required()` global/leer, Tripwire :272-278 verlangt Owner-Paket-Entscheid VOR der ersten required-Deklaration." Eigener VORLAGE-Satz („Comp-Gate als eigener Posten — Empfehlung JA") war zu diesem Zeitpunkt selbst noch unbeantwortet.
- **KON47-03** (Ledger:5033-5046, Owner-Antwort ~11.08.): woertlich „Der Festplatten IO Ausbau ist eine Meta-Meta-Organ-Achse, die voll in alle anderen Genus Interface-Funktionen integriert werden muss. Daher ja, voll bauen wenn an der Reihe." — entscheidet den Vollbau (inkl. Comp-Gate) grundsaetzlich, laesst aber das TIMING offen.
- **C-3a-Vorlage #38a1** (13.08., Commit `136a1798`, `docs/plaene/20260813-OWNER-VORLAGE-c3a-comp-gate-paket-entscheid.md`): verdichtet beides zu EINER Frage, mit Owner-woertlichem Tripwire-Zitat aus `simd_build_gate.hpp:258-278` („C-3a-TRIPWIRE: ein Organ deklariert jetzt required-Flags ..."), EMPFEHLUNG JA, Frist Mi 19.08., Fallregel 18.6(3) fuer Schweigen.
- **KON89** (Ledger:1002-1026, 16.08.): „C-3a: Vorlage ... dem Owner in dieser Sitzung VOLLSTAENDIG praesentiert ... Antwort steht aus."
- **KON91-02** (Ledger:968-978, SPAETER am selben 16.08.): Owner „JA" (Original: „geau so wie empfohlen"): „Tripwire ausloesen + durch den Orchestrator-Weg ersetzen ... als EIGENES PAKET IM EINEN W1-BUMP-BUENDEL: #15/S-6 (Format 4->5, Layout 6->7) + #38a2 + #38d = EIN Bruch vor F2 (Fr 21.08.). Frist Mi 19.08. ERFUELLT, Fallregel 18.6(3) GEGENSTANDSLOS."

**DELTA — Deckungsgleich, NICHT erweitert:** KON91-02 (16.08.) und die heutige B-1-Antwort (KON103-02, Ledger:232-234: „JA WIE EMPFOHLEN — C-3a-Tripwire ausloesen, Ersatz = per-Binary-Orchestrator-Weg, gebuendelt im EINEN #15-Bruch (B-Plan: B-5-Umfeld). Der Frist-Posten Mi 19.08. ist damit VOR der Frist entschieden; die Fallregel (#38a2 -> W2) ist gegenstandslos.") sind in der Sache **identisch** — kein neues Element, kein neuer Umfang. Die einzigen Unterschiede sind notationell: die Plan-Adresse „B-5-Umfeld" (praeziser als KON91-02s Buendel-Aufzaehlung) und die ausgeschriebene Fallregel-Zielstelle „-> W2" statt der blossen Regelnummer. **B-1 ist der Sache nach eine Duplikat-Frage**: die heutige Vorlage zitiert in ihrem STAND-Text (Zeile 88-95) nur die 13.08.-Vorlage, erwaehnt KON91-02 (16.08., bereits JA) mit keinem Wort. Bemerkenswert: die SPAETERE, noch am selben Tag gelandete KON105-02 (Ledger:50-52) klaert das selbst auf — „C-3a-Vorlage #38a1 braucht KEINE neue Owner-Antwort: KON91-02 ... traegt die Semantik bereits — R4 ist RESTLOS ZU" — aber erst im R4-Kontext, nicht rueckwirkend an B-1/KON103 vermerkt.

**UEBERHOLT-Marker-Liste:**
1. `docs/sessions/20260817-OWNER-VORLAGE-fragenbuendel-parallelstart.md:83-103` (B-1-STAND): fehlender Verweis auf KON91-02 als bereits ergangene Antwort vom Vortag.
2. Ledger:232-234 (KON103-02, B-1-Buchung): fehlender Querverweis „= KON91-02, keine neue Substanz" (den KON105-02 an anderer Stelle bereits zieht, aber nicht hierher zurueckspiegelt).
3. Ledger:5219-5221 (KON45-02s eigener Vorlage-Satz „nur mit Provenienz-/Stempel-Semantik"): durch KON47-03 (Vollbau-GO) TEIL-UEBERHOLT, Marker fehlt unabhaengig von B-1.

**Fehlende Bau-Folgen:** Am Bauplan aendert sich nichts (Bruch bleibt #38a2+#38d+#15/S-6, Bau-Ort B-5-Umfeld, vor F2). Die einzige fehlende Buchung ist redaktionell: die doppelte Owner-Bestaetigung (16.08.+17.08.) sollte als EIN GO gefuehrt werden, sonst droht bei einer spaeteren Vollstaendigkeitspruefung eine Verwechslung mit einer tatsaechlich zweiten Entscheidung.

---

## C-1 — PMC fail-loud (a+b+c, mit Warnung) — KERN-BEFUND

**Owner heute (KON103-01, Ledger:217-219):** „C-1: (a) und (b) und (c) alle ja. Aber Warnung bei (c) wenn PMC vorhanden, aber nicht verwendet. Korrekt sonst, volles GO. Stille nullen gibt es bei Messung nicht, wir hatten fail loud ueber die letzten 10 wochen explore geplant."

**VORGESCHICHTE — die woertliche Hebung ueber 12 Wochen:**
- **13.07.2026** (Ledger:19028, „KERNFEATURE-BLOCK honest-100%-Doktrin"): AeLTESTE gefundene Grunddoktrin — User: „alles echt gemessen und validiert, nur honest-100% akzeptabel"; „honest-0 NUR wo genuin 0; **PMC/HW-Werte real verdrahtet lesen (Task #34)**." (~5 Wochen vor heute; das ist die Basis, auf die sich der Owner mit „ueber die letzten 10 Wochen" stuetzt.)
- **12.07.2026** (Ledger:18538-18541, „AKTUALISIERT 2026-07-12"): AeLTERE, gegenlaeufige Formel — „Reale Cache-Misses/PMC bleiben **honest-0 bis #26** (Intel-PCM/PAPI extern-gated)". **Praezisierung bei Nachpruefung:** an dieser Stelle steht Zeile 18542 tatsaechlich ein „[SUPERSEDED-Vermerk 2026-07-19 -> §33]" — sein WORTLAUT betrifft aber primaer, dass der golden-320-Lauf #9916 „nie persistiert" und „KEIN legitimer Systembeweis" ist, nicht wortwoertlich die PMC-Gating-Aussage selbst. Die Entwertung der „honest-0 bis #26"-Formel ist also eher FAKTISCH (durch die juengere F9-Pflicht ueberholt) als durch einen NAMENTLICH auf PMC zielenden Supersede-Text — ein Unterschied, den die 06.08.-Analyse (naechster Punkt) glaettend zusammenfasst.
- **16.07.2026, F9** (Ledger:19006): Owner woertlich — „Die Infra hat die Einrichtung schon seit Tagen fertig. NICHT mehr gegated, kann von MIR installiert werden und **MUSS als PFLICHT fuer die Vollstaendigkeit aller perf-Messwerte mit in die Ergebnisse**." Das ist das vom Owner heute referenzierte „Wort vom 16.07."; am selben Tag (Ledger:19005) wird I-PMC-1 GESETZT — und genau hier entsteht (noch unerkannt) die Wurzel des heutigen Defekts: die Pflicht wird an ZWEI Job-Namen gebunden (`measure:smoke`, `measure:golden-320`), nicht an eine Invariante.
- **06.08.2026 nachmittag-9/-10** (Ledger:24219-24268 + 24397-24402, „NACHTRAG 06.08.2026 nachmittag-10"): **VOLLSTAENDIGE technische Diagnose, 11 Tage vor heute**, mit EXAKT denselben vier Wachen, die die heutige Vorlage (Anker „nachmittag-10 E") erneut vorlegt:
  1. `experiment_plan_director.hpp` emittiert 4x `-DCOMDARE_V32_ENABLE=ON`, `grep -c COMDARE_ENABLE_PMC` = 0 (Z.24224-24230)
  2. `CMakeLists.txt:67` `option(COMDARE_ENABLE_PMC ... OFF)` — irrefuehrend als „Windows"-Option beschrieben, gated aber auch Linux (Z.24240-24242, dort bereits explizit als „eigener Risikofaktor" benannt)
  3. `m3v2_pmc_smoke.cpp:71` laesst Nullzaehler als „bestanden" durch
  4. die eigens gebaute #37-PMC-Preflight-Wache selbst (`linux_perf_pmc_smoke.cpp:58-63`) gibt bei fehlendem Zugriff `SMOKE_SKIP`/`return 0`, obwohl ihr eigener Kommentar die Gefahr woertlich benennt (Z.24224-24246).
  WURZEL bereits hier: „die PMC-Pflicht war an ZWEI JOB-NAMEN geheftet statt an eine Invariante" (Z.24249-24254). Die F9-Quelle wird hier woertlich zitiert, UND die „honest-0 bis #26"-Gegenstelle wird hier bereits als „vier Tage aelter ... SUPERSEDED-Vermerk vom 19.07." entwertet (Z.24256-24263) — **wort-fuer-wort dieselbe Analyse**, die `rest_karte_r3.md` (17.08.) als Fragenbuendel-STAND fuer C-1 nutzt.
  Ebenda, Abschnitt H (Z.24397-24402): „Zu entscheiden sind **DREI Dinge, nicht eins**: (1) das Flag ... als Invariante ... (2) die Wache so drehen ... (3) der Anhangs-Umfang angesichts I-PMC-2/3." — die woertliche Vorlaeuferin der heutigen a/b/c-Struktur.

**DELTA der heutigen Antwort:** Die technische Diagnose (vier Wachen, Wurzel=Job-Name-Bindung, F9-Pflicht) ist am 17.08. **inhaltlich null neu** — sie ist eine 11 Tage alte, bereits vollstaendig fertige Analyse, die nie in einen Fix umgesetzt wurde. Die ECHTE Praezisierung liegt an zwei Stellen: **(1)** die 06.08.-Dreiteilung trennte „Invariante / Wache-dreht / Anhangs-Umfang"; die heutige Dreiteilung lagert den Anhangs-Umfang als EIGENE Frage aus (das ist heute C-2) und ersetzt Punkt 3 durch eine neue Frage — darf ein Lauf OHNE PMC ueberhaupt gueltig gebucht werden? Diese Buchbarkeits-Frage hat in der gesamten Vorgeschichte (13.07./16.07./06.08.) **kein Vorbild**. **(2)** Die Owner-Antwort auf (c) ist keine einfache Ja/Nein-Auskunft, sondern fuegt eine vierte, nirgends vorgezeichnete Feinheit hinzu: eine **Warnung** spezifisch fuer den Fall „PMC vorhanden, aber nicht verwendet" — unterschieden vom Fall „PMC-Quelle fehlt" (= Fehler). Diese Drei-Wege-Unterscheidung (Fehler bei fehlender Quelle / Warnung bei ungenutzter vorhandener Quelle / stiller Normalfall bei aktivem PMC) ist der einzige inhaltlich neue Beitrag der heutigen Runde.

**UEBERHOLT-Marker-Liste:**
1. Ledger:18538-18542 (12.07./19.07.-Superseded-Absatz): der Supersede-Text zielt nachweislich auf golden-320-als-Systembeweis, nicht namentlich auf die PMC-Gating-Formel — eine PRAeZISIERE Supersede-Notiz direkt an der „honest-0 bis #26"-Teilzeile fehlt bis heute.
2. Ledger:24219-24268 + 24397-24402 (06.08. nachmittag-10, PMC-Diagnose): traegt keinen Vorwaertsverweis auf C-1/KON103 (17.08.) oder Task #83 — die Diagnose steht seit 11 Tagen unangetastet im Ledger, ohne dass eine der vier Wachen seither beruehrt wurde; ein Liegenzeit-Marker fehlt.
3. `CMakeLists.txt:67` (Code-Kommentar „Intel PCM Windows cache-miss source"): seit mindestens 06.08. als irrefuehrend dokumentiert (Z.24240-24242), am Objekt bis heute nicht korrigiert.
4. `experiment_plan_director.hpp:1352-1360` (Preflight-Kommentar, der die Gefahr korrekt beschreibt, aber neben einer sie nicht abfangenden Wache steht): Diskrepanz seit 06.08. bekannt, kein Marker am Code selbst.

**Fehlende Bau-Folgen:**
- Die vier nicht-beissenden Wachen sind seit 06.08. exakt lokalisiert (`CMakeLists.txt:67`, `m3v2_pmc_smoke.cpp:71`, `linux_perf_pmc_smoke.cpp:58-63`, die 4 Emissionsstellen in `experiment_plan_director.hpp`) — Task #83 nennt bislang nur „Invariante + Fehler-statt-Skip + Teil-Lauf-Warnung" OHNE diese vier Fundstellen zu uebernehmen. Sie sollten 1:1 in den #15-Bruch uebernommen werden statt erneut gesucht zu werden.
- Die neue Warnungsanforderung („PMC vorhanden, nicht verwendet") braucht einen eigenen Signalpfad (WARN-Log/CSV-Flag), der in keiner der vier bestehenden Wachen vorgesehen ist — ein echter NEUER Baustein, keine blosse Umpolung.
- Der AMD-`errno=2`-L3-Fall (`pmc_cache_misses_l3` faellt auf AMD still auf 0, Intel populiert Millionen) ist ein dritter, von a/b/c noch nicht scharf erfasster Unterfall: „PMC-Quelle systemweit vorhanden, aber EIN Zaehler liefert errno" — weder klar „fehlende Quelle" (Fehler) noch klar „vorhanden-aber-ungenutzt" (Warnung). Diese Klassifikationsluecke fehlt in der heutigen Buchung.

---

## C-2 — I-PMC-2/3 bauen, „volles Programm, NICHTS nach der Abgabe"

**Owner heute (KON103-01, Ledger:219-222):** „C-2: Wir lassen nichts weg und machen NICHTS nach der Abgabe, es gibt also nur vor der Abgabe, volles Programm bitte. Ja krischer Pfad muss gegangen werden, egal was."

**VORGESCHICHTE (dokumentierter Bau-Weg):**
- **16.07.2026** (Ledger:19005, im selben Nachtrag wie I-PMC-1-Abschluss): „Offen: I-PMC-2 (L3-Mapping+branch_misses) · I-PMC-3 (#187 L2+coherence via Zen-5-RAW) · Standalone-Preset." — I-PMC-2/3 werden am Tag der I-PMC-1-Fertigstellung bereits als Restposten benannt.
- **16.07.2026** (Ledger:19899, Prioritaetenliste desselben Nachtrags): „4. F9 I-PMC-2/3 (L3-Mapping/branch_misses · L2+coherence Zen5-RAW = #187)" — Prioritaet 4 von 10, nach der Bruecken-Increments-Arbeit.
- **~20.-23.07.2026** (Ledger:21049, 21390, Konformitaets-/Statusregister): „[§12-PMC] I-PMC-2 (L3+branch_misses) / I-PMC-3 (#187 L2+coherence Zen-5-RAW) (**TEIL, hoch**)" — formal gefuehrter, hochpriorer offener Posten.
- **06.08.2026 nachmittag-10** (Ledger:24265-24268): „I-PMC-2 BLEIBT OFFEN, und das begrenzt den Anhang: auch mit Flag bleiben L3, L2, coherence und energy auf 0 ... Der Anhang kann also selbst im besten Fall nur L1D + dTLB zeigen — das gehoert **vor Phase 6 entschieden, nicht nach der Messung entdeckt**." — woertliche Vorlaeuferin der heutigen „WENN OFFEN"-Warnung im Fragenbuendel (identischer Wortlaut).
- **~06.08.2026** (Ledger:25009, „6 TRIGGER-/ABGABE-RELEVANTE VERGESSENE POSTEN"): **V-08** woertlich — „#152 Cache-Misses als Kernmetrik + I-PMC-2/3 — sonst wird mit einer als Kernmetrik deklarierten Groesse = 0 ausgewertet." Das ist exakt das V-08-Zitat, das die heutige Fragenbuendel-STAND-Sektion fuer C-2 anfuehrt.

**DELTA:** In der gesamten Vorgeschichte (16.07. bis 06.08., vier unabhaengige Fundstellen) wird I-PMC-2/3 durchgaengig als zu bauender Restposten gefuehrt — an KEINER Stelle taucht vor heute der Gedanke auf, die „Cache-Misses als Kernmetrik"-Zusage stattdessen zurueckzunehmen. Diese Rueckzugs-Option ist eine genuin NEUE Empfehlung der heutigen Vorlage selbst (nicht der Vorgeschichte), die der Owner explizit zurueckweist. Die heutige Antwort praezisiert die Vorgeschichte also nicht durch neue Inhalte, sondern durch (a) die explizite Ablehnung einer heute erst vorgeschlagenen Abschwaechung und (b) eine neue, konkrete Terminzusage, die die Vorgeschichte nie kannte: „eigener Slot vor W3 ... Vorstaffel WE 22./23." (KON103-02, Ledger:245-246) — die aeltere Fuehrung als „TEIL, hoch" oder „Prioritaet 4" enthielt nie ein Datum.

**UEBERHOLT-Marker-Liste:**
1. Ledger:21049/21390 („I-PMC-2/3 ... TEIL, hoch"): unveraendert seit ca. 20.-23.07., kein Terminbezug — sollte den 22./23.08.-Slot nachtragen.
2. Ledger:19899 Punkt 4: Teil einer seit 4,5 Wochen statischen To-do-Liste — durch die heutige Terminierung TEIL-UEBERHOLT.
3. `Code/04_csv_to_latex/csv_to_latex.cpp:985-986` (Generator-Text, bereits per D-18/Ledger:26586-26608 als „dreht die Ehrlichkeits-Korrektur still zurueck" gefuehrt: „Cache-Misses (Kernmetrik): ... = 0 / nicht erhoben"): durch den heutigen „volles Programm"-Entscheid bekommt diese seit 07.08. bekannte Generator-Luecke zusaetzliches Gewicht — die Kernmetrik-Zusage wird JETZT definitiv nicht zurueckgenommen, der Generator wuerde sie bis zum I-PMC-2/3-Bau aber weiter als „nicht erhoben" ausgeben.

**Fehlende Bau-Folgen:**
- Der 22./23.08.-Slot kollidiert terminlich mit dem in A-1 verhandelten Infra-Wartungsfenster UND mit S-19 (Planungs-Simulation, Task #7, ebenfalls Sa 22.-Mo 24.08.) — eine explizite Kollisionspruefung fehlt in der heutigen Buchung.
- Die Zen-5-RAW-Abhaengigkeit von I-PMC-3 wurde weder 16.07. noch 06.08. technisch nachrecherchiert (durchgehend als „offener Ausgang" gefuehrt) — ein Deep-Research-Auftrag vor dem 22.08.-Slot fehlt als Bau-Vorbedingung.
- Der Generator-Nachzug (`csv_to_latex.cpp:985-986`) sollte in denselben Bau-Zug wie I-PMC-2/3 gebuendelt werden, damit Textaussage und Messvermoegen nie auseinanderlaufen — diese Buendelung ist bislang nicht verbucht.

---

## C-3 — best_binary-Richtungen: nur Pruefung der Katalog-Haertungs-Zeile

**Owner heute (KON103-01, Ledger:222):** „C-3: Es gibt dazu immer noch einen deep research workflow, bitte selbst tief lesen." (Inhaltlich bereits tief gelesen; Auftrag hier: hat die „Katalog-Haertungs-Zeile [static_assert je Metrik gegen Katalog]" eine Vorgeschichte?)

**Objekt-Stand am Code:**
- `best_binary_selector.hpp:244-261`: `metric_direction()` liefert fuer ALLE SECHS Metriken (`ns_per_op`, `insert`, `lookup`, `erase`, `scan`, `rmw`) hart `Minimize` — inklusive stillem `Minimize`-Fallback (Z.261) fuer unbekannte Metriken.
- `test_best_binary_selector_parse_rank.cpp:21-60` — das bestehende „K-5-Paritaets-Gate" (Kommentar datiert **2026-07-19**): static_assert-ABI-Spiegel (kAbiMajor/Minor/Magic) + static_assert Enum-Gleichheit (Minimize/Maximize-Werte) + **genau EIN** static_assert, dass `metric_direction(lookup)` dem Katalog-Zeugen T0 `lookup_latency` (MIN) folgt + **ein zweiter**, der NUR beweist, dass die Enum-Klasse ueberhaupt eine MAX-Richtung tragen KANN (Katalog-Zeuge T6 `alloc_throughput` — eine METRIK, die gar nicht zu den sechs Selektor-Metriken gehoert).

**VORGESCHICHTE (nur zur Haertungs-Idee):**
- **09.08.2026** (`docs/sessions/20260809-KONFORMITAETS-REGISTER-teil2-stationen-5-bis-8.md`): „DER PRODUKTIVE SELEKTOR KANN DIE PARETO-ACHSEN GAR NICHT AUSDRUeCKEN ... es sind sechs Latenz-Spalten. T5 ... T6 ... T18 ... haben nicht eine einzige Spalte im Mess-Schema." — stellt bereits fest, dass alle sechs Metriken strukturell gleichgerichtet sind und T5/T6/T18 im Mess-Schema gar nicht vorkommen.
- **19.07.2026** (Code-Datierung des K-5-Paritaets-Gates selbst): das Spiegel+static_assert-MUSTER existiert bereits als Vorbild (K-5-ABI-Spiegel-Analogie).
- **07.08.2026 Welle A** (Ledger:26539-26561, ce `875a57cd`): T-9-Katalog (45 Zielgroessen, 17 MAX/28 MIN) wird in `break_even.hpp` integriert (NICHT in `best_binary_selector.hpp`); Pareto-Achsen T5/T6/T18 erhalten einen eigenen static_assert-Riegel dort.
- **07.08.2026 Welle C** (Ledger:26671-26680, ce `21560a2e`): `best_binary_selector` bleibt bewusst SPIEGEL (C++17 self-contained); der Test haelt „ein echtes Paritaets-Gate: ... Enum-Gleichheit + **zwei** Katalog-Zeugen per static_assert" — exakt der oben beschriebene, unvollstaendige Ist-Zustand.
- **KON45-02/D-04/G-3** (Ledger:5197 ff., 26559, 27412, mehrfach 07./09.08. wiederholt): „`best_binary_selector.hpp:236-254`: alle sechs Metriken hart Minimize" wird wiederholt als AUDIT-BEFUND/Diskrepanz zum Katalog benannt — nie als Auftrag „static_assert je Metrik".

**Befund:** Eine dezidierte Vorgeschichte fuer „static_assert je der sechs Metriken gegen den Katalog" (statt nur 1 echter + 1 Existenz-Zeuge) wurde **nicht gefunden** — weder im Ledger noch in `docs/sessions/` oder `docs/plaene/`. Vorhanden sind ausschliesslich (a) das allgemeine Paritaets-Gate-MUSTER (19.07.) und (b) der wiederholt bestaetigte BEFUND, dass alle sechs hart `Minimize` sind (07./09.08.) — die konkrete Haertungs-Idee selbst (Ausweitung von 1 auf 6 static_asserts) formuliert erstmals die heutige Vorlage („Ich lege dir die sechs Metriken einzeln ... vor"). Der Owner-Verweis auf den „deep research workflow" deckt sich der Sache nach am ehesten mit `docs/audits/20260709-pareto-objectives-t6-t18-t5-BEFUND.md` (RUM-Konjektur, EDBT 2016) — dieser behandelt aber die BREITEN T5/T6/T18-Pareto-Achsen, nicht spezifisch die sechs Selektor-Latenzmetriken.

**UEBERHOLT-Marker-Liste:**
1. `test_best_binary_selector_parse_rank.cpp:56-60` (Kommentar „Gegenprobe, dass der Spiegel eine MAX-Richtung ueberhaupt tragen KANN"): ehrlich, aber unvollstaendig dokumentierter Zustand — braucht bei Bau einen Nachtrag „erweitert auf alle sechs Metriken".
2. Kein einzelner Ledger-Eintrag fasst KON45-02/D-04/G-3/09.08.-Register zu EINEM Befund zusammen — vier unabhaengige Fundstellen desselben Tatbestands ohne Querverweis.

**Fehlende Bau-Folgen:**
- Falls „alle sechs bleiben MIN" bestaetigt wird (vom 09.08.-Befund gestuetzt: „sechs gleichgerichtete Latenzen"), ist der Bau NICHT eine Richtungsaenderung, sondern die Erweiterung des Paritaets-Gates von 1 auf 6 static_asserts — dieser konkrete Baustein fehlt bislang sowohl im D-04/G-3-Befund als auch im heutigen C-3-Bauplan (KON103-02, Ledger:247-249 spricht nur allgemein von „Richtungs-Fix im Bruch-Umfeld").
- Die 09.08.-Erkenntnis (T5/T6/T18 haben null Spalten im Mess-Schema) ist eine Bau-Abhaengigkeit, die C-3 nicht loesen kann: eine vollstaendige Pareto-faehige Selektor-Haertung braucht zuerst eine Mess-Schema-Erweiterung fuer diese drei Achsen — diese Abhaengigkeit ist in der heutigen Buchung nicht ausgewiesen.

---

## GEPRUEFT

Alle fuenf Entscheide (A-1, B-1, C-1, C-2, C-3) wurden gegen Ledger, Plaene, Sessions und Code am Objekt geprueft, mit Datei:Zeile- bzw. KON-Ankern belegt. Eine Einschraenkung: die SUPERSEDED-Vermerk-Praezisierung bei C-1 (Ledger:18538-18542) wurde bewusst als Nuance ausgewiesen statt unkritisch aus der 06.08.-Analyse uebernommen — der Marker existiert nachweislich am Objekt, sein Wortlaut zielt aber primaer auf golden-320-als-Systembeweis, nicht namentlich auf die PMC-Gating-Formel. C-3 wurde nur im angeforderten schmalen Umfang (Katalog-Haertungs-Zeile) tiefgepruft, nicht in voller Breite der sechs Richtungs-Fragen (per Auftrag „bereits tief gelesen 17.08.").