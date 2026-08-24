# AUDIT RUNDE 1 — Strang "kampvor" (S2: E-9 #38c-Rest + E-10-Generator-Haelfte + E-20 R-15)

Auditor: Fable-max-AUDITOR, 23.08.2026. Objekt: super `bau/kampvor` @ `025e0c42` (Basis
`a7e8e151`, NICHT gelandet) + ce `bau/kampvor` @ `1e1bc199` (Basis `66de5c09`, GELANDET in
ce/development via `b4c593f5` -> `5ddda4e5`). Nur-Lese-Zugriff auf beide Hauptklone; alle
Ausfuehrungs-Beweise an einem `git archive`-Export des super-Tips nach /tmp (nach dem Audit
geraeumt), Logs persistiert unter
`/home/comdare/backups-workflow/20260821-w2-audit-fixverify/kampvor/proben-logs/` (5 Dateien).

**VERDIKT: SITZT** (0 ERNST, 0 MILD, 2 KLEIN — beides Berichts-/Beweis-Hygiene, kein Code-Delta).

## 0. Objekt-Identitaet (selbst gemessen)

- ce `1e1bc199` "planner(e10+e20): window_belongs_to-Verdrahtung (Generator-Haelfte, C-10) +
  R-15-Pin-Pflicht-Deklaration", 2026-08-21 17:43 UTC; Diffstat exakt wie berichtet:
  `experiment_plan_director.hpp | 70 +` und `test_experiment_plan_director.cpp | 97 +-`,
  Summe "166 insertions(+), 1 deletion(-)".
- super `025e0c42` "ci(e9/#38c-rest): n/a-Zaehler-Heilung in frische_wache + persist_sammler
  nachgezogen (KON44-02)", 2026-08-21 17:31 UTC; Diffstat exakt wie berichtet: 6 Dateien,
  "385 insertions(+), 26 deletions(-)" (frische_wache 64, mess_ausbeute 4, persist_sammler 91,
  frische_probe 123, bissprobe 2, persist_probe 127).
- Landungs-Stand: `git merge-base --is-ancestor 1e1bc199 origin/development` = wahr (ce),
  `... 025e0c42 origin/development` = falsch UND lokales super/development = falsch; kein
  `lande/*`-Ref im super-Repo. Die super-Merges stehen in der ZUG-BILANZ
  (`20260822-lande-zug/ZUG-BILANZ.md` Z.95-100) als AUSSTEHENDE "SUPER-PHASE des Zugs" —
  deckt sich mit dem STATUS-KOPF der Soll-Karte. Die GATE.md-Zeile des 6k-Sweeps ("super-Merges
  ... kampvor-super 025e0c42 ... CONFIRMED") bestaetigt nur das Pause-Doku-ZITAT, nicht den
  Vollzug — am Objekt NICHT gelandet (Audit-Messung 23.08. gilt).
- `0c80aa78` ist Vorfahr von `1e1bc199` (merge-base --is-ancestor, RC=0 selbst gefahren).

## 1. Punkt-fuer-Punkt-Tafel (P-01..P-42 der Soll-Karte)

| P | Gegenstand | Urteil | Literal-Beleg (Kurzform) |
|---|---|---|---|
| P-01 | #38c-Rest: beide Skripte nachziehen | **ERFUELLT** | Diff gelesen: frische zweites n/a-awk + Gate `[ "$ECHT_DIESER" -eq 0 ]`, 4 Nenner-Zeilen (`na_dieser_lauf=... echte_dieser_lauf=$ECHT_DIESER`); persist `bilanz_zaehlen` SECHS Zahlen, Gate `if [ "$ECHT_ZEILEN_GESAMT" -eq 0 ]; then gate_verweigern; fi   # GATE-MUTATIONSMARKE`, PROVENANCE additiv. Bissproben SELBST am Tip gefahren: frische **17/17 + Selbstbiss 7/7** (rc=0), persist **18/18 + Selbstbiss 9/9** (rc=0), mess_ausbeute **32/32 + Selbstbiss 5/5** (rc=0) — Logs `proben-logs/*_selbstbiss.log`. Die staerkere ABNAHME-Alternative (nachgezogen, nicht nur deklariert). |
| P-02 | E-9-ABNAHME "nachgezogen oder deklariert; vor W3-Kampagne" | **ERFUELLT** (Bau) | Commit 21.08. 17:31 UTC < Sa 29.08. Hinweis (kein Fund): die super-LANDUNG steht noch aus (Super-Phase Lande-Zug) und muss vor Sa 29.08. erfolgen — Traeger Lande-Zug/Lead, nicht kampvor. |
| P-03 | T-UPD-1 Objekt=super/ci | **ERFUELLT** | Diffstat: alle 6 Dateien unter `ci/` bzw. `ci/tests/` des super-Repos; ce-Diff beruehrt nur planner+tests. |
| P-04 | T-6/V1 awk-Paritaet dreifach | **ERFUELLT** | `grep -cF` des exakten Programmtexts am Tip `025e0c42`: n/a-awk = **1/1/1**, PAAR-awk = **1/1/1** in mess_ausbeute/frische/persist (selbst gefahren, Ausgabe literal im Audit-Transkript). |
| P-05 | Versions-Skew konditional | **ERFUELLT** | persist_sammler.sh-Diff: `PROV_NA`-awk mit FEHLT-Zweig -> "HINWEIS ... Kein Abbruch", Widerspruchs-Zweig -> `exit 2`; Probe-Fall P18 prueft beide Koeder-Felder VOR der Entfernung ("KOEDER ZUERST"), riss an der Basis (s. P-19) und haelt am Tip. |
| P-06/P-07 | C-10 "nachgemessen+gebaut vor W3" | **ERFUELLT** | (a) Nachmessung: 0c80aa78-Vorfahr RC=0; Basis-Anker selbst verifiziert: `git show 66de5c09:...experiment_plan_director.hpp` -> `resource_group: \"ceb-measure-\" + host` an **:1449** und **:1616** (Bericht-Drift +1 gegen GOAL-:1448/:1615 bestaetigt); `measure_host_lane` an :759. (b) Bau: +70 Z. Produktion (Topologie-Kopf, fail-closed, Paritaets-Guard, [FENSTER-FREMD]) + 97 Z. Test. |
| P-08/P-09 | GOAL-Marker 16./17.08. | **ERFUELLT** | Marker wortgleich im GOAL (Z.650-661 gelesen); der Strang folgt der JUENGEREN Schicht (kein Neubau der Host-Lane-Haelfte, Commit-Body sagt es explizit: "Bestands-Pflicht, kein Neubau"). |
| P-10 | Ledger SOLL-1 | **ERFUELLT** | Ledger Z.2263-2267 wortgleich gegengelesen ("Generator emittiert bereits ceb-measure-<host> :1448/:1615"). |
| P-11 | KON29-04 "verdrahten ODER ausbuchen" | **ERFUELLT** | Ledger Z.8874-8880 wortgleich gegengelesen; Design-Wahl = VERDRAHTEN (Generator-Haelfte), Treiber-Haelfte deklariert offen (F-112, getragen). |
| P-12 | Fail-closed RANK>=MASCHINEN | **ERFUELLT** | Emissions-Diff literal: `if [ \"$MASCHINEN\" -gt 0 ] && [ \"$RANK\" -ge \"$MASCHINEN\" ]; then ... exit 1`; der `-gt 0`-Kurzschluss schuetzt zugleich die Modulo-Division im Guard. Test asserted den Abbruchtext 2x (je Build-Batch); Wegwerf-Mutation M-E10 (Guard-Flip) laut Bericht gefangen (FAILED :4171), Test-Substanz am Code verifiziert. |
| P-13 | Testat-Kontrakt-Neutralitaet | **ERFUELLT** | Emittierte Zeile traegt weder "TESTAT" noch "offen=" (Felder: ts/lane/zelle/phase/fenster/rank/maschinen — Diff literal). Objekt-Gegenprobe am Tip: `testat_marke_der_zeile` filtert `marke.find("TESTAT") == npos -> {}` (Test-TU :1555ff) — [FENSTER-FREMD] faellt strukturell aus der kTestatKlassifikation-Wache (`std::array<...,7>` :1902) heraus; Menge 7 unverschoben. |
| P-14 | H-10 Lande-Reihenfolge | **ERFUELLT** (Landungs-Auflage, nicht kampvor) | ZUG-BILANZ Z09: "Merge 10/10 kampvor 1e1bc199 GELANDET b4c593f5, merge-tree KONFLIKTFREI"; fenster-f4.md V10: Reihenfolge S1 (… pmcpaket) VOR S2 (… kampvor) eingehalten. |
| P-15 | R-15 L3-Asymmetrie nachgemessen | **ERFUELLT** | Strang-Dump Abschn. 1 (lscpu 128 MiB = Summe; sysfs 16x 98304K/0-7,16-23 + 16x 32768K/8-15,24-31); Werte decken sich mit Wellenplan R-15 Z.2649 "96/32 MB"; der ce-Code-Kommentar traegt dieselbe Herkunft ("/sys ... am Objekt gemessen (21.08.2026)"). |
| P-16 | E-20-ABNAHME "Pinning belegt" | **ERFUELLT** | [PIN-DEKLARATION]-Emission im Mess-Batch (Diff literal); Test asserted `count_occurrences(yaml, "[PIN-DEKLARATION] lane=") == 2u` + amd-Zeile + intel-Zeile wortgenau. Der Wortlaut fordert einen BELEG, keinen Aktuator — erfuellt in der ehrlichen Deklarations-Form. |
| P-17 | TABU system_axes/ | **ERFUELLT** | `git diff --name-only 66de5c09..1e1bc199 -- '*axes*' '*topics*' '*heuristik*'` = **0** (und super-Seite ebenso 0). |
| P-18 | Ehrlichkeit pin_ist=UNGEPINNT | **ERFUELLT** | Emission amd: `pin_soll=0-7,16-23 pin_ist=UNGEPINNT grund=aktuator-unverdrahtet ... folge=ungepinnt-nicht-reproduzierbar (R-15)`; intel: `pin_soll=UNVERMESSEN pin_ist=UNGEPINNT`. Negativ-Assertions im Test: `pin_ist=0-7,16-23` nie, `taskset` nie, `numactl` nie. |
| P-19 | T-1 ROT ZUERST | **ERFUELLT — vom Audit UNABHAENGIG REPRODUZIERT** | Tip-Proben gegen die UNGEHEILTEN Basis-Wachen (`COMDARE_FRISCHE=`/`COMDARE_SAMMLER=` auf a7e8e151-Exporte): frische **"NENNER: 17 Faelle gefahren, 14 gehalten, 3 gerissen"** (Risse exakt F6c/F6d/F6e, rc=1), persist **"NENNER: 18 Fall/Faelle gefahren, 15 gehalten, 3 gerissen"** (Risse exakt P16/P17/P18, rc=1) — wortgleich zu den Bericht-Behauptungen; Logs `proben-logs/*_ROT_an_basis_a7e8e151.log`. E-10/E-20: Wegwerf-Mutationen M-E10/M-E20 (Bericht-Literale mit FAILED-Zeilen; nach Traeger-Commit, F-115-Lehre dokumentiert). |
| P-20 | T-2 Aussage | **ERFUELLT** | Testkoerper gelesen: exakte Mengen (2u/4u/1u), Wert-Zeilen wortgenau, Semantik-Paritaet (n=1..3, w<12), Partitions-Vollstaendigkeit (32 Fenster, genau 1 Eigentuemer) — keine Existenz-Pruefungen. |
| P-21 | T-3 Nenner fremd | **ERFUELLT** | Proben drucken den Nenner selbst ("NENNER: 17 Faelle gefahren, 17 gehalten, 0 gerissen." / "32 ... 32 ... 0" / "18 ... 18 ... 0" — von mir literal erzeugt); ce: eingefrorene Mengen-Literale + Schleifen-Nenner im Test. |
| P-22 | T-4 Gegeneingang | **ERFUELLT** | E-9: F6d (gemischt -> rc=0 mit getrennten Nennern), F6e (provision_only -> rc=0), P17 (Commit MIT Nennern + Token im Blob), P18 (FEHLT-Feld -> kein rc=2); E-10: `window_belongs_to(5,4,2)==false` (rank>=n), `(7,3,0)==true` (n==0), Default-0/1-Unerreichbarkeits-Kommentar + PerBatchSliceArithmetic-8u-Nachzug. |
| P-23 | T-5 Orakel unabhaengig | **ERFUELLT** | Orakel der Paritaet = `bestandslog::window_belongs_to` (Bestandsfunktion; Pruefling ist die EMISSION — zweigliedrige Kette: literaler Emissions-String + Formel-gegen-Bestand); Formel am Tip gegengelesen (batch_planner.hpp: `n_machines==0 -> true; (w % n)==rank`). Proben: fordere_zahl rechnet Blob-Zeilen per awk unabhaengig nach. |
| P-24 | T-6 Schwesterpflicht E-10/E-20 | **ERFUELLT** | Ein Commit `1e1bc199` traegt beide an derselben Emissionsflaeche; E-9-Schwester-Trio unter P-04. |
| P-25 | T-7 Registrierung | **ERFUELLT** | TU registriert: `tests/unit/CMakeLists.txt:4210 comdare_add_test(test_experiment_plan_director SOURCES thesis_tiere/test_experiment_plan_director.cpp` (am Tip gelesen); die 2 neuen TEST()-Faelle haengen in dieser bestehenden TU (keine CMake-Aenderung noetig, H-9-konform). Zusatz-Beleg aus dem Audit selbst: der ERSTE Teil-Export (nur ci/) riss an der frische-Probe-eigenen Registrierungs-Wache ("ABBRUCH: ... .gitlab-ci.yml fehlt") — die T-7-Wache der Proben beisst nachweislich. ctest-N-Vorher/Nachher-Zaehler bleibt im Strang-Bericht unliteral (S-6-Beleg-Luecke, durch TU-Struktur + Endstand-Kombibau substanziell gedeckt — kein Fund). |
| P-26 | T-8 atomare Landung | **ERFUELLT** | Je Repo EIN Commit mit Test+Minimalbau (Diffs gelesen); Rot vor/Gruen nach Heilung im Paket (P-19). |
| P-27 | T-9 Testkritik (vorwaerts) | **OFFEN an Folge-Instanz (kein kampvor-Fund)** | Die OBJEKTPRUEFUNG der 5 neuen Pruef-Gegenstaende hat DIESES Audit geleistet (Code-Volllesung + eigenstaendige Laeufe + Mutations-Reproduktion); der formale Codex-Pass der Folgewelle bleibt als Posten der W3-Vorstaffel-/Folgewellen-Abnahme. |
| P-28 | T-11c Mutations-Protokoll | **ERFUELLT** | Selbstbisse selbst reproduziert: 7/7, 9/9, 5/5 ("NENNER SELBSTBISS: 7 Mutanten gefahren, 7 gefangen." etc., Logs persistiert). Koeder-Form-Pruefung IST strukturell vorhanden (staerker als im Bericht benannt): `mutant_fahren` prueft `cmp -s` und bricht bei byte-gleichem Mutanten mit rc=2 ab (frische_probe :644-647, selbst gelesen); P18 prueft beide Felder VOR der Entfernung. ce: M-E10/M-E20 Bericht-literal (:4171/:4218/:4220), danach 89/89. |
| P-29 | T-11b Kombibau (Wellen-Abnahme, nicht kampvor) | **ERFUELLT am ce-Endstand (durch Lande-Zug)** | fenster-f4.md V10: Endstand-Merge `5ddda4e5` "K17-Kombibau 4/4 '100% tests passed, 0 tests failed out of 544'; Gates 6/6" — die kampvor-TU ist Teil dieser 544er-Menge. BEIDE Mengen benannt: der Endstand-Kombibau deckt die Testmenge AM GEMERGTEN STAND (544), nicht die Strang-eigene 510/510-Bilanz am Tip (die bleibt Bericht-Literal, s. KLEIN-1). super: Kombibau nicht einschlaegig (Shell), Proben sind der Pruefweg. |
| P-30 | GOAL-Nenner-Doktrin | **ERFUELLT** | Deckungsgleich mit P-19/P-21/P-28 (keine Doppelzaehlung). |
| P-31 | K13 Koeder /dev/urandom | **ERFUELLT** | `token() { od -An -tx1 -N8 /dev/urandom ...}` + `wuerfel()` aus /dev/urandom (frische_probe :91-96, selbst gelesen); Fall-Parameter (Zeilenzahlen, Kennungen, Tokens) je Lauf gewuerfelt — meine Laeufe zeigten andere Zufallswerte (F6c "Alt(2)+Neu(4 n/a)" bzw. "Alt(6)+Neu(6 n/a+5 echte)") bei identischer Bilanz; beide Richtungen gefahren. |
| P-32 | V11 Messung vor Satz | **ERFUELLT** | Reihenfolge im Bericht konsistent (Explore Abschn. 2/4/5 vor Bau, ROT Abschn. 6 vor Heilung Abschn. 7); der unabhaengige Basis-Riss (P-19) beweist, dass die Faelle die Luecke messen und nicht nachtraeglich passend gemacht sind. |
| P-33 | TABU axes/topics/heuristik | **ERFUELLT** | 0 Treffer je Pathspec, beide Repos (Kommando + Zahl literal im Audit-Transkript). |
| P-34 | golden byte-stabil | **ERFUELLT** | `git diff --name-only ... -- '*golden*' '*overlay_source_set*' '*axis_version.lock*'` = 0 (ce) bzw. 0 (super). |
| P-35 | kein YAML | **ERFUELLT** | `-- '*.yml' '*.yaml'` = 0 Treffer, beide Repos. |
| P-36 | tests/unit/CMakeLists nur Dateiende | **GEGENSTANDSLOS** | Datei nicht im Diff (0 Treffer '*CMakeLists.txt'); deckt sich mit H-9 ("kampvor registriert keine neue TU"). |
| P-37 | ASCII-only neue Zeilen | **ERFUELLT** | `LC_ALL=C grep -c` ueber alle '+'-Zeilen beider Diffs = **0** Nicht-ASCII-Treffer (rc=1). |
| P-38 | clang-format-22 / Shell-Lint | **ERFUELLT** | `~/.local/bin/clang-format-22 --dry-run --Werror` ueber beide ce-Tip-Dateien: rc=0 (selbst gefahren). Shell: `bash -n` + `sh -n` je Aufrufkonvention gruen (frische=sh-Datei sh-sauber; persist=bash-Datei bash-sauber; Praezisierung s. KLEIN-2); Zeilenlaengen: 0 neue Zeile > 119 Byte (awk ueber alle '+'-Zeilen des super-ci-Diffs). |
| P-39 | Commit-Trailer | **ERFUELLT** | `Co-Authored-By: Claude Fable 5 <noreply@anthropic.com>` literal in BEIDEN Commit-Bodies (git log --format=%B gelesen). |
| P-40 | push -o ci.skip / Ref-Sicherung | **ERFUELLT** | `refs/remotes/origin/bau/kampvor` = `1e1bc199...` (ce) und `025e0c42...` (super), for-each-ref literal; ZUG-BILANZ Z09 bestaetigt zusaetzlich den ci.skip-API-Beweis der Landung (Pipeline 16071 "skipped", jobs UNION bridges = []). |
| P-41 | Bau-Slot-Protokoll | **NICHT-PRUEFBAR am Objekt** (kein Fund) | Slot-Verzeichnisse nach Freigabe entfernt (bauart-gemaess); Bericht-Protokoll (Slot 3 genommen/freigegeben) in sich konsistent, keine Gegenindizien. |
| P-42 | df-Gate + build/-Bereinigung | **ERFUELLT** | Bericht-Behauptung "git ls-files build/ = 0" am Tip gegengeprueft: `git ls-tree -r 1e1bc199 build/` = **0** Dateien — die Memory-Falle "getrackte Mess-CSV unter ce build/" ist am Tip leer; keine *.csv/*.xlsx im Diff. Audit-eigenes df-Gate: 25G frei (>5G). |

## 2. Abnahme-Formeln (woertlich, Urteil)

1. E-9 "nachgezogen oder deklariert; vor W3-Kampagne" — **nachgezogen** (staerkere Alternative),
   Commit 21.08. — ERFUELLT; Landung der super-Haelfte vor Sa 29.08. = offener Lande-Zug-Posten.
2. E-10 "nachgemessen+gebaut vor W3" — nachgemessen (0c80aa78-Vorfahr + Anker :1449/:1616 selbst
   verifiziert) + gebaut (Generator-Haelfte; YAML-/Treiber-Haelften ausdruecklich deklarierte
   Nachfolge-Zuege) — ERFUELLT im mandatierten Umfang.
3. E-20 "Pinning belegt" — [PIN-DEKLARATION] in beiden Mess-Batches, testgedeckt — ERFUELLT
   (Beleg-Form; Aktuator-Verdrahtung = W3-Vorstaffel, ehrlich deklariert).
4. T-1/T-11c — beide Formen geliefert UND vom Audit unabhaengig reproduziert (3+3 Basis-Risse;
   7/7+9/9+5/5 Selbstbisse) — ERFUELLT.
5. GOAL-Fail-closed — exit 1 vor der ersten Perm; kein stilles Leer-Gruen — ERFUELLT.

## 3. FUNDE

**KLEIN-1 — Beweisordner ohne Log-Kopien (Beweisorte-Doktrin).**
`20260820-w2-sofortstaffel/kampagnen-vorposten-beweise/` traegt nur 3 Patch-/Diff-Dateien;
die im Bericht zitierten Rot-/Gruen-Bilanzzeilen (17/17, 18/18, 32/32, Selbstbisse, ctest
510/510, 89/89) lagen NICHT als gesicherte Log-Kopien vor ("Beweisorte = gesicherte Kopien").
Substanz unbeschaedigt: alle Proben-Bilanzen wurden von diesem Audit am Objekt reproduziert
(identische Nenner), die ce-Testmenge ist durch den K17-Endstand-Kombibau (4x 544/544) am
gemergten Stand gedeckt.
fix_weg: ERLEDIGT fuer die super-Haelfte durch dieses Audit — 5 Logs persistiert unter
`/home/comdare/backups-workflow/20260821-w2-audit-fixverify/kampvor/proben-logs/`
(3x Selbstbiss-Gruen am Tip, 2x Rot-Lauf an Basis a7e8e151); fuer kuenftige Straenge:
Proben-/ctest-Ausgaben im selben Zug in den Beweisordner kopieren (Datei, kein Zitat).

**KLEIN-2 — Bericht-Formel "bash -n/sh -n gruen" pauschal.**
`sh -n` reisst an `ci/persist_sammler.sh` ("redirection unexpected", Process Substitution
`done < <(find ...)` im gehobenen Block B) — BESTAND, kein kampvor-Regress (Basis a7e8e151
reisst an derselben Konstruktion, Z.230 -> Z.273 nur um den +43-Diff verschoben) und kein
Laufzeit-Defekt (Shebang `#!/usr/bin/env bash`; Probe und CI rufen `bash "$SAMMLER"`;
frische_wache.sh ist die sh-Datei und sh-sauber). Die pauschale Doppel-Formel im Strang-
Bericht ist fuer diese eine Datei nur in der bash-Haelfte wahr.
fix_weg: kein Code-Fix; in der Synthese/Nachfolge-Berichten als "je Datei das einschlaegige
Lint (sh-Datei -> sh -n; bash-Datei -> bash -n)" fuehren. Datei: Berichts-/Synthese-Text,
kein Objekt.

## 4. Getragene OFFENE Posten (F-01..F-123 — KEINE neuen Funde, nur Liste)

- F-108 Wellenplan Z.718 "2x128 MiB CCD" — am 23.08. UNVERAENDERT bestaetigt (sed -n 718p);
  Traeger Lead docs-Zug (+ T12b CCD-Semantik lt. Lande-Inventur L16). Sollzustand fuer kampvor.
- F-112-Rest Treiber-Konsument window_belongs_to (BatchPlanner-Produktionsaufruf) = W3-Vorstaffel.
- F-114 run_profile-Pin-Konsument + prod2-Topologie-Vermessung = W3-Vorstaffel/Folgeposten.
- E-10-YAML-Haelfte + E-14 + E-15 = Staffel-3-YAML-Zug (kampvor hat auftragsgemaess 0 YAML
  angefasst — verifiziert, s. P-35).
- K17-Kombibau: ce-Endstand ERLEDIGT durch Lande-Zug (544/544 x4); super-Haelfte n/a.
- super-Landung (Super-Phase des Lande-Zugs, kampvor-super @ 025e0c42) — VOR Sa 29.08. 06:00
  faellig (E-9-Frist-Nenner), Traeger Lande-Zug/Lead.
- T-9-Codex-Pass der Folgewelle ueber die 5 neuen Pruef-Gegenstaende (Objektpruefungs-Haelfte
  durch dieses Audit geleistet).

## 5. Spannungen der Soll-Karte — Audit-Antwort

- S-1 (C-10-Wortlaut veraltet): bestaetigt aufgeloest — der Strang folgt der juengeren
  GOAL-17.08.-/Ledger-SOLL-1-Schicht; Wellenplan §19.3 wurde NICHT als Massstab fuer
  "Intel-Gegenstueck" verwendet.
- S-2 (Z.718 vs. R-15): Objektmessung schlaegt Text — R-15/Z.2649 + sysfs gelten; Z.718
  unveraendert = F-108 (getragen).
- S-3 (C-10-Label-Kollision): alle Audit-Treffer gegen die Korb-C-Zaehlung §19.3 geprueft;
  kein checkpoint_measure-"C-10" wurde kampvor zugerechnet.
- S-4 (V-1..V-14): kein nicht-existenter V-Punkt gesucht; GOAL-Doktrinen ueber II.2/II.6/II.7 +
  VII.2-Marker geprueft.
- S-5 (CCD-Wahl): CCD0/96 MiB als Strang-Auslegung akzeptiert — der Code-Kommentar begruendet
  sie ("GROSSE homogene Menge, X3D-V-Cache; Kern-Wahl im CCD = Aktuator-Politik"); nicht als
  falsch wertbar, R-15 legt die CCD nicht fest.
- S-6 (T-7-Registrierungs-Bissprobe): substanziell gedeckt (P-25), keine eigene Fund-Zeile.

## 6. Beweis-Inventar dieses Audits

- 5 persistierte Proben-Logs (Pfad s.o.): frische_wache_probe_selbstbiss.log (17/17, 7/7),
  persist_sammler_probe_selbstbiss.log (18/18, 9/9), mess_ausbeute_bissprobe_selbstbiss.log
  (32/32, 5/5), frische_ROT_an_basis_a7e8e151.log (14/17, Risse F6c/F6d/F6e),
  persist_ROT_an_basis_a7e8e151.log (15/18, Risse P16/P17/P18).
- Alle uebrigen Literale (Diffs, grep-Zaehler, Ancestor-RCs, clang-format-rc, Trailer,
  origin-Refs, Ledger-/GOAL-/Wellenplan-Fenster) im Audit-Transkript; /tmp-Export nach
  Abschluss geraeumt (rm -rf /tmp/kampvor-audit), Hauptklone unberuehrt (nur Lese-Kommandos).
