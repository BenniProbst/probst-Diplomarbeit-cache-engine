# SOLL-KARTE — #7/S-19 PLANUNGS-SIMULATION (Strang s19-simulation)

Erhoben von: Sonnet-max-PLANUNGS-ERHEBER, 21.08.2026 (W2-Audit-Fix-Verify).
NUR LESEN — keine Objekt-Verifikation, keine Bewertung; das ist Aufgabe des Audits.
Objekt-Pointer (nur zur Orientierung sondiert, KEIN Fix, KEIN Urteil): ce `bau/s19` @ `a1b348ae`
(Basis `66de5c09`), Worktree `/home/comdare/wt-ce-s19`, 7 Dateien +1661/-67 (`git show --stat`
bestaetigt: `apps/experiment_planner/main.cpp`, `libs/cache_engine/profile_facade/planner/
planner_simulation.hpp` [neu], `libs/cache_engine/profile_facade/profile_run_facade.{hpp,cpp}`,
`tests/unit/CMakeLists.txt`, `tests/unit/test_s19_simulation_cli.cpp` [neu],
`tests/unit/test_s19_simulation_rechnung.cpp` [neu] — keine `axes/`/`topics/`/`heuristik/`-Datei
im Diff).

Wahrheits-Rangfolge dieser Karte: Owner-Wort (Ledger-KON, woertlich) > juengere KON >
Wellenplan §21-23 > §17-20 > Designplan > W2-ABFOLGE-DESIGN > Strang-Bericht. Der
Strang-Bericht selbst ist NUR Beweismaterial (GOAL II.3/V1), nie SOLL-Quelle.

--------------------------------------------------------------------------------
## PRUEFLISTE

### Gruppe A — Mandat und Verarbeitungs-Etappe

**P-01 — Neuer Bau-Posten "Planungs-Simulation", Pflicht nach der Stempel-Aufgabe.**
WAS: Ledger KON17-01 (Z.10123-10150), Owner woertlich: *"Die Zahl der Tier-Binaries (und je
XML Anforderung des Planers) muss durch den geforderten Algorithmus der Planungs-Simulation noch
berechnet werden, er ist Pflicht nach der stempel Aufgabe und schon geplant."* Vorbedingung
Wellenplan §18.4 Zeile `#7` (Z.2249): *"haengt an: Stempel-Strecke komplett (#4+#15+#16+#17,
KON17-01) · OF-2"*. W2-ABFOLGE-DESIGN C-1 (Z.178-180): *"Vorbedingungen: Stempel-Strecke komplett
(#4+#15+#16+#17, gelandet) + OF-2 (beantwortet)."* Ledger Z.106: *"Freigabe #7/S-19 damit WIRKSAM
(KON17-01)"* (an der #17-Landungsstelle).
WIE PRUEFBAR: Board-Status #4/#15/#16/#17 = completed pruefen (bereits so im Board vermerkt,
21.08.); OF-2-Status im Ledger (KON59-Marker/KON41-03/KON42) pruefen; `git merge-base` der 4
Stempel-Straenge gegen `ce/development` (bereits gelandet lt. Board #15/#16 mit CI-Beleg).
BEHAUPTET (Strang-Bericht): Uebernimmt die Vorbedingung als Fakt in der Auftrags-Kurzform
(Abschnitt 0) und im WIEDERANLAUF-Absatz, erhebt sie selbst NICHT neu am Objekt — reine
Referenz auf den C-1-Text.

**P-02 — Der Weg zur Zahl: GRUPPIEREN -> KATEGORISIEREN -> ueber den GESAMTEN Experiment-B+-Baum
rechnen (zwei getrennte Schritte, nicht einer).**
WAS: Ledger KON30-03 (Z.8570-8594), Owner woertlich: *"Weiterhin gibt es die Planungs Simulation
noch nicht, weil die Achsen im Planer zur Simulation noch nicht gruppiert und kategorisiert
wurden, um ueber den gesamten Experiment-B+-Baum die tatsaechliche Permutation zu errechnen ...
Wir beginnen beim Bau genau in der Traeger-Stufen-Reihenfolge um das zu erreichen."* Praezisiert
als: *"1. die Achsen IM PLANER zur Simulation GRUPPIEREN und KATEGORISIEREN. 2. ueber den
GESAMTEN Experiment-B+-Baum die tatsaechliche Permutation ERRECHNEN."* Wellenplan §17.5
(Z.2185) wiederholt denselben Zwei-Schritt-Weg woertlich fast identisch. Steckbrief-Kurzform
deckt sich: "gruppieren->kategorisieren->B+-Baum-Permutation".
WIE PRUEFBAR: `planner_simulation.hpp` am Objekt lesen — traegt sie eine erkennbare
Gruppierungs-/Kategorisierungs-Struktur (Typen wie `SimAchse`/`SimDynDim`) UND eine
Permutations-Rechnung, die den GESAMTEN Baum durchlaeuft (nicht nur eine XML-lokale Teilmenge)?
BEHAUPTET: JA — N-1 (Abschnitt 3) nennt `SimAchse/SimDynDim/SimulationsEingang/
SimulationsSicht` als neue Typen; B-2/N-3 beschreiben `collect_simulation_eingang_facade` als
"EIN Walk", der `MengenSollBuilder` umhuellt und je Achse ueber `is_organ_composition_axis` +
Registry-Fallback lauft (= "exakt build_axis_levels-Regel" laut Bericht).

**P-03 — Bau-Reihenfolge-Doktrin: PLANER -> CEB -> TIER -> HYBRID; S-19 rechnet als
PLANER-ETAPPE, NUR der Planer wird direkt kompiliert.**
WAS: Ledger KON17-01 woertlich: *"Nur Planer wird direkt kompiliert"*; KON30-03: *"Wir beginnen
beim Bau genau in der Traeger-Stufen-Reihenfolge"*; GOAL v8 VI.1(b) (Z.438-451, Owner-Wortlaut
09.08.) fuehrt `XML -> Planer -> CEB -> Tier-Binaries BAUEN -> ... -> MESSEN -> AUSWERTEN ->
RELEASE -> VEROEFFENTLICHEN`; GOAL REFERENZ-STAND-Nachtrag (Z.55-56, KON17-04): *"Bau-Reihenfolge
danach (KON17-04): Stempel -> Planungs-Simulation -> von der XML die GESAMTE Kette bis zur PDF —
S-13 ist KERN, nicht Anhang."*
WIE PRUEFBAR: `simulate`-Subkommando liegt im `comdare_experiment_planner`-Binary (main.cpp),
nicht in einer CEB-/Tier-Komponente; die Rechnung produziert nur ZAHLEN (kein CEB-/Tier-Bau
wird vom Subkommando selbst ausgeloest).
BEHAUPTET: JA — D.1 (Abschnitt 4): *"DEKLARIERT+GEBAUT als Planer-ETAPPE — der Bericht und die
Hilfe sagen woertlich 'PLANER-ETAPPE: der CEB-Rechen-Ort folgt mit S-10/S-22'."* Die Etappen-
Freigabe SELBST ist O1 (owner-gated Vorlage, s. P-11), NICHT vom Strang entschieden.

### Gruppe B — Bau-Umfang C.8(a)-(f) (W2-ABFOLGE-DESIGN C-1, Z.172-183, Designplan K4/TEIL4)

**P-04 — C.8(a) XML-FREIGABE-PRODUKT je Organ-Achse.**
WAS: W2-ABFOLGE-DESIGN C-1 (Z.174): *"(a) XML-Freigabe-PRODUKT je Organ-Achse"*.
WIE PRUEFBAR: `planner_simulation.hpp`: Formel `prod(|Freigabe-Werte|)` je der 18 Organ-Achsen;
golden-320-Objekt `m3v2_study.profile.xml`: 18 `permute_axes`, Produkt der Freigaben
`4*1*1*1*4*5*1*4*1*1*1*1*1*1*1*1*1*1 = 320`.
BEHAUPTET: JA — Explore E-2 (Abschnitt 1) bestaetigt die LUECKE existierte vorher am Objekt
(kein Feld rechnete `prod(|values|)`, Plan-Kopf trug nur axes+values-SUMME); Bau-Design B-1(a) +
Vollzug N-1/N-3 behaupten den Bau; Abschnitt 7 zeigt `organ_produkt = 320` mit vollem Rechenweg
je Achse.

**P-05 — C.8(b) dynamic_dims-Produkt.**
WAS: W2-ABFOLGE-DESIGN C-1 (Z.174): *"(b) dynamic_dims-Produkt"*.
WIE PRUEFBAR: Formel `dyn_produkt` OHNE `repetition`-Faktor (Doppelzaehl-Falle, KF-10 zaehlt
genau einmal); golden-320: `dyn_produkt = 72` (`1*3*6*4`: thread_count x hw_prefetcher x
workloads x working_set_sweep).
BEHAUPTET: JA — B-1(b)/N-1 (Abschnitt 2+3): *"dyn_produkt OHNE repetition (Doppelzaehl-Falle:
repetition ist KF-10, genau EINMAL)"*; Abschnitt 7: *"dyn_produkt 72 (1*3*6*4, OHNE
repetition)"*.

**P-06 — C.8(c) T-15xKF-10=9 Messungen je Zelle + x5-Klammer in der Mengen-Formel.**
WAS: W2-ABFOLGE-DESIGN C-1 (Z.175): *"(c) T-15xKF-10=9 + x5-Klammer in Mengen-Formel"*.
Wellenplan §19.3 C-04 (Z.2463-2464): *"T-15 x KF-10 = 9 Messungen je Zelle: MESS-Phase
verdreifacht sich -> --check-size + S-19-Rechnung (Z15403) -> #7."*
WIE PRUEFBAR: Formel-Zeile `T-15 x KF-10 = 3*3 = 9` im `simulations_bericht`; x5-Klammer als
EIGENE, NICHT multiplizierte Zeile im Bericht.
BEHAUPTET: JA fuer die Formel selbst — Abschnitt 7: *"T-15 x KF-10 = 3*3 = 9 · ...
x5-Klammer als Zeile, NICHT multipliziert."* ABER die zugrundeliegende Arena-Zahl ist zum
Berichtszeitpunkt die AELTERE 18er-Lesart, nicht die waehrend derselben Staffel vom
Schwester-Strang mess-fenster ENTSCHIEDENE 120er-Zahl — siehe P-20/SPANNUNG 1.

**P-07 — C.8(d) PMC-Tor + Rekombination (3!/4!) als AUSGANG; "24 oder 48" NIE als Vorgabe im
Code.**
WAS: W2-ABFOLGE-DESIGN C-1 (Z.175-176): *"(d) PMC-Tor + 3!/4!-Rekombination, Ausgang '24 oder
48' NIE als Vorgabe"*.
WIE PRUEFBAR: Am Objekt `grep -n "24\|48" libs/.../planner_simulation.hpp` sollte KEIN hartes
Nenner-Literal treffen (nur ggf. in Kommentaren/Test-Orakeln); Rekombination =
`fakultaet(messgeraete)`, `messgeraete` aus gemessener PMC-Torlage.
BEHAUPTET: JA — Abschnitt 3 (N-1): *"KEIN Nenner-Literal im Code (kein 320/131072/24/48)"*;
Echtlauf (Abschnitt 7): PMC-Befund `events=3/4` -> Tor AN -> `messgeraete 3+1=4` ->
`rekombination = 4! = 24` — als AUSGANG einer echten Messung, nicht als Konstante.

**P-08 — C.8(e) Kapazitaets-/ETA-Anschluss + OV-4-Deckel als AUSGANG, fail-closed
UNBESTIMMBAR ohne Kalibrierung (deckt sich mit "GN-9-Anschluss fail-closed" im Steckbrief und
mit O4/OG-13).**
WAS: W2-ABFOLGE-DESIGN C-1 (Z.176): *"(e) Kapazitaets-/ETA-Anschluss + OV-4-Deckel als
AUSGANG"*; OG-13 (Z.538-541): *"O4 GN-9-1-Zellen-Kalibrierlauf VOR/IM Sa-Lauf ODER Herabstufung
— O4 ZEITKRITISCH (sonst sekunden_je_op Schaetzung, Deckel ggf. unbestimmbar); Bau haengt laut
D4 NICHT daran (Melden != Fragen)."* Wellenplan §19.3 C-03 (Z.2460-2462): *"OV-4-Deckel = f(T-3):
einlanig 41,4h@24W -> ~45,6h@16W; KEIN amd-16W-Trace; Deckel-Rechnung mit S-19-Zahlen VOR
GO-Vorlage ##51 + Pflicht-Nachkalibrierung."*
WIE PRUEFBAR: CLI-Wegwerf-Mutation (Bericht-Test L6/L9) zeigt: ohne `--t3-fenster-tage`/
`--bytes-je-dll` fällt die Ausgabe auf `UNBESTIMMBAR`, NICHT auf einen stillen Default.
BEHAUPTET: JA — Abschnitt 7 DECKEL(e): *"zeit kein_deckel (bewusst ohne --t3-fenster-tage:
sekunden_je_op existiert NICHT gemessen -> mit Fenster faellt der Lauf fail-closed UNBESTIMMBAR
= der O4-Zustand; im CLI-Test L6 literal belegt)"*; lager-Deckel HAELT gerechnet
(`136.960.000 B = 320*428000` gegen 6 TB).

**P-09 — C.8(f) Kampagnen-Aggregation ueber mehrere XMLs (Summe n_bau + FULL-JOIN-Union je
Achse + Kandidaten-Gegenprobe; Kandidaten NUR CLI-Eingang, nie einkompiliert).**
WAS: W2-ABFOLGE-DESIGN C-1 (Z.177): *"(f) Kampagnen-Aggregation ueber mehrere XMLs."*
WIE PRUEFBAR: `simulate profil1.xml profil2.xml ...` liefert `kampagnen_bericht` mit
`summe_n_bau`/`union_produkt`; `--kandidaten` ist ein reines CLI-Flag ohne Code-Literal.
BEHAUPTET: JA fuer den Mechanismus, aber NUR MIT EINEM Profil real durchgefahren (golden-320
ist eine Ein-Profil-Kampagne) — Abschnitt 7: *"B-4(Kampagne {m3v2_study}) = SUMME n_bau = 320;
FULL-JOIN-Produkt 320 x 1 = 320"*. Die Mehr-Profil-Kampagne (mehrere ECHTE Kampagnen-XMLs) ist
ausdruecklich dem Sa-Mo-Lauf 22.-24.08. zugewiesen, NICHT diesem Strang-Auftrag — siehe
NICHT-GEFORDERT.

**P-10 — Gesamt-Abnahme-Satz C-1 woertlich.**
WAS: W2-ABFOLGE-DESIGN C-1 (Z.181-183): *"ABNAHME: B-4-Zahl liegt vor; je C.8-Posten eigene
Ausgabe; D.1-D.10 benannt abgedeckt; C-04-Verdreifachung in der Rechnung."*
WIE PRUEFBAR: `simulations_bericht` traegt je C.8-Zeile eine EIGENE Ausgabezeile (nicht
verschmolzen); Strang-Bericht traegt einen Abschnitt, der D.1-D.10 vollzaehlig je
GEBAUT/DEKLARIERT ausweist.
BEHAUPTET: JA — Abschnitt 4 des Berichts fuehrt D.1-D.10 einzeln; B-4-Zahl=320 mit Rechenweg in
Abschnitt 7; C-04-Verdreifachung (`T-15 x KF-10 = 9`) explizit in der Rechnung enthalten.

### Gruppe C — Owner-Gates (NICHT entscheiden, nur Vorlage)

**P-11 — Owner-Punkte O1-O4 duerfen NUR als Vorlage-Zeilen erscheinen, nicht als vom Strang
getroffene Entscheidung.**
WAS: OG-13 (W2-ABFOLGE-DESIGN Z.538-541): *"O1 Planer-only-Etappe bestaetigen · O2 n_ops/
drift_gate ins Schema · O3 XML-Traeger Mess-Teilmenge · O4 GN-9-1-Zellen-Kalibrierlauf VOR/IM
Sa-Lauf ODER Herabstufung."* Auftragstext (Steckbrief-Umfeld, s19-Bericht Abschnitt 0): *"Owner-
Punkte O1-O4 NICHT entscheiden (Vorlage-Zeilen)."* STAFFEL1-SYNTHESE (Z.198-208) fuehrt die
vier Vorlage-Formulierungen woertlich (Primaertraeger `F2-VORLAGEN-FENSTER-ENTWURF.md`).
WIE PRUEFBAR: Strang-Bericht-Abschnitt "OWNER-PUNKTE" enthaelt GENAU 4 Vorlage-Saetze, keine
impliziten Vorentscheidungen (z.B. keine feste Schema-Erweiterung fuer O2, kein fest gewaehlter
XML-Traeger fuer O3).
BEHAUPTET: JA — Abschnitt 5 traegt exakt 4 VORLAGE-Zeilen, ueberschrieben *"NUR VORLAGE-ZEILEN
(nicht entschieden, nicht gebaut)"*.

### Gruppe D — TDD-Pflichten (Designplan §3/§11, GOAL VIII)

**P-12 — TDD-Vertrag T-1..T-9 gilt fuer jedes neue Test-Paket (Designplan §3, Z.63-75).**
WAS (woertlich, Auswahl): *"T-1 ROT ZUERST. Der Test ist am ersten Tag rot, ODER sein Biss ist
per protokollierter Wegwerf-Mutation bewiesen."* · *"T-3 NENNER, FREMD. Jeder Test nennt seine
Grundgesamtheit und bezieht sie aus einer anderen Quelle als dem Pruefling."* · *"T-7
REGISTRIERUNG IST TEIL DES TESTS. Ein Test existiert erst, wenn er in `ctest -N` erscheint und
sein Binary im Bauweg haengt."* · *"T-8 ATOMARE LANDUNG. ... auf development landen Test +
Minimalbau atomar."*
WIE PRUEFBAR: `ctest -N` zeigt `test_s19_simulation_rechnung`/`test_s19_simulation_cli`
registriert; Orakel-Herkunft (Hand-Rechnung/`bc`) pruefen, nicht aus dem Pruefling kopiert.
BEHAUPTET: JA fuer T-1/T-3/T-7 — 2 protokollierte Wegwerf-Mutationen mit literalem Rot
(Abschnitt 3+7); N-5 nennt *"89 Pruefungen: S/R/E/G/F-Bloecke"* + *"20 Pruefungen ... Orakel aus
dem XML"* als Hand-Orakel (T-5 unabhaengig); T-7 durch `ctest -N` Tests #511/#512 belegt.
T-8 (ATOMARE LANDUNG) ist per Status LANDEREIF explizit NOCH NICHT vollzogen — bleibt
Lande-Zug-Pflicht, kein Strang-Defizit.

**P-13 — T-11b KOMBIBAU-2x2-MATRIX (Designplan Z.645, KON55): {clang,gcc}x{Debug,Release} = 4
Zellen je J-1..J-4 + ctest, PFLICHT vor jeder Wellen-Abnahme.**
WAS: *"jede Landung ist erst gruen, wenn {clang, gcc} x {Debug, Release} = 4 Zellen je J-1...J-4
+ ctest durchlaufen ... GEZAEHLTE Pflicht: 4 Zellen, je mit literaler ctest-Bilanz."*
WIE PRUEFBAR: 4 protokollierte ctest-Laeufe (gcc-Debug, gcc-Release, clang-Debug, clang-Release).
BEHAUPTET: BEWUSST NICHT im Strang selbst — Abschnitt 9 (Endstand): *"clang-Zelle lief hier
nicht (gcc-Release-Zelle war die Auftrags-Mindestprobe — Warnungs-Review clang gehoert dem
Lande-Zug)."* Nur gcc-Release gefahren (RC=0, ctest 512/512 nach Anker-Heilung). Deckt sich mit
W2-ABFOLGE-DESIGN TEIL 3 SLOT [C] (Z.807): *"S1 wt-s19: C-1 (Planer-Etappe; kein Vollbau-Bedarf
ausser Smoke)"* — der volle T-11b-Kombibau ist laut STAFFEL1-SYNTHESE (Phase 3, Z.88-93)
explizit "EINMAL am gemergten ce-Endstand", also NICHT je Einzelstrang.

**P-14 — T-11c MUTATIONS-PROTOKOLL (Designplan Z.647, KON57): je neuem Test >=1 protokollierte
Wegwerf-Mutation mit literalem Rot + Gegenprobe-Gruen.**
WIE PRUEFBAR: Mind. 2 Mutationsprotokolle (je 1 pro neuer Testdatei) mit RC/Pruefungs-Bilanz
vorher/nachher.
BEHAUPTET: JA — Abschnitt 3 (Mutation 1, `fakultaet_sicher` Schleifenindex-Fehler): *"ROT: 89
Pruefungen, 15 rot" RC=1 ... Revert -> "GRUEN: 89 Pruefungen, 0 rot" RC=0.*; Abschnitt 7
(Mutation 2, `run_simulate_guarded` verliert `--bytes-je-dll`): *"ROT: 20 Pruefungen, 2 rot"
RC=1 ... Revert -> "GRUEN: 20 Pruefungen, 0 rot" RC=0.*

### Gruppe E — Betriebs-/Bau-Doktrin dieser Session

**P-15 — Bau-Slot-Doktrin (Drei-Bauten-Deckel, W2-ABFOLGE-DESIGN TEIL 3 Z.790, 807).**
WAS: *"Drei-Bauten-Deckel (MAX 3 lokale Vollbauten)"*; *"S1 wt-s19: C-1 (Planer-Etappe; kein
Vollbau-Bedarf ausser Smoke)"*; Staffelungs-Vorrang (Z.813-815): *"Sa-Vormittag S1+S2 exklusiv
(Trigger-Pflichten ZUERST, §21.3)."*
WIE PRUEFBAR: Bau-Slot-Verzeichnis-Log des Strangs; `df -h`-Gate vor Vollbau; Slot-Freigabe nach
ctest.
BEHAUPTET: JA — Bericht: *"BAU-SLOT: slot2 (slot1 haelt prtart-pin-duo, fremd, unangetastet).
df 32G frei."*; Abschnitt 9: *"Bau-Slot 2 freigegeben (slot1 hielt durchgehend prtart-pin-duo,
fremd, unangetastet), porcelain 0."* — ABWEICHUNG von der Slot-Erwartung "kein Vollbau-Bedarf
ausser Smoke": der Strang fuhr tatsaechlich die VOLLE Bau-Treppe (2519 Ziele) + vollen ctest,
nicht nur einen Smoke-Test — siehe SPANNUNG 6.

**P-16 — Code-Hygiene/TABU: clang-format-22 ueber jede geaenderte Lint-Datei; ASCII-only in
neuen Zeilen; nichts unter `axes/`/`topics/`/`heuristik/`; `tests/unit/CMakeLists.txt` NUR ans
Dateiende.**
WIE PRUEFBAR: `clang-format-22 --dry-run --Werror` ueber die 6 Lint-Dateien RC=0; `git diff`
CMakeLists nur am Dateiende; `git show --stat` 0 Treffer unter `axes/`/`topics/`/`heuristik/`.
BEHAUPTET: JA — Bericht: *"clang-format-22 --dry-run --Werror ueber alle 6 Lint-Dateien: RC=0
(nach -i-Lauf)"*; N-6: *"Registrierung ANS DATEIENDE"*; eigene `git show --stat`-Sondierung
(oben) bestaetigt: 7 Dateien, keine unter `axes/`/`topics/`/`heuristik/`.

**P-17 — Beweis-Doktrin: jede Behauptung mit Literal (Datei:Zeile, RC, ctest-Bilanz); GOAL
II.5 "Nenner nie eine nackte Zahl"; GOAL VII.2 "Nenner, Rot-/Gruen-Lauf, Koeder".**
WIE PRUEFBAR: Stichprobe der zitierten Datei:Zeile-Anker am Objektstand (z.B.
`experiment_plan_director.hpp:543`/`:552` fuer `PlanSizeBuilder`).
BEHAUPTET: JA durchgehend — praktisch jede Zahl im Bericht traegt einen Datei:Zeile-Beleg
(E-1..E-10, N-1..N-6); der Anker-Drift D.10 wird selbst offen ausgewiesen statt verschwiegen
(Wellenplan-Anker `:489` vs. real `:543`/`:552`, "dritte Bestaetigung am Objekt" laut
STAFFEL1-SYNTHESE F-01).

**P-18 — Gruen-Probe-Treppe (J-0b -> J-1 SIEBEN Werkzeuge -> RE-CONFIGURE -> all -> Ziel-Targets
-> ctest) mit voller literaler Bilanz, gemaess dieser Session-Bau-Regel.**
WIE PRUEFBAR: RC=0 je Treppen-Stufe; `ctest --no-tests=error` voller Lauf mit literaler Bilanz.
BEHAUPTET: JA — Abschnitt 8: volle Treppe RC=0 je Stufe (`--target all` 2519 Ziele, `comdare_
profile_run_facade`, `comdare_tests`); ctest Lauf 1: *"99% tests passed, 1 tests failed out of
512"* (Anker-Ratsche-Fund F-04, HEILUNG dokumentiert) -> Re-Run *"100% tests passed, 0 tests
failed out of 512"* (CTEST2_RC=0).

**P-19 — Origin-Sicherung nach Fix-Commit (`git push -o ci.skip`), Commit-Trailer
Co-Authored-By.**
WIE PRUEFBAR: `git log`/`git show` auf `origin/bau/s19` zeigt denselben Tip `a1b348ae`;
Commit-Message traegt den Trailer.
BEHAUPTET: JA — Abschnitt 9: *"origin-Sicherung `git push -o ci.skip origin bau/s19` OK
('[new branch] bau/s19 -> bau/s19')."* Eigene Sondierung (`git show bau/s19`) bestaetigt Tip
`a1b348ae` und den Trailer `Co-Authored-By: Claude Fable 5 <noreply@anthropic.com>`.

### Gruppe F — Cross-Strang-Kopplungen, aus dieser Aufgabe heraus offen

**P-20 — H-5-Kopplung: Arena-/Mengen-Zahl 18 -> 120 nach D.7-Entscheid des Schwester-Strangs
mess-fenster.**
WAS: STAFFEL1-SYNTHESE H-5 (Z.53-57): *"mess-fenster hat D.7 ENTSCHIEDEN (drift-Default 12,
paar 2, retry 5 => arena_gesamt_faktor 120; Eigentuemer measure_storage/#13). s19-Bericht/
Zeilen tragen noch 'drift_worst_arena 18' + 'x5 als Zeile, NICHT multipliziert' — beim
s19-Merge auf 120er-Basis NACHZIEHEN."* F-10 (Z.115): *"Zahlen-Kopplung 18->120 nach
D.7-Entscheid | OFFEN -> LANDE-ZUG (Pflicht) | H-5 beim s19-Merge (Eigentuemer measure_storage/
#13)."* W2-ABFOLGE-DESIGN C-2 (Z.190) benennt den Eigentuemer explizit: *"D.7-Arena-Widerspruch
(Faktor 2 vs. bis 18) — Eigentuemer measure_storage/#13, S-19 druckt beide Lesarten."*
WIE PRUEFBAR: Nach dem Lande-Merge mit `bau/messfenster`: `grep "arena_gesamt_faktor\|
drift_worst_arena"` in `planner_simulation.hpp`/Bericht — Soll = 120, nicht mehr 18.
BEHAUPTET: Vom Strang SELBST als offen erkannt (D.7 Abschnitt 4: *"GEBAUT als BEIDE Lesarten
... Entscheid bleibt measure_storage/#13"*) und in STAFFEL1-SYNTHESE explizit als
Lande-Zug-Pflicht (nicht Strang-Pflicht) eingeordnet, WEIL der 120er-Wert erst waehrend
derselben Staffel im PARALLELEN Strang mess-fenster entschieden wurde.

**P-21 — GN-9-Kalibrierlauf SELBST (der Lauf, nicht der Mechanismus) ist NICHT Teil dieses
Strangs.**
WAS: OG-13/O4 (s.P-08/P-11); STAFFEL1-SYNTHESE F-73 (Z.178): *"GN-9 / O4 | Kalibrierlauf
VOR/IM Sa-Lauf ODER deklarierte Herabstufung; sonst Zeit-Deckel fail-closed UNBESTIMMBAR (so
gebaut) | OFFEN — FRIST vor Sa 22.08. | Owner (V-10)"*; C-1 (Z.176): *"Bau haengt laut D4 NICHT
daran (Melden != Fragen)."*
WIE PRUEFBAR: Existiert ein Kalibrierlauf-Log/Ergebnis mit echten `sekunden_je_op`-Werten?
(Betriebsposten, NICHT im Strang-Diff zu suchen.)
BEHAUPTET: Explizit AUSSERHALB des Bau-Scopes — der Strang liefert nur den korrekten
FAIL-CLOSED-MECHANISMUS (P-08), nicht den Kalibrierlauf selbst; dieser ist Owner-/Betriebssache
vor Sa 22.08.

### Gruppe G — Weitergehende Doktrin-Pruefpunkte (GOAL v8 / Wellenplan-Nebenzeilen)

**P-22 — GOAL VI.2: "jede Groessenrechnung" muss den Hybrid-Mehrfach-Aufbau mitrechnen.**
WAS: GOAL v8 VI.2 (Z.502-506) woertlich: *"wie SearchAlgorithm die Container-Gattung nutzt, kann
die Heuristik-Tier-Binary-Strategie direkt im SearchAlgorithm-Hauptalgorithmus als
Heuristik-Hybrid-Achse aufgerufen werden, mit zwei Ausgaengen: direkter Tier-Aufbau ODER
Hybrid-Mehrfach-Aufbau. Sie wirkt auf den Bauplan, nicht nur auf den Bauinhalt —
`--check-size` muss sie mitrechnen, sonst ist jede Groessenrechnung strukturell zu klein."*
B-4-Zahl ist eine Groessenrechnung im Sinne dieses Satzes (sie ersetzt/ergaenzt `--check-size`
als Bau-Nenner-Quelle, Wellenplan §18.4 Z.2249).
WIE PRUEFBAR: `grep -ni hybrid` in `planner_simulation.hpp`/`profile_run_facade.{hpp,cpp}` am
Objekt; pruefen ob ein Hybrid-Mehrfach-Aufbau-Zweig strukturell in `organ_produkt`/`n_bau`
einfliesst, bewusst ausserhalb bleibt (mit Beleg wo/warum), oder unbehandelt ist.
BEHAUPTET: Der Strang-Bericht erwaehnt "hybrid" AN KEINER STELLE — Gegenprobe `grep -ni hybrid
s19-simulation-ergebnis.md` liefert 0 Treffer (RC=1); Kontroll-Gegenprobe `grep -ni golden`
auf derselben Datei liefert 9 Treffer (Werkzeug greift korrekt, kein Falsch-Null). D.1
deklariert die Kette nur bis "CEB-Rechen-Ort S-10/S-22", HYBRID wird nirgends genannt. Siehe
SPANNUNG 3 — echter Gap oder bewusst aus dem Planer-Etappen-Scope ausgenommen ist am Objekt zu
klaeren, NICHT hier zu entscheiden.

**P-23 — Der ECHTE Simulationslauf am golden-320-Profil, B-4-Zahl MIT vollem Rechenweg
(expliziter Auftrags-Teil 3, deckt sich mit dem Steckbrief-Stichwort "golden-320-Probe").**
WAS: Strang-Eigenauftrag Abschnitt 0 (aus C-1 abgeleitet): *"(3) Ein echter Simulationslauf am
golden-320-Profil, B-4-Zahl MIT Rechenweg."* Deckt C-1s Abnahme-Kern "B-4-Zahl liegt vor" (P-10)
konkret am golden-320-Objekt.
WIE PRUEFBAR: Datei `s19-simulation-echtlauf-golden320.txt` existiert (neben dem
Ergebnis-Bericht) und enthaelt den vollen `simulate`-Aufruf + volle Ausgabe.
BEHAUPTET: JA — Abschnitt 7 vollstaendig: Kommando `simulate m3v2_study.profile.xml
--kandidaten=... --bau-sekunden-je-dll=1282.5 --bytes-je-dll=428000
--lager-budget-bytes=6000000000000`; jede Rechenzeile mit ART+NENNER; Datei referenziert.

**P-24 — Pruefling = drittes Konzept (XML-beschraenkbar 1-3) als S-19-Eingang.**
WAS: Wellenplan §19.4 D-09 (Z.2515-2516): *"Pruefling = drittes Konzept, XML-beschraenkbar 1..3,
ERWEITERT den Permutationssatz (KON30-02/KON31) -> S-19-Input + prt-art-Rolle."*
W2-ABFOLGE-DESIGN D-4 (Z.320-321) wiederholt: *"D-09 Pruefling=drittes Konzept (XML-
beschraenkbar 1..3, erweitert Permutationssatz; S-19-Input)."* Wellenplan §17.5 definiert
PRUEFLING als *"Mess-Unter-Achse des Planers zur Laufzeit; je Organ-Achse zusaetzliche
Algorithmen, eigener Stempel je Pruefling-Algorithmus."*
WIE PRUEFBAR: Pruefen, ob `organ_produkt`/die Freigabe-Werte je Achse die Pruefling-
Algorithmen-Variantenzahl (1-3) strukturell mitzaehlen (z.B. weil sie Teil der
`allowed_variants`/values.size() je Achse sind) oder ob ein separater Faktor fehlt.
BEHAUPTET: Der Strang-Bericht nennt "Pruefling"/"Prüfling" AN KEINER Stelle (Gegenprobe
`grep -ni "pruefling\|prüfling"` liefert nur 2 Treffer, beide fuer die unabhaengige
CMake-Variable `COMDARE_CE_PRUEFLINGE` aus der Bau-Treppe, NICHT fuer das semantische
Pruefling-Konzept). Ob das strukturell ueber "Freigabe-Werte je Organ-Achse" (P-04) bereits
abgedeckt ist, ist am Objekt zu pruefen — hier nicht behauptet, nicht verneint.

--------------------------------------------------------------------------------
## ABNAHME-FORMELN (woertlich, Quelle+Zeile)

1. **W2-ABFOLGE-DESIGN C-1** (Z.181-183): *"ABNAHME: B-4-Zahl liegt vor; je C.8-Posten eigene
   Ausgabe; D.1-D.10 benannt abgedeckt; C-04-Verdreifachung in der Rechnung."*
2. **Wellenplan §18.4, Zeile #7** (Z.2249): Klasse **(M)** (vor Trigger Mi 26.08. 06:00 fest);
   *"haengt an: Stempel-Strecke komplett (#4+#15+#16+#17, KON17-01) · OF-2."*
3. **Ledger KON30-03** — der Weg zur Zahl, zwei Schritte (Z.8582-8586, woertlich s. P-02).
4. **Ledger KON17-01** — *"Nur Planer wird direkt kompiliert"* + *"Pflicht nach der stempel
   Aufgabe und schon geplant"* (Z.10126-10130).
5. **Designplan §3, T-1** (Z.67): *"Der Test ist am ersten Tag rot, ODER sein Biss ist per
   protokollierter Wegwerf-Mutation bewiesen (Rot gesehen, dann zurueckgenommen). Beides fehlt =
   kein Test."*
6. **Designplan §11, T-11c** (Z.647): *"GEZAEHLTE Pflicht je Paket: je neuem Test >=1
   Wegwerf-Mutation mit literalem Rot + Gegenprobe-Gruen."*
7. **Designplan §11, T-11b** (Z.645): *"GEZAEHLTE Pflicht: 4 Zellen, je mit literaler
   ctest-Bilanz; ... Abnahme-Regel, kein Einzeltest-Posten: sie gehoert in die Wellen-Abnahme
   (§4) jedes Stempel-/Mess-Pakets."* — ausdruecklich Wellen-Abnahme, nicht Strang-Abnahme.
8. **GOAL v8 VII.2** (Z.641-645): *"Eine Welle ohne beissende Wache gilt als nicht abgenommen —
   und beidseitig: ein Paket ohne Abnahmezeile ebenso wenig wie eine Abnahmezeile ohne Paket."*
   *"Zu jeder Abnahme gehoert die Antwort auf 'was erzwingt das Halten?' Zulaessig: ein Werkzeug
   oder eine ausdruecklich als ungedeckt benannte Stelle."*
9. **OG-13** (W2-ABFOLGE-DESIGN Z.538-541), vollstaendige O1-O4-Vorlage-Formeln (s. P-11).
10. **Wellenplan §21.3 Band B** (Z.2998): *"NEUE Platzierung = W2-Randslots Mo/Di 24./25. ... +
    WE 22./23. nach S-19/T-15b-Kern + Rest W3-Batch-Pausen [lok]"* — S-19 ist selbst ein
    Fristanker fuer NACHFOLGENDE Wiederaufnahme-Posten, nicht nur Empfaenger von Fristen.
11. **Kritischer Pfad** (W2-ABFOLGE-DESIGN TEIL 2, Z.779-782): *"KRITISCHER PFAD (laengster
    nicht komprimierbarer Strang): OG-11-Platte -> C-1 S-19 (Sa-Mo) -> E-6 Deckel -> E-4
    Gate-Vorlage + ##51-GO + E-5 Signal -> Trigger Mi 06:00."* S-19 ist damit der laengste
    Einzelposten auf dem Weg zum Trigger — jede Verzoegerung hier verschiebt den Trigger direkt.

--------------------------------------------------------------------------------
## NICHT-GEFORDERT (deklarierte Nachfolge-Zuege — Audit soll hier KEINE Phantom-Funde erheben)

- **CEB-Rechen-Ort selbst** (die eigentliche Rechnung auf CEB-Stufe) — folgt laut D.1 des
  Strang-Berichts explizit mit S-10/S-22 (bzw. Wellenplan-Zeile O1: *"CEB-Rechen-Ort folgt mit
  S-22/#53"*); S-19 rechnet NUR die Planer-Etappe.
- **Owner-Entscheidungen O1-O4 selbst** — der Auftrag verbietet ausdruecklich, sie zu
  entscheiden ("Owner-Punkte O1-O4 NICHT entscheiden"); nur Vorlage-Zeilen sind gefordert (P-11).
- **`<n_ops>`/`<drift_gate>`-Schema-Erweiterung** — das ist O2, ausdruecklich owner-gated;
  bis dahin rechnen Paper-XMLs mit Defaults (vom Strang als "default" markiert, nicht heimlich
  fest verdrahtet).
- **Fester XML-Traeger der Mess-Teilmenge** — das ist O3; nur ein Interims-CLI-Eingang
  (`--mess-teilmenge`) ist gefordert, kein Schema-Feld.
- **Der GN-9-Kalibrierlauf selbst** (der 1-Zellen-Lauf mit realen `sekunden_je_op`-Werten) —
  Betriebsposten fuer den Sa-Lauf 22.-24.08., ausdruecklich NICHT Bau-Blocker fuer diesen Strang
  (s. P-21).
- **Der Sa-Mo-Kampagnenlauf mit ECHTEN mehreren Kampagnen-XMLs** (+ ggf.
  `--fremde-lane=intel`) — STAFFEL1-SYNTHESE (Z.244-246) und STAFFEL2-SYNTHESE (Z.319) weisen
  dies ausdruecklich dem Zeitfenster 22.-24.08. zu, NICHT diesem Strang-Auftrag, der nur EINE
  golden-320-Probe fahren musste.
- **T-11b-Vollkombibau (4 Zellen) und die zweite (clang-)Warnungs-Runde** — laut
  W2-ABFOLGE-DESIGN TEIL 3 (Slot [C]) ausdruecklich "kein Vollbau-Bedarf ausser Smoke" fuer
  diesen Slot; der volle Kombibau ist laut STAFFEL1-SYNTHESE Phase 3 "EINMAL am gemergten
  ce-Endstand" vorgesehen (Lande-Zug-Sache).
- **18->120-Arena-Zahlen-Nachzug (H-5)** — Eigentuemer ist der Schwester-Strang mess-fenster/
  measure_storage (#13); s19 "reuse" nur `planner_mengen_types.hpp`, uebernimmt die Zahl aber
  erst im Lande-Merge (P-20).
- **K17-Kombibau am gemergten Endstand + Push + CI-Gruen-Verifikation** — explizit
  Lande-Zug-Phase-3/4-Sache (STAFFEL1-SYNTHESE Z.88-93), nicht Teil des Einzelstrang-Auftrags.
- **Die Landung selbst** (Merge nach `ce/development`) — Status ist bewusst "LANDEREIF", nicht
  "GELANDET"; der Merge ist Lead-Sache in der vorgesehenen Reihenfolge (STAFFEL1-SYNTHESE
  Phase 1, Schritt 2: nach `bau/messfenster`, vor `bau/s13schema`).
- **Eine konkrete 12-Perm-Kapazitaets-Zahl** — D.8 des Strang-Berichts nennt ausdruecklich nur
  die MECHANIK als gefordert ("n_bau = organ_produkt x system_perms rechnet JEDE deklarierte
  Perm-Menge"); die konkrete Zahl "folgt aus dem Sa-Lauf mit entsprechender XML (kein statischer
  Nenner vorgelegt)" — das deckt sich mit der Dauerregel "MESS-PERMUTATION DYNAMISCH >32, NUR
  S-19 RECHNET" (NIE statische Nenner vorlegen).
- **Die Rekombinations-ORDNUNG (n!) als feste Vorgabe** — D.9 des Strang-Berichts: *"die
  Rekombinations-ORDNUNG n! ist AUSGANG (Zeile 'NIE Vorgabe')"*; ein fester Wert waere
  Auftragsverletzung, kein fehlendes Feature.
- **Der Wellenplan-Pflegepass fuer den Anker-Drift `:489`->`:543`/`:552` (D.10)** — der
  Strang-Bericht selbst weist dies als "Wellenplan-Pflegepass ist Lead-Sache (Ledger-ENTWURF
  unten), NICHT von mir geschrieben" aus.
- **Die Ledger-Zeilen selbst** (ENTWURF-1/ENTWURF-2 im Strang-Bericht Abschnitt 6) — der Strang
  liefert nur ENTWUERFE; das tatsaechliche Einpflegen in den Ledger ist Lead-only.

--------------------------------------------------------------------------------
## SPANNUNGEN (Widersprueche zwischen Quellen — NICHT glattgezogen)

**SPANNUNG 1 — Arena-/Mengen-Faktor: 2 (alte Wellenplan-Lesart) vs. 18 (C-1-/Strang-Lesart) vs.
120 (juengste, waehrend derselben Staffel entschiedene Lesart).**
W2-ABFOLGE-DESIGN C-2 (Z.189, aelterer Kontext-Verweis auf D.7): *"D.7-Arena-Widerspruch (Faktor
2 vs. bis 18)"*. Derselbe C-1-Auftrag (Z.175) verlangt "18er-Arena-Lesart (D.7 beide)" als
Bau-Auftrag an s19 SELBST — d.h. der Plan wusste beim Design bereits, dass diese Zahl strittig
ist, und liess s19 bewusst BEIDE Lesarten drucken. WAEHREND DERSELBEN Staffel 1 hat der
parallele Strang mess-fenster (Eigentuemer laut W2-ABFOLGE-DESIGN C-2) D.7 auf **120**
(`12*2*5`, Default-Drift 12 x Paar 2 x Retry 5) ENTSCHIEDEN — eine dritte, juengere Zahl, die
weder im urspruenglichen C-1-Auftragstext (18) noch im aeltesten Wellenplan-Kontext (2) steht.
JUENGSTE SCHICHT: der mess-fenster-D.7-Entscheid (120), NOCH NICHT im s19-Bericht nachgezogen
(offen erklaert als H-5/F-10, Lande-Zug-Pflicht). Der s19-Strang selbst hat NICHT falsch
gehandelt (er durfte die 120er-Zahl zum Erhebungszeitpunkt nicht kennen, da beide Straenge
parallel liefen) — die Spannung ist eine ECHTE Nachzugspflicht, kein Fehler im Ursprungsbau.

**SPANNUNG 2 — "Ausgang 24 oder 48 NIE als Vorgabe" (C.8-Auftrag) vs. K1-Kurzzitat, das
"41,4h fuer 128" als feste Rechenluecke benennt.**
Wellenplan §18.4 Zeile #7 (Z.2249) zitiert K1 mit der Formulierung *"'41,4 h fuer 128' ist
benannte Rechenluecke"* — dieser Halbsatz koennte als impliziter fester Nenner (128 Binaries)
gelesen werden, waehrend C.8(d) ausdruecklich verlangt, dass die Rekombinationszahl NIE als
Vorgabe im Code stehen darf. Kein echter Widerspruch am Objekt (der Strang druckt 24 als
gemessenen AUSGANG, kein Literal), aber die Quellen selbst benutzen an verschiedenen Stellen
feste Zahlen ("41,4h fuer 128", "24 oder 48") als Kurzformeln fuer denselben noch offenen
Sachverhalt — das Audit sollte pruefen, dass im COMMIT-TEXT/BERICHT diese Zahlen NUR als
Beobachtungs-Ergebnis, nie als Code-Konstante auftauchen (P-07 ist hierfuer der Pruefpunkt).

**SPANNUNG 3 — GOAL VI.2 ("jede Groessenrechnung muss Hybrid-Mehrfach-Aufbau mitrechnen") vs.
Ledger KON42-02 ("die Hybrid-Dock-Zahl ist von S-19 UNABHAENGIG").**
GOAL v8 VI.2 (Z.505-506, Owner-nah, vor KON42 formuliert): *"`--check-size` muss sie [Hybrid-
Mehrfach-Aufbau] mitrechnen, sonst ist jede Groessenrechnung strukturell zu klein."* Ledger
KON42-02 (juenger, Z.6964-6965): *"S-19 (#7): rechnet die Mess-Dimension als 'geforderte
Belegungen <= 32'; die Dock-Variable geht als Programm-Deckel-Konstante ein, nicht als
Kombinatorik-Faktor."* KON42-01(1) (Z.6930-6934) praezisiert zusaetzlich: die "32" ist ein
WILLKUERLICHER Programm-Deckel, "von den Mess-Belegungen entkoppelt". Diese beiden Aussagen
LOESEN SICH VERMUTLICH dadurch auf, dass "Dock-Zahl" (KON42, wie viele Pruefdock-Slots es
maximal geben darf) ein ANDERER Gegenstand ist als "Hybrid-Mehrfach-Aufbau" (GOAL VI.2, ob
mehrere bereits gebaute Tier-Binaries fuer den Hybrid-Router noetig sind und damit den
Tier-Bau-Nenner erhoehen) — aber der s19-Strang-Bericht adressiert KEINEN der beiden
Gegenstaende namentlich (0 Treffer "hybrid", s. P-22). Ob die B-4-Zahl=320 die
Hybrid-Mehrfach-Aufbau-Dimension strukturell schon enthaelt (weil sie ueber die
"CEB-Rechen-Ort S-10/S-22"-Ausweisung ohnehin erst spaeter gerechnet wird) oder eine echte
Luecke ist, bleibt am Objekt zu klaeren — hier bewusst NICHT entschieden.

**SPANNUNG 4 — Wellenplan-Anker-Drift `:489` vs. Objekt-Realitaet `:543`/`:552`.**
Wellenplan §16.2 (Z.2100) nennt den PlanSizeBuilder-Anker `experiment_plan_director.hpp:489`.
Am Objekt (66de5c09, von E-1 des Strangs UND von der eigenen Sondierung bestaetigt) liegt der
Kopf-Kommentar bei `:543`, die Klasse `PlanSizeBuilder final : public IPlanBuilder` bei `:552`.
STAFFEL1-SYNTHESE F-01 bezeichnet dies als *"dritte Bestaetigung am Objekt"* — d.h. diese Drift
war schon VOR diesem Strang zweimal unabhaengig gemessen worden, der Wellenplan-Text selbst ist
seit mindestens drei Erhebungen NICHT korrigiert. JUENGSTE/MASSGEBLICHE SCHICHT: der Objektstand
selbst (Owner-Wort > Plan-Text bei reinen Zeilenanker-Fakten; hier gilt zusaetzlich GOAL II.8
"Objekt vor Aggregat"). Der Wellenplan-Pflegepass ist explizit Lead-Sache, nicht Teil dieses
Strang-Auftrags (s. NICHT-GEFORDERT).

**SPANNUNG 5 — Zugewiesene SOLL-Quellen vs. die vom Strang selbst zitierten Design-Quellen.**
Der Auftrags-Steckbrief benennt konkret "Subkommando simulate + planner_simulation.hpp" als
Bauform. Diese konkrete CLI-/Datei-FORM steht NICHT woertlich in den mir zugewiesenen
SOLL-QUELLEN (W2-ABFOLGE-DESIGN nennt nur den Bau-UMFANG C.8(a)-(f), keine Dateinamen/
Kommandonamen). Der Strang-Bericht selbst nennt als seine Design-Quellen zusaetzlich
`s19-rechenweg-design.md` (TEIL A-E) und `karte-plaene-designs.md` TEIL 4 — beide liegen
AUSSERHALB der mir zugewiesenen SOLL-QUELLEN-Liste. Diese Karte kann die konkrete CLI-/
Dateinamens-Entscheidung deshalb nur als Steckbrief-Fakt uebernehmen (P-01/P-03), nicht mit
einer eigenen Zeilen-Quelle aus den sieben gelesenen Dokumenten belegen. Kein inhaltlicher
Widerspruch, aber eine offene Beleg-Luecke, die hier transparent ausgewiesen statt
stillschweigend geglaettet wird.

**SPANNUNG 6 — Slot-Erwartung "kein Vollbau-Bedarf ausser Smoke" vs. tatsaechlich gefahrene
volle Bau-/Test-Treppe.**
W2-ABFOLGE-DESIGN TEIL 3 SLOT [C] (Z.807) ordnet dem s19-Strang die leichteste Bau-Kategorie
zu: *"S1 wt-s19: C-1 (Planer-Etappe; kein Vollbau-Bedarf ausser Smoke)"* — vermutlich, damit
mehr vom knappen Drei-Bauten-Deckel fuer die binary-beruehrenden Straenge (S2 mess-fenster,
u.a.) frei bleibt (Staffelungs-Regel Z.813-815: "Trigger-Pflichten ZUERST"). Tatsaechlich
belegt der Strang-Bericht (Abschnitt 8) eine VOLLE Bau-Treppe (2519 Ziele, `--target all`) plus
zwei volle `ctest`-Laeufe (512 Tests) in Bau-Slot 2 — deutlich mehr als ein reiner Smoke-Test.
Dies ist im Sinne der Dauerregel "NIE KUERZEN" eher wuenschenswert (gruendlicher als gefordert),
steht aber der urspruenglichen Slot-Kalkulation des Designs entgegen; das Audit sollte pruefen,
ob dadurch andere Sa-Straenge (S2-S7) im selben Zeitfenster tatsaechlich auf freie Bau-Slots
warten mussten (Slot-Konkurrenz), da der Deckel session-weit bei 3 liegt und mit dem
laufenden W1L-Kombibau geteilt wird.

--------------------------------------------------------------------------------
SELBSTCHECK: alle 7 vorgegebenen SOLL-QUELLEN vollstaendig gelesen (W2-ABFOLGE-DESIGN.md C-1-
Block + TEIL 2/3/4/5 voll; LEAD-ENTSCHEIDE-zum-w2-design.md 87 Z. voll; Wellenplan-Treffer
§16.2/§17.2-17.6/§18.4/§19.3/§19.4/§21.3 gelesen; Designplan §3/§10/§11/§12 voll gelesen;
GOAL v8 Kopf+TEIL II/III/VI/VII/VIII gelesen; Ledger KON17-01/KON30-03/KON37-03/KON42-01/-02
voll gelesen + Z.106; STAFFEL1-SYNTHESE + STAFFEL2-SYNTHESE vollstaendig auf s19-Bezuege
durchsucht und die Treffer-Abschnitte voll gelesen). Objekt-Sondierung nur zur
Beleg-Praezisierung (kein Fix, kein Urteil): `git log`/`git show --stat` auf `bau/s19` am
ce-Hauptklon (read-only). 24 PRUEFLISTE-Punkte, 11 ABNAHME-FORMELN, 13 NICHT-GEFORDERT-Punkte,
6 SPANNUNGEN — kein Punkt glattgezogen.
