# SOLL-KARTE — Strang pmcpaket (#82 I-PMC-2/3 + #83 PMC-fail-loud)

Erstellt: 21.08.2026 (W2-Audit-Fix-Verify, Sonnet-max Planungs-Erheber; NUR LESEN, kein Fix).
Gepruefter Zweig: ce `bau/pmcpaket` @ **1d38263b** (Basis ce 66de5c09 / super a7e8e151 / prt-art 777fff7).
Strang-Ergebnis (voll gelesen): `/home/comdare/backups-workflow/20260820-w2-sofortstaffel/pmc-paket-ergebnis.md` (283 Z.).
Board-Spiegel (voll gelesen, Stand 21.08.): Task #82 und #83, beide markiert GEBAUT+LANDEREIF, Status-Feld noch `pending` (= nicht gelandet).

Wahrheits-Rangfolge dieser Karte: Owner-Wort > juengere KON > Wellenplan par.21-23 > par.17-20 > Designplan > W2-ABFOLGE-DESIGN > Strang-Bericht. Quellen-Kuerzel: **W2D**=W2-ABFOLGE-DESIGN.md, **LE**=LEAD-ENTSCHEIDE-zum-w2-design.md, **WP**=20260808-WELLENPLAN-ENDFASSUNG-v2, **DP**=20260808-DESIGNPLAN-tdd, **GOAL8**=20260808-GOAL-V8-DOSSIER, **LEDGER**=DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md (KON-Nummer+Zeile), **K1**=karte-tasks-kon119.md, **S1**=STAFFEL1-SYNTHESE.md, **S2**=STAFFEL2-SYNTHESE.md, **SB**=pmc-paket-ergebnis.md (Strang-Bericht).

---

## PRUEFLISTE

### A) #83 PMC-FAIL-LOUD-KERN (C-1, KON103)

**P-01 — C-1(a) COMDARE_ENABLE_PMC wird INVARIANTE der dynamischen Kette.**
WAS: LEDGER KON103-02 :1745 "(a) JA -- COMDARE_ENABLE_PMC wird INVARIANTE der dynamischen Kette." (Antwort auf Owner-Frage `docs/sessions/20260817-OWNER-VORLAGE-fragenbuendel-parallelstart.md:111-113`).
WIE pruefbar: `experiment_plan_director.hpp` 4 Emissionsstellen (SB nennt :1086/:1132/:1470/:1667) + clang-Zwilling :423; Test `PmcPflichtInvariante.JedeTreiberKonfigurationTraegtDasPmcFlag` (`test_experiment_plan_director.cpp:3036`).
BEHAUPTET (SB Z.84): "C-1 (a) ist am Objekt GEBAUT (06.08.+10.08.)" — **bereits VOR diesem Strang gebaut**, vom Strang nur verifiziert/bestaetigt, nicht neu geschrieben. Die 17.08.-Vorlage hatte dies faelschlich als offen behauptet (r3-Karte stale, F-35).

**P-02 — C-1(b) "PMC-Quelle nicht gebaut" wird FEHLER statt Skip (Preflight scheitert statt skippt).**
WAS: LEDGER KON103-02 :1746 "(b) JA -- 'PMC-Quelle nicht gebaut' wird FEHLER statt Skip (Preflight scheitert statt skippt)." + NP-30 (KON106-04 :1285-1288: vier Wachen-Fundstellen 1:1 uebernehmen).
WIE pruefbar: `experiment_plan_director.hpp:1687ff` Preflight-Emission verzweigt am Befund — `Unbrauchbar` => `[PMC-TESTAT] ... pmc=FEHLER grund=pmc_quelle_nicht_gebaut` + `exit 1` VOR jeder Messung; Test T-A `PmcFailLoud` (rot zuerst, `test_experiment_plan_director.cpp:3188`).
BEHAUPTET (SB Z.152-155, 185-187): GEBAUT — rot-zuerst-Literal `Failure ... s.find("pmc=ok") ... #83: eine flaglose Emission darf NIE ein pmc=ok testieren`, nach Bau `[ PASSED ] 3 tests` (PmcFailLoud+PmcPflichtInvariante).

**P-03 — C-1(c) Teil-Lauf ohne PMC bleibt buchbar: Bau-Seite SOFT, Ergebnis-Seite HART, ausdruecklich gekennzeichnet.**
WAS: LEDGER KON103-02 :1747-1748 "(c) JA -- Teil-Lauf ohne PMC bleibt buchbar (Bau-Seite soft, Ergebnis-Seite hart, ausdruecklich gekennzeichnet), ABER mit WARNUNG..."; deckungsgleich mit WP:2479-2480 (C-11 "Achsen failen IMMER hart; NUR fehlende Messeinrichtung (PMC) soft = Warnung in die xlsx, Binary WIRD gebaut (KON28-02)") und WP:2176 (T-15b "Soft-Ausnahme nur fehlende Messeinrichtung (PMC) -> xlsx-Warnung").
WIE pruefbar: `cache_engine_builder_iterator.hpp` `pmc_zelle()` — `row.pmc.available &&`-Gate entfernt, jede Zelle ohne Quellen-Flag rendert n/a-Token statt "0"; PMC-off-Zeile = 8x Token + `pmc_available=0`; Pin `test_a8s3_csv_klasse_c.cpp` W10 (+ neu W10b).
BEHAUPTET (SB Z.156-159, 188-189): GEBAUT, T-B rot-zuerst (`a8s3_rc=1` + `[ERR] W10 PMC-off-Zeile traegt Token statt stiller 0`) -> nach Bau `rc=0, 16x [OK], 0x ERR`.

**P-04 — C-1(c)-Warnung: "wenn PMC vorhanden, aber nicht verwendet" (Drei-Wege-Unterscheidung, KON106-04).**
WAS: Owner-Verbatim LEDGER KON103-01 :1727-1728 "Aber Warnung bei (c) wenn PMC vorhanden, aber nicht verwendet." + KON106-04 :1283-1285 "die Drei-Wege-Unterscheidung ist NEU: Fehler bei fehlender Quelle / WARNUNG bei vorhandener-aber-ungenutzter Quelle / stiller Normalfall -- der einzige inhaltlich neue Beitrag der Runde" + NP-31 :1288-1289 "der Warn-Signalpfad 'vorhanden, nicht verwendet' ist ein NEUER Baustein (WARN-Log/CSV-Flag), in keiner der vier Wachen vorgesehen."
WIE pruefbar: NEU `builder/pmc_startup_pruefung.hpp` (immer uebersetzt) — einkompiliert+available=still; einkompiliert+!available=[PMC-WARN] teil_lauf; NICHT einkompiliert+Host-Koeder beisst=[PMC-WARN] pmc_startup_vorhanden_nicht_verwendet (Nenner host_biss=x/y); sonst still. Einbau: `collect_ordered`-Vorfeld (einmal je Lauf) + beide Smoke-Skip-Pfade. Test T-C `test_pmc_startup_pruefung` (4 Tests).
BEHAUPTET (SB Z.160-165, 190-191, 198-202): GEBAUT+PASSED(4)+LIVE bewiesen — stdout `pmc_startup_lage = pmc_startup_vorhanden_nicht_verwendet`, stderr `[PMC-WARN] klasse=pmc_startup_vorhanden_nicht_verwendet ... host_biss=3/4` (3/4 = L1D+dTLB+branch beissen, generisches LL nicht), Exit 0.
ANMERKUNG: CSV-Flag-Alternative aus NP-31 ("WARN-Log/CSV-Flag") wurde NICHT als neue Spalte gebaut — Strang begruendet dies (SB Z.134-135, 217-218): "Zeilen-Kennzeichnung liegt in pmc_available=0 + Tokens; die Warnung ist LAUF-Eigenschaft -> Log/Testat". NP-31 nennt beide Wege ausdruecklich ALTERNATIV ("WARN-Log/CSV-Flag"), keine Pflicht zu beidem — kein Widerspruch, aber Audit sollte diese Lesart pruefen.

**P-05 — errno=2-Fall (AMD-L3, stille 0 neben Intel-Millionen) wird FEHLER, nie Messwert.**
WAS: LEDGER KON103-02 :1750-1751 "Bau-Folge: ... der AMD-L3-errno=2-Fall (stille 0 neben Intel-Millionen) wird FEHLER, nie Messwert."
WIE pruefbar: `pmc_counter_outcome.hpp` static_asserts (`pmc_outcome_cell`).
BEHAUPTET (SB Z.36, 182): "bereits als FEHLER gebucht" (B-5, 08.08., **vor** diesem Strang) — Strang verifiziert nur, kein Neubau.

**P-06 — "Stille Nullen gibt es bei Messung nicht" (Owner-KERN, uebergreifende Fail-Loud-Doktrin).**
WAS: Owner-Verbatim LEDGER KON103-01 :1728-1729 "Stille nullen gibt es bei Messung nicht, wir hatten fail loud ueber die letzten 10 wochen explore geplant." Deckungsgleiche Session-Doktrin GOAL8:305-308 (II.7 Fail-closed: "Kann eine Wache nicht pruefen ... ist das rot oder Abbruch, nie gruen. Ein stiller Rueckfall ist ausdruecklich ein Fehler.") und GOAL8:763-776 (allow_failure-Tabelle: "CI-Job faellt immer hart rot -- nie allow_failure"; "ZELLE=Warnung, JOB=rot").
WIE pruefbar: P-02 (Job faellt hart, kein allow_failure in der YAML) + P-03 (Zelle traegt Token/Warnung, kein stiller Wert).
BEHAUPTET (SB Z.153-154): "Job HART rot, kein allow_failure; YAML unberuehrt" — erfuellt exakt die GOAL8-Tabellenzeile "CI-Job faellt immer hart rot".

### B) #82 I-PMC-2/3-KERN (C-2, KON103, "volles Programm")

**P-07 — C-2 BAUEN, VOR der Abgabe, volles Programm; Zuschneide-Empfehlung ABGELEHNT.**
WAS: Owner-Verbatim LEDGER KON103-01 :1729-1731 "Wir lassen nichts weg und machen NICHTS nach der Abgabe ... volles Programm bitte. Ja krischer Pfad muss gegangen werden, egal was." KON103-02 :1752-1756: "Die Kernmetrik-Zusage (Cache-Misses) bleibt VOLL (L3/L2/coherence/energy zusaetzlich zu L1D+dTLB); Zuschneide-Empfehlung der Vorlage ist ABGELEHNT."
WIE pruefbar: L1D+dTLB (Bestand), branch_misses (`PERF_COUNT_HW_BRANCH_MISSES`), AMD-L3 (Uncore-Diagnose-Spalte), L2+coherence (neuer RAW-Katalog), energy (RAPL best-effort) — alle sechs Felder muessen am Objekt referenzierbar sein.
BEHAUPTET (SB Z.171-182, 231-238): branch_misses war GEBAUT (M-3a 07.08., vor diesem Strang); AMD-L3-Klaerung war GEBAUT (B-5 08.08., Uncore-Spalte, Wertfuellung haengt an Rechten); L2+coherence NEU gebaut in diesem Strang (siehe P-08); energy best-effort RAPL (Bestand, nicht Gegenstand dieses Strangs).

**P-08 — Zen-5-RAW-Ausgang schliessen (KON103 "offen"; NP-33 Deep-Research als Bau-Vorbedingung).**
WAS: LEDGER KON103-02 :1756 "I-PMC-2/3 braucht einen EIGENEN SLOT vor W3 (Zen-5-RAW-Ausgang offen; Planung im Wellen-Nachtrag, Vorstaffel WE 22./23.)." + KON106-04 NP-33 :1299-1300 "Zen-5-RAW-Deep-Research als Bau-Vorbedingung vor dem Slot (seit 16.07. nie nachrecherchiert)."
WIE pruefbar: NEU `measurement/pmc_raw_event_katalog.hpp` — (Vendor,Family)->RAW-Belegung; Zen 5 (AuthenticAMD, family 26): l2=PERF_TYPE_RAW 0x964 (`l2_cache_req_stat.ic_dc_miss_in_l2`), coherence=PERF_TYPE_RAW 0x1443 (`ls_dmnd_fills_from_sys.remote_cache`); Kreuzprobe `perf stat` (benannt) gegen RAW-config am selben Lauf.
BEHAUPTET (SB Z.112-122, 172-182, 203-205): GESCHLOSSEN mit Objekt-Beweis — Kreuzprobe `r964==ic_dc_miss_in_l2` (17.314.023==17.314.023), `r1443==remote_cache` (21.503==21.503); Live-Wegwerf-Sonde `l2=8234162 l2_avail=1` / `coh=270641 coh_avail=1` auf prod1 (Zen 5, family 26/model 68, perf 6.17). Test T-D `test_pmc_raw_event_katalog` (2 Tests, PASSED).

**P-09 — fremde CPU-Modelle: fail-closed, kein Rateversuch (Steckbrief-Anforderung; Instanz der GOAL8-II.7-Doktrin).**
WAS: GOAL8:305-308 (II.7 Fail-closed) generisch angewandt; Steckbrief nennt es explizit fuer #82.
WIE pruefbar: `pmc_raw_event_katalog.hpp` — ALLE anderen Vendor/Family-Kombinationen LEER (kein Default-Guess), 6 static_asserts am Katalog-Kopf.
BEHAUPTET (SB Z.139, 175, 219, 237): GEBAUT ("fremde Modelle -> LEER = ehrlich n/a, NIE geraten"; "fail-closed, kein Rateversuch; 6 static_asserts"); Intel-Zeile bewusst NICHT befuellt — "ohne Objekt-Kreuzprobe waere jeder Eintrag ein Rateversuch (Katalog additiv erweiterbar; Muster + static_assert-Form stehen)". Deckt sich mit DP:79 (PM-NichtGelesen-Hardwareteil braucht pmc:intel-Lane, "prod2 ist per OV-5(b) gestrichen, der Teil geht nach W7") und WP:3121 ("soll die pmc:intel-/P-E-Lane zurueckkommen, genuegt EIN Owner-Satz").

**P-10 — NP-34 csv_to_latex.cpp-Kernmetrik-Caveat "in DENSELBEN Zug buendeln" (super-Repo).**
WAS: LEDGER KON106-04 :1299-1302 "NP-34 csv_to_latex.cpp:985-986 (Kernmetrik-Text '= 0 / nicht erhoben', D-18) in DENSELBEN Zug buendeln, damit Textaussage und Messvermoegen nie auseinanderlaufen." — Ort: `super Code/04_csv_to_latex/csv_to_latex.cpp:986-999` (Caveat "L2 + Coherence strukturell 0").
WIE pruefbar: Datei liegt im **super**-Repo, ausserhalb des ce-Worktrees `wt-ce-pmcpaket`.
BEHAUPTET (SB Z.107-108, 214-216, 274-275): **NICHT gebaut** — Strang begruendet explizit: liegt im super-Repo, ausserhalb dieses ce-Worktrees; als offener Punkt fuer den super-/Lande-Zug deklariert ("umschreiben auf 'modell-gebunden real (Zen 5), sonst n/a'"). Siehe SPANNUNGEN — der Ledger-Wortlaut "IN DENSELBEN Zug" ist damit NICHT woertlich erfuellt.

**P-11 — NP-30: die vier Wachen-Fundstellen "werden scharf" (Bau-Folge, KON103-02).**
WAS: LEDGER KON103-02 :1749-1751 "Bau-Folge: die 4 nicht-beissenden PMC-Wachen werden scharf" — NP-30 (KON106-04 :1285-1288) benennt sie: (W1) CMakeLists-Option, (W2) `m3v2_pmc_smoke.cpp:71`, (W3) `linux_perf_pmc_smoke.cpp:58-63`, (W4) die 4 Emissionsstellen im Director.
WIE pruefbar: je Fundstelle einzeln am Objekt.
BEHAUPTET (SB Z.73-96 "STAND DER VIER WACHEN"): W2 und W3 waren **bereits seit M-2/B3 (06.08.) scharf** (vor diesem Strang); W4 war bereits seit 06./10.08. Invariante (= P-01); **W1 (CMakeLists Vendor-leer WARNING) bleibt bewusst NICHT scharf** — als Folgepaket "super-Nachzug-Fenster" deklariert (Begruendung: zwei super-Altaufrufer setzen ON ohne Vendor, ein Flip jetzt macht die super-Pipeline hart rot). Siehe SPANNUNGEN.

### C) TDD-VERTRAG (DP §3, Pflicht-Massstab fuer JEDES Paket)

**P-12 — T-1 ROT ZUERST fuer jeden neuen Test.**
WAS: DP:67 "Der Test ist am ersten Tag rot, ODER sein Biss ist per protokollierter Wegwerf-Mutation bewiesen ... Beides fehlt = kein Test."
WIE pruefbar: Rot-Lauf-Literal vor dem Fix je neuem Test.
BEHAUPTET (SB Z.184-194): T-A (PmcFailLoud) UND T-B (W10) rot-zuerst mit Literal; T-C und T-D zusaetzlich per Wegwerf-Mutation bewiesen (T-11c, siehe P-17).

**P-13 — T-3 NENNER, FREMD.**
WAS: DP:69 "Jeder Test nennt seine Grundgesamtheit und bezieht sie aus einer anderen Quelle als dem Pruefling."
WIE pruefbar: Katalog-Test T-D — Nenner (Zen5-Eintraege vs. fremdes-Modell-leer) muss unabhaengig vom `pmc_raw_event_katalog.hpp`-Code selbst stammen (Header-static_asserts als Kompilierzeit-Nenner ausserhalb der Testlogik).
BEHAUPTET (SB Z.192-194): T-D-Mutation vertauscht Configs UND legt 2 Header-static_asserts temporaer still — "die FREMDE amd_raw_config-Nachrechnung beisst" = unabhaengiges Orakel; nach Revert PASSED 2, 0 Wegwerf-Marker verbleiben.

**P-14 — T-6 SCHWESTERPFLICHT.**
WAS: DP:72 "Jeder Fix und jeder Test sucht im selben Zug die Schwesterstelle."
WIE pruefbar: Weiterleitungs-/Delegationsmuster statt Abschrift; gleiche Semantikklasse bei neuen Feldern.
BEHAUPTET (SB Z.166-169, 176-180): PROBE-KERN-UMZUG folgt "Weiterleitungs-Muster wie `pmc_cache_cfg`" (Abschrift-schlaegt-Loeschung-Doktrin); `c_l2_`/`c_coherence_` folgen "gleiche Semantikklasse wie l1d/dtlb/branch" — beide als bewusste Schwestersuche benannt, nicht als eigener T-6-Pruefschritt separat protokolliert.

**P-15 — T-7 REGISTRIERUNG IST TEIL DES TESTS + `tests/unit/CMakeLists.txt` NUR ans Dateiende (Session-TABU).**
WAS: DP:73 "Ein Test existiert erst, wenn er in `ctest -N` erscheint und sein Binary im Bauweg haengt."
WIE pruefbar: `ctest -N` zeigt beide neuen Tests; CMakeLists-Registrierung am Dateiende; Labels ohne 'pmc'-Substring (da `ctest -LE pmc` Regex ist und `test:unit` sonst faelschlich ausschliesst — F-43).
BEHAUPTET (SB Z.123, 195-196, 256-257): "test:unit laeuft `-LE pmc` (CMakeLists :3797, :4991) -- Smoke-Schaerfung bricht test:unit nicht"; beide neuen Tests am Dateiende, Labels bewusst ohne 'pmc'-Substring (im Code-Block dokumentiert); `ctest -N` listet `Test #511: test_pmc_startup_pruefung` + `Test #512: test_pmc_raw_event_katalog` (Total 512).

**P-16 — T-11b KOMBIBAU-2x2-MATRIX ALS PRUEFNORM (K17-Doktrin).**
WAS: DP:645 "jede Landung ist erst gruen, wenn {clang, gcc} x {Debug, Release} = 4 Zellen ... durchlaufen"; Memory K17: "jeder Lande-Merge traegt VOR Push den 4-Zellen-Kombibau ... CI ist nie Erstpruefung."
WIE pruefbar: 4-Zellen-Bilanz am GEMERGTEN Endstand (nicht am Einzel-Branch).
BEHAUPTET (SB Z.242-257, 273): Strang selbst verifiziert NUR gcc-Release (2. Lauf 100% 512/512, CTEST_RC=0); die restlichen 3 Zellen sind explizit als OFFENER PUNKT #1 "Lande-Zug: T-11b-4-Zellen-Kombibau am GEMERGTEN Endstand" deklariert. Dies ist gemaess K17-Doktrin KEIN Strang-Defekt (T-11b greift erst am Merge-Stand), sondern korrekt an den Lande-Zug delegiert — Audit sollte NICHT die fehlenden 3 Zellen als Luecke DIESES Strangs werten.

**P-17 — T-11c MUTATIONS-PROTOKOLL ALS ABNAHMEKLASSE.**
WAS: DP:647 "der Biss jedes neuen Tests wird per protokollierter Wegwerf-Mutation belegt (Rot gesehen, dann zurueckgenommen) ... je neuem Test >=1 Wegwerf-Mutation mit literalem Rot + Gegenprobe-Gruen."
WIE pruefbar: je neuem Test (T-A..T-D) mindestens 1 Mutation mit Rot-Literal + Revert-Gruen-Literal.
BEHAUPTET (SB Z.184-194): T-A/T-B als T-1-rot-zuerst gefahren (Testcode selbst ist der Erstlauf-Rot-Beweis); T-C (Warn-Weg stillgelegt -> `[ FAILED ] PmcStartupPruefung.VorhandenAberNichtVerwendetWarnt` -> revertiert -> PASSED 4) und T-D (Configs vertauscht + 2 static_asserts still -> FAILED -> revertiert -> PASSED 2) als vollstaendige Wegwerf-Mutationen mit "0 WEGWERF-Marker verbleiben".

### D) PROZESS-/BAU-GATES (Session-REGELN, bindend fuer jeden Strang)

**P-18 — TABU-Gate: nichts unter axes/, topics/, heuristik/; golden-Dateien byte-stabil.**
WAS: Auftrags-REGELN dieser Audit-Runde.
WIE pruefbar: `git diff --name-only 66de5c09..HEAD` gegen TABU-Muster (golden_fullpilot, permutation_axes, m3v2_study, Registry-XML, axes/, topics/, heuristik/).
BEHAUPTET (SB Z.263-264): "TABU/golden: trifft KEINE ... Datei (Gegenprobe rc=1 = kein Treffer)."

**P-19 — clang-format-22 + ASCII-only/120-Breite Diff-Hygiene-Wache.**
WAS: Auftrags-REGELN + Memory (`~/.local/bin/clang-format-22` ueber jede geaenderte Lint-Datei; ASCII-only in neuen Zeilen).
WIE pruefbar: `clang-format-22 --dry-run -Werror` ueber alle geaenderten Dateien; `sh scripts/ci_diff_ascii_width_guard.sh 66de5c09..HEAD`.
BEHAUPTET (SB Z.206-207, 260-262): Beides GRUEN — "clang-format-22 --dry-run -Werror ueber alle 15 geaenderten Dateien = clean"; offizielle Wache "DIFF-HYGIENE-WACHE: GRUEN." (GUARD_RC=0). SB nennt zusaetzlich 6 mitgereiste Non-ASCII-Altzeilen bei der SCHWESTER-Strang mess-fenster (F-14) — bei pmcpaket selbst wird kein solcher Fund berichtet.

**P-20 — Vollbau-Treppe + `ctest --no-tests=error` voller Lauf, Bilanz literal.**
WAS: Bau-Treppe der Session-REGELN (J-0b -> J-1 sieben Werkzeuge -> RE-CONFIGURE -> all -> facade -> tests -> ctest).
WIE pruefbar: Ausgabe der Treppe + finale ctest-Bilanz.
BEHAUPTET (SB Z.242-257): Treppe vollzogen (J-1-Werkzeugschleife lief leer — 0 registry_gen-Targets im Namensraster dieses Standes, Treppe trotzdem durchlaufen); `--target all` 2524 Schritte; Erstlauf 99% (510/512, 2 rot, beide als RIPPLE DES EIGENEN BAUS identifiziert+behoben); Zweitlauf **100% tests passed, 0 tests failed out of 512** (CTEST_RC=0).

**P-21 — Commit-Trailer + Push mit `ci.skip` (Ref-Sicherung).**
WAS: Session-REGEL: Commit-Trailer `Co-Authored-By: Claude Fable 5 <noreply@anthropic.com>`; `git push -o ci.skip origin <branch>`.
WIE pruefbar: `git log -1 --format=%B 1d38263b` am Objekt (Audit-Sache, hier nicht ausgefuehrt).
BEHAUPTET (SB Z.265-267): Commit 1d38263b "bau(pmc-paket): #83 PMC-fail-loud + #82 I-PMC-2/3 (Owner-GO KON103 17.08., C-1/C-2)" (16 Dateien, 11 geaendert/5 neu, Porcelain 0); Push `git push -o ci.skip origin bau/pmcpaket` -> `[new branch]`. Der volle Commit-Body inkl. Trailer wird im Ergebnis-Bericht NICHT woertlich zitiert — Trailer-Literal ist am Objekt zu pruefen.

### E) LANDE-KOPPLUNG (Harmonisierungs-Flaechen, S1/S2-Synthese)

**P-22 — H-3: `cache_engine_builder_iterator.hpp` — DREI Zweige, drei disjunkte Zonen.**
WAS: S1:47-50 "messfenster ([T-15-KLAMMER]-Paar, [T-15B-RETRY]-Dispatch, LazyRunResult::mess_warnungen) x s13 (PerBinaryMappeFn/cfg.per_binary_mappe) x pmc (pmc_zelle Token-Haerte). Sequentiell harmonisieren; Marker-Wachen ... decken den Endstand."
WIE pruefbar: Merge-Konflikt-Freiheit pruefen (disjunkte Zonen), nicht logische Kollision.
BEHAUPTET: Kein Widerspruch von pmcpaket selbst berichtet; Harmonisierung ist Lande-Zug-Aufgabe (nicht Strang-Aufgabe).

**P-23 — H-10: Lande-Reihenfolge — `bau/pmcpaket` MUSS vor `kampvor` gemergt werden.**
WAS: S2:51-56 "pmcpaket (S1: Preflight pmc=FEHLER + Director-Tests) x kampvor (S2: Fenster-Topologie/[FENSTER-FREMD] + [PIN-DEKLARATION]) ... kampvor ZWINGEND NACH pmcpaket mergen."
WIE pruefbar: Merge-Reihenfolge am Lande-Zug (Phase 1, Schritt 4 von 5 in S1:75-82: messfenster -> s19 -> s13schema -> **pmcpaket** -> s8kopf).
BEHAUPTET: reine Prozess-/Reihenfolge-Anforderung an den LANDE-ZUG, kein Code-Liefergegenstand von pmcpaket selbst — hier nur als Randbedingung vermerkt, die der Audit nicht pmcpaket, sondern der Lande-Stufe anlasten muss.

**P-24 — E-1-Abnahme "vor Trigger gelandet" (Mi 26.08. 06:00).**
WAS: W2D:447-449 "ABNAHME: fail-loud-Paket gebaut, vor Trigger gelandet."
WIE pruefbar: Merge-Commit von `bau/pmcpaket` in `ce/development` vor Mi 26.08. 06:00.
BEHAUPTET: **NOCH NICHT erfuellt** — Branch-Status laut S1-Status-Tafel (Z.20) und Board #82/#83 ist "LANDEREIF", nicht "GELANDET"; Landung ist als eigener Fable-max-Lande-Zug nach Design TEIL 3 vorgesehen (Phase-1-Schritt-4). Frist (Mi 26.08. 06:00) ist zum Zeitpunkt dieser Karte (21.08.) noch nicht ueberschritten — kein Defekt, aber ein offener Pflichtpunkt, den der Audit von den Code-Pflichtpunkten P-01..P-20 UNTERSCHEIDEN muss.

---

## ABNAHME-FORMELN (woertliche Zitate der Quellen)

- **W2D:198-199 (C-4):** "**C-4 #82 I-PMC-2/3 VORSTAFFEL** (eigener Slot vor W3; Owner-GO 17.08. liegt). QUELLE K1:24. **ABNAHME: I-PMC-2/3 gebaut.**"
- **W2D:447-449 (E-1):** "**E-1 #83 PMC-FAIL-LOUD-PAKET** (eigener Zug 26.08.; Owner-GO 17.08.; Bau-Vorzug im WE zulaessig, s. [C]-Fussnote). QUELLE K1:25. **ABNAHME: fail-loud-Paket gebaut, vor Trigger gelandet.**"
- **K1 (karte-tasks-kon119.md:29):** "I-PMC-2/3 bauen | ... | #82 [pending] | **I-PMC-2/3 gebaut.** Owner-GO liegt bereits vor (17.08.) — Ausfuehrung, keine offene Frage."
- **K1 (karte-tasks-kon119.md:30):** "PMC fail-loud-Paket | ... | #83 [pending] | **fail-loud-Paket gebaut.** Owner-GO bereits 17.08. erteilt; war '#15-Bruch-Umfeld', jetzt eigenstaendiger Zug."
- **LEDGER KON103-01 (:1723-1732), Owner-Verbatim, vollstaendig:** "A-1: ... A-2: ... B-1: ... **C-1: (a) und (b) und (c) alle ja. Aber Warnung bei (c) wenn PMC vorhanden, aber nicht verwendet. Korrekt sonst, volles GO. Stille nullen gibt es bei Messung nicht, wir hatten fail loud ueber die letzten 10 wochen explore geplant. C-2: Wir lassen nichts weg und machen NICHTS nach der Abgabe, es gibt also nur vor der Abgabe, volles Programm bitte. Ja krischer Pfad muss gegangen werden, egal was.** C-3: Es gibt dazu immer noch einen deep research workflow, bitte selbst tief lesen."
- **LEDGER KON103-02 (:1745-1756):** "C-1 PMC-DREIFACH: (a) JA -- COMDARE_ENABLE_PMC wird INVARIANTE der dynamischen Kette. (b) JA -- 'PMC-Quelle nicht gebaut' wird FEHLER statt Skip (Preflight scheitert statt skippt). (c) JA -- Teil-Lauf ohne PMC bleibt buchbar (Bau-Seite soft, Ergebnis-Seite hart, ausdruecklich gekennzeichnet), ABER mit WARNUNG wenn PMC VORHANDEN und NICHT VERWENDET. ... Bau-Folge: die 4 nicht-beissenden PMC-Wachen werden scharf; der AMD-L3-errno=2-Fall (stille 0 neben Intel-Millionen) wird FEHLER, nie Messwert. — C-2 I-PMC-2/3: BAUEN, VOR der Abgabe ... Die Kernmetrik-Zusage (Cache-Misses) bleibt VOLL (L3/L2/coherence/energy zusaetzlich zu L1D+dTLB); Zuschneide-Empfehlung der Vorlage ist ABGELEHNT. Der kritische Pfad wird gegangen 'egal was' -> I-PMC-2/3 braucht einen EIGENEN SLOT vor W3 (Zen-5-RAW-Ausgang offen ...)."
- **LEDGER KON106-04 (:1283-1285):** "DELTA: (1) die Buchbarkeits-Frage (c) hat KEIN Vorbild; (2) die Drei-Wege-Unterscheidung ist NEU: Fehler bei fehlender Quelle / WARNUNG bei vorhandener-aber-ungenutzter Quelle / stiller Normalfall -- der einzige inhaltlich neue Beitrag der Runde."
- **WP:2479-2480 (C-11):** "C-11 HART/SOFT: Achsen failen IMMER hart; NUR fehlende Messeinrichtung (PMC) soft = Warnung in die xlsx, Binary WIRD gebaut (KON28-02) -> T-15b/#13"
- **WP:2176 (T-15b):** "Soft-Ausnahme nur fehlende Messeinrichtung (PMC) -> xlsx-Warnung."
- **GOAL8:305-308 (II.7 Fail-closed):** "Kann eine Wache nicht pruefen — Werkzeug fehlt, API antwortet nicht, Verzeichnis fehlt —, ist das **rot oder Abbruch, nie gruen**. Ein stiller Rueckfall ist ausdruecklich ein Fehler."
- **GOAL8:763-776 (allow_failure):** "**`allow_failure: true` ist auf JOB-Ebene VERBOTEN.**" / Tabelle: "CSV-Zelle | traegt `failed` (nicht `null`), plus Warnung an den Anwender ... | CI-Job | faellt **immer hart rot** — nie `allow_failure`."
- **DP:65-75 (TDD-Vertrag, T-1..T-9):** vollstaendiger Wortlaut siehe PRUEFLISTE C; Kernsatz DP:65 "Gilt ab sofort fuer jedes Paket aller Wellen."
- **DP:645, 647 (T-11b/T-11c):** vollstaendiger Wortlaut siehe PRUEFLISTE P-16/P-17.
- **Board #82 (Task-Liste, Stand 21.08., Status noch `pending`):** "GEBAUT+LANDEREIF ... REST: Intel-RAW braucht Intel-Host-Kreuzprobe · NP-34 csv_to_latex-Caveat = super-Zug · Kombibau = Lande-Zug."
- **Board #83 (Task-Liste, Stand 21.08., Status noch `pending`):** "GEBAUT+LANDEREIF ... REST: W1-FATAL-Flip = Folgepaket super-Nachzug-Fenster; super-Grep optional."

---

## NICHT-GEFORDERT (ausdruecklich NICHT Teil von #82/#83 — Phantom-Funde vermeiden)

1. **PMC-Schwester-Design (KON73-01)** — eigenstaendiges Feature: PMC als MESS-ACHSE im Stempel-/Schema-System ("Sondergrammatik kein-Eintrag-bei-Abwesenheit", Nenner-Erweiterung, Planer-HW-Erkennung+System-Proxy). Gehoert zu Task **#53** (DESIGN MESS-ACHSEN-FAMILIE, in_progress, eigener Owner-Vorlage-Bedarf), NICHT zu #82/#83. Quelle: W2D:629-630 (OG-45, "blockiert genau diesen Bau-Posten" = PMC-Schwester-Bau selbst, nicht #82/#83), WP:2322 ("W1-Design, W2-Bau"), S2:249-250 (O-D: "PMC-Schwester zuerst" vor #53-Kollektor-Bau).
2. **OG-20 (OV-S13-3) PMC-Flag-Felder im Mess-POD** — die Frage "#15-Bruch ODER vorerst nur Darstellung?" fuer die POD-/ABI-Ebene ist S-13s Gegenstand (#18, blockiert S13-11-POD-Haelfte), nicht #82/#83. pmc-paket aendert nur die RENDER-Logik in `pmc_zelle()` (Darstellungsebene), keine POD-Struktur — OG-20 bleibt unberuehrt offen. Quelle: W2D:576-578.
3. **OG-41 PMC-Gueltigkeit/Anhangs-Umfang** — eine ECHTE, noch unbeantwortete Owner-Frage (r3 W-r3-2/W-r3-4) ueber den Gueltigkeits-/Anhangsumfang von PMC-Daten in der Thesis; kein Bauauftrag an #82/#83. Quelle: WP:2624-2628.
4. **D-6 PMC-Vertragsfolge ungetestet (CEB->Tier-CT-Vertragsanpassung, MT-L11 Vendor-Injektion)** — eigener Testposten Band B, **Welle W4**, nicht W2. Quelle: DP:41 (MT-L11 [B W4 2]), DP:631.
5. **Intel-RAW-Katalog-Eintraege** — bewusst NICHT gebaut (P-09); braucht eine Intel-Host-Kreuzprobe, die auf prod1 (AMD Zen 5) nicht moeglich ist. `pmc:intel`/P-E-Lane ist per Owner-Entscheid OV-5(b) gestrichen (WP:1052, DP:79) und geht — falls je reaktiviert — nach W7.
6. **W1-CMakeLists-Flip Vendor-leer WARNING->FATAL** — von der Session als "Folgepaket im super-Nachzug-Fenster" behandelt (siehe SPANNUNGEN); NICHT als Teil dieses Strangs gebaut.
7. **T-11a Warmup-Paar-Pflichttest** — gehoert zu #13/mess-fenster (KON47-04), nicht zu pmc-paket, obwohl beide C-11/PMC-Soft-Bezug teilen. Quelle: DP:640-644.
8. **T-12a-e (Drift-Gate-Debug, Warmup-Legacy, Arena E11, Full-Join FJ-1..FJ-10, S-3-Kombibau-Nachweis)** — keine dieser fuenf Designplan-Nachtrags-Pflichten hat einen PMC-Bezug; sie gehoeren zu C-2/C-3/S-13/S-3. Quelle: DP:653-713.
9. **NP-32 Termin-Kollisionspruefung WE 22./23.** (#82 vs. S-19 vs. T-15b vs. A-1-Wartungsfenster) — eine Slot-/Terminfrage, keine Code-Pflicht; laut LE-Punkt 8 durch die Owner-Sofort-Regel entschaerft (Straenge liefen bereits parallel). Quelle: LEDGER KON106-04 :1297-1299, LE:16-18.
10. **S-19s "PMC-Tor"-Konsum (3!/4!-Rekombination)** — S-19 LIEST das Ergebnis, ob PMC aktiv ist, als EIGENEN Input fuer die Planungs-Simulation (Board #7: "PMC-Tor AN->4!=24 als AUSGANG"). Das ist ein ANDERER Strang/Task (C-1/#7/S-19), keine Lieferpflicht von pmc-paket selbst.
11. **Anhang-/Thesis-Text der Zen-5-Spalten-Semantik** — vom Strang selbst als spaeter faellig deklariert ("sobald der Mess-Anhang geschrieben wird"), kein W2-Pflichtpunkt jetzt. Quelle: SB Z.282-283, S1:254.
12. **super-CI-Sichtbarkeitszeile (Log-Grep `pmc=FEHLER`/`[PMC-WARN]`)** — von S1 ausdruecklich als "kein Muss" gefuehrt (Job faellt ohnehin hart ueber exit 1). Quelle: S1:235-236.

---

## SPANNUNGEN (Widersprueche zwischen Quellen — nicht glattgezogen)

**S-1 — "die 4 nicht-beissenden PMC-Wachen werden scharf" (KON103-02, 17.08.) vs. nur 0/4 NEU geschaerft.**
Der Owner-Bau-Folge-Satz vom 17.08. (LEDGER KON103-02 :1749-1751) verlangt woertlich, dass alle vier NP-30-Wachen-Fundstellen "scharf werden". Der Strang-Explore zeigt: W2 (`m3v2_pmc_smoke.cpp`) und W3 (`linux_perf_pmc_smoke.cpp`) waren bereits seit dem 06.08. (M-2/B3) scharf, W4 (Director-Emission) seit 06./10.08. Invariante — alle DREI bereits **vor** dem 17.08.-Owner-Satz erfuellt, weil die 17.08.-Vorlage (r3-Karte) auf einem stalen Stand basierte (Finding F-35, STAFFEL1). Nur **W1 (CMakeLists-Option, Vendor-leer=WARNING)** war zum 17.08. tatsaechlich noch "nicht-scharf" — und bleibt es nach diesem Strang WEITERHIN: die Strang-Begruendung (Finding F-41, "OFFEN (deklariert)") ist, dass ein FATAL-Flip jetzt zwei super-Altaufrufer (`measure:smoke`/`measure:golden-320`, die ON ohne Vendor setzen) hart rot brechen wuerde — ein Zielkonflikt mit der Doktrin "Pipeline immer gruen". Die juengere, praezisere Quelle (KON106-04, 17.08. abends) benennt NP-30 nur als "1:1 in Task #83 uebernehmen" (Fundstellen-Registrierung), nicht als expliziten Vier-von-Vier-Vollzugsbefehl — die Owner-KERN-Formulierung selbst ("werden scharf") ist aber nicht qualifiziert. **Der Audit muss selbst entscheiden, ob das bewusste Aufschieben von W1 (mit Begruendung, als Finding F-41 dokumentiert) die Owner-Bau-Folge vollstaendig erfuellt, oder ob hier eine echte Restluecke gegen den Wortlaut steht.**

**S-2 — NP-34 "IN DENSELBEN Zug buendeln" (KON106-04) vs. Strang-Scope endet am ce-Worktree.**
KON106-04 (:1300-1302) verlangt woertlich, den super-seitigen csv_to_latex-Kernmetrik-Caveat "in DENSELBEN Zug" wie I-PMC-2/3 zu buendeln, "damit Textaussage und Messvermoegen nie auseinanderlaufen". Der Strang-Auftrag (Worktree `wt-ce-pmcpaket`, Branch `bau/pmcpaket` im **ce**-Repo) hat keinen Schreibzugriff auf **super**. Der Strang dokumentiert dies offen als Folgepunkt (SB Z.274-275, F-40 "OFFEN"), erfuellt den Ledger-Wortlaut "denselben Zug" damit aber NICHT woertlich — der Textstand in super bleibt bis zum super-/Lande-Zug widerspruechlich zum jetzt gebauten Messvermoegen (Zen-5-Werte sind real, Text behauptet weiterhin "strukturell 0").

**S-3 — E-1-Abnahme "vor Trigger gelandet" vs. Strang-Status "LANDEREIF" (noch nicht gelandet).**
W2D:448-449 formuliert die Abnahme fuer #83 zweiteilig: "fail-loud-Paket gebaut, **vor Trigger gelandet**." Der zweite Teil ist zum Stand dieser Karte (21.08.) unerfuellt — der Branch ist LANDEREIF, aber nicht gemergt. Das ist (Stand jetzt) kein Defekt, weil die Frist Mi 26.08. 06:00 noch nicht erreicht ist und die Landung als eigener Fable-max-Zug explizit vorgesehen ist (Board #108) — der Audit sollte diesen Punkt aber NICHT mit den Code-Pflichten P-01..P-20 vermengen, da er ausschliesslich von der noch ausstehenden Lande-Stufe abhaengt, nicht vom pmc-paket-Strang selbst.

**S-4 — H-3/H-10-Harmonisierung ist ANGEKUENDIGT, aber am pmcpaket-Branch selbst NICHT beweisbar.**
STAFFEL1/2 benennen `cache_engine_builder_iterator.hpp` (H-3, drei disjunkte Zonen mit messfenster+s13) und `experiment_plan_director.hpp`+Testdatei (H-10, zwingende Merge-Reihenfolge VOR kampvor) als Harmonisierungs-Flaechen. Der pmcpaket-Ergebnisbericht selbst behauptet an diesen Stellen keine Kollision, kann sie aber naturgemaess nur einseitig (aus Sicht seines eigenen Branches) beurteilen — die tatsaechliche Harmonisierung ist erst am gemergten Endstand pruefbar, nicht am isolierten Branch-Stand 1d38263b.

**S-5 — WIDERSPRUCHSFREI, aber PRUEFENSWERT: zwei PMC-Warnpfade (C-11-INFO-Blatt vs. pmc_startup_pruefung-Log).**
mess-fenster (Schwesterstrang, Board #13) behauptet "C-11 hart/soft (PMC-Warnung REAL im xlsx-INFO-Blatt)"; pmc-paket baut unabhaengig davon `builder/pmc_startup_pruefung.hpp` mit `[PMC-WARN]`-Log-Ausgabe. Beide erfuellen denselben Owner-Satz ("Warnung bei (c) wenn PMC vorhanden, aber nicht verwendet") ueber ZWEI verschiedene Kanaele (INFO-Blatt vs. stderr-Log) in ZWEI verschiedenen Straengen. H-3 (STAFFEL1) stuft dies als disjunkte Zonen derselben Datei ein (keine Code-Kollision), aber ob die Inhalte beider Warnpfade fachlich DECKUNGSGLEICH sind (dieselbe Bedingung, denselben Nenner) ist am isolierten pmc-paket-Branch nicht zu pruefen — erst am gemergten Endstand.

---

Ende SOLL-KARTE pmcpaket. 24 Pflicht-Punkte (P-01..P-24), 12 ausdruecklich nicht geforderte Nachbar-Gegenstaende, 5 benannte Spannungen.
