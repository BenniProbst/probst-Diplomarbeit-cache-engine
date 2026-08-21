# KONSOLIDIERT: docs (Wellenplan + Register + Memory/Tasks) — Vollaudit 20260820

Quellen (alle VOLLSTAENDIG gelesen, Z1-Ende, vor Dedup):
- `leser-wellenplan.md` — 929 Rohposten (Extraktion aus `docs/plaene/20260808-WELLENPLAN-ENDFASSUNG-v2-geschaerft-fable5.md`, 3627 Z.)
- `leser-register.md` — 439 Rohposten (Extraktion aus `docs/sessions/20260818-SESSION-REGRESSIONEN-bump15-codex-audit-review.md`, 1294 Z.)
- `leser-memory-tasks.md` — 404 Rohposten (Extraktion aus MEMORY.md + MEMORY-DETAIL.md + task_board_dump.md)

Roh-Summe = 929 + 439 + 404 = **1772 Posten**.

## Methodik

**Dedup-Scope:** Zusammengefuehrt werden Zeilen, die denselben realen Gegenstand beschreiben — erkannt an einem gemeinsamen, eindeutigen Bezeichner (Task-#, OV-#, Owner-Doktrin-Titel, benanntes Objekt wie `checkpoint_measure`/`seg1-37`/`C-3a`) UND inhaltlich uebereinstimmendem Text (nicht nur Zahlengleichheit — s. Namenskollisions-Warnung unten). Der Schwerpunkt liegt auf QUELLEN-UEBERGREIFENDEN Duplikaten (derselbe Posten in 2 oder 3 der drei Leser-Dateien); vereinzelt wurden auch eindeutige INNERHALB einer Quelle liegende Fortschreibungs-Paare zusammengefuehrt (z. B. EIN-BLECH-REGEL, OV-5/prod2), wo Ausgangs- und Korrektur-Zeile denselben Gegenstand tragen. NICHT aufgeloest wurden die vielen MARKER-/PRAEZISIERUNGS-/UEBERHOLT-Ketten, mit denen `leser-wellenplan.md` und `leser-register.md` die Chronologie ihres jeweiligen Quelldokuments selbst schon nachzeichnen (dort steht das Fortschreibungs-Verhaeltnis bereits explizit in der Zeile) — deren Kollabierung waere eine Neuinterpretation der Quelldokumente selbst und damit ausserhalb des Auftrags "Leser-Dateien konsolidieren".

**Status-Konflikt-Regel:** Bei widerspruechlichem Status gewinnt die JUENGSTE Quelle (jeweils anhand des Datums/Snapshots der konkreten Passage, nicht des Dateidatums pauschal — `task_board_dump.md` ist mit Stand 20.08. ~15:30Z i. d. R. der juengste Task-Status; `leser-register.md` Abschnitt 13.x reicht bis Z1294/19.08. spaet; `leser-wellenplan.md` Abschnitt §22/§23 (par.21-23) ist nach dem Register-Audit datiert). Der juengste Status steht vorn, der Konflikt wird in der Status-Zelle AUSGEWIESEN, nicht stillschweigend verworfen.

**Namenskollisions-Warnung:** `leser-wellenplan.md` verwendet in §13-18 (KON27-04-Prioritaetsliste, datiert ~11.-13.08.) eine FRUEHERE `#N`-Nummerierung, die mit der SPAETEREN dauerhaften Task-Board-Nummerierung (`#1`-`#106`, ab §19 sowie in Register/Memory-Tasks verwendet) teils IDENTISCHE Nummern fuer ANDERE Gegenstaende vergibt. Bestaetigte Kollisionen: `#83` (fruehe Wellenplan-Zeile Z1470 = "lint:format ohne lokale Deckung"; aktuelles Board-#83 = "PMC fail-loud-Paket"), `#87` (fruehe Wellenplan-Zeile Z1483 = "Funktions-Variablen in Stufigkeits-Ordnung"; aktuelles Board-#87 = "Talos-Lane D-5"). In beiden Faellen wurden NUR die textlich uebereinstimmenden Zeilen zusammengefuehrt; die frueh-nummerierten Fremdposten bleiben als eigene Einzelquellen-Zeile in Teil B stehen, unverbunden.

**Spaltenformat:** Vereinigungsschema der drei Quell-Tabellen (Wellenplan hat zusaetzlich `Welle`; Register/Memory-Tasks nicht — dort mit `—` aufgefuellt) plus neue Spalte `Quellen`:

`KUERZEL/Name | Klasse | Welle | Quelle (Z-Anker) | Status LAUT QUELLE | Traeger/Task | Quellen`

## Teil A — Zusammengefuehrte Gegenstaende (quellenuebergreifender Dedup, 36 Cluster aus 113 Rohzeilen)

| KUERZEL/Name | Klasse | Welle | Quelle (Z-Anker) | Status LAUT QUELLE | Traeger/Task | Quellen |
|---|---|---|---|---|---|---|
| Task #15 / Bump15-Preimage-Bruch (S-6-Fenster, Bump-Buendel) | AUFGABE | W1 (vor F2) | WP-Z3469-3472 · R-Z6-9 · MT-task_board_dump:44 | GELANDET (Memory-Tasks-Board 20.08. 15:30Z = juengste Quelle: "alle CIs SUCCESS") — **KONFLIKT ausgewiesen:** Wellenplan (§23, ~19.08. frueh) und Register (Sec.1, ~18.08.) zeigten zu ihrem jeweiligen Snapshot noch OFFEN/UNGELANDET (Fix-Strecke2 NULL_NEUE_FUNDE, Voll-Abnahme lief); Board-Endstand dokumentiert die seither erfolgte Landung | wt-ce-bump15 -> ce/development; Ledger KON119 | Wellenplan, Register, Memory/Tasks |
| Task #17 / g2-Strang (W1-V1) | REGRESSION (Audit-Befund, behoben) / AUFGABE | W1 | WP-Z2971-2976+Z3465-3468 · R-Z175-180(3b) · MT-task_board_dump:44 | GELANDET — alle 3 Quellen konvergieren im Endstand (ba33b9ac, CI 16029 SUCCESS). Historie: urspruenglich KRITISCH/UNGELANDET (1528f6fd nicht Ancestor von development), am 19.08. gelandet+gepusht, g2-Schlussstueck TERMINAL SUCCESS 20:23Z | gibt #7/S-19 frei (KON17-01) | Wellenplan, Register, Memory/Tasks |
| Task #93 W1-Vollstaendigkeits-Audit | AUFGABE | W1 | WP-Z2983-2989 · R-Z185-189(3b)+Z394-398(Sec.9) · MT-task_board_dump:44 | GELANDET (Resultat vorliegend, wf_ca507b8f-Resume, 9/9 Agenten, 19.08. ~21:00) — konsistent; Wellenplan-Snapshot zeigte zuvor GEPLANT, Register zeigte zuvor GEPLANT (Start nach Review-/Audit-Ruecklauf) | workflows/scripts/w1-vollstaendigkeit-wf.js | Wellenplan, Register, Memory/Tasks |
| #3 S-12 CI-Geruest (Mini-Pipelines je Traeger) | AUFGABE | W2 | WP-Z2253 · MT-task_board_dump:5 | OFFEN (Landung Di 25.08.) — konsistent | KON25-04/-08 · KON43-02 · KON55/T-11b; Vorbau @731b5655; -> #106 (Dual-Compiler) | Wellenplan, Memory/Tasks |
| #7 S-19 Planungs-Simulation (produziert B-4-Zahl) | AUFGABE | W2 | WP-Z2249 · MT-task_board_dump:6 | OFFEN (Sa 22.-Mo 24.08., frei seit #15/#17) — konsistent | KON37-03 · KON30-03 · KON42-01/3; haengt an Stempel-Strecke komplett | Wellenplan, Memory/Tasks |
| #13 T-15b-Umzug (Retry-Klammer 5x) | AUFGABE | W2 | WP-Z2250 · MT-task_board_dump:7 | OFFEN (binary-beruehrend vor Trigger) — konsistent | KON37-06 · KON26-04/28-02 | Wellenplan, Memory/Tasks |
| #18 S-13 Export-Element+Ziel-Filter+per-Binary-XLSX | REGRESSION (heilt cfg.measurement_sink) / AUFGABE | W2 | WP-Z2254 · MT-task_board_dump:8 | OFFEN (Di 25.08., engster Slot) — konsistent | KON32-01 Owner "nur per Binary xlsx" | Wellenplan, Memory/Tasks |
| #19 main-FF beider Repos | AUFGABE | W2 | WP-Z2257 · MT-task_board_dump:9 | OFFEN — konsistent; Memory-Tasks praezisiert: Blocker #31 completed, kumulative Hygiene + volle SHA davor | KON27-04 P.10; davor Diff-Hygiene-Wache ueber kumulativen FF-Bereich | Wellenplan, Memory/Tasks |
| #22 OD-7 (Infra-Haelfte HEAVY_J 24->16 + --debug-CLI-Haelfte) | AUFGABE | W0b + W2 | WP-Z2217+Z2255 · MT-task_board_dump:10 | IN_PROGRESS (Memory-Tasks, juengste) — Wellenplan zeigte beide Teilstuecke einzeln als GEPLANT | KON26-05/28-01 (Infra, Handout dc8c0dc5) · KON34-05 (CLI, "beschleunigt, leitet nie um") | Wellenplan, Memory/Tasks |
| #24 Mess-Schalter B1-B5 (Schalter-Hoheit CEB/Hybrid) | AUFGABE | W1/W2 | WP-Z2227+Z2228+Z2229+Z2230+Z2256+Z2310 · MT-task_board_dump:11 | Aufgeschluesselt, kein echter Konflikt: B2 GELANDET (MT #24-B2, "NAECHSTER BAU" laut Wellenplan zuvor); B1/B3/B4/B5 bleiben OFFEN mit denselben Teilbedingungen (B1 W1-Ende, B3 Owner-Datum vor F2, B4=W2/OF-1, B5 nach S-5/KON119) — Memory-Tasks fasst dies korrekt als Gesamt-OFFEN zusammen | KON34-04-B1..B5 · KON37-01/-02/-03 · KON38 (Fable max fuer B5) | Wellenplan, Memory/Tasks |
| #28 TEST-KONSOLIDIERUNG | AUFGABE | W2 | WP-Z2258 · MT-task_board_dump:12 | OFFEN (Dauerposten mit S-16 bis W4) — wortgleich | KON37-08 Owner "jeden Test pruefen"; haengt an #29-Zielstruktur · S-16/#88 | Wellenplan, Memory/Tasks |
| #38a2 Comp-Gate-Stempel-Anteil (organ_stamp_line je COMP) | REGRESSION/UNKLAR | W1 | WP-Z2233 · R-Z334-337(E4)+Z638(seg1-48) · MT-task_board_dump:13 | UNKLAR — im Kern konvergent ("nicht sicher gebaut"), aber kein finaler Beleg: Wellenplan OFFEN(P)/Owner-Paket-Entscheid noetig; Register-Audit zweifach negativ (E4 "fehlt trotz Buchung IM EINEN W1-BUMP-BUENDEL"; seg1-48 "0 Treffer im Diff"); Memory-Tasks (juengste, 20.08.) bestaetigt offen: "im Bump-Buendel gelandet? -> Audit noetig" | KON45-02/2 · KON47-03; C-3a-Tripwire; Fallregel 18.6(3) | Wellenplan, Register, Memory/Tasks |
| #38b Warmup-Paar (alle Messpfade verwerfen+speichern x3) | REGRESSION/AUFGABE | W2 | WP-Z2251 · MT-task_board_dump:13 | OFFEN (W2 Sa/So) — konsistent | 🔴 KON47-04 Owner "SONST IMMER ZWEI MAL. PFLICHT FUER DIE FORSCHUNG."; Tests T-1...T-9 | Wellenplan, Memory/Tasks |
| #38d Preimage-Budget (kAnatomyFingerprintPreimageMax 4096 bei 32 Docks) | REGRESSION | W1 | WP-Z2232+Z2349-2350(A-02) · MT-task_board_dump:13 | GELANDET (im Bruch gelandet, Memory-Tasks juengste) — Wellenplan-Planungs-Snapshot zeigte zuvor OFFEN(P); Register bestaetigt an anderer Stelle (POSITIV-Bestaetigung) Budget 6057 nachgerechnet | KON45-01/5 "Pflicht-Edit MIT Budget-Beleg" | Wellenplan, Memory/Tasks |
| #38a3 IO-Vollausbau | AUFGABE | W7 | WP-Z2265+Z2267-2269 · MT-task_board_dump:13 | OFFEN (W7) — konsistent; Wiederaufnahme-Marker 18.08. bestaetigt Verbleib in W7 | KON47-03/27-04 P.12/37-07 | Wellenplan, Memory/Tasks |
| #65 PRT-ART Nachstufe (cmake-Ladeweg-Fix+Ladebeweis) | AUFGABE | W1 | WP-Z2316 · MT-task_board_dump:19 | IN_PROGRESS (Memory-Tasks, juengste) — Wellenplan-Snapshot zeigte GEPLANT (W); Rest laut Memory-Tasks: 10W-Planungs-Explore+Aufraeumen+V1-Diskrepanz | Waisen-Archiv | Wellenplan, Memory/Tasks |
| #69 Messwert 750-vs-1310 (+prod2-TeX) | AUFGABE/REGRESSION | W2 | WP-Z2317 · MT-task_board_dump:20 | OFFEN-REGRESSION (Diskrepanz, prod2-TeX-Probe aussteht) — konsistent; Memory-Tasks praezisiert Klasse als REGRESSION (Wellenplan neutraler als AUFGABE gefuehrt, kein Widerspruch, nur Klassenschaerfung) | #41-Nachlauf; vor W3 | Wellenplan, Memory/Tasks |
| #71 Leser-Hebungs-Triage | AUFGABE | W2 | WP-Z2319 · MT-task_board_dump:21 | OFFEN — konsistent (KON-15/43/44 + machines + concurrency-Vorlage) | — | Wellenplan, Memory/Tasks |
| #74 Repo-Rollen-Umbau (XSD-Hoheit -> ce, F6) | AUFGABE | W2 | WP-Z2320 · MT-task_board_dump:22 | OFFEN — konsistent (W-G-Karte liegt, 15 CE-Kandidaten) | — | Wellenplan, Memory/Tasks |
| #87 Talos-Lane D-5 (Debug-Messung mit Core-PMC) | AUFGABE (Task) / REGRESSION (Plan-Fehler, behoben) | Infra / W7 | WP-Z3571-3572(L7) · R-Z1000-1003(K10-13) · MT-task_board_dump:29 | OFFEN (Task selbst: Voraussetzung Talos v1.13.x/Infra) — der zugrundeliegende PLAN-FEHLER ("Debug-Messung OHNE PMC" beruhte auf veraltetem v1.12-Stand) ist laut Register BEHOBEN (korrigiert+getrackt als #87, Owner-Einspruch bestaetigt); die Task selbst bleibt offen | L7 Kernel-Fixes (perf_event_paranoid 3->0/1, nmi_watchdog 1->0) im Infra-Fenster Do 20.08. ergaenzt | Wellenplan, Register, Memory/Tasks |
| #94 C-F4 Abi7-Freeze-Historie kapseln | REGRESSION | W2 | WP-Z3046-3050 · R-Z122-125(Sec.2)+Z526-527 | OFFEN (VERTAGT als Fixstrecke1-Ausnahme -> W2-Task; Task inzwischen angelegt) — konsistent | decl.hpp:~780/:784; koppelbar mit decl.hpp:797-Rest | Wellenplan, Register |
| #95 V-08R (fingerprint_sha-Formfrage) | REGRESSION | W1 | WP-Z3052-3056+Z3154 · R-Z339(E8)+Z519-521(seg1-40)+Z1125-1129(X-8)+Z1233-1235(13.5) · MT-task_board_dump:44 | GELANDET (16045, Memory-Tasks juengste) — **mit Vorbehalt ausgewiesen:** Register 13.5 (spaeteste Register-Passage) haelt fest "Fix-Tip 0f0742aa OHNE dokumentierte Abnahme"; Wellenplan-Vorlagepunkt P5 (Form 64-Hex vs. 128-Hex-S-1-Vertrag) war beim Wellenplan-Snapshot noch OFFEN. Board-"GELANDET" deckt die Code-Landung, NICHT nachweislich die Abnahme-Dokumentation | wt-ce-v08r -> Bruch; zusammen mit #94 angelegt | Wellenplan, Register, Memory/Tasks |
| #98 F-07b Diagramm-Bau + Wellenplan-Par.5-Arithmetik-Korrektur | FEATURE (Diagramme) + REGRESSION (Arithmetik) + REGRESSION (Fehl-Autorisierung, behoben) | W4 | WP-Z998(x2)+Z2900-2901+Z3066-3069 · R-Z1048-1049(K13-7) · MT-task_board_dump:37(x2) | OFFEN / OFFEN-REGRESSION (Memory-Tasks, beide Teilzeilen) — Historie: F-07b war Owner-KERN-PFLICHT (06.08., 2D+3D SOTA-orientiert), wurde mit ERFUNDENER Autorisierung ("Streichkaskade bestaetigt", 0 Owner-Belege) faelschlich nach W7 verschoben — dieser Fehlgriff ist BEHOBEN (UEBERHOLT-Marker ff64fe0e, Task #98 angelegt); die eigentliche Bau-Arbeit bleibt offen | mit ##60; par.5-Marker super 9015a0de | Wellenplan, Register, Memory/Tasks |
| #102 golden-Zug F6 (EIN golden-Ereignis: B-9+A-11+B-10.3+B-11.2) | AUFGABE | — | R-Z413(9.1(4))+Z1252-1255(13.8[A1]) · MT-task_board_dump:44 | GELANDET (Memory-Tasks, juengste) — Register-Snapshot zeigte LAEUFT (wf_77867329, Frist Do 20.08.) | TABU-Anker 0x56F1B721C72DC10E + Emissions-CRC 0xF1C1F26A1232073B; Lock-Regen NICHT darin enthalten | Register, Memory/Tasks |
| #70 XorFilter-Korrektheit | REGRESSION -> FEATURE | W1 | WP-Z2318 · MT-task_board_dump:44 | GELANDET (Memory-Tasks, juengste, KON116) — Wellenplan-Snapshot (§18, 16.08.) zeigte OFFEN (P-nah, 30/256 Falsch-Negative, VOR naechster Messung zu klaeren) | — | Wellenplan, Memory/Tasks |
| VERTAGT = NUR ZWISCHENZUSTAND (Owner-Dauerregel) | OWNER-ENTSCHEID | — | WP-Z3189-3191((4) im par.22-Sweep) · MT-MEMORY.md:25 | GELANDET/BINDEND — wortgleiche Owner-Order vom 19.08. in beiden Quellen (Wellenplan zitiert explizit den Memory-Anker `vertagt_ist_nur_zwischenzustand`): "vertagt=NUR Zwischenzustand — landen, Vertagte durchziehen, NACHLANDEN" | — | Wellenplan, Memory/Tasks |
| NIE KUERZEN — Kette voll, alle Features (Owner-Dauerregel) | OWNER-ENTSCHEID | — | WP-Z2887-2894 · MT-MEMORY.md:26 | GELANDET/BINDEND — laut Memory-Index 3x owner-gesetzt (zuletzt 19.08.); Wellenplan belegt eine wortgleiche Instanz (Owner 18.08.: "NIE etwas ausgebucht/verschoben" + "NIE kuerzen, gesamte Kette voll, ALLE Features") | Limit=pausieren/sequentialisieren, NIE reduzieren; Vollzaehligkeits-Gates | Wellenplan, Memory/Tasks |
| KEINE YAML — Planer emittiert PROZESS (Owner-Doktrin) | OWNER-ENTSCHEID | W2 | WP-Z2444-2445(B-17)+Z2084(O-6/7/8) · MT-MEMORY.md:18 | GELANDET/BINDEND (KON16/17/18/25, KON16-03) — konsistent; Wellenplan zeigt zusaetzlich die Vorgeschichte (O-6/O-7/O-8 dadurch GESTRICHEN/gegenstandslos) | zentrales C++23-Bau-Modul, Rakete rueckwaerts -> #3 | Wellenplan, Memory/Tasks |
| CACHE-LANDSCHAFT — Runner lesen nur ccache+NAS (Owner-Doktrin) | OWNER-ENTSCHEID | W2 | WP-Z2435-2436(B-13)+Z2085(O-9) · MT-MEMORY.md:60 | GELANDET/BINDEND ("mein letztes Wort", KON13-04/15-05) — wortgleich in allen 3 Belegen | Runner LESEN nur ccache minio.comdare.de+Buildsystem-NAS; XSD-Enum traegt die Semantik bereits | Wellenplan, Memory/Tasks |
| STEMPEL TRAEGT FUENF ROLLEN (Identitaet/Cache/Lager/Skip/Einordnung) | FEATURE | — | WP-Z1410-1412 · MT-MEMORY.md:16 | GELTEND (KON9-11) — Wellenplan liefert die vollstaendige Rollenliste mit Zusatz "entscheidet was ueberhaupt neu gebaut wird; Voraussetzung von W2, nicht Beiwerk"; Memory-Index ist die knappere Kurzfassung derselben Aussage | — | Wellenplan, Memory/Tasks |
| prod1 = 16 Kerne/32 Threads (fruehere Annahme "24" war falsch) | REGRESSION | W2 (Doku-Nachtrag) | WP-Z3320-3326(T-13) · R-Z166-167(seg3-kon28-01)+Z719(9.1-Fortschreibung) · MT-MEMORY.md:74 | Sachverhalt BEHOBEN (Memory: "korrigiert auf 16/32"; Register 9.1: runner-mode.sh HEAVY_J=16 seit Commit 20ebba5, N-3/N-4 auf 16W neu gerechnet) — **Doku-Luecke bleibt OFFEN ausgewiesen:** Register Sec.3 (seg3-kon28-01) und Wellenplan T-13 fuehren uebereinstimmend, dass Ledger-Marker §69.6 "prod1=24 Worker ohne UEBERHOLT-Vermerk" weiterhin fehlt (TEIL-GETRAGEN, Docs-Zug Di-25). Kein Fakten-Konflikt, nur Fakt-vs-Doku-Zeitversatz | Ledger §69.6; Docs-Zug Di-25 | Wellenplan, Register, Memory/Tasks |
| checkpoint_measure — Bau-/Einordnungsstatus | REGRESSION/OWNER-ENTSCHEID | — (nicht W7, Teil System B/B4) | WP-Z1010+Z1059+Z3128-3130+Z765,769+Z2172 · R-Z629(LSEG8-14)+Z677(SEG5-01) | **KONFLIKT ausgewiesen, nicht aufgeloest:** Register-Audit-Tafel widerspricht sich intern — LSEG8-14 (Sec.6b, FEHLT-Liste) "KEINE Definition im Code, nur Kommentar+SOLL", SEG5-01 (dieselbe Tafel, ABWEICHUNG-Liste) dagegen "Instrument GEBAUT: checkpoint_measure.hpp init(MessMasse)+flush_mess/flush_stapel je Arena getrennt". Wellenplan (juengste durchgaengige Linie, §21/§22 nach dem Register-Audit) loest dies NICHT technisch, sondern per Owner-Einordnung: zuletzt BINDEND als Teil von System B/B4 gefuehrt ("--debug und Mess-Schalter streng disjunkt; checkpoint_measure MUSS gebaut werden, nicht W7", KON34-02/-03) und in §22 als VERTAGT->FORTGESCHRIEBEN registriert ("laengst zurueck als B4"). Juengste Quelle gewinnt fuer die EINORDNUNG (System B/B4, nicht W7); der Register-interne Bau-Widerspruch bleibt am Objekt ungeklaert | B4/System B; Owner-KERN 09.08., §17.3 | Wellenplan, Register |
| OV-5 / prod2-Betrieb (Ein-Maschinen-Korrektur) | OWNER-ENTSCHEID -> REGRESSION (Textkorrektur) | — / W2/W3 | WP-Z1052+Z3119-3122 | UEBERHOLT AM OBJEKT — urspruenglich OFFEN (Frist Fr 21.08., Empfehlung "ja", getent hosts prod2 rc2); durch #60 Flotten-Runner ueberholt: prod2 ist seit #60 online, nur noch Textkorrektur der Praesens-Zusage in 05_evaluation.tex offen ("EIN Owner-Satz genuegt fuer pmc:intel-Lane") | #60 | Wellenplan (intra-Quelle, 2 Zeilen derselben Datei) |
| EIN-BLECH-REGEL (Betriebsregel, richtiggestellt) | FEATURE (Betriebsregel) -> OWNER-ENTSCHEID (Richtigstellung) | — | WP-Z49+Z674 | GELTEND — urspruengliche Fassung ("prod1 = Runner+Arbeitsmaschine, max 1 Paket Pipeline-Abnahme gleichzeitig") am 09.08. vom Owner RICHTIGGESTELLT: "Hardware-Job-Pool ueber Maschinenfaehigkeiten... alle Maschinen alle Jobs aufnehmen"; Floaten IST der Entwurf (47/53 Jobs floaten bestaetigt) | — | Wellenplan (intra-Quelle, 2 Zeilen derselben Datei) |
| B3 Schalter-Hoheits-Umzug (abi_adapter.hpp / W1-V2) | AUFGABE (Plan) + REGRESSION (Audit-Befund, offen) | W1 | WP-Z2367-2368(A-12)+Z2228(#24/B3)+Z2978-2981(W1-V2) · R-Z181-184(W1-V2 ERNST-PLAN)+Z793-796(12.1 Anker-Diskrepanz)+Z1209-1210(13.2[F-B]) | OFFEN-REGRESSION — Plan (Owner-Datum "VOR F2", KON34-04/KON37-01) verlangt Umzug der Schalter-Hoheit zur CEB; Audit fand keinen Bau-Treffer. **Anker-Konflikt ausgewiesen:** Register 3b/W1-V2 (aeltere Passage) verortete den fehlenden Bau bei `abi_adapter.hpp:476-491`; die juengere Register-Passage 12.1 [W1-V2-ANKER-DISKREPANZ] korrigiert dies — der B3-Pflicht-Wurf sitzt tatsaechlich in `mess_achsen_naht.hpp:477-517` (:509 throw), NICHT in abi_adapter.hpp. Juengste Quelle (Register 12.1) gewinnt fuer den Anker; Bau-Slot laut Register 13.2[F-B] inzwischen in Fix-Strecke2 aufgenommen (M1-Messung beide Anker + G5-Bau, GEPLANT) | #93 W1-Audit Gruppe D fuer finalen Abgleich | Wellenplan, Register |
| CI-DUAL-COMPILER ALLE BEREICHE / #106 (Owner-KERN 20.08.) | OWNER-ENTSCHEID (Regel) + AUFGABE (Task) + REGRESSION (Erhebungsbefund) | — | MT-MEMORY.md:30+task_board_dump.md:41(x2) | GELANDET (Regel, 20.08.) / IN_PROGRESS (Task #106, Fix-Design+Landung Di-25 mit #3) / OFFEN-REGRESSION (Erhebung: nur 9/41 Jobs dual-compiled, 13/23 Konfigurationen nie clang; Fix-Raenge 1-10 priorisiert) — alle 3 Zeilen derselben Quelle, intern konsistent als Owner-KERN + Umsetzungsstand | gcc+clang-Doppel-Compile fuer JEDEN Bau-/Test-Job aller Pipelines, kein when:never/changes:-Skip | Memory/Tasks (intra-Quelle, 3 Zeilen derselben Datei) |


## Teil B — Einzelquellen-Posten: Wellenplan (874 von 929 Rohzeilen; 55 gingen in Teil A auf)

Unveraendert aus `leser-wellenplan.md` uebernommen (KUERZEL/Name | Klasse | Welle | Quelle (Z-Anker) | Status LAUT QUELLE | Traeger/Task), Spalte `Quellen` ergaenzt. Kein weiterer Inhalt gekuerzt oder umformuliert.

| KUERZEL/Name | Klasse | Welle | Quelle (Z-Anker) | Status LAUT QUELLE | Traeger/Task | Quellen |
|---|---|---|---|---|---|---|
| WIEDERAUFNAHME-MARKER 18.08. (par.21) | OWNER-ENTSCHEID | par.21 | Z9-11 | GELTEND | Owner-Order: NIE ausbuchen/verschieben; W7 ist KEIN Endlager mehr (par.21.0); Platzierung: Wiederaufnahme-Register + par.21.3 | Wellenplan |
| KON119 reserviert als Lande-Bericht #15-Bruch | OWNER-ENTSCHEID | par.21.1 | Z10 | GEPLANT (reserviert) | super-Zug | Wellenplan |
| Owner-KERN 08.08.: HYBRID=Gattung HEURISTIK-ADAPTER, "Volles GO. Alles Pflicht." | OWNER-ENTSCHEID | — | Z7,39,92 | BINDEND | Genus Function-Interface-Reroute, 4. Mess-Ebene DAZWISCHEN | Wellenplan |
| WIEDERAUFNAHME-MARKER 18.08. (par.21, Preis-Satz nur Historie) | OWNER-ENTSCHEID | par.21 | Z41-43 | GELTEND (Fortschreibung) | ##40-Reste neu platziert: T-13/T-14 vor W3, T-07/T-08 vor Trigger/W2-Slots, Rest W4 | Wellenplan |
| Ersetzt wellenplan_endfassung.md v1 | OWNER-ENTSCHEID | — | Z5 | GELTEND | v1 deprecatet (nicht geloescht), transitiv Vorgaenger-Dateien | Wellenplan |
| Synthese-Entscheid: Ketten-Entwurf traegt | OWNER-ENTSCHEID | — | Z7 | GELTEND | Reihenfolge Waage->Naehte->Statistik-Glied->fehlendes Glied->einmal bauen->einmal messen | Wellenplan |
| GO-Vorabzusage beim Owner (OV-15) | OWNER-ENTSCHEID | W3-MESS | Z47 | OFFEN (Vorabzusage noetig) | Messfenster Sa 29.08.-Do 03.09. | Wellenplan |
| DURCHSTICH: echter Mini-Messwert F1 durch komplette Kette | FEATURE | W0b (F1) | Z45 | GEPLANT | CSV->persist->xlsx->anhang:forward->PDF, Thesis-Submodul | Wellenplan |
| HY-A (Struktur+Dock+Achse+Parser) | FEATURE | W1 (F2 Freeze) | Z39 | GEPLANT | Hybrid-Bau Teil 1 | Wellenplan |
| HY-B (Overhead-Messung Stub-Heuristik) | FEATURE | W3-MESS (F4) | Z39 | GEPLANT | Hybrid-Bau Teil 2, eigene kleine Teilmatrix | Wellenplan |
| HY-C (Router aus echten Kurven) | FEATURE | W4-AUSWERTUNG (F5) | Z39 | GEPLANT | Break-Even-Router konsumiert Messkurven | Wellenplan |
| ABGABEFAEHIGKEITS-MINIMUM | FEATURE (Betriebsregel) | — | Z49 | GELTEND | ab F1 zu jedem Zeitpunkt ehrliche kleine Abgabe, jeder Freitag steht allein | Wellenplan |
| D1 — Reconfigure in `check` | AUFGABE | W-1 | Z110 | GEPLANT (3h) | mit D1a in einem Commit; Zahlen 427/429/431 gemessen | Wellenplan |
| D1a — `make` baut 0/53 Permutations-DLLs | AUFGABE | W-1 | Z111 | GEPLANT (2,5h) | nach D1, gleiche Datei; Produkt-Problem `make install` | Wellenplan |
| D1b — CI-Prebuild kennt adhoc_emitter_cli nicht | AUFGABE | — | Z112 | GESTRICHEN | F1-Kern-Explore 10.08., s. Fussnote F1-KERN | Wellenplan |
| D1c — Abdeckungs-Wache bleibt gruen gegen korrekte Inventur | AUFGABE | W0a | Z113 | GEPLANT (5h) | nach D1b, D1f; Job-Baum-Inventur aus fremdem Artefakt | Wellenplan |
| D1d — Doku-Widerspruch "404 statt 406" vs "427 gegen 431" | AUFGABE | W-1 | Z114 | GEPLANT (0,5h) | nach D1-Messung (K13); Zahlen kuenftig mit Datum+Kommando | Wellenplan |
| D1e — f15_compare_cli_smoke Binary fehlt in Baukante | AUFGABE | W0a | Z115 | GEPLANT (2h) | vor D1b; PASS_REGULAR_EXPRESSION haengt Exit-Code ab | Wellenplan |
| D1f — 5 STATUS_OUT-Bloecke, drei Zustaende | AUFGABE | W0a | Z116 | GEPLANT (3h) | nach D1; message(WARNING) bei rc!=0 = stiller ERROR-Pfad | Wellenplan |
| D1g — super Reconfigure strukturell wirkungslos | AUFGABE | W0a | Z117 | GEPLANT (1,5h) | nach D1; EXCLUDE_FROM_ALL, Nenner 186/610 in Lauf-Ausgabe | Wellenplan |
| D2-G4 — Textkorrektur Abnahme ##06 VOR dem Bau | AUFGABE | W0a | Z127 | ERLEDIGT 09.08. (1h) | super scripts/ci_abnahme06_bedingungs_tabelle.sh + Allowlist + korrigierte Formel §6 | Wellenplan |
| D2 — Nenner-Untergrenze (ci_test_inventory_floor.txt) | AUFGABE | W0a | Z128 | GEPLANT (3,5h) | nach D2-G4; Emitter in covguard-Prebuild-Zeile, Skip-Allowlist | Wellenplan |
| D2-G1 — unsichtbare gtest-Faelle (27->30 gezaehlt) | AUFGABE | — | Z129 | ERLEDIGT 10.08. mit ce ca6d8af1 (0h) | zwei add_test nach dokumentiertem Muster, COMDARE_TEST_TARGETS | Wellenplan |
| D2-G2 — Registrierung ohne Bau macht Hauptpipeline rot | AUFGABE | W0a | Z130 | GEPLANT (1,5h) | im D2-Bogen; TIMEOUT nach gemessener Zeit x4 | Wellenplan |
| D2-G3 — drei Gruen-ohne-Vergleich-Wege | AUFGABE | W0a | Z131 | GEPLANT (1,5h) | mit D2; K11 ctest-Ausgabe in Datei dann rc | Wellenplan |
| D2-G5 — Host-Klassen-Bericht (Richtigstellung) | AUFGABE | W0b | Z132 | GEBAUT | super scripts/ci_host_klassen_bericht.sh + Selbsttest + Job test:host-klassen-bericht | Wellenplan |
| D2-G6 — Registry-Roundtrip-Gates haengen an Datei-Existenz | AUFGABE | W0a | Z133 | GEPLANT (0,5h) | Anhang zu D2; Standard-Bissprobe (stash-Koeder) | Wellenplan |
| D2-G4/Z Nachtrag — Allowlist deckte Bedingungen, nicht Stellen (Schleichweg) | REGRESSION | W0a | Z222-244 | BEHOBEN | Zusicherungsfeld "stellen=N" je Allowlist-Eintrag eingefuehrt, fail-closed | Wellenplan |
| test:abnahme06-zusicherung (neuer CI-Job) | FEATURE | — | Z248-252 | GEBAUT | kein allow_failure, kein .code-rules; volle Formel ##06 bleibt bis D2 baremetal | Wellenplan |
| NACHZUG 10.08. — 4 PRT-ART-Registrierungen entfallen, Zahlen 18->14 ziehen nach | REGRESSION | — | Z262-283 | BEHOBEN (Wachen fingen es) | super-Pipeline 15615, Jobs 373214/373217; Allowlist-Eintrag aufgehoben (auskommentiert), Disposition Ledger PA-3 | Wellenplan |
| Ledger PA-3 — Disposition der 3 PRT-ART-Quelldateien | OWNER-ENTSCHEID | — | Z277 | OFFEN | Owner muss entscheiden (Dateien liegen weiter im Baum) | Wellenplan |
| ##26-Formel "N==M" gruen bei Nenner 0 | REGRESSION | — | Z31 | BEHOBEN (korrigiert in v2) | korrigiert auf N>=1 UND M==N UND datenzeilen_gesamt>=1 | Wellenplan |
| ##06-Formel "5 STATUS_OUT je FOUND" waere Dauer-Rot | REGRESSION | — | Z32 | BEHOBEN (korrigiert in v2) | Bedingungs-Tabelle: erfuellt ODER Allowlist mit Begruendung | Wellenplan |
| ##36-Koeder sieht Zielfall (Null-Fenster) nicht | REGRESSION | — | Z33 | BEHOBEN (korrigiert in v2) | zwei degenerierte Zellarten getrennt: unbestimmbar vs. Reruns | Wellenplan |
| ##04/##05 Abnahmezeilen ohne Bau-Paket | REGRESSION | W-1 | Z34 | OFFEN | V-6 gilt jetzt beidseitig; D1/D1a sollen Luecke schliessen | Wellenplan |
| ##57-Koeder beisst aus falschem Grund | REGRESSION | — | Z35 | BEHOBEN (korrigiert in v2) | Abnahme auf Statusraum umgestellt (D4f) | Wellenplan |
| ##20-Vorschrift — echter Defekt: stale index.lock -> IDEMPOTENT 0 Aenderungen, Exit 0, 0/2 Messwertdateien | REGRESSION | — | Z36 | OFFEN | RICHTIGSTELLUNG 10.08. nur Text; realer Defekt daneben reproduziert, noch offen | Wellenplan |
| Einwand-36-Erklaerung (610 Tests = Folge EXCLUDE_FROM_ALL) | REGRESSION/OFFEN-FRAGE | — | Z37 | OFFEN | nicht festgeschrieben; entscheidet D1g-Messung, nicht der Plan | Wellenplan |
| Drei Nenner fuer "kein Test fehlgeschlagen" (427/429/431) | REGRESSION | — | Z72-74 | OFFEN | wird durch D1-Familie behoben | Wellenplan |
| Wache blind: guard431.log gruen trotz Luecke (Selektor- statt Registrierungs-Abdeckung) | REGRESSION | — | Z74 | OFFEN | wird durch D1c/D2 behoben | Wellenplan |
| 27 gtest-Faelle seit 21.05. in jedem Baum unsichtbar (WelchTTest darunter) | REGRESSION | — | Z74 | dup->siehe D2-G1 (BEHOBEN 10.08.) | Fortschreibung | Wellenplan |
| Lebender Mess-Weg kann nicht rot werden (allow_failure, Existenz-Gate, persist zaehlt Dateien statt Zeilen, anhang:forward-Selektor traf nie) | REGRESSION | — | Z76 | TEILWEISE BEHOBEN | anhang:forward-Teil BEHOBEN mit 6d2e3dce (=D3-6, s.u.); allow_failure/persist-Rest offen, s. D3-Familie | Wellenplan |
| KORREKTUR-EINSCHUB 10.08. — anhang:forward-Muster nicht mehr disjunkt (D3-6) | REGRESSION | — | Z78-86 | BEHOBEN | ci/anhang_forward_core.sh:202 traegt beide Formen; gelandet 6d2e3dce (09.08.), origin/development | Wellenplan |
| Statistik erklaert tote Reihen fuer gueltig (Welch se<=0, MWU valid vor Guard, Bonferroni p=1.0, result_aggregator success=!empty, drift_detector median<=0->stable=true) | REGRESSION | — | Z88 | OFFEN | = D4-Familie (Details spaeter im Dokument) | Wellenplan |
| Perzentile: 2 Definitionen, faelschlich "Nearest-Rank" benannt, in 4700/9998 Faellen verschieden | REGRESSION | W0a-Lokalspur | Z88 | OFFEN | = D5-1 (Perzentil-Kanon), rueckt vor W1 | Wellenplan |
| Median: 5 Implementierungen, 3 Antworten (20/25/30 auf {10,20,30,40}) | REGRESSION | — | Z88 | OFFEN | = D5-Familie; REV-DATA-12 offen laut Code selbst | Wellenplan |
| Menge/Maschine: --check-size und <measure_selection> = 0 Treffer | REGRESSION | — | Z90 | OFFEN | beide Repos betroffen | Wellenplan |
| Voll-Matrix ~143 Tage einthreadig als Untergrenze | UNKLAR (Befund, keine der 4 Klassen sauber) | — | Z90 | GEMESSEN (LIVE) | Spanne Faktor 69; Bau des Bestands 128x19,4min=41,4h auf prod1 | Wellenplan |
| getent hosts prod2 rc 2, waehrend 05_evaluation.tex Zwei-Maschinen-Betrieb im Praesens zusagt | REGRESSION | — | Z90 | OFFEN | Doku-Code-Widerspruch, prod2 nicht erreichbar | Wellenplan |
| HYBRID-Bestand: nur README.md vorhanden | FEATURE (Status) | — | Z92 | OFFEN (nicht gebaut) | git ls-tree origin/development libs/cache_engine/hybrid/ = genau README.md | Wellenplan |
| Fenster: 27 Werktage+11 WE-Tage, 5 Freitage, Abgabe Di 15.09. | OWNER-ENTSCHEID | — | Z94 | GELTEND | Arbeitsbaum 29 Commits hinter origin/development -> W-1 landet+erhebt neu | Wellenplan |
| D2-G4 Fussnote — Formel ##06 komplett (SOLL/IST-Nenner getrennt, Host-Kennung Pflicht) | AUFGABE/FEATURE | W0a | Z137-260 | ERLEDIGT 09.08. | scripts/ci_abnahme06_bedingungs_tabelle.sh, Koeder gefahren (K13), Selbsttest 11/11 gruen | Wellenplan |
| D2-G5 Fussnote — Richtigstellung "6 von 428" ist falsch (Ebenenfehler) | REGRESSION | W0b | Z287-300 | BEHOBEN 08.08. | 6 ISA-gebundene Registrierungen: 4 an AVX512F, 2 an AVX2; prod2 verliert 4 | Wellenplan |
| D2-G5 NACHTRAG — Gegenorakel: CMake bestaetigt die Leiter | AUFGABE | W0b | Z311-337 | GEBAUT | scripts/ci_host_klassen_gegenorakel.sh + Selbsttest 9 Faelle, Koeder beide Richtungen; ctest-Eintraege je Klasse gemessen 429/425/423 | Wellenplan |
| "428" aus altem Plan-Stand nicht bestaetigt, nicht uebernommen | REGRESSION | — | Z305-309 | BEHOBEN (klargestellt) | andere Einheit (Registrierungs-Aufrufe vs. ctest-Eintraege), super-Baum registrierungen_gesamt=148 | Wellenplan |
| Owner-Order 10.08.: Pflicht-Explore-Stufe 0 vor jeder Verarbeitung (STIMMT/STIMMT_TEILWEISE/STIMMT_NICHT/SCHON_ERLEDIGT) | OWNER-ENTSCHEID | — | Z339-346 | BINDEND | Anlass: 7 Kern-Explores 10.08., Workflow wf_e22d25ef-71c, 11 Agenten, 0 Fehler | Wellenplan |
| F1-KERN Ergebnis: 5/7 Pakete SCHON_ERLEDIGT, 2/7 STIMMT_TEILWEISE, 0/7 STIMMT | REGRESSION (Planungs-Befund) | — | Z348-357 | BEHOBEN (durch Pflicht-Explore verhindert) | 5 Pakete waeren sonst neu+doppelt gebaut worden, gefahrene Koeder entwertet | Wellenplan |
| D1b Restposten: Stage-Topologie (test:unit Inventar hat keinen Verbraucher) | AUFGABE | — | Z369-373 | OFFEN | ce/.gitlab-ci.yml:934-938 selbst als "OFFEN (eigenes Paket)" markiert; needs darf nicht vorwaerts zeigen | Wellenplan |
| Ledger-Zeile 2626 "zwei gegenstandslos" verharmlost D2-G1-Klasse, ist als Satz falsch | REGRESSION | — | Z385-386 | BEHOBEN | korrigiert im Ledger-Nachtrag 10.08. | Wellenplan |
| D2-G1 war ZWEI unabhaengige Defekte (enable_testing-Reihenfolge + gtest_discover_tests-Defekt) | REGRESSION | — | Z381-384 | BEHOBEN | (a) W-1-Wurzelfix, (b) ce ca6d8af1 10.08. "zwei gtest-Binaries unter libs/ nach Repo-Muster registrieren" | Wellenplan |
| ##08-A — Schema-Freeze Stufe 1 + B-3 | FEATURE | — | Z389-391 | GEBAUT | schema_freeze.hpp (Kopf 2026-08-09), kWideSchemaFreezeStufe1=189 Spalten; test_b3_schema_freeze_stufe1.cpp, test_mt_l3_wide_schema_orakel.cpp; Ledger:4079 03f897dd | Wellenplan |
| ##08-B — "lazy Header-Emission auf a.out_csv" | AUFGABE | — | Z392-398 | GESTRICHEN (NIE bauen) | Auftrag hat Namen missverstanden (lazy=Lauf-Familie, kein Emissionsverhalten); Posten meint "einmal definiert" nicht "einmal geschrieben" | Wellenplan |
| D3-7 — Lauf-Marker/Frische-Wache | AUFGABE | — | Z400-404 | ERLEDIGT 09.08. (028684ac) | ci/lauf_marker.sh (371 Z.), ci/tests/lauf_marker_probe.sh, ci/frische_wache.sh; verdrahtet .gitlab-ci.yml:1665-1667/:1840-1842 | Wellenplan |
| D3-7b Restposten — dritter Modus pruef_only fehlt in Bilanzzeile | AUFGABE | — | Z403-404 | OFFEN | ce profile_run_entry.hpp:1268; Marker kann pruef_only nicht fuehren | Wellenplan |
| D3-3 — persist_sammler.sh Gate gegen 0-Zeilen | AUFGABE | — | Z406-408 | ERLEDIGT 08.08. (4e0b7e0d) | ci/persist_sammler.sh (332 Z.): :305 gate_verweigern bei DATENZEILEN_GESAMT=0, Zaehlung per awk (:26-33 begruendet) | Wellenplan |
| D3-3b Restposten — LEERZEILE zaehlt als Messwert (NR-1) | AUFGABE | — | Z409-410 | OFFEN | Heilung muss drei Dateien in EINEM Commit treffen (gegenseitige Wortgleichheits-Zusicherung) | Wellenplan |
| ##20+D3-6 — Selektor geheilt (A-Teil), Vorschrift falsch (B-Teil) | REGRESSION | — | Z412-422 | STIMMT_TEILWEISE | Selbstbiss: 11/11 gehalten, 6/6 Mutanten rot; Vorschrift-Korrektur s. Fussnote ##20-B | Wellenplan |
| ##23 — zwei Nahtstellen (ergebnis_mappe_naht.hpp xlsx->csv + tools/mess_report/ CLI) | AUFGABE | — | Z424-428 | ERLEDIGT | alle vier Teile gebaut, Abnahme gegen echtes 320er-Archiv gefahren; Owner-Doktrin: Titel "CSV->xlsx" beschreibt Richtung falsch herum | Wellenplan |
| ##23-R1 Restposten — 8 vendorierte thesis_profiles sind xlsx-blind | AUFGABE | — | Z429-432 | TEILWEISE ERLEDIGT | mit_xlsx=1 ohne_xlsx=8 (Nenner 9); Gitlink 10.08. auf e114cabd gehoben, Stand >=4a26b6a3 neu auszuzaehlen | Wellenplan |
| Fuenf Restposten + eine Ledger-Korrektur bleiben aus F1-KERN-Pruefung | AUFGABE | — | Z436-443 | OFFEN (4 von 5 unvermessen) | Stage-Topologie, D3-7b, D3-3b, ##20-B(BAU-Rest), ##23-R1; urspruengliche Aufwaende D1b 1,5h+D2-G1 2h fallen | Wellenplan |
| Lehre: Kern-Explore muss VOR dem Bauen laufen, nicht danach | OWNER-ENTSCHEID/REGRESSION | — | Z445-448 | BINDEND (Lehre) | 5/5 Faelle waren Bauauftraege am Objekt falsch, weil aus veralteten Plaenen/Ledger-Zitaten gebaut; "Plan ist keine Quelle ueber den Code, sondern eine Behauptung" | Wellenplan |
| ##20-B Behauptung "rc=128 bei jedem DE-only-Lauf" | REGRESSION | — | Z468 | BEHOBEN (widerlegt) | ZU STARK: rc=128 nur wenn Pathspec nichts trifft; 3/3 Zustaende gemessen | Wellenplan |
| ##20-B Behauptung "Zeile stand jahrelang so" | REGRESSION | — | Z469 | BEHOBEN (widerlegt) | FALSCH: Zeile kam mit erstem Commit 347684cb, 2026-08-06 (nur 4 Tage alt) | Wellenplan |
| ##20-B — echter Defekt reproduziert: stale index.lock verschluckt Fehler, 0/2 Dateien landen, rc=0 | REGRESSION | — | Z480-502 | OFFEN-REGRESSION | stderr leer (2>/dev/null verschluckt fatal), Exit 0 (\|\| true); Gegenprobe ohne lock: 2/2 gelandet | Wellenplan |
| ##20-B ZWEITER Befund — git add nimmt fremde unversionierte Dateien im Zielverzeichnis mit | REGRESSION | — | Z504-511 | OFFEN-REGRESSION | fremd_entwurf.tex landet im Commit; Rollback-Zusage deckt nur Loeschung, nicht Commit-Inhalt | Wellenplan |
| ##20-B — korrigierte Vorschrift ($COPIED_LIST statt Verzeichnis-Pathspec) | AUFGABE | — | Z513-545 | GEPLANT (vorgeschlagen, ausdruecklich NICHT gebaut) | Auftrag ##20-B: "vorschlagen, nicht bauen"; 5/5 Faelle V1-V5 gemessen inkl. Koeder-Gegenprobe | Wellenplan |
| ##20-B — git-Version auf baremetal-Runner ungeprueft (--pathspec-from-file braucht >=2.25) | AUFGABE | — | Z561-565 | OFFEN | vor Bau zu pruefen; Rueckfallform bei zu alter Version noetig (xargs -0 + NUL-Liste) | Wellenplan |
| Ledger KON4-06 zu starke Fassung "rc=128 bei JEDEM DE-only-Lauf" muss korrigiert werden | AUFGABE | — | Z591-594 | OFFEN | Nachzuziehen von Ledger-Single-Writer, nicht von diesem Paket; docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md:221-223 | Wellenplan |
| D3-Familie — "Ein leeres Messfenster ist heute gruen" (8 Posten, 20h) | REGRESSION | — | Z596-600 | OFFEN | Kopfzeilen-CSV/0-Byte-CSV bestehen golden-320-Gate (rc=0); Detailtabelle folgt | Wellenplan |
| D3-7 — Lauf-Marker neben jeder CSV (Posten-Tabelle) | AUFGABE | W0b | Z602 | GEPLANT (3h, dann ERLEDIGT 09.08. s.o.) | vor allen D3-Gates; auch prune_only schreibt einen | Wellenplan |
| D3-1 — ci/measure_csv_gate.sh: drei Zahlen, rot nur bei modus=voll/Z==0 | AUFGABE | W0b | Z603-604 | TEILWEISE ERLEDIGT | gebaut als ci/mess_ausbeute_wache.sh (7444d8c0) unter ANDEREM Namen; Marker-Haelfte (modus=voll) offen, haengt an D3-7 | Wellenplan |
| D3-2 — Smoke-Stelle auf denselben Helfer (Doppel-Aufruf beseitigen) | AUFGABE | W0b | Z605 | ERLEDIGT (7444d8c0, bestaetigt 09.08.) | Plan-Angabe "heute 2" war veraltet; Abnahme jetzt Fall F10 in ci/tests/mess_ausbeute_bissprobe.sh, gewuerfelter Koeder | Wellenplan |
| Abnahmekriterium selbst defekt: `grep -c` ohne `-F` liefert stille 0 (rc=1) unabhaengig vom Inhalt | REGRESSION | — | Z605-606 | BEHOBEN | Lehre: "==0 ohne Gegenprobe ist wertlos"; korrigiert auf grep -cF + gewuerfelter Koeder je Lauf | Wellenplan |
| D3-3 — persist zaehlt Zeilen statt Dateien (Posten-Tabelle) | AUFGABE | W0b | Z607 | GEPLANT (2h, dann ERLEDIGT 08.08. s.o.) | Beweis am Git-Zustand, nicht am Log; :1038-Warnung wird echter Abbruch | Wellenplan |
| D3-4 — lebender Mess-Job bekommt Inhalts-Gate je Batch | AUFGABE | W0b | Z608 | GEPLANT (5h) | nach D3-1/D3-7; allow_failure=Owner-Entscheid OV-16 bis Mi 12.08.; Emissionsblock byte-fixiert (Handarbeit) | Wellenplan |
| D3-5 — [MESS-TESTAT] in else-Zweig (Testat-XOR) | AUFGABE | W0b | Z609 | GEPLANT (1,5h) | im D3-4-Bogen; Batch-Bilanz A+B==C, set -e-Sicherheit erhalten | Wellenplan |
| D3-6 — anhang:forward-Selektor findet beide Ablageformen (Posten-Tabelle) | AUFGABE | W0b | Z610 | GEPLANT (2,5h, dann ERLEDIGT s.o.) | Owner-Klaerung Konvention OV-17; NO-OP nur noch mit Nenner | Wellenplan |
| D3-8 — Frische-Wache gegen GIT_CLEAN_FLAGS-Ausnahme | AUFGABE | W0b | Z611 | GEPLANT (2h) | zuletzt; scharf mit ergebnis:holen (W2); CI_PIPELINE_ID+JOB_ID als Lauf-Kennung | Wellenplan |
| OV-16 — allow_failure Owner-Entscheid | OWNER-ENTSCHEID | W0b | Z608, 701 | OFFEN (Frist Mi 12.08.) | Blockiert D3-4 | Wellenplan |
| OV-17 — result.csv-Konvention Owner-Klaerung | OWNER-ENTSCHEID | W0b | Z610, 701 | OFFEN (Frist Mi 12.08.) | Blockiert D3-6 | Wellenplan |
| D4-Familie — tote Messreihen gelten als gueltig (7 Posten, 12,5h) | REGRESSION | W1/W2 | Z615-617 | OFFEN | Heilungsform liegt vor: mess_konsistenz_gate.hpp (fail-closed per Default, benannte Fehlerklassen) | Wellenplan |
| D4 — Drift-Gate median<=0 -> unstable=true | AUFGABE | W2 | Z621 | GEPLANT (2h) | NUR zusammen mit T-15 (##36); allein=Scheinvollzug, T-15 allein=Blindheit einbauen | Wellenplan |
| D4a — Welch degeneriert-Flag bei se<=0 | AUFGABE | W1 | Z622 | GEPLANT (1,5h) | vor D4c | Wellenplan |
| D4b — MWU valid=true HINTER den Guard | AUFGABE | W1 | Z623 | GEPLANT (1h) | mit D4a | Wellenplan |
| D4c — Bonferroni: m=getestete Hypothesen | AUFGABE | W1 | Z624 | GEPLANT (3h) | nach D4a/D4b | Wellenplan |
| D4d — success=mind. eine Probe>0, degeneriert eigenes Feld | AUFGABE | W1 | Z625 | GEPLANT (1h) | einzige CSV-Spaltenaenderung der Woche, danach Header-Freeze Stufe 2 | Wellenplan |
| D4e — f15 Tote-Proben-Guard + Summenzeile | AUFGABE | W1 | Z626 | GEPLANT (1,5h) | nach ##07 (W0a) | Wellenplan |
| D4f — Break-Even-Rueckgabetyp mit Statusraum | AUFGABE | W1 | Z627 | GEPLANT (2,5h) | nach Break-Even-Definitionslage OV-6 | Wellenplan |
| FUSSNOTE T-15b (KON59, Marker 13.08.) — "5" sitzt falsch auf Drift-Achse | REGRESSION | W2 | Z632 | OFFEN | T-15a (ce 4cd1ab91) != T-15b (je 5 fuer Build UND Messung, 3x persistiert, KON37-06 §17.4); Umzug+8-Punkte-Ripple = Task #13 | Wellenplan |
| D5-Familie — 6 Perzentil-Verfahren, 5 Mediane, 1 fehlendes Feld (5 Posten, 13h) | REGRESSION | — | Z634 | OFFEN | Detailtabelle D5-1..D5-5 | Wellenplan |
| D5-1 — Perzentil-KANON, Lehrbuch-Formel, nearest_rank_p geloescht | AUFGABE | W0a (Lokalspur) | Z638 | GEPLANT (6h) | einziger Posten der den Messtermin bewegt; DREI Pins (p50 51->50, p99 100->99, p95 96->95 neu) | Wellenplan |
| D5-1 Plan-Zahl "34 unbewachte Stellen" nicht reproduzierbar | REGRESSION | — | Z638 | BEHOBEN (korrigiert 09.08.) | echt 38 (39 Vorkommen minus 1 Definition an c98b4b95~1); 34 mit keiner von 5 Zaehlweisen reproduzierbar | Wellenplan |
| D5-2 — Median-Kanon = q=0.5-Fall | AUFGABE | W1 | Z639 | GEPLANT (3h) | nach D5-1, nach D5-3; :1783/:1784 (Mediane UEBER Konfigurationen) nicht faelschlich umbauen | Wellenplan |
| D5-3 — Vorlage-Korrektur REV-DATA-12 (Posten-Tabelle) | AUFGABE | W1 | Z640 | ERLEDIGT 09.08. (0,5h) | Drift +239 Zeilen bestaetigt, Anker auf Symbol-Form umgestellt, ci/anker_wache.sh haelt sie | Wellenplan |
| D5-4 — delete_p99_ns existiert 0-mal | AUFGABE | W1 | Z641 | GEPLANT (1,5h) | mit D5-1-Flaechen; 9er-Feldliste als EINE Konstante, 5 Serialisierer auf geteilten Helfer | Wellenplan |
| D5-5 — HDR-Option "entfernen" gestrichen | OWNER-ENTSCHEID | W1 | Z642 | ENTSCHIEDEN 09.08. | Rangfolge OWNER>PLAN>THESIS (Owner-Korrektur); HDR+Perzentil-Kanon sind zwei Schichten, kein Gegensatz | Wellenplan |
| D5-5 — Neuer Auftrag "HDR verdrahten" | AUFGABE | W1 | Z642 | OFFEN (Aufwand neu zu schaetzen, "?", NICHT rutschfaehig) | heute 0 Produktions-Konsumenten; + Je-Lauf-Persistenz + 0-ns-Zaehler + Toleranz aus significant_figures=3 | Wellenplan |
| Fussnote D5-1/D5-3 Vendoring — Submodul-Arbeitsbaum 85 Commits VOR eigenem Gitlink (rueckwaerts) | REGRESSION | — | Z646-668 | OFFEN | ci/plan_zahlen_wache.sh bricht Exit 2 ab ("ce-Baum am Gitlink-SHA nirgends lesbar"); Kreuz-Test waere grün und blind | Wellenplan |
| Strang 9 — Submodul-Arbeitsbaum auf geheilten ce-Stand ziehen | AUFGABE | — | Z667-668 | OFFEN | eigenes Paket, kein Nebenschritt; Voraussetzung fuer D5-1/D5-2-Kreuztest | Wellenplan |
| Eigene Deutung "zweite Maschine=zweite Fehlerquelle" zurueckgezogen | REGRESSION | — | Z674 | BEHOBEN (zurueckgezogen) | Befund haelt (47/53 Jobs floaten), Deutung war falsch; Abstimmung laeuft ueber Lager+Hardware-Freigabe, nicht GitLab-Tags | Wellenplan |
| Zahl "44/48 -> 45/51 -> 47/53 tag-tragende Jobs" driftet mit jedem neuen Job | REGRESSION | — | Z674 | BEHOBEN (Lehre gezogen) | "Zahl ueber lebende Datei gilt nur mit Commit-Anker"; Symbol-Anker statt Zeilennummer eingefuehrt (D2-G5) | Wellenplan |
| ##01 — Merge origin/development, nie rebase (29->0) | AUFGABE | W-1 | Z687 | GEPLANT | beide Zahlen | Wellenplan |
| ##02 — A9-S4 landen (6 Commits, 17 Dateien) | AUFGABE | W-1 | Z687 | GEPLANT | Pipeline gruen | Wellenplan |
| ##03 — Diff-Neuerhebung, Erhebungs-SHA je Zeile | AUFGABE | W-1 | Z687 | GEPLANT | A.1-A.5 neu erheben | Wellenplan |
| ##04 — baremetal literal ("out of 431") | AUFGABE | W-1 | Z687 | GEPLANT | tragende Abnahme D1-Familie | Wellenplan |
| ##05 — ctest -N vor/nach Reconfigure | AUFGABE | W-1 | Z687 | GEPLANT | jetzt MIT Bau-Paket, Differenz + 4 Namen | Wellenplan |
| ##06 — korrigierte Formel (Abnahme, s. D2-G4) | AUFGABE | W0a | Z692 | ERLEDIGT (Formel), CI-Job baremetal belegt | im D2-G4-Bogen | Wellenplan |
| ##07 — (Vorlagen-Paket) | AUFGABE | W0a | Z692 | GEPLANT | vor D4e | Wellenplan |
| ##21 — Realm-Wurzeln /mnt + G-E3 + COMDARE_BESTANDSLOG | AUFGABE | W0b | Z698, 840-844 | TEILWEISE GELANDET | nur erste Haelfte (aktiv-Zeile via ci/bestandslog_wache.sh) mit LAG-P1 gelandet; object_stat am Store offen; V-3/V-8-Warnung: YAML-Praesenz != Abnahme | Wellenplan |
| ##22 — persist um *.xlsx; F-15 Schwere-Stufe | AUFGABE | W0b | Z698, 845 | GEPLANT | — | Wellenplan |
| ##24 — A9-S5a gegen 06.06.-Archiv | AUFGABE | W0b (nachrangig) | Z698, 850 | GEPLANT (nachrangig) | faellt zuerst bei Riss | Wellenplan |
| F-13 — super-Wache | AUFGABE | W0b | Z698, 850 | GEPLANT | — | Wellenplan |
| ##27-##30 — Nachlauf-Pakete | AUFGABE | W0b-Nachlauf (bis Di 18.08.) | Z698, 851-852 | GEPLANT | Diff-Wache/Allowlist/lint/parity | Wellenplan |
| ##31 — Wachen-Register (Grundmenge alle .sh + verdiktdruckende Jobs + PASS_REGULAR_EXPRESSION-Tests) | AUFGABE | W0b-Nachlauf | Z698 | GEPLANT | neue Klasse aus D4-Querbefund; Koeder gefahren; Rueckfallstufe bei Riss: manuell versioniert | Wellenplan |
| ##10+##10b — --check-size, working_set 8.388.608 | AUFGABE | W1 | Z705, 863 | GEPLANT | zwei Zahlenreihen + EIN gemessener Punkt | Wellenplan |
| ##11 — <measure_selection> Schema+XSD+Validator | AUFGABE | W1 | Z705, 864 | GEPLANT | Teilmengen-Garantie | Wellenplan |
| ##12 — configure --enable-X=no, 5 XMLs wohlgeformt | AUFGABE | W1 | Z705, 865 | GEPLANT | 2 generiert | Wellenplan |
| ##13 — G3-Split aus STATISTICS-Gate | AUFGABE | W1 | Z705, 866 | GEPLANT | 7. Feld mess_gates_glied | Wellenplan |
| ##14 — Sperrlisten-Wache = Freeze-Gate (maschinell, kAnatomyFingerprintGliedCount=9) | AUFGABE | W1 | Z705, 867 | GEPLANT | 10. Glied -> rot | Wellenplan |
| ##15 — §59-SCHEMA hartes W3-MESS-Vor-Gate | AUFGABE | W1 | Z705, 868 | GEPLANT | EMITTER/TEMPLATE bei Slack | Wellenplan |
| ##16+##17 — Break-Even-Kanon + Serialisierung | AUFGABE | W1 | Z705, 869 | OFFEN (blockiert durch OV-1) | nach OV-1 | Wellenplan |
| ##19 — LaTeX-Auswertungs-Emitter | AUFGABE | W1 | Z705, 871 | GEPLANT | — | Wellenplan |
| ##09 — amd_l3-Teil (nachrangig) | AUFGABE | W1 (nachrangig) | Z705, 871 | GEPLANT (nachrangig) | — | Wellenplan |
| Registry-Zahl 22->23 (Heuristik-Hybrid-Achse) | REGRESSION | W1 | Z705 | BEHOBEN (korrigiert) | UEBERHOLT per E-6/P.20.10: 22=Phantom-Nenner; real=kGenusBuildSlotCounts 5->6 | Wellenplan |
| ##42-##45 — Abgabe-Vorlauf (FF-Matrix, .ps1/.py-Abloesung, C5-Geruest, Thesis-Spur) | AUFGABE | W1 | Z705, 876 | GEPLANT | — | Wellenplan |
| OV-4 — Deckel-Vorlage mit beiden --check-size-Zahlenreihen an Owner | OWNER-ENTSCHEID | W1->F2 | Z705, 877 | OFFEN (Vorlage Fr 21.08.) | — | Wellenplan |
| NULL-BUMP-Regel gilt AB SOFORT (nicht erst ab 24.08.) | OWNER-ENTSCHEID | W2 | Z712 | GELTEND (korrigiert 09.08.) | wer bis 26.08. 06:00 bumpt bricht Freeze, entwertet 41,4h Bau; Wache dazu ist vorgezogener W2-Posten | Wellenplan |
| Magic-Wechsel "4->5" war unbereinigter Textrest | REGRESSION | — | Z712 | BEHOBEN (korrigiert 09.08.) | Wechsel bereits gefallen: d4c0b49c (NAHT-1, Major 8->9) am 09.08.; ##34-Filter 159 Commits im Fenster, 1 echte Wertaenderung | Wellenplan |
| ##35 — Resume-Beweis (Abbruch nach 2 Batches, Neustart ueberspringt) | AUFGABE | W2 | Z712 | GEPLANT | — | Wellenplan |
| ##37, ##38 (klein), ##39, ##41 | AUFGABE | W2 | Z712 | GEPLANT | — | Wellenplan |
| ##46 — Anker + TP1-FINAL, drei Spiegel | AUFGABE | W2 | Z712 | GEPLANT | Di | Wellenplan |
| ##47 — Kalibrierlauf GN_TOTAL=64 durch alle W0b-Gates | AUFGABE | W2 | Z712 | GEPLANT | erster Ernstfall der Messweg-Ehrlichkeit; Menge unabhaengig per Teilbaum-Auszaehlung, Einwand 29 | Wellenplan |
| ##48 — §66 G1-G5 + Platten-Budget (benoetigt_GB/frei_GB BEIDE gedruckt) | AUFGABE | W2 | Z712 | GEPLANT | 43G frei bei 83% | Wellenplan |
| ##41b — Kaskade Parent/Child/Grandchild mit Job-IDs | AUFGABE | W2 | Z712 | GEPLANT | dank D3-4 kann Grandchild jetzt rot werden | Wellenplan |
| ##49 — Bau-Trigger (~41,4h = 128x19,4min) | AUFGABE | W2 | Z712 | GEPLANT | Mi 26.08. 06:00; KIPP-PUNKT spaetester Start Fr 28.08. 06:00, danach faellt W4-Fangnetz | Wellenplan |
| ##50 — Zweitlauf (built_new==0, lager_skip==N, skip_ohne_testlog==0) | AUFGABE | W2 | Z712 | GEPLANT | Do abends | Wellenplan |
| ##51 — USER-GO-VORLAGE = F3 | AUFGABE | W2 | Z712 | GEPLANT | EINE Datei: 320er+gedeckelte Teilmatrix+HY-B-Teilmatrix+prod2-Entscheid | Wellenplan |
| OV-2/OV-3 — Null-Bump-Umfang / 4. Ebene | OWNER-ENTSCHEID | W2 | Z714 | OFFEN | blockiert W2 | Wellenplan |
| ##52 — Vor-Gate §59-SCHEMA + zwei getrennte GOs | AUFGABE | W3-MESS | Z718 | GEPLANT | — | Wellenplan |
| ##53 — 320er zuerst, dann gedeckelte Teilmatrix, je Batch am Abend | AUFGABE | W3-MESS | Z718 | GEPLANT | Bilanz A+B==C, Inhalts-Gate mit Marker, Frische csv_dieser_lauf>=1 | Wellenplan |
| ##54 — Auswertung NUR in Batch-Pausen (§61) | AUFGABE | W3-MESS | Z718 | GEPLANT | — | Wellenplan |
| ##55 — L3-Asymmetrie prod1-eigen (2x128 MiB CCD) | AUFGABE | W3-MESS | Z718 | GEPLANT | braucht kein prod2 | Wellenplan |
| ##56 — Rueckschrieb WRITE-Token/NAS/minio inkl. xlsx | AUFGABE | W3-MESS | Z718 | GEPLANT | Commit nur bei datenzeilen_gesamt>=1 | Wellenplan |
| OV-15 — beide GOs bis Sa 29.08. 06:00 | OWNER-ENTSCHEID | W3-MESS | Z720 | OFFEN | jeder Verzugstag frisst 1:1 Fenster | Wellenplan |
| ##57 — Break-Even auf D4f-Typ | AUFGABE | W4-AUSWERTUNG | Z728 | GEPLANT | Umfang gemaess OV-1/OV-6; "kein Break-Even bestimmbar" != "bestimmt: keiner" | Wellenplan |
| ##58+##58b — Anhang-Wache (InputIfFileExists-Ziele) | AUFGABE | W4-AUSWERTUNG | Z728 | GEPLANT (Nenner NEUGEMESSEN 13.08.) | \thesisfinal macht Ersatztext zu LaTeX-Fehler; \|\| echo honest-empty faellt ersatzlos | Wellenplan |
| ##58-Nenner "28" ist mit KEINER Zaehlweise reproduzierbar — UNBELEGT | REGRESSION | — | Z728, 732-757 | BEHOBEN (Wache misst Soll selbst zur Laufzeit) | 6 Zaehlweisen durchprobiert (12 roh/10 unkommentiert/10 eindeutig/...); auch alte "13" (KON6-07/3) reproduziert nicht; eingefrorene Konstante durch Laufzeit-Nenner ersetzt | Wellenplan |
| ##59 — FF0-FF4, Nenner 5, leere Frage=rot | AUFGABE | W4-AUSWERTUNG | Z728 | GEPLANT | — | Wellenplan |
| ##60 — Ergebniskapitel C5 (Zahlen ins ##44-Geruest) | AUFGABE | W4-AUSWERTUNG | Z728 | GEPLANT | jede Tabelle mit Lauf-Provenance; DE fuehrt, EN zieht nach | Wellenplan |
| ##61 — Backups sofort | AUFGABE | W4-AUSWERTUNG | Z728 | GEPLANT | — | Wellenplan |
| P-1 — Praesens-Zusagen-Wache (3 Zusagen) | AUFGABE | W4-AUSWERTUNG | Z728 | TEILWEISE ERLEDIGT | Zwei-Maschinen KORRIGIERT per OV-5, Resume ERFUELLT per ##35, Konformitaet ERFUELLT per perm_runner/OV-8 | Wellenplan |
| ##62 — PDF aus sauberem Checkout (W5-SICHERUNG) | AUFGABE | W5-SICHERUNG | Z761 | GEPLANT | Warnings<=1, .blg alphadin, Anhang gegen Nenner, DE/EN konsistent, Spiegel synchron, Overleaf-Identitaet | Wellenplan |
| §75-Aufraeumpass (104 offen) | AUFGABE | W7 | Z765 | VERTAGT | Behaelter nach Abgabe | Wellenplan |
| ##40-Restbau (T-06...T-14, W-03, W-08, A14, A10) | AUFGABE | W7 | Z765 | VERTAGT | s.a. Wiederaufnahme-Marker (T-13/T-14 vor W3, T-07/T-08 vor Trigger/W2, Rest W4) | Wellenplan |
| HY-Vollausbau (Heuristik-Familie, Mehrfach-Aufbau, scharfe Eviction, Paper-Kopplung) | FEATURE | W7 | Z765 | VERTAGT | — | Wellenplan |
| Record-and-Replay | FEATURE | W7 | Z765 | VERTAGT | — | Wellenplan |
| Paper-Kopplung (OV-14) | AUFGABE | W7 | Z765 | VERTAGT (Owner-entschieden, bleibt in W7) | — | Wellenplan |
| prod2-Lane/pmc:intel/P-E-Trennung | FEATURE | W7 | Z765 | VERTAGT (Owner-entschieden, bleibt in W7) | — | Wellenplan |
| D1c-Ausbau falls Floor-Rueckfall gezogen wurde | AUFGABE | W7 | Z765 | VERTAGT (bedingt) | — | Wellenplan |
| B-Spline (je nach OV-1) | AUFGABE | W7 | Z765 | VERTAGT (bedingt) | — | Wellenplan |
| Voll-Messung als Kampagnen-Programm | AUFGABE | W7 | Z765 | VERTAGT (Owner-entschieden, bleibt in W7) | — | Wellenplan |
| PV-1 | AUFGABE | W7 | Z765 | VERTAGT | — | Wellenplan |
| Doku-Anker-Sanierung | AUFGABE | W7 | Z765 | VERTAGT | — | Wellenplan |
| KORREKTUR-EINSCHUB 10.08. — Kritischer Pfad bis ##25 DURCHSTICH ist jetzt leer | REGRESSION | — | Z923-925 | BEHOBEN (Pfad neu bestimmt) | durchgestrichene Glieder erledigt/gestrichen (F1-KERN); Durchstich haengt jetzt an neuem Riss | Wellenplan |
| Durchstich-Riss: measurement_line ist len=0 (2-arg-Zweig COMDARE_ANATOMY_VERSION_STAMP) | REGRESSION | W0b (F1) | Z925-927 | OFFEN-REGRESSION | einziger verbleibender Blocker vor F1 | Wellenplan |
| Owner 10.08.: "system sollte immer vorn stehen, organ hinten" | OWNER-ENTSCHEID | — | Z927-929 | BINDEND | entspricht Stufen-Anordnung; zwei Aenderungen noetig, nicht nur Stempel-Heilung | Wellenplan |
| Zeitrechnung Kritischer Pfad: 26 von 27 Werktagen belegt, Rest-Reserve 1 WT+~7 WE-Tage | UNKLAR (Planungsrechnung) | — | Z932 | GEMESSEN/GEPLANT | 2 WE(W-1)+2,5AT(W0a)+2,5AT(W0b)+5AT(W1)+5AT(W2)+5,75 Maschinentage+1AT+3AT+2 Fangnetz+2AT Sicherung | Wellenplan |
| Defizit-Arithmetik: ~76h Defekt-Pflicht + HY-A/B/C(~3-4AT) gedeckt durch ~10-11WT gestrichenes v1-Programm, Saldo=0 bis -1WT | UNKLAR (Planungsschaetzung) | — | Z934 | GESCHAETZT | ausdruecklich als Schaetzung gekennzeichnet | Wellenplan |
| WIEDERAUFNAHME-MARKER 18.08. — Deckungs-Streichungen (F-07b,##40,##15,Register-Vollautomation) wiederaufgenommen | OWNER-ENTSCHEID | par.21 | Z938-941 | GELTEND | Saldo-Rechnung nur Historie; Arithmetik-Korrektur = Task #98 | Wellenplan |
| Vier-Formen-Schein-Gruen + fuenfte (Wache mit sich selbst einig) | REGRESSION | — | Z947 | BEHOBEN (Vertrag schliesst Klasse aus) | guard431.log als Beispiel: "431 von 431 GRUEN" blind fuer Job-Baum | Wellenplan |
| V-1 NENNER (Vertragszeile) | FEATURE | — | Z953 | GELTEND | Grundmenge gedruckt+geprueft, Nenner 0=Exit!=0 | Wellenplan |
| V-2 KOEDER BEIDSEITIG (K13) | FEATURE | — | Z954 | GELTEND | Rot-Lauf vor Heilung protokolliert, Gegenköder unmanipuliert bleibt gruen | Wellenplan |
| V-3 GATE-VOLLZUG | FEATURE | — | Z955 | GELTEND | Job-ID+Log-Zeile eines gefahrenen Laufs, YAML-Absicht zaehlt nicht | Wellenplan |
| V-4 DIFFERENZ-BELEG | FEATURE | — | Z956 | GELTEND | zwei Zustaende, beide Zahlen | Wellenplan |
| V-5 DUAL-WEG (§61) | FEATURE | — | Z957 | GELTEND | CI und baremetal, beide literal | Wellenplan |
| V-6 PLAN-NENNER beidseitig (verschaerft) | FEATURE | — | Z958 | GELTEND (verschaerft ggue v1) | Paket ohne Abnahmezeile UND Abnahmezeile ohne Paket = nicht abgenommen | Wellenplan |
| V-7 FREMDER NENNER (neu, aus D1c/D2) | FEATURE | — | Z959 | NEU GELTEND | mind. eine Zahl aus anderer Quelle als sich selbst | Wellenplan |
| V-8 GEGENSTAND STATT ANKUENDIGUNG (neu 09.08.) | FEATURE | — | Z960 | NEU GELTEND | hebt §11.4-Pruefffrage2 in operativen Vertrag; Beispiele LAG-P1, D3-2 | Wellenplan |
| LAG-P1 — bestandslog aktiv-Zeile fiel, Schreibweg scheiterte DANACH, Emission lief ohne Abbruch weiter | REGRESSION | — | Z960 | OFFEN-REGRESSION | "leeres Lager fuer scharf gehalten"; s.a. ##21, W3-MESS-Haertung ##56 | Wellenplan |
| ##02 "diff --stat 17->0" gehaertet (V-8) | REGRESSION | W-1 | Z972 | BEHOBEN (gehaertet) | braucht Gegenprobe im selben Lauf (bekannt abweichendes Ref-Paar >0) + rc direkt hinter Aufruf (K11) | Wellenplan |
| D1d "grep -rnF '404 statt 406'=0" gehaertet (V-8) — ugrep uebersieht .gitignore-Inhalt still | REGRESSION | W-1 | Z972 | BEHOBEN (gehaertet) | ugrep 7.5.0 vs GNU grep 3.11; Koeder 1 von 2 gefunden, rc blieb 0; Fix: --no-ignore + beissender Koeder | Wellenplan |
| test:unit R5.G-Zeile gehaertet (V-8) — CMake message() zur Configure-Zeit meldet 48 auch bei 0 .so | REGRESSION | W0a | Z974 | BEHOBEN (gehaertet) | zusaetzlich find .so auf Platte gezaehlt im selben Job | Wellenplan |
| ci/tests/mess_ausbeute_bissprobe.sh --selbstbiss + CI-Job test:mess-ausbeute-bissprobe | FEATURE | W0b | Z976 | GEBAUT | ohne allow_failure, Koeder je Lauf gewuerfelt | Wellenplan |
| ##56 gehaertet (V-8) — Git-Stand allein ist Ankuendigung, object_stat gegen minio/NAS fehlt noch | REGRESSION | W3-MESS | Z982 | OFFEN (benannt, unerledigt) | Bestandslog-Wache sagt selbst: "ZUSICHERT NICHT... gehoert an ein object_stat" | Wellenplan |
| STELLVERTRETER-DURCHGANG 09.08.: 56 Formeln geprueft, 4 gehaertet, 52 halten | REGRESSION | — | Z968 | BEHOBEN (4/56 gehaertet) | gehaertet: ##02, D1d, W0a-DLL-Zaehler, ##56; 2 weitere ausserhalb Nenner (D3-2, ##21) in §4 geheilt | Wellenplan |
| ##40 Restbau — "Preis des Owner-KERN Hybrid" | OWNER-ENTSCHEID | W7 | Z992 | GELTEND | Bausteine ohne Konsument tragen keine Messung | Wellenplan |
| prod2/Intel-Lane (S-05,U-06 pmc:intel,U-07,B-3-Spalte,D2-G5-Vollausbau) | OWNER-ENTSCHEID | — | Z994 | GESTRICHEN (Empfehlung OV-5b) | nur 3-Zeilen-Host-Bericht (D2-G5) gebaut; 3 Praesens-Zusagen zurueckgenommen statt erfuellt | Wellenplan |
| Voll-Messung (524.288 Binaries, >=143 Tage einthreadig) faellt IMMER | OWNER-ENTSCHEID | — | Z995 | GESTRICHEN | genau EINE gedeckelte Kampagne via measure_selection, ETA<=4,5 Maschinentage | Wellenplan |
| T-15/D4-Streichung (Frist-Entwurf) — abgelehnt | OWNER-ENTSCHEID | — | Z996 | GESTRICHEN (Streichung selbst abgelehnt = D4 bleibt Pflicht) | Owner-KERN "DEFEKT=IMMER BEHEBEN"; Frist-Gift-Argument durch Rerun-Deckel entschaerft | Wellenplan |
| NULL-Bump (Frist-Entwurf) — abgelehnt als Total-Streichung, uebernommen als Wache | OWNER-ENTSCHEID | W2 | Z997 | GELTEND | EIN Buendel Mo 24.08., danach NULL-Wache | Wellenplan |
| Break-Even-Neubau B=3 (gemaess OV-1) | AUFGABE | — | Z1002 | OFFEN (bedingt) | faellt Definitionskonsolidierung nicht bis F2, faellt Break-Even GANZ aus Ergebnissen | Wellenplan |
| D4a-Vorzeichenfrage (p=1.0 vs 0.0 bei se=0) NICHT im Code entschieden | OWNER-ENTSCHEID/AUFGABE | W1 | Z1003 | OFFEN | nur degeneriert=true+Ausschluss aus Familie; Methodik-Fussnote statt still geaenderter Zahl | Wellenplan |
| EN-Nachzug nur berührte Kapitel (DE führt) | OWNER-ENTSCHEID | — | Z1006 | GELTEND | EN zur Abgabe nicht vollsynchron | Wellenplan |
| measure:smoke-Wiederbelebung faellt (bleibt deprecated) | AUFGABE | — | Z1007 | GESTRICHEN | nur 3-Zeilen-Helfer-Umbau D3-2 | Wellenplan |
| Streichkaskade bei globalem Zeitriss (5 Rang-Punkte + NICHT-streichbar-Liste) | OWNER-ENTSCHEID | — | Z1008 | GELTEND (spaeter stillgelegt s.u.) | 1.##40-Reste 2.F-07b 3.HY-C-Umfang 4.Break-Even-Neubau 5.##41-Stufe2; NICHT streichbar: 3 Praesens-Zusagen, HY-A/B, D5-1+D4-Trio, W0a/W0b-Wachen | Wellenplan |
| WIEDERAUFNAHME-MARKER 18.08. — HY-Vollausbau nicht mehr W7 | OWNER-ENTSCHEID | par.21 | Z1018-1020 | GELTEND (Fortschreibung) | Mehrfach-Dock=HY-B/W3-Design+W4-Bau nach HY-C; Heuristik-Familie/Eviction=W4 nach HY-C | Wellenplan |
| WIEDERAUFNAHME-MARKER 18.08. — Aufraeumpass/Record-and-Replay/PV-1 nicht mehr W7-Endlager | OWNER-ENTSCHEID | par.21 | Z1022-1024 | GELTEND (Fortschreibung) | W4/W5-Randslots GEZAEHLT (Di-25-Schnitt); objektiv Nach-Abgabe nur per Owner-Satz | Wellenplan |
| WIEDERAUFNAHME-MARKER 18.08. — Rutsch-Klassifizierung ##24/##15 AUFGEHOBEN | OWNER-ENTSCHEID | par.21 | Z1026-1028 | GELTEND (Fortschreibung) | ##15-EMITTER/TEMPLATE=W2-Slot, ##24/A9-S5a=W4 | Wellenplan |
| WIEDERAUFNAHME-MARKER 18.08. — ##31/D1c Rueckfallstufen bleiben ungezogen, Vollformen=W2-W-Posten | OWNER-ENTSCHEID | par.21 | Z964-966, 1030-1032 | GELTEND (Fortschreibung, zweifach im Text) | — | Wellenplan |
| WIEDERAUFNAHME-MARKER 18.08. — Streichkaskade als Instrument STILLGELEGT | OWNER-ENTSCHEID | par.21 | Z1034-1037 | GELTEND (Fortschreibung, ersetzt Kaskade oben) | Limit=pausieren/sequentialisieren+Register-Platzierung, NIE reduzieren; Pos.1(##40) wiederaufgenommen, Pos.2 Owner-Pflicht(F-07b/#98); NICHT-streichbar-Liste gilt fort | Wellenplan |
| OV-13 HYBRID — Ketten-Zerlegung HY-A/HY-B/HY-C mit F8-Minimal-DoD bestaetigen | OWNER-ENTSCHEID | — | Z1047 | OFFEN (Frist Mo 10.08., Empfehlung: ja) | bei "nein" entspannt sich W1 um ~4 Tage, ##40 kehrt zurueck | Wellenplan |
| OV-3 4. MESS-EBENE — hybrid-lokal oder globales Glied? | OWNER-ENTSCHEID | — | Z1048 | OFFEN (Frist Mi 19.08. vor ##34, Empfehlung: hybrid-lokal) | — | Wellenplan |
| OV-12 HYSTERESE — Bereichs-Erkennung oder Stoerung? | OWNER-ENTSCHEID | — | Z1049 | OFFEN (Frist Mo 17.08. abends, Empfehlung: Bereichs-Erkennung) | bis Entscheid keine Variante verdrahtet | Wellenplan |
| OV-4 MESS-DECKEL — groesste Teilmenge ETA<=4,5 Maschinentage | OWNER-ENTSCHEID | — | Z1053 | OFFEN (Frist an F2, Empfehlung: ja) | einzige Rechnung >=143 Tage schliesst Vollraum aus | Wellenplan |
| OV-1 BREAK-EVEN — B=3-B-Spline neu bauen oder Hermite ratifizieren? | OWNER-ENTSCHEID | — | Z1054 | OFFEN (Frist Mo 17.08., ECHTER Widerspruch offen vorgelegt) | Risikosicht sagt Hermite, Owner-KERN sagt B=3; "dein Satz entscheidet" | Wellenplan |
| OV-6 BE-DEFINITION — Break-Even faellt ganz aus falls nicht bis 21.08. konsolidiert | OWNER-ENTSCHEID | — | Z1055 | OFFEN (Frist an F2, Empfehlung: ja) | kapitel/ hat 0 Treffer "Break-Even" | Wellenplan |
| OV-10 CEB-VARIANTEN — Teilmengen-Lesart (max.4 erreichbar) | OWNER-ENTSCHEID | — | Z1056 | OFFEN (Frist vor ##32, Empfehlung: ja) | echte 3!-Permutation waere Gate-Modell-Umbau im Identitaetsfenster | Wellenplan |
| OV-8 TREIBER — ce perm_runner faehrt Voll-Lauf | OWNER-ENTSCHEID | — | Z1057 | OFFEN (Frist vor W2, Empfehlung: ja) | 05_evaluation.tex:138 bleibt ohne Textaenderung wahr | Wellenplan |
| OV-14 PAPER-KOPPLUNG — Bau nach Abgabe + Methodikgrenze-Satz | OWNER-ENTSCHEID | — | Z1058 | OFFEN (Frist Mo 17.08. sonst automatisch W7, Empfehlung: ja) | LEDGER:11128 | Wellenplan |
| OV-18 STREICHKASKADE — neue Streich-Reihenfolge bestaetigen | OWNER-ENTSCHEID | — | Z1061 | OFFEN (Frist Mo 17.08., Empfehlung: ja) | weicht von v1 ab (Hybrid faellt durch Owner-KERN nicht mehr) | Wellenplan |
| MARKER 12.08 (KON39) — OV-10 praezisiert, OV-13 Zeitbezug korrigiert | OWNER-ENTSCHEID | — | Z1063 | GELTEND (Fortschreibung) | OV-10: gegenstandslos NUR Nenner-/6er-Frage, Anordnungs-Gegenstand neu per KON37-03 -> §17.2; OV-13: "SPAETER" -> jetzt direkt/delegiert (KON36/KON21-01) -> §17.5 | Wellenplan |
| OV-9/OV-11 (v1) aufgegangen in OV-5/OV-8; OV-14-alt bleibt offen | OWNER-ENTSCHEID | — | Z1065 | OFFEN (OV-14-alt, an F2 mitvorgelegt) | RF-5, A5-Value-Filter | Wellenplan |
| R-1 — lebender Messweg war unbeobachtbar (hoechstes Risiko) | UNKLAR (Risiko-Register) | W0b | Z1071 | TEILWEISE ADRESSIERT | Gegenmassnahme D3-Kette+Durchstich; Restrisiko: erste echte Rot-Laeufe brauchen Budget | Wellenplan |
| R-2 — Menge/Anker (verschaerft aus v1) | UNKLAR (Risiko-Register) | W1/W2 | Z1073 | OFFEN | Gegenmassnahme Sperrlisten-Wache(##14)+NULL-Wache(##34)+Kalibrierlauf(##47); Kipp-Punkt Fr 28.08. 06:00 | Wellenplan |
| R-3 — die drei Praesens-Zusagen | UNKLAR (Risiko-Register) | — | Z1075 | OFFEN | Gegenmassnahme P-1: erfuellt bis F4 ODER korrigiert bis F5 | Wellenplan |
| R-4 — Statistik-Erstlaeufe koennen rot sein | UNKLAR (Risiko-Register, erwarteter Fund) | W0a/W0b | Z1077 | OFFEN | AllFourteenAxesPopulated bei 22/18 Achsen Kandidat; mehr als 2 rote Faelle=eigener Posten, nie allow_failure | Wellenplan |
| R-5 — HY-Ueberlauf | UNKLAR (Risiko-Register) | W1 | Z1079 | OFFEN | An-10 ohne Objekt-Basis; F8-Minimalschnitt bindend, HY-C=Streichkaskade Rang3 | Wellenplan |
| R-6 — prod1-Platte/RAM (83% voll, 43G frei) | REGRESSION | — | Z1081 | OFFEN | Gegenmassnahme BUILD_JOBS-Deckel(D1a), ##48 druckt Zahlen vor Trigger, Lastfreiheit angeordnet (An-7) | Wellenplan |
| R-7 — GO-Verzug | UNKLAR (Risiko-Register) | W3-MESS | Z1083 | OFFEN | ohne beide GOs bis Sa29.08 06:00 schrumpft Fenster 1:1 | Wellenplan |
| R-8 — Drift-Gate-Rerun-Rate unbekannt | UNKLAR (Risiko-Register) | W2 | Z1085 | OFFEN | Rerun-Deckel im Code, Rate im Kalibrierlauf(##47) erhoben | Wellenplan |
| R-9 — die Korrektur-Fassungen selbst koennten falsch korrigiert sein | REGRESSION | — | Z1087 | OFFEN (Meta-Risiko) | jede korrigierte Formel braucht Gegenkoeder+Bissbeweis vor Verlass | Wellenplan |
| An-1 — bleibt gestrichen (v1: als R-4/OV-5 hochgestuft) | AUFGABE | — | Z1107 | GESTRICHEN | — | Wellenplan |
| An-8 — Consumer-Silizium verliert 4 ISA-Registrierungen; "424 statt 428" widerlegt | REGRESSION | — | Z1100 | BEHOBEN | Differenz -4 gemessen (3 ce-Staende gleich); absolute Zahlen je Klasse jetzt 429/425/423 (Gegenorakel) | Wellenplan |
| An-9 — super-Zahlen 610/186 GEMESSEN 10.08, BEIDE Erklaerungen widerlegt | REGRESSION | — | Z1101 | BEHOBEN | loest Einwand-36-Frage: weder enable_testing()-Reihenfolge noch EXCLUDE_FROM_ALL erklaeren es; Ursache=BAU-ZUSTAND (gtest_discover_tests legt 20/488 NOT_BUILT-Platzhalter an, ohne Labels); 610/186 nicht reproduzierbar, gelandet super 41b20a16 | Wellenplan |
| An-2,An-4,An-6,An-7,An-10,An-11,An-12,An-13 — uebrige benannte Annahmen | UNKLAR (Annahmen-Register) | diverse | Z1095-1106 | UNGEPRUEFT/TEILWEISE | Mess-Dauer je Binary, a9-s4-mess-report baubar, Doku-Drift, prod1 Lastfreiheit, HY-A-Aufwand, Template-Befunde lokal statt live, CI-Aussagen ohne Job-ID, Durchstich mit D5-1-Kanon gesichert | Wellenplan |
| 11.1 — 32,5% der Widerrufe hielten Nachpruefung nicht stand | REGRESSION | — | Z1138-1142 | BEHOBEN (Konsequenz gezogen) | 9/9 Bestaetigungen brauchten Schaerfung, >=4/9 Widerrufe selbst falsch; Verifikationsvertrag gilt jetzt AUCH fuer Widerrufe/Richtigstellungen/Klassifikationen | Wellenplan |
| 11.2 — "Der Stellvertreter"-Mechanik (5 Klassen, 15 Belege) | UNKLAR (Referenz-Erkenntnis) | — | Z1150-1161 | DOKUMENTIERT | "richtiges Messgeraet am falschen Gegenstand" erzeugt kein Fehlersignal | Wellenplan |
| 11.3 — NEUE ABNAHME-REGEL "was erzwingt das Halten?" (aendert §6) | FEATURE | — | Z1163-1178 | NEU GELTEND (bindend) | nur Werkzeug ODER ausdruecklich ungedeckte Stelle zaehlen; "wir achten darauf"=nicht abgenommen; 7/10 Verschaerfungen hielten (die ins Werkzeug gebrannten), 3 disziplinaere kamen zurueck | Wellenplan |
| 11.4 — Fuenf Pruefffragen vor jedem Paket (Nenner/Gegenstand/Zeitrichtung/Deckung/Widerruf) | FEATURE | — | Z1180-1200 | NEU GELTEND | stehen VOR dem Bau; Zeitrichtung: 6/6 Selbstwiderlegungen kamen NACH der falschen Aussage beim Owner; Widerruf: 13/40 Faellen war Antwort nein, Korrektur-Momentum ersetzt Pruefung | Wellenplan |
| 11.5 — Rueckkopplungs-Schleife (Breite->Takt->Stellvertreter->Aussage vor Messung->Korrekturschleife->weniger Zeit->mehr Breite) | REGRESSION | — | Z1204-1211 | DOKUMENTIERT | 9 Workflows/114 Agenten, 1/9 fristkritisch; Owner: "zuerst fallende Stufe ist das Gedaechtnis" | Wellenplan |
| 11.5 KONSEQUENZ — Workflow ist kein Fortschritt ohne Landung auf krit. Pfad | FEATURE | — | Z1213-1216 | NEU GELTEND | vor jeder Fan-out-Runde: "liegt das auf dem Weg zum 15.09.?" sonst W7-Behaelter | Wellenplan |
| WIEDERAUFNAHME-MARKER 18.08. — "W7-Behaelter" (11.5) kein Endlager-Weg mehr | OWNER-ENTSCHEID | par.21 | Z1218-1220 | GELTEND (Fortschreibung) | gezaehlte Platzierung im Wiederaufnahme-Register statt stilles Ausbuchen; Pfad-Frage bleibt gueltig | Wellenplan |
| 11.6 — Lead-Praemissen haeufiger falsch als Agenten-Arbeit (5x/8x); kein Agent widerlegte je Owner am Objekt | REGRESSION | — | Z1224-1230 | DOKUMENTIERT | Owner korrigierte sich zweimal selbst; Fehler entstehen wo aggregiert wird, nicht wo Objekte angefasst werden | Wellenplan |
| 11.6 KONSEQUENZ — "Objekt vor Aggregat" fuer §4 | FEATURE | — | Z1232-1233 | NEU GELTEND | erst Datei/Zeile/Lauf, dann Zusammenfassung | Wellenplan |
| 12.1 — 157 Behauptungen TDD-Kritik: 117 bestaetigt/geschaerft (386h), 40 fielen (1/4), 62 Funde nur Meta-Stufe | REGRESSION | — | Z1246-1251 | DOKUMENTIERT | einstufige Kritik verliert 1/4 + uebersieht >Haelfte des Fundvolumens | Wellenplan |
| 12.1 — 13/40 Gefallene waren Fehler der ERSTEN Schaerfungsstufe selbst | REGRESSION | — | Z1253-1257 | BEHOBEN (identifiziert+korrigiert) | P99IstNichtDasMaximum unerfuellbar, falsches Winsor-Orakel bei geradem n, Tautologie-Schleife, 2 falsche Ganzheits-Nenner | Wellenplan |
| T-1 ROT ZUERST | FEATURE | — | Z1265 | NEU GELTEND (bindend) | Test rot am ersten Tag ODER Biss per Wegwerf-Mutation bewiesen | Wellenplan |
| T-2 AUSSAGE NICHT ANWESENHEIT | FEATURE | — | Z1266 | NEU GELTEND (bindend) | find()/Exit0/"wirft nicht" sind keine Zusicherungen | Wellenplan |
| T-3 NENNER FREMD | FEATURE | — | Z1267 | NEU GELTEND (bindend) | Grundgesamtheit aus anderer Quelle als Pruefling | Wellenplan |
| T-4 GEGENEINGANG | FEATURE | — | Z1268 | NEU GELTEND (bindend) | zu jeder Zusicherung ein Eingang bei dem sie nicht gilt | Wellenplan |
| T-5 ORAKEL UNABHAENGIG | FEATURE | — | Z1269 | NEU GELTEND (bindend) | nie aus gepruefter Funktion, nie aus Kritik-Material abgeschrieben | Wellenplan |
| T-6 SCHWESTERPFLICHT | FEATURE | — | Z1270 | NEU GELTEND (bindend) | jeder Fix sucht Schwesterstelle (beide Writer/Genera/Backends/Engines) | Wellenplan |
| T-7 REGISTRIERUNG IST TEIL DES TESTS | FEATURE | — | Z1271 | NEU GELTEND (bindend) | Test existiert erst in ctest -N + Binary im Bauweg; Belegstand 4 unregistriert+27 unsichtbar+F15-if-Block | Wellenplan |
| T-8 ATOMARE LANDUNG | FEATURE | — | Z1272 | NEU GELTEND (bindend) | Test+Minimalbau landen atomar auf development | Wellenplan |
| T-9 TESTKRITIK | FEATURE | — | Z1273 | NEU GELTEND (bindend) | neue Tests jeder Welle durch Codex-Pass+Objektpruefung in Folgewelle | Wellenplan |
| Testklasse keine-negativprobe (29) | REGRESSION | — | Z1279 | OFFEN | Mutant ueberlebt, nur gesunde Seite betreten | Wellenplan |
| Testklasse anwesenheit-statt-bedingung (25) | REGRESSION | — | Z1280 | OFFEN | geprueft: da, nicht: gilt | Wellenplan |
| Testklasse kein-nenner (23) | REGRESSION | — | Z1281 | OFFEN | Teilpruefung tritt als Ganzheit auf | Wellenplan |
| Testklasse unerreichbarer-block (16) | REGRESSION | — | Z1282 | OFFEN | Test laeuft nie, billigste Klasse pro Stunde | Wellenplan |
| Testklasse test-zementiert-defekt (10) | REGRESSION | — | Z1283 | OFFEN | Orakel aus dem Pruefling selbst | Wellenplan |
| Testklasse zwei weitere (12) + Einzelfaelle (2) | REGRESSION | — | Z1284-1285 | OFFEN | nach Hausregel keine eigene Klasse | Wellenplan |
| Testlast W-1: 1 Posten 3h Band A | AUFGABE | W-1 | Z1293 | GEPLANT | ST-CTestWache zuerst (enable_testing-Wurzelfix + Soll/Ist-Wache) | Wellenplan |
| Testlast W0a: 3 Posten 9h Band A, 1/5h Band B | AUFGABE | W0a | Z1294 | GEPLANT | MT-L4, AS-Bewaffnung, HY-Label-Gate; rote Statistik-Suite (Landung D4 in W1) | Wellenplan |
| Testlast W0b: 15 Posten 40h Band A, 9/21,5h Band B | AUFGABE | W0b | Z1295 | GEPLANT | Testseite D3-4/D3-5; F1-Testlieferung: kein Zaehler luegt mehr | Wellenplan |
| Testlast W1: 23 Posten 99h Band A, 22/62h Band B — ENGPASS DES GESAMTEN PLANS | REGRESSION | W1 | Z1296 | OFFEN (Ueberlast-Risiko) | MT-L3-Schema-Orakel VOR D4d zwingend; HY-Reroute-Vertrag zuerst (definiert HY-A) | Wellenplan |
| TDD-Plan "47 von 47 Stellen" nicht reproduzierbar | REGRESSION | W1 | Z1296 | BEHOBEN (korrigiert) | belastbar: 29 Aufruf-Stellen in 17 UE (ce 25fe4fbf); Zaehler eingefrorener Orakel=0; bewacht durch ci/plan_zahlen_wache.sh | Wellenplan |
| Testlast W2: 8 Posten 21h Band A, 23/67h Band B | AUFGABE | W2 | Z1297 | GEPLANT | nur Mo/Di/Fr Slots; Band A=Kampagnen-Wahrheit, Landung bis F3 | Wellenplan |
| Testlast W3-MESS: 0h neue Testarbeit | AUFGABE | W3-MESS | Z1298 | GELTEND | W0b/W2-Gates SIND die Batch-Abend-Instrumente | Wellenplan |
| Testlast W4: 3 Posten+HY-Ebene4b 34h Band A, 4/11h Band B | AUFGABE | W4-AUSWERTUNG | Z1299 | GEPLANT | HY-Kurvenlage/Ausgaenge/HonestEmpty MIT HY-C | Wellenplan |
| Testlast W7: Band C 5 Posten 13h + alles ungelandete Band B (Start 59 Posten/166,5h) | AUFGABE | W7 | Z1301 | VERTAGT (gezaehlte Warteliste) | nicht als stilles Vergessen | Wellenplan |
| WIEDERAUFNAHME-MARKER 18.08. — Band-Semantik (B=Slot, C=W7) ueberholt | OWNER-ENTSCHEID | par.21 | Z1303-1306 | GELTEND (Fortschreibung) | Band B=konkrete Slots (W2-Randslots, WE, W3-Batch-Pausen, W4); Band C fahrbar (WinPCM Runner online, AmdL3->#87, Rest W4) | Wellenplan |
| Drei Einfuege-Regeln Testlast (Landung folgt Bauwelle, W3-MESS blechexklusiv, HY-A in W1) | FEATURE | — | Z1308-1313 | GELTEND | T-8 atomar; HY-A reiner TDD-Fall (0 Zeilen Bestand, Test ist Spezifikation) | Wellenplan |
| 12.5 — Kapazitaetskonflikt: Bedarf 117 Posten/386h, Band A=53 Posten/206h | UNKLAR (Kapazitaetsrechnung) | — | Z1317-1327 | GEMESSEN/GESCHAETZT | ~131,5h wandert in Paketbudgets, ~30h in D-Posten eingepreist; eigenstaendig Band A ~75h; Kapazitaet ~118h (Annahme, keine Messung) | Wellenplan |
| 12.5 KONSEQUENZ — W1 traegt 99h Band A auf bereits voller Woche | REGRESSION | W1 | Z1329-1332 | OFFEN (Risiko) | reisst W1, reisst Freeze und Kette dahinter | Wellenplan |
| 12.5 — Band B in W1 gilt als "nicht eingeplant", faellt zuerst geschlossen nach W7 | OWNER-ENTSCHEID | W1 | Z1334-1336 | GELTEND | mit Zahl im Protokoll, nicht durch Weglassen | Wellenplan |
| WIEDERAUFNAHME-MARKER 18.08. — Band B/W1 (22 Posten,62h) NEU platziert | OWNER-ENTSCHEID | par.21 | Z1338-1340 | GELTEND (Fortschreibung) | W2-Randslots Mo/Di 24./25.+WE 22./23. nach S-19/T-15b + Rest W3-Batch-Pausen | Wellenplan |
| 12.6 — Codex-Einsatzregeln (5 Regeln) | FEATURE | — | Z1356-1364 | GELTEND | nur frisch gepinnter SHA beide Repos; Output=Kartierung nie Zitat; Meta-Stufe Pflicht; je Welle Codex-Pass(T-9); NICHT fuer Aufwandsschaetzung/Wellen-Zuordnung/Owner-Entscheide | Wellenplan |
| 12.6 — Codex schwach: Vorfahr-SHA 85847715 statt HEAD 7bcf353b, Drift-Abschnitt durch D4-Heilung ueberholt | REGRESSION | — | Z1348-1351 | DOKUMENTIERT | + Zeilenanker auf Nachbargegenstaende, Ganzheits-Behauptungen an Teilmengen, Koeder die nicht beissen | Wellenplan |
| Band C (5 Posten,13h,W7): MT-L8, PM-PAPI, PM-WinPCM, PM-AmdL3 T1-2, AG-PunktFixes, PM-NichtGelesen-HW | AUFGABE | W7 | Z1368-1373 | VERTAGT | PM-WinPCM: Windows-Zweig vertragslos (kein Runner im Fristpfad); PM-AmdL3-Teil0 (Kommentar-Richtigstellung, 0,2h) SOFORT | Wellenplan |
| Band B (59 Posten,166,5h): AG-Pakete(33h), XL-Haertung(31h), AS-Block(17h), PK-Folgeposten(19h) | AUFGABE | W7 | Z1375-1379 | VERTAGT (mit Zaehlern) | Concept-Trennschaerfe/Vendor-Randfaelle/Registry-Drift/Produzenten-Grenzen bleiben ungepinnt | Wellenplan |
| WIEDERAUFNAHME-MARKER 18.08. — Band C fahrbar geworden | OWNER-ENTSCHEID | par.21 | Z1381-1384 | GELTEND (Fortschreibung) | PM-WinPCM ueberholt (Windows-Runner 4/4 online seit #60->W2/W4), PM-AmdL3 1-2=Talos-Lane #87, MT-L8/PM-PAPI/AG-PunktFixes->W4, Band B->W3-Batch-Pausen+W4 | Wellenplan |
| Bewusst nie getestet: Holm/Bonferroni malformte p-Werte, v32_orchestrator-Stub, alpha=1-Konstruktion, HDR (nur falls D5-5 "fuehren" entscheidet) | AUFGABE | — | Z1386-1387 | GESTRICHEN (bewusst) | — | Wellenplan |
| Owner-Auftrag 11.08.: "konsolidiere unseren Aufgabenstand ... in die korrekt passenden Wellen" | OWNER-ENTSCHEID | — | Z1393-1394 | BINDEND | Abschnitt ordnet zu, entscheidet nicht neu; Quellen KON6-KON10, 91 Task-Posten | Wellenplan |
| Owner 11.08.: "jedes Detail geplant, komplexe Architektur angelegt, muessen ihr nur noch Herr werden" | OWNER-ENTSCHEID | — | Z1404-1407 | BINDEND | Selbstkompilations-Entwurf KON10 seit 19.07.; Stempel-Architektur Satz fuer Satz abgenommen KON7/8/9 | Wellenplan |
| Harter Blocker: Phase 0 (super-Repo reconcilen) fehlt | REGRESSION | — | Z1414-1416 | OFFEN-REGRESSION | ohne sie erzeugt jeder Bau am Planer-Kopf eine DRITTE Enumerations-Engine; Bauplan 19.07. eigene adversariale Kritik | Wellenplan |
| Status 11.08. nachts: W-1 ABGESCHLOSSEN, W0a LAEUFT (endet in Stunden) | AUFGABE | W-1/W0a | Z1422-1423 | Fortschreibung | W0b/F1 in 3 Tagen, W1/F2 in 10 Tagen, W2/F3 Bau-Trigger 26.08 | Wellenplan |
| W0a-Rest korrigiert 11.08.: D1e,D1f,D1c,D2-G2,##06-CI-Haelfte,##07 bleiben offen | AUFGABE | W0a | Z1428-1429 | OFFEN (Fortschreibung) | Rest der W0a-Liste | Wellenplan |
| ERLEDIGT+zu streichen (11.08.): D2,D2-G1,D2-G3,D2-G4,D2-G5,D5-1,D1g | AUFGABE | W0a | Z1429-1430 | ERLEDIGT (Fortschreibung, ersetzt fruehere GEPLANT-Eintraege) | D1g bestaetigt per An-9 (super 41b20a16) | Wellenplan |
| D2-G6-Status "nicht erhoben" (11.08.) | AUFGABE | W0a | Z1430 | OFFEN (unklar, nicht gemessen) | — | Wellenplan |
| W0b-Rest (11.08.): D3-1-Marker-Haelfte, D3-4+D3-5(Bau fehlt trotz OV-16 entschieden), D3-8, ##08-Rest, ##20-B-Restbau, ##21-2.Haelfte(object_stat), ##23-R1, ##26, ##27-##31 | AUFGABE | W0b | Z1432-1434 | OFFEN (Fortschreibung) | OV-16 zu diesem Zeitpunkt bereits ENTSCHIEDEN (vor Frist Mi 12.08.), Bau selbst aber noch offen | Wellenplan |
| ##25 DURCHSTICH — "kein Paket, kein Besitzer" (Stand 11.08.) | REGRESSION | W0b (F1) | Z1434, 1466 | OFFEN-REGRESSION (kritisch) | ohne Besitzer bis Mi mittag ist F1 nur halb (GOAL:494) | Wellenplan |
| Drei Wirkungsklassen (P)Preimage/(M)Mengen/(W)Werkzeug fuer Wellen-Zuordnung | FEATURE | — | Z1438-1452 | NEU GELTEND | (P) muss vor F2, (M) muss vor Bau-Trigger, (W) muss vor Gegenstand da sein; ersetzt themenbasierte Zuordnung | Wellenplan |
| Owner 11.08.: "es wurde nie eine Flotte gebaut" — Identitaets-Umbauten heute kostenlos | OWNER-ENTSCHEID | — | Z1454-1456 | BINDEND | ab Mi 26.08. 06:00 entwertet dieselbe Aenderung 41,4h Bau | Wellenplan |
| #21 — ##25 DURCHSTICH (Task-Nummerierung) | AUFGABE | W0b | Z1466 | OFFEN-REGRESSION | die F1-Lieferung selbst, ohne Besitzer | Wellenplan |
| #90 — Bump-Pflicht-Wache Teil 1 (Riegel), VORGEZOGEN | AUFGABE | W0b (W) | Z1469, 1473-1477 | GEPLANT (vorgezogen aus W2) | Stempel=Cache-Schluessel; Aenderung ohne Bump=Binary nicht neu gebaut=Lauf schneller UND falsch; auch ##47 laeuft sonst blind | Wellenplan |
| #83 — lint:format ohne lokale Deckung | AUFGABE | W0b (W) | Z1470 | GEPLANT | dreimal in Folge Format-Nachzug, blockiert jede Landung | Wellenplan |
| #80 — coverage-guard deterministisch rot | AUFGABE | W0b (W) | Z1471 | GEPLANT | F1-vor-F2-Reihenfolge bindend (Dual-Review) | Wellenplan |
| #87 — Funktions-Variablen in Stufigkeits-Ordnung | AUFGABE | W1 (P) | Z1483 | GEPLANT | aendert Argument-Reihenfolge des Preimage | Wellenplan |
| #78 — Stempel-Reihenfolge System-vor-Organ | AUFGABE | W1 (P) | Z1484 | GEPLANT | aendert Zeilen-Ordnung im Preimage; s.a. Owner 10.08. Z927-929 | Wellenplan |
| #86 — Stempel-Mechanik (drei Flaeche-2-Schichten) | AUFGABE | W1 (P) | Z1485 | GEPLANT | erzeugt den Stempel ueberhaupt | Wellenplan |
| KON9-05 — Achsen-Algo-Hardware-Stempel X.Y.Z in voller System-Syntax | AUFGABE | W1 (P) | Z1486 | GEPLANT | jeder Algorithmus bekommt neue Versionszeile | Wellenplan |
| KON9-04 — drei Grammatiken je Phasigkeit | AUFGABE | W1 (P) | Z1487 | GEPLANT | bestimmt Schreibweise jeder Zeile | Wellenplan |
| KON9-05 — Ordnungs-Relation als constexpr | AUFGABE | W1 (M) | Z1488 | GEPLANT | entscheidet Teilmengen, nicht Identitaet | Wellenplan |
| #67 — Benennung: vier Familien, 142 Include-Kanten | AUFGABE | W1 (P) | Z1489 | GEPLANT | Umbenennung beruehrt 29 Include-Wanderungen | Wellenplan |
| #68 — selektiver Rebuild/Additivitaet | AUFGABE | W1 (M) | Z1490 | GEPLANT | muss vor dem Bau stehen | Wellenplan |
| Kollision W1: 99h Band A + Stempel-Strecke zusaetzlich | REGRESSION | W1 | Z1494-1495 | OFFEN (Risiko, 3 Entlastungen gezogen) | Entlastung 1: Band B in W1 faellt geschlossen (62h) | Wellenplan |
| Entlastung 2: Reserve-WE 15./16.08.+22./23.08. gezogen | AUFGABE | W1 | Z1500-1501 | GEPLANT | 22./23. war ohnehin fuer HY-A reserviert | Wellenplan |
| Entlastung 3: Designplan-Bestand kleiner als gedacht (3/4 Selbstkompilations-Bausteine bereits gebaut) | AUFGABE | — | Z1502-1504 | TEILWEISE ERLEDIGT | 5/7 F1-Kern-Explores SCHON_ERLEDIGT (dup Fussnote F1-KERN); KON10-05 | Wellenplan |
| Prioritaet bei W1-Riss: Ordnungs-Relation(M)+#68(M) fallen zuerst nach W2; #87/#78/#86/KON9-05/HY-A duerfen NIE fallen | OWNER-ENTSCHEID | W1 | Z1506-1507 | GELTEND | mengen- vs preimage-wirksam als Prioritaetskriterium | Wellenplan |
| #90 (zweiter Teil) — CI-Geruest vier Mini-Pipelines je Traeger | AUFGABE | W2 (M) | Z1513 | GEPLANT | D17: fuenf Stufen | Wellenplan |
| Buildsystem-Cache scharf: prod-MinIO fuer generierte Folge-Stufen | AUFGABE | W2 (M) | Z1514 | GEPLANT | D18/§31-A4 | Wellenplan |
| #82 — ueberlebender Mutant bvset_ist_teilmenge | AUFGABE | W2 (W) | Z1516 | OFFEN-REGRESSION | Mutationstest-Fund | Wellenplan |
| #19 — Thesis-Textpflichten | AUFGABE | W4-AUSWERTUNG | Z1520 | GEPLANT | laeuft mit ##60 | Wellenplan |
| #66 — Lizenz, prt-art/overleaf-Rest | AUFGABE | W5-SICHERUNG | Z1521 | GEPLANT | gehoert zu ##62 | Wellenplan |
| W7-Behaelter (14 gezaehlte Posten): #29,#30,#32,#34,#42,#44,#48,#50,#63,#64,#69,#71,#72,#26 | AUFGABE | W7 | Z1525-1530 | VERTAGT (mit Zaehler) | wide_aggregat-Dedup(#29)·zwei Parses(#30)·LAG-Z1/EXCLUDE_FROM_ALL(#32)·2 Owner-Fragen aus T-15(#34)·blinde Wache(#42)·-Werror global(#44)·Gate-Luecke(#48)·Mutations-Recherche(#50)·tote Ledger-Anker(#63)·d2floor-Tests(#64)·W12-B(#69)·-Wstringop-overflow(#71)·2-Pass-Falle(#72)·Abnahme-Entwuerfe haerten(#26) | Wellenplan |
| WIEDERAUFNAHME-MARKER 18.08. — die 14 W7-Posten gehen NICHT nach W7 | OWNER-ENTSCHEID | par.21 | Z1532-1534 | GELTEND (Fortschreibung) | W4/W5-Randslots GEZAEHLT je Di-25.-Schnitt; W5 traegt nur Nicht-Bau-Anteile | Wellenplan |
| #91 — PHASE 0: Blocker vor Selbstkompilations-Strecke (zweite Enumerations-Engine im super-Repo) | REGRESSION | — | Z1540-1549 | OFFEN-REGRESSION (nicht terminiert) | v32_messreihe_antrieb.hpp:214 "der OFFIZIELLE Einstieg"; neuer ExperimentPlanDirector waere DRITTE Engine; = P-0 | Wellenplan |
| #88 — KONSOLIDIERUNGS-ARCHITEKTUR, Owner-Reihenfolge 11.08. | OWNER-ENTSCHEID | — | Z1551-1562 | BINDEND (Reihenfolge, keine Wellen-Zuordnung) | 1.Stempel zuende(LAEUFT) 2.Pipeline debuggen(NAECHSTES) 3.Konsolidierung(#88); Vorrang vor W0b/W1-interner Ordnung | Wellenplan |
| SELBSTKOMPILATIONS-STRECKE HAT KEINEN WELLEN-PLATZ — "ehrlichster Befund" | REGRESSION | — | Z1564-1572 | OFFEN | Planer-Kopf im Entwurf selbst als "groesstes Loch (PL-1)" gefuehrt; W2 baut heute mit HEUTIGEM Bauweg | Wellenplan |
| Varianten (A)/(B)/(C) zur Selbstkompilations-Strecke, Empfehlung (A) | OWNER-ENTSCHEID | — | Z1574-1586 | OFFEN (an F1 vorgelegt) — SPAETER VERWORFEN s.u. §14 | (A)Stempel ja+Selbstkompi nach W7 (B)Beides vor F2=Pfad reisst (C)Selbstkompi ersetzt W2=hoechstes Risiko; "Vorschlag kein Entscheid" | Wellenplan |
| §1 "HYBRID-Bestand=README.md" UEBERHOLT — 11.08. gemessen 4 Header/943 Zeilen | REGRESSION | — | Z1592-1595 | BEHOBEN (Fortschreibung) | heuristik_adapter_gate(189)+klassifikation(256)+strategy(246)+synthese_matrix(252); AnatomyGenus seit HY-A1 SECHS statt fuenf Werte | Wellenplan |
| §5 "Kette bis ##25 leer" praezisiert — ##25 hat weiterhin KEINEN Besitzer | REGRESSION | W0b | Z1596-1599 | OFFEN-REGRESSION (bestaetigt) | gilt nur fuer gestrichene Kettenglieder, nicht W0b-Postenliste | Wellenplan |
| Ledger waechst an einem Abend von 20.354 auf 20.973 Zeilen | REGRESSION | — | Z1600-1602 | DOKUMENTIERT | jeder Ledger-Anker gilt nur mit Commit-Anker, sonst Symbol-Suche | Wellenplan |
| Stempel-Designplan ST-00...ST-14 (15 Pakete) existiert nicht mehr | REGRESSION | — | Z1603-1605 | BEHOBEN (Neuschnitt statt Nachbesserung) | 0 Treffer ueber 180 Workflow-Outputs, 0 ueber docs/; Paketnamen+4 Nachbesserungs-Befunde erhalten | Wellenplan |
| Bilanz 13.6: 91 Task-Posten gesamt, 56 erledigt, 35 offen (P=6,M=4,W=5,regulaer=6,W7=14) | UNKLAR (Bilanz-Zaehler) | — | Z1611-1616 | GEMESSEN | Stand 11.08.2026 | Wellenplan |
| Owner-Entscheide die Bau blockieren: O-1(Syntax+Semantik Abgabe-Pflicht), Meta-Meta-Achsen(zu recherchieren) | OWNER-ENTSCHEID | — | Z1618-1620 | OFFEN | 2 Stueck, s. O-1/O-4 unten | Wellenplan |
| Bump-Pflicht-Wache = neuer Vorlaeufer im kritischen Pfad (§5) | REGRESSION | W0b | Z1628-1630 | GELTEND | ohne sie faehrt jeder folgende Bau (inkl.##47) auf blindem Cache | Wellenplan |
| OWNER-ENTSCHEID 11.08. NACHTS — "volles Risiko", KOMPLETTE Traeger-Baukette EXAKT wie beschrieben, Variante B | OWNER-ENTSCHEID | — | Z1634-1645 | BINDEND (verwirft Empfehlung A aus 13.4c!) | Owner verbatim: "ich moechte volles Risiko fahren... Aufbau MIT ALLEN TEILEN IN REIHENFOLGE... direkt ins Zielbild"; Varianten A/A+/C GESTRICHEN, gilt (B): Stempel UND Selbstkompilation im Fenster, Wellen/Termine unveraendert | Wellenplan |
| WIEDERAUFNAHME-MARKER 18.08. — Wiederaufnahme-Volumen (>200h) faehrt auf "volles Risiko"-Praezedenz | OWNER-ENTSCHEID | par.21/par.14.6 | Z1647-1650 | GELTEND (Fortschreibung) | Reserve null als Zahl; Deckung: Mehr-Kontingent-Parallelitaet ab 19.08. (6+ disjunkte Straenge, Bau-Slots-Deckel 3 bleibt)+[lok]-Klasse W3; Trigger-Pflichten fahren ZUERST, Wiederaufnahme verdraengt nie; Task #96 | Wellenplan |
| 14.1 Zielbild — ORT/ZEIT/NUTZLAST/IDENTITAET (formale Architektur-Definition) | FEATURE | — | Z1654-1671 | GELTEND | PLANER->CEB->HYBRID->TIER / MESS,SYSTEM,ORGAN; jede Stufe KOMPILIERT die naechste, nichts zur Laufzeit umgeschaltet (D1/D5) | Wellenplan |
| O-1 — Syntax+Semantik je Achsen-Kategorie ueber 'c' hinaus, "Pflicht und Basis fuer Abgabe" | OWNER-ENTSCHEID | — | Z1681 | OFFEN (blockiert S-2,S-3) | — | Wellenplan |
| O-2 — wirkt Hybrid-Einschub auf Organ oder nicht? (KON7-03 vs Grammatik-Zuordnung widersprechen sich) | OWNER-ENTSCHEID | — | Z1682 | GESTRICHEN (s.u. MARKER 13.08 KON59) | blockierte S-2; Kante bleibt gezeichnet, gilt nicht mehr | Wellenplan |
| O-3 — Voraussetzungs-Semantik: fordert Flag Voraussetzung oder impliziert sie? | OWNER-ENTSCHEID | — | Z1683 | OFFEN (blockiert S-3) | Code stellt Frage selbst, algo_semver.hpp:1527-1528, beantwortet sie nicht | Wellenplan |
| O-4 — Meta-Meta-Achsen von System und Organ, "zu recherchieren" | OWNER-ENTSCHEID | — | Z1684 | OFFEN (blockiert S-3) | Organ-Liste leer, System genau eine Familie (SIMD) | Wellenplan |
| O-5 — K1 Lager-Identitaet Hybrid-.so, K2 Loader-Schichten, K5 Snapshot-Aggregations-Semantik | OWNER-ENTSCHEID | — | Z1685 | OFFEN (blockiert S-10) | drei Teilfragen | Wellenplan |
| MARKER 13.08 (KON59) — O-2 GESTRICHEN | REGRESSION | — | Z1687 | BEHOBEN (Fortschreibung) | §15.1, KON8-12/KON13: Hybrid ist Glied der MESS-Kette, nicht BAU-/FREIGABE-Kette; S-2 haengt nur noch an O-1 | Wellenplan |
| P-0 — super-Repo reconcilen (=#91) | AUFGABE | W0b | Z1693, 1765 | GEPLANT | v32_messreihe_antrieb.hpp kartieren/wiederverwenden/deprecaten | Wellenplan |
| S-1 — Gemeinsame Stempel-Basisklasse | AUFGABE | W0b | Z1694, 1765 | GEPLANT | KON7-08; heute fuenf lose Strukturen, vier Namensschemata | Wellenplan |
| S-2 — Drei Grammatiken je Phasigkeit + vierte Klammer-Gruppe Testat-Grammatik | AUFGABE | WE 15./16.08. | Z1695, 1771-1775 | GEPLANT | KON9-04, algo_semver.hpp R1-R8; setzt nur O-1 voraus (O-2-Zusatz gestrichen) | Wellenplan |
| S-3 — Ordnungs-Relation als constexpr + Voraussetzungs-Wache | AUFGABE | W1 | Z1696, 1781 | GEPLANT | KON9-05, bvset_teilmenge.hpp (187Z), Andockstelle seit 07.08. bei :73 | Wellenplan |
| S-4 — Filter-Concepts (Hardware/Mess, mp11) | AUFGABE | W1 | Z1697, 1782 | GEPLANT | KON9-06; ram_probe_chain.hpp:161/:483 concept-CoR existiert bereits | Wellenplan |
| S-5 — Stempel-Factory (compile time) + Composite je Traeger | AUFGABE | W1 | Z1698, 1781 | GEPLANT | KON7/KON8; Planer2·CEB3·Tier4·Hybrid4+Karte | Wellenplan |
| S-6 — Preimage-Ordnung (#87 Stufigkeit, #78 System-vor-Organ, #67 Benennung) | AUFGABE | W1 | Z1699, 1781 | GEPLANT | KON9-01 | Wellenplan |
| S-7 — Achsen-Algo-Hardware-Stempel X.Y.Z voller System-Syntax+Semantik | AUFGABE | W1 | Z1700, 1781 | GEPLANT | KON9-05 | Wellenplan |
| S-8 — Planer-Kopf (Interpreter,Director,IPlanBuilder,CMakeGraphBuilder,CiYamlBuilder,Template-Method,CoR,IExperimentDock+Registry,App-Target,cmake 2-Pass) | AUFGABE | WE 22./23.08.(Teil1)+W2 Mo(Teil2) | Z1701, 1790, 1796 | GEPLANT | BAUPLAN Phase1; Vorbild catalog_codegen.cmake:52-60; Teil1=Interpreter+Director+IPlanBuilder+--dump-plan+Contract-Test | Wellenplan |
| S-9 — CEB-Generierung (CebSystemAxisDrive, harte Kompilation je Messsystem, .so-ABI-Grenze) | AUFGABE | W2 Di | Z1702, 1797 | GEPLANT | BAUPLAN Phase2 §30.3; Vorbild search_algorithm_dock.hpp:63-86 | Wellenplan |
| S-10 — Teilbaum-Serialisierung (Ranges) + Cursor-/Delta-Rueckkanal | AUFGABE | W2 Di | Z1703, 1797 | GEPLANT | §38 | Wellenplan |
| S-11 — ceb:build von Env-Variable auf harte Kompilation umstellen | AUFGABE | W2 Di | Z1704, 1797 | GEPLANT | Audit 05.08.: "durch KEINEN Deferred-Posten gedeckt" (Kernsatz-Verstoss) | Wellenplan |
| S-12 — CI-Geruest, fuenf Stufen, Mini-Pipeline je Traeger | AUFGABE | W2 Di | Z1705, 1797 | GEPLANT | D17, emittiert vom CiYamlBuilder | Wellenplan |
| S-13 — Buildsystem-Cache scharf (CI-Cache=nur Planer, prod-MinIO=alle Folge-Stufen) | AUFGABE | W2 Di | Z1706, 1797 | GEPLANT | D18/§31-A4 | Wellenplan |
| S-14 — Bump-Pflicht-Wache | AUFGABE | W0b | Z1707, 1765 | GEPLANT (vorgezogen, dup #90 Teil1) | KON9-11 | Wellenplan |
| S-15 — Hybrid: Genus mit Flaeche2, drei Anteile, Bereichskarte | AUFGABE | — | Z1708 | TEILWEISE GEBAUT | KON9-02/03; 943 Zeilen bestehen bereits | Wellenplan |
| S-16 — ci/tests/*.sh -> Google Tests | AUFGABE | — | Z1709 | OFFEN | KON6-05 #89; heute 14 Dateien/8.528 Zeilen, wachsend | Wellenplan |
| MARKER 12.08 (KON39) — S-19 neuer Knoten zwischen S-7/F2 und Trigger, produziert B-4-Zahl | AUFGABE | — | Z1717 | GEPLANT (neuer Posten) | KON37-03/KON30-03: Traeger-Stufen-Reihenfolge, Planer zuerst -> §17.5 | Wellenplan |
| Vier harte Reihenfolge-Regeln (14.3) | FEATURE | — | Z1747-1752 | GELTEND (mit Korrekturen s.u.) | 1.Kein Grammatik-Bau ohne O-1(+O-2 urspr.) 2.Kein Planer-Kopf ohne P-0 3.Alles Preimage-Wirksame vor F2(S-1,2,5,6,7) 4.Hybrid nach Einzelmessung(ZEIT) aber vor Tier in Kette(ORT) | Wellenplan |
| MARKER 13.08 (KON59) — Graph-Kante O-2->S-2 GESTRICHEN, Regel1 nur noch "ohne O-1" | REGRESSION | — | Z1745, 1754 | BEHOBEN (Fortschreibung) | Regel2(P-0) begleitend nicht blockierend (§15.5) | Wellenplan |
| W0b Owner-Vorlage O-1...O-5, Frist Do 14.08. | OWNER-ENTSCHEID | W0b | Z1764 | OFFEN (Frist korrigiert s.u.) | sonst rutscht S-2 und ganze Kette | Wellenplan |
| MARKER 13.08 (KON59) — Owner-Vorlage nur O-1,O-3,O-4,O-5 (O-2 raus); Frist Do->Fr 14.08. korrigiert | REGRESSION | W0b | Z1769 | BEHOBEN (Fortschreibung) | 14.08.2026 ist ein Freitag | Wellenplan |
| Bau-Trigger Mi 26.08. 06:00 laeuft jetzt UEBER DIE NEUE TRAEGER-KETTE (nicht mehr alter Bauweg) | REGRESSION | W2 | Z1798 | OFFEN (Risiko-Eskalation ggue. Empfehlung A) | entspricht der zuvor als "hoechstes Risiko" bewerteten Variante (C) aus 13.4c: "der Bau ist der kritische Pfad" | Wellenplan |
| ##47 Kalibrierlauf = "der erste Ernstfall der NEUEN Kette" | AUFGABE | W2 Di | Z1797 | GEPLANT | ersetzt fruehere Formulierung "Ernstfall der Messweg-Ehrlichkeit" | Wellenplan |
| S-15 Hybrid erzeugen+einschieben=HY-B, nach der Einzelmessung | AUFGABE | W3-MESS | Z1804 | GEPLANT (Wellen-Fortschreibung) | — | Wellenplan |
| S-16 laeuft als Dauerposten wo Slots frei werden | AUFGABE | W4/W5 | Z1809 | GEPLANT (Wellen-Fortschreibung) | — | Wellenplan |
| K-1 Fr 14.08.: O-1 entschieden, sonst S-2 rutscht ins WE | FEATURE (Kipp-Punkt) | W0b/F1 | Z1820, 1826 | GELTEND (korrigiert: Do->Fr, O-2 raus) | jeder Verzugstag schiebt F2 | Wellenplan |
| K-2 Fr 21.08.: S-1...S-7 stehen gruen, sonst Freeze haelt nicht | FEATURE (Kipp-Punkt) | W1/F2 | Z1821 | GELTEND | jede spaetere Stempel-Aenderung entwertet Bau | Wellenplan |
| K-3 Di 25.08. abends: ##47 laeuft durch neue Kette gruen | FEATURE (Kipp-Punkt) | W2 | Z1822 | GELTEND | sonst Bau-Trigger faehrt auf ungepruefem Weg | Wellenplan |
| K-4 Mi 26.08. 06:00: Bau-Trigger startet, spaetester Start Fr 28.08. 06:00 | FEATURE (Kipp-Punkt) | W2 | Z1823 | GELTEND | danach faellt W4-Fangnetz ersatzlos | Wellenplan |
| K-5 Do 27.08. abends: Bau ist durch | FEATURE (Kipp-Punkt) | W2 | Z1824 | GELTEND | ohne Bau kein F4, kein Ergebniskapitel | Wellenplan |
| Rueckfallstufe K-3/K-4: heutiger Bauweg bleibt bis F3 im Baum | AUFGABE | W2 | Z1828-1832 | GEPLANT (Sicherheitsnetz) | reisst neue Kette am Kalibrierlauf, faehrt Trigger ueber alten Weg — "kostet Zielbild, nicht Abgabe" | Wellenplan |
| 14.6 — Reserve ist NULL nach "volles Risiko"-Gliederung | OWNER-ENTSCHEID | — | Z1836-1847 | GELTEND | Band B W1(62h)+14 W7-Posten+beide Reserve-WE+W0b-Nachlauf ##27-31+1 Werktag Rest-Reserve alle verbraucht/verdraengt | Wellenplan |
| S-8 GUENSTIGER: ExperimentPlanDirector EXISTIERT BEREITS (unangeschlossen) | REGRESSION | — | Z1864-1867 | BEHOBEN (Planungsfehler korrigiert) | ce profile_facade/planner/experiment_plan_director.hpp; muss verdrahtet, nicht entworfen werden — teuerste Position der Kette | Wellenplan |
| S-14 GUENSTIGER: Bump-Pflicht-Wache EXISTIERT BEREITS, deckt nur 6/136 Dateien (0 unter axes/) | REGRESSION | — | Z1869-1874 | TEILWEISE GEBAUT (Ausroll-Auftrag) | ce tools/axis_version_lock/ + axis_version.lock, verdrahtet ce/.gitlab-ci.yml:768-786; 130 axes/-Header brauchen AXIS_ALGO_VERSION-Marker | Wellenplan |
| B-2 — GitLab-Nesting-Budget ausgeschoepft, technischer Blocker fuer S-12 | REGRESSION | — | Z1878-1889 | OFFEN-REGRESSION | super/.gitlab-ci.yml:2686-2688 Tiefe2; 3/4 Traeger belegen bereits 3 Ebenen; fuer Hybrid keine 4.Ebene; 3 Aufloesungen (Hybrid auf bestehende Ebene / Emission flach / Owner-Entscheid) | Wellenplan |
| B-4 — Wurzel des Buildsystem-Caches hat KEIN Ziel im Code | REGRESSION | — | Z1891-1897 | OFFEN-REGRESSION | comdare-buildsystem=0 Treffer; Ledger-Widerspruch MinIO-Bucket vs NAS-Ordner seit 07.08.; TWO-CACHE-STORAGE-Env-Variablen nie angelegt; S-13 setzt Owner-Entscheid voraus | Wellenplan |
| B-5 — LagerBaumWriter IST GEBAUT UND WIRD NIRGENDS GERUFEN | REGRESSION | — | Z1899-1902 | OFFEN (owner-konform, kein Defekt) | 1 Datei (eigene), ::kaskade(-Aufrufe von aussen=0; Spec-Typ fehlt, setzt B-4 voraus | Wellenplan |
| S-17 — Lager-Baum-Writer verdrahten (neu) | AUFGABE | W2 (mit S-13, s.15.6) | Z1904-1905, 2017-2021 | GEPLANT | ohne ihn hat Messdaten-Kaskade keinen Einsortier-Pfad | Wellenplan |
| O-6 — Mini-Pipeline: GitLab-Child-Pipeline oder Job-Gruppe? | OWNER-ENTSCHEID | — | Z1913 | OFFEN (blockiert S-12) | spaeter GEGENSTANDSLOS s. 16.1 (keine YAML) | Wellenplan |
| O-7 — Mini-Pipelines statisch eingecheckt oder vom Planer emittiert? | OWNER-ENTSCHEID | — | Z1914 | OFFEN (blockiert S-12) | heutige Architektur emittiert; spaeter GEGENSTANDSLOS | Wellenplan |
| O-8 — Wo sitzt Hybrid bei ausgeschoepftem Nesting-Budget? | OWNER-ENTSCHEID | — | Z1915 | OFFEN (blockiert S-12,S-15) | s. B-2 | Wellenplan |
| O-9 — NAS-Ordner oder MinIO-Bucket als Cache-Wurzel? | OWNER-ENTSCHEID | — | Z1916 | OFFEN (blockiert S-13,S-17) | s. B-4; spaeter BEANTWORTET s. 16.1 | Wellenplan |
| O-10 — Mini-Pipeline je Traeger-TYP oder -INSTANZ? | OWNER-ENTSCHEID | — | Z1917 | OFFEN (blockiert S-12) | "je Traeger-Stufe" deutet auf Typ; spaeter BEANTWORTET s. 16.1 | Wellenplan |
| O-11 — Was heisst "eigene Beduerfnisse" konkret? | OWNER-ENTSCHEID | — | Z1918 | OFFEN (blockiert S-12) | Runner-Tags/Toolchain/Sanitizer/Test-Suite; spaeter BEANTWORTET s. 16.1 | Wellenplan |
| Nichtfund: fruehere Owner-Aussage zur Mini-Pipeline-Pflicht nicht auffindbar (Gegenprobe 19 .jsonl+Ledger+docs+Memory) | UNKLAR (methodischer Befund) | — | Z1922-1928 | DOKUMENTIERT | widerlegt Owner-Gedaechtnis nicht; Satz vom 11.08. ist massgebliche+einzige Quelle fuer S1-S7 | Wellenplan |
| IST-Bild S-12: 0 von 4 CI-Trigger-Kanten triggert einen Traeger als Bau-Gegenstand; Hybrid 0 Treffer in beiden CI-Dateien | REGRESSION | — | Z1930-1939 | OFFEN-REGRESSION | super 2768Z/45Jobs/11Stufen; ce 1056Z/25Jobs/6Stufen; "Sieben Owner-Zusagen (S1-S7), 0 von 4 Traegern erfuellt" | Wellenplan |
| Konsistenz-Review 11.08. spaet: 27 Agenten, 20 Korrekturvorschlaege gegengeprueft, 11 fielen | REGRESSION | — | Z1956-1957 | DOKUMENTIERT | §13/§14 bleiben stehen, §15 gilt vor; Ledger KON13 | Wellenplan |
| 15.1 — O-2 ENTFAELLT: W-1 war NIE offene Owner-Frage, sondern Agenten-Widerspruch gegen KON8-12 | REGRESSION | — | Z1961-1974 | BEHOBEN (an 6 Stellen gestrichen) | Hybrid=Glied der MESS-Kette (3 ohne/4 mit Hybrid), nicht BAU-/FREIGABE-Kette (SYSTEM 2/2, ORGAN 2/2); S-2 haengt nur an O-1 | Wellenplan |
| 15.2 — Owner: ZWEI Grammatiken nicht drei, eine existiert schon (G-1 Mess dreiphasig fehlt, G-2 System+Organ zweiphasig Syntax da) | OWNER-ENTSCHEID | — | Z1976-1989 | BINDEND | vierphasige braucht keine eigene Grammatik (Kern ist dreiphasig, s.15.3) | Wellenplan |
| 15.2 — Satz "Grammatik-Zahl nicht schneidbar" faellt aus §14.2/14.3 | REGRESSION | — | Z1988-1989 | BEHOBEN | — | Wellenplan |
| 15.3 — Owner: Vier-Parteien-Kette hat dreiphasigen Kern (2 parallele DREIPHASIG Vertraege ueber Mess-Achse) | OWNER-ENTSCHEID | — | Z1991-2000 | BINDEND | CEB hat konzeptionell 2 dritte Phasen als Kopf, im ORT aber 4 Phasen | Wellenplan |
| S-4 baut NICHT einen vierstelligen Vertrag, sondern zweimal einen dreistelligen parallel | AUFGABE | W1 | Z1997-2000 | GEPLANT (Fortschreibung) | CEB gemeinsamer Kopf; zwei Steuerungswege (Tausch am Pruefdock direkt / Beauftragung an Hybrid) | Wellenplan |
| 15.4 — S-3 FAELLT NICHT: transitiv preimage-wirksam (S-5 haengt von S-3 ab) | REGRESSION | W1 | Z2002-2007 | BEHOBEN (Reklassifikation M->P) | Regel3 §14.3 jetzt: S-1,S-2,S-3,S-5,S-6,S-7; nur #68 faellt bei Zeitnot | Wellenplan |
| 15.5 — P-0 IST BEGLEITEND NICHT BLOCKIEREND: ExperimentPlanDirector bereits im Produktionspfad benutzt | REGRESSION | — | Z2009-2015 | BEHOBEN (widerspricht 14.7-Aussage "unangeschlossen") | profile_run_facade.cpp, ce 670483c0, zweimal bestaetigt KON12-01; P-0 wird zu "super-Seite auf ce-Skelett ziehen" | Wellenplan |
| 15.6 — S-17 gehoert nach W2, zusammen mit S-13 | AUFGABE | W2 | Z2017-2021 | GEPLANT (Wellen-Fortschreibung) | beide haengen an derselben Cache-/Ablage-Klaerung | Wellenplan |
| 15.7 — Frist ist Freitag: "Do 14.08." an 2 Stellen (§14.4,§14.5/K-1) -> "Fr 14.08."; alle 30+ Datum-Paare nachgerechnet | REGRESSION | — | Z2023-2027 | BEHOBEN | sonst keine Abweichung gefunden | Wellenplan |
| 15.8 — S-13 praezisiert: drei Orte, zwei Backends, eine XML (O-9 beantwortet) | AUFGABE | W2 | Z2029-2042 | BEHOBEN (praezisiert) | (1)CCACHE generisch HOT nicht behalten (2)BUILDSYSTEM-CACHE=Projekt-Binaries+Messungen isoliert PR4100 NAS backup1.comdare.de (3)CACHE-ENGINE-EXPERIMENT Cluster_NFS nur finale Zusammenfassung; beide Caches S3+Filesystem, alle 3 per XML konfigurierbar | Wellenplan |
| 15.9 — "7 von 130" (KON12-02) ist KEINE Deckungsquote, Schnittmenge NULL | REGRESSION | — | Z2046-2048 | BEHOBEN (aufgedeckt) | 6 AXIS_ALGO_VERSION-Traeger alle unter heuristik/, 130 axes/-Header ohne jeden *_VERSION-Marker | Wellenplan |
| 15.9 — Owner: "C-4 ist eine ueble Bilanz, muessen trennen und verdrahten" | OWNER-ENTSCHEID | — | Z2050-2051 | BINDEND | — | Wellenplan |
| S-18 — Achsen-Interface-Trennung (neu) | AUFGABE | — | Z2053-2056 | OFFEN (Umfang Gegenstand laufenden Explores) | MARKER 12.08 KON39 BEANTWORTET: Home-Prinzip (KON27-01) definiert S-18 vollstaendig — je Kategorie ein Home+EIN Waechter, zweistufige Versionierung, golden zuerst -> §17.5 | Wellenplan |
| 15.10 — 14 von 17 Bau-Teilen NIE gegen Code gemessen (nur P-0,S-14,S-17); Stunden-/Tage-Aufwand von S-1...S-18 an KEINER Stelle beziffert | REGRESSION | — | Z2060-2062 | OFFEN-REGRESSION | "Termine unveraendert" ist aus dem Dokument allein NICHT entscheidbar | Wellenplan |
| §16 Anlass — Owner-Antwortrunden 11./12.08. (KON16-KON21) + 3 Workflows (WF1/WF2/WF3 -> KON20/22/23) | OWNER-ENTSCHEID | — | Z2068-2074 | GELTEND | §16 gilt bis KON23, Vorrang §17(KON24-38); WF4 laeuft; Referenz-Konsolidierung KON19-00 folgt separat | Wellenplan |
| O-1 (Fortschreibung) — Grammatik EXISTIERT bereits (Flag-Grammatik v2, gebaut+gelandet 07.08.) | REGRESSION | — | Z2080 | BEHOBEN | Rest-Fork F1 (cp/ce Klammerformen c{p}/c{e}); S-2=G-2-Semantik-Nachzug, kein Neuentwurf | Wellenplan |
| O-3 (Fortschreibung) — BEANTWORTET je Seite: Freigabe impliziert, Compile-Seite fordert, beide gebaut+heute leer/inert | OWNER-ENTSCHEID | — | Z2081 | ENTSCHIEDEN (KON16-02/KON23-02) | S-3/S-7 sind AKTIVIERUNGS-Auftraege | Wellenplan |
| O-4 (Fortschreibung) — NICHT leer: SIMD=System-Meta-Meta, Festplatten-IO=Organ-Meta-Meta | OWNER-ENTSCHEID | — | Z2082 | ENTSCHIEDEN (KON19-01) | verknuepft je Tier-Binary=je Gattung+Genus; WF4-E-A erhebt Bestand | Wellenplan |
| O-5 (Fortschreibung) — K2+K5 BEANTWORTET: CEB direkt ODER delegiert, Hybrid via wiederverwendete CEB-Module+Sync-Kanal | OWNER-ENTSCHEID | — | Z2083 | TEILWEISE ENTSCHIEDEN (KON21-01/KON19-02) | keine Aggregation, Durchreichung ueber Flaeche3; K1 bleibt offen | Wellenplan |
| O-10 (Fortschreibung) — BEANTWORTET: anforderungsgetrieben, Zahlen aus Planungs-Simulation (S-19) | OWNER-ENTSCHEID | — | Z2086 | ENTSCHIEDEN (KON17-01) | — | Wellenplan |
| O-11 (Fortschreibung) — BEANTWORTET: Emission endet im Lager, J-1...J-4 mitemittieren | OWNER-ENTSCHEID | — | Z2087 | ENTSCHIEDEN (KON17-02) | Rest-Fork F8 (Lint/Release) | Wellenplan |
| O-12 — XML-Kanal: EINE Einstiegs-XML, rekursiv, XML-Syntax=Programmiersprache (neu, beantwortet) | OWNER-ENTSCHEID | — | Z2088 | ENTSCHIEDEN (KON19-03) | S-8 entblockt | Wellenplan |
| O-13 — dump-plan: Director-Methode, vermutlich ueberholt (neu) | OWNER-ENTSCHEID | — | Z2089 | OFFEN | WF4-E-C klaert Herkunft | Wellenplan |
| O-14 — Registry: Option1 geschichtet, Code=Wahrheit Freigabe/XML=Wahrheit Realisierung/Binary=XML-Teilmenge (neu, beantwortet) | OWNER-ENTSCHEID | — | Z2090 | ENTSCHIEDEN (KON21-02) | Registry-Arbeit S-2/S-9 entblockt | Wellenplan |
| S-6 ENTSPERRT+geschnitten: S-6a MESS,SYSTEM,ORGAN-Umstellung an 3 Aussen-Ebenen | AUFGABE | W1 | Z2091 | GEPLANT (KON20/21-03) | POD braucht Layout-Bump, Konflikt mit decl.hpp:293-Verbot vorab loesen | Wellenplan |
| S-6b — Transpositions-Sperre (mit S-6) | AUFGABE | W1 | Z2091 | GEPLANT | — | Wellenplan |
| S-6c — Kategorien-Ordnungs-Wache (neu, Owner-GO) | AUFGABE | W1 | Z2091 | GEPLANT | — | Wellenplan |
| S-6d — #67 explore+schaerfen, behalten | AUFGABE | W1 | Z2091 | GEPLANT | Verbotszonen: Lager-Kaskaden, Unterachsen-Quellen, Hash-Mechanik | Wellenplan |
| S-12 (Fortschreibung) — NEU GEFASST: Bau-Modul (C++23-Planer-Bibliothek) emittiert Beschreibung, reale Prozesse im BuildOrchestrator | AUFGABE | W2 | Z2092 | GEPLANT (KON18-01) | anforderungsgetriebene Uebergabe+J1-J4-Emission+CEB-Sequenz Tier->Hybrid+F4-Entscheid | Wellenplan |
| S-13 (Fortschreibung) — von "post-Abgabe-Kandidat" zu DER KERN DER ABLAGE (Owner-Ruege) | REGRESSION | W2 | Z2093 | BEHOBEN (Fehleinstufung korrigiert, KON17-04) | Reihenfolge: Stempel->Planungs-Simulation->von XML gesamte Kette bis PDF, mit allen Abzweigungen | Wellenplan |
| S-16 (Fortschreibung) — verschaerft: "Gebaut wird immer, skip ist VERBOTEN", beide Compiler Pflicht-Parallel | OWNER-ENTSCHEID | — | Z2094 | BINDEND (KON22) | — | Wellenplan |
| S-19 — PLANUNGS-SIMULATION (neu): berechnet Traeger-Zahlen je XML-Anforderung | AUFGABE | — | Z2100 | OFFEN (Pflicht nach Stempel-Aufgabe) | KON17-01; Zaehl-Keim PlanSizeBuilder (experiment_plan_director.hpp:489); Plan selbst zu FINDEN (Bestands-Pflicht) | Wellenplan |
| S-20 — SYNC-KANAL CEB<->Hybrid, Loader als wiederverwendetes CEB-Modul | AUFGABE | — | Z2101 | GEPLANT (KON21-01) | AnatomyModuleLoader Modul-Kandidat; Hybrid-Bau-Anschluss=0 | Wellenplan |
| S-21 — Kategorien-Ordnungs-Wache (=S-6c), Vorbild organ_gruppen_decken_die_komposition | AUFGABE | W1 | Z2102 | GEPLANT (KON21-03) | Vorbild CT-bewiesen | Wellenplan |
| S-22 — mess/-SUBSYSTEM als eigene S-Position (Owner KON110-05: "eigene S-Position, additives Feature") | AUFGABE | — | Z2103 | GEPLANT (KON110-05/KON112-10) | ersetzt mess/->TIER-Haelfte von #29-Default; mess/=6 Dateien/1140Z; S-10-Naehe fachlich bestaetigt | Wellenplan |
| ##25 DURCHSTICH weiter ohne Besitzer (V-1) | REGRESSION | W0b | Z2107-2108 | OFFEN | ist die F1-Lieferung; ce-Pipeline rot vor jeder weiteren Landung | Wellenplan |
| S-6-Fenster (S-6a-d) + harte Umbenennungs-Stellen (WF1-G XSD-Enum/Golden) als EIN Aenderungsfenster | AUFGABE | WE/W1 | Z2109-2112 | GEPLANT | Layout-Bump-Konflikt decl.hpp:293 vorab; S-14/S-18 Prio hoch (WF3 Build-Blocker) | Wellenplan |
| S-17+S-13 steigen auf kritischen Pfad; S-19 liefert Bau-Zahlen VOR Trigger | AUFGABE | W2 | Z2113-2115 | GEPLANT | "41,4h fuer 128" als Rechenluecke benannt | Wellenplan |
| Nenner-Vorbehalt: KEINE Kapazitaetsrechnung mit Hybrid-Zahl bis F3 beantwortet | OWNER-ENTSCHEID | — | Z2116-2117 | GELTEND | CEB-Reihe 5->6->12 (W-3), PMC-Multiplikator unbeziffert | Wellenplan |
| MARKER 12.08 (KON39): Nenner ist 32 (KON25-03); "CEB-Reihe 5->6->12" abgeloest | REGRESSION | — | Z2119 | UEBERHOLT-MARKER | Anordnung kehrt als statische Freigabe zurueck (KON37-03) -> §17.2 | Wellenplan |
| F1-F10 + F11 Pruefdock-Zaehlung + F3-Nenner + A-1-Vorlagetext offene Owner-Punkte (Stand 12.08 mittags) | OWNER-ENTSCHEID | — | Z2123-2124 | OFFEN | KON23-07 | Wellenplan |
| MARKER 12.08 (KON39): F1-F11 ALLE geschlossen, R-4 GESTRICHEN, WF7 F-A..F-H per KON37 beantwortet | REGRESSION | — | Z2126 | UEBERHOLT/GESTRICHEN (KON30-04) | lebende Offen-Liste steht §17.1 | Wellenplan |
| Betriebsregel KON38: jeder Stempel-Posten faehrt {model:fable, effort:max} in allen Workflow-Teilen | OWNER-ENTSCHEID | — | Z2132 | BINDEND | S-1..S-7,S-14,S-18,B5,Flaechen,Preimage,Versionierung,S-17 | Wellenplan |
| KON37-01 Wallclock-SOLL MERGE: Freigabe Planer, Entscheidung CEB, Durchfuehrung Vertrag CEB<->Tier/Hybrid | OWNER-ENTSCHEID | — | Z2140 | ENTSCHIEDEN | Vererbungsregel: CEB baut/ruft nur eigene Messeigenschaften | Wellenplan |
| KON37-02 R-1-Rest: Auswahl-Subsystem NEU gebaut, measurement_tooling erweitert (Stufen-Dim.), Altes ARCHIVIERT | OWNER-ENTSCHEID | — | Z2141 | ENTSCHIEDEN | Korrelations-Pflicht Freigabe<->Ausfuehrung per CT-Permutation | Wellenplan |
| KON37-03 KON34-06(b): Reihenfolge zaehlt DOCH als statische Anordnungs-Freigabe (Mess-Achse) | OWNER-ENTSCHEID | — | Z2142 | ENTSCHIEDEN | Adressierung, keine Nenner-Dimension | Wellenplan |
| KON37-05 E-Label-Doppeldeutung: Umbenennung genehmigt, Lastsequenz=Framework-Mess-Achse | OWNER-ENTSCHEID | — | Z2143 | ENTSCHIEDEN | keine dritte "Ebene" | Wellenplan |
| KON37-06 T-15b-Details P.13/14: je 5 fuer Build UND Messung, 3 Erfolgswerte einzeln (KF-10) | OWNER-ENTSCHEID | — | Z2144 | ENTSCHIEDEN | — | Wellenplan |
| KON37-04 OD-7-Rest: W3-Kampagne faehrt --debug, T-3(~12.09.)=echte Messung | OWNER-ENTSCHEID | — | Z2145 | ENTSCHIEDEN | — | Wellenplan |
| KON37-07 W-6: vier Klone = Zielzustand unter Konsolidierungspflicht | OWNER-ENTSCHEID | — | Z2146 | ENTSCHIEDEN | #88 | Wellenplan |
| R-2 nur noch Bezeichner-VORSCHLAG (im S-6-Fenster) | OWNER-ENTSCHEID | — | Z2150 | OFFEN | KON30-02 · KON36-02/F | Wellenplan |
| R-3/B-4-Menge: KEINE Owner-Zahl, S-19 rechnet sie | OWNER-ENTSCHEID | — | Z2151 | OFFEN | KON37-03 · KON30-03 | Wellenplan |
| OF-1 KON34-06(d) 17-vs-18 Dateien System-B-Doppelbau | OWNER-ENTSCHEID | — | Z2152 | OFFEN | KON34-06 | Wellenplan |
| OF-2 KON34-06(a) 32 Docks=32 Mess-Permutationen Bestaetigung | OWNER-ENTSCHEID | — | Z2153 | OFFEN | KON28-03 · KON37-03 | Wellenplan |
| OF-3 O-5/K1 Lager-Identitaet Hybrid-.so; OF-4 O-4-Rest Festplatten-IO | OWNER-ENTSCHEID | — | Z2154 | OFFEN | §16.1 · WF4/E-A | Wellenplan |
| A-1-Vorlagetext vor jeder Backup-Ref-Aktion | AUFGABE | — | Z2155 | OFFEN | Ledger-IV/M | Wellenplan |
| NEU: E-WARMUP-Explore, TEST-KONSOLIDIERUNG-Eigentuemer, T-3-Ripple (XML->PDF-Vollautomatik+Lager-Skip+W5-Fenster) | AUFGABE | — | Z2156 | OFFEN | KON37-06/-08/-04 | Wellenplan |
| MARKER 13.08 (KON59): OF-1..OF-4+E-WARMUP beantwortet; weiter offen R-2/R-3-B-4/A-1/TEST-KONSOLIDIERUNG/T-3-Ripple | REGRESSION | — | Z2158 | TEILWEISE BEHOBEN | zu per KON40-02/-03/-04/41-02/-03/42/45-02/-03/47-03/-04 | Wellenplan |
| Mess-Nenner ist 32 (Tier 2x2 · Hybrid 2x2 · CEB-Wallclock 2); 6 verliert Gegenstand | REGRESSION | — | Z2160-2162 | BEHOBEN (KON25-03) | 6 zaehlte Reihenfolgen (KON34-03); Ordnung kehrt als statische Anordnungs-Freigabe zurueck (KON37-03); Kapazitaet haengt an S-19-Ausgabe | Wellenplan |
| Zwei Mess-Architekturen: System A LIVE (#ifdef abi_adapter.hpp) vs. System B DORMANT (17 Dateien, 0 Aufrufer) | REGRESSION | W1 | Z2164-2166 | OFFEN (KON34-01) | B3 explizit VOR F2 (KON34-04, Owner-Datum); B1/B2/B4/B5 als Ableitung eingeplant | Wellenplan |
| B1 XML-Konsum je Stufe: measurement_tooling+Stufen-Dim., Registry-NEUBAU, Altes ARCHIVIEREN | AUFGABE | W1 (P-Ableitung) | Z2167 | GEPLANT (KON37-02) | Korrelations-Pflicht via Filterketten-Mechanik (KON9-06) | Wellenplan |
| B2 Gate-Trennung G2/G3 | AUFGABE | W1 | Z2168 | GEPLANT | ohne sie ist "Tier je an/aus" unerfuellbar | Wellenplan |
| B3 Hybrid-Gates (erst damit 5 statt 3 Schalter) | AUFGABE | W1 | Z2169 | GEPLANT (KON37-01, Owner-Datum) | Wallclock-Umzug=Schalter-Hoheit, Tier-Pflicht-Wurf abi_adapter.hpp:476-491 faellt | Wellenplan |
| B4 System B umstellen+anschliessen | AUFGABE | W2 | Z2170 | GEPLANT (KON37-03-Zielrolle) | statische Anordnungs-Freigabe statt anzahl==6-Vollmengen-Permutation | Wellenplan |
| B5 Stempel-Pflicht je Schalter | AUFGABE | W1 | Z2171 | GEPLANT (Fable max, KON38) | — | Wellenplan |
| T-15b zweite Retry-Klammer um measure_one_binary, Build+Messung je 5x, 3 Wiederholungen einzeln persistiert | AUFGABE | W2 | Z2176 | GEPLANT (KON37-06) | 5 sitzt falsch auf Drift-Achse (ce 4cd1ab91), Umzug+8-Punkte-Ripple (KON26-04/28-02) | Wellenplan |
| OD-7 HEAVY-Deckel 24->16, Kompensation --debug; Umschaltpunkt T-3(~Sa 12.09.) | AUFGABE | W3 | Z2177 | GEPLANT (KON26-05/28-01/37-04) | Debug-Ergebnisse loeschen = einzige Ausnahme "Messdaten nie loeschen" (KON29-01) | Wellenplan |
| Zweilaniger Kampagnenbetrieb Gen-2: Bestandslog minio, Claims 4096, Takeover ETA+50% | AUFGABE | — | Z2178 | GEPLANT (KON29-04) | Luecken: window_belongs_to unverdrahtet, Messung selbst nicht zweilanig | Wellenplan |
| PRUEFLING: Mess-Unter-Achse des Planers, je Organ-Achse zusaetzl. Algorithmen, XML-beschraenkbar 1-3 | FEATURE | — | Z2182 | NEU GELTEND (KON30-02/31/36-F) | MergeStrategy-Werte SIND die Verbund-Varianten | Wellenplan |
| HOME-PRINZIP: je Achsen-Kategorie ein Home + genau EIN Waechter, zweistufige Versionierung | OWNER-ENTSCHEID | — | Z2183 | BINDEND (KON27-01) | beantwortet §15.9/S-18-Explore vollstaendig | Wellenplan |
| EXPORT/S-13 Option b: je FORMAT ein FORMAT->ZIEL-Eintrag, LaTeX mit Inhalts-Auswahl, PDF lazy | OWNER-ENTSCHEID | — | Z2184 | ENTSCHIEDEN (KON27-02) | — | Wellenplan |
| BAU-REIHENFOLGE-DOKTRIN: PLANER->CEB->TIER->HYBRID ist Ledger-Doktrin-Box (kein Owner-Zitat) | OWNER-ENTSCHEID | — | Z2185 | GELTEND (KON30-03) | S-19 = Knoten zwischen S-7/F2 und Trigger; S-19 PRODUZIERT B-4-Zahl | Wellenplan |
| E-LABELS: Erhebungs-Ebenen umbenannt; Lastsequenz=Framework-Mess-Achse | OWNER-ENTSCHEID | — | Z2186 | ENTSCHIEDEN (KON37-05) | in Umbenennungs-Landkarte | Wellenplan |
| Hybrid-Zeitbezug: "eigenstaendig+Sync-Kanal"=spaeter; JETZT CEB direkt ODER delegiert | OWNER-ENTSCHEID | — | Z2187 | GELTEND (KON36/WF7) | S-20=Neubau fuer spaeter; HY-A/B/C-Zerlegung haelt | Wellenplan |
| KON27-04: 15 Aufgaben (Prio 1-15) den Wellen zugeordnet | OWNER-ENTSCHEID | — | Z2189-2191 | GELTEND | Bestand #7/#10/#11/#13+neu #14-#22 | Wellenplan |
| V-1: ##25-DURCHSTICH (F1-Lieferung Fr 14.08.) bis 12.08 mittags OHNE Besitzer | REGRESSION | — | Z2191 | OFFEN (Sofortposten) | Layout-Bump-Konflikt decl.hpp:293 bleibt benannter Vorab-Posten | Wellenplan |
| KON37-08: 3 Skelett-Testverzeichnisse NICHT mehr W7-Behaelter -> TEST-KONSOLIDIERUNG aktiver Posten | REGRESSION | — | Z2191 | BEHOBEN (Umklassifiziert) | s. Teil D | Wellenplan |
| Owner-Auftrag 13.08.: "Arbeite alle offenen tasks in die Wellen des Wellenplans mit ein" | OWNER-ENTSCHEID | — | Z2196 | BINDEND | Kriterium §13.2 P/M/W; Kostenlage KON6-02/2 (Identitaets-Umbauten ab Mi 26.08. teuer) | Wellenplan |
| Objekt-Pruefstand 13.08: Layout-Gleichheits-Wache ==6 bestaetigt (#15-Vorabposten lebt) | REGRESSION | — | Z2198 | OFFEN | Symbol stamp_pod_has_entries; Loesung=EIN gebuendelter Bruch (KON45-01/3) | Wellenplan |
| Objekt-Pruefstand 13.08: cfg.measurement_sink feuert unbedingt je result.csv (#18-Verstoss lebt) | REGRESSION | — | Z2198 | OFFEN (toleriert bis c) | KON32-01a | Wellenplan |
| Objekt-Pruefstand 13.08: active_organ_required() liefert {} global + C-3a-Tripwire | REGRESSION | — | Z2198 | OFFEN (#38a) | verlangt Owner-Paket-Entscheid | Wellenplan |
| Objekt-Pruefstand 13.08: Legacy-Pfad run_observable_perm misst kalt, Fallback bei unbek. Profil | REGRESSION | — | Z2198 | OFFEN (#38b) | — | Wellenplan |
| Objekt-Pruefstand 13.08: KON44-02-n/a-Zaehler mess_ausbeute_wache.sh BEREITS GEBAUT, CI-Beweis "1 echte 0 n/a" | REGRESSION | — | Z2198 | TEILWEISE BEHOBEN | Pipeline 15764; #38c nur noch Rest (frische_wache/persist_sammler) | Wellenplan |
| Objekt-Pruefstand 13.08: 13 lokale ce-Branches+2 Workflow-Worktrees+Thesis 2x Submodul uninitialisiert bestaetigt | REGRESSION | — | Z2198 | OFFEN | wt-ce-golden-s14a@8cc564d5 · wt-ce-mess-ordnung@4a89aed5 "Paket P1" | Wellenplan |
| Klassen-Regel fortgeschrieben: (P) vor F2 · (M) vor Trigger · (W) vor Gegenstand · (-) Betrieb | OWNER-ENTSCHEID | — | Z2200-2203 | GELTEND | — | Wellenplan |
| NEU AUSGEWIESEN: binary-beruehrender MESS-Code trigger-gebunden, nicht preimage-FORM-wirksam, faehrt als (M) VOR Trigger | REGRESSION | — | Z2204-2206 | BEHOBEN (Klasse ergaenzt) | Praezedenz Strecken-Posten 42/#13 | Wellenplan |
| #36 Fixup 3 landen: Riegel bewacht Grundgesamtheit (387er-Overlay) statt 152 Literal-Zitierer | AUFGABE | W0b | Z2212 | GEPLANT (W, LUECKE=PFLICHT) | KON55-Kombibau; blockiert #33 | Wellenplan |
| #33 S-14a-Riegel Teil 1 landen; Vollausrollung erst NACH S-18-Homes (W2, P.41) | AUFGABE | W0b | Z2213 | GEPLANT (W) | §13.3-Bump-Wachen · KON9-11 · Fessel P11-vor-P4 | Wellenplan |
| #4 S-3 Abnahme (Kombibau 4 Zellen+Inventory-Floor)+Landung, danach S-7 im selben Worktree | AUFGABE | W0b | Z2214 | GEPLANT (P) | §15.4 · KON43-01/1; haengt an S-1 gelandet, Fessel P1-vor-P2 | Wellenplan |
| #10 MinIO-Key-Haelfte SOFORT (Vault-blind+200-Probe) | AUFGABE | W0b | Z2215 | GEPLANT (-) | KON27-04 P.3 · KON22-02; haengt an A-1-Text aus #21 | Wellenplan |
| #21 E-1...E-4-Vollzug+A-1-Vorlagetext, W-6-Gate gefallen | AUFGABE | W0b | Z2216 | GEPLANT (-) | KON37-07 · KON27-04 P.15/P.12 | Wellenplan |
| #37 Disjunktheits-Plan ALS DOKUMENT LANDEN (Lande-Ordnung, geht nicht in Wellen-Zeitordnung auf) | AUFGABE | W0b | Z2218 | GEPLANT (W) | v3.8/A2.1a; im Repo nicht auffindbar, nur Commit-Marker "Paket P1" | Wellenplan |
| #31 13 ungelandete ce-Branches+4 Workflow-Worktrees+Store2+Gitlink: Triage sofort, seriell landen, VOR #19 | AUFGABE | W0b | Z2219 | GEPLANT (-) | KON49 · Owner 13.08. · EIN-SCHREIBER-Regel | Wellenplan |
| NEU #38a Owner-Vorlage: C-3a-Paket-Entscheid, Frist Mi 19.08. sonst Fallregel 18.6(3) | OWNER-ENTSCHEID | W0b | Z2220 | OFFEN | KON47-03 | Wellenplan |
| #16 golden festschreiben -> Homes MESS/SYSTEM+S-18-Waechter+queuing-Umzug | AUFGABE | W1 | Z2226 | GEPLANT (P) | KON27-01 · KON27-04 P.5; haengt #33/#36 (P11-vor-P4) · #24/B2 (P6-vor-P4) | Wellenplan |
| #15 S-6-FENSTER (a MESS/SYSTEM/ORGAN, b Sperre, c S-21-Wache, d #67), letzter Preimage-Schritt | AUFGABE | W1 | Z2231 | GEPLANT (P), GELOEST-DESIGNT (KON45-01/3) | Layout 6->7+Format 4->5+Budget in EINEN Bruch; S-6b vorziehbar ins WE | Wellenplan |
| #17 G-2-Semantik-Nachzug in Achsen-Nummerierungs-Reihenfolge, gibt #7 frei | AUFGABE | W1 | Z2234 | GEPLANT (P) | KON13-03 · KON27-04 P.8 · KON17-01; haengt an #16 | Wellenplan |
| #20 Flaeche-3-Vereinigung: IMessVisitor==measurement-Durchstich | AUFGABE | W1 | Z2235 | GEPLANT (P) | KON25-02 · Strecke P.30; Test-Teil haengt an B2 | Wellenplan |
| WIEDERAUFNAHME-MARKER 18.08 (par.21): #15-Bump-Bruch FIX-KOMPLETT UNGELANDET, e285d316 (32 Commits) | REGRESSION | W1 | Z2237-2240 | OFFEN | wartet auf Audit-Ruecklauf -> Fix-Strecke 2 -> #93 -> Landung vor F2 | Wellenplan |
| FREEZE-CHECK Fr 21.08 alle (P): S-6a-d·S-7·S-5·S-3/#17·ABI-Pflicht·CEB-Stempel·SOLL-Vers.·HY-A·B1·B2/B3/B5·Umbenennung·#38d·#38a2 | AUFGABE | W1 | Z2242 | GEPLANT (Checkliste) | oder deklarierter Fall nach 18.6(3) | Wellenplan |
| #29 Zielstruktur-SCHNITT der vier Traeger-Unterprojekte VOR S-8-Bau; voller Monolith-Split->W7/#88 | AUFGABE | W2 | Z2248 | GEPLANT (W) | KON43-01/2+02; haengt an Abstimmung S-6d/#67 | Wellenplan |
| #38c n/a-Zaehler-REST: frische_wache/persist_sammler nachziehen ODER Arbeitsteilung deklarieren | AUFGABE | W2 | Z2252 | OFFEN (W) | KON44-02; vor W3-Kampagne | Wellenplan |
| W3-MESS (Sa 29.08.-Do 03.09., F4): Debug-GENERALPROBE, T-3-Ripple ausgewiesen | AUFGABE | W3 | Z2262 | GEPLANT | KON37-04/41-01 | Wellenplan |
| W4 (F5 Fr 11.09.): ##58-NENNER-NEUMESSUNG vor Bau, Diskrepanz 28 vs 13; NACHGEMESSEN: weder 28 noch 13 reproduzierbar (10 bzw 12 am Klon) | REGRESSION | W4 | Z2263 | OFFEN-REGRESSION (28 UNBELEGT) | Vor-Bau-Posten: Soll zur Laufzeit erheben, keine eingefrorene Konstante | Wellenplan |
| W5/T-3 (~Sa 12.09.): MANUELLER RESET + ECHTE MESSUNG Sa 12.-Mo 14.09. | AUFGABE | W5 | Z2264 | GEPLANT (harter Anker) | KON41-01 | Wellenplan |
| Kapazitaet W1 offen ausgewiesen: BESTAND 99h Band A+~24h Zweitslot(Annahme)+Stempel-Strecke+#38d+#38a2(~1-2 Tage)+B1-Landung | AUFGABE | W1 | Z2271-2276 | OFFEN (kein Glattrechnen) | §12.5 | Wellenplan |
| FALL-REIHENFOLGE bei W1-Riss: (1)#68->W2 (2)Ordnungs-Relations-M-Anteil->W2 (3)#38a2->W2-Bump-Buendel (4)B1->W2-Anfang | AUFGABE | W1/W2 | Z2277-2281 | GEPLANT (deklarierter Fall) | je mit Zahl im Protokoll | Wellenplan |
| NIE FALLEN: #87 #78 #86 · KON9-05-Stempelzeile · HY-A · #15 · #16/#17 · B3 (Owner-Datum) · #38d | OWNER-ENTSCHEID | W1 | Z2282-2283 | BINDEND | — | Wellenplan |
| WIEDERAUFNAHME-MARKER 18.08 (par.21): Fall-Reihenfolge ist KEINE Ausbuchung — bei Riss pausieren/sequentialisieren, Platz bleibt gezaehlt | OWNER-ENTSCHEID | W1 | Z2285-2288 | GELTEND | NIE-FALLEN-Liste unveraendert | Wellenplan |
| Fessel P11-vor-P4: S-18 verschiebt Homes, die S-14a bewacht -> Riegel Teil 1 (#33) JETZT, Vollausrollung NACH Home-Umzug | AUFGABE | W1/W2 | Z2292-2293 | GEPLANT | Disjunktheits-Plan 13.08. | Wellenplan |
| Fessel P6-vor-P4: B2-Gate-Trennung golden-brechend -> landet VOR #16 | AUFGABE | W1 | Z2294 | GEPLANT | — | Wellenplan |
| Fessel P1-vor-P2: simd_build_gate-Kopplung -> S-3-Landung VOR S-7-Bau, ein Worktree | AUFGABE | W0b/W1 | Z2295-2296 | GEPLANT | wt-ce-mess-ordnung | Wellenplan |
| Fessel P3-vor-P5: anatomy_module_abi_v1_decl.hpp -> EIN Schreiber, alle decl-Aenderungen im EINEN Bump-Buendel-Slot | AUFGABE | W1 | Z2297-2298 | GEPLANT | — | Wellenplan |
| NACHTRAG 15.08: Fessel P6-vor-P4 KORRIGIERT (Gegenstand=B2-Gate-Trennung, nicht Lizenz-Branch); EIN golden-Fenster buendelt B2+#16-Homes+organ_axes+queuing | REGRESSION | W1 | Z2300-2306 | BEHOBEN (KON70-01) | vier Aenderungen als EIN Bruch statt vier | Wellenplan |
| #16+#72+F5 golden-Fenster-Landung (Homes+organ_axes+queuing) NACH B2 | AUFGABE | W1 | Z2311 | GEPLANT (P) | — | Wellenplan |
| #60 Flotten-Runner WS2022/Win11/macOS+runner-mode 3/2 | AUFGABE | W1/W2 | Z2312 | GEPLANT (M) | F7/KON71-03 | Wellenplan |
| #61/#67 Thesis-Trailer-Rewrite -> Code<->Thesis-Sync (B5) | AUFGABE | WE/W1 | Z2313 | GEPLANT (-) | seriell | Wellenplan |
| #62 14 ce-origin-Branches Re-Pruefung->Bundle->Loeschung | AUFGABE | WE | Z2314 | GEPLANT (-) | Frage 8; vor #19 | Wellenplan |
| #64/#66/#68/#73 Zombie-Cancel · Randbestand · Folge-BU · helm-Nachlauf | AUFGABE | WE | Z2315 | GEPLANT (-, laeuft) | — | Wellenplan |
| NEU Paper-Experiment-XML je Paper | AUFGABE | W2 | Z2321 | GEPLANT (M) | mit #18; Fadenriss 20.07. | Wellenplan |
| NEU PMC-Schwester-Design (KON73-01-Kerne) -> Owner-Vorlage -> Bau | AUFGABE | W1/W2 | Z2322 | GEPLANT (P/M) | Design W1, Bau W2 | Wellenplan |
| DOKTRIN-NACHTRAEGE 15.08 (KON71-73): No-Bloat+Planer-Bloat-AUSNAHME · Mess-Interfaces eigene Achse · AND-Freigabe · Drei-Bereiche-Concurrency · OS-Realm-Lager-Pooling · Repo-Rollen · Mess-Permutation DYNAMISCH >32 NUR S-19 | OWNER-ENTSCHEID | — | Z2324-2328 | BINDEND | Meilenstein | Wellenplan |
| Owner 16.08.: "konsolidiere die offenen Posten in die 4 /goal-Referenzdokumente, Drift regelmaessig ausgleichen" | OWNER-ENTSCHEID | — | Z2334-2339 | BINDEND | Quellen KON94-97; §13-18 bleiben stehen, hier gilt vor | Wellenplan |
| #15 fuehrt bereits Layout6->7+Format4->5+Budget in EINEM Bruch; Gegenlese macht daraus VOLLSTAENDIGES Buendel | AUFGABE | W1 | Z2342-2345 | GEPLANT | KON96/Korb A, jeder Posten einzeln abzunehmen | Wellenplan |
| A-01 10. Stempel-Glied fuer ALLE Binaries (Hybrid-Map-Zeile), GliedCount 9->10, im selben Bruch | AUFGABE | W1 | Z2347-2348 | GEPLANT | KON45-01+KON5-04 | Wellenplan |
| A-03 Synthese-Key-Grammatik existiert nicht; Map-VALUE=Tier-SHA statt Voll-Stempel; RT-Cache, Invariante RT⊆CT | REGRESSION | W1 | Z2351-2352 | OFFEN | KON45-01(6)+KON47-02 -> #15/HY-A2 | Wellenplan |
| A-04 VOR dem Bruch entscheiden: Preimage-Glied-FOLGE (fest 9) und AxisKind-Enum-Ordnung im SELBEN Bruch? | AUFGABE | W1 | Z2353-2354 | OFFEN (Design-Entscheid) | KON5-04(3)/KON5-05 | Wellenplan |
| A-05 work_mode: Debug verlaesst Enum, Build tritt ein, kWorkModeCount=4, neue Registry-Zeile | AUFGABE | W1 | Z2355-2356 | GEPLANT | Kette build->measure->compare->release, Besitzer Planer | Wellenplan |
| A-06 Stufe/Phase-Umbenennung ist preimage-/ABI-wirksam, selbe F2-Frist wie S-6 | AUFGABE | W1 | Z2357 | GEPLANT | KON16-09 | Wellenplan |
| A-07 E-1-Heuristik-Rekursion: Tiefe+Stufen-IDs als Stempel-Felder | AUFGABE | W1 | Z2358 | GEPLANT | Owner Z15504 -> #38a2 | Wellenplan |
| A-08 prod2-Umbenennung ("Ja umbenennen"): Registry-Generator spiegelt Namen; VORHER prod2-Identitaet messen | AUFGABE | W1 | Z2359-2360 | GEPLANT | lscpu Alder Lake vs 14900KS-Etikett, r1 C4 | Wellenplan |
| A-09 FullJoin (Pruefling-MergeStrategy) beim S-6-Bau UMBENENNEN — Kollision mit KON91 "FULL JOIN" | REGRESSION | W1 | Z2361-2362 | OFFEN (Namens-Hygiene) | KON30-02 | Wellenplan |
| A-10 S-6-Schnitt KOMPLETT (Umstellung+Sperre+Ordnungs-Wache+#67) + VERBOTSZONEN (Lager-Kaskaden, kOrganGruppen*, Hash-Mechanik) | AUFGABE | W1 | Z2363-2365 | GEPLANT | KON21-03/20-02/5-04 = Inhalt von #15 | Wellenplan |
| A-11 5. ABI-Symbol (Stempel) am Loader heute OPTIONAL (nullptr) — SOLL Pflicht | REGRESSION | W1 | Z2366 | OFFEN | KON7-01 | Wellenplan |
| A-12 B3=Umzug SCHALTER-HOHEIT zur CEB (abi_adapter.hpp:476-491 faellt), kein physischer Umzug | AUFGABE | W1 | Z2367-2368 | GEPLANT (Vererbungsregel) | KON37-01 -> #24-B3 | Wellenplan |
| A-13 EISERNE REGEL bis zum Fenster: nichts unter axes/topics/heuristik/ anfassen (Overlay-Glied[7] hasht Quelltext) | OWNER-ENTSCHEID | W1 | Z2369-2370 | BINDEND | KON58-05, Arbeitsregel ALLER Straenge | Wellenplan |
| A-14 KORREKTUR: "jeder Algorithmus neue Versionszeile" hat NULL Ledger-Treffer; KON9-05 verlangt nur Stempel-Unterstuetzung | REGRESSION | W1 | Z2371-2372 | BEHOBEN (Fehlannahme korrigiert) | KON58-05 | Wellenplan |
| Zusatz r2-r5: kCebFingerprint rendert ANGEBOT statt Wahl | REGRESSION | W1 | Z2374-2375 | OFFEN | r3 A1 | Wellenplan |
| Zusatz r2-r5: COMDARE_MEASUREMENT_ON ABI-wirksam ohne Preimage-Glied | REGRESSION | W1 | Z2375-2376 | OFFEN | r3 A3 | Wellenplan |
| Zusatz r2-r5: O-2 Preimage-Glieder cxx/opt/build_type+bvset fehlen = Owner-Frage Option A/B | OWNER-ENTSCHEID | W1 | Z2376 | OFFEN | r2 A61 | Wellenplan |
| Zusatz r2-r5: VS-A..VS-F STOPP-Gates offen, E-B bricht golden-CRC, fehlt im EINEN golden-Fenster | REGRESSION | W1 | Z2377-2378 | OFFEN | r4 A-07, r5 A34 | Wellenplan |
| Zusatz r2-r5: Versionierungs-Interface+CT-Namensfunktion, Blocker reale Achsen-Typen ohne name() | AUFGABE | W1 | Z2378-2379 | OFFEN | Owner-KERN Vorlaeufer 22.07, r3 A6/A7 | Wellenplan |
| Zusatz r2-r5: run_methodology-Enum-Ordnung=Byte-Ereignis, Owner-Frage G-5/C-7 | OWNER-ENTSCHEID | W1 | Z2379-2380 | OFFEN | r1 A13, r4 C-7 | Wellenplan |
| Zusatz r2-r5: all_axes_golden.profile.xml nicht wohlgeformt, Flag-Ausnahme entfernen | REGRESSION | W1 | Z2380-2381 | OFFEN | r3 A12 | Wellenplan |
| Zusatz r2-r5: F5-Owner-Halbsatz XML-Syntax/Semantik + Planer-Interpreter | OWNER-ENTSCHEID | W1 | Z2381-2382 | OFFEN | r3 A15 | Wellenplan |
| Zusatz r2-r5: telemetry-silent-Wiring golden-gebunden | AUFGABE | W1 | Z2382 | OFFEN | r4 A-01 | Wellenplan |
| Zusatz r2-r5: stale Kommentar bestandslog_document.hpp:22-26 faellt | REGRESSION | W1 | Z2383 | OFFEN | r1 A28 | Wellenplan |
| WIEDERAUFNAHME-MARKER 18.08: Verdachtsfall seg1-44, nur S-6a-Anker-Teil der golden-Nachposten im #15-Bruch | REGRESSION | W1 | Z2385-2390 | OFFEN | Aufloesung Audit-Synthese+ggf. Owner-Satz VOR Landung | Wellenplan |
| PRAEZISIERUNG 17.08 (1): VS-A..F ALLE SECHS seit 07.08. ENTSCHIEDEN (E-B=Variante i, Owner "Wir brechen golden-CRC!") | REGRESSION | W1 | Z2392-2397 | BEHOBEN | offen nur AUSFUEHRUNG A/B/C/D; faehrt im #15-golden-Ereignis | Wellenplan |
| PRAEZISIERUNG 17.08 (2): r3 A1+A3 GEHEILT 06.-07.08. | REGRESSION | W1 | Z2397-2398 | BEHOBEN | ce 62a5b6f7 / 2e1f9c1d | Wellenplan |
| PRAEZISIERUNG 17.08 (3): O-2 AM OBJEKT GEHEILT, Option-A/B-Frage GEGENSTANDSLOS | REGRESSION | W1 | Z2398-2400 | BEHOBEN | Glied[5]=cxx/opt/build_type, Glied[6]=bvset | Wellenplan |
| PRAEZISIERUNG 17.08 (4): all_axes_golden '--'+Flag beidseitig ERLEDIGT seit 08.08. | REGRESSION | W1 | Z2400 | BEHOBEN | ce 90a31961, super 2983e9ba | Wellenplan |
| PRAEZISIERUNG 17.08 (5): Versionierungs-Interface KON7-01/08 legen ABI-Aussenflaeche+CRTP-Pflicht fest, V-07 entschieden | OWNER-ENTSCHEID | W1 | Z2401-2403 | ENTSCHIEDEN | Rest=autonomer Erbinnen-Bau | Wellenplan |
| PRAEZISIERUNG 17.08 (6): G-5/run_methodology bleibt ECHTE Owner-Frage | OWNER-ENTSCHEID | W1 | Z2403-2404 | OFFEN (V-12) | Rest-Vorlage 20260817-OWNER-VORAB-15-restfragen.md | Wellenplan |
| Korb B (#18/S-13+Arena+#57 Lager+Naehte, 20 Posten) fuer Di-25.-Buendel | AUFGABE | W2 | Z2406 | GEPLANT | — | Wellenplan |
| B-01 Naht-Schablone Planer<->CEB: 3 Nachrichtenklassen hinauf, NIE Mess-Rohdaten zum Planer | AUFGABE | W2 | Z2408-2409 | GEPLANT | KON50-01/-02 -> S-8/S-10/#20 | Wellenplan |
| B-02 Steuer-Naht spricht GEFILTERTES XML; Flaeche 3 Signal aus/Messwert-Stream ein, Format SPARSE BINARY | AUFGABE | W2 | Z2410-2411 | GEPLANT | KON51-01 -> #20 | Wellenplan |
| B-03 Arenen je Tier/Hybrid bei Anforderung; OOB=Fertig-Signal; ram_warn 6GB/ram_oob AUS, XML-einstellbar | AUFGABE | W1/W2 | Z2412-2414 | GEPLANT | KON51/52 -> S-13-XSD+S-10 | Wellenplan |
| B-04 Inter-Experiment-Fenster: bidirektionale Sync-Barriere, --auto/manuell/VERNEINEN, kill-OOB | AUFGABE | W2 | Z2415-2416 | GEPLANT | KON53/54 -> S-8+S-10 | Wellenplan |
| B-05 MeasureStorage: acht Owner-Festlegungen+ZWEI Arenen, ALLOKATIONS-VERBOT in Aggregation | AUFGABE | W2 | Z2417-2418 | GEPLANT | -> E1-E11 | Wellenplan |
| B-06 Ursache-Kette: variadische Mess-Template-Variablen NICHT durch Gattung+Genus durchgereicht — Metaprogrammier-Luecke | REGRESSION | W2 | Z2419-2421 | OFFEN | keine Arena-Init, kein flush(), keine Dock-Signale -> E1-E11-Design | Wellenplan |
| B-07 Bestands-Fallen: ThreadArena/InMemoryMeasurementBuffer=Anti-Vorlagen; csv_to_latex->measure_to_latex MIGRATION | REGRESSION | W2 | Z2422-2424 | OFFEN | -> #18+#74 | Wellenplan |
| B-08 Lagerbaum: ZWEI NEUE WURZELEBENEN Gattung->Genus->Binary|Messung->REST fuer ALLE Gattungen/Genera | AUFGABE | W2 | Z2425-2426 | GEPLANT | -> #57 | Wellenplan |
| B-09 Bestandslog NICHT scharf: mess_bestandslog_active=false, Restliste main.cpp | REGRESSION | W2 | Z2427-2429 | OFFEN | -> #57 | Wellenplan |
| B-10 Hybrid: Tier-Bau/-Laden IMMER durch CEB delegiert; Standard-compare->release VOR Hybrid-Dock | AUFGABE | W2 | Z2430-2431 | GEPLANT | -> #57(3)/HY-A | Wellenplan |
| B-11 measure-drop-Kanal ZWEIFACH heilen: Ziel-Filter UND per-Binary-xlsx | REGRESSION | W2 | Z2432 | OFFEN | KON32-01 -> S-13 | Wellenplan |
| B-12 Export-Element Option b + vier ct-gesicherte Rueckschrieb-Methoden; PDF ausserhalb | AUFGABE | W2 | Z2433-2434 | GEPLANT | KON27-02+KON23-03 -> S-13-XSD | Wellenplan |
| B-14 SECHS STEUERDOCKS Planer<->CEB; zwei Rechtsakte (FREIGABE System/DURCHSETZUNG Organ) | AUFGABE | W2 | Z2437-2438 | GEPLANT | -> S-8/S-10 | Wellenplan |
| B-15 Default-Doktrin (constexpr, XML ueberschreibt), Hybrid ZWEIWEGIG XML-steuerbar, Hybrid-Meta-Meta=FAMILIE | AUFGABE | W2 | Z2439-2441 | GEPLANT | KON42+Z13999 -> S-8/S-13/HY-A3 | Wellenplan |
| B-16 Zielform-Pflicht AB SOFORT: S-8/S-9 in Vier-Unterprojekt-Form; #29a Planer-Unterprojekt erster Schnitt | AUFGABE | W2 | Z2442-2443 | GEPLANT | KON43+KON47-01 -> W2-Struktur | Wellenplan |
| B-18 vierte Mess-Ebene=SPALTE der Macro-Stufe (Tier-Stempel je Funktionsaufruf); Overhead=Differenz | AUFGABE | W2 | Z2446-2447 | GEPLANT | -> Mess-Design+S-19-Input | Wellenplan |
| B-19 B1 "direkt neu, Altes archivieren"; Anordnungs-Freigabe je Stufe Subset {W,Ma,Mi} | AUFGABE | W2 | Z2448-2450 | GEPLANT | KON37-02/-03 -> #24-B1/B4-Design | Wellenplan |
| B-20 System B (17 Dateien, dormant) traegt Ordnungs-Maschinerie; B4=9 Kern+8 Ripple "Steuerung->Compile" | AUFGABE | W2 | Z2451-2452 | GEPLANT | KON34-01/04+KON40-02 -> #24-B4 | Wellenplan |
| Korb C (Trigger-/W3-Vorposten, 15 Posten) | AUFGABE | W2/W3 | Z2454 | GEPLANT | Mi 26.08/Kampagne Sa 29.08 | Wellenplan |
| C-01 VOLLBAU-GATE (KON22) als Vorlage VOR dem Trigger — Kopf kennt Trigger, nicht das Gate | REGRESSION | W2 | Z2456-2457 | OFFEN | — | Wellenplan |
| C-02 HEAVY ist SIGNAL-GATED: Signal fuer 26.08.-Fenster muss GESENDET werden | AUFGABE | W2 | Z2458-2459 | GEPLANT | KON58-03 -> Betriebs-Task Infra | Wellenplan |
| C-03 OV-4-Deckel=f(T-3): einlanig 41,4h@24W->~45,6h@16W, kein amd-16W-Trace, Deckel-Rechnung mit S-19 VOR ##51 | AUFGABE | W2 | Z2460-2462 | GEPLANT | KON41-01+58-03 -> #7-Ausgang | Wellenplan |
| C-04 T-15 x KF-10 = 9 Messungen je Zelle: MESS-Phase verdreifacht sich | REGRESSION | W2 | Z2463-2464 | OFFEN | -> --check-size+S-19-Rechnung -> #7 | Wellenplan |
| C-05 Warmup-PAAR-Pflicht: run_observable_perm misst KALT — anpassen oder ausbuchen+Tests | REGRESSION | W2/W3 | Z2465-2466 | OFFEN | KON47-04 -> vor Kampagne | Wellenplan |
| C-06 5/5-Retry-Klammer: Build UND Messung je 5x, 3 Wiederholungen einzeln persistiert | AUFGABE | W2 | Z2467-2468 | GEPLANT | KON37-06 -> #13 T-15b | Wellenplan |
| C-07 T-15-Luecken: Granularitaet "ganzer Lauf neu starten" UNDEFINIERT, T-15 kein CI-Gate | REGRESSION | W2 | Z2469-2470 | OFFEN | -> #13 | Wellenplan |
| C-08 Die 5 sitzt FALSCH auf der Drift-Achse (ce 4cd1ab91): Umzug+8-Punkte-Ripple, Arena-Formel x5 zusaetzlich | REGRESSION | W2 | Z2471-2472 | OFFEN | KON26-04 -> #13 | Wellenplan |
| C-09 DRIFT-GATE OHNE DEBUG-AUSNAHME (RunMethodology=0 Treffer): sonst jede Zelle rot bei --debug-Generalprobe | REGRESSION | W2/W3 | Z2473-2475 | OFFEN | Debug-Zahlen NIE ins Lager (AdmissionStatus existiert) -> mit T-15/D4 VOR W3 | Wellenplan |
| C-10 ZWEILANIGKEIT: resource_group hart amd/prod1, §61-Revision nie umgesetzt, Intel-Gegenstueck fehlt | REGRESSION | W2/W3 | Z2476-2478 | OFFEN | KON29-04 -> Bau-Posten VOR W3 | Wellenplan |
| C-11 HART/SOFT: Achsen failen IMMER hart, NUR fehlende Messeinrichtung (PMC) soft | OWNER-ENTSCHEID | W2 | Z2479-2480 | BINDEND | KON28-02 -> T-15b/#13 | Wellenplan |
| C-12 Fehlerklassen PFLICHT fuer alle Achsen->Unterachsen->Algorithmen, Stand 0/18 bzw 0/121 | REGRESSION | W2/W3 | Z2481-2482 | OFFEN | Owner 17.07. -> T-13/T-14 vor W3 | Wellenplan |
| C-13 Skip-Oekonomie: selektiver Rebuild 27.07. geloescht; System-Aenderung erzwingt Vollflotten-Neubau | REGRESSION | W2/W3 | Z2483-2485 | OFFEN | KON6-03+KON2-09/2-13 -> vor Kampagne wiedergewinnen | Wellenplan |
| C-14 Bestandslog-SKIP-Risiko: je binary_id EIN Eintrag bei 320 bit-identischen IDs — SKIP falsch begruendbar | REGRESSION | W2/W3 | Z2486-2487 | OFFEN | KON3-06 -> Wache vor Kampagne | Wellenplan |
| C-15 MinIO Ebene B: gueltiger Beweis=CI-SMOKE mit Beweiszeile+Gegenkoeder; Falle COMDARE_RUN_MEASURE erzeugt measure:golden-320 | REGRESSION | W2/W3 | Z2488-2490 | OFFEN | KON58-04/#10+KON56-01 -> Betriebs-Task vor Kampagne | Wellenplan |
| WIEDERAUFNAHME-MARKER 18.08: C-12/T-13/T-14 bleiben PFLICHT VOR W3; C-13/C-14 tragen jetzt Board-Task #97; T-07/T-08 VOR Trigger falls mengen-wirksam | REGRESSION | W2/W3 | Z2492-2495 | GELTEND | par.21.4+Wiederaufnahme-Register | Wellenplan |
| Korb D (W2-Triage, lebend ohne Frist-Anker, 24 Posten neben #71) | AUFGABE | W2 | Z2497 | GEPLANT | — | Wellenplan |
| D-01 S-3-Abnahme gebaut (ce 4a89aed5), KON55-Kombibau NIE gefahren; Aktivierungs-Beweis mit ZWEI Zahlen | REGRESSION | W1 | Z2499-2501 | OFFEN | KON58-08+NE-10 -> W1-Rest | Wellenplan |
| D-02 S-7-Bauplan+Fesseln P11->P4·P6->P4·P1->P2·P3->P5+Lande-Ordnung 1-9; 6/11 Wellen-Posten ohne Kopf-Nachfolger | REGRESSION | W1/W2 | Z2502-2503 | OFFEN | KON58-05/-10 -> W1/W2-Abgleich | Wellenplan |
| D-03 Riegel-Betrieb: 122 Traeger=Bump ODER Regen-Commit, --check Exit 3, LANDE-AUFLAGE nach JEDEM Merge | OWNER-ENTSCHEID | W2 | Z2504-2505 | BINDEND | KON58-01/-07/-13 -> Lande-Doktrin | Wellenplan |
| D-04 C-4-Wache modular splitten (deckt 6, >=152 ungedeckt); Home-SEMANTIK EIN Waechter je Home | REGRESSION | W2 | Z2506-2507 | OFFEN | KON17-03/KON2-19+KON27-01 -> F5 | Wellenplan |
| D-05 Compiler=kuenftige 5. SYSTEM-ACHSE gcc|clang, Unterachsen opt/flags/commands | AUFGABE | W2/W7 | Z2508-2509 | GEPLANT | KON55-01+KON56-03 -> S-9/S-11+W7 | Wellenplan |
| D-06 vier CacheEngine-Modi als PHASEN (State-Pattern, 0 Code-Treffer) zu BAUEN; compare vergleicht heute nichts | REGRESSION | W2/W3 | Z2510-2511 | OFFEN | KON29-01/-03, r5 A28 -> W2/W3-Design | Wellenplan |
| D-07 Hybrid=Transmitter/Multiplexer, Glied der MESS-Kette; Autonomie zweistufig, S-20 spaeter | AUFGABE | — | Z2512-2513 | GEPLANT | KON19-02/13-01+KON21-01/36 -> HY-Design-Register | Wellenplan |
| D-08 15-Stationen-Kette: Plan-/Memory-Nachzug (8-Stationen-Memory korrigieren) | REGRESSION | — | Z2514 | OFFEN (Doku-Zug) | Z14663 | Wellenplan |
| D-09 Pruefling=drittes Konzept, XML-beschraenkbar 1..3, ERWEITERT Permutationssatz | FEATURE | — | Z2515-2516 | NEU GELTEND | KON30-02/KON31 -> S-19-Input+prt-art-Rolle | Wellenplan |
| D-10 Auswahl-Subsystem (17 Dateien): Fortfuehrungs-Entscheid FEHLT, K4/K5 ohne Eigentuemer | OWNER-ENTSCHEID | — | Z2517-2518 | OFFEN | KON29-06/R-1+KON20-04 -> Explore, dann ggf. Owner-Vorlage | Wellenplan |
| D-11 #19-Vorbedingungen: zwei Diff-Hygiene-Fassungen+13 ungelandete ce-Branches+BRANCH-PFLICHT | REGRESSION | W2 | Z2519-2520 | OFFEN | KON5-06+KON49-03/-04 -> vor #19 | Wellenplan |
| D-12 PUBLIC-GANG-Buendel: Betreuer-PDFs, NOTICE-vs-LICENSE, 5. Schalter kopiert GPL-3 UNGEGATET | REGRESSION | — | Z2521-2522 | OFFEN | KON22/K+KON2-24/25 -> Release-CL | Wellenplan |
| D-13 ADR-Grundgesetz-Register (25 Entscheidungen, 04.05.) in den Ledger | AUFGABE | W4 | Z2523-2524 | GEPLANT | KON-40+KON-42 -> W4-Thesis-Fundament | Wellenplan |
| D-14 aufgehobene Streichliste=NEUN lebende Bau-Posten (CEB-27/43/12/34/18/20, 33-Paper-Generator, Toolchain-Permutation, CEB-19) | REGRESSION | W5-W7 | Z2525-2526 | BEHOBEN (Streichung aufgehoben) | Z16345 | Wellenplan |
| D-15 blockierende 09.08.-Entscheide ohne Kopf-Spur: D-5 Bau-vs-Mess-Menge, CEB-38, CEB-Identitaet A/B, variant-Fehlerklassen-Ausnahme | REGRESSION | — | Z2527-2530 | TEILWEISE BEHOBEN | D-5 per r3 B5 aufgeloest; Rest -> Explore, dann Owner | Wellenplan |
| D-16 Konformitaets-Register: 256 Aussagen, 17% ERFUELLT, +1564h — keine Nachmessung seit 09.08. | REGRESSION | W4 | Z2531-2532 | OFFEN-REGRESSION | KON82 misst anderen Gegenstand -> W4-Realitaetsanker | Wellenplan |
| D-17 Verifikationsvertrag V-1..V-8 lebt (Kopf-"V1-V10"=Namenskollision); OV-Nummern kein Autoritaetsbeleg | REGRESSION | — | Z2533-2534 | OFFEN (Register-Pflege) | Z14501+Z14434 | Wellenplan |
| D-18 Wachen-Sammelposten W2: Inventar-Nenner·3 allow_failure gegen Doktrin·libs/ ohne -Wall·D2-UB+kHashes·n/a-Gate·289-Writeback | REGRESSION | W2 | Z2535-2538 | OFFEN | KON59-02/NE-16/-20+Karte-5 -> #71-Nachbar | Wellenplan |
| D-19 Infra-Reste: COMDARE_NFS_DROP_TOKEN fehlt (Ebene C inert)·CE_SUBMODULE_TOKEN fehlt·Registration-Token-Reset=Owner-Entscheid | REGRESSION | — | Z2539-2540 | OFFEN | KON58-04 -> Handout | Wellenplan |
| D-20 Prozess-Register: v3.6 Opus/Fable·v3.7 MAX DREI Vollbauten·v3.8 Wellen-Form·Codex klein+2.Lens·vier /goal=Referenz | OWNER-ENTSCHEID | — | Z2541-2544 | BINDEND | KON58-09/-12+KON39/38 | Wellenplan |
| D-21 Owner-ABGABE-PFLICHT: Syntax UND Semantik je Achsen-Kategorie ueber c hinaus; G-2-Semantik in Nummerierungs-Reihenfolge | OWNER-ENTSCHEID | W4 | Z2545-2547 | BINDEND | KON9-09+KON13-03 -> W4-Pflicht+nach F5 | Wellenplan |
| D-22 Karte-4-Spitzengruppe je eigener W2-Pruefposten: KON-46 Retry 5/2/1·KON-11/12 Drift n=1·KON-36 fuenf rote Dauer-Tests·MT-L3 Orakel 0/29 | REGRESSION | W2 | Z2548-2550 | OFFEN | 34x "BLOCKIEREND" nie gebucht | Wellenplan |
| D-23 offen ohne Anker: -Wstringop-overflow(Pragma-Fix VERWORFEN)·28-vs-13 InputIfFileExists·Thesis-Doppel-Submodul·S-17-Einsortier-Pfad | REGRESSION | — | Z2551-2554 | OFFEN | KON58-13/-11 -> Triage | Wellenplan |
| D-24 Bleib-Notizen gegen Fehl-Abriss: PlanTextBuilder+plan dump+visibility, drei Versionierungs-IST-Luecken | AUFGABE | W2 | Z2555-2558 | GEPLANT | KON26-03/27-05+KON8-04+KON2-06/17 -> Design-Register | Wellenplan |
| FJ-1..FJ-10 (Full-Join, #18-Buendel): ab ma-Ebene ALLE Parameter inkl. PMC=FULL JOIN der mi-Erfolgs-Parameter | AUFGABE | W2 | Z2560-2570 | GEPLANT | KON91/94/95-O1/-O2; Bezugsgroesse seg_*_ns gegen seg_run_total_ns NIE gegen total_ns (r1 A-7) | Wellenplan |
| E1-E10 (Arena-Kette, S-13-Kernstueck; E6=Drain-Schleife measurement_sink-Heilung) | AUFGABE | W2 | Z2571-2572 | GEPLANT | KON92/94 | Wellenplan |
| E11 = Arena-Kapazitaet (6GB FEST/STATISCH, Planer-Reservierung zu Experiment-Beginn aenderbar) | AUFGABE | W2 | Z2572-2574 | GEPLANT (KON93-C6) | 10W-Explore fuehrt x5+2-vs-18 als Pruefpunkte | Wellenplan |
| Zusatz-Auflagen r5 (checkpoint_measure C-1..C-17): Hot-Path=EIN statischer Deskriptor · Ueberlauf=BEFUND nie blockieren · virtuelle Thread-Slots · thread-lokale Puffer=Richtigkeits-Frage | AUFGABE | W2 | Z2574-2580 | GEPLANT | KON94 kennt sie nicht; Testseite Designplan §12/T-12c+d | Wellenplan |
| W1 (Marker) Arena/6GB: KON93 gilt fuer GROESSE, Warn-/OOB-Kommando bleibt eigenes Objekt | REGRESSION | W1 | Z2588-2589 | UEBERHOLT-MARKER | x5/2-vs-18-Pruefpunkte im laufenden Explore | Wellenplan |
| W2 (Marker) Mess-Nenner: KON71 gewinnt, 32/6->12/4! sind S-19-Eingangshypothesen | REGRESSION | — | Z2590-2591 | UEBERHOLT-MARKER | "24 oder 48"=S-19-Ausgang | Wellenplan |
| W3 (Marker) Mess-Ebenen: drei Ebenen, vierte=SPALTE der Macro-Stufe, PMC=Meta-Meta | REGRESSION | — | Z2592-2593 | UEBERHOLT-MARKER | ACHTUNG r5 C4: Marker nicht an :28858 (fuenf Orte, andere Zaehlung) | Wellenplan |
| W4 (Marker) Lastsequenz=EIGENE Mess-Achse (KON64/65) | REGRESSION | — | Z2594 | UEBERHOLT-MARKER | an KON37-05 | Wellenplan |
| W5 (Marker) 3/2/2-GESETZ lebt; Menge "final drei" ueberholt (Compiler-Achse, Meta-Metas) | REGRESSION | — | Z2595 | UEBERHOLT-MARKER (teilweise) | — | Wellenplan |
| W6 (Marker) HW-Erkennung: KON64/65-F2 gewinnt, bindend-Klausel an KON-03 nachziehen | REGRESSION | — | Z2596 | UEBERHOLT-MARKER | — | Wellenplan |
| W7 (Marker) Parallel-Deckel: BEIDE gelten (CI-Concurrency vs. lokale Vollbauten) | OWNER-ENTSCHEID | — | Z2597-2598 | GELTEND | Vorbehalts-Marker an KON73 "unbeschadet v3.7" | Wellenplan |
| W10 (Marker) --debug-Ende: T-3 gewinnt | REGRESSION | — | Z2599 | UEBERHOLT-MARKER | KON28-01+Kapitel E | Wellenplan |
| W11 (Marker) Change Date: 10.08.2031 FINAL (lizenzwirksam) | OWNER-ENTSCHEID | — | Z2600 | BINDEND | Segment-Marker | Wellenplan |
| W12 (Marker) Dock-32: Deckel-DEFAULT willkuerlich, XML-Pflichtangabe bei Hybrid-Anforderung bleibt | REGRESSION | — | Z2601-2602 | UEBERHOLT-MARKER | K5-Text per V7 nachziehen | Wellenplan |
| W15 (Marker) Repo-Rollen: F6 gewinnt, im #74-Design ausweisen (kein stiller Umzug Auswertung super->ce) | REGRESSION | W2 | Z2603-2604 | UEBERHOLT-MARKER | E1-Hauptfund Matrix/Baseline-Taxonomie VOR #74 zitieren | Wellenplan |
| W16 (Marker) checkpoint_measure-Name: kein Sachwiderspruch, Owner-Wort bereits 08.08.; "Erfindung"-Befund austragen | REGRESSION | — | Z2605-2606 | BEHOBEN | r5 C1, KON60(iii)=Bestaetigung | Wellenplan |
| W8 (Explore) KEINE-YAML vs S-12: Design-Explore der Naht; Par.42/40.b meinen TRAEGERKETTE | AUFGABE | — | Z2609-2610 | OFFEN (Explore vor Bau) | r2 C-3; Owner-Vorlage mit beiden Wortlauten | Wellenplan |
| W9 (Explore) Lager-Inhalt: per r5 A18 AUFGELOEST (Release=Rekonstruktion, Binaries nicht aufbewahren) | REGRESSION | — | Z2611-2612 | BEHOBEN | Explore nur noch Beleg-Zug am lager_baum_writer, dann Marker | Wellenplan |
| W13 (Explore) CEB-Erreichbarkeit 4-vs-6: nach B2-Gate-Trennung am Objekt messen | AUFGABE | W2 | Z2613-2614 | OFFEN | r5 A14/C6: heute max 2 herstellbar | Wellenplan |
| W14 (Explore) T17 vs ORG-19: Explore ob persistence_target daneben besteht | AUFGABE | — | Z2615-2616 | OFFEN | koppelt K17-Pinning+gedruckte 2^17 (r4 C-6/D-19) | Wellenplan |
| W17 (Explore) Backup-Ref: Identitaet pre-secret-scrub-Ref <-> V9 verifizieren | AUFGABE | — | Z2617-2618 | OFFEN | r3 W-r3-6 liefert SHA 5ba3d03f | Wellenplan |
| W18 (Austragung) merge-Zeile: Owner-Verbot steht, LEDGER:8941 AUSTRAGEN vor Bau des verbotenen Bestands | REGRESSION | — | Z2620-2622 | OFFEN-REGRESSION | Trigger-Risiko 26.08. | Wellenplan |
| ECHTE OWNER-FRAGEN (gebuendelt): XML-Wache unbeobachtbare Zweighaelften · E-5 Kurven-Stack+K4 · Registration-Token-Reset · O-2 A/B · VS-A..F · AVX-512-golden · PMC-Gueltigkeit · Selektor MAX/MIN · ETA-Merge · F-01 Talos · Token-Rotation 286/288/289 (SOFORT) | OWNER-ENTSCHEID | — | Z2624-2629 | OFFEN | kein Explore loest sie | Wellenplan |
| R-01 Planer-Split: ZWINGEND eigene Binary VOR Abgabe (Schnitt-Spez liegt) | AUFGABE | W1/W2-KOPF | Z2635 | OFFEN (P) | r2 A40 | Wellenplan |
| R-02 Lager-Basis-Tests: Dummy-Text-Strategie+leerer Binary-Stub | AUFGABE | W2/#57 | Z2636 | OFFEN (M) | r3 B1, Owner-KERN | Wellenplan |
| R-03 Inventar-Batch-Cache: Host-Belegung fehlt (Ebene 1 inert)+Plan-Ablage 156x | REGRESSION | W2/#57 | Z2637 | OFFEN (M) | r3 B2/B3/B9 | Wellenplan |
| R-04 LB-4/LB-5/LB-6>1 NICHT gebaut ("Voll-Bau-Trigger IST Baum-Vollausbau") | REGRESSION | vor 26.08. | Z2638 | OFFEN (P) | r3 B4 | Wellenplan |
| R-05 XML-Trennung BAU-/MESS-Menge (Owner: "sonst regression") | REGRESSION | W2/S-13-XSD | Z2639 | OFFEN (M) | r3 B5, Schnitt liegt | Wellenplan |
| R-06 WritebackMethod::Xlsx+XSD-Enum-Wache; A9-Bauliste am Objekt nachmessen | AUFGABE | W2/#18 | Z2640 | OFFEN (M) | r5 A43/A45 | Wellenplan |
| R-07 Bestandslog-SOLL (verteiltes System, 4096/ETA/Takeover/Locks) als Design | AUFGABE | W2/#57 | Z2641 | OFFEN (M) | r2 A8, E2 F1 | Wellenplan |
| R-08 Batch-Job-Prinzip O(Maschinen): Emissions-Umbau ohne Vollzugsbeleg | REGRESSION | W2->W3 | Z2642 | OFFEN (M) | r2 A9/C-1 | Wellenplan |
| R-09 G3 aus dem STATISTICS-Gate loesen (6 CEBs, heute max 2) | AUFGABE | W2 | Z2643 | OFFEN (M) | r5 A14/A24 | Wellenplan |
| R-10 Registry=ANGEBOT/.pom-Resolver+3 Registries+Generator je Registry | AUFGABE | W2-Design | Z2644 | OFFEN (M) | r2 A1-A3 | Wellenplan |
| R-11 Resolver fuer target_isa-RT-Unterachsen+core_class-Provenienz | AUFGABE | vor W3/#53 | Z2645 | OFFEN (M) | r4 C-02/C-03 | Wellenplan |
| R-12 E-07-Gate: Kriterien 0 Treffer im Code, Position B10 trigger-blockierend | REGRESSION | vor 26.08. | Z2646 | OFFEN-REGRESSION (P) | r3 C4 | Wellenplan |
| R-13 Zwei unwahre Messgroessen (bytes_in_use_peak; CLU-64) vor erstem Batch | REGRESSION | vor 26.08. | Z2647 | OFFEN-REGRESSION (P) | r3 C5 | Wellenplan |
| R-14 Chaos-/Drift-Gate ohne Produktions-Aufrufer, CI-Job existiert nicht | REGRESSION | vor W3/#13 | Z2648 | OFFEN-REGRESSION (M) | r3 C8 | Wellenplan |
| R-15 L3-Asymmetrie prod1 (96/32 MB)+Pinning-Pflicht, ungepinnt nicht reproduzierbar | REGRESSION | W3-Vorb. | Z2649 | OFFEN-REGRESSION (M) | r4 C-01/C-08 | Wellenplan |
| R-16 21-Images-Entscheid (7 OS x 3), Marker an alle 7/8/18-Stellen | AUFGABE | W2-Marker | Z2650 | OFFEN (W) | r4 C-05 | Wellenplan |
| R-17 Tag-Mismatch baremetal/bare-metal sperrt Runner id6-9 aus | REGRESSION | vor W3 | Z2651 | OFFEN-REGRESSION (M) | r1 A46 | Wellenplan |
| R-18 adhoc_emitter ohne CI-Job, R5.G-Tests fehlen der Inventur | REGRESSION | W2 | Z2652 | OFFEN-REGRESSION (M) | r1 A34 | Wellenplan |
| R-19 GN-9 Feasibility-Gate ohne Fahrplan-Slot, 4096-static_assert-Schranke | AUFGABE | #7-Ausgang | Z2653 | OFFEN (M) | r4 C-04, B-08 | Wellenplan |
| R-20 HDR verdrahten (Thesis-Praesens)+p95-Export+4 Zusagen | REGRESSION | vor W4 | Z2654 | OFFEN-REGRESSION (M) | r1 A21/A22 | Wellenplan |
| R-21 Break-Even: ZWEI Implementierungen+B-Spline/String/3x je node-Tiefe | AUFGABE | W4-Vorb. | Z2655 | OFFEN (M) | E3 F1, r5 A15/16 | Wellenplan |
| R-22 Record-and-Replay als Mess-Vertrag der 3 Ebenen (Traeger der Elimination) | AUFGABE | W2-Design | Z2656 | OFFEN (M) | r5 A17 | Wellenplan |
| R-23 Klebe-Zeit der Gattungs-Interfaces=separater Messpunkt | AUFGABE | W4/#18 | Z2657 | OFFEN (M) | r5 A19 | Wellenplan |
| R-24 Sheet-/Profil-Blattfamilien: Blattzahl-Formel+Hyperlinks+Checkpoint-Spalten | AUFGABE | W2/#18 | Z2658 | OFFEN (M) | r5 A21/A22/A2 | Wellenplan |
| R-25 UltiHash/Produktions-Release-Konzept (H5+Owner 25.06., 3x unverfolgt) | AUFGABE | Owner+W4 | Z2659 | OFFEN (W) | E4 F1 | Wellenplan |
| R-26 BAUSTEINE_BEWERTUNG.md+Habich-Sign-Off je SOTA-Quelle | AUFGABE | Owner+W4 | Z2660 | OFFEN (W) | E4 F2 | Wellenplan |
| R-27 Nachtrag-1-Register (KON-01..-66) gegen KON60-96 gegenlesen, 6 bestaetigte Luecken (u.a. "sauberste Strategie gilt fuer ALLEN Code") | REGRESSION | W2-Triage | Z2661-2663 | OFFEN-REGRESSION (W) | E4 §2 | Wellenplan |
| R-28 Bauweg-Doktrin: configure.sh/make/make install/make check im Wurzelordner | AUFGABE | W2/#74 | Z2664 | OFFEN (M) | r5 A53 | Wellenplan |
| R-29 tier150_measurements.csv ARCHIVIEREN (danach rm-build-Memory nachziehen) | AUFGABE | W2 | Z2665 | OFFEN (W) | r5 A55 | Wellenplan |
| R-30 Schicht-Verstoss anatomy->builder (Owner-GO "Fenster ist jetzt") | AUFGABE | W1/W2 | Z2666 | OFFEN (M) | r5 A56 | Wellenplan |
| R-31 LaTeX-Anlage+Textbausteine IN die Abgabe (hebt Betreuer-Auflage, abgestimmt) | AUFGABE | W4 | Z2667 | OFFEN (M) | r5 A78 | Wellenplan |
| R-32 Lizenz-Feinheiten: Sperrvermerk+Uni-Ausnahme, privates Copyright, KI-Verbot, liburing fehlt in Lizenzdateien | REGRESSION | Release-CL | Z2668-2669 | OFFEN-REGRESSION (W) | E2 F6, r5 A75, r4 D-01 | Wellenplan |
| R-33 samba-Vault-Wert kompromittiert -> Rotationsliste (Kopf kennt nur V8) | REGRESSION | Infra | Z2670 | OFFEN-REGRESSION (W) | r5 A74 | Wellenplan |
| R-34 Cross-Plattform-Infra (Win/macOS/7-Linux-Container)+Debug-only-Plattformen: bewusst descoped? | OWNER-ENTSCHEID | Explore | Z2671-2672 | OFFEN (W) | E2 F2, r4 C-06 | Wellenplan |
| R-35 S-7 Locking/Observer-Strang (Owner-PFLICHT deep research, Plan liegt) | AUFGABE | W2-Strang | Z2673 | OFFEN (M) | r1 A16 | Wellenplan |
| R-36 H1-H7-Fork-Entscheide (H4: std::map-Interfaces variadisch => XSD)+FF0 | AUFGABE | W2/#18+W4 | Z2674 | OFFEN (M) | r1 A17/A45 | Wellenplan |
| R-37 §75-Kandidatenliste 133/104 offen+§55-RECONCILE 26 offen (Anker migriert) | REGRESSION | W7+Triage | Z2675 | OFFEN-REGRESSION (W) | r5 A57/A58 | Wellenplan |
| R-38 ETA-Merge verwirft still; last_update_utc-Ein-Feld-Schnitt (Owner offen) | REGRESSION | W2/#57 | Z2676 | OFFEN-REGRESSION (M) | r5 A48/A50 | Wellenplan |
| Abgrenzung: Paper-Experiment-XML+PMC-Schwester-Design bereits in §18.8 gefuehrt (nicht doppelt buchen) | REGRESSION | — | Z2678-2681 | DOKUMENTIERT | Owner-GO 08.08.; profile_ref nie dereferenziert (r5 A26, E3 F2) | Wellenplan |
| §20 Anlass: konsolidiert ALLE offenen Zugaenge Kontexte 10-11 fuer GOAL v8 | OWNER-ENTSCHEID | — | Z2687-2690 | BINDEND | bei Widerspruch Owner-Wort schlaegt alles, Neueres schlaegt Aelteres | Wellenplan |
| MARKER 17.08 spaetnachts (Sweep B-3): KOMPLETT=Landung des Gebauten; W1-Abnahmeformel :952 steht 0/4 | REGRESSION | W1 | Z2693-2697 | OFFEN-REGRESSION | Luecke traegt P.20.2, Abnahme vor F2; CI-Nachtrag 15971 ROT->geheilt | Wellenplan |
| Welle 1 KOMPLETT: ce dev 04ac26fa->6cdcf1c9 (31 Commits, hy-a/vl12/vl3/k2), Kombibau 4/4 "100% tests passed of 499" | FEATURE | W1 | Z2698-2704 | GELANDET | Floor 500/496/494 live; ce-CI-Ergebnis ausstehend | Wellenplan |
| HY-A2+HY-A3-ACHSE NIE GEBAUT: proxy/tier_module (4 ABI-Symbole)+test_hy_f8_reroute+Registry "22->23" fehlen | REGRESSION | W1 (vor F2) | Z2712-2717 | OFFEN-REGRESSION | W1-ABNAHMEFORMEL :952 NICHT erfuellt; Traeger #15-Bump-Buendel-Zug | Wellenplan |
| #15-BUMP-BUENDEL selbst (Layout6->7+Format4->5+10.Glied+#38a2/d+PMC-Spalten+bestandslog v5+HY-A2-Map-Zeile) | AUFGABE | W1 (vor F2) | Z2718-2720 | GEPLANT (Design-Karte liegt) | Bau=letzter Preimage-Schritt vor F2 | Wellenplan |
| VL-3-PFLICHT-FIXES: (a) clang-Warnungs-Review (b) --debug x plan dump/ci/cmake-Tests (c) Windows-_pclose | AUFGABE | W1 | Z2721-2724 | TEILWEISE BEHOBEN | ROT-2 (main.cpp-Zusicherung) BEHOBEN 6cdcf1c9 | Wellenplan |
| G-2-REST: g2-Strang landereif @ 1528f6fd (Welle 2) | AUFGABE | W1/W2 | Z2725 | GEPLANT | Rest-Kategorien lt. Bericht | Wellenplan |
| WELLE 2 Lande-Liste: g2->xorf b8d6edab (golden: Filter-Zelle+algo_version 1.0.0.c->1.1.0.c)->f3v->a11 | AUFGABE | W2 | Z2728-2732 | GEPLANT | danach Worktree-Abbau nur gelandeter Baeume | Wellenplan |
| WIEDERAUFNAHME-MARKER 18.08: g2 war ERSTES Glied der Lande-Liste, KON116-Landung nannte nur xorf+f3v+a11 — g2 bleibt UNGELANDET | REGRESSION | W1/W2 | Z2734-2736 | OFFEN-REGRESSION | vor F2 zu landen (par.21.2) | Wellenplan |
| SUPER-ZUG k2-6-Schritt-Rezept (tests/CMakeLists.txt +Gitlink ATOMAR, fixture_schema_subset_check FATAL, Mutationsprobe) | AUFGABE | W1 | Z2739-2741 | GEPLANT | +Gitlink-Bump 6cdcf1c9+PZW | Wellenplan |
| P-A Kanal-/Arena-Designplan (checkpoint_measure-Kanal-Baum, PROFILER, Klammer-Default) | AUFGABE | — | Z2744-2745 | GEPLANT | Spannung C-1-vs-Default nicht glattrechnen | Wellenplan |
| P-B Parameter-Filter-Registry + neuer Deep-Research | AUFGABE | — | Z2745-2746 | GEPLANT | — | Wellenplan |
| P-C kleine Hybride (Docks=Optimal-Bereiche<=32) | AUFGABE | — | Z2746 | GEPLANT | — | Wellenplan |
| P-D Hybrid-ML-Profile (XML-init, Lookahead ma x w) | AUFGABE | — | Z2746-2747 | GEPLANT | — | Wellenplan |
| P-E Lager-Typ 3 (Funktions-Synthese)+Typ 4 (XML-Loesungs-Cache)=Bestandslog-FACTORY-Erweiterung | AUFGABE | — | Z2747-2748 | GEPLANT | -> #57/#18 | Wellenplan |
| P-F Flaeche-3-Zweiform (Steuer- vs Mess-Naht; #20=intra-Naht) | AUFGABE | — | Z2748-2749 | GEPLANT | — | Wellenplan |
| P-G mess/ EIGENE S-Position (Register-Nachtrag+Design) | AUFGABE | — | Z2749-2750 | GEPLANT | — | Wellenplan |
| P-H 33 Paper->Prueflinge+Begriffs-Alias-Registry (CT, kein Uebersetzer)+Markierungs-/Ranking-Ausgabe | AUFGABE | W2 | Z2750-2751 | GEPLANT | -> #44/W2 | Wellenplan |
| P-I Selector-Merge in Komponente 3 (std-only-Spiegelung FAELLT, super liest Lager) | AUFGABE | — | Z2751-2752 | GEPLANT | — | Wellenplan |
| P-J CEB-Auswertungs-Beschleunigung (std::variant-Ausnahme-Zone, HW-Detection, SIMD-Reservierung) | AUFGABE | — | Z2752-2753 | GEPLANT | — | Wellenplan |
| P-K SIMD-/Erweiterungs-Deep-Research | AUFGABE | — | Z2754 | GEPLANT | — | Wellenplan |
| T-NEU-1 s13-Kurz-Verify-Verdikt nachbuchen (Gate KON100-02) | AUFGABE | — | Z2757 | OFFEN | s13-F3 bis dahin nicht landereif | Wellenplan |
| T-NEU-2 KON49-Schnitte vs #41/#30 Abgleich | AUFGABE | — | Z2758 | OFFEN | — | Wellenplan |
| T-NEU-3 wf_e13d73bf identifizieren | AUFGABE | — | Z2758-2759 | OFFEN | — | Wellenplan |
| T-NEU-4 Journal-BU Kontext 10ff | AUFGABE | — | Z2759 | OFFEN | — | Wellenplan |
| T-NEU-13 wip/luecken-stufe2 vs #40 | AUFGABE | — | Z2759-2760 | OFFEN | — | Wellenplan |
| T-UPD-3 R3-D37B-Zeile stale "offen" -> GELANDET | REGRESSION | — | Z2760-2761 | BEHOBEN | 9b3a1bcd+75505b9d | Wellenplan |
| p2/p3-Worktree-Reste beim #37-Vollzug einspielen/verwerfen | AUFGABE | — | Z2761 | OFFEN | — | Wellenplan |
| (1) Kenntnisnahme b-Strich Talos: Core-PMC-Zuschnitt+v1.13.x-Upgrade ins A-1-Fenster? | OWNER-ENTSCHEID | — | Z2764-2766 | OFFEN | NICHT v1.14 (sandboxd-GA 27.08.) | Wellenplan |
| (2) Infra-Fenster-TERMIN (WE 22./23. ueberbucht: S-19+T-15b+I-PMC+A-1+evtl. Talos) | OWNER-ENTSCHEID | — | Z2766 | OFFEN | Slot-Vorschlag liegt | Wellenplan |
| (3) E-5-Chat-Reste: Owner wollte Zusammenhaenge der 3 Komponenten weiter klaeren | OWNER-ENTSCHEID | — | Z2766-2768 | OFFEN | RF-Runde beantwortet, Unifikations-Design-Vorlage folgt | Wellenplan |
| HANDLUNGEN: V8-GitHub-PAT · node6/node5/id56/id18 | AUFGABE | — | Z2769 | OFFEN | — | Wellenplan |
| NEUGRUENDUNG 17.08 vollzogen: 4 /goal-Dokumente+7 Owner-Verbatims+5 Workflow-Rueckkehrer voll gelesen | AUFGABE | — | Z2773-2779 | ERLEDIGT | BU tmp/owner_verbatims_k11.txt | Wellenplan |
| TASK-ANLAGE VOLLZOGEN (KON112 T3->Board): #89 P-H · #90 P-A · #91 Unifikations-Designplan M0-M14 · #92 P-G mess/-Position | AUFGABE | — | Z2780-2786 | ERLEDIGT | UPDATES an #88/#20/#86/#15/#57/#18/#71/#81 | Wellenplan |
| T-NEU-5 S-14-VOLLAUSROLLUNG (W2, P.41, nach S-18-Homes) | AUFGABE | W2 | Z2787-2788 | OFFEN | — | Wellenplan |
| T-NEU-6 S-8/S-9/S-10/S-11-TRAEGERBAU als eigener W2-KOPF-Posten (deckt B-01/B-04/B-14/B-16+R-01) | AUFGABE | W2 | Z2788-2789 | OFFEN | — | Wellenplan |
| T-NEU-9 C-01 VOLLBAU-GATE-Vorlage VOR Trigger Mi 26.08. | AUFGABE | vor Trigger | Z2789-2790 | OFFEN | — | Wellenplan |
| T-NEU-10 C-02 HEAVY-Signal-Sende-Akt (26.08.-Fenster, #60-Umfeld) | AUFGABE | — | Z2790-2791 | OFFEN | — | Wellenplan |
| T-NEU-11 C-13 Skip-Oekonomie+C-14 Bestandslog-SKIP-Wache (vor Kampagne Sa 29.08.) | AUFGABE | vor W3 | Z2791-2792 | OFFEN | — | Wellenplan |
| T-NEU-12 ERLEDIGT (Cluster ee2f933: 20 helm-Skripte+ci-templates-Gitlink) | AUFGABE | — | Z2792-2793 | ERLEDIGT | — | Wellenplan |
| T-UPD-1 #38c-Rest neu fassen (Objekt=super/ci) | AUFGABE | — | Z2793 | OFFEN | — | Wellenplan |
| T-UPD-2 #40-Wellen-Kollision T-13/T-14 aufloesen (W7 vs vor-W3/C-12) | REGRESSION | — | Z2793-2794 | OFFEN | — | Wellenplan |
| T-UPD-5 MEMORY-Korrektur 8->15 Stationen (Doku-Zug); NP-01..NP-50+UEBERHOLT M-01..M-36 (KON106) naechster Zug | REGRESSION | — | Z2794-2796 | OFFEN | buendelbar mit KON111-11-Liste | Wellenplan |
| AUFRAEUM-LISTE C (remove): golden-rettung·p6-Worktree·/tmp-Audit-Checkout·8 ce-Lokalbranches·super b-checkheft·wt-thesis-lizenz | AUFGABE | — | Z2797-2799 | GEPLANT | Vollzugs-Doktrinen je remove beachten | Wellenplan |
| NICHT anfassen (Liste D): W1-Worktrees bis CI-gruen·a11/f3v/g2/xorf(aktiv)·p2/p3·wf_e22d25ef·wip/luecken-stufe2·backup/rescue-Refs·Cluster | OWNER-ENTSCHEID | — | Z2799-2801 | BINDEND | — | Wellenplan |
| OWNER-NEUZUGANG: NP-46 (E-1-Anschlussfrage Text-Aufnahme woertlich)+NP-48 (UltiHash<->ComdareDB vierte Entitaet?) | OWNER-ENTSCHEID | — | Z2802-2804 | OFFEN | in naechste Vorlagen-Runde | Wellenplan |
| B-1 KRITISCH: super-Fixture-Wache skippt seit W1-Landung STILL (FIXTURE-Pfad existiert nach ce-Rename nicht mehr) | REGRESSION | — | Z2809-2814 | OFFEN-REGRESSION (DRINGLICH) | SYNC-SKIP :56-62 laesst grün durch -> super-Zug P.20.4 FATAL statt Skip | Wellenplan |
| B-2 behoben (Marker P.20.1); B-3/B-4=Marker gesetzt | REGRESSION | — | Z2815 | BEHOBEN | — | Wellenplan |
| B-5 main.cpp:515 zweite unbelegte Byte-Gleichheits-Zusicherung | REGRESSION | W2-1 | Z2815-2816 | OFFEN | — | Wellenplan |
| B-6/B-7 AUFGELOEST: N-Liste komplett geborgen (N1=W2-clang, N5=--debug-Matrix, N6=Bytevergleich, N3 AUSGEBUCHT, N7 BEHOBEN 316c488f, N8 erledigt) | REGRESSION | — | Z2816-2819 | BEHOBEN | #80-Status: Rest=HY-A2/A3+M-1/M-2 | Wellenplan |
| M-1 F-9-Sentinel NAMENTLICH ins #15/HY-A2-Paket (hybrid_dock_array.hpp:206-219, "A2.5-FUND F-9 NICHT BEHOBEN") | REGRESSION | W1 | Z2821-2823 | OFFEN | tragender Weg=attach-Definition in gemeinsamem Header | Wellenplan |
| M-2 TSAN-AUSBAU (fence-Naht messbar machen) ins #15/HY-A2-Umfeld | AUFGABE | W1 | Z2823-2824 | OFFEN | war einziger Posten ohne Besitzer | Wellenplan |
| M-3 stdout-Bytevergleich als MESSUNG+main.cpp:515 -> W2-1 (mit N5 buendeln) | AUFGABE | W2 | Z2825-2826 | GEPLANT | — | Wellenplan |
| M-4 = B-6 (aufgeloest) | REGRESSION | — | Z2826 | BEHOBEN | — | Wellenplan |
| M-5 R-OPTION: Sa 22./So 23. traegt KEINE HY-A-Reserve — faellt HY-A2 aus dem #15-Zug vor F2, WE=letzte Flaeche | REGRESSION | W1 | Z2827-2828 | OFFEN-REGRESSION | Slotliste P.20.7 ergaenzt | Wellenplan |
| M-6 owner-vorlagen-Redundanz-Triage (Ultracode-Funde 7-9/20) | AUFGABE | — | Z2829-2830 | OFFEN (klein) | vor naechster Owner-Praesentation | Wellenplan |
| Objekt-Praezisierungen #15-Text: HY-A2-Enums EXISTIEREN, fehlt nur ABI-decl-SLOT; HY-A3 KEINE Registry steht auf 22 | REGRESSION | W1 | Z2831-2835 | BEHOBEN (praezisiert) | E-6-Explore benennt zuerst Ziel-Registry | Wellenplan |
| T-NEU-1 NACHGEBUCHT: s13-F3-Kurz-Verify GEBORGEN (wf_0e1f240b)=TRAEGT_MIT_FIXES, Gate KON100-02 ERFUELLT | REGRESSION | — | Z2836-2841 | BEHOBEN | 2 Ein-Zeilen-Edits als Auflage in Di-25-Zug | Wellenplan |
| E-6-VERDIKT: "22" der HY-A3-Formel war ein PHANTOM-NENNER (Herkunft EIN Commit ffa4b836 ohne Objekt-Basis) | REGRESSION | — | Z2843-2854 | BEHOBEN (Phantom aufgedeckt) | einzige lebende 22=AllStrategies 03a, als Ziel VERWORFEN | Wellenplan |
| VOLLZOGEN: Registrierung HY-A1 (Gattungen 3->4, Genera 5->6, 256er-Wache) am Objekt stichprobenverifiziert | REGRESSION | — | Z2855-2858 | BEHOBEN | anatomy_base.hpp:89/169 | Wellenplan |
| Offener Rest HY-A3-Registry-Anteil: kGenusBuildSlotCounts std::array 5->6+static_assert :171==5->==6+Wachen-Nachzug | REGRESSION | W1 | Z2859-2864 | OFFEN | Dock-Registry bleibt designfest 5 | Wellenplan |
| ABNAHME-ERSATZ fuer :952-Formel: ctest druckt kGenusBuildSlotCounts.size() 5->6+Einzelquellen-Paare 4/6 | AUFGABE | W1 | Z2865-2867 | GEPLANT | — | Wellenplan |
| MARKER: Stellen :697/:857/:952 in 22->23-Haelfte UEBERHOLT; Nebenfund AllFourteenAxesPopulated bei 22/18 Achsen traegt selbe Phantom-22 | REGRESSION | — | Z2868-2872 | UEBERHOLT-MARKER | bei R-4 korrigieren | Wellenplan |
| §21 Anlass: par.13-20 bleiben stehen, was hier steht gilt vor; Quellen Regressionen-/Wiederaufnahme-Register+Uebergabe K13 | OWNER-ENTSCHEID | — | Z2879-2883 | BINDEND | Owner-Wort schlaegt alles, Neueres schlaegt Aelteres | Wellenplan |
| Beleg-Tafel (1) Selektiver Rebuild geloescht (ce 813c3232) -> C-13 gebucht, Traeger Task #97 | REGRESSION | W2/W3 | Z2898 | BEHOBEN (nachgetragen) | par.21.4 | Wellenplan |
| Beleg-Tafel (2) checkpoint_measure -> W7 trotz Owner-KERN -> zurueck als B4/System B | REGRESSION | W2 | Z2899 | BEHOBEN (nachgetragen) | #24/W2 | Wellenplan |
| Beleg-Tafel (4) "W1 KOMPLETT" galt nur Straengen, HY-A2/A3 ungebaut -> im #15-Bruch nachgebaut (e285d316) | REGRESSION | W1 | Z2902 | BEHOBEN | — | Wellenplan |
| Beleg-Tafel (5) #17/g2 ungelandet -> W1-V1/#93 | REGRESSION | W1 | Z2903 | OFFEN | par.21.2 | Wellenplan |
| Beleg-Tafel (6) 06_evaluation_methodology still nicht eingebunden -> #67 (8/8 abgedeckt, DEPRECATED-Kopf) | REGRESSION | — | Z2904 | BEHOBEN | — | Wellenplan |
| Beleg-Tafel (7) Audit-slice(0,14)+stille Limit-Filterung -> Voll-Umbau+Vollzaehligkeits-Gates | REGRESSION | — | Z2905 | BEHOBEN | — | Wellenplan |
| Beleg-Tafel (8) Synthese-Dedup-Verlust -> per Verify-Rekursion R2 gefangen | REGRESSION | — | Z2906 | BEHOBEN | — | Wellenplan |
| Prozess-Ertrag Codex/Plan-B: bwrap DAUERHAFT defekt (7 Tode); Plan-B=codex exec CLI mit Diff-VOLLTEXT im Prompt | REGRESSION | — | Z2909-2914 | BEHOBEN (Workaround etabliert) | erste 4/4 erfolgreiche Codex-Lenses; Memory-Anker Codex-Lens-klein | Wellenplan |
| Prozess-Ertrag sequentieller Audit-Umbau+Vollzaehligkeits-Gates: 11/11-Quellen-Gate, kein slice-Deckel, Synthese-Dedup-Verlust per Verify R2 gefangen | AUFGABE | — | Z2916-2921 | BEHOBEN (Prozessverbesserung) | Orchestrator-Bug Template-Literal-Interpolation, Verify rekonstruierte aus journal.jsonl | Wellenplan |
| #15-Bump-Bruch FIX-KOMPLETT, UNGELANDET (Tip e285d316, 32 Commits); A2.5-Rekursion 43 BEHOBEN/3 ENTLASTET/4 VERTAGT, Review LANDBAR_MIT_FIXES | REGRESSION | W1 | Z2925-2933 | OFFEN-REGRESSION | wartet auf Audit-Ruecklauf->Fix-Strecke2->#93->Landung, Frist vor F2 | Wellenplan |
| Lande-Kette ce Schritt 1: .review-tmp/ loeschen, ggf. clang-Zelle wiederholen (Deckel 3) | AUFGABE | W1 | Z2937 | GEPLANT | — | Wellenplan |
| Lande-Kette ce Schritt 2: git merge --no-ff bau/bump15-preimage-bruch (EIN Merge, 32 Commits) | AUFGABE | W1 | Z2938-2939 | GEPLANT | — | Wellenplan |
| Lande-Kette ce Schritt 3: WELLEN-ENDE-GATES am ENDSTAND (Lock-Regen, Drift-Probe Exit1 mit 4 versionslosen Traegern, Hygiene, gitleaks) | AUFGABE | W1 | Z2940-2947 | GEPLANT | LS2-34-Audit-Verdikt deckungsgleich | Wellenplan |
| Lande-Kette ce Schritt 4: EIN Push (origin+github)->EINE CI->Ergebnis per API messen, B-10-Anker-Faelligkeit pruefen | AUFGABE | W1 | Z2948-2949 | GEPLANT | — | Wellenplan |
| super-Zug ATOMAR Schritt 5 -> KON119: XSD-Patch super_xsd_golden_verbund.patch+Gitlink+PZW+KON119-Lande-Bericht | AUFGABE | W1 | Z2951-2961 | GEPLANT (Frist vor F2) | Subset-Wache koppelt Fixture+XSD | Wellenplan |
| Bauplan-Folgezuege nach Landung: B-7-Stempel-Haelfte (E-B Emitter-Name+Stempel-Pflicht in Makros, V-03R-Budget unverbraucht) | AUFGABE | — | Z2963-2964 | OFFEN | golden-Ereignis | Wellenplan |
| Bauplan-Folgezuege: B-10-Anker (frozen kFrozenFingerprintV1, "NOCH NICHT setzen" galt fuer Bau, beim Landen Faelligkeit pruefen) | AUFGABE | — | Z2964-2966 | OFFEN | — | Wellenplan |
| Bauplan-Folgezuege: B-8 (RT-Dock-Haelfte A-12) · N-1..N-6 · VL-5/VL-6-Doku · KORB-A-12 (B3 Schalter-Hoheit, Owner-Datum) | AUFGABE | — | Z2966-2967 | OFFEN | golden-Teile im F2-Umfeld | Wellenplan |
| Band B/W1 (22 Posten, 62h): AG-Concepts11 etc., neue Platzierung W2-Randslots+WE 22./23.+Rest W3-Batch-Pausen | AUFGABE | W2/W3 | Z2993-3001 | VERTAGT (neu platziert) | Feinplatzierung Di 25.08. | Wellenplan |
| Band-B-Rest (37 weitere der 59 Posten, ~104,5h): W3-Batch-Pausen[lok]+W4 Mo-Mi+W4-Fangnetz | AUFGABE | W3/W4 | Z3003-3005 | VERTAGT (neu platziert) | vereinbar mit "null CI-Last" | Wellenplan |
| Band C (5 Posten, 13h): PM-WinPCM UEBERHOLT (Windows-Runner online)->W2/W4, PM-AmdL3 Talos-Lane #87, MT-L8+PM-PAPI+AG-PunktFixes->W4 | REGRESSION | W2/W4 | Z3007-3010 | TEILWEISE BEHOBEN | alte Begruendung UEBERHOLT am Objekt | Wellenplan |
| ##40-Restbau (T-06/07/08/09/10/12/13/14, W-03/08, A14, A10, ~10-11 WT): T-13/T-14 PFLICHT vor W3, T-07/T-08 vor Trigger falls mengen-wirksam, Rest W4 | AUFGABE | W2/W3/W4 | Z3012-3015 | GEPLANT | — | Wellenplan |
| HY-Vollausbau: Mehrfach-Dock=HY-B/W3-Design (MaxDocks==1 ist ehrlicher Minimal-Pin, kein Verzicht); Heuristik-Familie/Eviction W4 nach HY-C | AUFGABE | W3/W4 | Z3017-3020 | GEPLANT | — | Wellenplan |
| 14 W7-Posten par.13.3+P/E-Core(#21)+IO-Vollausbau(#38a3)+par.75-Pass+Record-Replay+PV-1: neue Platzierung W4/W5-Randslots gezaehlt | AUFGABE | W4/W5 | Z3022-3026 | VERTAGT (neu platziert) | was OBJEKTIV nach Abgabe muss, braucht Owner-Satz (Kategorie C) | Wellenplan |
| ##15-EMITTER/TEMPLATE + ##24/A9-S5a: Rutsch-Klassifizierung AUFGEHOBEN -> ##15 = W2-Slot, A9-S5a = W4 | REGRESSION | W2/W4 | Z3028-3030 | BEHOBEN (neu platziert) | — | Wellenplan |
| Register-Vollautomation ##31 + D1c-Vollausbau: Rueckfallstufen bleiben ungezogen, Vollformen werden W2-W-Posten | AUFGABE | W2 | Z3032-3033 | GEPLANT | — | Wellenplan |
| Kapazitaets-Ehrlichkeit: Wiederaufnahme-Volumen >200h zusaetzlich auf 19 Kalendertage bis T-3 (KEINE Streichung) | REGRESSION | — | Z3035-3042 | OFFEN (ausgewiesen) | Deckung: "volles Risiko"+Mehr-Kontingent-Parallelitaet+[lok]-Klasse; Vollzug=Task #96 | Wellenplan |
| Task #96 (NEU) Di 25.08.: Wiederaufnahme-Register-Vollzug+Feinplatzierung (Stunden je Slot) | AUFGABE | W2 | Z3058-3060 | GEPLANT | nach Audit-/#93-Ruecklauf | Wellenplan |
| Task #97 (NEU) vor Kampagne Sa 29.08.: C-13+C-14 Selektiver-Rebuild-Wiederherstellung | AUFGABE | W2/W3 | Z3062-3064 | GEPLANT | Traeger war nur T-NEU-11 | Wellenplan |
| Task #99 (NEU, =B-5f): Tooling-Ordnungs-Validierung (wallclock/macro/micro) an ALLEN DREI Stellen — Traeger-Luecke war ausgewiesener Befund | REGRESSION | W2 | Z3071-3078 | BEHOBEN (Traeger angelegt) | V-13 per KON101 beantwortet | Wellenplan |
| Verdachtsfall golden-Nachposten E-B-CRC/K1-avx512-Filter/telemetry-silent (seg1-44): nur S-6a-Anker im Bruch | REGRESSION | W1 | Z3082-3087 | OFFEN | Aufloesung Audit-Synthese+ggf. Owner-Satz VOR Landung | Wellenplan |
| Verdachtsfall V-06 Lesart A: Stempel-Pflicht GEWEITET vs 2 Symbole, per R2-Commit festgeschrieben, golden-gebunden | REGRESSION | — | Z3089-3091 | OFFEN (Aufloesung laeuft) | Folgezug B-7-Haelfte | Wellenplan |
| Verdachtsfall B1 (W1-Ende): Aufloesung durch #93 | AUFGABE | W1 | Z3093-3094 | OFFEN | fliesst in Wiederaufnahme-Register Teil D | Wellenplan |
| Verdachtsfall A1-Durchzug 9-vs-18 (LS2-33): simd_organ_requirement 9x kRequiredNone gegen Registry 18, Durchzug fehlt | REGRESSION | W1 | Z3096-3099 | VERTAGT -> #44-Rest | Aufloesung Voll-Audit+#93 | Wellenplan |
| Verdachtsfall 23 Band-A-Testposten aus Designplan par.4-W1 | AUFGABE | W1 | Z3101-3102 | OFFEN | Ist-Stand misst #93 Gruppe G | Wellenplan |
| Laufende Audits als Lande-Vorbedingung: Voll-Audit wf_794b904b (688 Zusagen) -> Fix-Strecke2 -> #93 -> Landung | AUFGABE | W1 | Z3104-3109 | LAEUFT | Review-Haelfte ZURUECK (LANDBAR_MIT_FIXES) | Wellenplan |
| OV-4 Vollmessung->Deckel (Deckel-Doktrin+S-19 rechnet); physikalisch >=143 Tage einthreadig | OWNER-ENTSCHEID | — | Z3116-3118 | BINDEND | Deckel=Mess-AUSWAHL, keine Feature-Kuerzung | Wellenplan |
| OV-14 Paper-Kopplung -> nach Abgabe | OWNER-ENTSCHEID | — | Z3123-3124 | BINDEND | bleibt, ausser Owner dreht | Wellenplan |
| W7/#88 Monolith-Split (Owner-B3 "beim Aufraeumen") | OWNER-ENTSCHEID | W7 | Z3125-3127 | BINDEND | vereinbar mit par.21.0 | Wellenplan |
| Offener Rest: clang-debug-Zelle ROT (PIE/HDR-Link), vorbestehend/neu-sichtbar | REGRESSION | W2 | Z3133-3136 | OFFEN (kein Lande-Blocker) | Behebung als W2-Slot | Wellenplan |
| Offener Rest: clang-format-22-Anomalie 122-vs-120 (lokaler Formatter alignt anders als Standard) | REGRESSION | — | Z3137-3139 | OFFEN (beobachten) | CI-lint:format faellt Urteil | Wellenplan |
| Offener Rest: decl.hpp:797 stale Referenz | REGRESSION | — | Z3140-3141 | OFFEN | koppelbar mit Task #94 | Wellenplan |
| Offener Rest: C-3a (#38a1) EINZIGE offene Owner-FRAGE, Frist Mi 19.08. | OWNER-ENTSCHEID | — | Z3142-3143 | OFFEN | laeuft im F2-Vorlagen-Fenster Punkt 4 | Wellenplan |
| F2-Vorlage (1) AxisKind-Ordnung im Bruch mitdrehen? | OWNER-ENTSCHEID | W1 | Z3148-3149 | OFFEN | ohne GO kostet spaetere Drehung weiteren Preimage-Bruch | Wellenplan |
| F2-Vorlage (2) E-6-Satz: "22->23 war Phantom-Nenner, Rest=kGenusBuildSlotCounts 5->6 gebaut — Einspruch?" | OWNER-ENTSCHEID | W1 | Z3150-3151 | OFFEN | KON118 | Wellenplan |
| F2-Vorlage (3) KON60-04-Spannung S-6 (stale, blockiert nicht) | OWNER-ENTSCHEID | — | Z3152 | OFFEN | — | Wellenplan |
| F2-Vorlage (4) C-3a-Frist (Mi 19.08.) | OWNER-ENTSCHEID | — | Z3153 | OFFEN | — | Wellenplan |
| F2-Vorlage (6) golden-Nachposten-Satz (seg1-44)+Owner-Saetze fuer objektiv-nach-Abgabe-Posten | OWNER-ENTSCHEID | — | Z3155-3156 | OFFEN | Kategorie C der W7-Liste | Wellenplan |
| Owner-Order 19.08.: "Aufgaben, die spaeter relevant werden, duerfen nicht verloren gehen"; 195->120 dedup Posten, 96 GETRAGEN/19 TEIL/5 UNGETRAGEN | OWNER-ENTSCHEID | — | Z3162-3176 | BINDEND | K14+K15-Sweep wf_d42115cb; NIE-KUERZEN: bei Zweifel TEIL-GETRAGEN | Wellenplan |
| (1) FIX-STRECKE 2 KOMPLETT: Verify NULL_NEUE_FUNDE, Abnahme @ 8cd32a0d, End-Tip 79171599, 20 Commits | REGRESSION | W1 | Z3180-3182 | BEHOBEN | Eingangsmenge 15/15 GEDECKT | Wellenplan |
| (2) g2-HARMONISIERUNG+KOMBISTAND-ABNAHME @ b02b7523 (#17-Lande-Zug laeuft) | AUFGABE | W1 | Z3183-3184 | GEPLANT | 4/4 Zellen @ 9aa9b9df | Wellenplan |
| (3) clang-debug-Zelle GEHEILT: Wurzel war Zellen-MISCHBAU (CMAKE_C_COMPILER=gcc-15.3 ohne PIE bei CXX=clang++) | REGRESSION | W2 | Z3185-3188 | BEHOBEN | Rest-Haelfte PIC-Hausnorm=W2-Mini (22.2 T-4) | Wellenplan |
| (5) BU-ORDNER GELANDET @ 9052a56b (Redaktion FREIGEGEBEN 18/18 SAUBER, CI SUCCESS) | AUFGABE | — | Z3192-3193 | BEHOBEN | Folge-BU-Nachzug = 22.2 T-17 | Wellenplan |
| U-1 ROT: s13-design-J-1-REZEPTFIX — falsche Target-Namen (adhoc_emitter_cli statt comdare_adhoc_emitter_cli) | REGRESSION | W2 | Z3197-3207 | OFFEN-REGRESSION (0 Traeger-Treffer) | Faelligkeit vor Di 25.08./#18; Traeger NEU: ROT-Auflage an Task #18 | Wellenplan |
| U-2 PLATTEN-RAEUMUNG prod1, ROOT-SEITIG (/tmp/comdare e2e-b-ci ~8G+comdare-gcc-build ~1.5G, eigenes rm scheiterte) | REGRESSION | Infra | Z3209-3217 | OFFEN-REGRESSION (0 Traeger-Treffer) | Faelligkeit vor WE 22./23.; Traeger NEU: Infra-Fenster Do 20.08.+Di-25-Zeile | Wellenplan |
| U-3 T-3-OWNER-MELDUNG axis_cross_product (bewusste, nie gemeldete Namensabweichung statt verbund_union) | REGRESSION | — | Z3219-3224 | OFFEN (0 Traeger-Treffer) | Faelligkeit F2-Vorlagen-Fenster; Traeger NEU: Kenntnisnahme-Zeile neben P2-P7 | Wellenplan |
| U-4 K16-STOPP-BAUSTEIN fehlt in Session-Vorlage B.0 (Schreiberwechsel-Protokoll) | REGRESSION | W2 | Z3226-3230 | OFFEN (0 Traeger-Treffer) | Traeger NEU: 12.4-Docs-/Memory-Zug-Liste | Wellenplan |
| U-5 WERKZEUG-WUNSCH Journal-Agent-Labels (nur v2:-Step-Key-Hashes, kein Label-Feld) | AUFGABE | W7 | Z3232-3236 | OFFEN (unverbindlich) | Traeger NEU: 22.5 C-1, Kategorie C, nur per Owner-Satz | Wellenplan |
| T-1 KON119-Maschinenlesbarkeits-Auflage: A2.5-Bilanz muss aus JSON-Quittungslisten zitieren, nicht Prosa | REGRESSION | — | Z3240-3244 | TEIL-GETRAGEN | NACHZUG in L4-/KON119-Checkliste | Wellenplan |
| T-2 S-17/B5-Traeger fuer CEB-Lager-Registry-Hash-Map (KON64), Traeger-Benennung fehlt | REGRESSION | W2 | Z3246-3249 | TEIL-GETRAGEN | NACHZUG bei P4-Ruecklauf/Di-25 in #24/B5 oder #57 | Wellenplan |
| T-3 NP-24-Bauptunkt (lazy_csv_header-Folgehaelfte nach NP-23), kein Board-Task | AUFGABE | W2 | Z3251-3254 | TEIL-GETRAGEN | NP-23 GEBAUT (Commit 78cc75e6); NACHZUG W2-Task Di-25 | Wellenplan |
| T-4 13.8-Kleinposten-Trio A9(out_path)/A10(PIC-Hausnorm)/A11(2 static_asserts) | AUFGABE | W2 | Z3256-3263 | TEIL-GETRAGEN | kein Board-/Di-25-Anker; NACHZUG Di-25-Sammelzeile | Wellenplan |
| T-5 F8-super-Stelle Konformitaetsregister teil2 (S7-HY-A "22->23" UEBERHOLT-Marker faellig) | REGRESSION | — | Z3265-3271 | TEIL-GETRAGEN | ce-Haelfte behoben; super-Haelfte lebt nur als WF-Quittung VERTAGT | Wellenplan |
| T-6 prt-art-ROUNDTRIP-SHA-PIN (K7b-3), 15er-Eingangsliste trug prt-art NICHT — durchgerutscht | REGRESSION | W2 | Z3273-3278 | TEIL-GETRAGEN | NACHZUG W2-Board-Task spaetestens Di 25. | Wellenplan |
| T-7 X-12/V-02R-Laufzeit-Befuellung: je Pruefdock-Tier-Binary eigener SHA-256, Folge-Bau-Task existiert nicht | REGRESSION | W2 | Z3280-3284 | TEIL-GETRAGEN | wartet auf P4/P5-Owner-Entscheid | Wellenplan |
| T-8 Hybrid-Stempel-Export Ende-zu-Ende (HY-B-Folgezug): Stempel-ABI-Symbol fehlt, kein Task | REGRESSION | W3 | Z3286-3292 | TEIL-GETRAGEN | NACHZUG eigener HY-B/W3-Task nach P5-Antwort | Wellenplan |
| T-9 FB20-K-1 im #24/B4-Umfeld: Break-Even-Implementierungen ZUSAMMENFUEHREN, CSV-Spalten-Luecke getrennt vorlegen | REGRESSION | W2 | Z3294-3299 | TEIL-GETRAGEN | NACHZUG #24-B4-Text Di-25 | Wellenplan |
| T-10 g2-Nebenbefunde Warnungsrunde 2: gcc-Warnung axis_03a+clang-22-Warnung gtest-printers.h+12 Non-ASCII-Altbestand | REGRESSION | W2 | Z3301-3305 | TEIL-GETRAGEN | NACHZUG namentlich in #93-A/W2-2 | Wellenplan |
| T-11 seg4-15 S-16-Regressionsmesspunkt: ci/tests 13->14 Shell-Skripte, Riegel weiter NUR Shell | REGRESSION | W2 | Z3307-3311 | TEIL-GETRAGEN | NACHZUG als Messpunkt in #28-W2-Slot | Wellenplan |
| T-12 D5-5 HDR-Verdrahtung als BAU vor Kampagne (NP-43): 0 Produktions-Konsumenten, kein Bau-Traeger | REGRESSION | vor W3 | Z3313-3318 | TEIL-GETRAGEN | NACHZUG nach #93-F-Ruecklauf, Frist vor 29.08. | Wellenplan |
| T-14 Docs-/Memory-Zug K15-Neuzugaenge: gitlab.comdare.local-Host-Regel+Rot-Lauf-Logs-Pflicht+Queue-Verfall-Lehre | AUFGABE | — | Z3328-3335 | TEIL-GETRAGEN | NACHZUG beim Memory-Zug, mit U-4 buendeln | Wellenplan |
| T-15 PRE-PUSH-GATE-DOKTRIN-REST: Memory-Eintrag "Werkzeug schlaegt Disziplin"+Komplex-Fix-Regel | AUFGABE | — | Z3337-3342 | TEIL-GETRAGEN | Mechanisierung GEBAUT (pre_push_lande_gates.sh); Doktrin-Haelfte fehlt | Wellenplan |
| T-16 E3-Folgen+H2-Auflage: Beweisorte auf gesicherte Logs umschreiben, COMDARE_WACHE_STRIKT=1 | AUFGABE | — | Z3344-3349 | TEIL-GETRAGEN | NACHZUG in L1-Lande-Checkliste+Memory-Zug | Wellenplan |
| T-17 FIX-STRECKE-2-RUECKKEHR: BU-Nachzug neuer Schnappschuss mit NEUER Redaktionspruefung | AUFGABE | — | Z3351-3357 | TEIL-GETRAGEN | NACHZUG mit naechstem Folge-BU-Zug | Wellenplan |
| T-18 SWEEP-ERGEBNIS LANDEN (dieser Nachtrag): par.22 committen+Tasks anlegen | AUFGABE | — | Z3359-3365 | TEIL-GETRAGEN (VOLLZOGEN hiermit) | 22.4=Di-25-Liste, 22.5=Nach-Abgabe | Wellenplan |
| T-19 L21/F-9-Sentinel+M-2-TSan-Fence-Naht: kein Einzelbeleg BEHOBEN/VERTAGT in Fix-Strecke 2 | REGRESSION | — | Z3367-3373 | TEIL-GETRAGEN | NACHZUG 13.7-K16-Check; falls VERTAGT: HY-B-Task Di-25 | Wellenplan |
| F2-Vorlagenfenster P1 AxisKind-Ordnung mitdrehen? | OWNER-ENTSCHEID | W1 | Z3380 | OFFEN | seg1-37 | Wellenplan |
| P2 E-6-Satz "22->23 war Phantom-Nenner — Einspruch?" | OWNER-ENTSCHEID | W1 | Z3381-3382 | OFFEN | KON118 | Wellenplan |
| P3 KON60-04-Spannung S-6 (stale, blockiert nicht) | OWNER-ENTSCHEID | — | Z3383 | OFFEN | — | Wellenplan |
| P4 C-3a-Frist Mi 19.08. — EINZIGE offene Owner-FRAGE; S-17/B5-Traeger-Benennung haengt daran | OWNER-ENTSCHEID | — | Z3384-3386 | OFFEN | 18.6(3)-Fallweg deklariert | Wellenplan |
| P5 V-08R-Form 64-Hex vs 128-Hex-S-1-Vertrag (#95 gebaut @ 0f0742aa) | OWNER-ENTSCHEID | — | Z3387-3388 | OFFEN | V-02R-Bau+HY-B-Stempel-Export warten | Wellenplan |
| P6 golden-Nachposten-Satz seg1-44+Owner-Saetze objektiv-nach-Abgabe | OWNER-ENTSCHEID | — | Z3389 | OFFEN | — | Wellenplan |
| P7 NP-02 (axis_category_of=Andockpunkt) | OWNER-ENTSCHEID | — | Z3390 | OFFEN | 13.8 A19 | Wellenplan |
| NEU im Fenster: T-3-Kenntnisnahme axis_cross_product/verbund_union + CSV-Checkpoint-Spalten-Luecke getrennt vorlegen | OWNER-ENTSCHEID | — | Z3391-3393 | OFFEN | 22.1 U-3, 22.2 T-9 | Wellenplan |
| L-A OF-4-PAT-Kette A1->A2->A3 (id=54-Abloesung->ROTATE_TOKEN @290->Schedule active=true) | AUFGABE | — | Z3397-3398 | GEPLANT | completed-#54 | Wellenplan |
| L-B V8 GitHub-PAT-Rotation (Credential-Store-Fund, #61) | AUFGABE | — | Z3399 | OFFEN | — | Wellenplan |
| L-C V9 rescue-Ref w3-thesis-c (95 Alt-Trailer), an E12-Owner-Entscheid gekoppelt | OWNER-ENTSCHEID | — | Z3400 | OFFEN | — | Wellenplan |
| L-D node6 Remote-Login/id56-Herkunft/id18-Duplikat (#60) | AUFGABE | — | Z3401 | OFFEN | — | Wellenplan |
| Einzelposten: C-3a(=P4) · Infra-Termin(#84) · E12+V9-Thesis · Z-21 Mirrors owner-gated · NEU Platten-Raeumung prod1 | AUFGABE | — | Z3403-3407 | OFFEN | Board-Owner-Zeile+13.4 | Wellenplan |
| DI-25-SCHNITT: bereits gebuchte Bestandsposten (B-8/X-13, VL-6b/X-15, S-8-Methodik, Peer-Session-Triage, L20, Nested-Worktree, G-Tafel L1-L23) | AUFGABE | W2 | Z3411-3414 | GEPLANT (Bestand) | zaehlen weiter | Wellenplan |
| Z-1 s13-J-1-Rezeptfix als ROT-Vorbedingung VOR #18 | REGRESSION | W2 | Z3417-3418 | OFFEN | 22.1 U-1 | Wellenplan |
| Z-2 prt-art-Roundtrip-SHA-Pin-Task, Anlage SOFORT | REGRESSION | W2 | Z3419 | OFFEN | 22.2 T-6 | Wellenplan |
| Z-3 NP-24-Slot | AUFGABE | W2 | Z3420 | OFFEN | 22.2 T-3 | Wellenplan |
| Z-4 W2-Miniposten-Trio 13.8 A9/A10/A11 als Sammelzeile | AUFGABE | W2 | Z3421 | OFFEN | 22.2 T-4 | Wellenplan |
| Z-5 V-02R-Bau-Task, Vermerk "nach P4/P5" | AUFGABE | W2 | Z3422 | OFFEN | 22.2 T-7 | Wellenplan |
| Z-6 HY-B-Stempel-Export-Task W3, "nach P5+A-11/#102" | AUFGABE | W3 | Z3423 | OFFEN | 22.2 T-8 | Wellenplan |
| Z-7 #24/B4-Text-Nachschaerfung FB20-K-1 | AUFGABE | W2 | Z3424 | OFFEN | 22.2 T-9 | Wellenplan |
| Z-8 g2-Nebenbefunde namentlich in #93-A/W2-2 | AUFGABE | W2 | Z3425 | OFFEN | 22.2 T-10 | Wellenplan |
| Z-9 seg4-15-Messpunkt als #28-Inventur-Startzahl | AUFGABE | W2 | Z3426 | OFFEN | 22.2 T-11 | Wellenplan |
| Z-10 D5-5-HDR-Verdrahtungs-BAU, Frist vor Sa 29.08. | AUFGABE | W2/W3 | Z3427 | OFFEN | 22.2 T-12 | Wellenplan |
| Z-11 Register-3b-Hinweis-Buendel in Docs-Zug | AUFGABE | W2 | Z3428-3429 | OFFEN | 22.2 T-13 | Wellenplan |
| Z-12 F8-super-Stelle an #85/super-Docs-Zug | AUFGABE | W2 | Z3430 | OFFEN | 22.2 T-5 | Wellenplan |
| Z-13 S-17/B5-Traeger-Benennung KON64 nach P4-Ruecklauf | AUFGABE | W2 | Z3431 | OFFEN | 22.2 T-2 | Wellenplan |
| Z-14 Betriebszeile Platten-Raeumung prod1 | AUFGABE | Infra | Z3432 | OFFEN | 22.1 U-2 | Wellenplan |
| Z-15 L21/F-9-Sentinel+M-2-Einzelbeleg-Nachschlag, falls VERTAGT->HY-B-Task | REGRESSION | W2 | Z3433 | OFFEN | 22.2 T-19 | Wellenplan |
| C-1 Workflow-Journal-Agent-Labels (Kategorie C, Nach-Abgabe/W7) | AUFGABE | W7 | Z3437-3440 | OFFEN (unverbindlich) | 22.1 U-5; Aktivierung NUR per Owner-Satz | Wellenplan |
| Bestandstafel unveraendert (OV-4/OV-5b/OV-14/W7-#88); dieser Sweep fuegt KEINEN weiteren Nach-Abgabe-Posten hinzu (119/120 haben Vor-Abgabe-Platz) | OWNER-ENTSCHEID | — | Z3442-3444 | GELTEND | par.21.6+par.21.3 | Wellenplan |
| VOLLZUG T-18: par.22 committen+Task-Anlagen laut 22.4; #96 zaehlt gegen; 13.7-K16-Pflicht prueft kuenftig auch gegen par.22 | AUFGABE | — | Z3446-3449 | ERLEDIGT | par.22 ist persistenter Traeger, kein Bericht-only-Zustand | Wellenplan |
| §23 Anlass: traegt juengere Objekt-Befunde des #93-W1-Audits + Lande-Stand nach #17/g2-Landung | OWNER-ENTSCHEID | — | Z3457-3461 | BINDEND | dieser Abschnitt vor par.22 vor par.21 | Wellenplan |
| STAND-ANKER PARALLEL: g2-Rest-Zellen-Vollabnahme am formatierten Tip laeuft | AUFGABE | W1 | Z3473-3474 | LAEUFT | T-11b am Tip | Wellenplan |
| F2-1 B1 XML-Konsum je Stufe NICHT GEBAUT — Freeze-Check-Element (P), Fallweg 18.6(4) jetzt DEKLARIERT | REGRESSION | W1/W2 | Z3479-3484 | OFFEN-REGRESSION | Registry-Neubau bis Fr unrealistisch -> W2-Anfang-Slot [Traeger #24] | Wellenplan |
| F2-2 CEB-STEMPEL system_zeile-Fuellung bewusst leer in dev UND Bruch, KEINE Fall-Deklaration | REGRESSION | W1 | Z3485-3488 | OFFEN | in #15-NACHLANDESCHRITT aufnehmen ODER 18.6-Fall deklarieren | Wellenplan |
| F2-3 S-5-ERBINNEN-REST: Tier-/HybridStempel-Erbinnen=0 Treffer in beiden Baeumen | REGRESSION | W1 | Z3489-3492 | OFFEN | mit F2-2 buendeln ODER Fall deklarieren [B-6-Rest] | Wellenplan |
| F2-4 B5 Stempel-Pflicht je Schalter haengt an F2-3+B5-Vorposten, kein Fall deklariert | REGRESSION | W1 | Z3493-3496 | OFFEN | Fall-Deklaration mit F2-3-Kopplung; KON64-B5-Anteil haengt an P4 | Wellenplan |
| F2-5 ACHT Band-A-Testposten Designplan par.4-W1 ungebaut (0 Treffer je Objekt-Messung) | REGRESSION | W1 | Z3497-3505 | TEILWEISE BEHOBEN | 2 NIE-fallen-nahe (LG-XlsxAlt+LG-SkipCallback) bis Fr BAUEN; 6+2 als Fall in W2-Randslots (~33h) | Wellenplan |
| F2-6 UMBENENNUNGS-REST: E-Label(KON37-05)+Flag-f-Kollision FPGA/AVX-512=0 Objekt-Treffer, nicht im Bauplan | REGRESSION | W2 | Z3506-3507 | OFFEN | platzieren oder deklarieren | Wellenplan |
| F2-7 SOLL-VERSIONIERUNGS-REST: Genus-CT-Komposition ungebaut+Planer-SHA owner-gated P5 | REGRESSION | W1/W2 | Z3508-3510 | TEILWEISE BEHOBEN (P5 gebaut @0f0742aa) | Teilstueck-Deklaration im Freeze-Check | Wellenplan |
| F2-8 N-1(S-6c Zwei-Welten-Wache)+N-2(S-6d-Rest, real 23 statt "142" Dateien) als deklarierte Nachlaeufe NACH #15-Landung | AUFGABE | W1 | Z3511-3513 | GEPLANT | vor Freeze-Check faellig [#15-Nachlandeschritt] | Wellenplan |
| FREEZE-CHECK-TAFEL DEKLARIERT-W2: A8/A12 clang-Warnungs-Review, A9/A11/A13 --debug-Matrix+N5, #38a2/P4, D-2-Band-B 22 Posten, B4/OF-1, S-2/G-1, Wstringop | AUFGABE | W2 | Z3517-3521 | GEPLANT (deklariert) | Fr 21.08. damit nichts als Falsch-Rot faellt | Wellenplan |
| FREEZE-CHECK-TAFEL ENTLASTET AM OBJEKT: A10 Windows-_pclose — _pclose liefert Exit-Code korrekt, KEIN Fix noetig | REGRESSION | W1 | Z3522-3524 | BEHOBEN (entlastet) | P.20.2(c)-Pflicht vollzogen | Wellenplan |
| FREEZE-CHECK-TAFEL GEBAUT_UNGELANDET (landet mit #15): S-6a-d·HY-A2/A3+Abnahmeformel·B3·#38d(Budget 8192, Summe 6057)·ABI-Pflicht 6 Symbole·A-06/08/09 | REGRESSION | W1 | Z3524-3528 | GEBAUT_UNGELANDET | landet mit #15 | Wellenplan |
| FREEZE-CHECK-TAFEL ERFUELLT: S-1 S-3 S-7 B2 HY-A1 SOLL-Vers.-Kern MT-L3 PK-Kanon/Kreuz/DeleteP99 ST-Trio(5) HY-Reroute LG-WritebackXlsx XL-L2 | FEATURE | W1 | Z3528-3529 | ERFUELLT | — | Wellenplan |
| L-N1 CI-TERMINAL: 16029 SUCCESS, 16031 running -> nach SUCCESS W1-V1-Buchung (#17 completed+Ledger) | AUFGABE | W1 | Z3533-3535 | LAEUFT | Poller b1uvq3cwn | Wellenplan |
| L-N2 wt-ce-g2-Loeschung NUR nach Doktrin (gruen+gemergt+Submodul-Check), NACH L-N1 | AUFGABE | W1 | Z3536-3537 | GEPLANT | — | Wellenplan |
| L-N3 Platte VOR naechstem Vollbau raeumen (97%/8.6G zum Verify-Zeitpunkt) | REGRESSION | — | Z3538-3539 | OFFEN | root-Anteil=par.22-Owner-Punkt | Wellenplan |
| L-N4 Sequentialitaets-Befund (Push waehrend 16029 running, Runner-Queue sequentialisierte faktisch) | REGRESSION | — | Z3540-3541 | DOKUMENTIERT | Ledger-Notiz im KON119-Umfeld | Wellenplan |
| L-N5 bump15-Lande-Vorbehalte unveraendert: T-B Lock-Erst-Versionen, T-C 4 XML-Wohlform-Fehler, F-A-Komplex-Fix, KON119-Pflichten | AUFGABE | W1 | Z3542-3546 | OFFEN | 13.8 A4 | Wellenplan |
| VERGESSENS-SCHUTZ-BILANZ K15: Register 13/13.8, Uebergabe 0-11, par.22/23, Tasks NEU #102-105, ROT-Auflage #18, Memory-Neuzugaenge | AUFGABE | — | Z3549-3555 | ERLEDIGT | K16-Einlese-Pflicht: Register VOLL+Uebergabe+par.21-23+#93-Synthese+4 /goal-Dok. | Wellenplan |
| K16-Neugruendungs-Analyse 19.08: 8 Sonnet-max-Transkript-Leser K11-K15, 137 Posten gegen T1-T6, 0 Ausfaelle, 8/8 Fenster lueckenlos (8249/8249 Z.) | OWNER-ENTSCHEID | — | Z3557-3564 | ERLEDIGT | Kette K1-K11 BESTAETIGT, 13/13 Stichproben trafen | Wellenplan |
| L10 DRINGENDST: seg4-58 snmalloc -Werror=pedantic blockt comdare_tests im super-Vollbau (37 Not Run) | REGRESSION | W2 | Z3568-3570 | OFFEN-REGRESSION | beheben ODER deklarieren VOR super-Lande-Vollbau | Wellenplan |
| L1+L4 KON106+KON109 ohne CI-SUCCESS-Beleg | REGRESSION | — | Z3573-3574 | OFFEN | EIN API-Probe-Zug im KON119-Umfeld bzw K11-Docs-Zug | Wellenplan |
| L2 KOEDER_RC=124 der 4. RCU-Endabnahme unerklaert (124=timeout-Signatur) | REGRESSION | — | Z3575-3576 | OFFEN (kein Lande-Blocker) | K11-Fallen-/Memory-Zug | Wellenplan |
| L3 PRAEZISIERT: stale i9-14900KS/raptor-Kommentar im BRUCH BEREITS GEHEILT (NP-11-KORREKTUR 765ee421); nach K3-Landung 2 Kommentar-Treffer bleiben | REGRESSION | — | Z3577-3581 | TEILWEISE BEHOBEN | Mini-Posten Di-25-Sammelzeile | Wellenplan |
| L5 ENTLASTET AM ORIGINAL: s13-Kurz-Verify-Verdikt LIEGT (par.20.9), Abgleich las par.20 nicht; Rest=2 Ein-Zeilen-KANN-Edits als Di-25-Auflage | REGRESSION | — | Z3582-3585 | BEHOBEN (entlastet) | an Task #18 angehaengt | Wellenplan |
| L6 wf_e13d73bf (namenloser W0a-Agent 10.08., T-NEU-3) — Drei-Pfade-Extraktor-Kleinlauf | AUFGABE | — | Z3586-3587 | OFFEN (niedrig) | K11-Docs-Zug | Wellenplan |
| L8 Hybrid-Parser fail-closed OHNE fehlerklasse=-Traeger (K12-Teammate-Audit) | REGRESSION | W2/W3 | Z3588-3590 | OFFEN | an T-13/T-14-Fehlerklassen-Posten angedockt | Wellenplan |
| L9 'N8' nirgends definiert (nur K12-Abschlusstabelle, N-Posten enden bei N-7) | REGRESSION | — | Z3591-3592 | OFFEN (Fussnote) | K11-Docs-Zug | Wellenplan |
| L11 Owner-Rueckfrage Kipp-Kartierer-Konstruktion — Antwort: Kippen macht Lead selbst | OWNER-ENTSCHEID | — | Z3593-3595 | ENTSCHIEDEN | seit K15 so vollzogen | Wellenplan |
| L12 HERABGESTUFT: #93-Erstlauf-Verdacht (0872967d) materiell entschaerft (finale Synthese lief NACH ba33b9ac) | REGRESSION | — | Z3596-3598 | ENTLASTET | Ein-Satz-Fussnote im KON119-Zug | Wellenplan |
| A1 Zitierpraezision par.22.3/23.3=WELLENPLAN (nicht Uebergabe) | REGRESSION | — | Z3600-3601 | DOKUMENTIERT | — | Wellenplan |
| A2 taskboard_kompakt_k15.txt endet bei #101 — fuer #102-#105 NIE den Snapshot zitieren | REGRESSION | — | Z3601-3602 | DOKUMENTIERT | Live-Board/par.23.4 | Wellenplan |
| A3 EINLESE-REGEL: Register Abschnitt 9 VOR Uebergabe-Abschnitt 2 (dort "16031 RUNNING" bereits ueberholt) | REGRESSION | — | Z3602-3603 | DOKUMENTIERT | — | Wellenplan |
| A4 clang-debug-ROT GEHEILT (Mischbau-Wurzel), Rest=PIC-Hausnorm T-4 | REGRESSION | W2 | Z3603-3604 | BEHOBEN | — | Wellenplan |
| A5 HY-A2/A3+g2 in aelteren Fenstern als offen gefuehrt = Historie, Abgleich korrekt | REGRESSION | — | Z3604-3605 | DOKUMENTIERT | — | Wellenplan |
| A6 ZWEI Zaehlbasen (688/85-roh-89 vs 107 offene) — bei Zitat Basis mitnennen | REGRESSION | — | Z3605-3606 | DOKUMENTIERT | — | Wellenplan |
| A7 #102 faehrt VOR K3, Lock-Regen bleibt Lande-Schritt 3 | REGRESSION | — | Z3606-3607 | DOKUMENTIERT | — | Wellenplan |
| A8 Task-Board ist im Landefenster kein Fortschritts-Signal (0 Statuswechsel an 99 Alt-Tasks trotz Arbeit) | REGRESSION | — | Z3607-3609 | DOKUMENTIERT | Fortschritt lebt in Register-/Uebergabe-Commits | Wellenplan |
| VL12-UNTERSUCHUNG (Owner-Zweifel 19.08. "vl12 ist nicht stale" — BESTAETIGT): wt-ce-vl12 = VL-1+VL-2, NIE substanz-stale, KOMPLETT GELANDET (Merge be724cb5) | REGRESSION | W1 | Z3611-3620 | BEHOBEN (entlastet) | "stale" traf NUR build-vl12 (raeumbarer Build-Ordner) | Wellenplan |
| VL-FAMILIE 8/8 GETRAGEN: VL-1/2 gelandet, VL-3 gelandet+#101, VL-4 owner-beantwortet, VL-5(a-e) VOLLZOGEN, VL-6a-Rest=N-2/F2-8, VL-6b=Di-25, VL-6c bestaetigt | FEATURE | W1 | Z3620-3626 | GELANDET/TEILWEISE | KEIN neuer Task noetig; Worktree nach Doktrin AUFRAEUMBAR | Wellenplan |

## Teil C — Einzelquellen-Posten: Register (417 von 439 Rohzeilen; 22 gingen in Teil A auf)

Aus `leser-register.md` uebernommen (KUERZEL/Name | Klasse | Quelle (Z-Anker) | Status LAUT QUELLE | Traeger/Task); Spalte `Welle` fehlte in der Quelle und wurde mit `—` aufgefuellt (Register traegt keine Wellen-Zuordnung), Spalte `Quellen` ergaenzt. Kein weiterer Inhalt gekuerzt oder umformuliert.

| KUERZEL/Name | Klasse | Welle | Quelle (Z-Anker) | Status LAUT QUELLE | Traeger/Task | Quellen |
|---|---|---|---|---|---|---|
| Owner-Auftrag 18.08. Regressionen-Register erstellen (codex zuerst, dann Workflows konsolidieren) | OWNER-ENTSCHEID | — | Z3-5 | GEGEBEN | Owner | Register |
| Quellen-Stand: 4/4 Codex-Lenses + 36/688 Audit-Verdikte; Abschnitt 5/6 Platzhalter | UNKLAR | — | Z7-11 | OFFEN (ausstehend) | wf_13b562e7, wf_794b904b | Register |
| Dreiwertige Quittung BEHOBEN/ENTLASTET/VERTAGT je Fund (A2.5-Weg) | OWNER-ENTSCHEID | — | Z12-13 | GEGEBEN (Verfahrensregel) | Fix-Stufe A2.5 | Register |
| Lage: 3 KRITISCH + ~12 ERNST echte Funde, Bruch landet erst nach voller A2.5-Fix-Runde | UNKLAR | — | Z17-19 | OFFEN | - | Register |
| B-F2 Preimage-KOLLISION durch stillen Stellen-Verwurf (komposit_key_text) | REGRESSION | — | Z28-34 (1.1 KRITISCH) | BEHOBEN (Fixstrecke1 18.08., Rot-zuerst: 100000001/200000001->selber Key REAL erzeugt vor Fix, s. Z488-489) | anatomy_fingerprint.hpp:1222-1234, g1-fingerprint 35ab0c46 | Register |
| B-F1 Map-Grammatik nur im optionalen Builder bewacht | REGRESSION | — | Z35-41 (1.1 KRITISCH) | BEHOBEN (Fixstrecke1, verschaerft durch Fix11: zweite Digest-Kollisionsklasse '1=x;2=y' Ein-/Zweisegment ebenfalls geschlossen) | ebd.:511-531/:806-815/:1262-1291, g1-fingerprint 35ab0c46 | Register |
| A-F1 Proxy-Bindungszustand spaltbar (ziel_binden) | REGRESSION | — | Z42-47 (1.1 KRITISCH) | BEHOBEN (Fixstrecke1, gekoppelt mit D-F5-Fix: ziel_binden-Nullpaarungs-Gate) | hybrid_binary_proxy.hpp:225-229/:251-264/:278-280, g3-hybrid 9378e463 | Register |
| A-F5 Loader: rohe uint8->Enum-Casts ungeprueft | REGRESSION | — | Z51-55 (1.2 ERNST) | BEHOBEN (Fixstrecke1 Fix2: genus_bekannt()+ist_abi_sichtbares_genus() als 2 Wertklassen, Gate-Flip-Mutation bewies dlopen-Pfad) | anatomy_module_loader.cpp:179-180/:198, g2-loader cc243c8c | Register |
| A-F4 Leak-Pfad beim Identity-Mismatch | REGRESSION | — | Z56-58 (1.2 ERNST) | OFFEN | ebd.:199-205, FIX Scope-Guards | Register |
| A-F3 CT-Sperre der Hybrid-Makros umgehbar | REGRESSION | — | Z59-63 (1.2 ERNST) | OFFEN | hybrid_module_abi_v1.hpp:71-72/:99-104, FIX Ziel einmal constexpr einfrieren | Register |
| B-F3 Identitaetswirksamer leerer Default | REGRESSION | — | Z64-67 (1.2 ERNST) | OFFEN | anatomy_fingerprint.hpp:970-989/:1164-1174/:1309-1316, FIX Default entfernen | Register |
| B-F4 32-Dock-Deckel unerzwungen | REGRESSION | — | Z68-70 (1.2 ERNST) | OFFEN | ebd.:1264-1291, FIX size()<=Deckel fail-loud | Register |
| B-F5 Dangling string_view via Temporary | REGRESSION | — | Z71-74 (1.2 ERNST) | OFFEN | ebd.:1208-1212, FIX sv() const& + sv()&&=delete | Register |
| B-F6 64-Hex-Wache prueft nur Byte 64 | REGRESSION | — | Z75-76 (1.2 ERNST) | OFFEN | ebd.:1362-1369, FIX alle 64 Bytes pruefen | Register |
| C-F2 Typ-Folge-Wache 18 statt 20 Typen | REGRESSION | — | Z77-81 (1.2 ERNST) | OFFEN | anatomy_module_abi_v1_decl.hpp:~445, FIX FeldZgr/FeldU64 anhaengen | Register |
| D-F4b Toter Enum-Name im Emissions-Pfad (Verbund2_Hybrid) | REGRESSION | — | Z82-88 (1.2 ERNST) | OFFEN | merge_plan.hpp:78, sota_catalog.hpp:238/:243, FIX "merge" laut ablehnen | Register |
| D-F5 F8-Roundtrip-Koeder umgeht das Dock | REGRESSION | — | Z89-93 (1.2 ERNST) | OFFEN | test_hy_f8_reroute.cpp:126-151, FIX Griff ausschliesslich ueber Proxy/Dock | Register |
| D-F6-Rest F8-dlopen-Haelfte 4/6 Symbole, Set-Cast-Ergebnis ignoriert | REGRESSION | — | Z94-96 (1.2 ERNST) | OFFEN | FIX alle 6 Symbole handle-lokal aufloesen | Register |
| B-F7 BudgetSum==6057-Assert erkennt kompensierende Aenderungen nicht | REGRESSION | — | Z100-101 (1.3 HINWEIS) | BEHOBEN (Fixstrecke1: 768->767+256->257-Mutation feuerte neue Reihen-Wache) | g1-fingerprint 35ab0c46 | Register |
| A-F6 kDeklarierteRerouteZiele==2-Assert tautologisch | REGRESSION | — | Z102-103 (1.3 HINWEIS) | OFFEN | FIX geschlossene constexpr-Whitelist | Register |
| D-F2 work_mode-Namen-Anker doppelt gepflegt | REGRESSION | — | Z104-105 (1.3 HINWEIS) | OFFEN | FIX Single-Source | Register |
| D-F1 resolve_measure_parallelism_of_mode()/"debug"-Exception ohne Tests | REGRESSION | — | Z106 (1.3 HINWEIS) | OFFEN | - | Register |
| D-F8 test_hy_f8 nutzt std::cout ohne <iostream> | REGRESSION | — | Z107 (1.3 HINWEIS) | OFFEN | - | Register |
| C-F5+A-F7 Kommentar-Wahrheiten (sizeof 136->152, 4->6 Pflicht-Symbole, View=4/Reroute=5, neun->zwoelf Codes) | REGRESSION | — | Z108-110 (1.3 HINWEIS) | OFFEN | Kommentare korrigieren | Register |
| B-F8 "leeres 10. Glied waere byte-identisch" ist FALSCH | REGRESSION | — | Z111-112 (1.3 HINWEIS) | OFFEN | Kommentar-Korrektur | Register |
| B-F9 "nur Vertauschungen uebersetzen nicht mehr" gilt nur S-6b, nicht S-6a | REGRESSION | — | Z112-113 (1.3 HINWEIS) | OFFEN | Kommentar-Korrektur | Register |
| A-F2 MaxDocks-Vertrag vs. Ein-Ziel-Zustand (Proxy deklariert 1..32, haelt 1 ziel_) | REGRESSION | — | Z117-121 (Sec.2 Architektur) | OFFEN | hybrid_binary_proxy.hpp:183-193/:258-280, FIX static_assert(MaxDocks==1) | Register |
| D-F3 fail-loud-Kette der Verbund-Tokens ("fulljoin" faellt still auf Verbund2_Replace) | REGRESSION | — | Z126-130 (Sec.2) | OFFEN (bedingt ENTLASTET, in A2.5 zu MESSEN) | merge_plan.hpp:79, validate_profile.hpp:705 | Register |
| C-F3 Layout-6-Probe prueft die ZAHL, nicht das Layout | REGRESSION | — | Z131-134 (Sec.2) | OFFEN | decl.hpp:~548, FIX eingefrorener Layout-6-Mirror | Register |
| LS2-34 Lock-Regen fehlt in den 25 Commits (Audit KRITISCH) | REGRESSION | — | Z138-141 (Sec.3 Plan) | OFFEN (Plan deckungsgleich, Regen = Lande-Schritt 3) | axis_version.lock | Register |
| seg1-37 AxisKind-Ordnung NICHT gedreht (Audit KRITISCH) | REGRESSION | — | Z142-145 (Sec.3) | OFFEN (gedeckt durch KON5-04, ohne GO teurer Preimage-Bruch) | F2-Owner-Vorlage Punkt 1 | Register |
| seg1-04 3 stale E-6-Verweise | REGRESSION | — | Z146-148 (Sec.3) | OFFEN | hybrid_config_xml.hpp:52-55, hybrid/README.md:33, A2.5-Doku-Fix | Register |
| seg1-40 V-08R nur zur NAME-Haelfte im Bruch (fingerprint_sha leer) | REGRESSION | — | Z149-151 (Sec.3) | OFFEN (Triage: Buendel-SOLL oder Folgeposten) | planner_version.hpp:78-84 | Register |
| seg1-43 Tooling-ORDNUNG unvalidiert (wallclock/macro/micro haengt an V-13) | REGRESSION | — | Z152-154 (Sec.3) | OFFEN (Kandidat Vorlagen-Runde) | ceb_tooling_list | Register |
| seg1-44 golden-Nachposten-Spannung (Bruch nur S-6a-Anker, nicht K1/E-B/telemetry) | REGRESSION | — | Z155-158 (Sec.3) | OFFEN (SPANNUNG AUSGEWIESEN) | Audit-Synthese + ggf. Owner-Satz | Register |
| seg1-45 PMC-Snapshot traegt 1 statt 5 Flags | REGRESSION | — | Z159-161 (Sec.3) | OFFEN (Triage, #83-Umfeld) | measurement_snapshot.hpp | Register |
| LS2-33 A1-Durchzug 9-vs-18 offen | REGRESSION | — | Z162-163 (Sec.3) | OFFEN | simd_organ_requirement, bekannter W1-Posten | Register |
| seg4-15 S-16-Regression waechst (ci/tests 13->14, 8656 Zeilen) | REGRESSION | — | Z164-165 (Sec.3) | OFFEN (Dauerposten W2, KON37-08/S-16) | guard_basis_bissprobe.sh | Register |
| Hinweis: SHA-Zuordnungs-Detail 9f8e2be8-vs-3ba0f7b3 (Ledger) | REGRESSION | — | Z168-169 (Sec.3 Hinweise) | OFFEN | - | Register |
| Hinweis: super build:clang Kill-Switch when:never + docs-only-changes | REGRESSION | — | Z168-169 (Sec.3 Hinweise) | OFFEN (D-2-Kandidat, W2-Triage) | - | Register |
| 9x UEBERHOLT sind korrekt (Bruch ueberholt dev-Staende) | UNKLAR | — | Z170 (Sec.3) | ENTLASTET (Meta-Befund) | - | Register |
| C-F1 "7. Hybrid-Makrostelle fehlt" | REGRESSION | — | Z193-195 (Sec.4) | ENTLASTET (existiert mit beiden Symbolen) | hybrid_module_abi_v1.hpp:70/:101/:104 | Register |
| D-F7 "Q2-Datei fehlt vollstaendig" | REGRESSION | — | Z196-197 (Sec.4) | ENTLASTET (existiert, 8039B, Fixture-Tabelle) | tests/unit/test_q2_identitaets_riegel.cpp | Register |
| D-F4a "Emitter rendert MergeStrategy" | REGRESSION | — | Z198-199 (Sec.4) | ENTLASTET (D-F4b-Haelfte haelt weiter) | sota_catalog.hpp:238/:243 | Register |
| E-1 ERNST (T-4-Klasse): Loader-Codes 9/10 nirgends real ERZEUGT (keine Negativ-Fixture) | REGRESSION | — | Z207-213 (Sec.5) | BEHOBEN (Fixstrecke1: 4 neue .so-Negativ-Fixtures Luegner->11/ohne-gattung->9/ohne-genus->10/alt-magic->magic_mismatch, echter dlopen-Weg) | test_q2_identitaets_riegel.cpp:127-136, g4-tests 7ccf7002 | Register |
| E-2 MITTEL: measure_parallelism-Randzellen (Env "0"->nproc, Ueberlauf ohne Deckel) | REGRESSION | — | Z214-217 (Sec.5) | OFFEN (mit D-F1 buendeln) | measure_parallelism.hpp:35-53 | Register |
| E-3 HINWEIS->TRIAGE: zweiter Nenner fehlt in test_validate_profile.cpp:607-626 | REGRESSION | — | Z218-221 (Sec.5) | OFFEN-TRIAGE (A2.5) | - | Register |
| 5 Stufe-1-ERHEBER zurueck (217 erhobene Stellen, neutral) | AUFGABE | — | Z201-204 (Sec.5) | GELANDET (zurueckgekehrt, konsolidiert) | wf_13b562e7 | Register |
| Claude-Review Bewerter+Synthese: GESAMT-VERDIKT LANDBAR_MIT_FIXES (5/5 Flaechen konvergieren) | OWNER-ENTSCHEID | — | Z237-247 (5b) | GELANDET (Verdikt), Fixes OFFEN | wf_13b562e7, 11/11 Agenten 0 Fehler 980k Tokens | Register |
| Synthese: 33 Findings (1 KRITISCH/23 ERNST/9 HINWEIS), Fix-Liste 30 Posten | UNKLAR | — | Z241-243 (5b) | OFFEN (maschinenlesbar hinterlegt) | review-synthese-w5swesjti.json | Register |
| Synthese-Begruendung: Bruch-Substanz nicht in Frage gestellt (Layout7/Format5/GliedCount10/S-6a/6-Symbole/POD152/Budget/HY-A2+A3/work_mode/V-11R korrekt gebaut) | UNKLAR | — | Z244-247 (5b) | ENTLASTET (Substanz bestaetigt) | - | Register |
| Fix 3 (NEU) dritte Alt-Fixture pinnt Loader-Reihenfolge (Magic vor Symbol-Lookups) | REGRESSION | — | Z256-257 (5b Fix-Liste) | BEHOBEN (Fixstrecke1) | - | Register |
| Fix 8 (NEU) Q2-Selbstvergleichs-Tautologie (gattung_of gegen sich selbst geprueft) | REGRESSION | — | Z261-262 | BEHOBEN (Fixstrecke1: unabhaengige erwartete_gattung-Spalte) | - | Register |
| Fix 11 (verschaerft B-F1) '1=x;2=y' Ein-/Zwei-Segment-Map byte-identisch = zweite Digest-Kollisionsklasse | REGRESSION | — | Z263-264 | BEHOBEN (Fixstrecke1, s.o. B-F1) | constexpr-Grammatik-Pruefer | Register |
| Fix 12 (NEU) KompositMapGlied-Laengen-Wache fehlt (Laufzeit-Weg waechst unbegrenzt) | REGRESSION | — | Z265-266 | BEHOBEN (Fixstrecke1) | Budget-Zusage war am Parameter-Eingang unwahr | Register |
| Fix 14 (NEU) Offset-Pins 136/144 fuer name_line/name_len fehlen in Stamp-Tafel | REGRESSION | — | Z267-268 | BEHOBEN (Fixstrecke1) | - | Register |
| Fix 15+16 (praezisiert D-F3/D-F4b) validate-Gate fuer merge + merge_mode_to_strategy fail-closed | REGRESSION | — | Z269-271 | BEHOBEN (Fixstrecke1, s.o. D-F3/D-F4b) | Alt-Token 'fulljoin' invertierte still Union->Replace | Register |
| Fix 17 (NEU) debug-Restbestaende in run_methodology_registry-Doku (profile_run_entry:956 empfiehlt woertlich werfenden Fehlerpfad) | REGRESSION | — | Z272-273 | BEHOBEN (Fixstrecke1) | - | Register |
| Fix 18 (NEU) 3 stale Vor-S-6a-Ordnungs-Saetze (fingerprint:1154/:577/:130) | REGRESSION | — | Z274-276 | BEHOBEN (Fixstrecke1) | Anleitung fuer falsche vierte Stelle | Register |
| Fix 20 (NEU) lint_layer_includes.sh deckt hybrid/ nicht | REGRESSION | — | Z277-278 | BEHOBEN (Fixstrecke1) | Kante builder/->hybrid/ war unbewacht | Register |
| Fix 21 clang-release-Vollbau+ctest am Tip VOR Landung PFLICHT (R1 heilt NUR-clang-ab-O2-Fehler) | AUFGABE | — | Z279-280 | GEGEBEN (Pflicht, erfuellt s. Z496-497) | Landungs-Vorbedingung | Register |
| Fixes 22-30 HINWEISE (Cross-Pins HeuristikAdapter/Reroute-Aritaet, Budget-Prosa maschinell, ~4600->4416, Test-Umbenennung At120->At152, stale Anker, Mengen-Kommentare, Overflow-Gate, (d)-Anker, Klassifikations-Historie) | REGRESSION | — | Z282-285 | BEHOBEN (Fixstrecke1, Pauschal-Bilanz) | - | Register |
| 9 ENTLASTUNGEN der Synthese (clang-debug-PIE vorbestehend, Lock-Regen=Lande-Schritt, Stempel-Pflicht=golden-Folgezug, TABU-CRC haelt, Kern-Substanz richtig gebaut, (d)-prozessual-gedeckt, Overflow dormant, F8-Delegations-Proben echt, V-11R-K13 vorbildlich) | UNKLAR | — | Z286-289 | ENTLASTET | - | Register |
| 5c RESUME-BILANZ: 18 heutige Task-Outputs geprueft; 2 unvollstaendige Workflows sind bereits sequentielle Resumes (Audit wf_794b904b als wg7df0h36, Review wf_13b562e7 als w5swesjti); mehrere Vorlaeufe/Doppelstarts identifiziert; KEIN weiterer nicht-doppelter failed Workflow | AUFGABE | — | Z291-298 (5c) | GEKLAERT | - | Register |
| VOLL-AUDIT-SYNTHESE ENDSTAND (wf_794b904b): 502 ERFUELLT / 74 UEBERHOLT / 85 ABWEICHUNG / 22 FEHLT ueber 688 Zusagen (65/65 Agenten, 0 unverifiziert, >14h sequentiell 18.08. 14:47-19.08. 05:13 + Resume) | UNKLAR | — | Z300-307 (Sec.6) | ABGESCHLOSSEN | wf_794b904b | Register |
| GESAMTURTEIL: UEBERWIEGEND JA (Soll-Erfuellung TEILWEISE, Doktrin-Treue JA/Verstoesse selbst geheilt, Beweis-Vollstaendigkeit TEILWEISE, Owner-Wort-Treue TEILWEISE/1 Rangfolge-Verstoss); LANDE-FREIGABE LANDBAR_MIT_FIXES (F1-F9), F1/F2/F3=PUSH-SPERREN | OWNER-ENTSCHEID | — | Z304-307 | GEGEBEN (Verdikt) | - | Register |
| K1=F1 (PUSH-SPERRE) V-01R AxisKind-Dreh+CT-Zuordnung NICHT gebaut, Gegenteil-Entscheid mit doppelt ueberholtem KON5-04 dokumentiert; A2.3a-NEIN-Probe hiermit KORRIGIERT: V-01R gilt | REGRESSION | — | Z309-316 (Sec.6 KRITISCH) | OFFEN (PUSH-SPERRE) | bauen ODER Owner-Satz VOR Merge + KON119-Revision; = seg1-37/W1-V1-Verwandte | Register |
| K2=F6 golden-gebundene Bauplan-Reste ohne EINEN terminierten Zug (telemetry-silent/B-9 build_version-wirksam, CRC-Anker-Zug B-10.3, Bissprobe B-11.2, A-11-Stempel-Pflicht traegerlos); Task-#15-Zusage '3 golden-Nachposten' unerfuellt; ENTLASTUNG: K1-avx512 korrekt nicht vorgezogen, id-CRC MATCH, seg1-81-NP-19-Falsch-Null | REGRESSION | — | Z317-322 | OFFEN | EIN golden-Ereignis VOR F2 terminieren, A-11 Task+T-1-Abnahme | Register |
| K3 W1-Push ohne eigene Lande-Gate-Kette (KON114-02, 15971-Rot als Quittung) | REGRESSION | — | Z323-325 | BEHOBEN (GEHEILT, Lehre verankert), Rest: Pre-Push-Script mechanisieren | gilt auch E13/KON116-01 | Register |
| E1 clang-debug-Kombibau-Viertel OHNE gruenen Volllauf; 'PIE vorbestehend'-Entlastung=V11-Stellvertreter; Verdacht ENABLE_EXPORTS(0d0ad521) link-wirksam -> F2 (PUSH-SPERRE) | REGRESSION | — | Z327-330 | OFFEN (PUSH-SPERRE) | Basis-Probe am 20c111c4 + Volllauf am Tip | Register |
| E2 Endstand ungedeckt: realer Tip e285d316=30 Commits (Uebergaben nannten 25/32, nie literal gemessen); Hygiene deckt nur bis 67dafa46, ctest bis 19e7951a, 7 A2.5-Commits ungedeckt -> F3 (PUSH-SPERRE) | REGRESSION | — | Z330-332 | OFFEN (PUSH-SPERRE) | - | Register |
| E3 tragende LastTest.log-Beweisorte im Worktree durch 0-Test-Laeufe zu FALSCH-NULLEN ueberschrieben (Belege nur in .review-tmp/g6_*+jobs-tmp) | REGRESSION | — | Z332-334 | OFFEN | Beweisorte umschreiben, kuenftig ctest --no-tests=error | Register |
| E5 NP-23/24 PMC-Snapshot-Flags: POD-Wirksamkeit KLAEREN -> F5 | REGRESSION | — | Z337-338 | OFFEN | - | Register |
| E6 E-6-Doku 0/3 -> F8 | REGRESSION | — | Z338 | OFFEN | - | Register |
| E7 V-06-Stempel-Pflicht-Haelfte (A-11) traegerlos -> in F6 | REGRESSION | — | Z338-339 | OFFEN | - | Register |
| E9 V-13 = #99 | AUFGABE | — | Z339 | OFFEN | #99 | Register |
| E10 PMC-fail-loud = #83 (vor Trigger 26.08.) | AUFGABE | — | Z340 | OFFEN (Frist 26.08.) | #83 | Register |
| E11 TSan-Beleg + F-9 fehlen im Bruch-Anker (F-9=Basis-Altbestand, HY-A2-Traeger) | REGRESSION | — | Z340-341 | OFFEN | - | Register |
| E12 Thesis-Remote traegt wieder 1 Co-Authored-By-Commit 09cc728 auf ALLEN Refs beider Remotes (vermutlich via Owner-Overleaf-Linie zurueckgeflossen) + lokale Klone stale | REGRESSION | — | Z341-344 | OFFEN (Owner-gated, Rewrite=Remote-Loeschung), NICHT #15-blockierend | = Z-26/seg1-52-Verwandte | Register |
| E13 W2-Gates nicht am Endstand (KON116-01, 15978-Rot) | REGRESSION | — | Z344 | BEHOBEN (GEHEILT), Rest in F9 | - | Register |
| FEHLT/ABWEICHUNG-TAFEL P1-P14 spiegeln K1/K2/E4-E12 je seg-Anker | REGRESSION | — | Z346-347 | OFFEN (Sammelverweis) | - | Register |
| P14 ENTLASTET (bestandslog-Posten korrekt Di-25-faellig, NP-19-Trennung vorhanden) | REGRESSION | — | Z347 | ENTLASTET | - | Register |
| H1 Root-Duplikat ./system_axis_registry.xml (12285B, Generator-Default out_path=CWD) -> F7 | REGRESSION | — | Z349-350 | OFFEN | - | Register |
| H2 Abdeckungs-Wache lief WEICH (COMDARE_WACHE_STRIKT ungesetzt) | REGRESSION | — | Z350-351 | OFFEN (fuer Lande-Gates STRIKT=1 setzen) | - | Register |
| H3 unquittierter Flake test_seg_coverage (03:51 Failed -> 03:52 Passed ohne Commit) | REGRESSION | — | Z351-352 | OFFEN | Findings-Register + vor Kampagne klaeren | Register |
| H4 K16-Kollisions-Heilung vorbildlich; KON119 mit bump15-a/b/c/d-Namensnennung (F9) | REGRESSION | — | Z352-353 | ENTLASTET (positiv), F9-Namensnennung OFFEN | - | Register |
| H5 klassifikation.hpp:28 '==5'-Historienzitat (mit F8) | REGRESSION | — | Z353-354 | OFFEN | - | Register |
| H6 Muster: ALLE Verstoesse Disziplin-, keine Mechanik-Fehler -> Pre-Push-Script (K3/E13) | AUFGABE | — | Z354-355 | OFFEN | Pre-Push-Script | Register |
| H7 Audit-Anker 67dafa46=23 Commits, realer Tip e285d316=30 -- KON119 fuehrt literalen Endstand | REGRESSION | — | Z355-356 | OFFEN | KON119 | Register |
| Detail-Tafel: 111 Einzelverdikte (22 FEHLT+89 ABWEICHUNG; Kopfzahl nennt 85 ABWEICHUNG dedupliziert) als Abschnitt 6b am Dateiende | UNKLAR | — | Z358-359 | VERWEIS (spaeter in Datei) | - | Register |
| KONSEQUENZ Sec.6: Fix-Strecke2 = F1-F9 + Register-11-Zusaetze (T-2 Positions-Beweise, T-10 V-02R-Verkettung, beide NICHT im Audit) + Register-G-L21 (F-9/TSan-Triage); Reihenfolge F1(bauen)+F2/F3 vor Push; F4 haengt an C-3a-Antwort; F6 vor F2 terminieren | AUFGABE | — | Z361-364 | GEPLANT | - | Register |
| POSITIV bestaetigt (Lens, Abschnitt 7): POD 20 Felder/152@align8 korrekt, designierte Initialisierer MESS/SYSTEM/ORGAN, 6 Makros signaturidentisch, Gate-Grammatik 9 Felder/512 Formen/AUS-Laenge 3+26+8=37, anatomy_name_hex consteval+Terminierung, Budget 32+768+256+256+128+512+1536+128+64+2368+9=6057 nachgerechnet (Reserve 2135/8192) | FEATURE | — | Z372-377 (Sec.7) | CI-BEWIESEN | Lens-Bestaetigung | Register |
| POSITIV bestaetigt (Lens, Abschnitt 7): Erzeuger MESS/SYSTEM/ORGAN konsistent, Format5/10 Glieder/Komposit[9] gepinnt, K-1-Sperren wirksam, Loader-Returns entladen+destroy vor unload, 6 Exports extern"C", Alt-Major-Fixtures ODR-frei, Admission Groesse6+Hybrid-CT+Cross-Pin korrekt, 3 Verbund-Strategien altsemantik-treu, 4 work_modes nutzen Release, B4-Paare 4/6 direkt geprueft | FEATURE | — | Z377-382 | CI-BEWIESEN | Lens-Bestaetigung | Register |
| KONSEQUENZ-Kette Sec.8 (18.08. nachmittags): (1) Review+Audit-Synthese abwarten->5b/6, (2) W1-Audit#93 drittes Glied->Abschnitt9, (3) A2.5-Fix-Stufe(Fable max) T-1 je Fund Rekursion bis 0, (4) Landung nach Kontext-13-Rezept(5e0b7f95)+F2-Owner-Vorlagen | AUFGABE | — | Z384-392 (Sec.8) | GEPLANT | - | Register |
| 9.0 GESAMTURTEIL: NEIN auf Posten-/Formel-Ebene, JA auf Strang-Ebene; 4 Straenge+Nachzuege sind Ancestors; #17/g2 gelandet+gepusht (ba33b9ac); 'W1 abgeschlossen' als Vollzaehligkeits-Aussage war falsch | UNKLAR | — | Z400-402 | GEKLAERT (Widerspruch zu W1-V1 aufgeloest) | - | Register |
| ZAEHLER 9.0: 91 Verdikte roh = 39 ERFUELLT/13 GEBAUT_UNGELANDET(=#15-Bruch)/16 OFFEN_VOR_F2/20 W2-DEKLARIERT/0 GESTRICHEN(einzige Kandidatin D-2-Band-B=Historie)/3 UNKLAR | UNKLAR | — | Z402-404 | GEZAEHLT | - | Register |
| W1 wird komplett durch: #15-Landung -> Stempel-Nachlande-Zug -> F2-5-Kleinbauten -> ##10b/OV-4-Vorlage -> Freeze-Check-Buchungen | AUFGABE | — | Z405-407 | GEPLANT | - | Register |
| 9.1(1) #15-LANDUNG einziger Erfuellungsweg fuer B3+13 GEBAUT_UNGELANDET; Voll-Abnahme@79171599 KOMPLETT 4x507/507 | AUFGABE | — | Z409-411 (9.1) | OFFEN (Voraussetzung erfuellt) | #15 | Register |
| 9.1(2) g2-Schlussstueck 16031-Terminal INZWISCHEN VOLLZOGEN (TERMINAL SUCCESS 20:23Z, #17 completed) | AUFGABE | — | Z411-412 | BEHOBEN | #17 | Register |
| 9.1(3) KON17-01-Freigabe #7/S-19 wirksam erst mit #15-Landung (S-19 Sa-Mo) | AUFGABE | — | Z412-413 | OFFEN (abhaengig #15) | #7/S-19 | Register |
| 9.1(5) Stempel-Nachlande-Zug F2-2+F2-3 (CEB-system_zeile KON8-03 + S-5-Erbinnen) | AUFGABE | — | Z413-414 | OFFEN | F2-2/F2-3 | Register |
| 9.1(6) B5/B5-VORPOSTEN (F2-4, Fable max) | AUFGABE | — | Z414 | OFFEN | F2-4 | Register |
| 9.1(7) LG-SkipCallback (WOERTLICHES F2-Abnahmekriterium) | FEATURE | — | Z415 | OFFEN | F2 | Register |
| 9.1(8) LG-XlsxAlt (NIE-fallen-Klasse) | FEATURE | — | Z415 | OFFEN | - | Register |
| 9.1(9) ##10b working_set-8388608-Messpunkt + beide --check-size-Reihen in OV-4-Vorlage | AUFGABE | — | Z416 | OFFEN | OV-4 | Register |
| 9.1(10) D4f Break-Even-Statusraum-Typ ('jetzt, solange 0 Konsumenten'; OV-6=ja; KEINE W2-Deklaration existiert) | AUFGABE | — | Z417-418 | OFFEN (bauen oder deklarieren) | - | Register |
| 9.1(11) ##16/##17 an OV-1 (deklarierter Fallback par.7:1002 greift sonst) | AUFGABE | — | Z418-419 | OFFEN | OV-1 | Register |
| 9.1(12) ##19 LaTeX-/Ranking-Emitter (bei OV-1-Fallback bleibt 'beste je Last/beste 5' unadressiert) | FEATURE | — | Z419-420 | OFFEN (bauen oder deklarieren) | - | Register |
| 9.1(13) A10/VL-3(c) _pclose: statischer Blick VOLLZOGEN (par.23.2 ENTLASTET 19.08., l.rc=status korrekt), Rest=Deklarations-Buchung kein Bau | REGRESSION | — | Z421-422 | BEHOBEN (statisch), Rest OFFEN (Deklaration) | - | Register |
| 9.1(14) S-6d/#67 Vier-Familien-Benennung (29 Include-Wanderungen ungebaut) + N-1/N-2 (F2-8) | FEATURE | — | Z422-424 | OFFEN | F2-8 | Register |
| 9.1(15) F2-6 Umbenennungs-Rest E-Label + Flag-f (platzieren oder deklarieren) | AUFGABE | — | Z424 | OFFEN | F2-6 | Register |
| 9.1(16) FREEZE-CHECK-Buchungen (B1-18.6(4)-Zahl, #38a2-T-A, N1/N5-DEKLARIERT-Ausweis, F2-7-Teilstuecke) | AUFGABE | — | Z425-426 | OFFEN | Freeze-Check | Register |
| 9.2 GEBAUT_UNGELANDET (13+1): S-6a, #38d, S-6b-Fortschreibung, S-6c/S-21(94095eda), S-6d-Anteil(V-11R+A-06/A-08), S-5-Bildungs-Haelfte, B3(f4e88786+4cb16334), HY-A2, HY-A3, ABI-Pflicht 6 Symbole(Emitter-Haelfte=#102), HY-ModulGrenze-Testlast, P.20.10-Abnahmeformel(3 Logs), A14/M-5-Messung, clang-debug-Heilung 4x507/507(ersetzt NICHT N1-Warnungs-Review) | FEATURE | — | Z428-432 (9.2) | GEBAUT (ungelandet, Traeger #15-Bruch) | - | Register |
| 9.3 W2-DEKLARIERT (12 explizit benannt von 20): N1-Warnungs-Review, N5-Matrix(6fdad80c REVERTIERT ca26044e,Selbstkorrektur), A15/Wstringop(praezise W4/W5-RANDSLOT), S-2/G-1, B1(18.6(4)/#24), B4(haengt OF-1), MESS-dreiphasig=#53, D5-5-Rest(#105,Frist29.08.), ##11 measure_selection(#18), 6 F2-5-Randslot-Posten(PM-Naht Falsch-Null korrigiert), D-2-Band-B(nie GESTRICHEN buchen), #38a2(18.6(3)) | AUFGABE | — | Z434-441 (9.3) | W2-DEKLARIERT | diverse #-Traeger | Register |
| 9.4 ##15-K6 = ERFUELLT NACHGEBUCHT: derive_default_experiment_phases() (grep auto_phase=0 Treffer!), Ledger-Marker :22951 UEBERHOLT, alle 5 K-Posten K1-K4+K6 GEBAUT | REGRESSION | — | Z443-455 (9.4) | BEHOBEN (ERFUELLT nachgebucht) | - | Register |
| 9.4 LG-LoadWache = W2-RANDSLOT BESTAETIGT (test_e24_c10_g5 prueft NUR Set-Genus; Kontrast test_e24_c10_genus_dll_roundtrip faehrt 4 Genera) | REGRESSION | — | Z456-460 | OFFEN (bleibt 6+2-Deklaration) | - | Register |
| 9.4 LG-Idempotenz = W2-RANDSLOT PRAEZISIERT AUF EINE ZELLE (5/6 Zellen objektweit gedeckt, fehlt NUR [beide x Wiederholungslauf]) | REGRESSION | — | Z461-467 | OFFEN (Di-25-Slot) | - | Register |
| 9.5 OWNER-VORLAGE-KANDIDATEN (7, ins F2-Fenster P1-P7): OV-1 Break-Even-Kanon(+##19), OV-4-Deckel(##10b-Messung geliefert), HY-Ebene4a-Entscheid(war Mi19. terminiert), G-1 9/12 Fragen, P5 fingerprint_sha-Form, OF-1(B4 haengt daran,war Mi19. faellig), #38a2/P4-Paket-Entscheid(Tripwire) | AUFGABE | — | Z469-472 (9.5) | OFFEN (Owner-Vorlage), 2 Fristen bereits verpasst | P1-P7 F2-Fenster | Register |
| 9.6 KONSEQUENZ-DELTA: NEU ohne Traeger (##10b,D4f,##19-Mitfall-Ausweis,S-6d-Benennungs-Entscheid) hiermit getragen; PM-Naht-Falsch-Null korrigiert; A10=Deklaration statt Bau; 3 UNKLAR-Messungen als Mini-Posten vor Freeze-Check | UNKLAR | — | Z474-478 (9.6) | GEKLAERT | - | Register |
| A2.5-FIX-STRECKE 1 VOLLZOGEN (wf_a1b55606, 7/7 Agenten, 0 Fehler) | AUFGABE | — | Z480-484 (Sec.10) | GELANDET | wf_a1b55606 | Register |
| BILANZ Fixstrecke1: 42 BEHOBEN, 0 ENTLASTET, 1 VERTAGT (C-F4->W2-Task); Worktree-Tip 67dafa46->19e7951a (6 Commits: g1-fingerprint 35ab0c46, g2-loader cc243c8c, g3-hybrid 9378e463, g4-tests 7ccf7002, g5-semantik cdec6079, abnahme-format 19e7951a) | REGRESSION | — | Z482-486 | BEHOBEN (42/43, deckt Abschnitt1/2/5 -- Einzel-Zuordnung je Zeile s.o. dort wo explizit belegt) | fixstrecke1-ergebnis-wiq9ihup1.json | Register |
| ABNAHME GRUEN am End-Tip 19e7951a: gcc-release 503/503 | AUFGABE | — | Z495 | CI-BEWIESEN | - | Register |
| clang-release 503/503 (Fix-21-Pflicht erfuellt, R1/ENABLE_EXPORTS-Zelle gemessen; fruehere 503-vs-502-Differenz war stale EXCLUDE_FROM_ALL-Binary, per Relink geheilt) | REGRESSION | — | Z496-498 | BEHOBEN/CI-BEWIESEN | - | Register |
| gcc-debug 499/499 (Differenz 4 gemessen erklaert per comm ueber ctest -N) | AUFGABE | — | Z498 | CI-BEWIESEN | - | Register |
| clang-debug NICHT gefahren (vorbestehender PIE/HDR-Rest, deklariert) | REGRESSION | — | Z499 | OFFEN (deklariert, nicht behoben) | - | Register |
| Abdeckungs-Wache GUARD_EXIT=0 literal '503 von 503' | AUFGABE | — | Z499-500 | CI-BEWIESEN | - | Register |
| Floor avx512f 503==Anker | AUFGABE | — | Z500 | CI-BEWIESEN | - | Register |
| Exit 1 mit 4 versionslosen Traegern LITERAL PROTOKOLLIERT = deklarierter Lande-Schritt | AUFGABE | — | Z501 | GEPLANT (deklariert) | - | Register |
| Diff-Hygiene GRUEN (5165 Zusatzzeilen, 0 Nicht-ASCII, 0 >120), clang-format-Nachzug 19e7951a, gitleaks clean, TABU-CRC unbewegt, golden-Diff 67dafa46..HEAD=0 Byte | AUFGABE | — | Z502-505 | CI-BEWIESEN | - | Register |
| VERIFY RUNDE 1: 3 kleine Luecken -> REKURSION RUNDE 2 (wf_b943361e): (1) C-F3 in Synthese-Dedup verloren, (2) 4 Triage-Posten ohne dreiwertige Quittung (seg1-40/43/45,LS2-33), (3) Nachzug-Pflichten (C-F4-W2-Task, seg1-04-super-Haelfte) | REGRESSION | — | Z507-512 | OFFEN -> Runde 2 | wf_b943361e | Register |
| Verify R1 bestaetigt: ALLE 21 KRITISCH/ERNST-Diffs tragen Anweisung, KEINE neue Code-Regression, Kopplung g3<->g4 konsistent | UNKLAR | — | Z511-512 | ENTLASTET | - | Register |
| 10b RUNDE 2 VOLLZOGEN+VERIFY: NULL_NEUE_FUNDE, A2.5-REKURSION #15 FORMAL BEENDET (End-Tip e285d316 auf 19e7951a) | AUFGABE | — | Z514-515 | BEHOBEN/GELANDET | - | Register |
| C-F3 BEHOBEN @ e285d316 (Variante a Kommentar-Ehrlichkeit, 15 ///-Zeilen; Mirror-Variante verworfen) | REGRESSION | — | Z517-518 | BEHOBEN | ersetzt "OFFEN" Status aus Sec.2 | Register |
| seg1-43 ENTLASTET (deklariert-ungedeckt; V-13 per KON101 BEANTWORTET, offen nur BAU B-5f an 3 Stellen) | REGRESSION | — | Z521-523 | ENTLASTET | - | Register |
| seg1-45 VERTAGT -> #83 | REGRESSION | — | Z523-524 | VERTAGT | #83 | Register |
| LS2-33 VERTAGT -> #44-Rest (Bruch beruehrt Flaeche nicht) | REGRESSION | — | Z523-524 | VERTAGT | #44-Rest | Register |
| seg1-44 ENTLASTET-bestaetigt (Spannung ausgewiesen, Aufloesung Audit-Synthese+Owner) | REGRESSION | — | Z525 | ENTLASTET-bestaetigt | - | Register |
| Verify R2 (unabhaengig nachgemessen): NULL_NEUE_FUNDE (C-F3-Fakten geprueft, golden-Diff 19e7951a..e285d316=0 Byte, TABU 0 Diff, clang-format rc=0, ctest m_w12 gruen beide Zellen) | AUFGABE | — | Z529-532 | ENTLASTET/BEHOBEN | - | Register |
| Prozess-Notiz: Prompt-Interpolation der Quittungen scheiterte erneut am Template-Literal (bekannter Orchestrator-Bug), Verify rekonstruierte aus journal.jsonl | REGRESSION | — | Z532-534 | ENTLASTET (kein Fund am Gegenstand) | Orchestrator-Bug bekannt | Register |
| Bruch fix-komplett bei e285d316, wartet auf Audit-Ruecklauf -> Fix-Strecke2 -> W1-Audit#93 -> Landung | UNKLAR | — | Z534-535 | OFFEN | - | Register |
| Owner-Auftrag 19.08. (K14): K13-Session-Log Z68514-69705+K12-Endphase Z67336-68514 VOLLSTAENDIG nachvollziehen, Luecken hier dokumentieren | OWNER-ENTSCHEID | — | Z539-542 (Sec.11) | GEGEBEN | - | Register |
| 11.0 VERLAUFS-REKONSTRUKTION: K13 (18.08. 09:13-21:24 UTC) diente 5 Zwecken (Owner-Audit 688, Dual-Review, #93 W1-Luecken, Fork, par.21-Konsolidierung); K13 verlor ~5,5h durch 2 Limit-Risse | UNKLAR | — | Z544-552 | GEKLAERT | - | Register |
| [T-2] Fingerprint-Positions-Beweise :609-627 FORTGESCHRIEBEN statt am Objekt neu bewiesen (bump15-a Z67631 'Prioritaet (iv) OFFEN') | REGRESSION | — | Z555-559 | OFFEN | Fix-Strecke2: Positions-Beweise am End-Tip e285d316 frisch messen | Register |
| [T-10] V-02R SHA256-Verkettung Hybrid-Pruefdock-Tier-Binaries VERBLEIB UNGEKLAERT (bump15-a Z67560 'KONFLIKT, NICHT GEBAUT', unter EXPLORE-PFLICHT) | REGRESSION | — | Z560-565 | OFFEN | Fix-Strecke2 + #93-Gruppe C(HY) | Register |
| [T-3] Bewusste Namens-Abweichung ohne Meldung: algorithm_baustein.hpp full_join->axis_cross_product statt verbund_union | REGRESSION | — | Z568-571 | ENTLASTET (fachlich sauber, nie gemeldet) | Meldungs-Tafel-Punkt | Register |
| [T-5] clang-22-Falle -fassume-unique-vtables: dynamic_cast auf FINAL-Klasse -> vtable-Zeigervergleich, nullptr NUR clang -O2/-O3 | REGRESSION | — | Z574-580 | BEHOBEN (ENABLE_EXPORTS ON am Test-Target; -fno-assume-unique-vtables erwogen+VERWORFEN) | Fallen-Register T-11c | Register |
| [T-6] Koeder-Reichweiten-Lehre: Koeder B (merge='Stufe2_PrueflingReplace') biss NICHT, weil AUSSERHALB der Pruefmenge lag | REGRESSION | — | Z581-586 | BEHOBEN (b54311f0: Namens-Naht + Sammel-Test Nenner>=8) | Fallen-Register | Register |
| [T-9] "Q2/Q3 GESTOPPT (K16)" IST AUFGELOEST: bump15-d baute P8 komplett als R2+R0(110->0 Warnungen)+R1(T-5-Fix) | REGRESSION | — | Z589-593 | BEHOBEN (KEIN offener Faden) | - | Register |
| [T-1] j3/work_mode-Eingang KEINE stille Streichung (Director-Test testet j3-Mechanik state-direkt, S-8-Grenze dokumentiert) | REGRESSION | — | Z594-598 | ENTLASTET, Rest: Task-#22-Text um j3-Direktor-Test-Haelfte ergaenzt | #22/OD-7 S-8 | Register |
| [T-4] Verbund2_Hybrid BEREITS GEDECKT als D-F4b+Fix15/16 (bump15-c-Abweichung 2 vom Review unabhaengig gefunden+behoben) | REGRESSION | — | Z599-600 | ENTLASTET | - | Register |
| [T-8] bump15-b-Probe-TUs GESICHERT (name_probe/komposit_probe/maxlen_probe/kp_koeder.cpp aus Job-tmp nach backups-workflow kopiert) | AUFGABE | — | Z601-603 | BEHOBEN | 20260819-bump15b-probe-tus/ | Register |
| 11.5 KONSEQUENZ-DELTA: Fix-Strecke2 +2 Posten (T-2,T-10) vor Triage-Liste, Meldungs-Tafel +1 (T-3), Fallen-Register +2 Klassen (T-5,T-6); Kette selbst NICHT geaendert | AUFGABE | — | Z605-608 | GEPLANT | - | Register |
| 6b DETAIL-TAFEL: 114 Verdikt-Objekte -> 111 eindeutige IDs (22 FEHLT: 0 KRIT/18 ERNST/4 HINWEIS; 89 ABWEICHUNG: 4 KRIT/62 ERNST/23 HINWEIS); Synthese-Zaehlung 22/85 dedupte 4 Doppel-IDs schaerfer; Beleg-Zellen bei ~230 Zeichen geschnitten, Volltext in BU-Journal-Kopie | UNKLAR | — | Z610-620 (Sec.6b) | ABGESCHLOSSEN (Rohliste) | audit-wf794b904b-journal-ENDSTAND.jsonl | Register |
| F-D6 [ERNST] Owner-GO seit 17.08 (KON104-01/02) 'D-6 als ueberholt MARKIEREN' -- Objekt ohne Marker | REGRESSION | — | Z624 (6b FEHLT) | FEHLT | - | Register |
| F-D7 [ERNST] Owner KON104-01/02-D-7 'Weg1 ehrliche Luecken-Zeile JETZT' -- le_limitierung.tex DE+EN ohne Anhang-A-Luecken-Zeile | REGRESSION | — | Z625 | FEHLT | - | Register |
| F-E2 [ERNST] bausteine_bewertung/baustein_bewertung = 0 Pflichtformat-Artefakte (Existenz-Suche negativ, beide Schreibweisen) | REGRESSION | — | Z626 | FEHLT | - | Register |
| LS2-66 [ERNST] harness/perm_runner.hpp nur Zwei-Phasen-Cache-Warmup, keine Paar-Persistenz/Retry-5x/--debug-Zweig | REGRESSION | — | Z627 | FEHLT | - | Register |
| LS2-78 [HINWEIS] B4-Umbau NICHT vollzogen, static_assert(...==6 Steuerdocks) NICHT entfernt | REGRESSION | — | Z628 | FEHLT | steuer_dock.hpp:234-235 | Register |
| LSEG8-17 [ERNST] Konsolidierung nicht vollzogen: axis_spline.hpp monotone kubische Hermite statt B-Spline | REGRESSION | — | Z630 | FEHLT | letzter Commit 26487fb1 vor 08.08-Entscheid | Register |
| PAU-03 [ERNST] Kein dokumentierter Terminal-Status ('15787' grep trifft nur Pause-Doku selbst) | REGRESSION | — | Z631 | FEHLT | - | Register |
| SEG5-16 [ERNST] measure_to_latex = 0 Treffer ueber ce/wt/super; csv_to_latex hat Konsumenten | REGRESSION | — | Z632 | FEHLT | - | Register |
| Z-21 [HINWEIS] Live-API remote_mirrors=0/0 (Projekte 288/286), 3 github.com-Zeilen noch im Store | REGRESSION | — | Z633 | FEHLT | - | Register |
| seg1-04 [ERNST] 0/3 Nachzuege im 23-Commit-Bruch: hybrid_config_xml.hpp E-6-Verweis unveraendert | REGRESSION | — | Z634 | FEHLT | (= seg1-04 Sec.3, Status-Fortschreibung) | Register |
| seg1-40 [ERNST] planner_version.hpp:78-84 UNVERAENDERT, fingerprint_sha() leer | REGRESSION | — | Z635 | FEHLT | (= seg1-40 Sec.3, spaeter VERTAGT->#95 s.10b) | Register |
| seg1-43 [ERNST] KEINE der 3 Stellen validiert Ordnung wallclock/macro/micro | REGRESSION | — | Z636 | FEHLT | (= seg1-43 Sec.3, spaeter ENTLASTET s.10b) | Register |
| seg1-45 [ERNST] measurement_snapshot.hpp NICHT im Bruch, POD nur pmc_available | REGRESSION | — | Z637 | FEHLT | (= seg1-45 Sec.3, spaeter VERTAGT->#83) | Register |
| seg1-67 [ERNST] bump15-Diff beruehrt 0 PMC-Dateien, linux_perf_pmc_smoke.cpp weiter SMOKE_SKIP | REGRESSION | — | Z639 | FEHLT | - | Register |
| seg3-kon13-04 [ERNST] Drei-Ziele-Struktur NICHT vorhanden: experiment_schema.xsd nur binary_path/csv_path/latex_path+1 storage-Slot | REGRESSION | — | Z640 | FEHLT | - | Register |
| seg3-kon16-09 [ERNST] Umbenennung Klasse A NICHT vollzogen: batch_planner.hpp type_phase_rank unveraendert | REGRESSION | — | Z641 | FEHLT | - | Register |
| seg3-kon25-08 [HINWEIS] Emissionsliste ohne Lint-/Release-/Lager-Ablage-Jobs, kein J-1..J-4 | REGRESSION | — | Z642 | FEHLT | - | Register |
| seg3-kon27-02 [HINWEIS] experiment_schema.xsd KEIN export-Element (dev+wt identisch) | REGRESSION | — | Z643 | FEHLT | - | Register |
| seg3-kon34-03 [ERNST] steuer_dock.hpp:234 static_assert(...==6) UNVERAENDERT in ce dev UND wt-ce-bump15 | REGRESSION | — | Z644 | FEHLT | - | Register |
| seg4-12 [ERNST] Code war nie mutiert (bvset_teilmenge.hpp korrekt seit 363f0022), ABER Test-Blindheit besteht | REGRESSION | — | Z645 | FEHLT | test_bvset_teilmenge.cpp:73 | Register |
| D2-05 [HINWEIS] Lock: 6 heuristik-Header exakt in axis_version.lock, CI-Job hart gated | REGRESSION | — | Z649 (6b ABWEICHUNG) | ABWEICHUNG | - | Register |
| F-D1 [ERNST] Owner KON104-01/02-D-1 Wohlgeformtheit/Uebergangs-Deklaration -- Objekt-Abweichung (Beleg gekappt) | REGRESSION | — | Z650 | ABWEICHUNG | - | Register |
| F-D8 [HINWEIS] Praemisse stimmt: axis_optimization_catalog.hpp honest-empty fuer persistence_target (Owner-Entscheid, keine T19-Zeile) | REGRESSION | — | Z651 | ABWEICHUNG | - | Register |
| F-K2 [ERNST] Lizenz-Unstimmigkeit: NOTICE 'MIT' vs LICENSE_AUDIT_EXT.md 'KEINE LICENSE' (A03-michael-lockfree), identisch in beiden Baeumen | REGRESSION | — | Z652 | ABWEICHUNG | - | Register |
| F-M1 [ERNST] 20 Fragen stimmen (A-1,A-2,B-1,C-1..3,D-1..10,E-1..4), Aussonderung/Zusammenlegung dokumentiert, BU-Ordner vollstaendig | REGRESSION | — | Z653 | ABWEICHUNG | - | Register |
| INF-03 [ERNST] allow_runner_registration_token=True (SOLL laut Owner-Entscheid D-3 17.08. 'Wie empfohlen') | REGRESSION | — | Z654 | ABWEICHUNG | - | Register |
| INF-05 [ERNST] Rotationsliste ohne Nachtrag 'samba-comdare-socks-pw' nach Owner-Entscheid 17.08. | REGRESSION | — | Z655 | ABWEICHUNG | - | Register |
| K-07 [ERNST] Buendel-Zug LAEUFT: wt-ce-bump15 heute 30 Commits 20c111c4..e285d316 (67dafa46=Ancestor, 23er-Kernstand+7 a25-Fixrunden) | REGRESSION | — | Z656 | ABWEICHUNG | - | Register |
| LS2-07 [ERNST] Freigabe belegt Ledger B7a/B7b (CEB-LAGER-REGISTRY-HASH-MAP), Bau: S-17/HY-A/B5 | REGRESSION | — | Z657 | ABWEICHUNG | - | Register |
| LS2-21 [ERNST] Widerlegung bestaetigt: A03-michael-lockfree 4/4 Dateien LGPL-2.1-or-later | REGRESSION | — | Z658 | ABWEICHUNG | - | Register |
| LS2-33 [ERNST] Kette verdrahtet, ABER Durchzug NICHT erfolgt (simd_organ_requirement.hpp nur 9x kRequiredNone) | REGRESSION | — | Z659 | ABWEICHUNG | (= LS2-33 Sec.3, spaeter VERTAGT->#44-Rest) | Register |
| LS2-34 [KRITISCH] S-6a-Kern GEBAUT, ABER Riegel-Echtfall-Protokoll ROT->Bump/Regen->GRUEN FEHLT (Lock-Traeger target_isa_c...) | REGRESSION | — | Z660 | ABWEICHUNG | (= LS2-34 Sec.3) | Register |
| LS2-41 [HINWEIS] pre-secret-scrub-20260802 nirgends, super lokal exakt 3x heads/backup | REGRESSION | — | Z661 | ABWEICHUNG | - | Register |
| LS2-51 [ERNST] 2 von 4 Pflicht-Posten gebaut (c: mess_ausbeute_wache.sh n/a-Erkennung Felder 4/5/6) | REGRESSION | — | Z662 | ABWEICHUNG | - | Register |
| LS2-52 [ERNST] Zeiger OK: ARBEITSWEISE-GESAMT-DOKTRIN.md umgezogen, ##58 GEKLAERT | REGRESSION | — | Z663 | ABWEICHUNG | - | Register |
| LS2-55 [ERNST] Handout liegt: prod1 HEAVY_J 24->16, prod2 unberuehrt, SIGHUP-only | REGRESSION | — | Z664 | ABWEICHUNG | - | Register |
| LS2-60 [HINWEIS] Doktrin-Praxis belegt: 4 CI-Zellen g++15.3.0/clang22.1.8 | REGRESSION | — | Z665 | ABWEICHUNG | - | Register |
| LS2-67 [HINWEIS] wt: GliedCount=10, fingerprint_format=5, PreimageMax=8192 gerechnet nicht geraten | REGRESSION | — | Z666 | ABWEICHUNG | - | Register |
| LS2-68 [ERNST] Mechanismus GEBAUT: OrganMetaMetaAxis CRTP+Concept, Registrierungszeile | REGRESSION | — | Z667 | ABWEICHUNG | - | Register |
| LS2-88 [HINWEIS] GOAL:10-13 KOPF-NACHTRAG vorhanden, Wellenplan §16/§17, Designplan §10 D-1..D-6 | REGRESSION | — | Z668 | ABWEICHUNG | - | Register |
| LSEG8-13 [ERNST] Kern gebaut: ergebnis_mappe FASSUNG3 (Owner 08.08.), compare=1 Sheet/Rekombination, MessEbene enum | REGRESSION | — | Z669 | ABWEICHUNG | - | Register |
| LSEG8-15 [ERNST] Flag GEBAUT: --check-size, planner_mengen_types.hpp Substanz aus builder/measure_storage | REGRESSION | — | Z670 | ABWEICHUNG | - | Register |
| LSEG8-25 [ERNST] scheduling_strategy.hpp weiter 0 Konsumenten unveraendert (auch bump15-WT) | REGRESSION | — | Z671 | ABWEICHUNG | - | Register |
| P-08 [HINWEIS] merge-base xorf/f3v/a11 IN dev 20c111c4; g2 9aa9b9df/1528f6fd EXISTS-NOT-IN-development | REGRESSION | — | Z672 | ABWEICHUNG | (= Z-11/#17-g2-Verwandte) | Register |
| P-10 [HINWEIS] Inventar bestaetigt 21 Ordner (von 18 gewachsen)/53M unter 20260817-folge-bu-kontext11 | REGRESSION | — | Z673 | ABWEICHUNG | - | Register |
| P-12 [ERNST] worktree list: hy-a/vl12/vl3/k2 stehen ALLE (Owner-Auflage Loeschung-erst-nach-Beleg eingehalten) | REGRESSION | — | Z674 | ABWEICHUNG | - | Register |
| PAU-10 [ERNST] Dokumentiertes GO erst 15.08. (Ledger KON73 'Schluss-GO Owner: volles GO und volle Fahrt voraus') | REGRESSION | — | Z675 | ABWEICHUNG | - | Register |
| PAU-13 [ERNST] Koeder-Praxis erfuellt (glpat-26, Ledger 'Koeder biss', rc=1 laenge-26) | REGRESSION | — | Z676 | ABWEICHUNG | - | Register |
| SEG5-02 [ERNST] Visitor GEBAUT: mess_visitor_abi.hpp IMessVisitor+tier_measure_accept (FLAECHE3, KON25-02) | REGRESSION | — | Z678 | ABWEICHUNG | - | Register |
| SEG5-03 [ERNST] SteuerDock<MK> variadisch, Tag+Zensus, requires BefehlErlaubt; ABER :39-41 zusichert NICHT vollstaendigen Steuerkanal | REGRESSION | — | Z679 | ABWEICHUNG | - | Register |
| SEG5-06 [HINWEIS] ISA-Trennung im Glied vorhanden: toolchain_stamp_glied.hpp simd-Feld '(+ext=)' | REGRESSION | — | Z680 | ABWEICHUNG | - | Register |
| SEG5-09 [HINWEIS] Deckel ERFUELLT: hybrid_config_xml.hpp W12-Pflichtangabe max_docks, 0/>32 ungueltig, Deckel 32 inklusiv KON28-03 | REGRESSION | — | Z681 | ABWEICHUNG | - | Register |
| SEG5-10 [HINWEIS] Kern GEBAUT: hybrid/ 10 Dateien+README, Owner-Auflage woertlich im Test | REGRESSION | — | Z682 | ABWEICHUNG | - | Register |
| SEG5-12 [ERNST] Loader weiterhin NUR unter Builder-Stufe (ce+wt identisch), CEB-Pruefdock nutzt ihn, hybrid/ bewusst lose | REGRESSION | — | Z683 | ABWEICHUNG | - | Register |
| SEG5-13 [HINWEIS] Konform gebaut: hybrid_dock_factory Abstract Factory 'einziger Konstruktions-Ort', hybrid_dock_contract 'Kein Loader/dlopen/Proxy/XML-Parser' | REGRESSION | — | Z684 | ABWEICHUNG | - | Register |
| SEG5-15 [ERNST] Geliefert: golden-Profil writeback_methods csv+xlsx (W0b ##25, beide zugleich), Produktionsaufrufer gelandet | REGRESSION | — | Z685 | ABWEICHUNG | - | Register |
| SEG5-18 [HINWEIS] Durchstich BEWIESEN: KON56 'F1-LANDUNG IST DURCH', KON57-01 '##25-BEWEIS KOMPLETT TERMINAL', Tasks#11+#30 completed | REGRESSION | — | Z686 | ABWEICHUNG | - | Register |
| SEG5-24 [ERNST] Bestandslog mess_bestand_key_of/doc_key/maschine ERFUELLT | REGRESSION | — | Z687 | ABWEICHUNG | - | Register |
| SEG5-30 [ERNST] Haelfte1 erfuellt: run_with_drift_gate produktive Aufrufer (Mess-Schleife run_cell_with_drift_gate) | REGRESSION | — | Z688 | ABWEICHUNG | - | Register |
| SEG5-32 [ERNST] Paper-EXPERIMENT-XML je Referenz-Paper=0 am Objekt, nur 33 sota/*.profile.xml + 12 thesis_profiles | REGRESSION | — | Z689 | ABWEICHUNG | - | Register |
| SEG5-36 [ERNST] Zugesagte Korrektur NICHT vollzogen: AF_CORPUS_ROOT weiter 'measurement', Script erklaert es selbst als OFFEN | REGRESSION | — | Z690 | ABWEICHUNG | - | Register |
| SEG5-37 [ERNST] Teil1 erfuellt (T-1, 09.08.): SystemAchsenEntscheidung faellt einmal, reist mit (Zwilling von compile_for_perm) | REGRESSION | — | Z691 | ABWEICHUNG | - | Register |
| SEG5-47 [ERNST] measurement_axis_registry.xml (WT wie CE) nur load_framework als measurement_meta_meta, grep hybrid=0 | REGRESSION | — | Z692 | ABWEICHUNG | - | Register |
| V15-04 [ERNST] 0 golden-Re-Anker-Commits am wt-HEAD e285d316, kNewGolden131072Crc64 byte-identisch zur Basis 20c111c4 | REGRESSION | — | Z693 | ABWEICHUNG | - | Register |
| V15-07 [ERNST] set_/sequence_/view_/adapter_module_abi_v1.hpp je 0 VERSION_STAMP-Treffer am wt-HEAD | REGRESSION | — | Z694 | ABWEICHUNG | - | Register |
| V15-08 [ERNST] planner_version.hpp:80-84 unveraendert, fingerprint_sha() leer; Owner-Entscheid seit 17.08 (KON101-01) | REGRESSION | — | Z695 | ABWEICHUNG | (= seg1-40-Verwandte) | Register |
| V15-10 [ERNST] all_axes_golden.profile.xml <simd> nur no_extension+avx2, avx512 FEHLT, stale Filter-Prosa unveraendert | REGRESSION | — | Z696 | ABWEICHUNG | K1-Stelle 1, identisch in ce dev | Register |
| V15-15 [ERNST] K2 VOLLZOGEN (ce-Naht-Fixture entflochten, in development gemergt KON109-02); K5+K6 VERBUCHT | REGRESSION | — | Z697 | ABWEICHUNG | - | Register |
| Z-03 [ERNST] Kern des Buendels DA: f3559e7a Preimage Format4->5, 5c0c3a5e POD Layout6->7, komposit_line | REGRESSION | — | Z698 | ABWEICHUNG | - | Register |
| Z-04 [ERNST] simd_build_gate.hpp static_assert(...organ_required_union_size()==0, C-3a-TRIPWIRE) NOCH VORHANDEN, NICHT ausgeloest | REGRESSION | — | Z699 | ABWEICHUNG | (= seg1-48-Verwandte) | Register |
| Z-11 [KRITISCH] #17 GEBAUT aber UNGELANDET: 1528f6fd nur auf Branch bau/g2-semantik, NICHT Ancestor von development | REGRESSION | — | Z700 | ABWEICHUNG | (= W1-V1, spaeter BEHOBEN/GELANDET 9.0) | Register |
| Z-26 [ERNST] Co-Authored-By-Pruefanker=1 (SOLL 0) ueber HEAD c169fd22: Commit 09cc728 (18.06.) traegt Claude-Opus-Trailer | REGRESSION | — | Z701 | ABWEICHUNG | (= E12-Verwandte) | Register |
| Z-31 [ERNST] Erfuellt: node5 tot bestaetigt, Sidekiq-HPA behalten (Pipeline 15846), id56 online | REGRESSION | — | Z702 | ABWEICHUNG | - | Register |
| Z-38 [ERNST] BU-Teil erfuellt: 20260816-folge-bu-kontext8 mit 3 journal.jsonl + staffelungs_karte_49.json + kon64_sammlung.md | REGRESSION | — | Z703 | ABWEICHUNG | - | Register |
| seg1-26 [ERNST] Wellenplan 20.2/20.9: clang-Warnungs-Review, --debug x plan Exit-6-Zweige, Windows-_pclose statischer Blick, N6-Bytevergleich dokumentiert | REGRESSION | — | Z704 | ABWEICHUNG | - | Register |
| seg1-37 [KRITISCH] topics/axis.hpp im Bruch UNBERUEHRT, keine CT-Zuordnung | REGRESSION | — | Z705 | ABWEICHUNG | (= seg1-37 Sec.3 / K1=F1, Status-Fortschreibung) | Register |
| seg1-44 [ERNST] Nur S-6a-Makro-Teil im Bruch (d866bb3d '4 Anker'), K1-avx512 0 Filter-Edits | REGRESSION | — | Z706 | ABWEICHUNG | (= seg1-44 Sec.3) | Register |
| seg1-46 [HINWEIS] bestandslog_document.hpp kSyntaxVersion=4 (kein 5), Gate unveraendert, last_update_utc=0 Treffer | REGRESSION | — | Z707 | ABWEICHUNG | - | Register |
| seg1-49 [ERNST] (a) NP-39 bestaetigt gestrichen (deckungsgleich), (b) +tel=silent NICHT verdrahtet | REGRESSION | — | Z708 | ABWEICHUNG | - | Register |
| seg1-52 [ERNST] Co-Authored-By ueber ALLE Remote-Refs beider Remotes inkl. origin | REGRESSION | — | Z709 | ABWEICHUNG | (= E12/Z-26-Verwandte) | Register |
| seg1-66 [ERNST] Erfuellt: f45e995b IS Ancestor, TSAN-Grenze-Block exakt+Terminierungs-Praezisierung | REGRESSION | — | Z710 | ABWEICHUNG | - | Register |
| seg1-71 [ERNST] W18-Austragung NICHT vollzogen: Ledger:22953/22739 §59-MERGE-STEMPEL K7a weiter '(OFFEN, kritisch)' | REGRESSION | — | Z711 | ABWEICHUNG | - | Register |
| seg1-81 [KRITISCH] Rahmen ERFUELLT: BUENDEL-BAUPLAN-15.md 23 Schritte VL-1..6+B-1..11+N-1..6, Byte-/Hex-/CRC-Anker-Regel | REGRESSION | — | Z712 | ABWEICHUNG | - | Register |
| seg1-84 [ERNST] Regel bauleitend im Ledger (3 Bedingungen SHA512+Kern-Identitaets-Klasse+Meta-Meta), ABER NICHT eingezogen | REGRESSION | — | Z713 | ABWEICHUNG | - | Register |
| seg3-kon19-06 [HINWEIS] Die 3 (success-Wiederholung) GEBAUT je Wiederholung eigene Zeile; die 5 = drift_gate_max_reruns | REGRESSION | — | Z714 | ABWEICHUNG | - | Register |
| seg3-kon21-03 [ERNST] Im Worktree: S-6a VOLL (f3559e7a/5c0c3a5e/d866bb3d, Preimage+POD+Konsumenten) | REGRESSION | — | Z715 | ABWEICHUNG | - | Register |
| seg3-kon22-01b [HINWEIS] (a) MinIO-Neueinsetzung VOLLZOGEN 14.08. (Cluster-Commit b20492a) | REGRESSION | — | Z716 | ABWEICHUNG | - | Register |
| seg3-kon22-01c [HINWEIS] 'build:gcc'=0 Treffer (gcc-Bau lebt in test:unit*), ce build:clang UNBEDINGT (08.08. 'UNBEDINGT GESCHALTET') | REGRESSION | — | Z717 | ABWEICHUNG | - | Register |
| seg3-kon27-03 [ERNST] Erfuellt in 20260811-workflow-rohdaten-stempel-ci-konsistenz/ (kon-quellen/+owner-extrakte/+20+ Dateien) | REGRESSION | — | Z718 | ABWEICHUNG | - | Register |
| seg3-kon30-04 [HINWEIS] Marker gesetzt WF3-Synthese+Gesamturteil, ABER Ledger selbst 0 Treffer 'UEBERHOLT 12.08 KON30-04' | REGRESSION | — | Z720 | ABWEICHUNG | - | Register |
| seg3-kon32-02 [ERNST] keeper-root-rotation-Eintrag vorhanden Vault Z.683; blinde mapfile-Probe: alle 10+2 Kandidaten HTTP-geprueft | REGRESSION | — | Z721 | ABWEICHUNG | - | Register |
| seg3-kon34-04 [HINWEIS] B2 seit 15.08 GEBAUT+GELANDET: mess_gates_glied.hpp 'ERLEDIGT DURCH B2', Gate-Grammatik 4 Gates->16 Belegungen | REGRESSION | — | Z722 | ABWEICHUNG | - | Register |
| seg3-kon8-03 [ERNST] Doktrin-Haelfte am Objekt: ceb_version_stamp.hpp W10-C3-Kommentar-Wache, CEB-Selbst-Stempel zellwertfrei | REGRESSION | — | Z723 | ABWEICHUNG | - | Register |
| seg3-kon8-11 [HINWEIS] 3 von 4 SHA-Zuordnungen stimmen; 9f8e2be8 ist aber style(e18-snap) statt erwarteter Zuordnung | REGRESSION | — | Z724 | ABWEICHUNG | (= SHA-Zuordnungs-Hinweis Sec.3) | Register |
| seg4-15 [ERNST] ci/tests/*.sh=14 (SOLL-Stand 11.08.=13), 8656 Zeilen total (war 7967), Wachstum 5->12->13->14 | REGRESSION | — | Z725 | ABWEICHUNG | (= seg4-15 Sec.3) | Register |
| seg4-30 [ERNST] GEBAUT: P1 Sidecar-Klartext Zeile2=Glied[6] (#59 v2), ABER additiv statt Format-Bump; Invalidierung kam via bump15-Preimage | REGRESSION | — | Z726 | ABWEICHUNG | - | Register |
| seg4-33 [ERNST] Bestand unveraendert gemessen: file(GLOB)=34 Zeilen/22 Dateien, konsistent zu KON6-07 '32' | REGRESSION | — | Z727 | ABWEICHUNG | - | Register |
| seg4-58 [ERNST] Frischer super-Vollbau (super@5ca82678,ce@20c111c4): 866 Tests, FAILED-Liste=40=37 NotRun+3 Failed | REGRESSION | — | Z728 | ABWEICHUNG | test_limits_entkopplung_vorstufe u.a. | Register |
| seg4-59 [ERNST] Thesis-Repo Historie neu geschrieben (branch --contains 19e15920=LEER, Befund 98/366 ueberholt), 376 Commits origin/development, Co-Authored-By-Trailer=1 | REGRESSION | — | Z729 | ABWEICHUNG | - | Register |
| seg4-62 [HINWEIS] 4 von 5 Teilposten vollzogen (Wache in ce, nicht super): PA-1 GEBAUT ci_test_registrierungs_wache.sh ERREICHBARKEITS-PROBE | REGRESSION | — | Z730 | ABWEICHUNG | - | Register |
| seg4-70 [HINWEIS] Kern bestaetigt: COMDARE_CE_ENABLE_ORIGINAL_CODE_VALIDATION Default-ON (Anker 550->589), wh.c in Validation-Pfaden | REGRESSION | — | Z731 | ABWEICHUNG | - | Register |
| seg4-74 [ERNST] Genannter Anker geheilt (KON37-01, Paragraphen-Marke), ABER neue Kommentare verletzen Regel in ce+wt hybrid/heuristik_adapt... | REGRESSION | — | Z732 | ABWEICHUNG | - | Register |
| seg6-08 [ERNST] Alle 9 TU-Dateien existieren in wt (test_tp1_planer_filter_iterator u.a.) | REGRESSION | — | Z733 | ABWEICHUNG | - | Register |
| seg6-39 [ERNST] hybrid/ = 11 Dateien (kein README-Stub mehr); wt zusaetzlich hybrid_binary_proxy.hpp+hybrid_module_abi_v1.hpp | REGRESSION | — | Z734 | ABWEICHUNG | - | Register |
| seg7-17 [HINWEIS] 4 Werte+Registry: run_methodology_registry.hpp enum{Debug,Measure,Release,Compare}, Zusagen-Anker gedriftet | REGRESSION | — | Z735 | ABWEICHUNG | - | Register |
| seg7-45 [ERNST] axis_centric_namespaces.hpp unveraendert 'ALLE 17 Achsen' (Kopf beansprucht), kanonisch 18 Organ-Achsen (Phantom-Nenner) | REGRESSION | — | Z736 | ABWEICHUNG | Referenz: reference_organ_achsen_sind_achtzehn_nicht_neunzehn | Register |
| seg7-50 [HINWEIS] DOCKER_OS-Matrix=18 unique=6 Familien x3 (ubuntu/debian/fedora/alpine/opensuse/rocky je 3 Versionen) | REGRESSION | — | Z737 | ABWEICHUNG | - | Register |
| Owner-Auftrag Sec.12: 10 Transkript-Fenster K5-K13 (16.08.12:28-18.08.21:24, Z59214-69705) + 3 Journal-Gruppen VOLL nachvollziehen; Audit-Verdikte NICHT erneut melden | OWNER-ENTSCHEID | — | Z739-747 (Sec.12) | GEGEBEN | K14-Synthese | Register |
| 12.0 Leser 10/10 Fenster K5-K13, Summe 10501 gescannte Zeilen, Bereich LUECKENLOS | UNKLAR | — | Z751-754 | VOLLZAEHLIGKEITS-GATE BESTANDEN | - | Register |
| Journal-Gruppen 3/3: 38 Workflow-Journale 16.-19.08 kartiert (35 FERTIG, 3 live, 0 abgebrochen-ungeerntet, 0 journallos); Backups-Sweep 22+2 Ordner; Ernte-/Output-Gegenproben | AUFGABE | — | Z755-758 | GEKLAERT | - | Register |
| GEGENZAEHLUNG REGRESSIONEN: 103 Roh-Eintraege -> 80 NEUE nach Dedup (11 im_register, 1 zu 12.1 umklassiert, 11 in 8 Merge-Gruppen M1-M8); kein Roh-Eintrag verworfen | UNKLAR | — | Z759-765 | GEZAEHLT | - | Register |
| GEGENZAEHLUNG STRAENGE: 40 Roh-Kandidaten -> 33 nach Dedup = 16 GEERNTET/17 REKONSTRUIERBAR/0 VERLOREN (Tafel 12.3); Register-5c-Bilanz bestaetigt | UNKLAR | — | Z766-768 | BESTAETIGT | Tafel 12.3 | Register |
| 12.1 [T-10 GESCHLOSSEN zur Ernte-Haelfte]: V-02R-Explore-Ernte EXISTIERT (wf_969b3bba 17.08., Ledger KON103-03), NEU-FAHREN ENTFAELLT; Rest: (a) BAU-Haelfte SHA256-Verkettung nicht gebaut, (b) Hash-Laengen-Spannung SHA-256(Owner) vs SHA-512/128(Objekt) | REGRESSION | — | Z772-782 | TEIL-BEHOBEN (Ernte gefunden), Rest OFFEN | Fix-Strecke2+#93-C; = Fortschreibung von T-10 oben | Register |
| 12.1 [5c-KORREKTUR] w78hb9hii war KEIN verwaister 0-Byte-Doppelstart, sondern AUDIT-Run (Tool-Error Z68280 belegt) | REGRESSION | — | Z783-785 | KORRIGIERT (kosmetisch) | = Fortschreibung 5c-RESUME-BILANZ | Register |
| 12.1 [6b-TRUNKIERUNG, ERNST] alle 111 Verdikt-Zeilen mechanisch bei ~250 Zeichen abgeschnitten, UNDEKLARIERT; bei seg1-81 fehlt Schritt-zu-Commit-Deckungs-Matrix | REGRESSION | — | Z786-792 | OFFEN | Sicherung+Reparatur X-16/X-17 | Register |
| 12.1 [5c-FORTSCHREIBUNG] journal-Sweep 19.08.: 0 abgebrochene+ungeerntete Runs, kein wf-Verzeichnis ohne journal.jsonl, 3 LIVE-Laeufe bestaetigt per Log-Wachstum | AUFGABE | — | Z797-799 | BESTAETIGT | - | Register |
| 12.2a [K7b-3] prt-art build:registry-roundtrip NICHT-DETERMINISTISCH (Runner-Slot-Checkout ungepinnt, Schein-Gruen/Schein-Rot) | REGRESSION | — | Z805-808 (12.2a) | OFFEN | W2-Task (SHA-Pin) | Register |
| 12.2a [K7a-3] = W1-V2-Anker-Diskrepanz (s. 12.1), OFFEN bis #93-D-Abgleich | REGRESSION | — | Z809 | OFFEN | #93 Gruppe D | Register |
| 12.2a [K10-4] vl3-Restposten ohne Bau: ROT-3 '--debug x plan dump\|ci\|cmake' (Exit6) + Windows-_pclose-Posten ohne WEXITSTATUS | REGRESSION | — | Z810-812 | OFFEN | #93 Gruppe A | Register |
| 12.2a [K10-12] vl3-Verlustliste F2-Rest: -Wstringop-overflow-VORBESTAND (A-13) ohne Verbleibs-Quittung | REGRESSION | — | Z813-815 | OFFEN | #93 Gruppe A / Komplex-Fix-Flaeche | Register |
| 12.2a [M-6] clang-Haelfte des WARNUNGS-Reviews (vl3) nie gefahren (Hausregel 2x gcc->clang) | REGRESSION | — | Z816-818 | OFFEN | W2-2 vertagt (S-12-Dual-CI #3) | Register |
| 12.2a [M-5] Unbelegte Determinismus-Zusicherungen im GELANDETEN Code: main.cpp:717 abgeschwaecht, :515 NIE gemessen | REGRESSION | — | Z819-822 | OFFEN | W2-1 (Bytevergleich-Messung+--debug-Matrix) | Register |
| 12.2a [K11-5-Rest] tools-3-Format-Altbestand ohne Traeger (axis_registry_gen,gen_golden_fullpilot,p27_bundle_finder clang-format-rot ausserhalb CI-Pruefmenge) | REGRESSION | — | Z823-825 | OFFEN | W2 | Register |
| 12.2a [M-7] clang-format-22-Umgebungs-Drift lokal-vs-CI UNGEKLAERT (lokal 22.1.8 rot, CI gruen, par.21.6 'CI entscheidet') | REGRESSION | — | Z826-829 | OFFEN (Workaround committet, Werkzeug-Paritaet offen) | W2 | Register |
| 12.2a [K12-2] Methodik-Override emissionsseitig UNBEOBACHTBAR: alle 4 work_modes Release, measurement_on/single_thread NULL Leser im Emitter | REGRESSION | — | Z830-834 | OFFEN | S-8/W2-Entscheid (#22, s8_erbstuecke) | Register |
| 12.2a [K7b-5] KON74-04 ohne Superseded-Vermerk auf KON80-01/V3 | REGRESSION | — | Z835-836 | OFFEN | Docs-Zug | Register |
| 12.2a [JB-4] KON99-03-Inventar-Drift: 11 deklariert, Ordner traegt 14 (3 VL-6-Ergebnis-Karten unsichtbar) | REGRESSION | — | Z837-838 | OFFEN | Docs-Zug, Folge X-15 | Register |
| 12.2a [JB-2] BU-Spiegel-Luecke kontext11: 8 Dateien (W1-Beweis-Logs) fehlen KOMPLETT im Repo-Spiegel; f45e995b-tsan-Patch nur lokal | REGRESSION | — | Z839-842 | OFFEN | naechster Folge-BU-Zug | Register |
| 12.2a [JB-3] hy-a-Folge-Lens-Funde GEFIXT+GELANDET aber UNVERBUCHT (wf_750d2441 TRAEGT_MIT_FIXES, Fund1+Fund2) | REGRESSION | — | Z843-847 | OFFEN (Meldungs-Luecke) | Quittungs-Nachtrag, loest halbe X-4 | Register |
| 12.2a [K9-3] tail-Fallen-Eintrag ZUGESAGT (Lead 17.08. 11:18), NIE GESCHRIEBEN (0 Treffer 'tail' im Fallen-Register) | REGRESSION | — | Z848-851 | OFFEN | Memory-Zug (mit T-5/T-6) | Register |
| 12.2b [M-1] super 15941+prt-art 15944 ROT, F5-Rename-Ripple (axes/->organ_axes/ ohne prt-art-MASTER-Nachzug) | REGRESSION | — | Z855-860 (12.2b) | BEHOBEN (7ed4a7e+d11781f+c926efdc, 15945/15946 SUCCESS) | LEHRE unverankert: Rename braucht Master-Nachzug (12.2c) | Register |
| 12.2b [M-2] super-Fixture-Subset-Wache STILL-SKIP nach K2-Rename (CMakeLists:348 zeigte ins Leere) | REGRESSION | — | Z861-867 | BEHOBEN (f4b01ab3, super 15976 SUCCESS, KON115) | B-1-HAERTUNG Verdrahtungsfehler=FATAL | Register |
| 12.2b [M-3] Floor-Anker-Fehlkalibrierungs-Komplex 16./17.08. (fbe898be FALSCHE Doktrin, 15936 ROT) | REGRESSION | — | Z868-872 | BEHOBEN (Rueckkalibrierung 04ac26fa, CI 15937 SUCCESS) | KON98/#78 | Register |
| 12.2b [M-4] test_rcu_concurrency-Komplex (Churn-Test prueft Gegenstand nie) | REGRESSION | — | Z873-877 | BEHOBEN (Umbau Reader-an-Generationen, #80/f45e995b) | - | Register |
| 12.2b [M-8] Audit-WF-Orchestrator-Doppelbug (.then-Crash k.zusagen.map, Fix haette 4 Segmente STILL gefiltert) | REGRESSION | — | Z878-882 | BEHOBEN (Vollzaehligkeits-Gate 11/11, Endlauf 65/65 688/688) | Quelle NIE-KUERZEN-Memory 18.08. | Register |
| 12.2b [K5-1] Falsch-ROTER ctest auf ungebautem Baum (487/495)+LastTest.log Falsch-Beleg (16.08.) | REGRESSION | — | Z883-885 | BEHOBEN (Re-Bau+CI-Form 494/494) | KLASSEN-VORLAEUFER von E3 | Register |
| 12.2b [K5-2] prt_art-Piloten-Compile-Bruch (stale Generat referenzierte fehlende Fixture) | REGRESSION | — | Z886-889 | BEHOBEN (geraeumt, Re-Configure) | scope-treu an #65 | Register |
| 12.2b [K5-3] golden-Nachstufe 3 MUSS-Funde (wf_a0e17d5d, F1 4 Ueberlaengen, F2 131, Push 5fa37f36->15895 FAILED) | REGRESSION | — | Z890-894 | BEHOBEN (c0b28670) | Branch-Rest s.12.3/X-1 | Register |
| 12.2b [K5-4] Dual-Review golden 3 Stellen (>120,consteval-switch ohne fail-closed,Selbsttest-Luecke) | REGRESSION | — | Z895-897 | BEHOBEN (d44008c5, 17/18 rot->18/18, 90ee6809 gelandet) | - | Register |
| 12.2b [K5-6] Eigener Buchungsfehler KON93-02 (6GB-Arena ABLOESUNG statt SCHICHTUNG) | REGRESSION | — | Z898-900 | BEHOBEN (KON94 fe6439ea, E11->S-13-Buendel #18) | - | Register |
| 12.2b [K5-8] TaskCreate in Subagent-Umgebung nicht verfuegbar | REGRESSION | — | Z901-902 | BEHOBEN (Haupt-Agent ToolSearch, Task#77 direkt) | Werkzeug-Falle 12.2c | Register |
| 12.2b [K6-3] Workflow-Ergebnis-Verluste (Owner-geruegt 'tendierst zu abschneiden') | REGRESSION | — | Z903-906 | BEHOBEN (journal_extrakt.py, 21/21+17 Dateien, super 4901f808) | verwandt 10b-Template-Literal-Bug | Register |
| 12.2b [K6-4] Rohdaten-Sicherungs-Luecke 7GB-Raeumung (Floor-Rohdaten nur Job-tmp) | REGRESSION | — | Z907-909 | BEHOBEN (Nachsicherung docs/sessions/backups) | 2. Vorfall T-8-/B.3-Klasse | Register |
| 12.2b [K6-6] Objekt-Luecken WritebackMethod/XSD/Sink (Validierung nur --validate-Pfad, XSD ohne Enum-Wache, publish=0 Treffer, E-18 ce-seitig unimplementiert) | REGRESSION | — | Z910-914 | OFFEN (als Design-Input in S-13 konsumiert, beim Bau verdrahten oder fail-loud) | S-13 (#18/#57), vgl. X-15 | Register |
| 12.2b [K6-7] Plan-/Karten-Drift-Sammelbefund (Wellenplan-hybrid stale, A43 ohne Xlsx, measurement_sink dreifach gegatet, LagerBaum-Writer ohne Konsument) | REGRESSION | — | Z915-918 | ENTLASTET (von Strang-Designs konsumiert, =9x-UEBERHOLT-Klasse) | #57 | Register |
| 12.2b [K6-5] CI-Poller-Skript-Defekt (eingebetteter python3-Dump, Syntaxfehler, exit1) | REGRESSION | — | Z919-920 | BEHOBEN (Dump in ci_jobs_dump.py ausgelagert) | Poller-Werkzeug-Serie 12.2c | Register |
| 12.2b [K7a-2] Wellenplan-Plan-Regression par.19.1 (VS-A..F STOPP-Gates offen = FALSCH, alle 6 entschieden) | REGRESSION | — | Z921-923 | BEHOBEN (Kopf harmonisiert, Fortschreibungs-Marker Wellenplan Z.2394) | - | Register |
| 12.2b [K7a-4] prt-art-Submodul detached HEAD + development stale (32e8ffa8 hinter 3077e102) | REGRESSION | — | Z924-925 | BEHOBEN (checkout+ff-only) | Register 6/E12 fuehrte nur Thesis-Klone | Register |
| 12.2b [K7a-5] Poller mit sh statt bash gestartet (mapfile/Bad substitution, exit2) | REGRESSION | — | Z926-927 | BEHOBEN (bash-Neustart) | trivial | Register |
| 12.2b [K7b-4] curl '--header @file' liest keine Datei | REGRESSION | — | Z928-929 | BEHOBEN (curl -K Muster, mapfile blind) | Werkzeug-Rezept 12.2c | Register |
| 12.2b [K8-1] s13-Design-Lens 13 Funde (4 MUSS: Arena-Ueberlauf,xlsx-Zeilenlimit,result.csv-Resume-Blindheit) | REGRESSION | — | Z930-932 | BEHOBEN (dfb8ba09+e9c74abf) | s13-Zusagen im 688-Audit | Register |
| 12.2b [K8-2] HY-A-Dual-Lens F-1..F-11 (Zweig waere CI-rot gewesen) | REGRESSION | — | Z933-936 | BEHOBEN (c979d1c0+374c1d12, F-11 gcc499/clang498) | HY-A-Zusagen im Audit | Register |
| 12.2b [K8-3] F-12 Eigenfund: latenter CI-VERDECKTER Bau-Bruch (perms-DLL-Ziele vs 'make inventar') | REGRESSION | — | Z937-939 | BEHOBEN (374c1d12) | - | Register |
| 12.2b [K8-5] K2-Drift: D1 Plan falsch, D3 Gate G7 '~100%' real 63%, Schritt3/R4 gegenstandslos | REGRESSION | — | Z940-942 | BEHOBEN (44a909c1, #81) | - | Register |
| 12.2b [K8-7]+[K9-12] Arbeitsweise-Verstoss-Serie (2x Owner-Ruege 17.08.: 13 V-Fragen ohne Explore, KON106-08 38 Fragen ohne Vorlauf) | REGRESSION | — | Z943-948 | BEHOBEN (KON100-Zug, 12-Wochen-Memory-Schaerfung) | Klasse=Audit 'Owner-Wort-Treue TEILWEISE'/H6 | Register |
| 12.2b [K8-9] Platte 2x kritisch (95%/13G, 97%/8G) waehrend Kombibauten | REGRESSION | — | Z949-950 | BEHOBEN (Raeumung 8G->14G, git-ls-files=0-Beleg) | - | Register |
| 12.2b [K9-2] Lead-Wiederanlauf-Skript doppelt defekt (Bau-Verzeichnis geraten + CTEST_RC=0 Falsch-Null) | REGRESSION | — | Z951-953 | BEHOBEN (sauber neu gefahren) | 2. E3-Klassen-Vorfall | Register |
| 12.2b [K9-5] VL-2-Feldzahl-Wache (P0960) BLIND fuer Zeiger-Appends (17. Feld char const*) | REGRESSION | — | Z954-956 | BEHOBEN (typ-agnostische Zaehl-Sonde cd011e60) | Klassen-Naehe C-F2/Fix13/14 | Register |
| 12.2b [K9-7] k2-Lens ERNST: 6 Zeilenbelege XML-Kopfblock +1 daneben, Kommentar-Unwahrheit Byte-Gleichheit | REGRESSION | — | Z957-960 | BEHOBEN (Lead uebernahm k2-Worktree, gelandet 6a8cdc65) | - | Register |
| 12.2b [K9-8] vl3-Lens ERNST: K9b-Koeder biss nicht (Nadel '8 ' schon von --debug-Hilfeblock erfuellt) | REGRESSION | — | Z961-963 | BEHOBEN (7bf66ddd->c8d7295e) | T-6-Koeder-Reichweiten-Klasse | Register |
| 12.2b [K9-9] Floor-Erwartungs-Rechenfehler des Leads (496/492/490 widerspruechlich) | REGRESSION | — | Z964-966 | BEHOBEN (gestoppt 500/496/494 von hy-a-bau) | Auflage: Schalter-Zustand ins Lande-Protokoll | Register |
| 12.2b [K9-10] Doppellauf-Kollision build-vl12 (Lead-Wiederanlauf parallel zu vl12) | REGRESSION | — | Z967-968 | BEHOBEN (aufgeklaert) | Ein-Schreiber-Klasse | Register |
| 12.2b [K9-13] Auftrags-Karten-Fehler des Leads (3 Teilfehler: '47 in 12' real 42 in 11, 'drei' real VIER Initialisierer, Timestamp-Schein-Differenz) | REGRESSION | — | Z969-972 | BEHOBEN (korrigiert von vl12-bau) | Falle 12.2c | Register |
| 12.2b [K10-1] HY-A2 KOMPLETT + HY-A3-ACHSE in W1 NIE BEGONNEN (Abnahmeformel :952 unerfuellt) | REGRESSION | — | Z973-977 | BEHOBEN (KON113, Bau im Bruch nachgeholt) | Ursachen-Klasse: decl.hpp-SPERRE als Erledigung behandelt | Register |
| 12.2b [K10-5] N7-Luecke REAL: add_dependencies fehlte (rc=127 comdare-experiment-planner not found) | REGRESSION | — | Z978-980 | BEHOBEN (W1-Landung, 2 Kanten) | comdare_tests-PFLICHT-Falle 12.2c | Register |
| 12.2b [K10-6] TSan-Kopfzeilen-Uebertreibung test_rcu_concurrency ('race-frei unter TSan' falsch, atomic_thread_fence unmodellierbar) | REGRESSION | — | Z981-984 | BEHOBEN (f45e995b TSAN-GRENZE-Block) | E11=anderes Bein, TSan-AUSBAU bleibt offen | Register |
| 12.2b [K10-7] LEAD-FEHLBUCHUNG (Owner-Ruege 20:34): limit-tote Teammates als erledigt gebucht | REGRESSION | — | Z985-987 | BEHOBEN (Doppel-Audit->KON113) | H6 generisch, Vorfall war unregistriert | Register |
| 12.2b [K10-8] DOPPEL-INKARNATION des Lande-Agenten nach Workflow-Stop/Resume (alte mergte 4 Commits weiter) | REGRESSION | — | Z988-990 | BEHOBEN (neue erkannte+deduplizierte selbst) | NEUE Ausloese-Mechanik->12.2c | Register |
| 12.2b [K10-9] Koordinations-Widerspruch (vl3-build-Baeume Lead vs Lande-Agent) | REGRESSION | — | Z991-993 | ENTLASTET (transparent aufgeloest, Verifikation via Kombibau) | - | Register |
| 12.2b [K10-10] Workflow-Synthese-Tod wf_e06c7f73 (synthese:null) + wqxyzoh3q-Output 88KB gekappt | REGRESSION | — | Z994-996 | BEHOBEN (rekonstruiert aus journal.jsonl, Resume w8tz2815j) | Klasse 'journal=Wahrheit' | Register |
| 12.2b [K10-11] KON107-Poller-FALSCH-NULL (mapfile-Header leere Statuszeilen, beide Hosts 404, real SUCCESS) | REGRESSION | — | Z997-999 | BEHOBEN (glhdr.curlrc+curl -sk) | 12.2c | Register |
| 12.2b [K10-14] Cluster-Repo-Verlustbestand: 20 helm-1014-Schrittskripte+ci-templates-Gitlink UNCOMMITTED (#73 landete nur Handout), Erst-Push ans falsche Remote | REGRESSION | — | Z1004-1005 | BEHOBEN (ee2f933) | #73-Nachzug | Register |
| 12.2b [K11-3] Lead-Fehlbuchung+Message-Verlust: Audit-Teammate-Bericht als vollstaendig verbucht quittiert, Erstversand kam nie an (Owner-Ruege) | REGRESSION | — | Z1006-1008 | BEHOBEN (Nachreichung, dreifach verbucht) | Buchung-ohne-Beleg-Klasse | Register |
| 12.2b [K11-4] Falsches Gruen im CI-Fix-Bau: CTEST_RC=0 bei 496/500, 4 AVX-512-Tests nie gebaut (EXCLUDE_FROM_ALL ohne comdare_-Praefix) | REGRESSION | — | Z1009-1012 | BEHOBEN (korrekte J-1-Treppe -> 500/500) | zweite EXCLUDE_FROM_ALL-Instanz, vgl. par.10/503-vs-502 | Register |
| 12.2b [K11-5] lint:format-Fix Runde 1 unvollstaendig (CI prueft 1906 Dateien, Fix nur 3 aus Log-Tail -> 15973 erneut rot) | REGRESSION | — | Z1013-1014 | BEHOBEN (965b121a, 15974 SUCCESS) | Rest s. 12.2a tools-3 | Register |
| 12.2b [K11-9] Inverse Fehlbuchungen: N3 offen-gebucht ohne Gegenstand, #80 in_progress obwohl gelandet, N1/N5/N6 beim toten Steward nirgends persistiert | REGRESSION | — | Z1015-1017 | BEHOBEN (S-4-Bereinigung im Fenster) | Rest N1/N5/N6-Messung s. X-9 | Register |
| 12.2b [K11-11] Beinahe-Verfaelschung des Floor-Historienblocks durch blinden Replace | REGRESSION | — | Z1018-1019 | BEHOBEN (am Diff selbst gefangen, praezise nachgezogen) | Werkzeug-Disziplin-Hinweis | Register |
| 12.2b [K11-12] Zwei CI-Poller STUMM gestorben (bxiwgzwli Quoting; b8kgvg39c ohne Ergebniszeile) | REGRESSION | — | Z1020-1022 | BEHOBEN (je per Direkt-API ersetzt, 15976/15979 SUCCESS) | Poller-Skript-Klasse selbst OFFEN -> 12.2c | Register |
| 12.2b [K12-3] Koeder-(iii)-Nebenfund: test_m_w12:772-775 prueft Format 5 korrekt, Assert-Meldungstext erklaerte veraltet "3->4"/9-Glieder | REGRESSION | — | Z1023-1025 | BEHOBEN (98f05b04) | Lehre "Koeder-Meldungen LESEN" -> 12.2c | Register |
| 12.2b [K12-4] P9-Neufunde: anatomy_fingerprint.hpp:10-11 Kopf beschrieb eigene Glied-Zahl falsch (seit R-3) + test_m_w12:727 | REGRESSION | — | Z1026-1028 | BEHOBEN (cd15dd05) | Abgrenzung zu 5b/Fix18 (andere stale Saetze) | Register |
| 12.2b [K12-6] Kumulative Diff-Hygiene fand 4 >120-Zeilen aus Bruch-Commits (alle push-lokalen Vorgaenger-Gates passiert) | REGRESSION | — | Z1029-1031 | BEHOBEN (5f269555+Fixup) | bestaetigt KON116-Lehre "kumulative Gates ans Wellen-Ende" | Register |
| 12.2b [K12-7] Lead-Fehldiagnose 500-vs-501: Ursache nicht gesetzter Configure-Schalter -DCOMDARE_CE_PRUEFLINGE (CI-Paritaets-Luecke der lokalen J-1-Treppe) | REGRESSION | — | Z1032-1035 | ENTLASTET (von bump15-a am Objekt widerlegt, Rezept ergaenzt) | J-1-Memory-Nachzug -> 12.2c | Register |
| 12.2b [K12-10] Beleg-Sicherungs-Luecke: 3 bump15-b-Patches (Vorgaenger-Setter, Kollisionsstand, Decorator) weiter NUR im rotierenden Job-tmp | REGRESSION | — | Z1036-1038 | OFFEN (optionaler B.3-Nachzug mit X-16-BU-Zug) | - | Register |
| 12.2b [K13-2] GitLab-Push-Auth-Transient (HTTP Basic denied, Retry rc=0) | REGRESSION | — | Z1039-1040 | ENTLASTET (Infra-Hinweis, K11-sauber nachgemessen) | - | Register |
| 12.2b [K13-3] Mini-Verify-Agent-Tod wf_b943361e (API-Abriss ~19:06); Verify-Tod fehlte in 10b | REGRESSION | — | Z1041-1042 | BEHOBEN (Cache-Resume wrlfi8rec NULL_NEUE_FUNDE 19:15) | - | Register |
| 12.2b [K13-4] Orchestrator-Prompt-Trunkierung wgmt22mio: Schreiber sah nur 23/25 Stellen-Karten-Eintraege | REGRESSION | — | Z1043-1045 | BEHOBEN (2 rekonstruiert, Verify 72/72) | zweite Instanz Prompt-Verlust-Klasse (neben Template-Literal 10b) -> 12.2c | Register |
| 12.2b [K13-5] Stale Prosa-Referenz decl.hpp:797 zitiert "decl:568-571" (vorbestehend) | REGRESSION | — | Z1046-1047 | OFFEN (deklarierter Hinweis) | Traeger par.21.6/Doku-Zug | Register |
| 12.2b [K13-7] Wellenplan-par.5-Defizit-Arithmetik zaehlt F-07b als Deckungs-Streichung, obwohl F-07b Owner-KERN-PFLICHT ist | REGRESSION | — | Z1048-1049 | BEHOBEN (Task #98 + par.5-Marker super 9015a0de) | #98 | Register |
| 12.2b [K13-8] Fork "gab-es-denn": C-13 selektiver Rebuild STILL geloescht seit 27.07. (ce 813c3232, seither Vollflotten-Neubau) + C-14 SKIP-Wache nur T-NEU-11 + F-07b-W7-Verschiebung mit ERFUNDENER Agent-Autorisierung ("Streichkaskade bestaetigt", 0 Owner-Treffer) | REGRESSION | — | Z1050-1054 | OFFEN | Traeger #97/#98 + Wiederaufnahme-Register 0f569c8b + par.21.0-Beleg-Tafel | Register |
| 12.2b [JB-1] = 6b-Trunkierung-Verweis (s. 12.1) | UNKLAR | — | Z1055 | VERWIESEN (dort verdiktiert) | Sicherung/Reparatur X-16/X-17 | Register |
| 12.2c-Klasse: tail-Fenster (Fallen-Bezeichnung) | UNKLAR | — | Z1059 | VERWIESEN (= K9-3 oben) | Fallen-Register-Nachzug | Register |
| 12.2c-Klasse: ctest -N sed-Muster verliert Tests #1-#99 durch Padding (Zaehlbasis "Total Tests: N") | REGRESSION | — | Z1059-1060 | OFFEN (NEUE Fallen-Klasse, K6-2) | Fallen-Register-Nachzug | Register |
| 12.2c-Klasse: ctest --no-tests=error als Pflicht-Flag (E3-Klasse) | UNKLAR | — | Z1060 | VERWIESEN (= K5-1/K9-2 oben) | Fallen-Register-Nachzug | Register |
| 12.2c-Klasse: -DCOMDARE_CE_PRUEFLINGE in JEDER lokalen J-1-Treppe | UNKLAR | — | Z1061 | VERWIESEN (= K12-7 oben) | Fallen-Register-Nachzug | Register |
| 12.2c-Klasse: comdare_tests-Target ist PFLICHT sonst "Not Run"-Falschrot | UNKLAR | — | Z1061-1062 | VERWIESEN (= K10-5 oben) | Fallen-Register-Nachzug | Register |
| 12.2c-Klasse: Emitter-Timestamp macht sha256-Vergleich zur Schein-Differenz | UNKLAR | — | Z1062-1063 | VERWIESEN (= K9-13 oben) | Fallen-Register-Nachzug | Register |
| 12.2c-Klasse: Cross-Repo-Rename braucht Master-Nachzug in Geschwister-Repos | UNKLAR | — | Z1063 | VERWIESEN (= M-1 oben) | Fallen-Register-Nachzug | Register |
| 12.2c-Klasse: Stop/Resume erzeugt Agent-Duplikate | UNKLAR | — | Z1064 | VERWIESEN (= K10-8 oben) | Fallen-Register-Nachzug | Register |
| 12.2c-Klasse: Koeder-MELDUNGSTEXTE mitlesen | UNKLAR | — | Z1064-1065 | VERWIESEN (= K12-3 oben) | Fallen-Register-Nachzug | Register |
| 12.2c-Klasse: Poller-Rezepte gebuendelt (kein eingebetteter python3/K6-5, bash statt sh/K7a-5, curl -K statt --header @file/K7b-4, glhdr.curlrc+curl -sk gegen 404-Falsch-Null/K10-11, Poller nie stumm/K11-12) | UNKLAR | — | Z1065-1067 | VERWIESEN (= K6-5/K7a-5/K7b-4/K10-11/K11-12 oben) | Fallen-Register-Nachzug | Register |
| 12.2c-Klasse: docker auf prod1 ENTFERNT -> gitleaks lokal 8.30.1 (Koeder biss rc=1) | REGRESSION | — | Z1067 | ENTLASTET (NEUE Fallen-Klasse, K5-7) | Fallen-Register-Nachzug | Register |
| 12.2c-Klasse: TaskCreate fehlt Subagenten -> ToolSearch im Hauptagenten | UNKLAR | — | Z1068 | VERWIESEN (= K5-8 oben) | Fallen-Register-Nachzug | Register |
| 12.2d [K5-9] 3 Limit-Risse 16.08. (13:14 Monats-Limit wtsautqlp 3/3+Synthese; 15:47 Session-Limit w8oovcd6x 11/15; 21:38 Session-Limit) -- 15 Agenten tot, Luecken ~11h | REGRESSION | — | Z1072-1074 | BEHOBEN (alle per Resume-Kette geheilt: wsw7bnx76->wxmetyvp5, w5nfwp05x, wt0v91pcx->w3ebg280l) | - | Register |
| 12.2d [K8-10] K8-Tode 17.08.: Kurz-Verify verdict:null am Session-Limit; hy-a-bau 2x Limit+1x 529; vl12/vl3 529 | REGRESSION | — | Z1075-1077 | BEHOBEN (alle resumed; pgrep-Falle bestaetigt als Ausloeser des M-4-Doppelstarts) | Memory-Eintrag seit 19.08. | Register |
| 12.2d [K9-11] Spend-Riss 17.08. 11:35-15:39 (~4h): vl3/hy-a idle=failed, wf_a2e443f0 12/12 Agenten leer (bericht:null) | REGRESSION | — | Z1078-1079 | BEHOBEN (nach /login Resume wy7btb713 komplett per Cache-Replay, KON105) | - | Register |
| 12.3 GEERNTET-Tafel (16 Straenge, nur Zaehler+Beleg, keine Aktion): S-13-Design+Lens+Landung(#18,dfb8ba09) · hy-a-bau komplett(#80/#81,a4366cb8 Ancestor) · goal-drift wf_9819fde6(#78,KON97/98) · Buendel-Explore w4uz2itsx(BUENDEL-BAUPLAN-15) · super-Poller d152ba93(via #79) · 15946-Beweis+#79 · KON99+OWNER-VORAB-15(KON101) · ovs13-Explore(KON102) · 19-Fragen-Runde(KON103/104,#82-#86) · wf_7f847de1 F-Fragen(KON105/106,#86/#99) · vl3-Fix-Runde(7bf66ddd Ancestor) · W1-Lande-Strang wf_b5b4ac36(KON114,par.20;Push-vor-Gate=K3 GEHEILT) · audit-hya-vl3-Subagent(KON113) · K10-Schlussauftraege par.20+Uebergabe(Restnotiz #85(A)-Text stale,s.X-3) · super-Zug2 Welle2(KON116,#20/#70;a11-Vorpruefung=Register-G L9) · E-6-Explore(per KON118 Phantom-Nenner ueberholt,Doku-Rest=seg1-04/F8) | AUFGABE | — | Z1083-1092 | GEERNTET (bestaetigt, keine weitere Aktion) | 12.3-Tafel | Register |
| [X-1] golden-Rest-Refs: origin bau/golden-homes@5fa37f36 (letzte Branch-CI 15895 FAILED) + refs/rescue/golden-fenster-20260817@fbe898be + wt-ce-golden-rettung, beide Refs Ancestor von development (Substanz enthalten, 0 Traeger) | AUFGABE | — | Z1096-1100 | OFFEN (REKONSTRUIERBAR) | L20-Aufraeum-Block: D12-Muster (Bundle+SHA256+Owner-GO), 15895 ausbuchen | Register |
| [X-2] k2-Vollbau-Abnahme: bg-Outputs bl5ldht9z/bb3upsvgg nie gelesen, zugesagter G3/G4-Endbericht nie gekommen, Outputs noch in /tmp (Rotations-Risiko) | AUFGABE | — | Z1101-1104 | OFFEN (REKONSTRUIERBAR; k2 selbst gelandet #81) | Outputs sofort nach backups-workflow, G3/G4-Literale in #93 Gruppe Straenge nachbuchen | Register |
| [X-3] Owner-Voll-Lese-Auftraege 17.08.: Morgen-Klasse via #78 gedeckt, Neugruendungs-Haelfte via wf_6c904e28 vollzogen, #85-Text nennt 17:45-Zusaetze nicht | AUFGABE | — | Z1105-1109 | OFFEN (REKONSTRUIERBAR) | #85-Vollzug: 17:45-Zusaetze abhaken, synthese-p20-roh.json nur als Delta | Register |
| [X-4] HY-A-Zweit-Lens-Deckung: SPANNUNG AUFGELOEST -- Folge-Lens LIEF (wf_750d2441, TRAEGT_MIT_FIXES 2 ERNST, Fixes gelandet s. JB-3); Rekonstruktions-These gilt nur fuer Runde-2-Flaeche (RCU-Umbau nach 21/25-rot) | REGRESSION | — | Z1110-1115 | GEKLAERT | Quittungs-Nachtrag(JB-3) + #93-C: Runde-2-Flaeche auf Lens-Deckung pruefen | Register |
| [X-5] rcu-Nachmess-Serien (50/30/20 + A/B-Paarlauf): Endquittungen nie angekommen, Rohwerte nirgends persistiert; Zweck objektseitig gedeckt (f45e995b Ancestor, 502/502) | AUFGABE | — | Z1116-1119 | OFFEN (REKONSTRUIERBAR) | #93-C: am gelandeten Stand reproduzieren ODER "Rohquittungen nicht persistiert" explizit ausweisen | Register |
| [X-6] tail-Fallen-Eintrag = Verweis auf K9-3 | UNKLAR | — | Z1120 | VERWIESEN | Ein-Zeilen-Nachzug im T-5/T-6-Memory-Zug (11.5) | Register |
| [X-7] wf_cd301f28 Schwester-Sweep K8-K13 (14 started/13 results, lebte 19.08. 07:35); R1-R10 inhaltlich in Abschnitt 12 konsolidiert (R1=M-3,R2=K5-1,R3=K11-1/K3,R4/R6=M-1,R5=K1-Korrektur,R7/R10=T-10/12.1,R8=K8-1,R9=K10-1) | AUFGABE | — | Z1121-1124 | BEHOBEN (GEKLAERT, keine Doppel-Ernte) | Journal nach B.3 sichern + Endzeile quittieren | Register |
| [X-9] vl3-Nachposten N1/N5/N6: Quelle doppelt gesichert (audit-ergebnisse-beide-straenge.md), Register 0 Treffer; vl3 gelandet | AUFGABE | — | Z1130-1132 | OFFEN (REKONSTRUIERBAR) | #93 Gruppe A aus Audit-BU aufschluesseln, je Posten am gelandeten Stand messen -> Abschnitt 9 | Register |
| [X-10] g2/#17-Strang: 1528f6fd NICHT Ancestor, Branch bau/g2-semantik NUR LOKAL (Einzelkopie-Risiko!), wt-ce-g2@9aa9b9df clean, Abschlussbericht gesichert in wf_b5b4ac36-Journal | REGRESSION | — | Z1133-1138 | OFFEN zum K15-Zeitpunkt (= W1-V1/9.1(2)-Status-Fortschreibung, seither dort BEHOBEN/GELANDET ba33b9ac 20:23Z) | Branch sichern, Bericht ernten, Lande-Kette per [W1-V1] VOR F2 | Register |
| [X-11] Nested-Worktree wf_e22d25ef-71c-7@7f3901fb, dirty=17 (D2-Strang 10.08.), Tip NICHT Ancestor, Eltern-Journal tot seit 10.08.; Nebenbefund 3 weitere nested Baeume wf_5834b706(p2/p3/p6,dirty=0) | AUFGABE | — | Z1139-1145 | OFFEN (einziger ganz unverbuchter Arbeitsprodukt-Fund des Sweeps) | 17 Aenderungen als Diff-BU sichern, dev-Enthaltensein pruefen (#62-Muster), Liste-C/D-Ausbuchung ODER D2c-Wiederaufnahme | Register |
| [X-12] V-02R Wert-Befuellung (Laufzeit-Haelfte B-8/A-12): Bausteine im Bruch da (P5 9c17765f Compose+3 fail-loud-Wachen, P3/P4 name_line/len+SHA-256, Map landet K-1-leer); Ernte-Frage per 12.1 GESCHLOSSEN | AUFGABE | — | Z1146-1149 | TEIL-BEHOBEN (Bausteine da), Rest OFFEN (Laufzeit-Befuellung) | nach C-3a-/F4-Entscheid eigener Board-Task; Hash-Laenge=F2-Punkt | Register |
| [X-13] B-8-Folgeposten Gate-Define-Emission + hat()-Paar: Kommentar-Anker bestaetigt (mess_achsen_naht.hpp:593), par.21.1-Liste+Bauplan tragen B-8, aber KEIN Board-Task; K2=F6 deckt B-8 NICHT | AUFGABE | — | Z1150-1152 | OFFEN | Beim Di-25.-Schnitt (#96) als Task slotten | Register |
| [X-14] Peer-Sessions e1-e4 + idle Subagent: 3 bg-Sessions idle (11d/5d/4d), nie beendet/geerntet; fachliche Deckung wahrscheinlich (#21 completed); Subagent audit-hya-vl3-soll-ist noch adressierbar | AUFGABE | — | Z1153-1156 | OFFEN | Je Session Ernte-Check gegen #21/Ledger, dann BEENDEN; Betriebszeile im Di-25.-Schnitt | Register |
| [X-15] VL-6b-G6-Buchung NIE VOLLZOGEN: run_options/organ_subaxes XSD-gueltig, aber von parse_experiment_profile/ExperimentProfile/validate IGNORIERT; vl6b-karte.md verlangte woertlich Nachbuchung -- genau das ist NICHT passiert | REGRESSION | — | Z1157-1162 | OFFEN | Nachtrag in KF-6/S6-Familie bzw. S-13/#18; beim S-13-Bau verdrahten ODER fail-loud (vgl. K6-6) | Register |
| [X-16] Voll-Audit-ENDSTAND ungesichert (SOFORT): wf_794b904b-Journal (1,1MB,170 started/77 results) NUR unter ~/.claude/projects; audit_107_tafel.md NUR im rotierenden jobs-tmp; Repo-BU traegt nur 18.08.-Teilstand; Journal = EINZIGER Traeger der 111 ungekuerzten Verdikte+seg1-81-Matrix | REGRESSION | — | Z1163-1168 | OFFEN (SOFORT-Sicherung noetig) | Vor Aufraeumen: additiv nach backups-workflow/20260819-audit-endstand-794b904b/, dann Repo-BU-Nachzug; K12-10-Patches im selben Zug | Register |
| [X-17] 23-Schritte-Deckungs-Matrix ohne publizierten Traeger: Volltext nur im Audit-Journal Z.144, 6b-Zeile seg1-81 endet mid-Satz | REGRESSION | — | Z1169-1173 | OFFEN | Nach X-16 als Register-Nachtrag 6c bzw. Fix-Strecke-2-Eingang publizieren, 6b-Zeile reparieren, Kuerzung deklarieren | Register |
| 12.4 SOFORT (vor jedem Aufraeumen, B.3): X-16 Audit-Journal+107er-Tafel sichern · X-2 k2-Outputs aus /tmp sichern · X-10 bau/g2-semantik + X-8 bau/v08r-fingerprint-sha auf origin sichern · K12-10-Patches mitnehmen | AUFGABE | — | Z1177-1179 | GEPLANT | SOFORT | Register |
| 12.4 Fix-Strecke 2 erhaelt zusaetzlich: T-10-Praezisierung(12.1) · 6b-Reparatur+23er-Matrix(X-16/X-17) · B3-Anker-Abgleich VOR Gruppe-D-Messung(12.1) · prt-art-Roundtrip-SHA-Pin als W2-Task(K7b-3) · tools-3-Format-Traeger(K11-5) · W2-1/:515-Registeranker(M-5) | AUFGABE | — | Z1180-1184 | GEPLANT | Fix-Strecke 2 | Register |
| 12.4 #93 erhaelt konkretisierte Pruefposten: Gruppe A(vl3 ROT-3+_pclose K10-4, N1/N5/N6 X-9, F2/Wstringop-Verbleib K10-12, Warnungs-Review-clang M-6/W2-2) · Gruppe C(HY-A-Runde2-Lens X-4, rcu-Serien X-5, V-02R-Bau-Haelfte X-12) · Gruppe D(B3 richtiger Anker 12.1) · Gruppe Straenge(k2-G3/G4-Literale X-2) | AUFGABE | — | Z1185-1189 | GEPLANT | #93 | Register |
| 12.4 Di-25.-Schnitt (#96) erhaelt: B-8-Task(X-13) · VL-6b-Parser-Befund in S-13/#18(X-15,mit K6-6) · Methodik-Override-Entscheid S-8/#22(K12-2) · Peer-Session-Triage(X-14) · golden-Ref-Ausbuchung(X-1) · Nested-Worktree-Triage(X-11); VORHER vor F2: g2-Landeweg(X-10=W1-V1-Pflicht) | AUFGABE | — | Z1190-1193 | GEPLANT | #96 | Register |
| 12.4 Docs-/Memory-Zug: KON74-04-Vermerk(K7b-5) · KON99-03-Zaehlwerk(JB-4) · Folge-BU-Spiegel(JB-2) · hy-a-Lens-Quittung(JB-3) · #85-Text-Delta(X-3) · Fallen-Block 12.2c GESCHLOSSEN in T-5/T-6-Memory-Zug (13 Klassen, nicht einzeln verlieren) | AUFGABE | — | Z1194-1196 | GEPLANT | Docs-/Memory-Zug | Register |
| 13.1 Audit-ENDSTAND-PRAEZISIERUNG (Auflage fuer 6c/X-17): 111er-Tafel(6b) = ZWISCHENSTAND; Audit-ENDSTAND 502 ERFUELLT/74 UEBERHOLT/85 ABWEICHUNG/22 FEHLT/5 NICHT_PRUEFBAR = 107 offene (ueber 688 Zusagen) | UNKLAR | — | Z1201-1205 (13.1) | ABGESCHLOSSEN (6c uebernimmt Endstand-Zahlen+Volltexte aus BU-Journal @9052a56b) | 6c-Publikation | Register |
| 13.1 4 spaeter entlastete IDs -> ERFUELLT: LS2-33, LS2-41, seg3-kon8-11 | REGRESSION | — | Z1203-1204 | BEHOBEN (Status-Fortschreibung: waren ABWEICHUNG/VERTAGT, jetzt ERFUELLT) | = Fortschreibung LS2-33/LS2-41/seg3-kon8-11 oben | Register |
| 13.1 1 ID -> UEBERHOLT: LS2-34 | REGRESSION | — | Z1203-1204 | ENTLASTET (Status-Fortschreibung: war KRITISCH/ABWEICHUNG, jetzt UEBERHOLT) | = Fortschreibung LS2-34 oben | Register |
| 13.2 [F-A] Komplex-Fix-Rolle (v4.3) DEKLARIEREN in KON119/Merge-Botschaft (Fix-Strecke2+L2/L3-Kombibau am zusammengesetzten Stand uebernehmen sie; Pushes je L-Glied juenger) | AUFGABE | — | Z1207-1209 | OFFEN | KON119/Merge-Botschaft | Register |
| 13.2 [F-C] B-8 + VL-5/VL-6-Doku beim Di-25.-Schnitt NAMENTLICH gegenzaehlen (nur implizit im Wiederaufnahme-Register) | AUFGABE | — | Z1210-1211 | OFFEN | Di-25.-Schnitt (#96) | Register |
| 13.2 [F-D] VL-3(a) clang-Warnungs-Review = W2-1-Buchung (Sweep B-6), in #93-A DEKLARIERT ausweisen (sonst Freeze-Check-Falsch-Rot) | REGRESSION | — | Z1211-1213 | OFFEN | #93-A | Register |
| 13.2 [F-E] B-1-Kern GEBAUT (fixture_schema_subset_check.cmake haertet, CMakeLists:349 -DFIXTURE); Rest: Mutationsprobe ROT-statt-SKIPPED, Kopf-Nachzuege, SCHEMA.md:48 | REGRESSION | — | Z1213-1214 | TEIL-BEHOBEN (Kern gebaut), Rest OFFEN | L4 | Register |
| 13.2 [F-F] P2/P3-Vorlagen aus par.21.6 AM ORIGINAL bauen | AUFGABE | — | Z1214-1215 | OFFEN | par.21.6-Nachzug | Register |
| 13.2 [F-G] clang-debug-ENTLASTET-Deklaration beim Freeze-Check mitfuehren; waehrend Fix-Strecke gehoert wt-ce-bump15 dem Workflow (Lead-Session-cwd beachten) | AUFGABE | — | Z1215-1216 | OFFEN | Freeze-Check | Register |
| 13.3 [L-A] OF-4-PAT-Kette A1->A2->A3 | AUFGABE | — | Z1219 | BEHOBEN (completed, #54) | #54 | Register |
| 13.3 [L-B] V8 GitHub-PAT-Rotation | AUFGABE | — | Z1219-1220 | OFFEN | - | Register |
| 13.3 [L-C] V9 rescue-Ref w3-thesis-c (95 Alt-Trailer) | AUFGABE | — | Z1220 | OFFEN (an E12-Owner-Entscheid gekoppelt) | E12 | Register |
| 13.3 [L-D] node6/id56/id18 (Owner-Klaerung) | AUFGABE | — | Z1220-1221 | OFFEN | Owner | Register |
| 13.3 [L-E] VL-5(b)-(e) in L4 (+X-17-Gegenprobe) | AUFGABE | — | Z1221 | OFFEN | L4 | Register |
| 13.3 WARNUNG: N1-N5-N6 (vl3/X-9) != N-1..N-6 (Bauplan via X-17) -- Verwechslungsgefahr, Parallel-Order gilt per Memory | UNKLAR | — | Z1221-1222 | OFFEN (Warnung) | - | Register |
| 13.4 seg4-58-Detail: snmalloc '-Werror=pedantic' blockt comdare_tests -> 37 Not Run, Eichlinie dort BLIND | REGRESSION | — | Z1224-1226 | OFFEN | L4-/W2-Posten | Register |
| 13.4 [K-07] #90/#91 nie angeworfen (naechste Parallel-Kandidaten nach dem Rueckweg; #91-Frist Identitaets-Entscheide vor Mi 26.08.) | AUFGABE | — | Z1228 | OFFEN | #90, #91 | Register |
| 13.4 [P-12] wt-ce-vl12/build-vl12 880M stale | AUFGABE | — | Z1230 | OFFEN | Aufraeum-Block | Register |
| 13.6 ENOSPC-Ausgang+Queue-Verfall-Lehre+Pipeline-16020-Heilung | REGRESSION | — | Z1237-1238 | BEHOBEN (verbucht Uebergabe Abschnitt 10) | - | Register |
| 13.6 g2-ENDSTAND cb856212 (Rest-Kategorien LEERE MENGE; 4/4 Zellen@9aa9b9df; g2-Funde 2-4 vertagt) | UNKLAR | — | Z1238-1239 | ABGESCHLOSSEN (Kategorien leer), Funde 2-4 VERTAGT | -> L2-Optionen A/B | Register |
| 13.6 Memory-Z.73-Fix | AUFGABE | — | Z1239 | BEHOBEN (ERLEDIGT) | - | Register |
| 13.6 BU-Ordner GELANDET 9052a56b (Redaktion wf_279c39c0 FREIGEGEBEN 18/18 SAUBER, CI SUCCESS) | AUFGABE | — | Z1239-1240 | GELANDET/CI-BEWIESEN | - | Register |
| 13.7 FIX-STRECKEN-DECKUNGS-TAFEL: laufender WF wf_46805ad8 traegt F1-F9,T-2,T-10-Bau,L21,B3,tools-3,M-5,18.6(3)-Deklaration; NICHT: 13.1/6c(Lead-docs-Zug),13.2 F-A/F-E/F-F(Lande-Zuege),13.3(Di-25/Owner/L4),13.4(L4/W2/Infra/Di-25),13.5(L3) | AUFGABE | — | Z1242-1247 | LAEUFT (Scope-Zuweisung; K16-Pflicht: WF-Quittungen gegenpruefen) | wf_46805ad8 | Register |
| 13.8 [A2] LANDE-VORBEHALTE L1: (a) Gate-4-Lock-Rot 4 Traeger -> T-B=Lande-Schritt3 (Erst-Versionen+Regen-Commit+pre_push_lande_gates voll gruen) | REGRESSION | — | Z1256-1257 | OFFEN | T-B, Lande-Schritt 3 | Register |
| 13.8 [A2] (b) T-C: 4 XML-Wohlform-Vorbestandsfehler ('--' im Kommentar: m3_smoke_coverage:170, m3v2_sota_pilot:8, wdk_fairness_example:73, measurement_axis_registry:61) | REGRESSION | — | Z1257-1259 | OFFEN (im Lande-Zug heilen, sonst ci_xml_wellformed_guard 4/160 rot) | T-C | Register |
| 13.8 [A13] TIP-DELTA-DECKUNG: Abnahme/R2 galten @8cd32a0d, HEAD ist 79171599 (+3 tools-Format-Dateien+1 Kommentarzeile, ausserhalb CI-Pruefmenge) | REGRESSION | — | Z1260-1262 | OFFEN | vor L1 pre_push_lande_gates.sh am neuen Tip fahren + M-7-Klaerung (#100) | Register |
| 13.8 [A4] KON119-PFLICHTEN: F4/18.6(3)-Deklaration (fixr1_endquittung_fixstrecke2_vollstaendig.md Abschnitt 0) + F-A-Komplex-Fix-Deklaration + T-A Ledger-Buchung C-3a | AUFGABE | — | Z1263-1265 | OFFEN | KON119 | Register |
| 13.8 [A7] B3-SPEZ-ABWEICHUNG (deklariert, kein Defekt): G5 baute Legenden-Erbe statt m1-vorgesehenem neuem CEB-Stempel-Glied, golden-NEUTRAL; m1-F2-Schutzgedanke lebt als B5-VORPOSTEN in #24 | REGRESSION | — | Z1266-1270 | ENTLASTET (deklariert) | KON119-Vermerk, #24 | Register |
| 13.8 [A8] NP-23 GEBAUT MIT ZAHL 7 (nicht 5/6): Voll-CSV 25->32 Spalten, 16er-Pipeline-Vertrag unberuehrt, schema_freeze.hpp im selben Commit (78cc75e6) | REGRESSION | — | Z1271-1272 | BEHOBEN | NP-24-Baupunkt neu benannt | Register |
| 13.8 [A9] F7-WURZEL SCHARF: Generator-Default out_path='system_axis_registry.xml' im CWD | REGRESSION | — | Z1273-1274 | BEHOBEN (Datei geloescht) | = Fortschreibung H1/F7 | Register |
| 13.8 [A10] PIC-LATENZ: C3-Rot war Zellen-Mischbau (CMAKE_C_COMPILER=cc->gcc-15.3 ohne PIE-Default bei CXX=clang++, prod1-Maschinen-Falle); comdare_hdr_histogram_wrapper einzige Haus-Lib ohne POSITION_INDEPENDENT_CODE ON | REGRESSION | — | Z1275-1278 | ENTLASTET (Ursache), Rest OFFEN (W2-Mini-Posten PIC-Hausnorm) | 'W2-Slot-Posten Altbestand' entfaellt in alter Form | Register |
| 13.8 [A11] T2-Haertung optional: [0]/[4]-Vertauschung nur Test-TU-gedeckt | AUFGABE | — | Z1279-1280 | OFFEN (W2-klein) | 2 static_asserts unter anatomy_fingerprint.hpp:1207 | Register |
| 13.8 [A12] -> Task #103 TSan-Vollausbau, eigene Objektklasse (87fa9473 aendert CI-Verhalten mit L1!) | AUFGABE | — | Z1281 | OFFEN | #103 | Register |
| 13.8 [A5] VERIFY-R1-VOLLTEXT geborgen (nur im Journal): 6 Funde (2 MITTEL/4 NIEDRIG), inkl. Korrektur "F3=Endstand decken" (R1-Kandidat decl.hpp war falsch) | REGRESSION | — | Z1282-1283 | BEHOBEN (alle in fix-r1) | - | Register |
| 13.8 [A16-A18] Fallen/Betrieb (Memory-Zug): LastTestsFailed.log=Altrest bei gruenem Lauf · CMakeCache-mtime kein Halbschreib-Indiz · Basename-Gleichheit statt Substring (clang++ endet auf g++!) · ctest-Nummern rechtsbuendig · 'ccache 1837 Hits' nie zitieren · ninja-Endzeile [N-1/N] normal · Werkzeug-Targets comdare_adhoc_emitter_cli+comdare_catalog_codegen_cli | REGRESSION | — | Z1284-1288 | OFFEN (Fallen-Register-Nachzug) | Memory-Zug | Register |
| 13.8 [A19] ZITIERFUNDUS: G1-Dreh wire-/preimage-neutral BELEGT; Ordinale 0-5 blockweise; axis_category_of=NP-02-Andockpunkt; Status-Codes 13-15 in hybrid_dock_contract.hpp; Floor-Endstand 507/503/501; Hygiene 34174 Zusatzzeilen 0/0 | UNKLAR | — | Z1289-1291 | ABGESCHLOSSEN (Zitierfundus) | - | Register |
| 13.8 COMMIT-TAFEL e285d316..79171599 (20 Commits) + Vollzaehligkeits-Urteil: Eingangsmenge 15/15 GEDECKT, kein Posten still verschwunden | AUFGABE | — | Z1292-1294 | CI-BEWIESEN (Vollzaehligkeit) | schatz-leser-Bericht + backups-workflow/20260819-fixstrecke2-logs/fixr1_endquittung_*.md | Register |

## Teil D — Einzelquellen-Posten: Memory/Tasks (368 von 404 Rohzeilen; 36 gingen in Teil A auf)

Aus `leser-memory-tasks.md` uebernommen (KUERZEL/Name | Klasse | Quelle | Status LAUT QUELLE | Traeger/Task); Spalte `Welle` fehlte in der Quelle und wurde mit `—` aufgefuellt (MEMORY.md/Task-Board tragen keine Wellen-Zuordnung), Spalte `Quellen` ergaenzt. Kein weiterer Inhalt gekuerzt oder umformuliert.

| KUERZEL/Name | Klasse | Welle | Quelle (Z-Anker) | Status LAUT QUELLE | Traeger/Task | Quellen |
|---|---|---|---|---|---|---|
| NUR FABLE 5 MAX (voruebergehend) | OWNER-ENTSCHEID | — | MEMORY.md:3 | GELANDET (aktiv seit 12.08., bis Widerruf; danach zurueck zu A1-Matrix+KON38) | Owner 12.08. | Memory/Tasks |
| STAND 10.08. (Auslaufdokument) | UNKLAR | — | MEMORY.md:6 | GESTRICHEN (abgeloest durch Ledger-Kopf KON118) | -- | Memory/Tasks |
| 12/14 Definitionen in STAND 10.08. falsch | REGRESSION | — | MEMORY.md:6 | BEHOBEN (lebender Stand jetzt=Ledger-Kopf KON118, 18.08.) | -- | Memory/Tasks |
| ZWEI MESS-ARCHITEKTUREN (System A live / System B dormant) | FEATURE | — | MEMORY.md:7 | GEPLANT (Konflikt dokumentiert) | KON34 | Memory/Tasks |
| HARDWARE-ERWEITERUNG IST ADDITIV | OWNER-ENTSCHEID | — | MEMORY.md:8 | GELANDET (nur Funktionseinschraenkung erzwingt Neubau) | -- | Memory/Tasks |
| PMC = Meta-Meta | OWNER-ENTSCHEID | — | MEMORY.md:9 | GELANDET | Owner-Antworten 10.08. | Memory/Tasks |
| Fallback-Reihenfolge 5/2/1 | OWNER-ENTSCHEID | — | MEMORY.md:9 | GELANDET | Owner-Antworten 10.08. | Memory/Tasks |
| Binary-Zahl NUR aus Planungs-Simulation | OWNER-ENTSCHEID | — | MEMORY.md:9 | GELANDET | Owner-Antworten 10.08.; rechnet S-19 | Memory/Tasks |
| GOAL v8 + TDD-Vertrag | AUFGABE | — | MEMORY.md:10 | GEPLANT (Frist 15.09., 5 Pruefungen T-1..T-9) | -- | Memory/Tasks |
| MEMORY-DETAIL.md (Auslagerung Architektur/Kette/Infra/Rollen/Planung/Thesis) | UNKLAR | — | MEMORY.md:11 | GELANDET (Verweisziel, separat ausgewertet) | -- | Memory/Tasks |
| 106 UNVERLINKTE MEMORIES (Konsolidierung) | AUFGABE | — | MEMORY.md:12 | OFFEN (liegt in super docs/plaene/20260810-KONSOLIDIERUNG-*) | -- | Memory/Tasks |
| STEMPEL-STRECKE = FABLE 5 MAX UEBERALL | OWNER-ENTSCHEID | — | MEMORY.md:15 | GELANDET | Owner-KERN 12.08., KON38 | Memory/Tasks |
| ORT != ZEIT (keine Phasigkeit aus ORT-Satz) | OWNER-ENTSCHEID | — | MEMORY.md:17 | GELANDET (KON8-12/KON13) | -- | Memory/Tasks |
| DREI FLAECHEN (Genus/Stempel/measurement-Durchstich) | FEATURE | — | MEMORY.md:19 | dokumentiert | -- | Memory/Tasks |
| SELBSTKOMPILATION (Director/Builder+AxisCommand) | FEATURE | — | MEMORY.md:20 | GEBAUT (3/4 Bausteine da), fehlt Steuerung->Compile | -- | Memory/Tasks |
| Ledger-Kopf = juengste KON (aktuell KON118) | OWNER-ENTSCHEID | — | MEMORY.md:21 | GELANDET (18.08.) | Konsolidierung IV, Wellenplan Par.18 | Memory/Tasks |
| KON35 nie vergeben | UNKLAR | — | MEMORY.md:21 | OFFEN (Luecke in KON-Nummerierung) | -- | Memory/Tasks |
| ZEITHORIZONTE UEBERGEHEN -- ALLES SOFORT | OWNER-ENTSCHEID | — | MEMORY.md:24 | GELANDET | Owner 20.08. | Memory/Tasks |
| STEMPEL-KUERZEL IMMER ZERLEGEN | OWNER-ENTSCHEID | — | MEMORY.md:27 | GELANDET (cpe=c{p.e} nie flach) | -- | Memory/Tasks |
| ZWOELF-WOCHEN-ultracode-EXPLORE fuer JEDE Frage | AUFGABE | — | MEMORY.md:28 | GELANDET (Normalfall) | -- | Memory/Tasks |
| Falsch-Null-Muster (Encoding/Case/~95-Zeichen-Umbruch) | REGRESSION | — | MEMORY.md:28 | OFFEN-REGRESSION (staendiges Risiko bei Explore) | -- | Memory/Tasks |
| CODE-REVIEW = Opus max ERHEBT + Fable max BEWERTET | OWNER-ENTSCHEID | — | MEMORY.md:29 | GELANDET | -- | Memory/Tasks |
| SYNTHESE = Fable 5 max, NIE Opus | OWNER-ENTSCHEID | — | MEMORY.md:31 | GELANDET (nur uebers Workflow-Tool setzbar) | -- | Memory/Tasks |
| BESTANDS-PFLICHT vor Neuimplementierung | AUFGABE | — | MEMORY.md:32 | GELANDET | -- | Memory/Tasks |
| NEU GRUENDEN + VOLL KIPPEN nach jedem Compact | OWNER-ENTSCHEID | — | MEMORY.md:33 | GELANDET (Dauerorder) | -- | Memory/Tasks |
| K17-Pausen-Sonderorder | OWNER-ENTSCHEID | — | MEMORY.md:33 | GESTRICHEN (verbraucht 20.08., Owner "Dann weiter") | -- | Memory/Tasks |
| GOAL allein genuegt NICHT (Arbeitsweise eigenes Dokument) | AUFGABE | — | MEMORY.md:34 | GELANDET | -- | Memory/Tasks |
| Sessions ab 08.08. LESEN statt Reviews fahren | AUFGABE | — | MEMORY.md:34 | GELANDET | -- | Memory/Tasks |
| ERST LAUTE COMPILE-FEHLER, DANN VERSCHIEBEN | AUFGABE | — | MEMORY.md:35 | GELANDET | -- | Memory/Tasks |
| FERTIGE ARBEIT LANDEN (erst Landung, dann aufraeumen) | AUFGABE | — | MEMORY.md:36 | GELANDET | -- | Memory/Tasks |
| WORKTREE loeschen erst gruen+gemergt | AUFGABE | — | MEMORY.md:37 | GELANDET | -- | Memory/Tasks |
| Submodul-Branches VORHER pruefen (vor Worktree-Loeschung) | OWNER-ENTSCHEID | — | MEMORY.md:37 | GELANDET | -- | Memory/Tasks |
| NESTED Worktrees sterben mit dem Eltern-Worktree | REGRESSION | — | MEMORY.md:37 | OFFEN-REGRESSION (Risiko bei Loeschung) | -- | Memory/Tasks |
| STUMME WORKFLOW-TODE (journal.jsonl=Wahrheit) | REGRESSION | — | MEMORY.md:38 | OFFEN-REGRESSION (Diagnoseweg: zuerst df -h) | -- | Memory/Tasks |
| VOLLE PLATTE TOETET AUCH HOOKS | REGRESSION | — | MEMORY.md:39 | BEHOBEN (Ausweg: rm -rf ~/.cache/uv/builds-v0) | -- | Memory/Tasks |
| PARALLEL BAUEN, SEQUENTIELL LANDEN | AUFGABE | — | MEMORY.md:40 | GELANDET (Lande-Stufe im Workflow, landet den Zweig) | -- | Memory/Tasks |
| LANDUNG HARMONISIERT VERTRAEGE | OWNER-ENTSCHEID | — | MEMORY.md:41 | GELANDET (harmonisieren statt mergen; Zaehlwerke einmal live) | -- | Memory/Tasks |
| EIN SCHREIBER JE WORKTREE | AUFGABE | — | MEMORY.md:42 | GELANDET | -- | Memory/Tasks |
| WARNUNGS-REVIEW ZWEIMAL (gcc dann clang) | AUFGABE | — | MEMORY.md:43 | GELANDET | -- | Memory/Tasks |
| Google Tests Debug+Release (keine Shell-Proben) | AUFGABE | — | MEMORY.md:43 | GELANDET | -- | Memory/Tasks |
| VOLLBAU-LUECKEN = FALSCHES GRUEN | REGRESSION | — | MEMORY.md:44 | OFFEN-REGRESSION | J-0b PRUEFLINGE-Var, J-1 SIEBEN Werkzeuge->RE-CONFIGURE->Vollbau | Memory/Tasks |
| VERDECKTE exit-ZWEIGE (Mutant bleibt gruen) | REGRESSION | — | MEMORY.md:45 | OFFEN-REGRESSION (nicht beobachtbar) | -- | Memory/Tasks |
| ABSCHRIFT statt Aufruf -- Loeschung bricht nur bei Aufrufern | AUFGABE | — | MEMORY.md:45 | GELANDET (Prinzip) | -- | Memory/Tasks |
| Nie raten -- immer State-of-Art/Docs nachschlagen | AUFGABE | — | MEMORY.md:46 | GELANDET | -- | Memory/Tasks |
| GOAL-Hook thorough read in "never guess" | AUFGABE | — | MEMORY.md:46 | GELANDET | -- | Memory/Tasks |
| Kein Erfolgs-Haken ohne woertlichen Output | AUFGABE | — | MEMORY.md:46 | GELANDET | -- | Memory/Tasks |
| Gruendliche Annahmen im Workflow-Planning | AUFGABE | — | MEMORY.md:46 | GELANDET | -- | Memory/Tasks |
| Keine Quick-Fixes | OWNER-ENTSCHEID | — | MEMORY.md:47 | GELANDET | -- | Memory/Tasks |
| Immer schwererer offizieller Weg (CMake/ctest, keine Behelfswege) | AUFGABE | — | MEMORY.md:47 | GELANDET | -- | Memory/Tasks |
| Infra: sauberste statt einfachste Loesung | AUFGABE | — | MEMORY.md:47 | GELANDET | -- | Memory/Tasks |
| Nur EIN offizielles XML-getriebenes Programm, keine Behelfswege | OWNER-ENTSCHEID | — | MEMORY.md:47 | GELANDET | -- | Memory/Tasks |
| Deploy Key nur privates CI-Template, nie in public Repos | OWNER-ENTSCHEID | — | MEMORY.md:47 | GELANDET | -- | Memory/Tasks |
| ultracode-Workflow fuer Unklarheit und absolute Behauptungen | AUFGABE | — | MEMORY.md:48 | GELANDET | -- | Memory/Tasks |
| "Scheint fertig?" -> ultracode-Verifikation Pflicht | AUFGABE | — | MEMORY.md:48 | GELANDET | -- | Memory/Tasks |
| Analyse-Backups vor Entscheidungen via ultracode konsultieren | AUFGABE | — | MEMORY.md:48 | GELANDET | -- | Memory/Tasks |
| Ledger komplett + ultracode-Richtung vor Abschnitten | AUFGABE | — | MEMORY.md:48 | GELANDET | -- | Memory/Tasks |
| bwrap DAUERHAFT defekt fuer Codex (7 Belege) | REGRESSION | — | MEMORY.md:49 | BEHOBEN (Workaround: codex exec + Volltext im Prompt) | -- | Memory/Tasks |
| Codex klein schneiden + IMMER zweiten Lens parallel | OWNER-ENTSCHEID | — | MEMORY.md:49 | GELANDET | -- | Memory/Tasks |
| Ledger immer ZUERST lesen vor Handeln | OWNER-ENTSCHEID | — | MEMORY.md:50 | GELANDET | -- | Memory/Tasks |
| Vor jedem TODO liest Agent vollen Ledger + manuelle Details | AUFGABE | — | MEMORY.md:50 | GELANDET | -- | Memory/Tasks |
| Offene Entscheidung -> erst Ledger+Plandocs erneut lesen | AUFGABE | — | MEMORY.md:50 | GELANDET | -- | Memory/Tasks |
| Fehlende Entscheidung erst Explore, alles ist entschieden | AUFGABE | — | MEMORY.md:50 | GELANDET | -- | Memory/Tasks |
| Vor Aufgaben erst Projektstruktur-Analyse | AUFGABE | — | MEMORY.md:50 | GELANDET | -- | Memory/Tasks |
| Nie rebase, immer merge | OWNER-ENTSCHEID | — | MEMORY.md:51 | GELANDET | -- | Memory/Tasks |
| Gitflow-Branch-Doktrin (main Autoritaet, development voraus) | OWNER-ENTSCHEID | — | MEMORY.md:51 | GELANDET | -- | Memory/Tasks |
| Alle Projekte Dual-Remote GitHub+GitLab | OWNER-ENTSCHEID | — | MEMORY.md:51 | GELANDET | -- | Memory/Tasks |
| GitHub flache Out-of-house-Sicherung, Fokus GitLab | AUFGABE | — | MEMORY.md:51 | GELANDET | -- | Memory/Tasks |
| Nach Push GitLab-Pipeline-Gruen verifizieren | AUFGABE | — | MEMORY.md:51 | GELANDET | -- | Memory/Tasks |
| Remote-Loeschung erfordert explizite User-Autorisierung | OWNER-ENTSCHEID | — | MEMORY.md:51 | GELANDET | -- | Memory/Tasks |
| Diplomarbeit 4 Projekte lokale Klone synchron halten | AUFGABE | — | MEMORY.md:51 | GELANDET | -- | Memory/Tasks |
| Messdaten nie loeschen, auch wenn ABI bricht | OWNER-ENTSCHEID | — | MEMORY.md:52 | GELANDET | -- | Memory/Tasks |
| Dokumentation nie loeschen, nur deprecaten | OWNER-ENTSCHEID | — | MEMORY.md:52 | GELANDET | -- | Memory/Tasks |
| Raw-Data-Backups additiv, nie loeschen | OWNER-ENTSCHEID | — | MEMORY.md:52 | GELANDET | -- | Memory/Tasks |
| Backups nur Workflow-Rohdaten, nie Sessions/Plaene | AUFGABE | — | MEMORY.md:52 | GELANDET | -- | Memory/Tasks |
| rm build/-Verzeichnis enthaelt getrackte Mess-CSV (Falle) | REGRESSION | — | MEMORY.md:52 | OFFEN-REGRESSION | -- | Memory/Tasks |
| Tasks-Liste ist nutzersichtbares TODO, aktuell halten | AUFGABE | — | MEMORY.md:53 | GELANDET | -- | Memory/Tasks |
| Pipeline #286 (Multi-Day-Experiment) nie pollen | OWNER-ENTSCHEID | — | MEMORY.md:53 | GELANDET | -- | Memory/Tasks |
| Monitore duerfen nie stumm haengen -- Vollblick/Heartbeat | AUFGABE | — | MEMORY.md:53 | GELANDET | -- | Memory/Tasks |
| Zielgetriebene Autonomie -- Shells/Monitore beenden | AUFGABE | — | MEMORY.md:53 | GELANDET | -- | Memory/Tasks |
| Nie AskUserQuestion verwenden (crasht Session) | REGRESSION | — | MEMORY.md:53 | BEHOBEN (Tool wird gemieden) | -- | Memory/Tasks |
| Session-Transkripte enthalten Live-Tokens, nie committen | OWNER-ENTSCHEID | — | MEMORY.md:53 | GELANDET | -- | Memory/Tasks |
| Wiederanlauf-Doktrin nach Session-Abriss | AUFGABE | — | MEMORY.md:54 | GELANDET | -- | Memory/Tasks |
| Sessions rueckwaerts lesen, beide Repos, =5 | AUFGABE | — | MEMORY.md:54 | GELANDET | -- | Memory/Tasks |
| Diplomarbeit-Impl-Session-Handover-Ort | UNKLAR | — | MEMORY.md:54 | GELANDET (Referenz) | -- | Memory/Tasks |
| Doku-Policy neue Session: Docs+Ledger, nur User-Technik | AUFGABE | — | MEMORY.md:54 | GELANDET | -- | Memory/Tasks |
| Kontext-Neugruendung Workflow-Backup-Ort | UNKLAR | — | MEMORY.md:54 | GELANDET (Referenz) | -- | Memory/Tasks |
| NIE EINE FLOTTE GEBAUT (Identitaets-Umbauten) | REGRESSION | — | MEMORY.md:57 | OFFEN-REGRESSION (kostenlos nur bis 26.08., danach teuer; vor F2 ordnen) | -- | Memory/Tasks |
| VERSIONIERUNG: SOLL je Stufe (CEB nur Mess+System) | FEATURE | — | MEMORY.md:58 | GEPLANT | -- | Memory/Tasks |
| GLIEDER-REIHENFOLGE: ZWEI WELTEN (Lager vs. aussen) | FEATURE | — | MEMORY.md:59 | GEBAUT | S-6a, Task #15 | Memory/Tasks |
| LAGER-ORDNUNG != STUFEN-ORDNUNG (zwei Kaskaden) | FEATURE | — | MEMORY.md:61 | dokumentiert (D-12) | -- | Memory/Tasks |
| STEMPEL-REIHENFOLGE: SYSTEM VOR ORGAN | FEATURE | — | MEMORY.md:62 | GEBAUT (seit S-6a/#15) | -- | Memory/Tasks |
| GATTUNG+GENUS = Interface-Hierarchie (keine Achsen) | FEATURE | — | MEMORY.md:63 | GEPLANT/dokumentiert | -- | Memory/Tasks |
| GENUS_impl Abstract Factory -> EIN Tier-Binary | FEATURE | — | MEMORY.md:63 | GEPLANT/dokumentiert | -- | Memory/Tasks |
| NUR VIER BINARY-TYPEN (Planer/CEB/Tier/Hybrid, CEB traegt 8 Behelfs-CLIs) | FEATURE | — | MEMORY.md:64 | GEPLANT/dokumentiert | -- | Memory/Tasks |
| HYBRID = eigene Gattung (Heuristik-Adapter, Reroute-Genus) | FEATURE | — | MEMORY.md:65 | GEPLANT | -- | Memory/Tasks |
| Hybrid Owner-Entscheide 09.08. (vier Blocker) | OWNER-ENTSCHEID | — | MEMORY.md:65 | GELANDET | -- | Memory/Tasks |
| SINGLE+HYBRID-Zweig symmetrisch nach Auswerten | FEATURE | — | MEMORY.md:65 | GEPLANT | -- | Memory/Tasks |
| 18 ORGAN-ACHSEN (nicht 19) | FEATURE | — | MEMORY.md:66 | GEPLANT/dokumentiert | -- | Memory/Tasks |
| KEINE flat_hash_map -- Swisstable Gattung-Map, nicht Container | OWNER-ENTSCHEID | — | MEMORY.md:66 | GELANDET | -- | Memory/Tasks |
| 8-STATIONEN-KETTE dokumentiert, REAL SIND 15 STATIONEN | REGRESSION | — | MEMORY.md:66 | OFFEN-REGRESSION (Doku 8 vs. real 15, gemaess KON97) | -- | Memory/Tasks |
| CT/Achsen/Gattung-Verweis (18 Eintraege) | UNKLAR | — | MEMORY.md:67 | GELANDET (Verweisziel MEMORY-DETAIL.md) | -- | Memory/Tasks |
| Thesis-Verweis (Eigentum/Lizenz/HDR/DE fuehrt/Handwerk, 17 Eintraege) | UNKLAR | — | MEMORY.md:70 | GELANDET (Verweisziel MEMORY-DETAIL.md) | -- | Memory/Tasks |
| PIPELINES STRENG SEQUENTIELL (sonst OOM) | OWNER-ENTSCHEID | — | MEMORY.md:73 | GELANDET | -- | Memory/Tasks |
| LOKALE Maschine IST prod1 (kein dritter Host) | UNKLAR | — | MEMORY.md:74 | GELANDET | -- | Memory/Tasks |
| BASTION-ALIAS EXISTIERT NICHT | UNKLAR | — | MEMORY.md:75 | GELANDET (Workaround: ssh -i Cluster/keys/cluster root@10.0.10.201, pve1) | -- | Memory/Tasks |
| References/Infra-Restverweis (-O0 vs Release, Cluster read-only, Infra+Vault) | UNKLAR | — | MEMORY.md:76 | GELANDET (Verweisziel MEMORY-DETAIL.md) | -- | Memory/Tasks |
| MESS-PERMUTATION DYNAMISCH >32 (nie statische Nenner) | OWNER-ENTSCHEID | — | MEMORY.md:79 | GELANDET | nur S-19 rechnet | Memory/Tasks |
| allow_failure VERBOTEN seit 06.07. (Zelle=Warnung, Job=rot) | OWNER-ENTSCHEID | — | MEMORY.md:80 | GELANDET | -- | Memory/Tasks |
| Gesamte Pipeline immer hart gruen | OWNER-ENTSCHEID | — | MEMORY.md:80 | GELANDET | -- | Memory/Tasks |
| Messung-Verweis E-Ebenen/CI-golden/Rueckschrieb (27 Eintraege) | UNKLAR | — | MEMORY.md:81 | GELANDET (Verweisziel MEMORY-DETAIL.md) | -- | Memory/Tasks |
| Messung-Verweis Weitere (Mess-Visitor/Steuerkanal/Arenen/CSV) | UNKLAR | — | MEMORY.md:82 | GELANDET (Verweisziel MEMORY-DETAIL.md) | -- | Memory/Tasks |
| MEINE Arbeitsfehler K1-K17 (Lead-Berichte nie uebernehmen) | REGRESSION | — | MEMORY.md:85 | BEHOBEN (Register gefuehrt) | -- | Memory/Tasks |
| K11 PIPESTATUS | REGRESSION | — | MEMORY.md:85 | BEHOBEN | -- | Memory/Tasks |
| K13 Koeder beisst | REGRESSION | — | MEMORY.md:85 | BEHOBEN | -- | Memory/Tasks |
| K15 juengste KON+Bauplan (auch ~/backups-workflow) | REGRESSION | — | MEMORY.md:85 | BEHOBEN | -- | Memory/Tasks |
| K16 Schreiberwechsel-Protokoll | REGRESSION | — | MEMORY.md:85 | BEHOBEN | -- | Memory/Tasks |
| K17 Lande-Merge ohne Endstand-Kombibau (CI nie Erstpruefung) | REGRESSION | — | MEMORY.md:85 | BEHOBEN (Lehre gezogen; Sonderorder 20.08. verbraucht) | -- | Memory/Tasks |
| ALLES IST GEPLANT (unloesbare Frage = eigene Luecke, 12W-Explore) | OWNER-ENTSCHEID | — | MEMORY.md:86 | GELANDET | -- | Memory/Tasks |
| GEDAECHTNIS ZUERST (Gedaechtnis->Review->Explore->Design->Bau->Verify) | AUFGABE | — | MEMORY.md:87 | GELANDET | -- | Memory/Tasks |
| EXPLORE PFLICHT je Welle+Strang | OWNER-ENTSCHEID | — | MEMORY.md:88 | GELANDET | -- | Memory/Tasks |
| Explore 2-stufig (Sonnet5 max kartiert, dann selbst gegenlesen) | AUFGABE | — | MEMORY.md:88 | GELANDET | -- | Memory/Tasks |
| 6+ parallele Straenge + ultracode immer frei (disjunkt) | OWNER-ENTSCHEID | — | MEMORY.md:89 | GELANDET | -- | Memory/Tasks |
| DEFEKT = IMMER BEHEBEN (egal wie gross) | OWNER-ENTSCHEID | — | MEMORY.md:90 | GELANDET | -- | Memory/Tasks |
| BLANKO-GO (alle Phasen autonom am Stueck, Melden != fragen) | OWNER-ENTSCHEID | — | MEMORY.md:90 | GELANDET | -- | Memory/Tasks |
| Bestand invalidieren ist gewollt, kein Migrationszwang | OWNER-ENTSCHEID | — | MEMORY.md:90 | GELANDET | -- | Memory/Tasks |
| RANGFOLGE OWNER > PLAN > THESIS (erst Ausschluss, dann MERGEN) | OWNER-ENTSCHEID | — | MEMORY.md:91 | GELANDET | -- | Memory/Tasks |
| docs/termine ist die Primaerquelle | OWNER-ENTSCHEID | — | MEMORY.md:91 | GELANDET | -- | Memory/Tasks |
| xlsx IST DIE AUSGABE (CSV nie Skip bei gleicher Binary) | OWNER-ENTSCHEID | — | MEMORY.md:92 | GELANDET | -- | Memory/Tasks |
| Owner-KERNe 06.08. abends (Frist Messkette CEB) | OWNER-ENTSCHEID | — | MEMORY.md:92 | GELANDET | -- | Memory/Tasks |
| LUECKE = BEHEBUNG PFLICHT (kein Randfall, kein Hinweis-statt-Ernst) | OWNER-ENTSCHEID | — | MEMORY.md:93 | GELANDET | -- | Memory/Tasks |
| Behauptungen verifizieren, Layer-Vertraege halten | AUFGABE | — | MEMORY.md:94 | GELANDET | -- | Memory/Tasks |
| "bis jemand anderes macht es" ist immer mein Auftrag | OWNER-ENTSCHEID | — | MEMORY.md:94 | GELANDET | -- | Memory/Tasks |
| Claude Code Arbeitsweise v2 konsolidiert | AUFGABE | — | MEMORY.md:94 | GELANDET | -- | Memory/Tasks |
| ASCII-only Kommentare + Selbstcheck-Zeile | AUFGABE | — | MEMORY.md:95 | GELANDET | -- | Memory/Tasks |
| Par.61 Dual-Weg-Pflicht (Debug parallel Multi-Maschine) | OWNER-ENTSCHEID | — | MEMORY.md:95 | GELANDET | -- | Memory/Tasks |
| E-21 TODO-Stack LIFO, verbose Owner-Fragen, Vollpersistenz | AUFGABE | — | MEMORY.md:95 | GELANDET | -- | Memory/Tasks |
| Workflow-Backup SOFORT bei Fertigstellung | OWNER-ENTSCHEID | — | MEMORY.md:95 | GELANDET | -- | Memory/Tasks |
| Stand-Anker sind HISTORIE -- lebender Stand = Ledger + super docs/sessions/ | OWNER-ENTSCHEID | — | MEMORY.md:98 | GELANDET | -- | Memory/Tasks |
| DIFF-HYGIENE-Wache misst PUSH-lokal, nie kumulativ | AUFGABE | — | MEMORY.md:99 | GELANDET | -- | Memory/Tasks |
| EIN GRUENES GATE deckt nur seinen Gegenstand (beide Mengen nennen) | AUFGABE | — | MEMORY.md:100 | GELANDET | -- | Memory/Tasks |
| FALLEN-REGISTER Werkzeuge und CI (grep -v /build frisst /builder/) | REGRESSION | — | MEMORY.md:101 | OFFEN-REGRESSION | -- | Memory/Tasks |
| ugrep ASCII-Gate stille Null (Falle) | REGRESSION | — | MEMORY.md:101 | OFFEN-REGRESSION | -- | Memory/Tasks |
| LEERES pgrep != TOTER Hintergrundlauf | REGRESSION | — | MEMORY.md:102 | BEHOBEN (Lebendprobe=Log-Wachstum+Endmarke statt Prozessname) | -- | Memory/Tasks |
| OV-NUMMERN KEIN Autoritaetsbeleg | REGRESSION | — | MEMORY.md:103 | BEHOBEN (Gegenstand im Roh-Transkript pruefen) | -- | Memory/Tasks |
| VAULT-Dateien NIE greppen, nur blind verarbeiten | OWNER-ENTSCHEID | — | MEMORY.md:104 | GELANDET (mapfile, rueckwaerts bis HTTP 200) | -- | Memory/Tasks |
| gitleaks-Koeder MUSS aus einer Regel der wirksamen Config stammen | REGRESSION | — | MEMORY.md:105 | BEHOBEN (glpat-+20 gilt, AWS beisst nicht) | -- | Memory/Tasks |
| gitleaks push: Bereich statt geratener Klontiefe | REGRESSION | — | MEMORY.md:106 | BEHOBEN (stdin: --config PFLICHT) | -- | Memory/Tasks |
| Fallen-Sammlung 08.08. (gitleaks/AWS/Codex/pgrep) | REGRESSION | — | MEMORY.md:106 | GELANDET (dokumentiert) | -- | Memory/Tasks |
| Koeder-Literale in Commit-Texten maskieren (stdin-Wache triggert sonst) | AUFGABE | — | MEMORY.md:107 | GELANDET | -- | Memory/Tasks |
| Transkript-Extraktor: DREI Pfade (Union aus 3 Quellen) | FEATURE | — | MEMORY.md:108 | GEBAUT | -- | Memory/Tasks |
| MEMORY-DETAIL.md ausgelagert 10.08.2026 (MEMORY.md Lese-Limit 20.691/24.400 Byte) | UNKLAR | — | MEMORY-DETAIL.md:3-5 | GELANDET (nichts entfernt) | -- | Memory/Tasks |
| C++/Drogon u.a. Sprachen sind Feature-Quellen | AUFGABE | — | MEMORY-DETAIL.md:8 | GELANDET | -- | Memory/Tasks |
| Baseline-System in Stein gemeisselt (Layering) | OWNER-ENTSCHEID | — | MEMORY-DETAIL.md:8 | GELANDET | -- | Memory/Tasks |
| Umbrella-SOLL-Struktur trackt alles ausser Baseline-Zellen | FEATURE | — | MEMORY-DETAIL.md:8 | GEPLANT | -- | Memory/Tasks |
| Standardprozess-Research zu Product-Matrix 3D | AUFGABE | — | MEMORY-DETAIL.md:8 | GEPLANT | -- | Memory/Tasks |
| Vendoring-Doktrin: ordered vendor, faithful, selfcontained | OWNER-ENTSCHEID | — | MEMORY-DETAIL.md:8 | GELANDET | -- | Memory/Tasks |
| ext/-Paper-Organisation trennt Achsen von Paper-Code | FEATURE | — | MEMORY-DETAIL.md:8 | GEPLANT | -- | Memory/Tasks |
| Kein Python in der Buildchain | OWNER-ENTSCHEID | — | MEMORY-DETAIL.md:8 | GELANDET | -- | Memory/Tasks |
| 8er-Docker Build-Matrix (volle Plattform-Doktrin) | FEATURE | — | MEMORY-DETAIL.md:8 | GEPLANT | -- | Memory/Tasks |
| buildsystem.xml haende-weg, parallel CI/CMake | OWNER-ENTSCHEID | — | MEMORY-DETAIL.md:8 | GELANDET | -- | Memory/Tasks |
| PRT-ART konsumiert Cache-Engine (3 Rollen) | FEATURE | — | MEMORY-DETAIL.md:8 | GEPLANT | -- | Memory/Tasks |
| 286 = Forschung (Cache-Engine-Research vs. CacheEngine-all Split-TODO) | AUFGABE | — | MEMORY-DETAIL.md:8 | OFFEN | -- | Memory/Tasks |
| Diplomarbeit-Module-Spiegel geloescht, comdare-Module wiederverwenden | REGRESSION | — | MEMORY-DETAIL.md:8 | BEHOBEN | -- | Memory/Tasks |
| Kette Par.38 (Planer->Mess->CEB->System->Tier->Organ->Hybrid) | FEATURE | — | MEMORY-DETAIL.md:11 | GEPLANT | -- | Memory/Tasks |
| Recursive Dock .so (Planer/CEB/Tier ABI-stabil) | FEATURE | — | MEMORY-DETAIL.md:11 | GEPLANT | -- | Memory/Tasks |
| Registry=ANGEBOT (Anwender-XML, POM-Resolver, Planer) | FEATURE | — | MEMORY-DETAIL.md:11 | GEPLANT | -- | Memory/Tasks |
| 2 Registry (unified experiment.xml + system-registry.xml) | FEATURE | — | MEMORY-DETAIL.md:11 | GEPLANT | -- | Memory/Tasks |
| CMake PRT (Interface static, Registry-Pfade, PRT-Modul) | FEATURE | — | MEMORY-DETAIL.md:11 | GEPLANT | -- | Memory/Tasks |
| flach=Baum (flat SystemAxis-Ordner, deep Tier-Tree, dynamic-only Columns) | FEATURE | — | MEMORY-DETAIL.md:11 | GEPLANT | -- | Memory/Tasks |
| Tier-Binary incremental Caching | FEATURE | — | MEMORY-DETAIL.md:11 | GEPLANT | -- | Memory/Tasks |
| Cache-Engine Standalone-Build-Pipeline | FEATURE | — | MEMORY-DETAIL.md:14 | GEPLANT/GEBAUT | -- | Memory/Tasks |
| XML Kommentar Doppelbindestrich-Falle | REGRESSION | — | MEMORY-DETAIL.md:14 | OFFEN-REGRESSION | -- | Memory/Tasks |
| Drift-Wache faengt Anhaengen nicht (Luecke) | REGRESSION | — | MEMORY-DETAIL.md:14 | OFFEN-REGRESSION | -- | Memory/Tasks |
| git -C immer mit Pfad, cwd-Falle | REGRESSION | — | MEMORY-DETAIL.md:14 | BEHOBEN (Regel etabliert) | -- | Memory/Tasks |
| Codex UTF8 Mojibake Double-Encoding | REGRESSION | — | MEMORY-DETAIL.md:14 | OFFEN-REGRESSION | -- | Memory/Tasks |
| Documentation Master-Paths | UNKLAR | — | MEMORY-DETAIL.md:14 | GELANDET (Referenz) | -- | Memory/Tasks |
| GitLab PAT-Format Punkte-Regex | UNKLAR | — | MEMORY-DETAIL.md:14 | GELANDET (Referenz) | -- | Memory/Tasks |
| GitLab .de abgeschaltet, .local kanonisch (scoped CA) | REGRESSION | — | MEMORY-DETAIL.md:14 | BEHOBEN (umgestellt) | -- | Memory/Tasks |
| Cluster VLAN-Tabelle SNI-Standard-Pattern | UNKLAR | — | MEMORY-DETAIL.md:14 | GELANDET (Referenz) | -- | Memory/Tasks |
| prod1 comdare Env-Setup | UNKLAR | — | MEMORY-DETAIL.md:14 | GELANDET (Referenz) | -- | Memory/Tasks |
| CI-Runner ICE Cold-Cache-Instabilitaet | REGRESSION | — | MEMORY-DETAIL.md:14 | OFFEN-REGRESSION | -- | Memory/Tasks |
| Infra-Agent Memory-Handover 322 Location | UNKLAR | — | MEMORY-DETAIL.md:14 | GELANDET (Referenz) | -- | Memory/Tasks |
| Desktop Plain-Backup Diplomarbeit | AUFGABE | — | MEMORY-DETAIL.md:14 | GELANDET | -- | Memory/Tasks |
| main-FF Watcher pinnt SHA, nicht rev-parse HEAD | REGRESSION | — | MEMORY-DETAIL.md:14 | BEHOBEN | -- | Memory/Tasks |
| Freeze-Nachrichten eindeutig, nur Antwort vs. Arbeitsauftrag | AUFGABE | — | MEMORY-DETAIL.md:17 | GELANDET | -- | Memory/Tasks |
| Task-Zuweisung ist kein Start-Signal, Gates respektieren, zuerst vorschlagen | OWNER-ENTSCHEID | — | MEMORY-DETAIL.md:17 | GELANDET | -- | Memory/Tasks |
| Agent-Working-Tree-Freeze nach Paketmeldung | AUFGABE | — | MEMORY-DETAIL.md:17 | GELANDET | -- | Memory/Tasks |
| User-KERN-Beschreibung ist immer Gesetz, Abweichung ist Regression | OWNER-ENTSCHEID | — | MEMORY-DETAIL.md:17 | GELANDET | -- | Memory/Tasks |
| Autonomie-Modus: Plan autonom durchziehen | OWNER-ENTSCHEID | — | MEMORY-DETAIL.md:17 | GELANDET | -- | Memory/Tasks |
| VOR+NACH jeder Aufgabe ultracode plus Autonomie-Scope | AUFGABE | — | MEMORY-DETAIL.md:17 | GELANDET | -- | Memory/Tasks |
| Jede Aufgabe ultracode-Planungssession, Ledger, alle Plandocs | AUFGABE | — | MEMORY-DETAIL.md:17 | GELANDET | -- | Memory/Tasks |
| Per Paket ultracode-Planung vor Ausfuehrung | AUFGABE | — | MEMORY-DETAIL.md:17 | GELANDET | -- | Memory/Tasks |
| Statischer Dispatch, kein Runtime-Switch | OWNER-ENTSCHEID | — | MEMORY-DETAIL.md:20 | GELANDET | -- | Memory/Tasks |
| Codegen compile-time-only, kein Runtime | OWNER-ENTSCHEID | — | MEMORY-DETAIL.md:20 | GELANDET | -- | Memory/Tasks |
| CRTP+Concept-Guard-Mix-Pattern | FEATURE | — | MEMORY-DETAIL.md:20 | GEPLANT | -- | Memory/Tasks |
| Nur GoF-Lehrbuch-Design-Patterns, Zero-Cost-Metaprog | OWNER-ENTSCHEID | — | MEMORY-DETAIL.md:20 | GELANDET | -- | Memory/Tasks |
| MOF Meta-driven Concept-Hardening-Pattern | FEATURE | — | MEMORY-DETAIL.md:20 | GEPLANT | -- | Memory/Tasks |
| Metaprogrammierung compile-time zwingend durchsetzen (CT->RT) | OWNER-ENTSCHEID | — | MEMORY-DETAIL.md:20 | GELANDET | -- | Memory/Tasks |
| Kein std::variant, statische Achsen-Bloat vermeiden | OWNER-ENTSCHEID | — | MEMORY-DETAIL.md:20 | GELANDET | -- | Memory/Tasks |
| Haupt-Achse static/Unter-Achse runtime, Chain CT-Wiring | FEATURE | — | MEMORY-DETAIL.md:21 | GEPLANT | -- | Memory/Tasks |
| Achsen-Thema/Modul/Framework/Metaprogramming/Interface (Kopf-Framework) | FEATURE | — | MEMORY-DETAIL.md:21 | GEPLANT | -- | Memory/Tasks |
| Keine Whole-Tier-Achsen, Genus-Configurator | OWNER-ENTSCHEID | — | MEMORY-DETAIL.md:21 | GELANDET | -- | Memory/Tasks |
| Systemachsen-Freigabe, Organachsen-Durchsetzung/Ressourcen | FEATURE | — | MEMORY-DETAIL.md:21 | GEPLANT | -- | Memory/Tasks |
| Fehlerklassen Pflicht fuer alle Achsen/Unterachsen/Algorithmen | OWNER-ENTSCHEID | — | MEMORY-DETAIL.md:21 | GELANDET | -- | Memory/Tasks |
| Q2 Option C Erweiterungshardware = sechste Systemachse | OWNER-ENTSCHEID | — | MEMORY-DETAIL.md:21 | GELANDET | -- | Memory/Tasks |
| Compiler-Systemachse traegt dynamische XML-Unterachsen | FEATURE | — | MEMORY-DETAIL.md:21 | GEPLANT | -- | Memory/Tasks |
| AP15 Container-Gattung comdare-Container-Sequence-Plan (Interface-Familie) | FEATURE | — | MEMORY-DETAIL.md:22 | GEPLANT | -- | Memory/Tasks |
| Gattung eigenes Genus, eigenes ABI, nonintersecting mutually usable | OWNER-ENTSCHEID | — | MEMORY-DETAIL.md:22 | GELANDET | -- | Memory/Tasks |
| Command-Pattern Achsen-Mess-Visitor Container in SA | FEATURE | — | MEMORY-DETAIL.md:22 | GEPLANT | -- | Memory/Tasks |
| Observable-Wrapper muss Concept-Members forwarden (Falle) | REGRESSION | — | MEMORY-DETAIL.md:22 | OFFEN-REGRESSION | -- | Memory/Tasks |
| E1-E4 Experiment-Maschinerie und Konsolidierung | FEATURE | — | MEMORY-DETAIL.md:25 | GEPLANT | -- | Memory/Tasks |
| E4-XML autoritative Bauanleitung, CEB orchestriert | FEATURE | — | MEMORY-DETAIL.md:25 | GEPLANT | -- | Memory/Tasks |
| Organ/System-Achsen Measurement eigene abstrakte Root (Blood) | FEATURE | — | MEMORY-DETAIL.md:25 | GEPLANT | -- | Memory/Tasks |
| E-Schichten separat fertigstellen, top-down | AUFGABE | — | MEMORY-DETAIL.md:25 | GELANDET | -- | Memory/Tasks |
| Max. Tiefe bei Problemen, saubersten Zustand | AUFGABE | — | MEMORY-DETAIL.md:25 | GELANDET | -- | Memory/Tasks |
| Elaborate Dossier fuer komplexe Planung | AUFGABE | — | MEMORY-DETAIL.md:25 | GELANDET | -- | Memory/Tasks |
| Axes-Optimization-Semantics Deep-Research Observer-Strategy (Min/Max) | FEATURE | — | MEMORY-DETAIL.md:26 | GEPLANT | -- | Memory/Tasks |
| Heuristik-Messkurven-Typsystem Chain-of-Responsibility | FEATURE | — | MEMORY-DETAIL.md:26 | GEPLANT | -- | Memory/Tasks |
| CEB drei Modi Arbeitsmodus Hot-Tier-Switching | FEATURE | — | MEMORY-DETAIL.md:26 | GEPLANT | -- | Memory/Tasks |
| Measurement-Modes Debug=parallel, Measure=singlethread, Planer generiert CI/CMake | FEATURE | — | MEMORY-DETAIL.md:26 | GEPLANT | -- | Memory/Tasks |
| Measurement-Failure-Visibility: Fehler->CSV failed, nicht null, plus Log | FEATURE | — | MEMORY-DETAIL.md:26 | GEPLANT | -- | Memory/Tasks |
| Mess-Tooling Default vereint EINE CEB | OWNER-ENTSCHEID | — | MEMORY-DETAIL.md:26 | GELANDET | -- | Memory/Tasks |
| New golden all axes XML >320 (golden 2^17) | AUFGABE | — | MEMORY-DETAIL.md:26 | GEPLANT | -- | Memory/Tasks |
| CI-Gesamtlauf ist Messung abgeschaltet, PDF kompiliert | OWNER-ENTSCHEID | — | MEMORY-DETAIL.md:27 | GELANDET | -- | Memory/Tasks |
| Autonomous Measurement via CI-Job autorisiert | OWNER-ENTSCHEID | — | MEMORY-DETAIL.md:27 | GELANDET | -- | Memory/Tasks |
| Production-Track voller Golden-Run findet Fehler | FEATURE | — | MEMORY-DETAIL.md:27 | GELANDET | -- | Memory/Tasks |
| CI gruen messfaehig nur bei punktuellen Refactorings | AUFGABE | — | MEMORY-DETAIL.md:27 | GELANDET | -- | Memory/Tasks |
| Increments muessen architekturkonform sein, nicht nur gruen | OWNER-ENTSCHEID | — | MEMORY-DETAIL.md:27 | GELANDET | -- | Memory/Tasks |
| Mess-Ergebnis-Rueckschreibung-Pipeline persistiert (WRITE-Token) | FEATURE | — | MEMORY-DETAIL.md:28 | GEPLANT/GEBAUT | -- | Memory/Tasks |
| Measurement-Writeback-Token 288 secure (Token 54) | UNKLAR | — | MEMORY-DETAIL.md:28 | GELANDET (Referenz) | -- | Memory/Tasks |
| super-CI kann neue CE-Submodule-Commits nicht fetchen (Deploy) | REGRESSION | — | MEMORY-DETAIL.md:28 | OFFEN-REGRESSION | -- | Memory/Tasks |
| Tier-Metaphor System-Axis-Properties, Graph=PHANTOM | REGRESSION | — | MEMORY-DETAIL.md:28 | OFFEN-REGRESSION (Graph existiert nur als Phantom) | -- | Memory/Tasks |
| CE-Facade Super-Subbuild verify+clang-format prod1-Gap (~15 vendored) | REGRESSION | — | MEMORY-DETAIL.md:28 | OFFEN-REGRESSION | -- | Memory/Tasks |
| Selbst implementieren ab 10.07., Codex abgeloest | OWNER-ENTSCHEID | — | MEMORY-DETAIL.md:29 | GELANDET | -- | Memory/Tasks |
| Alt-Golden darf brechen, erst additiv, dann aufraeumen unter Absprache | OWNER-ENTSCHEID | — | MEMORY-DETAIL.md:29 | GELANDET | -- | Memory/Tasks |
| Dual-Verifikation Baremetal lokal+CI synchron gruen | AUFGABE | — | MEMORY-DETAIL.md:29 | VERTAGT (GEPARKT) | -- | Memory/Tasks |
| Autonomous-Overnight-Note offene Entscheidungen fuer Morgen | AUFGABE | — | MEMORY-DETAIL.md:29 | VERTAGT (Schlaeft) | -- | Memory/Tasks |
| Vortrag nach Abgabe, technischer Hintergrund zuerst | AUFGABE | — | MEMORY-DETAIL.md:32 | GEPLANT | -- | Memory/Tasks |
| Thesis Habich-Restruktur allgemein->speziell | AUFGABE | — | MEMORY-DETAIL.md:32 | GELANDET | -- | Memory/Tasks |
| Thesis-LaTeX-Struktur bilingual (DE+EN) | FEATURE | — | MEMORY-DETAIL.md:32 | GEPLANT | -- | Memory/Tasks |
| Thesis-Kernbeitrag = Achsen-Library | UNKLAR | — | MEMORY-DETAIL.md:32 | GELANDET (Referenz) | -- | Memory/Tasks |
| Thesis Design-Space Fachvokabular (Idreos) | UNKLAR | — | MEMORY-DETAIL.md:32 | GELANDET (Referenz) | -- | Memory/Tasks |
| Thesis universelle Baum-Anatomie und Prinzipsuche | FEATURE | — | MEMORY-DETAIL.md:32 | GEPLANT | -- | Memory/Tasks |
| Diplomarbeit-Design ist Quelle der Implementierung (LaTeX=Quelle) | OWNER-ENTSCHEID | — | MEMORY-DETAIL.md:32 | GELANDET | -- | Memory/Tasks |
| Thesis nur User-Ideen persistieren | OWNER-ENTSCHEID | — | MEMORY-DETAIL.md:33 | GELANDET | -- | Memory/Tasks |
| Thesis linear, Aufgabenstellung, keine Loesung vorweg | OWNER-ENTSCHEID | — | MEMORY-DETAIL.md:33 | GELANDET | -- | Memory/Tasks |
| Thesis Sequential-Referencing-Regel (Verweis rueckwaerts) | OWNER-ENTSCHEID | — | MEMORY-DETAIL.md:33 | GELANDET | -- | Memory/Tasks |
| Thesis Tabellen-Legende-Notiz unter Float | AUFGABE | — | MEMORY-DETAIL.md:33 | GELANDET | -- | Memory/Tasks |
| Thesis Divide-and-Conquer (XX_op) | AUFGABE | — | MEMORY-DETAIL.md:33 | GELANDET | -- | Memory/Tasks |
| Text-Agent-Sessions gehoeren in Thesis, nicht Impl-Repo | OWNER-ENTSCHEID | — | MEMORY-DETAIL.md:33 | GELANDET | -- | Memory/Tasks |
| Thesis Git-Topologie Remotes+Overleaf | UNKLAR | — | MEMORY-DETAIL.md:34 | GELANDET (Referenz) | -- | Memory/Tasks |
| TUD Informatik Thesis-Format-Norm | UNKLAR | — | MEMORY-DETAIL.md:34 | GELANDET (Referenz) | -- | Memory/Tasks |
| Thesis-Achsen T-IDs vs. Dir-Numbers | UNKLAR | — | MEMORY-DETAIL.md:34 | GELANDET (Referenz) | -- | Memory/Tasks |
| Thesis-Build-Check .blg AlphaDIN | AUFGABE | — | MEMORY-DETAIL.md:34 | GELANDET | -- | Memory/Tasks |
| Post-v3-Anforderungen SO/ABI/Driver-Split/CLI | FEATURE | — | MEMORY-DETAIL.md:37 | GEPLANT | -- | Memory/Tasks |
| Planer-Mess-Schema Kern/Pruefling Replace/Merge/Fulljoin | FEATURE | — | MEMORY-DETAIL.md:37 | GEPLANT | -- | Memory/Tasks |
| Par.62 Planer Universal Cache Log Claim Compare | FEATURE | — | MEMORY-DETAIL.md:37 | GEPLANT | -- | Memory/Tasks |
| Bestandslog-Zielbild Ordner-Kaskaden Dual-ccache | FEATURE | — | MEMORY-DETAIL.md:37 | GEPLANT | -- | Memory/Tasks |
| Bestandslog-Abnahmen Baum-Heuristik-Stempel | FEATURE | — | MEMORY-DETAIL.md:37 | GEPLANT | -- | Memory/Tasks |
| Lager-Baeume xlsx-Doktrin | OWNER-ENTSCHEID | — | MEMORY-DETAIL.md:37 | GELANDET | -- | Memory/Tasks |
| Achsen-Neuordnung bindende Sortierung, Regressionen | OWNER-ENTSCHEID | — | MEMORY-DETAIL.md:37 | GELANDET | -- | Memory/Tasks |
| Diplom finale Linie, Identitaet, Overleaf | UNKLAR | — | MEMORY-DETAIL.md:37 | GELANDET (Referenz) | -- | Memory/Tasks |
| EIGENTUM: ZWEI ENTITAETEN (Thesis=BEP privat, CE+PRT-ART=BEP Venture UG); Abk. "BEP" fuer Person VERBOTEN | OWNER-ENTSCHEID | — | MEMORY-DETAIL.md:43 | GELANDET | -- | Memory/Tasks |
| LIZENZ je Repo (super=Apache, ce+PRT-ART=Forschung frei/proprietaer, Diplomarbeit=nur Copyright BEP) | OWNER-ENTSCHEID | — | MEMORY-DETAIL.md:44 | GELANDET (10.08.) | -- | Memory/Tasks |
| HDR = Thesis-Zusage (3 Praesens-Stellen) | OWNER-ENTSCHEID | — | MEMORY-DETAIL.md:45 | GELANDET | -- | Memory/Tasks |
| DE FUEHRT IMMER, EN zieht nach (Lint via chktex NN) | OWNER-ENTSCHEID | — | MEMORY-DETAIL.md:45 | GELANDET | -- | Memory/Tasks |
| LOKAL -O0 gegen CI Release -- Beobachtbarkeits-Luecke | REGRESSION | — | MEMORY-DETAIL.md:52 | OFFEN-REGRESSION (Koeder wuerfeln auf beiden Stufen) | -- | Memory/Tasks |
| Diplomarbeit-Impl-Agent: Cluster read-only, keine Infra | OWNER-ENTSCHEID | — | MEMORY-DETAIL.md:53 | GELANDET | -- | Memory/Tasks |
| Infra immer ultracode ueber Sessions zuerst | AUFGABE | — | MEMORY-DETAIL.md:53 | GELANDET | -- | Memory/Tasks |
| Infra-Autonomie-Freigabe, Cluster reserviert | OWNER-ENTSCHEID | — | MEMORY-DETAIL.md:53 | GELANDET | -- | Memory/Tasks |
| CI/Infra blockiert -> lokal weiter, Doppel-Verify Mode A | AUFGABE | — | MEMORY-DETAIL.md:53 | GELANDET | -- | Memory/Tasks |
| MESS-VISITOR am Genus-Interface (Sidecar ist falsch) | FEATURE | — | MEMORY-DETAIL.md:59 | GEPLANT | -- | Memory/Tasks |
| Variadische Mess-Template nicht durch die Kaskade gereicht | REGRESSION | — | MEMORY-DETAIL.md:59 | OFFEN-REGRESSION (kein Signal im Tier-Binary) | -- | Memory/Tasks |
| Steuerkanal Planer-CEB, sechs Steuerdocks variadisch | FEATURE | — | MEMORY-DETAIL.md:60 | GEPLANT (Release GESAMMELT) | -- | Memory/Tasks |
| MeasureStorage-Modul Custom-Arena, append-measure-to-latex (ZWEI Arenen) | FEATURE | — | MEMORY-DETAIL.md:60 | GEPLANT | -- | Memory/Tasks |
| Drift-Gate = 18x Durchlaeufe je Zelle-Kapazitaet | FEATURE | — | MEMORY-DETAIL.md:61 | GEPLANT | -- | Memory/Tasks |
| CSV ist Strategy-Pattern der xlsx-Erzeugung (Richtung xlsx->csv) | FEATURE | — | MEMORY-DETAIL.md:61 | GEPLANT | -- | Memory/Tasks |
| Task-Board-Dump Header: VOLLSTAENDIG 106 Tasks (Stand 20.08. ~15:30Z) | UNKLAR | — | task_board_dump.md:1-2 | GELANDET (Selbstauskunft der Quelle) | -- | Memory/Tasks |
| #40 ULTRACODE-NACHIMPLEMENTIERUNG (38 NE-Posten/20 Auftraege) | AUFGABE | — | task_board_dump.md:14 | OFFEN | -- | Memory/Tasks |
| #40 NE-01-Zahlenkorrektur | OWNER-ENTSCHEID | — | task_board_dump.md:14 | GELANDET (bindend) | -- | Memory/Tasks |
| #48 XML-PUBLIKATIONS-SEKTION (4 Klassen) | AUFGABE | — | task_board_dump.md:15 | OFFEN (Di 25.08., mit #18/#57) | -- | Memory/Tasks |
| #49 Staffelungs-Design-Dokument | AUFGABE | — | task_board_dump.md:16 | OFFEN (VOR W4, nach Owner-V7-Antwort) | -- | Memory/Tasks |
| #49 C1-Widerspruch | OWNER-ENTSCHEID | — | task_board_dump.md:16 | OFFEN (wartet auf Owner) | -- | Memory/Tasks |
| #53 DESIGN MESS-ACHSEN-FAMILIE | FEATURE | — | task_board_dump.md:17 | IN_PROGRESS (PMC-Schwester-Design zuerst, dann Lastsequenz; Owner-Vorlage je Achse vor Bau) | -- | Memory/Tasks |
| #57 LAGER-VOLLAUSBAU (6 Punkte) | AUFGABE | — | task_board_dump.md:18 | OFFEN (Owner 15.08. "ALLE schliessen"; Di 25.08. mit #18/#48) | -- | Memory/Tasks |
| #77 THESIS-AUDIT-EINARBEITUNG Runde 1 | AUFGABE | — | task_board_dump.md:23 | OFFEN (nach F2 Fr 21.08.) | -- | Memory/Tasks |
| #82 I-PMC-2/3 bauen | AUFGABE | — | task_board_dump.md:24 | OFFEN (Owner-GO 17.08.; Vorstaffel WE 22./23.) | -- | Memory/Tasks |
| #83 PMC fail-loud-Paket | AUFGABE | — | task_board_dump.md:25 | OFFEN (Owner-GO 17.08.; eigener Zug vor Trigger 26.08.) | -- | Memory/Tasks |
| #84 Infra-Rotation | AUFGABE | — | task_board_dump.md:26 | OFFEN (wartet auf Wartungsfenster, vor Mi 26.!) | -- | Memory/Tasks |
| #85 Nachzugs-Paket Voll-Lesung 17.08. | AUFGABE | — | task_board_dump.md:27 | OFFEN (D-2-Vorlage Spline-Trias, Ledger-Korrekturen, docs-Zug, X-3) | -- | Memory/Tasks |
| #86 ORG-19-IO anlegen+einbinden+T19-Katalog-Zeile+E-1/Thesis-Textzug | AUFGABE | — | task_board_dump.md:28 | OFFEN (Owner-GO 17.08.) | -- | Memory/Tasks |
| #88 KON110-Posten (Parameter-Filter-Registry RF-B+Deep-Research+Lager-Typ 3+4+Hybrid-ML+kleine Hybride) | AUFGABE | — | task_board_dump.md:30 | OFFEN | -- | Memory/Tasks |
| #89 P-H Paper->Prueflinge+Ledger-#44/PV-4-Bau | AUFGABE | — | task_board_dump.md:31 | OFFEN (mit #18/S-13) | -- | Memory/Tasks |
| #90 P-A Kanalwerk-/Arena-Designplan | AUFGABE | — | task_board_dump.md:32 | OFFEN (Fable max, W1->vor Trigger, #53-Umfeld) | -- | Memory/Tasks |
| #91 Unifikations-Designplan CEB-Modulsteuerung | AUFGABE | — | task_board_dump.md:33 | IN_PROGRESS (Design KOMPLETT/design91-v2 GELANDET @0778c6ef, Verbuchung offen; Identitaets-Entscheide vor Mi 26.) | -- | Memory/Tasks |
| #96 WIEDERAUFNAHME-Vollzug Dauer-Register | AUFGABE | — | task_board_dump.md:35 | OFFEN (Feinplatzierung aller Vertagten, Di-25-Schnitt naechste Pflichtinstanz) | -- | Memory/Tasks |
| #97 C-13 Skip-Oekonomie+C-14 Bestandslog-SKIP-Wache | AUFGABE | — | task_board_dump.md:36 | OFFEN (vor Kampagne Sa 29.08.) | -- | Memory/Tasks |
| #99 B-5f Tooling-Ordnungs-Validierung (an allen drei Stellen) | AUFGABE | — | task_board_dump.md:38 | OFFEN (Di-25) | -- | Memory/Tasks |
| #103 TSan-VOLLAUSBAU eigene Objektklasse | FEATURE | — | task_board_dump.md:39 | OFFEN (build-tsan braucht Neubau) | -- | Memory/Tasks |
| #105 NP-24+W2-Miniposten-Trio(A9/A10/A11)+X-12-Bau+HDR-Verdrahtung | AUFGABE | — | task_board_dump.md:40 | OFFEN (Di-25) | -- | Memory/Tasks |
| #1 WF1 KON23 | AUFGABE | — | task_board_dump.md:44 | GELANDET | -- | Memory/Tasks |
| #2 WF2 KON20 | AUFGABE | — | task_board_dump.md:44 | GELANDET | -- | Memory/Tasks |
| #39 (fehlt im Dump) | UNKLAR | — | task_board_dump.md (Luecke, weder pending noch completed) | OFFEN (nicht auffindbar trotz "106 Tasks"-Kopfzeile) | -- | Memory/Tasks |
| #4 S-7 gelandet | AUFGABE | — | task_board_dump.md:44 | GELANDET | -- | Memory/Tasks |
| #5 Frage10 KON17-04 | AUFGABE | — | task_board_dump.md:44 | GELANDET | -- | Memory/Tasks |
| #6 WF3 KON22 | AUFGABE | — | task_board_dump.md:44 | GELANDET | -- | Memory/Tasks |
| #8 WF4 KON26 | AUFGABE | — | task_board_dump.md:44 | GELANDET | -- | Memory/Tasks |
| #9 Referenz-Konsolidierung KON39 | AUFGABE | — | task_board_dump.md:44 | GELANDET | -- | Memory/Tasks |
| #10 MinIO-Keys geheilt | REGRESSION | — | task_board_dump.md:44 | BEHOBEN | -- | Memory/Tasks |
| #11 Durchstich CI (##25) | AUFGABE | — | task_board_dump.md:44 | CI-BEWIESEN | -- | Memory/Tasks |
| #12 WF5 KON29 | AUFGABE | — | task_board_dump.md:44 | GELANDET | -- | Memory/Tasks |
| #14 ce-CI 15751 gruen | AUFGABE | — | task_board_dump.md:44 | CI-BEWIESEN | -- | Memory/Tasks |
| #16 golden-Fenster CI 15937 | AUFGABE | — | task_board_dump.md:44 | CI-BEWIESEN | -- | Memory/Tasks |
| #20 Flaeche-3 KON116 | FEATURE | — | task_board_dump.md:44 | GELANDET | -- | Memory/Tasks |
| #21 E-Block | AUFGABE | — | task_board_dump.md:44 | GELANDET | -- | Memory/Tasks |
| #23 WF6 KON34 | AUFGABE | — | task_board_dump.md:44 | GELANDET | -- | Memory/Tasks |
| #25 WF7 KON36 | AUFGABE | — | task_board_dump.md:44 | GELANDET | -- | Memory/Tasks |
| #26 ultracode-Planung KON39 | AUFGABE | — | task_board_dump.md:44 | GELANDET | -- | Memory/Tasks |
| #27 E-Warmup KON45 | AUFGABE | — | task_board_dump.md:44 | GELANDET | -- | Memory/Tasks |
| #29 Zielstruktur 85c1174d | FEATURE | — | task_board_dump.md:44 | GELANDET | -- | Memory/Tasks |
| #30 S-1 gelandet | AUFGABE | — | task_board_dump.md:44 | GELANDET | -- | Memory/Tasks |
| #31 13-Branches-Triage | AUFGABE | — | task_board_dump.md:44 | GELANDET | -- | Memory/Tasks |
| #32 Fixup S-1/C | REGRESSION | — | task_board_dump.md:44 | BEHOBEN | -- | Memory/Tasks |
| #33 S-14a | AUFGABE | — | task_board_dump.md:44 | GELANDET | -- | Memory/Tasks |
| #34 #22-Q6 | AUFGABE | — | task_board_dump.md:44 | GELANDET | -- | Memory/Tasks |
| #35 Fixup2 | REGRESSION | — | task_board_dump.md:44 | BEHOBEN | -- | Memory/Tasks |
| #36 Fixup3 | REGRESSION | — | task_board_dump.md:44 | BEHOBEN | -- | Memory/Tasks |
| #37 Wellen-Plan-Schnitt | AUFGABE | — | task_board_dump.md:44 | GELANDET | -- | Memory/Tasks |
| #41 F1 geliefert KON63 | FEATURE | — | task_board_dump.md:44 | GELANDET | -- | Memory/Tasks |
| #42 P6 Lizenz | OWNER-ENTSCHEID | — | task_board_dump.md:44 | GELANDET | -- | Memory/Tasks |
| #43 #81-Wiederhol-Verify | AUFGABE | — | task_board_dump.md:44 | GELANDET | -- | Memory/Tasks |
| #44 Drei-Stufen-Landung+F1 | AUFGABE | — | task_board_dump.md:44 | GELANDET | -- | Memory/Tasks |
| #45 BU-Workflow | AUFGABE | — | task_board_dump.md:44 | GELANDET | -- | Memory/Tasks |
| #46 Freigaben A2+A4 | OWNER-ENTSCHEID | — | task_board_dump.md:44 | GELANDET | -- | Memory/Tasks |
| #47 A1 Writeback-Token | FEATURE | — | task_board_dump.md:44 | GELANDET | -- | Memory/Tasks |
| #50 D12 | FEATURE | — | task_board_dump.md:44 | GELANDET | -- | Memory/Tasks |
| #51 Umbrella-CI | AUFGABE | — | task_board_dump.md:44 | GELANDET | -- | Memory/Tasks |
| #52 GitLab-Vorstrecke | AUFGABE | — | task_board_dump.md:44 | GELANDET | -- | Memory/Tasks |
| #54 Rotations-Turnus dormant | FEATURE | — | task_board_dump.md:44 | GELANDET (dormant) | -- | Memory/Tasks |
| #55 xlsx-Aufmachung | FEATURE | — | task_board_dump.md:44 | GELANDET | -- | Memory/Tasks |
| #56 Lande-Zug CI-Dual+Lizenz | AUFGABE | — | task_board_dump.md:44 | GELANDET | -- | Memory/Tasks |
| #58 Lande-Zug2 | AUFGABE | — | task_board_dump.md:44 | GELANDET | -- | Memory/Tasks |
| #59 Vorlagen-Runde 15.08. | AUFGABE | — | task_board_dump.md:44 | GELANDET | -- | Memory/Tasks |
| #60 Flotten-Runner | FEATURE | — | task_board_dump.md:44 | GELANDET | -- | Memory/Tasks |
| #61 Thesis-Trailer-Rewrite | AUFGABE | — | task_board_dump.md:44 | GELANDET | -- | Memory/Tasks |
| #62 15-Branches | AUFGABE | — | task_board_dump.md:44 | GELANDET | -- | Memory/Tasks |
| #63 helm-Upgrade | AUFGABE | — | task_board_dump.md:44 | GELANDET | -- | Memory/Tasks |
| #64 Zombie-Cancel | REGRESSION | — | task_board_dump.md:44 | BEHOBEN | -- | Memory/Tasks |
| #66 Randbestand | AUFGABE | — | task_board_dump.md:44 | GELANDET | -- | Memory/Tasks |
| #67 Thesis-Sync KON77 | AUFGABE | — | task_board_dump.md:44 | GELANDET | -- | Memory/Tasks |
| #68 Folge-BU | AUFGABE | — | task_board_dump.md:44 | GELANDET | -- | Memory/Tasks |
| #72 queuing-Umzug | AUFGABE | — | task_board_dump.md:44 | GELANDET | -- | Memory/Tasks |
| #73 helm-Nachlauf | AUFGABE | — | task_board_dump.md:44 | GELANDET | -- | Memory/Tasks |
| #75 W-A/W-B | AUFGABE | — | task_board_dump.md:44 | GELANDET | -- | Memory/Tasks |
| #76 Wo-stehen-wir-Session | AUFGABE | — | task_board_dump.md:44 | GELANDET | -- | Memory/Tasks |
| #78 KON97/98 | AUFGABE | — | task_board_dump.md:44 | GELANDET | -- | Memory/Tasks |
| #79 super-15941-Heilung | REGRESSION | — | task_board_dump.md:44 | BEHOBEN | -- | Memory/Tasks |
| #80 HY-A | FEATURE | — | task_board_dump.md:44 | GELANDET | -- | Memory/Tasks |
| #81 Vorlauf-Welle | AUFGABE | — | task_board_dump.md:44 | GELANDET | -- | Memory/Tasks |
| #92 P-G/S-22 KON117 | AUFGABE | — | task_board_dump.md:44 | GELANDET | -- | Memory/Tasks |
| #100 tools-3-Format | FEATURE | — | task_board_dump.md:44 | GELANDET | -- | Memory/Tasks |
| #101 W2-1 Bytevergleich | AUFGABE | — | task_board_dump.md:44 | GELANDET | -- | Memory/Tasks |
| #104 prt-art-Pin (16048) | AUFGABE | — | task_board_dump.md:44 | GELANDET | -- | Memory/Tasks |
| Welle 1 formal KOMPLETT (#15 completed, alle CIs SUCCESS) | AUFGABE | — | task_board_dump.md:46 | CI-BEWIESEN (ce 66de5c09, super e674d0be, prt-art 777fff7) | KON119=Ledger-Kopf | Memory/Tasks |
| Freeze-Check F2 | AUFGABE | — | task_board_dump.md:46 | OFFEN (MORGEN Fr 21.08.) | -- | Memory/Tasks |
| Bau-Trigger | AUFGABE | — | task_board_dump.md:46 | GEPLANT (Mi 26.08. 06:00) | -- | Memory/Tasks |
| Kampagne | AUFGABE | — | task_board_dump.md:46 | GEPLANT (Sa 29.08.) | -- | Memory/Tasks |
| Abgabe (Thesis-Deadline) | AUFGABE | — | task_board_dump.md:46 | GEPLANT (Di 15.09.) | -- | Memory/Tasks |

## Gegenzaehlung (nichts still verworfen)

| Groesse | Wellenplan | Register | Memory/Tasks | Summe |
|---|---|---|---|---|
| Roh-Posten (vor Dedup) | 929 | 439 | 404 | **1772** |
| davon in Teil-A-Cluster aufgegangen (zusammengefuehrt) | 55 | 22 | 36 | **113** |
| davon als Einzelquellen-Zeile unveraendert uebernommen (Teil B/C/D) | 874 | 417 | 368 | **1659** |
| Kontrollsumme je Quelle (Merge-Anteil + Einzel-Anteil = Roh) | 55+874=929 ✓ | 22+417=439 ✓ | 36+368=404 ✓ | 113+1659=1772 ✓ |

**Roh-Summe:** 1772 Posten (929 Wellenplan + 439 Register + 404 Memory/Tasks), alle drei Leser-Dateien vollstaendig gelesen (Z1-Ende je Quelle).

**Zusammengefuehrt:** 113 Rohzeilen (55 Wellenplan + 22 Register + 36 Memory/Tasks) wurden in 36 quellenuebergreifende bzw. eindeutig identifizierte Gegenstaende (Teil A) verdichtet — davon 33 Cluster ueber mindestens 2 Quellen hinweg, 3 Cluster als eindeutige Fortschreibungs-Paare/-Tripel innerhalb derselben Quelle (OV-5/prod2, EIN-BLECH-REGEL, CI-DUAL-COMPILER/#106). Das spart 113 − 36 = **77 Zeilen** gegenueber einer reinen Konkatenation.

**Dedupliziert (End-Zeilen der konsolidierten Tabelle):** 36 (Teil A) + 874 (Teil B) + 417 (Teil C) + 368 (Teil D) = **1695 Zeilen**.

**Nichts still verworfen — Vollstaendigkeits-Beweis:** 1659 Einzelquellen-Zeilen (unveraendert, Teil B/C/D) + 113 in Teil A eingegangene Rohzeilen = 1772 = Roh-Summe. Jede der 1772 gelesenen Rohzeilen ist entweder (a) wortgleich als eigene Zeile in Teil B, C oder D vorhanden, oder (b) als benannte Quelle (WP-Zxxx / R-Zxxx / MT-Zeile) in genau einer Teil-A-Zeile referenziert und deren Inhalt in Status-/Traeger-Zelle synthetisiert. Keine Zeile wurde geloescht, gekuerzt auf "erledigt sich von selbst" oder ohne Verbleib ausgelassen.

**Status-Konflikte, die im Dedup sichtbar ausgewiesen wurden (nicht glattgezogen):** Task #15 (Board-GELANDET vs. Wellenplan/Register-Snapshot-OFFEN), #38a2 (Audit-Erhebung uneindeutig, Board bestaetigt weiter offene Audit-Pflicht), #95/V-08R (Board-GELANDET vs. Register-Vorbehalt "OHNE dokumentierte Abnahme"), prod1-16/32 (Sachverhalt behoben, Doku-Marker-Luecke offen), `checkpoint_measure` (interner Widerspruch der Register-Audit-Tafel FEHLT vs. GEBAUT, nicht aufgeloest), B3/W1-V2 (Anker-Korrektur zwischen zwei Register-Passagen).

---
*Erstellt vom KONSOLIDIERER-Subagenten des Vollaudits, 20260820. Quellen: `leser-wellenplan.md`, `leser-register.md`, `leser-memory-tasks.md` (alle im selben Verzeichnis, vollstaendig gelesen vor Konsolidierung).*
