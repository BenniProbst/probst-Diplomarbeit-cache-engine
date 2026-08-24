# SOLL-KARTE -- E-11 / C-12 FEHLERKLASSEN (Strang e11-fehlerklassen-design, Staffel 2)

Erhoben: 23.08.2026, Sonnet-max-Planungs-Erheber (S2 "e11"), NUR LESEN, kein Fix.
Zweck: Vollstaendigkeits-Pruefliste fuer das Audit gegen Wellenplan v2, Designplan-tdd, GOAL v8,
LEAD-ENTSCHEIDE, Ledger (KON119-Kopf), Findings-Bestand (STAFFEL1/2-SYNTHESE).

**Fassungs-Hinweis (diese Ueberarbeitung, selber Tag):** diese Karte aktualisiert eine
Vorfassung um (a) eine ERNEUTE, unabhaengige Objekt-Gegenprobe am inzwischen weiter
gewanderten HEAD, (b) den Abgleich mit der bereits ABGESCHLOSSENEN Audit-Runde 1 vom 22.08.
(Verdikt **SITZT**, 4 KLEIN-Funde E11-A1..A4 an der DESIGN-Datei selbst -- s. Abschnitt VII
am Ende), und (c) eine Kontrolle der beiden juengsten Ledger-Kopf-Eintraege KON120/KON121
(22.08.) auf E-11-Relevanz. Kein Inhalt der Vorfassung wurde entfernt, nur ergaenzt/verifiziert
-- Pruefliste, Abnahme-Formeln, Nicht-Gefordert und Spannungen dieser Karte decken sich mit der
unabhaengig recherchierten Fassung.

**Strang-Steckbrief (Auftrag):** E-11/C-12 Fehlerklassen NUR Explore+Design; Deliverable
`~/backups-workflow/20260820-w2-sofortstaffel/e11-fehlerklassen-design.md` (278 Z., P1-P5
baureif); Ergebnis-Bericht `e11-fehlerklassen-design-ergebnis.md` (133 Z.); KEIN Bau-Zweig.

**Objekt-Gegenprobe (von mir selbst verifiziert, nicht nur behauptet):**
- ce `origin/development` HEAD **jetzt** `3841d717` (23.08. 13:50, "fix(ci): CI-16095-Heilung
  Teil 4") -- weitergewandert seit der Vorfassung dieser Karte (`b247a339`, 23.08. 09:11) und
  seit Audit-Runde 1 (`ed9f1a3c`, 22.08.). Design-Basis war `66de5c09`(20.08.)/`65c51eeb`(21.08.,
  additiv nur B02 `genus_leistungs_version`). HEAD-Drift ist damit GROESSER als in jeder
  bisherigen Fassung dieser Karte gemessen (s. SPANNUNGEN #6, jetzt mit Gegenprobe unten).
- **Gegenprobe ueber den GESAMTEN Drift-Zeitraum (`66de5c09..3841d717`, nicht nur bis zur
  Vorfassung):** `git diff --stat` exakt ueber die 9 vom Design beruehrten/gelesenen
  Bestandsdateien (`axis_error.hpp`, `axis_error_traits.hpp`, `axis_error_traits_organ.hpp`,
  `ceb_complex_system_axis.hpp`, `organ_axis_error_classes.hpp`,
  `dock_error_classification.hpp`, `axis_variant_version_table.hpp`,
  `hybrid_dock_contract.hpp`, `hybrid_config_xml.hpp`) ist **LEER** -- keine einzige dieser
  Dateien hat sich seit der Design-Erhebung veraendert, trotz 5 dazwischenliegender Commits
  (`85a67b08`,`9da4d21d`,`6713156b`,`3149c8a2`,`1d38263b`, alle W2-Lande-Zuege anderer
  Straenge). Die IST-Karte des Designs (Abschnitt 1) bleibt damit inhaltlich exakt gueltig, auch
  am jetzigen HEAD -- die weiterhin PFLICHTIGE V0-Gegenlese (Design Abschnitt 8) ist ein
  Verfahrensschritt, kein Hinweis auf tatsaechlich veraenderten Befund.
- `git branch -a` im ce-Hauptklon traegt KEINEN e11-Zweig; einziger "fehlerklasse"-Treffer ist
  `bau/a15-fk3-fk4-fehlerklassen` @ `fea430d0` (07.08.), verifiziert **bereits Ahnen-Commit von
  origin/development** (`git merge-base --is-ancestor` = wahr) -- Alt-Landung, kein Bezug zu
  diesem Strang. Deckt die Ergebnis-Behauptung "Kein Worktree angelegt, kein Commit" (ERGEBNIS
  Z.129). `git worktree list` traegt ebenfalls keinen e11-Eintrag -- alle vorhandenen
  Worktree-/Bau-Verzeichnisse sind anderen, namentlich erkennbaren Straengen zugeordnet
  (`wt-ce-<strang>`-Muster bzw. Workflow-Unter-Worktrees).
- Bestehende FK-Traeger-Dateien (`axis_error.hpp`, `axis_error_traits.hpp`,
  `axis_error_traits_organ.hpp`, `axis_variant_version_table.hpp`, `hybrid_dock_contract.hpp`,
  `organ_axis_error_classes.hpp`) existieren am aktuellen HEAD. Die vom Design NEU geplanten
  Dateien (`axis_error_traits_sub.hpp`, `axis_error_traits_registry.hpp`,
  `test_t13_fk3_walk_compound.cpp`, `test_t14_unterachsen_algorithmen.cpp`) existieren am
  aktuellen HEAD **nicht** -- konsistent mit "Design, kein Bau" auch gegen den heutigen Stand.
  Ebenso am aktuellen HEAD bestaetigt: `axis_error_traits.hpp` traegt weiterhin KEINEN
  `AxisErrorTraits<CompoundSystemAxis...>`-Eintrag (P1-Luecke offen) und
  `test_a15_fk3_axis_error_traits.cpp:222` traegt weiterhin das harte Literal
  `n == 20u` (P2-Luecke offen) -- beide IST-Kernbefunde des Designs sind am HEUTIGEN Stand
  erneut bestaetigt, nicht nur am 20./21.08.-Explore-Stand.
- `axis_error.hpp:4` traegt die Owner-Direktive wortgleich zur Ledger-Fassung (s. P-03).
  `kAllRegisteredOrganVariantCount` ist tatsaechlich CT ueber `mp::mp_size<...>` abgeleitet
  (`axis_variant_version_table.hpp:167`), konsistent mit der Design-Behauptung.
- **Ledger-Kopf-Kontrolle KON120/KON121 (22.08., juenger als der in den Quellen benannte
  KON119-Kopf):** Volltext-Grep ueber beide KON-Bloecke (Ledger-Zeilen 1-170, Themen: A1-A4-
  Verbuchung, B1-B5/C1-C4/D-01-D-11-Deckung, W1L-Terminalzeile, V8-prod1-Vollzug,
  Owner-Ruege "Faden verloren") nach `fehlerklass|C-12|T-13|T-14|E-11|axis_error|FK-3|FK-6|
  CompoundSystemAxis` liefert **0 Treffer** -- KON120/KON121 aendern an der C-12/E-11-Soll-Lage
  NICHTS; die juengste inhaltlich einschlaegige Ledger-Schicht bleibt die A15/FK-Kette
  (02.08.-07.08., s. P-03/P-07) plus die WIEDERAUFNAHME-MARKER vom 18.08. (Wellenplan par.21).

---

## PRUEFLISTE

### I. Auftrags-Rahmen

**P-01 -- Explore+Design JETZT, Bau als eigener Zug spaeter.**
WAS: "E-11 faehrt deshalb JETZT als Explore+Design (Staffel 2), der Bau als eigener
golden-Ereignis-Zug danach -- nie nebenbei in einer Parallel-Staffel." (LEAD-ENTSCHEIDE Z.26-27,
"EISERNE-REGEL-KLARSTELLUNG fuer T-13/T-14 (E-11)", begruendet ueber Z.24-25: axes/-Aenderungen
sind seit der #15-Landung KONTROLLIERTE GOLDEN-EREIGNISSE).
WIE pruefbar: `git branch -a` / `git worktree list` im ce-Hauptklon (kein e11-Zweig erwartet);
Design-Datei traegt keinen Commit-Hash als Ist-Artefakt.
BEHAUPTET: JA -- ERGEBNIS Z.3 ("Auftrag: NUR Explore + Design, KEIN Worktree, KEIN Bau.") und
Z.127-129 ("KEIN Bau beauftragt... Kein Worktree angelegt, kein Commit"). Von mir zusaetzlich
objektiv verifiziert (s. oben).

**P-02 -- Der woertliche Auftragsposten.**
WAS: "**E-11 C-12 FEHLERKLASSEN-PFLICHT** T-13/T-14 (0/18 bzw. 0/121; T-UPD-2: Kollision
zugunsten C-12 aufgeloest; VOR W3 PFLICHT). QUELLE K2:§19.3 C-12 + §20.8 T-UPD-2 + §21.3 ##40.
ABNAHME: Abdeckung >0/18 und >0/121 gemessen." (AUFTRAG/W2-ABFOLGE-DESIGN.md Z.482-484)
WIE pruefbar: Wortlaut-Abgleich Design-Kopf gegen diese Zeilen.
BEHAUPTET: JA -- Design Z.8-9 zitiert diese Zeilen woertlich fast identisch als "Auftrag:".

**P-03 -- Owner-Mandat 17.07. (das materielle WARUM hinter C-12).**
WAS: "**Fehlerklassen und Behandlung sind für alle Achsen → Unterachsen → Algorithmen Pflicht.**"
(LEDGER Z.16969, verbatim; ausfuehrlich mit den drei Klassen (a) Hardware-/Erweiterungs-Fehlen,
(b) Compile-Fehler einer Achsen-Kombination, (c) Runtime-Algo-Fehler bei LEDGER Z.22192 --
"Der Experiment-Planer (Compiler-Compiler) muss diese Klassen kennen + je Achsen-Permutation die
passende erkennen/loggen, statt hart abzubrechen.") Gleicher Wortlaut steht im Objekt selbst:
`axis_error.hpp:4` ("User-Direktive 2026-07-17: 'Fehlerklassen und Behandlung sind fuer ALLE
Achsen -> Unterachsen -> Algorithmen Pflicht.'").
WIE pruefbar: `git show origin/development:libs/cache_engine/include/cache_engine/measurement/axis_error.hpp | head -8`.
BEHAUPTET: JA -- Design Z.12-13 zitiert die Direktive samt Datei-Anker "axis_error.hpp:4-5".
Die DREI Owner-Klassen (a)/(b)/(c) werden vom Design nicht als Dreier-Liste rueckbestaetigt,
sondern implizit ueber die FK-Ebenen-Leiter abgedeckt (FK-3/Achsen=b, FK-4/FK-5/Blaetter+Algorithmen
=c, die neue `BetriebssystemFeatureFehlt`-Bindung in P3 = a); ein expliziter (a)/(b)/(c)-Abgleich
fehlt im Design-Text selbst -- Audit-Punkt.

**P-04 -- Kollisionsaufloesung T-13/T-14: W7 vs. vor-W3, zugunsten C-12 entschieden.**
WAS: "T-UPD-2 #40-Wellen-Kollision T-13/T-14 aufloesen (W7 vs vor-W3/C-12)" (WELLENPLAN
Z.2793); bestaetigt durch "WIEDERAUFNAHME-MARKER 18.08.2026 (par.21): C-12/T-13/T-14
(Fehlerklassen) bleiben PFLICHT VOR W3 -- die Rutsch-/W7-Vermerke anderswo sind Historie"
(WELLENPLAN Z.2492-2493).
WIE pruefbar: Wellenplan-Grep "T-UPD-2" und "WIEDERAUFNAHME-MARKER"; beide Fundstellen sind
juenger als jede evtl. W7-Referenz und muessen sie ueberstimmen.
BEHAUPTET: JA -- Design Z.9 ("Auftrag: ... T-UPD-2: Kollision zugunsten C-12 aufgeloest").

**P-05 -- Frist VOR W3 (mehrfach unabhaengig belegt).**
WAS: "C-12 Fehlerklassen PFLICHT ... -> T-13/T-14 vor W3" (WELLENPLAN Z.2481-2482); "##40-Restbau
... T-13/T-14 (Fehlerklassen!) = C-12-PFLICHT VOR W3 (par.19.3 fuehrt sie schon; vor Sa 29.08.)"
(WELLENPLAN Z.3013-3014).
WIE pruefbar: Termin-Deckel Sa 29.08. gegen den tatsaechlichen Bau-Zug-Start (Staffel 3) halten.
BEHAUPTET: TEILWEISE -- das Design LIEFERT (Explore+Design-Anteil der Frist ist erfuellt: "Design
liegt dann", LEAD-ENTSCHEIDE Z.51), aber der EIGENTLICHE BAU (der die Zahlen 0/18 bzw. 0/121 auf
etwas >0 hebt) ist per Auftragslage explizit NICHT Teil dieses Strangs und steht noch aus -- die
Frist "vor Sa 29.08." bezieht sich auf den GESAMTPOSTEN C-12 (inkl. Bau), nicht nur das Design.
Das Audit muss pruefen, ob der golden-Zug-Bau bereits terminiert/gestartet ist.

**P-06 -- L8-Andockung: Hybrid-Parser-Fehlerklassen sind an denselben Posten angebunden.**
WAS: "L8 Hybrid-Parser fail-closed OHNE fehlerklasse=-Traeger (K12-Teammate-Audit) -- an
T-13/T-14-Fehlerklassen-Posten angedockt (par.21.3 ##40-Restbau, C-12-PFLICHT vor Sa 29.08.);
#96 zaehlt gegen." (WELLENPLAN Z.3588-3590)
WIE pruefbar: Design Abschnitt 5.5 (P5) und 9 gegen diese Zeile halten; #96-Gegenzaehlung pruefen.
BEHAUPTET: JA -- Design widmet P5/Abschnitt 5.5 explizit dieser Andockung
(`hybrid_status_fehlerklasse()`-Totalabbildung + `hybrid_status_meldung()`).

### II. Substanz der Design-Lieferung (P1-P5)

**P-07 -- IST-Karte muss je FK-Ebene (0-4) am OBJEKT gemessen sein, nicht behauptet.**
WAS: implizite Owner-/Haus-Doktrin "Gegenstand statt Ankuendigung" (V-8, WELLENPLAN Z.960: "Zu
**jeder** Formel gehoert die Antwort auf: 'Was waere der Zustand, in dem diese Ausgabe erscheint
und die Sache trotzdem nicht existiert?' ... prueft die Formel am **Gegenstand** ... nie an der
**Ankuendigung**"); operationalisiert durch die A15-Leiter (Ordnungsrahmen EBENE 0-4, Design Z.19).
WIE pruefbar: jede Ebenen-Zeile der IST-Tabelle (Design Z.22-30) gegen den Objektstand pruefen
(Datei:Zeile-Anker je Zeile vorhanden).
BEHAUPTET: JA -- Design Abschnitt 1 liefert eine 6-zeilige Tabelle (Ebene 0/1/2/2b/2c/3/4) mit
Verdrahtungspunkt UND Ist-Stand je Zeile, durchgehend mit Datei:Zeile-Ankern. Stichprobe von mir
verifiziert: `axis_variant_version_table.hpp:167` traegt tatsaechlich
`kAllRegisteredOrganVariantCount` CT-abgeleitet, wie behauptet.

**P-08 -- Nenner-Fremd-Pflicht: Zahlen muessen aus einer anderen Quelle als dem Pruefling
stammen und duerfen nicht hart verdrahtet werden.**
WAS: "**T-3 NENNER, FREMD.** Jeder Test nennt seine Grundgesamtheit und bezieht sie aus einer
anderen Quelle als dem Prüfling (Konstante neben dem Enum, Quelltext-Scan, eingefrorene
Literalliste); `ASSERT` auf die Zahl VOR der Schleife." (DESIGNPLAN Z.69)
WIE pruefbar: P2/P4 gegen dieses Kriterium halten (kein hartes `== 20u`/`== 121` im Testcode).
BEHAUPTET: JA -- Design Abschnitt 5.2 ersetzt explizit `n == 20u` durch
`n == kGebundeneAchsenFamilienZahl` ("Nenner fremd, aus dem Header"); Abschnitt 5.4 verlangt
"Wache `>= 121`" (nicht `== 121`, nicht `== 126`) mit Kommentar zur Korrektur, "der Test bricht
NICHT bei Registry-Wachstum"; Abschnitt 2 nennt das explizit "V0-BAUAUFLAGE: ... nie den Nenner
18 im Test hart verdrahten (Nenner-fremd-Regel)".

**P-09 -- Nenner-Korrektur 0/121 -> 126 muss als MESSUNG, nicht als Annahme dokumentiert sein.**
WAS: Design Abschnitt 2: "'0/121' (T-14, Algorithmen): 121 war NIE der Ist (FK-6-Header, gemessen
09.08.: **126 registrierte Organ-Varianten** via mp_size, 124 algo_version-Literale, Differenz =
Registry-Wrapper ohne eigenes Literal)."
WIE pruefbar: `grep -n "kAllRegisteredOrganVariantCount" axis_variant_version_table.hpp` +
Compile-Zeit-Ausdruck pruefen (mp_size-Ergebnis ist erst am Bau-Tag literal zu drucken).
BEHAUPTET: JA, mit Beleg-Kette (FK-6-Header, gemessen 09.08.) -- **von KEINER der Plan-Quellen
(Wellenplan, W2-ABFOLGE, Designplan) unabhaengig bestaetigt** (Grep auf "126" liefert in beiden
Dateien 0 echte Treffer, s. SPANNUNGEN #4). Der Beleg steht bislang NUR im Strang selbst
(Design/Ergebnis) und sekundaer in STAFFEL2-SYNTHESE F-116 (dieselbe Quelle referenzierend, keine
unabhaengige Zweitmessung).

**P-10 -- P1: CompoundSystemAxis-Traits-Eintrag (Familie Nr. 21).**
WAS: Design Abschnitt 5.1: partielle Spezialisierung
`AxisErrorTraits<CompoundSystemAxis<IsaK, OsA, ExtU>>`, Fehlerraum = Vereinigung der drei
Glieder-Familien-Raeume (Config-Realm, domains={D1}), keine neuen Klassen.
WIE pruefbar: `git show origin/development:.../ceb_complex_system_axis.hpp | sed -n '70,90p'`.
BEHAUPTET: JA (als Plan). **Eigene Gegenprobe:** das reale Objekt zeigt
`template <class TargetIsaComplex, class OperatingSystem, class ExternalUtils, class SubAxes>
struct CompoundSystemAxis` -- **VIER** Template-Parameter, nicht drei wie in der Design-Kurzform
`<IsaK, OsA, ExtU>` angedeutet (der vierte, `SubAxes`, traegt laut Kommentar im Objekt selbst "die
Unter-Achsen-Gruppe ... beschreibt den BAU"). Das ist keine Design-Luecke -- das Design fordert
selbst "Template-Parameter-Form am Objekt ablesen" (Abschnitt 5.1) und die generelle
V0-Gegenlese-Pflicht (Abschnitt 8) deckt genau diesen Fall -- aber am Bau-Tag ist die
Spezialisierung mit VIER Parametern zu schreiben, nicht drei; ein Audit sollte das als offenen
Praezisierungspunkt, nicht als Fehlbefund werten.

**P-11 -- P2: Vollstaendigkeits-Walk statt Handliste (21 Familien).**
WAS: Design Abschnitt 5.2: neuer Header `axis_error_traits_registry.hpp` mit CT-Typliste
`kGebundeneAchsenFamilien` (mp11-frei) + `consteval walk_alle_achsen_familien()`; Begruendung im
Kopf, warum die Liste die Wahrheitsquelle sein darf ("keine walkbare System-Familien-Typ-Registry
am Objekt ... geprueft 21.08.").
WIE pruefbar: existiert `axis_error_traits_registry.hpp` (soll NEIN vor Bau); `kSystemAxisOrder`
in `abi/` pruefen (Design behauptet: Namens-Ordnung mit 3 Eintraegen, keine Typliste).
BEHAUPTET: JA, vollstaendig ausgeplant inkl. Negativ-Probe (Wegwerf-Typ ohne Listen-Eintrag).

**P-12 -- P3: Unterachsen-Blatt-Ebene, 18(/19) Voll-Spezialisierungen + Verfeinerungs-Wache.**
WAS: Design Abschnitt 5.3: neuer Header `axis_error_traits_sub.hpp`, VERFEINERUNGS-Semantik
`assert_sub_axis_verfeinerung<Blatt, Familie>()` (V1 domains gleich, V2 Blatt-Satz enthaelt
Familien-Satz, V3 nicht leer); OS-Subs fuehren zusaetzlich `BetriebssystemFeatureFehlt`.
WIE pruefbar: Blatt-Liste (16 SubAxis + Gcc/ClangCompilerAxis = 18, Kandidat 19
DefaultSchedulingSystemAxis) gegen `system_axis_order.hpp:21` und das tatsaechliche Registry
pruefen.
BEHAUPTET: JA, MIT explizit offen gelassener 18-vs-19-Frage (Design Abschnitt 2 + Ergebnis
Z.130-131: "Offene Punkte fuer den Bau-Zug: ... (b) Nenner-Messung 18 vs. 19"). Das Design
verdrahtet die Zahl bewusst NICHT.

**P-13 -- P4: Algorithmen-Messnachweis, vier gezaehlte, gedruckte Groessen.**
WAS: Design Abschnitt 5.4: Zaehler A (`kAllRegisteredOrganVariantCount`, Wache `>= 121`),
Zaehler B (eigene `error_classes()`, heute 1, Wache `>= 1`), Zaehler C
(`algo_fehlerraum_erfuellt<W>`, Wache `== kAllRegisteredOrganVariantCount`), Zaehler D
(Uebergangsliste, Wache `== 0`); Druckform `[T-14] <name> = <zahl> / <nenner>`.
WIE pruefbar: `test_t14_unterachsen_algorithmen.cpp` (existiert NEIN vor Bau) -> nach Bau: 4
Druckzeilen im ctest-Log.
BEHAUPTET: JA, vier Zaehler vollstaendig benannt inkl. Bestandsformel (">0/121" MIT dokumentierter
Nenner-Korrektur).

**P-14 -- P5: Hybrid-Status-Raum an fehlerklasse=-Konvention binden.**
WAS: Design Abschnitt 5.5: `hybrid_status_fehlerklasse(int)` TOTALE Abbildung ueber
`kAlleHybridStatus` (16 Codes) auf GENAU ZWEI etablierte Etiketten
(`konfiguration_unvollstaendig`, `konfiguration_widerspruch`) + `hybrid_status_meldung(int)`
("fehlerklasse=<etikett> hybrid_status=<n>").
WIE pruefbar: `hybrid_dock_contract.hpp:80-119` (Registry `:125`) gegen die 16-Code-Behauptung
zaehlen; Etiketten-Vokabular gegen die ">40 Stellen" bestehender `fehlerklasse=`-Traeger
(Design Z.37-40) abgleichen.
BEHAUPTET: JA, inkl. begruendeter Einzelfall-Entscheidung je Statuscode (Design Z.160-177) und
Abgrenzung "ok -> kein Fehlerraum-Mitglied". Meine grobe Gegenzaehlung (grep ueber
`hybrid_dock_contract.hpp:78-127`) ist NICHT praezise genug fuer eine belastbare 16er-Bestaetigung
-- Audit sollte den exakten Enum-Header lesen statt Zeilenbereichs-Grep.

### III. TDD-Vertrag-Pflichten fuer den KUENFTIGEN Bau (par.3, Designplan)

**P-15 -- T-1 ROT ZUERST.**
WAS: "Der Test ist am ersten Tag rot, ODER sein Biss ist per protokollierter Wegwerf-Mutation
bewiesen." (DESIGNPLAN Z.67)
WIE pruefbar: Rot-Lauf-Log vor der Heilung, Wegwerf-Mutation dokumentiert.
BEHAUPTET: ALS PLAN JA -- Design Abschnitt 5.6(c): "NEGATIV-Proben: Wegwerf-Typ ohne Traits faellt
am Concept ... (T-1: ROT-zuerst per Wegwerf-Mutation im Bau-Protokoll belegen)"; Abschnitt 8
"TUs (je Posten ROT-zuerst)". NICHT ERFUELLBAR VOR Bau (kein Code existiert) -- reiner
Vorgriffs-Plan, korrekt als solcher deklariert.

**P-16 -- T-7 REGISTRIERUNG IST TEIL DES TESTS.**
WAS: "Ein Test existiert erst, wenn er in `ctest -N` erscheint und sein Binary im Bauweg haengt."
(DESIGNPLAN Z.73)
WIE pruefbar: nach Bau `ctest -N | grep test_t13` / `test_t14`.
BEHAUPTET: JA als Plan -- Design Abschnitt 5.6 "PFLICHTEN je neuer TU: T-7-Registrierung
(CMakeLists-ENDE)".

**P-17 -- T-11c MUTATIONS-PROTOKOLL.**
WAS: "der Biss jedes neuen Tests wird per protokollierter Wegwerf-Mutation belegt (Rot gesehen,
dann zurueckgenommen) ... GEZAEHLTE Pflicht je Paket: je neuem Test >=1 Wegwerf-Mutation mit
literalem Rot + Gegenprobe-Gruen." (DESIGNPLAN Z.647-649)
WIE pruefbar: Rot-Logs je neuer TU nach Bau, persistiert.
BEHAUPTET: JA als Plan -- Design Z.204 "T-11c-Mutation (je TU eine dokumentierte Wegwerf-Mutation,
die sie rot macht)".

**P-18 -- T-11b KOMBIBAU-2x2-MATRIX (Landungs-Gate, nicht Einzeltest).**
WAS: "jede Landung ist erst gruen, wenn {clang, gcc} x {Debug, Release} = 4 Zellen je J-1...J-4 +
ctest durchlaufen ... Abnahme-Regel, kein Einzeltest-Posten -- sie gehoert in die Wellen-Abnahme
(§4) jedes Stempel-/Mess-Pakets." (DESIGNPLAN Z.645-646)
WIE pruefbar: nach Bau 4x ctest-Bilanz literal (2 Compiler x 2 Konfigurationen).
BEHAUPTET: JA als Plan -- Design Z.205 "Debug+Release-Lauf, gcc+clang"; Abschnitt 8 "Deckel-3-
Protokoll ... J-1-Werkzeugtreppe -> RE-CONFIGURE -> all -> Facade -> comdare_tests -> ctest
--no-tests=error". Konsistent mit den Auftrags-REGELN (Bau-Treppe) dieses Workflows.

**P-19 -- tests/unit/CMakeLists.txt NUR ANS DATEIENDE.**
WAS: house-weite Betriebsregel (auch in den REGELN dieses Erhebungs-Auftrags explizit
wiederholt); vom Designplan als T-7-Nebenbedingung mitgetragen.
WIE pruefbar: `git diff` nach Bau gegen `tests/unit/CMakeLists.txt` -- Aenderung nur am Dateiende.
BEHAUPTET: JA als Plan -- Design Z.189 "tests/unit/CMakeLists.txt NUR ans DATEIENDE" explizit in
der Abschnittsueberschrift von 5.6 wiederholt.

### IV. Golden-/TABU-Pflichten

**P-20 -- Golden-Neutralitaets-Beweis (5 Belege), NICHT Regen.**
WAS: Design Abschnitt 6, fuenf Beweispflichten: (1) `git diff --stat` enthaelt keinen Pfad unter
organ_axes/ system_axes/ mess_axes/ anatomy/ topics/ heuristik/; (2) Overlay-Hash
(`comdare_overlay_source_hash_gen`) vorher==nachher; (3) `axis_version.lock` byte-identisch; (4)
`golden_fullpilot_320_binary_ids*.txt` byte-identisch, TABU-Gate [6/6] gruen; (5) ctest-Vollzahl
Debug+Release, gcc+clang.
WIE pruefbar: nach Bau die fuenf Kommandos wortgleich ausfuehren, Literale zitieren.
BEHAUPTET: JA als Plan, mit Eskalationspfad (F6-Muster) falls doch eine gehashte Datei getroffen
wird (Design Abschnitt 6, "ESKALATION"). Grundlage: Overlay-Glied [7] hasht EXAKT
`overlay_source_set.hpp`-Menge (von mir verifiziert: Datei existiert am Objekt); die geplanten
Neubauten liegen alle in `include/cache_engine/measurement/`, `hybrid/`, `tests/` -- NICHT in der
gehashten Menge (Design Abschnitt 3, unabhaengig nachvollziehbar).

**P-21 -- TABU-Wahrung WAEHREND dieses Strangs (axes/topics/heuristik/golden/.gitlab-ci.yml).**
WAS: Auftrags-REGELN dieses Workflows ("TABU: nichts unter axes/ topics/ heuristik/;
golden-Dateien byte-stabil; .gitlab-ci.yml nur wenn ... ausdruecklich traegt").
WIE pruefbar: kein Commit/Branch fuer diesen Strang vorhanden (s. P-01) -> TABU trivial gewahrt.
BEHAUPTET: JA -- **von mir VERIFIZIERT**, nicht nur behauptet (kein e11-Branch, keine
uncommitteten Aenderungen im Hauptklon durch diesen Strang zurechenbar).

**P-22 -- Supersede-Praezedenz "KEINE Parallelstruktur" (Architektur-TABU von Task #29).**
WAS: "**Das TABU bleibt sinngemaess gewahrt:** der Traits-Header bindet **bestehende**
Achsen-Typen an die **bestehende** Taxonomie ... er baut keine zweite Fehler-Welt daneben."
(LEDGER Z.23795, SUPERSEDE-VERMERK 02.08., zum urspruenglichen 17.07.-TABU "KEINE
Parallelstruktur -- an vorhandene Traeger andocken, nicht daneben").
WIE pruefbar: Architektur-Review der zwei NEUEN Header (`axis_error_traits_registry.hpp`,
`axis_error_traits_sub.hpp`) gegen dieses Praezedenz-Muster (bereits 2x geuebt:
`axis_error_traits.hpp` fuer FK-3, `axis_error_traits_organ.hpp` fuer FK-4).
BEHAUPTET: IMPLIZIT JA -- Design Abschnitt 5.3 argumentiert per Praezedenz ("Praezedenz: FK-4 hat
axis_error_traits_organ.hpp als eigene Ebenen-Datei"), zitiert aber NICHT den Ledger-Supersede-
Vermerk selbst und stellt die TABU-Frage nicht explizit fuer die JETZT VIER (statt zwei)
externen Header. Kein Fehlbefund, aber unbelegte Voraussetzung -- s. SPANNUNGEN #5.

**P-23 -- Disjunktheit gegen laufende/kommende Straenge.**
WAS: Design Abschnitt 10: beruehrte Flaechen `include/cache_engine/measurement/` (3 Dateien),
`hybrid/hybrid_dock_contract.hpp`, `tests/unit/` (2 neue TUs); KEINE Ueberschneidung mit
`drift_detector.hpp` (C-08/C-09), `mess/steuer_dock` (C-7/B-14), XSD/Schema (s13), YAML-Zug,
#106-Raenge, S-13-Ketten; `axis_variant_version_table.hpp` NUR GELESEN.
WIE pruefbar: Pfad-Liste gegen die STATUS-TAFEL der Parallelstraenge (STAFFEL2 Z.17-27) halten.
BEHAUPTET: JA -- explizit ausgewiesen und (soweit mir aus der STAFFEL2-Tafel ersichtlich) mit den
dort gefuehrten Straengen ueberschneidungsfrei.

### V. Cross-Check gegen den Findings-Bestand

**P-24 -- Deckung mit F-116/F-117/F-118 (STAFFEL2-SYNTHESE).**
WAS: F-116 (Plan-Nenner falsch, 126 statt 121, 0/18-Luecke, T-13-Handliste, CompoundSystemAxis 0
Traits) = "DOKUMENTIERT + DESIGN liegt (P1-P5)"; F-117 (L8, 16 Statuscodes ohne Bindung) = "OFFEN
-- DESIGN P5"; F-118 (golden-Scope NULL gehashte Dateien) = "DOKUMENTIERT (entschaerft den
golden-Ereignis-Charakter)". (STAFFEL2-SYNTHESE Z.206-208)
WIE pruefbar: 1:1-Abgleich der drei Funde gegen Design-Abschnitte 1-3 (bereits oben P-07..P-14
einzeln geprueft).
BEHAUPTET: JA, deckungsgleich -- die STAFFEL2-SYNTHESE fasst denselben Design-Stand zusammen, den
ich unabhaengig aus Design+Ergebnis erhoben habe; keine dritte, unabhaengige Quelle fuer die
126-Zahl gefunden (s. SPANNUNGEN #4).

**P-25 -- OG-54 korrekt als Owner-Frage AUSSERHALB des Bau-Umfangs gefuehrt.**
WAS: "O-E OG-54: Q10.3 Hybrid-Kennzeichen im System-Stempel-Array -- Vorlage-Zeile (e11-Design,
nicht gebaut)." (STAFFEL2-SYNTHESE Z.251, konsistent mit AUFTRAG Z.654 "OG-54 E-11 Q10.3 eigenes
Hybrid-Kennzeichen im System-Stempel-Array?")
WIE pruefbar: Design Abschnitt 9, erster Punkt.
BEHAUPTET: JA -- korrekt als Owner-Frage/Vorlage-Zeile deklariert, kein Bau-Posten.

### VI. Betriebsregeln dieses Erhebungs-Workflows (Selbstpruefung)

**P-26 -- ASCII-only in neuen Zeilen.**
WAS: Auftrags-REGELN. WIE pruefbar: n/a fuer diesen Strang -- keine Datei wurde von ihm angelegt
(Design/Ergebnis-Dateien selbst enthalten deutsche Umlaute/Anfuehrungszeichen, sind aber
Markdown-Berichte, keine "neuen Zeilen" im Quellcode-Sinn dieser Regel). BEHAUPTET: n/a; gilt erst
scharf fuer den kuenftigen Bau-Zug (neue .hpp/.cpp-Zeilen).

**P-27 -- Nur-Lesen-Pflicht am ce/super/prt-art-Hauptklon eingehalten.**
WAS: Auftrags-REGELN ("Der ce-/super-HAUPTKLON traegt parallele Lande-Arbeit -- dort NUR LESEN").
WIE pruefbar: keine Schreiboperation von mir im Hauptklon ausgefuehrt (nur `git show`, `git log`,
`git branch -a`, `git ls-tree`, `git merge-base`, `grep`, `Read`).
BEHAUPTET: JA -- von mir selbst eingehalten waehrend dieser Erhebung.

---

## ABNAHME-FORMELN (woertlich)

1. **AUFTRAG (W2-ABFOLGE-DESIGN.md Z.484):** "ABNAHME: Abdeckung >0/18 und >0/121 gemessen."
2. **WELLENPLAN (Z.2481-2482), Stand-Referenz:** "C-12 Fehlerklassen PFLICHT fuer alle
   Achsen->Unterachsen->Algorithmen; Stand 0/18 bzw. 0/121 (Owner 17.07., Z14455) -> T-13/T-14
   vor W3." (Ledger-Zeilenanker Z14455 ist eine damalige Momentaufnahme -- Ledger-Zeilennummern
   driften mit jedem Nachtrag, s. Memory-Doktrin "Ledger-Zeilennummern... verschieben sich"; NICHT
   identisch mit den von mir aktuell verifizierten Zeilen 16969/22192.)
3. **Owner-Substanz-Kriterium (LEDGER Z.22192):** "Fehlerklassen und Behandlung sind für **alle
   Achsen → Unterachsen → Algorithmen** Pflicht." Operationalisiert in drei Klassen: (a)
   Hardware-/Erweiterungs-Fehlen, (b) Compile-Fehler einer Achsen-Kombination, (c)
   Runtime-Algo-Fehler -- "je Achsen-Permutation die passende erkennen/loggen, statt hart
   abzubrechen."
4. **Design-Reformulierung (Abschnitt 7, die vom Strang vorgeschlagene BAU-Abnahme):**
   - "Unterachsen: `[T-14] unterachsen_gebunden = 18 / 18` (bzw. 19/19 nach Nenner-Messung) --
     vorher 0. Erfuellt '>0/18'."
   - "Algorithmen: `[T-14] eigene_saetze = 1 / 126` UND `[T-14] wirksamer_fehlerraum = 126 / 126`
     (+ Registry-Nenner-Zeile `126 >= 121`). Erfuellt '>0/121' mit dokumentierter
     Nenner-Korrektur."
   - "T-13: `[T-13] familien_gebunden = 21 / 21 (Walk)` + CompoundSystemAxis-OK-Zeile."
   - "L8: Totalitaets-Assert Status->Etikett 16/16 + eine gerenderte Beispiel-Meldung literal im
     Testlog (`fehlerklasse=konfiguration_unvollstaendig hybrid_status=11`)."
5. **Golden-Neutralitaets-Abnahme (Design Abschnitt 6, 5 Punkte):** `git diff --stat` ohne
   gehashten Pfad + Overlay-Hash vorher==nachher + `axis_version.lock` byte-identisch +
   `golden_fullpilot_320*` byte-identisch + ctest-Vollzahl Debug+Release gcc+clang.
6. **Explore/Design-Abnahme DIESES Strangs (nicht des Baus):** implizit aus LEAD-ENTSCHEIDE Z.51
   "golden-Zug E-11 (**Design liegt dann**)" -- die einzige harte Abnahme fuer DIESEN Strang ist
   das VORLIEGEN eines baureifen Designs als Vorlage fuer Staffel 3, nicht die Zahlen selbst.

**Spannung zwischen (1)/(2) und (4):** die AUFTRAGS-woertliche Formel nennt feste Nenner (18,
121); die vorgeschlagene BAU-Abnahme (4) ersetzt "121" faktisch durch einen gemessenen,
gleitenden Nenner (126, mit `>=121`-Wache). Beides ist nicht identisch formuliert -- s.
SPANNUNGEN #4.

---

## NICHT-GEFORDERT (ausdruecklich ausserhalb dieses Strangs)

- **Der eigentliche Bau von P1-P5** (Code-Umsetzung, Registrierung der 2 neuen Test-TUs,
  Kombibau, ctest-Lauf): explizit Staffel-3-Folgezug "golden-Zug E-11" (LEAD-ENTSCHEIDE Z.26-27 +
  Z.51; STAFFEL2-SYNTHESE Abschnitt 5.2). Ein Audit darf hier KEINEN Code/Test/ctest-Beleg
  erwarten -- dessen Fehlen ist kein Defekt dieses Strangs.
- **OG-54 / Q10.3** (eigenes Hybrid-Kennzeichen im System-Stempel-Array): Owner-Frage,
  Vorlage-Zeile im Vorlagen-Fenster, ausdruecklich kein Bau (Design Abschnitt 9, erster Punkt;
  AUFTRAG Z.654).
- **PRODUCER-Verdrahtung `BetriebssystemFeatureFehlt`** (Laufzeit-Detektion der OS-Sub-Achsen,
  Gesperrt-Producer/cpuid-Gate): C-3a-gebunden (Vorab-GO Ledger 69.9, Gate C-3b+O-4); nur die
  DEKLARATION (P3) kommt, die Detektions-Naht bleibt Schnittstelle ohne Implementierung (Design
  Abschnitt 9).
- **Flaechige FLOOR-Aenderungen der 18 Organ-Basen** (z.B. `quelle_nicht_verfuegbar` flaechig
  statt gezielt): durch die FK-6-Messbegruendung ausdruecklich verworfen (Design Abschnitt 9).
- **Blatt->Familien-Aufloesung per mp11-Typliste im FK-3-Header**: bleibt bewusste Luecke
  (Hermetik-Wahrung), P3 loest den Bedarf blatt-exakt OHNE mp11 (Design Abschnitt 9).
- **Flaechige 126 `error_classes()`-Abschriften** an allen Organ-Varianten: verworfen
  (FK-6-Doktrin, gemessene Begruendung, Design Abschnitt 9).
- **.gitlab-ci.yml aller Repos, axes/topics/heuristik-Beruehrung, golden-/TABU-Dateien**: TABU in
  diesem Schnitt (Design Abschnitt 9, letzter Punkt); Ledger-Eintrag schreibt NUR der Lead.
- **Die E1-E11-Arena-Kapazitaets-Kette** (WELLENPLAN §19.5, `E11 = Arena-Kapazitaet 6GB`,
  Designplan T-12c): NAMENS-AEHNLICH, INHALTLICH VOLLSTAENDIG FREMD -- kein Teil dieses Auftrags
  (s. SPANNUNGEN #1). Ein Fund zu Arena-Kapazitaet/6GB/checkpoint_measure C-1..C-17 gehoert NICHT
  in dieses Audit-Paket.
- **Der andere "C-12"** (K3:TeilB/X-8+TeilG, "V-08R BAU+VERIFY ABSCHLIESSEN" + v08r-L3-Auflage,
  bereits laut LEAD-ENTSCHEIDE Punkt 13/16 GEDECKT): NAMENS-GLEICH, INHALTLICH FREMD (s.
  SPANNUNGEN #2). "C-12 GEDECKT" darf NICHT als Beleg fuer den Abschluss von E-11 gelesen werden.
- **Ledger-Buchung/KON-Eintrag zu diesem Strang**: Lead-only (Auftrags-REGELN dieses Workflows);
  dieser Strang liefert nur Entwuerfe/Rohdaten, keine Ledger-Schreibung.

---

## SPANNUNGEN (Widersprueche/Unklarheiten zwischen den Quellen -- nicht glattgezogen)

**#1 -- Dreifache "E-11"/"E11"-Kollision im Corpus.**
(A) unser Auftrag = WELLENPLAN §19.3/C-12, "E-11 C-12 FEHLERKLASSEN-PFLICHT" (AUFTRAG Z.482).
(B) WELLENPLAN §19.5 "FJ-1..FJ-10 + E1-E11" (S-13-Buendel #18): "**E11 = Arena-Kapazitaet** (6 GB
FEST/STATISCH, Planer-Reservierung..., KON93-C6)" (WELLENPLAN Z.2571-2572), auch verankert in
DESIGNPLAN T-12c ("ARENA-KAPAZITAETS-TESTS (E11)", Z.676) und Ledger KON92/94 -- eine
Speicherkapazitaets-Frage, KEINE Fehlerklassen-Frage. (C) AUFTRAG Z.654 "OG-54 E-11 Q10.3" --
dieser DRITTE Treffer ist tatsaechlich VERWANDT (Hybrid-Nachbarschaft zu unserem Task, korrekt in
Design Abschnitt 9 als Owner-Frage exkludiert), teilt also zu Recht das Praefix. (B) dagegen teilt
NUR die Nummer, nicht den Gegenstand. Ein Volltext-Grep nach "E11"/"E-11" ueber den Korpus liefert
OHNE Quellenangabe (§19.3 vs §19.5) ein Phantom-Risiko in beide Richtungen.

**#2 -- Zweifache "C-12"-Kollision, SELBES Dokument (W2-ABFOLGE-DESIGN.md).**
Z.482 "E-11 C-12 FEHLERKLASSEN-PFLICHT" (Quelle **K2**:§19.3) vs. Z.247 "C-12 X-8/#95 V-08R
BAU+VERIFY ABSCHLIESSEN" + v08r-L3-Auflage (Quelle **K3**:TeilB/X-8+TeilG, ABNAHME "4-Zellen-Bilanz
am massgeblichen Tip"). LEAD-ENTSCHEIDE Punkt 13 ("C-12/v08r-L3-Auflage (K3 Teil G): ...
wahrscheinlich ... GEDECKT") und Punkt 16 ("C-12 GEDECKT (v08r-L3-Auflage durch L3-Merge 4cc3aa0f
erfuellt, A-11-Sicherung NICHT noetig)") beziehen sich **nachweislich auf die K3-C-12 (V-08R)**,
nicht auf die K2-C-12 (Fehlerklassen) unseres Strangs. Unsere K2-C-12 bleibt nach allen gelesenen
Quellen WEITER OFFEN (Design liegt, Bau steht in Staffel 3 aus). **Risiko fuer das Audit:** ein
unkritischer Verweis "C-12 GEDECKT (LEAD-ENTSCHEIDE)" wuerde E-11 faelschlich als erledigt
ausweisen.

**#3 -- Designplan-tdd traegt KEINEN eigenen T-13/T-14-Katalogposten.**
Volltext-Grep ueber die gesamte DESIGNPLAN-Datei nach "T-13"|"T-14"|"FK-"|"fehlerklasse"|"C-12"
liefert 0 Treffer -- anders als T-11a-c/T-12a-e (Warmup, Kombibau-Matrix, Mutationsprotokoll,
Drift-Gate-Debug, Legacy-Warmup, **Arena=T-12c**, Full-Join=T-12d, S-3-Kombibau=T-12e), die je
einen benannten Abschnitt mit GEZAEHLTEN Pflichten tragen. Die "T-13"/"T-14" der WELLENPLAN-/
AUFTRAG-Quellen sind **Board-Task-Nummern** (##40-Restbau-Register, Nachbarn von T-NEU-x/T-UPD-x),
NICHT Designplan-TDD-Kennungen -- Namensraum-Ueberschneidung im Praefix "T-" trotz getrennter
Zaehlung. Das Design selbst leitet die Pflichten korrekt aus dem ALLGEMEINEN T-1..T-9-Vertrag +
T-11b/T-11c ab (Abschnitt 5.6) statt aus einem nicht existenten Designplan-Absatz "T-13/T-14" --
in der Sache richtig, aber ein Audit, das einen dedizierten Designplan-Abschnitt "T-13/T-14"
SUCHT, findet keinen und darf das NICHT als Design-Luecke werten.

**#4 -- Nenner-Korrektur (126) ist NICHT in den Plan-Quellen verankert, nur im Strang selbst.**
Grep nach "126" liefert in WELLENPLAN und AUFTRAG (W2-ABFOLGE-DESIGN.md) **0 echte Treffer**
(nur zufaellige Substring-Matches wie Zeilennummern). Die Korrektur "121 -> 126, gemessen 09.08."
steht AUSSCHLIESSLICH im Design/Ergebnis dieses Strangs selbst und sekundaer in
STAFFEL2-SYNTHESE F-116 (dieselbe Quelle zitierend, keine unabhaengige Zweitmessung). Das ist
methodisch durch die Nenner-fremd-Doktrin (T-3, V0-Bauauflage) gedeckt, bedeutet aber: die
woertliche AUFTRAGS-Abnahme-Formel ">0/121 gemessen" ist NICHT wortgleich mit der spaeter zu
pruefenden Formel (">=121, real 126, gedruckt"). Ein Audit, das strikt woertlich gegen "0/121"
prueft, muss diese Umdeutung explizit mitfuehren -- sie steht nicht in der Auftragsquelle selbst.

**#5 -- Supersede-TABU "keine Parallelstruktur" nicht explizit auf 4 (statt 2) externe Header
neu geprueft.** LEDGER Z.23795 (SUPERSEDE-VERMERK 02.08.) rechtfertigt die Abweichung vom
17.07.-TABU "KEINE Parallelstruktur -- an vorhandene Traeger andocken, nicht daneben" fuer GENAU
EINEN externen Bindungs-Header (`axis_error_traits.hpp`) + dessen FK-4-Geschwister
(`axis_error_traits_organ.hpp`). Das Design plant ZWEI WEITERE externe Header
(`axis_error_traits_registry.hpp`, `axis_error_traits_sub.hpp`) per Praezedenz-Analogie
("FK-4 hat schon eine eigene Ebenen-Datei", Design Abschnitt 5.3), zitiert aber nicht den
Ledger-Supersede-Vermerk selbst und stellt die TABU-Frage nicht erneut fuer die jetzt VIER
Header. Keine Owner-Verletzung erkennbar, aber eine unbelegte Voraussetzung, die das Audit
pruefen sollte, statt sie zu uebernehmen.

**#6 -- HEAD-Drift seit der Design-Erhebung waechst mit jedem Tag, OHNE bislang die IST-Karte
inhaltlich zu treffen.** Design-/Explore-Basis: ce `66de5c09`(20.08.)/`65c51eeb`(21.08., additiv
nur B02 `genus_leistungs_version`). AKTUELLER `origin/development`-HEAD (von mir soeben
verifiziert): `3841d717` (23.08. 13:50) -- bereits die DRITTE, weiter fortgeschrittene Messung
dieser Drift innerhalb von drei Tagen (Audit-Runde-1 mass `ed9f1a3c` am 22.08., eine Vorfassung
dieser Karte mass `b247a339` am 23.08. morgens). **Gegenprobe (neu in dieser Fassung):**
`git diff --stat 66de5c09..3841d717` ueber genau die 9 vom Design gelesenen/geplanten
Bestandsdateien ist LEER -- die 5 dazwischenliegenden Commits (W2-Lande-Zuege anderer Straenge:
vollzug91, pmcpaket, w1-luecken) treffen KEINE der E-11-Touchpoints; `n == 20u` und die fehlende
`CompoundSystemAxis`-Spezialisierung sind am heutigen HEAD erneut bestaetigt (s. Objekt-
Gegenprobe oben). Die Drift ist also real und WAECHST TAEGLICH (das Audit muss sie bei jeder
neuen Pruefung neu messen, nicht die hier zitierten SHAs fortschreiben), hat aber bislang KEINE
der zitierten IST-Tatsachen veraendert. Das Design fordert deshalb zu Recht "V0-Gegenlese der
Ist-Karte am dann gueltigen HEAD" als ERSTEN Bau-Schritt (Design Abschnitt 8, Ergebnis Z.130) --
das ist ein PROZESS-Gate (immer neu am Bau-Tag auszufuehren), kein einmalig abhakbarer Befund.

**#7 -- GOAL v8 traegt ein gleichnamiges, aber fremdes "Fehlerklasse"-Kapitel.**
"TEIL IV -- DIE FEHLERKLASSE, DIE KEIN SIGNAL ERZEUGT" (GOAL-v8 Z.353ff) ist eine
METHODOLOGISCHE Selbstkritik-Kategorie (eigene Arbeitsfehler-Muster, Beispiel "ein richtiges
Messgeraet am falschen Gegenstand"), OHNE inhaltlichen Bezug zur Achsen-Fehlerklassen-Taxonomie
(C-12/E-11). Verwechslungsrisiko bei blossem Volltext-Grep ueber GOAL v8 nach "Fehlerklasse".

**#8 -- GOAL v8 traegt keine als Liste erkennbare "V-1..V-14"-Doktrinenreihe; die relevanten
V-Doktrinen (z.B. V-8) stehen im WELLENPLAN, nicht im genannten GOAL-Dossier.**
Grep auf "V-[0-9]+" in GOAL v8 liefert nur einen Sammelverweis "V-1...V-7" (Z.141, Testseiten-
Ergaenzung); "Hart-Gruen"/"hart-gruen" liefert 0 Treffer in GOAL v8. Die fuer diesen Strang
inhaltlich einschlaegige Doktrin V-8 ("GEGENSTAND STATT ANKUENDIGUNG") steht tatsaechlich im
WELLENPLAN (Z.960), nicht im GOAL-v8-Dossier, dem der Task-Steckbrief sie zuordnet. Der Doktrin-
INHALT bindet den Strang trotzdem (das gesamte IST-Karte-Vorgehen ist objektgepruefte Praxis) --
nur die Quellenzuordnung im Auftrag war ungenau; das Audit sollte bei GOAL-v8-Zitaten zu "V-x"
Vorsicht walten lassen und im Zweifel im Wellenplan nachschlagen. GOAL v8 selbst traegt dagegen
sehr wohl generische, den Strang bindende Doktrinen unter EIGENEM Namen -- II.5 "Der Nenner: nie
eine nackte Zahl" (Z.288-293, deckt P-08/P-09), II.6 "K13 -- Der Koeder muss erst beissen"
(Z.295-303, bindet die kuenftigen T-11c-Mutationen), II.7 "Fail-closed" (Z.305-308, deckt L8/P5:
ein hybrid_status ohne Etikett darf nie still durchlaufen) und TEIL III "Die fuenf Pruffragen"
(Z.322-350, u.a. "Nenner in der AUSGABE", "Zeitrichtung", "Deckung: was erzwingt das Halten
morgen?") -- diese sind die inhaltlich korrekten GOAL-v8-Anker fuer diesen Strang, nicht ein
literales "V-1..V-14"-Register.

**#9 -- Audit-Runde 1 (22.08.) hat bereits 4 dokumentarische KLEIN-Funde an der DESIGN-Datei
selbst identifiziert; keiner ist bislang behoben (Design-Datei-mtime unveraendert seit 21.08.
17:59, von mir gegengeprueft).** Das ist keine Spannung zwischen SOLL-Quellen, sondern ein
Spannungs-Hinweis zwischen dem bereits durchlaufenen Audit-Ergebnis und dem heutigen
Objektstand: die vier vorgeschlagenen 1-Zeilen-Praezisierungen (source_catalog.hpp-Ankerzeile,
CompoundSystemAxis-Parameterzahl in der Design-Prosa, Ergebnis-Datei-Testbestand-Halbsatz,
F6-V0-Pruefsatz) stehen weiterhin aus. Da sowohl Audit-Runde 1 als auch dieser Erhebungs-Auftrag
"NUR LESEN, kein Fix" tragen, ist die Behebung NICHT Teil dieses oder des vorherigen Strangs --
sie gehoert in die V0-Gegenlese des kuenftigen golden-Zugs (Design Abschnitt 8) oder in einen
Lead-Doku-Mikro-Edit. Details in Abschnitt VII am Ende dieser Karte.

---

## VII. BEREITS DURCHLAUFENE PRUEFUNG -- AUDIT-RUNDE 1 (22.08.2026, zur Kenntnis fuer diese/naechste Runde)

Damit ein zweiter Audit-Durchgang nicht denselben Boden neu aufreisst: am 22.08.2026 lief bereits
ein vollstaendiger Audit dieses Strangs (`e11/audit-runde-1.md`, 175 Z., Fable-max, gegen eine
Vorfassung dieser Soll-Karte mit 20 statt 27 P-Punkten) mit **VERDIKT SITZT** (0 ERNST, 0 MILD, 4
KLEIN). Alle 20 damaligen Pruefpunkte wurden ERFUELLT gewertet (inkl. P-13 korrekt als N/A fuer
T-12a-e); die Abnahme-Formeln wurden als vollstaendig operationalisiert bestaetigt. Die vier
KLEIN-Funde, ALLE an der DESIGN-Datei selbst (nicht an dieser Karte, nicht am Bau -- es gibt
keinen Bau) und laut eigener Gegenpruefung dieser Fassung **weiterhin unbehoben**:

- **E11-A1**: Design Abschnitt 6 nennt den Eskalations-Anker `kNewGolden131072Crc64` als
  `source_catalog.hpp:191`; real steht die Definition bei `source_catalog.hpp:204`
  (`profile_facade/source_catalog.hpp`). Bereits am Erhebungsstand falsch (kein Drift-Artefakt).
  Wirkt sich nur auf die (heute nicht geplante) F6-Eskalations-Sektion aus.
- **E11-A2**: Design/Ergebnis zitieren `docs/plaene/20260819-F6-TERMINIERUNG-golden-ereignis-
  ein-zug-vor-f2.md` als Quelle der F6-Eskalationsprozedur; diese Datei existiert im
  super-Hauptklon NICHT (nur in einem ungelandeten Bruch-Worktree-Commit `6fe69057`, kein
  gueltiges Git-Objekt im Hauptklon). Kein Fehler des e11-Strangs selbst (die Quelle war zum
  Erhebungszeitpunkt als committet gemeldet); offener Rest eines FREMDEN Traegers (#113/g6-
  Quittung). Das Design ist inhaltlich autark, da es die F6-Prozedur wortgleich abschreibt.
- **E11-A3**: Die Ergebnis-Datei fuehrt nach ihrer eigenen "WIEDERANLAUF-KORREKTUR" 8 Test-TUs,
  waehrend der massgebliche Design-"Test-Bestand (vollstaendig)" (Design Z.32-35) 10 nennt (fehlen
  in der Ergebnis-Inventur: `test_a15_fk4_organ_slot_traits.cpp`,
  `test_hy_a3_hybrid_config_parser.cpp` -- beide existieren am Objekt). Reine
  Berichts-Inkonsistenz zwischen Ergebnis-Inventur und Design-Bestand, kein Bau-Einfluss.
- **E11-A4**: Design 5.1 schreibt die Spezialisierung als
  `AxisErrorTraits<CompoundSystemAxis<IsaK, OsA, ExtU>>` (3 Parameter); das Objekt
  (`ceb_complex_system_axis.hpp:76-78`) traegt tatsaechlich VIER Template-Parameter
  (`TargetIsaComplex, OperatingSystem, ExternalUtils, SubAxes`). Deckt sich mit P-10 dieser Karte
  (dort unabhaengig erhoben). Risiko: eine woertlich uebernommene 3-Parameter-Teilspezialisierung
  waere ein STILLER Non-Match gegen die 4-Parameter-Primaervorlage (Spezialisierung greift nie,
  kein Compile-Fehler) -- die neue T-13-TU wuerde das zwar am Ende fangen (rot), aber die Prosa
  sollte es nicht erst dem Test ueberlassen.

**Einordnung fuer diese Runde:** keiner der vier Funde blockiert die (bereits erfolgte) Landung
des design-only-Strangs; alle vier sind V0-Gegenlese-Material fuer den kuenftigen golden-Zug
(E11-A1/A3/A4 sind 1-Zeilen-Praezisierungen der Design-/Ergebnis-Datei, E11-A4 zusaetzlich in der
neuen T-13-TU selbst zu heilen; E11-A2 ist ein Lead-Traeger ausserhalb dieses Strangs). Eine
zweite Audit-Runde sollte pruefen, OB diese vier Doku-Praezisierungen inzwischen nachgezogen
wurden (Stand dieser Karte: NEIN, Design-Datei-mtime unveraendert seit 21.08. 17:59) -- nicht,
ob sie NEU existieren; sie sind bereits vollstaendig beschrieben und tragen einen fix_weg.
