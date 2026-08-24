# SOLL-KARTE — Strang "kampvor" (S2, Kampagnen-Vorposten E-9/E-10/E-20)

Erstellt: 23.08.2026, Sonnet-max-PLANUNGS-ERHEBER. NUR LESEN, kein Fix. Diese Karte beschreibt
die SOLL-Lage aus den 7 vorgegebenen Quellen (+ 1 Objekt-Gegenprobe, s. STATUS-KOPF); sie bewertet
NICHT, ob das Objekt sie erfuellt — das ist Sache des Audits.

Gegenstand lt. Steckbrief: E-9 #38c-Rest (frische_wache+persist_sammler n/a-Phantom-Heilung,
ROT-zuerst, Selbstbisse) + E-10-Generator-Haelfte (window_belongs_to-Paritaets-Guard,
RANK/MASCHINEN fail-closed, [FENSTER-FREMD]) + E-20 R-15 ([PIN-DEKLARATION] ehrlich UNGEPINNT,
CCD0 96MiB; KEIN YAML).

Strang-Bericht: `/home/comdare/backups-workflow/20260820-w2-sofortstaffel/kampagnen-vorposten-ergebnis.md`
(241 Z., voll gelesen). Unabhaengige Lead-Gegenpruefung: STAFFEL2-SYNTHESE.md F-108..F-115 + H-10
(ebenfalls voll gelesen, s.u.).

## STATUS-KOPF (Objekt-Gegenprobe, 23.08., zusaetzlich zu den 7 Quellen)

- `wt-ce-kampvor` (Branch `bau/kampvor`, HEAD `1e1bc199`) und `wt-super-kampvor` (Branch
  `bau/kampvor`, HEAD `025e0c42`) EXISTIEREN, `git status --porcelain` BEIDE LEER. Beide Branches
  auf `origin` vorhanden mit identischem Tip (`git log -1 origin/bau/kampvor` deckt sich).
- **ce-Haelfte (E-10+E-20) IST BEREITS GELANDET**: `git merge-base --is-ancestor 1e1bc199
  origin/development` = wahr. Kette: `b4c593f5` "merge(lande 10/10): bau/kampvor @ 1e1bc199 in
  lande/w2-s1s2" -> `5ddda4e5` "merge(W2-LANDE-ZUG ce-Endstand): lande/w2-s1s2 @ 53c5524e in
  development" -> `origin/development` HEAD aktuell `3841d717` (23.08., Lead-CI-Fixes obendrauf,
  thematisch fremd: vl3/PMC/NSDMI). Die Lande-Position 10/10 aus STAFFEL2-SYNTHESE §2.2 wurde
  wortgleich vollzogen.
- **super-Haelfte (E-9) IST NOCH NICHT GELANDET**: `git merge-base --is-ancestor 025e0c42
  origin/development` = falsch; kein `lande/*`-Branch fuer super existiert; `025e0c42` steht
  isoliert auf `bau/kampvor`. Konsequenz fuer das Audit: E-9 ist NUR am super-Feature-Branch
  pruefbar, nicht an super/development.
- Damit: das Audit muss E-10/E-20 gegen den **ce-development-Endstand** (oder ersatzweise
  `1e1bc199`, byte-identisch dank Merge --no-ff-Kette) pruefen, E-9 aber gegen den **super
  bau/kampvor-Branch** (`025e0c42`), da dort noch nicht gelandet.

--------------------------------------------------------------------------------
## PRUEFLISTE

### A. E-9 — #38c-Rest (frische_wache.sh + persist_sammler.sh)

**P-01 — Kernauftrag #38c (Wellenplan §18.4 Z.2252, woertlich):**
"n/a-Zaehler-REST: mess_ausbeute_wache traegt die KON44-02-Heilung BEREITS (Objekt+CI-Beweis '1
echte, 0 n/a') — offen NUR frische_wache/persist_sammler: nachziehen ODER Arbeitsteilung
deklarieren." Klasse (W), Anker KON44-02, Frist "vor W3-Kampagne".
Pruefbar: `grep -n "n/a" ce/ci/frische_wache.sh ce/ci/persist_sammler.sh` gegen das bestehende
Muster in `ce/ci/mess_ausbeute_wache.sh:275-276` (zweites awk, FS=';', Felder 4/5/6=="n/a");
Bissprobe `ci/tests/frische_wache_probe.sh` + `ci/tests/persist_sammler_probe.sh` ausfuehren.
Strang-Bericht BEHAUPTET: geliefert (Abschn. 7) — "Heilung frische_wache.sh: zweites n/a-awk
(byte-gleiches Programm), Gate auf `echte_dieser_lauf == 0`" + "Heilung persist_sammler.sh:
bilanz_zaehlen zaehlt na/echt (SECHS Zahlen); Gate `echt_zeilen_gesamt == 0`". BEIDE Skripte
nachgezogen (nicht nur deklariert) — das ist die staerkere der zwei ABNAHME-Alternativen.

**P-02 — E-9-ABNAHME-Formel (W2-ABFOLGE-DESIGN Z.478, woertlich):**
"ABNAHME: nachgezogen oder deklariert; vor W3-Kampagne." Pruefbar: Diff-Gegenprobe auf beide
Dateien + Commit-Zeitstempel < Sa 29.08. Strang-Bericht BEHAUPTET erfuellt: Commit `025e0c42`
(super, 21.08.), 6 Dateien +385/-26; "vor W3-Kampagne" damit eingehalten (Frist noch 6 Tage
entfernt zum Commit-Zeitpunkt).

**P-03 — Designplan-Traeger T-UPD-1 (Wellenplan §20.8 Z.2793, woertlich):**
"T-UPD-1 #38c-Rest neu fassen (Objekt=super/ci)." Pruefbar: Objekt-Ort muss `super/ci/*` sein
(nicht `ce/*`) — stimmt mit dem Strang-Bericht ueberein (super bau/kampvor traegt die E-9-Aenderung,
ce bau/kampvor traegt E-10/E-20). Strang-Bericht BEHAUPTET: korrekt eingehalten (Abschn. 7,
"COMMIT: super bau/kampvor 025e0c42").

**P-04 — T-6 Schwesterpflicht + Objekt-Praezedenz (Designplan §3 Z.72 + Strang-eigene Objekt-Lesung):**
"Jeder Fix und jeder Test sucht im selben Zug die Schwesterstelle." Angewandt: `frische_wache.sh`
UND `persist_sammler.sh` sind hier die zwei Schwestern von `mess_ausbeute_wache.sh` (das dritte,
bereits geheilte Mitglied derselben PAAR-awk-Familie); alle drei muessen nach der Heilung
BYTE-GLEICHE n/a-awk-Programme tragen (V1-Gegenprobe). Pruefbar: `grep -cF` auf den exakten
awk-Programmtext in allen drei Dateien, muss je 1 Treffer liefern. Strang-Bericht BEHAUPTET:
geliefert (Abschn. 9, "V1-Gegenprobe awk-Paritaet NACH den Edits ... n/a-awk = je 1 Fundstelle in
denselben drei (byte-gleich, dreifach geteilt)").

**P-05 — Versions-Skew-Falle am Sammler (aus der Strang-eigenen Objekt-Lesung, Abschn. 2, kein
Fremd-SOLL-Zitat, aber direkt aus der Fail-closed-Doktrin GOAL II.7 ableitbar):** `gate` laeuft
NACH `git checkout -B development origin/development`, kann also eine neuere Sammler-Fassung
antreffen als beim `sammeln`-Schritt. Fail-closed verlangt: fehlt das neue PROVENANCE-Feld, darf
das NICHT als Hart-Fehler (rc=2) durchschlagen (sonst bricht harmlose Alt-Kompatibilitaet), ein
WIDERSPRUCH im Feld aber schon. Pruefbar: Test-Fall mit fehlendem vs. widersinnigem
PROVENANCE-Feld gegen `persist_sammler.sh` fahren. Strang-Bericht BEHAUPTET: geliefert (Abschn. 7,
"KONDITIONALE Gegenprobe aufs neue Feld (Versions-Skew: FEHLT -> lauter HINWEIS, nie rc=2;
Widerspruch -> rc=2)").

### B. E-10 — C-10 ZWEILANIGKEIT / Generator-Haelfte

**P-06 — Kernauftrag C-10 (Wellenplan §19.3 Z.2476-2478, woertlich):**
"C-10 ZWEILANIGKEIT: resource_group hart amd/prod1; §61-Revision (ceb-measure-<host>) nie
umgesetzt; Intel-Gegenstueck fehlt; window_belongs_to unverdrahtet; gegen ce 0c80aa78 nachmessen
(KON29-04, r4 C-1) -> Bau-Posten VOR W3." Klasse (M) it. §19.3-Tabellenkopf.
ACHTUNG (s. SPANNUNGEN S-1): dieser Wortlaut ist die AELTERE Fassung (KON29-04, vor 17.08.) und
durch die GOAL-v8-Marker P-08/P-09 PRAEZISIERT, nicht ersetzt — der Nachmess-Auftrag bleibt
verbindlich, der Baubeleg "hart amd/prod1 + Intel fehlt" ist objektiv ueberholt.

**P-07 — E-10-ABNAHME-Formel (W2-ABFOLGE-DESIGN Z.481, woertlich):**
"ABNAHME: nachgemessen+gebaut vor W3." Zwei Teile: (a) NACHMESSEN gegen ce `0c80aa78`, (b) BAUEN.
Pruefbar (a): `git merge-base --is-ancestor 0c80aa78 <ce-Referenz-Commit>` + Ankerzeilen in
`experiment_plan_director.hpp` lesen. Pruefbar (b): neue Tests + Produktionscode-Diff in
`experiment_plan_director.hpp`. Strang-Bericht BEHAUPTET: (a) geliefert (Abschn. 4, "0c80aa78 ...
IST Vorfahr von 66de5c09: bestaetigt"; Anker-Fundstellen mit Zeilen-Drift +1 dokumentiert); (b)
TEILWEISE geliefert — nur die "Generator-Haelfte", s. P-11/NICHT-GEFORDERT (a)+(b).

**P-08 — GOAL v8 MARKER 16.08.2026/KON97 (VII.2 Z.650-653, woertlich):**
"ERGAENZT — die Messung ist heute NICHT ZWEILANIG (`resource_group ceb-measurement-exclusive`
hart amd/prod1; §61-Revision `ceb-measure-<host>` vom 21.07. nie umgesetzt, Intel-Gegenstueck
fehlt; gegen ce `0c80aa78` am Objekt nachmessen, r4 C-1) — Bau-Posten VOR W3, sonst faehrt die
Kampagne einlanig -> Wellenplan §19.3."

**P-09 — GOAL v8 MARKER 17.08.2026/KON97-VERIFY, JUENGSTE Schicht dieses Punkts (VII.2
Z.655-661, woertlich, PRAEZISIERT P-08):**
"PRAEZISIERT — die IST-Beschreibung des vorstehenden Markers ist teilueberholt:
`ceb-measurement-exclusive` existiert weder in der ce-.gitlab-ci.yml (live: `pmu-prod1`/
`pmu-prod2` je Host) noch im Generator; der Generator emittiert bereits die 'nie umgesetzte'
§61-Revision `ceb-measure-<host>` (experiment_plan_director.hpp:1448/:1615). Der C-10-Bau-Posten
bleibt (Zweilanigkeit am Objekt nachmessen, r4 C-1 nennt den Auftrag selbst) — die Nachmessung
misst gegen den HEUTIGEN Generator-Stand, nicht gegen die alte resource_group-Bezeichnung."
Pruefbar: `grep -n "ceb-measure-" experiment_plan_director.hpp` (SOLL: Treffer nahe :1448/:1615,
Drift toleriert). Strang-Bericht BEHAUPTET: exakt diese Praezisierung bestaetigt (Abschn. 4,
"resource_group-Emission `ceb-measure-<host>`: VORHANDEN an experiment_plan_director.hpp:1449
... und :1616 ... [Anker :1448/:1615 um +1 gedriftet]"); der Drift ist selbst benannt, nicht
verschwiegen.

**P-10 — Ledger-Praezisierung MUSS-1/SOLL-1 (Ledger Z.2263-2267, woertlich, deckt sich mit P-09):**
"SOLL-1 GOAL-M-6 praezisiert (live resource_groups pmu-prod1/pmu-prod2; Generator emittiert
bereits ceb-measure-<host> :1448/:1615; C-10-Nachmessung gegen den HEUTIGEN Generator-Stand)."
Gleicher Befund wie P-09, unabhaengig im Ledger dokumentiert — DREIFACH bestaetigt (GOAL 16.08.,
GOAL 17.08., Ledger). Strang-Bericht BEHAUPTET: konsistent damit (s. P-09).

**P-11 — Ursprungs-Text der "zwei Luecken" vor Aufsplittung (Ledger KON29-04, Z.8874-8880,
woertlich; das ist der ERSTE Beleg, aus dem C-10 stammt, und der einzige, der explizit die
Design-Wahl "verdrahten ODER ausbuchen" fuer window_belongs_to nennt):**
"ZWEI LUECKEN VOR DER KAMPAGNE: (1) window_belongs_to (§62-B-GLEICHVERTEILUNG) gebaut+getestet,
NICHT verdrahtet (0 Treffer in planer_driven_build) -- verdrahten ODER ausbuchen (Design-Wahl)
(2) DIE MESSUNG IST NICHT ZWEILANIG: measure:golden-320 ist global-exklusiv (resource_group
ceb-measurement-exclusive, hart amd/prod1) -- die §61-Revision (ceb-measure-<host>, 21.07.) ist
bis heute nicht umgesetzt. Intel-Gegenstueck fehlt." Luecke (2) ist durch P-09/P-10 als objektiv
ueberholt dokumentiert (0c80aa78 hat sie geheilt); Luecke (1) ist der eigentliche verbleibende
Kern von E-10. Strang-Bericht BEHAUPTET: Design-Wahl getroffen = VERDRAHTEN, aber nur die
"Generator-Haelfte" (s. P-06-Warnhinweis + NICHT-GEFORDERT a/b).

**P-12 — Fail-closed-Doktrin (GOAL v8 II.7, Z.305-308, woertlich, auf die neue RANK/MASCHINEN-
Guard angewandt):** "Kann eine Wache nicht pruefen ... ist das rot oder Abbruch, nie gruen. Ein
stiller Rueckfall ist ausdruecklich ein Fehler." Pruefbar: Mutations-/Grenzfall-Test mit
RANK>=MASCHINEN muss hart abbrechen (exit != 0), nicht still eine leere Bau-Menge erzeugen.
Strang-Bericht BEHAUPTET: geliefert (Abschn. 8, "fail-closed rank>=maschinen -> exit 1 (stiller
leerer Batch verboten)"; Abschn. 10 belegt dies zusaetzlich per Wegwerf-Mutation M-E10 als
gefangen).

**P-13 — Testat-Kontrakt-Neutralitaet (aus der Strang-eigenen Objekt-Lesung, Abschn. 9, aber
direkt PFLICHT aus dem allgemeinen T-4/T-7-Rahmen ableitbar: ein neuer Marker darf bestehende
Zaehlwerke nicht verschieben):** das neue `[FENSTER-FREMD]`-Testat darf NICHT das Wort "TESTAT"
im Namen tragen und NICHT `offen=` fuehren, sonst verschiebt es die bestehende
kTestatKlassifikation-Wache (Menge 7) und die E-04-P1-offen=-Gleichung (2×Testate). Pruefbar:
`grep -c "TESTAT"` auf die neuen Zeilen (SOLL: 0 Treffer); bestehende Testat-Zaehl-Tests muessen
unveraendert gruen bleiben. Strang-Bericht BEHAUPTET: geliefert (Abschn. 6+9, "BEWUSST ohne
TESTAT-Namen und ohne offen=" + "Fremd-Test-Querpruefung: kein zweiter Test faehrt
TierCiYamlBuilder").

**P-14 — Landungs-Harmonisierung H-10 (STAFFEL2-SYNTHESE Z.51-56, woertlich; NICHT Bau-Pflicht
des Strangs selbst, sondern Auflage an die LANDUNG, hier informativ fuer das Audit mitgefuehrt):**
"H-10 experiment_plan_director.hpp + test_experiment_plan_director.cpp: pmcpaket (S1: Preflight
pmc=FEHLER + Director-Tests) x kampvor (S2: Fenster-Topologie/[FENSTER-FREMD] + [PIN-DEKLARATION];
Bestands-Test PerBatchSliceArithmetic4096 nachgezogen START 4->8). kampvor ZWINGEND NACH pmcpaket
mergen." Objekt-Gegenprobe (STATUS-KOPF): laut ce-Merge-Historie ist genau diese Reihenfolge
eingehalten (`bau/pmcpaket` vor `bau/kampvor` in der `lande/w2-s1s2`-Kette) — H-10 damit bereits
objektiv erfuellt, nicht mehr offen.

### C. E-20 — R-15 (L3-Asymmetrie prod1 + Pinning-Pflicht)

**P-15 — Kernauftrag R-15 (Wellenplan §19.7 Z.2649, woertlich):**
"R-15 | L3-Asymmetrie prod1 (96/32 MB) + Pinning-Pflicht; ungepinnt nicht reprod. | r4 C-01/C-08 |
M | W3-Vorb." Pruefbar: `lscpu`/`/sys/devices/system/cpu/cpu*/cache/index3/{size,shared_cpu_list}`
auf prod1 gegen 96 MiB (cpus 0-7,16-23) + 32 MiB (cpus 8-15,24-31). Strang-Bericht BEHAUPTET:
literal nachgemessen (Abschn. 1, vollstaendiger `lscpu`/`sysfs`-Dump, "r4 C-01 (96/32 MB, cpus
0..7,16..23 / 8..15,24..31) am Objekt BESTAETIGT").

**P-16 — E-20-ABNAHME-Formel (W2-ABFOLGE-DESIGN Z.508, woertlich):**
"ABNAHME: Pinning belegt." Der Wortlaut fordert NUR einen BELEG (nicht zwingend einen
funktionierenden Aktuator) — deckt sich mit der ehrlichen [PIN-DEKLARATION]-Strategie des
Strangs (s. P-18). Pruefbar: neue [PIN-DEKLARATION]-Zeile im Mess-Batch-Log/-Emission vorhanden
und literal lesbar. Strang-Bericht BEHAUPTET: geliefert (Abschn. 5+8).
ANMERKUNG: R-15 benennt NICHT, WELCHE der zwei CCDs (96 oder 32 MiB) gepinnt werden soll — die
Wahl CCD0/96 MiB ist eine Strang-eigene Auslegung, nicht woertlich vorgeschrieben (s. SPANNUNGEN
S-5).

**P-17 — TABU-Grenze axes/ (aus den bindenden REGELN dieses Workflows + Strang-eigener
Objekt-Lesung, Abschn. 5):** `system_axes/target_isa_sub_axes.hpp` benennt zwar `ScopedThreadPin`
als Aktuator, liegt aber axes-nah unter dem TABU und darf NICHT angefasst werden. Pruefbar:
`git diff <basis>..1e1bc199 -- 'system_axes/*' 'axes/*'` muss LEER sein. Strang-Bericht
BEHAUPTET: eingehalten ("system_axes/ ist TABU-nah (axes): wird NICHT angefasst").

**P-18 — Ehrlichkeits-/Fail-closed-Pflicht auf die Deklaration selbst angewandt (GOAL v8 II.2
V11 Z.264-268 "Die Messung muss aelter sein als der Satz" + II.7 Fail-closed, kombiniert; kein
woertliches Einzelzitat zu R-15, aber die einzige Lesart, die "Pinning belegt" mit einem
unverdrahteten Aktuator vertraegt, OHNE ein falsches Gruen zu erzeugen):** wenn der Aktuator
(`ScopedThreadPin`) im Mess-Loop nicht verdrahtet ist, darf die neue Zeile NICHT `pin_ist=gepinnt`
behaupten — sie muss ehrlich `pin_ist=UNGEPINNT` fuehren. Pruefbar: Code-Lesung
`run_profile`-Schleife auf tatsaechlichen `ScopedThreadPin`-Aufruf (SOLL: 0 Treffer) UND
Log-/Emissionstext auf `pin_ist=UNGEPINNT`. Strang-Bericht BEHAUPTET: geliefert (Abschn. 5+8,
"`[PIN-DEKLARATION]` mit pin_soll/pin_ist=UNGEPINNT (ehrlich: Aktuator unverdrahtet; kein
falsches Gruen)"); fuer die intel-Lane zusaetzlich `pin_soll=UNVERMESSEN laut deklariert`.

### D. Cross-Cutting — TDD-Vertrag (Designplan §3, Z.65-75, gilt fuer JEDES Paket aller Wellen)

**P-19 — T-1 ROT ZUERST** (Z.67): "Der Test ist am ersten Tag rot, ODER sein Biss ist per
protokollierter Wegwerf-Mutation bewiesen." Strang-Bericht BEHAUPTET: BEIDE Formen geliefert —
echtes Erst-Tag-Rot fuer E-9 (Abschn. 6, "ROT-ZUERST-BELEGE ... am UNGEHEILTEN Objekt gefahren",
3+3 Risse literal) UND Wegwerf-Mutation fuer E-10/E-20 (Abschn. 10, M-E10/M-E20, T-11c
Wegwerf-Klasse, nach dem Commit gefahren + sauber revertiert).

**P-20 — T-2 AUSSAGE, NICHT ANWESENHEIT** (Z.68): Wert/Position/Menge/Klasse statt bloss
`find()`/Exit-0. Pruefbar an den neuen Testnamen: `WindowBelongsToVerdrahtungGeneratorHaelfte`
behauptet laut Bericht "Emission literal + Semantik-Paritaet gegen bestandslog::window_belongs_to
+ Partitions-Vollstaendigkeit" (Abschn. 8) — das ist eine Wert-/Vollstaendigkeitsaussage, keine
reine Existenzpruefung. Zu verifizieren am Testkoerper selbst (Audit-Aufgabe).

**P-21 — T-3 NENNER, FREMD** (Z.69): Grundgesamtheit aus anderer Quelle als der Pruefling.
Strang-Bericht BEHAUPTET Nenner an mehreren Stellen benannt (17/18/32 Faelle je Probe, "NENNER:
17 Faelle gefahren, 14 gehalten, 3 gerissen" wortgleich in Abschn. 6) — die Faelle-Zahl kommt aus
der Bissprobe-Datei selbst, nicht aus dem gepruteften Skript.

**P-22 — T-4 GEGENEINGANG** (Z.70): zu jeder Zusicherung ein Eingang, bei dem sie NICHT gilt.
Fuer E-10: RANK<MASCHINEN (Fenster-Zugehoerigkeit) muss neben RANK>=MASCHINEN (fail-closed)
geprueft sein. Fuer E-9: "echte Zeilen vorhanden" muss neben "nur n/a" geprueft sein. Strang-
Bericht BEHAUPTET beide Richtungen ("rot am n/a-Phantom, gruen an echten ;-Zeilen" Abschn. 2 Ende).

**P-23 — T-5 ORAKEL UNABHAENGIG** (Z.71): Sollwerte gerechnet/eingefroren, nie aus der gepreuften
Funktion selbst. Zu verifizieren am Testkoerper (Audit-Aufgabe, nicht aus dem Bericht ablesbar).

**P-24 — T-6 SCHWESTERPFLICHT** (Z.72, allgemeine Fassung; die E-9-spezifische Anwendung steht
bereits unter P-04). Fuer E-10/E-20: beide teilen sich dieselbe Emissionsschleife in
`experiment_plan_director.hpp` — Strang-Bericht BEHAUPTET beide im selben Zug/Commit gebaut
(Abschn. 8, ein gemeinsamer Commit `1e1bc199` fuer E-10+E-20).

**P-25 — T-7 REGISTRIERUNG IST TEIL DES TESTS** (Z.73): Test muss in `ctest -N` erscheinen UND im
Bauweg haengen. Strang-Bericht BEHAUPTET: geliefert — "Tests (ans DATEIENDE
test_experiment_plan_director.cpp)" (Abschn. 8, TABU-konform ans Dateiende) + "die 2 neuen Tests
per --gtest_filter einzeln belegt (2/2 OK)" (Abschn. 10). Registrierungs-Bissprobe selbst (ctest
-N-Zaehler vorher/nachher) ist im Bericht NICHT literal gezeigt — nur die Gesamt-ctest-Bilanz
510/510. Das ist ein LUECKENHINWEIS fuer das Audit, keine Verneinung.

**P-26 — T-8 ATOMARE LANDUNG** (Z.74): Test+Minimalbau landen atomar; Rot-Lauf vor, Gruen-Lauf
nach der Heilung sind Paketbestandteil. Strang-Bericht BEHAUPTET: eingehalten (ROT-Lauf Abschn. 6
VOR dem Commit, GRUEN-Belege Abschn. 7/10 NACH dem Commit, alles im selben Commit
`025e0c42`/`1e1bc199` gelandet, kein separater Test-only-Vorlauf).

**P-27 — T-9 TESTKRITIK** (Z.75): "Neue Tests jeder Welle gehen in der Folgewelle durch einen
Codex-Pass + Objektpruefung." Das ist eine VORWAERTS gerichtete Pflicht — sie liegt NICHT bei
kampvor selbst, sondern bei der naechsten Pruef-Instanz (voraussichtlich: dieses laufende Audit
selbst, da es die "Folgewelle" der neuen kampvor-Tests ist). Pruefbar: Existiert ein
Codex-/Objekt-Pass ueber `frische_wache_probe.sh`, `persist_sammler_probe.sh`,
`mess_ausbeute_bissprobe.sh`(Anker-Fix), `WindowBelongsToVerdrahtungGeneratorHaelfte`,
`PinPflichtDeklarationR15ImMessBatch`? Strang-Bericht BEHAUPTET dies NICHT (liegt ausserhalb
seines eigenen Mandats) — als OFFEN fuer das Audit zu fuehren.

**P-28 — T-11c MUTATIONS-PROTOKOLL ALS ABNAHMEKLASSE** (Designplan §11 Z.647, allgemeine Fassung,
"verschaerft T-1"): "der Biss jedes neuen Tests wird per protokollierter Wegwerf-Mutation belegt
... die Koeder-LAENGE/-Form wird geprueft, BEVOR die Mutation zaehlt." Strang-Bericht BEHAUPTET:
geliefert fuer E-9 ("Selbstbiss 7/7"/"9/9"/"5/5", Mutanten M2/M5/M6/M7/m7/m8/m9 einzeln benannt,
je mit erwarteter vs. tatsaechlicher rc/Text) und fuer E-10/E-20 (M-E10/M-E20, Abschn. 10, inkl.
FAILED-Zeilennummern :4171/:4218/:4220). Die Koeder-Form-Pruefung selbst (vor der Mutation) ist im
Bericht nicht explizit als eigener Schritt benannt — nur das Ergebnis.

**P-29 — T-11b KOMBIBAU-2x2-MATRIX** (Designplan §11 Z.645, WELLEN-Abnahme-Pflicht, KEIN
Einzeltest-Posten laut eigenem Wortlaut: "sie gehoert in die Wellen-Abnahme (§4) jedes
Stempel-/Mess-Pakets"): {clang,gcc}x{Debug,Release}, 4 Zellen, EINMAL am gemergten Endstand
(K17). NICHT kampvor-eigene Pflicht — Strang-Bericht BEHAUPTET das auch nicht, sondern deklariert
es korrekt als offenen Lande-Zug-Posten (Abschn. 10, "(e) K17-Vollkombibau am gemergten Stand =
Lande-Zug (Order: lokal mind. gcc-Release, hier erfuellt)"). Objekt-Gegenprobe: fuer die ce-Haelfte
ist der gemergte Endstand laut STATUS-KOPF bereits erreicht (development enthaelt 1e1bc199) — das
Audit sollte pruefen, ob der K17-Kombibau am ce-development-Endstand inzwischen gelaufen ist (das
liegt aber ausserhalb der kampvor-Zustaendigkeit).

### E. Cross-Cutting — GOAL v8 Betriebsregeln (VII.2, gilt ueber allen Wellen)

**P-30 — Nenner-/Abnahme-Grundsatz (GOAL v8 Z.640-645, woertlich):** "Jede Abnahme traegt Nenner,
Rot- und Gruen-Lauf, frisch gewuerfelten Koeder. Eine Welle ohne beissende Wache gilt als nicht
abgenommen ... Zu jeder Abnahme gehoert die Antwort auf 'was erzwingt das Halten?'" Deckt sich
mit P-19/P-21/P-28 — hier als GOAL-eigene Fassung derselben Pflicht mitgefuehrt, damit das Audit
sie nicht als separaten fehlenden Punkt zaehlt.

**P-31 — K13 Koeder muss beissen (GOAL v8 II.6 Z.295-299, woertlich):** "Eine Wache gilt erst dann
als gebaut, wenn ein ZUFAELLIG erzeugter Koeder sie zum Beissen bringt — `/dev/urandom`, nie aus
einer Doku abgeschrieben." Im Bericht nicht explizit als `/dev/urandom`-Herkunft der Testfaelle
belegt (die neuen Faelle F6c/F6d/F6e/P16/P17/P18 wirken konstruiert-gezielt, nicht zufaellig
gewuerfelt) — das ist bei GEZIELTEN Grenzfall-Konstruktionen (n/a-Phantom, Fenster-Paritaet)
sachlich ueblich und deckt sich mit K13s eigener Ausnahme ("beide Richtungen fahren"), aber das
Audit sollte diesen Punkt nicht automatisch als erfuellt werten, ohne die Testdatei zu lesen.

**P-32 — V11 Belegzeile, Messung vor Aussage (GOAL v8 II.2 Z.264-268, woertlich):** "Die Messung
muss aelter sein als der Satz. Eine Messung, die nach der Aussage erfolgt, ist eine Korrektur,
kein Beleg." Strang-Bericht BEHAUPTET durchgehend die richtige Reihenfolge: Objekt-Lesung (Abschn.
2/4/5) VOR dem Bau-Entscheid, ROT-Lauf (Abschn. 6) VOR der Heilung (Abschn. 7), Wegwerf-Mutation
(Abschn. 10) NACH dem Commit als zusaetzlicher Beleg (nicht als Ersatz fuer den Erst-Rot-Lauf).

### F. Cross-Cutting — Prozess-/Hygiene-Regeln (bindende REGELN dieses Workflows)

**P-33 — TABU axes/topics/heuristik/:** kein Zugriff erlaubt. Pruefbar: `git diff <basis>..HEAD
-- 'axes/*' 'topics/*' 'heuristik/*'` je Zweig muss LEER sein. Strang-Bericht BEHAUPTET
eingehalten (explizit fuer system_axes/, s. P-17; sonst kein Treffer in den benannten Dateien
ci/frische_wache.sh, ci/persist_sammler.sh, experiment_plan_director.hpp,
test_experiment_plan_director.cpp).

**P-34 — golden-Dateien byte-stabil:** keine der beruehrten Dateien liegt im golden-Pfad
(overlay_source_set/axis_version.lock/golden_fullpilot_320*). Strang-Bericht BEHAUPTET dies
implizit durch Nicht-Erwaehnung; kein expliziter Neutralitaets-Beleg noetig, da die geaenderten
Dateien (ci/*.sh, experiment_plan_director.hpp) nicht golden-gehasht sind — zu verifizieren via
`git diff --stat` gegen die Overlay-Glied-[7]-Hashliste (Audit-Aufgabe).

**P-35 — .gitlab-ci.yml NUR wenn der Strang-Auftrag es ausdruecklich traegt:** hier NICHT
mandatiert (LEAD-ENTSCHEIDE Z.29-31: "YAML-SERIALISIERUNG: E-14 ... + E-15 ... + E-10-YAML-
Haelfte beruehren super-/ce-YAML -> warten auf den exklusiven YAML-Schreiber ... und fahren im
YAML-Zug der Staffel 3"). Strang-Bericht BEHAUPTET eingehalten: "KEIN YAML angefasst, alle drei
Repos" (Abschn. 8+10, mehrfach wiederholt).

**P-36 — tests/unit/CMakeLists.txt NUR ans DATEIENDE, falls angefasst:** Strang-Bericht
BEHAUPTET, diese Datei GAR NICHT angefasst zu haben ("kampvor registriert keine neue TU", so auch
unabhaengig in STAFFEL2-SYNTHESE H-9 Z.47-48 bestaetigt) — der neue Test haengt in einer
BESTEHENDEN, bereits registrierten TU (`test_experiment_plan_director.cpp`). Damit ist P-36
gegenstandslos (nicht: verletzt).

**P-37 — ASCII-only in neuen Zeilen:** Strang-Bericht BEHAUPTET geliefert (Abschn. 7, "Diff
ASCII-only (Nicht-ASCII-Treffer im Bestand = gehobener YAML-Block A, unberuehrt)"; Abschn. 8,
"Diff ASCII-only"). Pruefbar: `LC_ALL=C grep -n '[^ -~\t]' <diff>`.

**P-38 — clang-format-22 ueber jede geaenderte Lint-Datei:** Strang-Bericht BEHAUPTET geliefert
("clang-format-22 sauber", Abschn. 8) fuer die C++-Datei; fuer die Shell-Skripte (ci/*.sh)
BEHAUPTET stattdessen "bash -n/sh -n gruen" + Zeilenlaengen-Wache (<=119 Byte) — clang-format ist
fuer .sh-Dateien nicht das einschlaegige Werkzeug, insofern konsistent, aber nicht identisch mit
dem woertlichen REGEL-Text ("ueber jede geaenderte Lint-Datei"); Audit sollte pruefen, ob .sh
ueberhaupt als "Lint-Datei" im Sinn der Regel gilt.

**P-39 — Commit-Trailer 'Co-Authored-By: Claude Fable 5 <noreply@anthropic.com>':** Pruefbar via
`git log -1 --format=%B 1e1bc199 025e0c42`. Im Strang-Bericht nicht woertlich zitiert; Audit sollte
den tatsaechlichen Commit-Body pruefen (Objekt-Ebene, ausserhalb dieser reinen Leseerhebung nicht
weiter vertieft, da die Aufgabe hier NUR Soll-Text-Erhebung ist).

**P-40 — git push -o ci.skip nach jedem Fix-Commit:** Strang-Bericht BEHAUPTET geliefert fuer
super (Abschn. 9, "super bau/kampvor -> origin gepusht mit -o ci.skip ... Ausgabe literal: '*
[new branch] bau/kampvor -> bau/kampvor'") und implizit fuer ce (Abschn. 10, "ce bau/kampvor =
1e1bc199 (E-10+E-20, gepusht -o ci.skip)"). Objekt-Gegenprobe (STATUS-KOPF): BEIDE Branches auf
`origin` vorhanden, Tips identisch — bestaetigt.

**P-41 — Bau-Slot-Deckel 3 (parallele Bautaetigkeit):** Strang-Bericht BEHAUPTET Protokoll
eingehalten (Abschn. 8, "Bau-Slot 3 per Protokoll genommen (slot1=prtart-pin-duo 20.08. stale,
slot2=skip-oekonomie-97)"; Abschn. 10, "Bau-Slot 3 genommen und freigegeben").

**P-42 — df -h / >5G Gate + build/-Bereinigung nach Belegpruefung:** Strang-Bericht BEHAUPTET
geliefert (Abschn. 10, "build/ nach Belegpruefung entfernt (git ls-files build/ = 0; *.csv/*.xlsx
= 0)").

--------------------------------------------------------------------------------
## ABNAHME-FORMELN (woertliche Zitate, gebuendelt)

1. **E-9** (W2-ABFOLGE-DESIGN Z.478): *"ABNAHME: nachgezogen oder deklariert; vor W3-Kampagne."*
2. **E-10** (W2-ABFOLGE-DESIGN Z.481): *"ABNAHME: nachgemessen+gebaut vor W3."*
3. **E-20** (W2-ABFOLGE-DESIGN Z.508): *"ABNAHME: Pinning belegt."*
4. **#38c** (Wellenplan §18.4 Z.2252, Spalte "haengt an"): *"vor W3-Kampagne"*.
5. **C-10** (Wellenplan §19.3 Z.2478, Zeilenende): *"-> Bau-Posten VOR W3"*.
6. **R-15** (Wellenplan §19.7 Z.2649, Spalte "Welle"): *"W3-Vorb."*
7. **T-1** (Designplan Z.67): *"Der Test ist am ersten Tag rot, ODER sein Biss ist per
   protokollierter Wegwerf-Mutation bewiesen. Beides fehlt = kein Test."*
8. **T-11c** (Designplan Z.647): *"GEZAEHLTE Pflicht je Paket: je neuem Test >=1 Wegwerf-Mutation
   mit literalem Rot + Gegenprobe-Gruen."*
9. **GOAL-Nenner-Doktrin** (GOAL v8 Z.641-642): *"Eine Welle ohne beissende Wache gilt als nicht
   abgenommen — und beidseitig: ein Paket ohne Abnahmezeile ebenso wenig wie eine Abnahmezeile
   ohne Paket."*
10. **GOAL-Fail-closed** (GOAL v8 Z.307-308): *"... ist das rot oder Abbruch, nie gruen. Ein
    stiller Rueckfall ist ausdruecklich ein Fehler."*

Gemeinsamer Frist-Nenner aller drei Teilaufgaben: **"vor W3"** bzw. **"W3-Vorb."** — die W3-
Kampagne beginnt lt. Wellenplan Sa 29.08. 06:00. Zum Zeitpunkt dieser Erhebung (23.08.) ist diese
Frist noch nicht erreicht.

--------------------------------------------------------------------------------
## NICHT-GEFORDERT (deklarierte Nachfolge-Zuege — kein Phantom-Fund, wenn hier fehlend)

Alle vier Punkte sind DREIFACH belegt: (i) im Strang-Bericht selbst als "OFFEN AN
NACHFOLGE-ZUEGE" deklariert (Abschn. 10 a-e), (ii) in STAFFEL2-SYNTHESE F-112/F-114/§5.1
unabhaengig gegengelesen, (iii) in mindestens einer Primaerquelle als eigener, spaeterer
Wellen-/Fenster-Platz benannt.

**(a) Treiber-seitige Topologie-/Pin-KONSUMENTEN** (BatchPlanner-Produktionsaufruf von
`window_belongs_to`; `run_profile`-Pin via `ScopedThreadPin`). Beleg fuer "spaeter, nicht hier":
Ledger KON29-04 nennt "verdrahten ODER ausbuchen" als offene DESIGN-Wahl (P-11) — kampvor waehlt
verdrahten, aber nur die Generator-Seite; die Wellenkonsolidierung
(`docs/plaene/20260812-WELLENKONSOLIDIERUNG-und-strategische-reihenfolge.md` Z.94+227, NICHT Teil
der 7 vorgegebenen Quellen, als Zusatz-Gegenprobe gelesen) fuehrt *"zweilanige Messung §61 +
window_belongs_to"* woertlich unter der **"Kampagnen-Vorstaffel ab Sa 29.08."** (= W3), nicht W2.

**(b) E-10-YAML-Haelfte + E-14 + E-15** (die eigentliche CI-YAML-Verdrahtung der
Topologie-Variablen `COMDARE_MACHINE_RANK`/`COMDARE_MACHINES`, plus Chaos-/Drift-Gate-CI-Job E-14
und Tag-Mismatch-Fix E-15). Beleg: LEAD-ENTSCHEIDE Z.29-31 (*"warten auf den exklusiven
YAML-Schreiber (ci-dual-r1r2, Staffel 1) und fahren im YAML-Zug der Staffel 3"*) + Nachtrag 14
Z.48-55 (*"STAFFEL-3-LISTE ... YAML-Zug E-14/E-15/E-10"*). Kampvor hat in ALLEN drei Repos
"auftragsgemaess ... KEIN YAML angefasst" (STAFFEL2-SYNTHESE Z.270) — das ist korrekt, kein Fund.

**(c) prod2-Topologie-Vermessung fuer die Intel-Pin-Menge.** R-15s Quelle (r4 C-01/C-08) ist
ausdruecklich prod1-scoped ("L3-Asymmetrie **prod1**"); keine der 7 Quellen verlangt eine
prod2-Pin-Menge. Der Strang deklariert stattdessen ehrlich `pin_soll=UNVERMESSEN` fuer die
intel-Lane (P-18) — das ist eine zulaessige Deklaration, kein fehlender Bau.

**(d) Wellenplan-Z.718-Drift-Korrektur ("2×128 MiB CCD" -> "96+32 MiB").** Der Strang FINDET den
Fehler und haelt einen Korrektur-ENTWURF im eigenen Bericht (Abschn. 1) bereit, schreibt ihn aber
NICHT in den Wellenplan selbst (kein Docs-Zug-Mandat in diesem Strang). STAFFEL2-SYNTHESE fuehrt
dies unabhaengig als **F-108, Traeger "Lead docs-Zug"**. Kein Fund, wenn der Wellenplan-Text
Z.718 zum Audit-Zeitpunkt noch unveraendert "2×128 MiB" liest — das ist der Sollzustand fuer
DIESEN Strang.

**(e) K17-Vollkombibau am gemergten Stand.** Laut Designplan T-11b (P-29) ist das eine
Wellen-Abnahme-Pflicht, kein Einzelstrang-Posten; der Strang belegt nur seine lokale
gcc-Release-J-1-Treppe (Abschn. 10, "Order: lokal mind. gcc-Release, hier erfuellt"). Der volle
{clang,gcc}x{Debug,Release}-Nachweis ist Sache der LANDUNG (Lande-Zug), nicht dieses Strangs.

**Ausdruecklich NICHT Teil dieser Aufgabe** (zur Abgrenzung gegen aehnlich benannte, aber andere
Posten — s. auch SPANNUNGEN S-3): E-11 (C-12 Fehlerklassen, eigener golden-Zug Staffel 3) · E-12
bis E-21 (andere Kampagnen-Vorposten, andere Straenge/Faelligkeiten) · #38a/#38b/#38d (andere
Buchstaben derselben #38-Familie, NICHT #38c) · C-05 (Warmup-Paar/T-12b, andere C-Nummer) · das
checkpoint_measure-eigene "C-10" (Thread-lokale-Puffer-Richtigkeitsfrage, Wellenplan §19.5 Z.2580
+ Ledger Z.31970 — TEXTGLEICHER Bezeichner, ANDERER Gegenstand).

--------------------------------------------------------------------------------
## SPANNUNGEN (Widersprueche zwischen Quellen — nicht glattgezogen)

**S-1 — C-10-Wortlaut veraltet vs. praezisiert (aeltere vs. juengere Schicht, AUFGELOEST):**
Wellenplan §19.3 (Z.2476-2478, Basis KON29-04, vor 17.08.) behauptet noch "resource_group hart
amd/prod1 ... Intel-Gegenstueck fehlt" als IST-Zustand. GOAL v8 traegt dazu ZWEI Marker
uebereinander: 16.08./KON97 (Z.650-653) wiederholt zunaechst denselben IST-Befund, aber
17.08./KON97-VERIFY (Z.655-661, JUENGER) korrigiert ausdruecklich: die Host-Lane-Trennung
(`ceb-measure-<host>`) IST bereits im Generator vorhanden, nur die alte
`ceb-measurement-exclusive`-Bezeichnung existiert nicht mehr. Ledger Z.2263-2267 (SOLL-1)
bestaetigt dieselbe Praezisierung ein drittes Mal. Rangfolge-Regel (juengere Schicht gewinnt):
GOAL-17.08.-Marker + Ledger-SOLL-1 stehen ueber dem unrevidierten Wellenplan-Wortlaut. Der Strang
folgt korrekt der juengeren Fassung (Abschn. 4, "KEIN Neubau dieser Haelfte" fuer den
Host-Lane-Teil) — das ist keine Abweichung vom Strang, sondern eine noch nicht in den Wellenplan
zurueckgeschriebene Praezisierung. Das Audit sollte den Wellenplan-Wortlaut §19.3/C-10 NICHT als
alleinigen Massstab fuer "Intel-Gegenstueck" werten.

**S-2 — Wellenplan-INTERNER Widerspruch zur L3-Groesse (NICHT durch Schichtenregel aufloesbar,
da BEIDE Stellen aus derselben Dokumentversion stammen):** §19.7/R-15 (Z.2649) nennt korrekt
"96/32 MB". Der W3-MESS-Wellenkopf (Z.718, ##55) nennt dagegen *"L3-Asymmetrie prod1-eigen: 2×128
MiB CCD"* — objektiv falsch (96+32=128 MiB IN SUMME ueber zwei ASYMMETRISCHE CCDs, nicht 2×128
MiB SYMMETRISCH; die `lscpu`-Summenzeile wurde beim urspruenglichen Verfassen offenbar
fehlgelesen). Aufloesung NICHT durch "juengere Schicht", sondern durch direkte Objektmessung
(GOAL II.4/V4 "Verdaechtige das eigene Messverfahren" + II.8 "Objekt vor Aggregat"): die
`lscpu`/`sysfs`-Messung des Strangs (Abschn. 1) bestaetigt R-15s "96/32 MB" und widerlegt ##55s
"2×128 MiB". Der Wellenplan-Text selbst ist an dieser einen Stelle (Z.718) nicht korrigiert
(bestaetigt unabhaengig durch STAFFEL2-SYNTHESE F-108, "OFFEN, Lead docs-Zug"). Das Audit sollte
NICHT den Wellenplan-Wortlaut Z.718 als Massstab fuer E-20 nehmen, sondern R-15/Z.2649 + die
Objektmessung.

**S-3 — Label-Kollision "C-10" (drei verschiedene Gegenstaende im Corpus unter demselben
Kuerzel):** (1) Korb-C-Tabelle §19.3, Wellenplan Z.2476 = ZWEILANIGKEIT/resource_group = DAS
hier gemeinte E-10. (2) checkpoint_measure-Auflagenliste r5 C-1..C-17, zitiert in Wellenplan
§19.5 Z.2580 parenthetisch ("(iv) thread-lokale Puffer sind eine RICHTIGKEITS-Frage (C-10)") =
Arena/E11-Kontext, VOELLIG ANDERER Gegenstand. (3) Ledger Z.31970, Ueberschrift "### C-10 Damit
ist die Thread-Frage aus C-5(a) entschieden" = dieselbe checkpoint_measure-Zaehlung wie (2), NICHT
Wellenplan-Korb-C. Das Audit muss bei jedem Treffer auf "C-10" im Corpus pruefen, WELCHE der drei
Zaehlungen gemeint ist, bevor ein Fund kampvor zugeschrieben wird.

**S-4 — Meine eigene Auftrags-Formulierung nennt "GOAL v8 ... V-1..V-14" als Doktrinen-Bestand;
GOAL v8 selbst fuehrt (per Volltext-Lesung) an benannten V-Stellen nur V1 (Z.276), V4 (Z.282) und
V11 (Z.264) explizit auf, keine durchgehende V-1..V-14-Liste; Wellenplan D-17 (nicht Teil dieser
7 Quellen, nur beim Vor-Lesen aufgefallen) spricht von "Verifikationsvertrag V-1..V-8". Das ist
vermutlich eine Ungenauigkeit in der Aufgaben-Zusammenfassung, KEIN inhaltlicher Fund fuer
kampvor — hier nur dokumentiert, damit das Audit nicht nach einem nicht-existenten "V-14" sucht,
der speziell diese Aufgabe beruehrt.

**S-5 — R-15 legt die zu pinnende CCD nicht fest.** Der Wellenplan-Wortlaut ("96/32 MB) +
Pinning-Pflicht") sagt nicht, OB CCD0 (96 MiB) oder CCD1 (32 MiB) gepinnt werden soll. Die
Strang-Wahl CCD0/96 MiB (Abschn. 5+8) ist plausibel (die groessere, "typischere" Partition), aber
eine EIGENE Auslegung, kein woertliches Zitat aus einer der 7 Quellen. Kein Widerspruch, aber
eine Interpretationsluecke, die das Audit nicht als "objektiv falsch" werten sollte, falls eine
andere Wahl ebenso vertretbar waere.

**S-6 — Registrierungs-Bissprobe (T-7) im Bericht nicht separat gezeigt (kleine
Beleg-Luecke, kein Quellen-Widerspruch):** Designplan T-7 verlangt eine "Registrierungs-Bissprobe
(Koeder-Datei bzw. Configure-Probe)" als EIGENEN Abnahme-Bestandteil. Der Strang-Bericht zeigt nur
die GESAMT-ctest-Bilanz (510/510) und den `--gtest_filter`-Einzelbeleg (2/2), nicht explizit einen
ctest-N-Vorher/Nachher-Zaehler fuer die zwei neuen Testnamen. Das ist wahrscheinlich implizit in
der 510/510-Bilanz enthalten (Basis war laut STATUS-KOPF/STAFFEL2-SYNTHESE 510 vor kampvor,
kampvor "registriert keine neue TU", d.h. die 2 neuen Tests haengen an einer BESTEHENDEN,
bereits registrierten Zaehl-Einheit) — aber woertlich nicht vorgefuehrt. Fuer das Audit als
Pruefpunkt, nicht als Befund vorgemerkt.
