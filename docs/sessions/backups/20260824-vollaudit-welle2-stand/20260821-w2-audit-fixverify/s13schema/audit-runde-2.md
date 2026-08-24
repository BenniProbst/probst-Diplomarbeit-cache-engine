# AUDIT RUNDE 2 (RE-VERIFY nach Fix-Stufe R1) -- Strang s13schema

Re-Verifier: Fable-max, 22.08.2026. Objekt: ce `bau/s13schema` @ **c76d3116**4d7ffd5ffbb9f776e6839e7fc08114c7
(neuer Tip laut Fix-Bericht, 1 Commit auf ad5c6d66; Worktree /home/comdare/wt-ce-s13schema,
HEAD selbst gemessen, porcelain 0) + super `bau/s13schema` @ 1e92b77e (UNVERAENDERT,
porcelain 0, selbst gemessen). Origin-Ref selbst gemessen: `git ls-remote origin
refs/heads/bau/s13schema` = c76d31164d7ffd5ffbb9f776e6839e7fc08114c7 (Ref-Sicherung steht).
Eingang voll gelesen: soll-karte.md + audit-runde-1.md + fix-runde-1.md.

VERDIKT: **SITZT** (2/2 Quittungen BEHOBEN mit eigener Messung bestaetigt; 0 neue
Regressionen; Restliste vollstaendig getragen; keine Rest-Funde).

--------------------------------------------------------------------------------

## 1. QUITTUNGS-NACHMESSUNG (je EIGENE Messung, nicht abgeschrieben)

### S13A-F1 (ERNST, "8 Nicht-ASCII-Zusatzzeilen") => BEHOBEN **BESTAETIGT**

**(a) Kern-Messung Wache (selbst gefahren, wt-ce-s13schema @ c76d3116):**
`sh scripts/ci_diff_ascii_width_guard.sh "66de5c09..HEAD"` -> literal
"1095 Zusatzzeilen in selbst verfasstem Code geprueft, davon **0 Nicht-ASCII**,
davon 0 ueber 120 Spalten" + "**DIFF-HYGIENE-WACHE: GRUEN.**", GUARD_RC=0.
(Vorher-Zustand 8 Nicht-ASCII als echtes Rot im persistierten Log
`fixR1-rotbeweis-ascii-wache-vor-fix.log` gegengelesen: "davon 8 Nicht-ASCII" +
"DIFF-HYGIENE-WACHE: ROT." literal vorhanden.)

**(b) Fix-Diff voll gelesen (git show c76d3116):** exakt 2 Dateien, 12+/8-,
deckt alle 8 Audit-Zeilen: exp:255/:263 U+2500->`--` · exp:570 U+00D7->`x` ·
prof:1549 U+2014->`--` · exp:272+prof:799 FEHLER-Ausgabe U+2192->ASCII `->` ·
exp+prof fertig-Zeilen Roh-Pfeil->`→`-Escape + je 2 ASCII-Begruendungs-
Kommentarzeilen (die +4 des neuen Nenners 1095). Commit-Trailer
"Co-Authored-By: Claude Fable 5 <noreply@anthropic.com>" vorhanden.

**(c) Quelltext-Byte-Probe (selbst, xxd):** exp:565 traegt `→` als sechs
pure ASCII-Bytes (`5c 75 32 31 39 32`); prof-fertig-Zeile ebenso (grep `u2192`).

**(d) PARSE-ANKER-Erhalt dreifach selbst bewiesen:**
1. EIGENE Wegwerf-Compile-Probe (nicht die des Fixers; /tmp, danach entfernt):
   Literal `" → "` per `grep -o` DIREKT aus der gefixten profile_run_entry.hpp
   gespleisst, static_assert byte-weise gegen {0x20,0xE2,0x86,0x92,0x20,0} +
   Negativkontrolle sizeof(" -> ")!=sizeof(probe) -> **g++ -std=c++23 RC=0 UND
   clang++ -std=c++23 RC=0**, Laufzeit-Hexdump beider Binaries literal
   `20 E2 86 92 20 00`.
2. Artefakt-Probe am stehenden Fixer-Baum (LC_ALL=C grep -a -c auf die
   Byte-Folge 20 E2 86 92 20): libcomdare_profile_run_facade.a = **2**
   Treffer-Zeilen, test_s13_02-Binary = **1**; `strings`-Probe
   "RUN_PROFILE fertig:" = 1 im Testbinary.
3. Anker-Logik der super-Wache selbst gelesen (wt-super-s13schema
   ci/lauf_marker.sh): :204-205 ankern per `index()` NUR "RUN_PROFILE fertig:" /
   "RUN_EXPERIMENT fertig:", trenner = pfeil (:117 `PFEIL_UTF8=$(printf
   '\342\206\222')` mit Kommentar :116 "ein literales Zeichen waere ein
   ASCII-Verstoss" -- die Escape-Loesung folgt exakt dem Projektmuster der Wache
   selbst). Die beiden FEHLER-Zeilen sind NICHT vertragstragend -> ASCII `->`
   dort korrekt.

**(e) Format-Stabilitaet (selbst):** `~/.local/bin/clang-format-22 --dry-run
-Werror` ueber beide gefixte Dateien -> **RC=0**.

**(f) Datei-Bestand (Aufklaerung, selbst gemessen):** Nicht-ASCII-ZEILEN je Datei
Basis 66de5c09 -> Tip c76d3116: exp 103->99, prof 112->108 -- BEIDE Dateien
tragen am Tip WENIGER Nicht-ASCII-Bestand als an der Basis (der s13-Umbau
entfernte je 4 alte Zeilen, der Fix liess 0 neue zurueck). Kein Widerspruch zur
Wache. Randnotiz ohne Objekt-Wirkung: audit-runde-1.md schrieb die
Bestandszahlen als "112/103" in der Reihenfolge exp/prof -- die Zuordnung ist
vertauscht (exp=103, prof=112); die 8 Zusatzzeilen selbst waren korrekt
identifiziert, Fix und Wache-Messung sind davon unberuehrt. KEIN Fund.

### S13A-F2 (KLEIN, "Interpretations-Vermerk fehlt") => BEHOBEN **BESTAETIGT**

Selbst gelesen: /home/comdare/backups-workflow/20260820-w2-sofortstaffel/
s13-schema-kette-ergebnis.md:160ff traegt den ADDITIVEN, als solchen markierten
Block "NACHTRAG (Fix-Stufe R1, Fund S13A-F2)" mit allen im Fix-Weg geforderten
Elementen: Design-INTERPRETATION von KON32-01 · Betriebszustand/kein
Auswerte-Format · Owner-Wortlaut "ES WIRD NUR PER-BINARY-XLSX GEBEN" · OFFENE
Owner-Feinabstimmung · W3-Nachfolgeposten-Verweis 20260817-DESIGN-s13-buendel-
di25.md Z.481-483 · "nicht als glatt erledigt fuehren". Grenze eingehalten:
Ledger/Board/Memory NICHT geschrieben (Eintrag = Lead beim KON120-Zug).

## 2. VERTAGT-QUITTUNGEN

Die Fix-Runde traegt **0 VERTAGT** (2/2 BEHOBEN). Die "GETRAGENEN GRENZEN" der
Fix-Runde haben saemtlich benannte Traeger (Nachpruefung gegen Audit R1 Abschn. 4
und Soll-Karte): T-11b-4-Zellen/T-8/H-6-Vollzug/H-9/Floor -> **Lande-Zug**
(STAFFEL2 Phase 1 Schritt 3 / Phase 2 Schritt 11 / Phase 4) · reale
CI-Wachen-Ausfuehrung -> **Lande-Push** · F-25 per_binary_mappe-Vollkette ->
**Mess-Fenster Sa/So** · S13-04 Export-Element + X-1..X-5/X-7..X-9 ->
**Staffel 3 / D-1-Di-25-Buendel** (KON32-01-Toleranz (a) bleibt bis dahin formal
in Kraft, Board-#18 pending) · T-9 Codex-Testkritik -> **Folgewelle**.
Kein traegerlos vertagter Posten.

## 3. REGRESSIONS-STICHPROBE (selbst gefahren)

- **ctest-Stichprobe** am stehenden Fixer-Baum (build/gcc-release @ c76d3116,
  kein Neubau -- Baum vom Fixer-Vollbau, HEAD unveraendert): literal
  "**100% tests passed, 0 tests failed out of 6**" -- #511
  test_s13_02_zielfilter_vier_faelle, #512 test_s13_01_csv_kind_projektion,
  #513 test_s13_03_per_binary_mappe, #33 test_rcu, #34 test_rcu_concurrency,
  #429 test_profile_roundtrip, alle Passed. test_rcu isoliert Passed =
  bestaetigt die Fixer-Triage (Last-Flake unter 3 Parallel-Slots, kein
  Objekt-Defekt; Nachbar-Befund-Traeger Lande-Zug/K17 + #103-TSan-Umfeld).
  Byte-Orakel-Test s13_01 gruen => golden-Zeilen unveraendert (P-21 haelt).
- **Voller Nenner** (Fixer-Log gegengelesen, fixR1-ctest-voll-lauf3.log):
  "100% tests passed, 0 tests failed out of 513" literal persistiert; 513 ==
  Konsistenzrechnung Basis 510 + 3 (Audit R1 2(d)).
- **TABU/golden (selbst):** `git diff --name-only 66de5c09..c76d3116` = dieselben
  10 Dateien wie vor dem Fix (keine neue Datei), grep axes/|topics/|heuristik/|
  golden = **0** Treffer.
- **Format:** siehe 1(e), RC=0.
- **Log-Persistenz:** alle 7 fixR1-*.log liegen im Strang-Ordner, Kern-Literale
  (Rot-Beweis, Gruen-Beweis, 513er-Bilanz, Byte-Beweis gcc+clang) je gegengelesen.
- **Facade-Treppen-Befund des Fixers am Objekt verifiziert:** ninja-Targets @
  Tip: `comdare_facade` = **0** Treffer (existiert nicht), 
  `comdare_profile_run_facade` existiert (profile_facade/CMakeLists.txt:82,
  STATIC EXCLUDE_FROM_ALL; Fixer baute es explizit RC=0). Das ist ein Befund an
  der TREPPEN-FORMEL des Auftrags (Rezept kuenftig mit realem Namen), kein
  Objekt-Defekt dieses Strangs; Traeger: Lande-Zug (im Fix-Bericht deklariert).

## 4. RESTLISTE GEGEN DIE SOLL-KARTE (P-01..P-26)

Unveraendert ERFUELLT aus R1 (Fix beruehrte nur Kommentare + 2 String-Literale +
2 fertig-Zeilen der beiden Seam-Dateien; Nicht-Regression durch 3(a)-(d) gedeckt):
P-01..P-05, P-07..P-13, P-17, P-18, P-20 (Bau-Treppe am neuen Tip erneut
RC=0-durchlaufen inkl. J-0b/J-1-Sieben-Werkzeuge/RE-CONFIGURE laut persistiertem
Treppen-Log), P-21, P-24, P-25. **P-19 jetzt VOLL erfuellt** (einziger
Teil-Luecken-Punkt aus R1; Wache GRUEN selbst gemessen, 1(a)). P-06 intakt
(super unveraendert @ 1e92b77e; Kopplung ist branch-bezogen deklariert, der
Fix-Commit liegt auf demselben Branch; Vollzug = Lande-Zug). Wie in R1 korrekt
offen mit Traeger: P-14 (T-8, Lande-Zug), P-15 (T-9, Folgewelle), P-16 (T-11b,
Lande-Zug; diese Runde erneut 1 Zelle gcc-Release voll), P-22 (F-25,
Mess-Fenster), P-23 (S13-04, Staffel 3), P-26 (Toleranz (a) bis S13-04, #18
pending). Keine neue Luecke; Spannungen Nr. 1 (durch F2-Nachtrag jetzt
dokumentiert), Nr. 2-6 unveraendert korrekt gerahmt.

## 5. BEIDE MENGEN (Gate-Ehrlichkeit dieses Re-Verify)

GEPRUEFT (je selbst, literal): HEAD/porcelain/Origin-Ref beider Worktrees ·
Fix-Diff voll · Commit-Text+Trailer · ASCII-Wache am Tip (GRUEN, 1095/0/0) ·
Quelltext-Bytes (xxd) · eigene gcc+clang-Wegwerf-Byte-Probe · Artefakt-Byte-Probe
(2/1 Treffer) · lauf_marker.sh-Ankerlogik · clang-format-22 RC=0 · TABU/golden 0 ·
F2-Nachtrag im Strang-Bericht · ctest-Stichprobe 6/6 · Facade-Target-Namen ·
Kern-Literale aller 7 persistierten Logs · Traeger-Liste der offenen Posten.
NICHT GEPRUEFT (mit Grund): frischer eigener VOLLBAU + 513er-Neulauf (Baum stand
unveraendert vom Fixer-Vollbau am selben HEAD; Bilanz literal persistiert;
K17-Endstand-Kombibau erbringt den naechsten Frisch-Beweis am GEMERGTEN Stand --
Bau-Slot-Deckel geschont) · 4-Zellen-Kombibau/T-8/H-6-Vollzug/reale CI-Wachen
(Lande-Zug, getragen) · super-seitige ctest-Wirkung (xmllint-substanzgedeckt via
R1) · Wegwerf-Mutationen M1-M5 (revertiert; Protokoll + 0-Reste-Gegenprobe aus R1).

## 6. ERGEBNIS

**SITZT.** Beide Funde aus Runde 1 sind am Objekt behoben und eigenstaendig
nachgemessen; der Strang ist LANDEREIF auf neuem Tip ce c76d3116 (origin
gesichert, ci.skip) + super 1e92b77e (H-6-Kopplung unveraendert deklariert).
An den Lande-Zug weitergereicht (bestehende Traeger, keine neuen Funde):
T-11b-4-Zellen am Merge-Endstand · Treppen-Formel-Korrektur comdare_facade ->
comdare_profile_run_facade · test_rcu unter Parallel-Last beobachten ·
kumulatives Diff-Hygiene-Gate gegen origin/main am Lande-Push.

--------------------------------------------------------------------------------

## WIEDERANLAUF-NACHTRAG R2-W (23.08.2026, additiv -- Bericht oben unveraendert)

GRUND: Die Fix-Stufe riss nach ihrer Bericht-Schreibung ab, ohne ihr
Schema-Ergebnis zu uebergeben, und lief am 23.08. als R1-W wieder an (additiver
Nachtrag im fix-runde-1.md, KEIN neuer Commit). Der Orchestrator faehrt die
RE-VERIFY-Stufe danach erneut; diese Inkarnation uebernimmt den R2-Stand oben
(NIE verworfen) und quittiert mit EIGENEN Nachmessungen am unveraenderten Objekt.

STAND-AUFNAHME (selbst gemessen, 23.08.): ce /home/comdare/wt-ce-s13schema
HEAD = c76d31164d7ffd5ffbb9f776e6839e7fc08114c7, porcelain 0; super
/home/comdare/wt-super-s13schema HEAD = 1e92b77e3cbfdee1f8914382765d5fd20067c20a,
porcelain 0. Origin-Refs (ls-remote, je selbst): ce bau/s13schema = c76d3116...,
super bau/s13schema = 1e92b77e... -- Objekt seit R2 oben BYTE-IDENTISCH unbewegt;
einziges Delta ist Berichts-/Beweis-Ebene (R1-W-Nachtrag + fixR1W-Log).

EIGENE NACHMESSUNGEN DIESER INKARNATION (je literal):
1. S13A-F1 ROT-Beweis unabhaengig reproduziert am HISTORISCHEN Bereich:
   `sh scripts/ci_diff_ascii_width_guard.sh "66de5c09..ad5c6d66"` -> exakt die
   8 Audit-Zeilen (exp 255/263/272/563/570, prof 799/1543/1549), Nenner "1091
   Zusatzzeilen ... davon 8 Nicht-ASCII, davon 0 ueber 120 Spalten",
   "DIFF-HYGIENE-WACHE: ROT.", RC=1.
2. S13A-F1 GRUEN-Beweis am Tip: `... "66de5c09..HEAD"` -> "1095 Zusatzzeilen
   in selbst verfasstem Code geprueft, davon 0 Nicht-ASCII, davon 0 ueber 120
   Spalten", "DIFF-HYGIENE-WACHE: GRUEN.", RC=0.
3. Fix-Diff `git show c76d3116` VOLL gelesen: exakt 2 Dateien, alle 8 Stellen
   gedeckt (4 Kommentare U+2500/U+00D7/U+2014 -> ASCII; 2 FEHLER-Ausgaben
   U+2192 -> `->`; 2 fertig-Zeilen Roh-Pfeil -> `→`-Escape + je 2
   ASCII-Begruendungs-Kommentarzeilen = die +4 des Nenners 1095); Trailer
   "Co-Authored-By: Claude Fable 5 <noreply@anthropic.com>" vorhanden.
4. Quelltext-Byte-Probe (xxd, selbst): exp:565 + prof:1545 tragen `" → "`
   als pure ASCII-Bytes `22 20 5c 75 32 31 39 32 20 22`; Begruendungs-Kommentare
   an exp:560/prof:1539 (grep -n u2192 = genau diese 4 Zeilen).
5. PARSE-ANKER-Erhalt, EIGENE Wegwerf-Compile-Probe dieser Inkarnation (/tmp,
   danach entfernt): Literal `" → "` per grep -o DIREKT aus der gefixten
   profile_run_entry.hpp gespleisst, static_assert byteweise gegen
   {0x20,0xE2,0x86,0x92,0x20,0x00} + Negativkontrolle sizeof(" -> ")!=
   sizeof(probe): g++ -std=c++23 RC=0 UND clang++ -std=c++23 RC=0,
   Laufzeit-Hexdump BEIDER Binaries literal `20 E2 86 92 20 00`.
6. Anker-Logik selbst gelesen (wt-super ci/lauf_marker.sh): :117
   `PFEIL_UTF8=$(printf '\342\206\222')` mit Kommentar :116 ("ein literales
   Zeichen waere ein ASCII-Verstoss" -- die Escape-Loesung folgt dem Muster der
   Wache selbst); :204-205 ankern per index() NUR "RUN_PROFILE fertig:" /
   "RUN_EXPERIMENT fertig:" -> die 2 FEHLER-Zeilen sind nicht vertragstragend,
   ASCII `->` dort korrekt.
7. clang-format-22 (~/.local/bin/clang-format-22) --dry-run -Werror ueber beide
   Fix-Dateien: FMT_RC=0.
8. TABU/golden (selbst): `git diff --name-only 66de5c09..c76d3116` = dieselben
   10 Dateien (keine neue Datei), grep axes/|topics/|heuristik/|golden = 0
   Treffer.
9. S13A-F2 selbst gelesen: s13-schema-kette-ergebnis.md traegt "NACHTRAG
   (Fix-Stufe R1, Fund S13A-F2)" ab Z.160 mit ALLEN Fix-Weg-Elementen
   (Design-INTERPRETATION von KON32-01 · Betriebszustand/kein Auswerte-Format ·
   Owner-Wortlaut · OFFENE Owner-Feinabstimmung · W3-Nachfolgeposten-Verweis ·
   "nicht als glatt erledigt fuehren"); Quell-Verweis selbst nachgeschlagen:
   20260817-DESIGN-s13-buendel-di25.md Z.481-483 woertlich "Alternative, bewusst
   NICHT gewaehlt: Stamp/Resume auf die Mappe umstellen ... Als
   W3-Nachfolgeposten vermerkt." Ledger/Board/Memory unberuehrt (super HEAD
   unbewegt, porcelain 0).
10. Kern-Literale ALLER persistierten Logs gegengelesen (grep, je Treffer),
    inkl. des seit R2 oben NEUEN fixR1W-Logs: Lauf3-Log Kopf "Test project
    .../wt-ce-s13schema/build/gcc-release" + "100% tests passed, 0 tests failed
    out of 513" + 29.79 sec · Rot-Log 1091/8 + ROT · Gruen-Log 1095/0 + GRUEN ·
    Treppen-Log Kopf "@ c76d3116" + ALL_RC=0/TESTS_RC=0/CTEST_RC=0 + FACADE_RC=1
    (= dokumentierter Treppen-Formel-Befund, Traeger Lande-Zug) · fixR1W-Log
    ROT_RC=1 + GRUEN_RC=0 mit denselben Nennern (konsistent mit meinen eigenen
    Laeufen 1./2.).

BAU-ENTSCHEID DIESER INKARNATION (beide Mengen): build/gcc-release ist GERAEUMT
(ls: No such file or directory; df 94%, 16G frei > 5G-Gate). KEIN Re-Vollbau
gefahren: der Objektstand ist byte-identisch derselbe HEAD c76d3116, an dem die
volle Treppe + 513/513-Bilanz literal persistiert liegen (Beweisort, Kern-
Literale oben Punkt 10 selbst gegengelesen) und an dem DIESE Stufe (fruehere
Inkarnation, Abschnitt 3 oben) ihre eigene 6/6-ctest-Stichprobe am damals
stehenden Baum bereits erhoben hat; der Fix-Diff beruehrt ausschliesslich
Kommentare + String-Literale (voll gelesen, Punkt 3). Ein Wiederholungsbau
desselben Stands belastete nur den mit dem laufenden Kombibau geteilten
3er-Slot-Deckel (Owner-Aufraeum-Modus 22.08.: sequentiell, keine Tokens
verschwenden; identischer Entscheid wie R1-W am selben Objekt). GEDECKT durch
diese Inkarnation: Wache ROT+GRUEN, Fix-Diff, Bytes/Anker (gcc+clang), Format,
TABU/golden, F2-Text+Quelle, Refs/porcelain, Log-Gegenlesen. NICHT GEDECKT
durch eigenen Frischlauf: ctest-513er-Neulauf am neu gebauten Baum -- Traeger:
K17-Endstand-Kombibau am GEMERGTEN Lande-Stand (von R1, Fix-Stufe und R2 oben
uebereinstimmend deklariert).

VERTAGT-PRUEFUNG UNVERAENDERT: 0 VERTAGT in der Fix-Runde (2/2 BEHOBEN); alle
getragenen Grenzen mit benannten Traegern (Abschnitt 2 oben gilt fort; der
R1-W-Nachtrag fuegt keinen neuen vertagten Posten hinzu, seine LOG-GRENZE ist
ehrlich deklariert und durch die Terminal-Literale des Fix-Berichts gedeckt).

VERDIKT UNVERAENDERT: **SITZT** (2/2 BEHOBEN eigenstaendig bestaetigt, 0 neue
Regressionen, 0 Rest-Funde, Restliste P-01..P-26 unveraendert gueltig --
Objekt seit R2 oben unbewegt).

--------------------------------------------------------------------------------

## WIEDERANLAUF-NACHTRAG R2-W2 (23.08.2026, additiv -- Bericht oben unveraendert)

GRUND: Auch die R2-W-Inkarnation (Nachtrag oben, 23.08. 14:03) hat ihr
Schema-Ergebnis nicht an den Orchestrator uebergeben; die RE-VERIFY-Stufe laeuft
deshalb erneut. Diese Inkarnation uebernimmt den Stand oben (NIE verworfen) und
quittiert mit EIGENEN Nachmessungen am Objekt.

STAND-AUFNAHME (je selbst gemessen, literal): ce /home/comdare/wt-ce-s13schema
HEAD = c76d31164d7ffd5ffbb9f776e6839e7fc08114c7, porcelain 0 Zeilen; super
/home/comdare/wt-super-s13schema HEAD = 1e92b77e3cbfdee1f8914382765d5fd20067c20a,
porcelain 0 Zeilen. Origin-Refs (ls-remote, je selbst): ce bau/s13schema =
c76d3116..., super bau/s13schema = 1e92b77e... -- Objekt seit R2/R2-W
BYTE-IDENTISCH unbewegt. build/ des Fixer-Vollbaus bleibt GERAEUMT (ls: "No such
file or directory"); df / = 24G frei (91%) > 5G-Gate.

EIGENE NACHMESSUNGEN DIESER INKARNATION (je literal, nicht abgeschrieben):
1. S13A-F1 ROT-Repro am HISTORISCHEN Bereich: `sh scripts/
   ci_diff_ascii_width_guard.sh "66de5c09..ad5c6d66"` -> exakt die 8 Audit-Zeilen
   (exp 255/263/272/563/570, prof 799/1543/1549), Nenner "1091 Zusatzzeilen in
   selbst verfasstem Code geprueft, davon 8 Nicht-ASCII, davon 0 ueber 120
   Spalten", "DIFF-HYGIENE-WACHE: ROT.", ROT_RC=1.
2. S13A-F1 GRUEN am Tip: `... "66de5c09..HEAD"` -> "1095 Zusatzzeilen ... davon
   0 Nicht-ASCII, davon 0 ueber 120 Spalten", "DIFF-HYGIENE-WACHE: GRUEN.",
   GRUEN_RC=0.
3. Fix-Diff `git show c76d3116` VOLL gelesen: exakt 2 Dateien, Stat literal
   "2 files changed, 12 insertions(+), 8 deletions(-)"
   (experiment_run_entry.hpp "| 12", profile_run_entry.hpp "| 8"),
   alle 8 Stellen gedeckt (U+2500/U+00D7/U+2014-Kommentare ->
   ASCII; 2 FEHLER-Ausgaben U+2192 -> `->`; 2 fertig-Zeilen Roh-Pfeil ->
   Backslash-u2192-Escape + je 2 ASCII-Begruendungs-Kommentarzeilen = +4 des
   Nenners 1095); NUR Kommentare + String-Literale beruehrt, KEINE
   Kontrollfluss-/Logik-Zeile; Trailer "Co-Authored-By: Claude Fable 5
   <noreply@anthropic.com>" vorhanden.
4. Quelltext-Byte-Probe (xxd, selbst): exp:565 + prof:1545 tragen `" → "`
   als pure ASCII-Bytes `22 20 5c 75 32 31 39 32 20 22`; grep -n u2192 = genau
   4 Zeilen (2 Code + 2 Begruendungs-Kommentare exp:560/prof:1539).
5. PARSE-ANKER-Erhalt, EIGENE Wegwerf-Compile-Probe (/tmp, danach entfernt;
   Literal per grep -o DIREKT aus der gefixten profile_run_entry.hpp
   gespleisst): static_assert byteweise gegen {0x20,0xE2,0x86,0x92,0x20,0x00} +
   Negativkontrolle sizeof(" -> ")!=sizeof(probe) -> g++ -std=c++23 RC=0 UND
   clang++ -std=c++23 RC=0; Laufzeit-Hexdump BEIDER Binaries literal
   `20 E2 86 92 20 00`, memcmp-RC je 0.
6. Anker-Logik selbst gelesen (wt-super ci/lauf_marker.sh): :116-117
   PFEIL_UTF8=$(printf '\342\206\222') mit Kommentar "ein literales Zeichen
   waere ein ASCII-Verstoss" (Escape = Projektmuster der Wache selbst);
   Anker per index() NUR "RUN_PROFILE fertig:" / "RUN_EXPERIMENT fertig:"
   (trenner = pfeil) -> die 2 FEHLER-Zeilen sind nicht vertragstragend,
   ASCII `->` dort korrekt.
7. clang-format-22 (~/.local/bin/clang-format-22) --dry-run -Werror ueber beide
   Fix-Dateien: FMT_RC=0.
8. TABU/golden (selbst): `git diff --name-only 66de5c09..c76d3116` = dieselben
   10 Dateien (keine neue Datei), grep axes/|topics/|heuristik/|golden = 0
   Treffer.
9. S13A-F2 selbst gelesen: s13-schema-kette-ergebnis.md:160ff traegt "NACHTRAG
   (Fix-Stufe R1, Fund S13A-F2)" mit ALLEN Fix-Weg-Elementen (Design-
   INTERPRETATION von KON32-01 · Betriebszustand/kein Auswerte-Format ·
   Owner-Wortlaut "ES WIRD NUR PER-BINARY-XLSX GEBEN" · OFFENE Owner-
   Feinabstimmung · W3-Nachfolgeposten-Verweis · "nicht als glatt erledigt
   fuehren"); Quelle selbst gegengelesen: 20260817-DESIGN-s13-buendel-di25.md
   Z.481-483 woertlich "Alternative, bewusst NICHT gewaehlt: Stamp/Resume auf
   die Mappe umstellen ... Als W3-Nachfolgeposten vermerkt." Ledger/Board/
   Memory unberuehrt (beide HEADs unbewegt, porcelain 0).
10. Kern-Literale ALLER 8 persistierten Logs gegengelesen (grep, je Treffer):
    Rot-Log 1091/8+ROT · Gruen-Log 1095/0+GRUEN · Treppen-Log Kopf
    "@ c76d3116" + ALL_RC=0/TESTS_RC=0/CTEST_RC=0 + FACADE_RC=1 (=
    dokumentierter Treppen-Formel-Befund comdare_facade ->
    comdare_profile_run_facade, Traeger Lande-Zug) · ctest-voll Lauf 2
    "99% tests passed, 1 tests failed out of 513" (test_rcu-Flake) ·
    Lauf3-Log Kopf "Test project .../wt-ce-s13schema/build/gcc-release" +
    "100% tests passed, 0 tests failed out of 513" + 29.79 sec ·
    rcu-Wiederholungen 5x "0 tests failed out of 1" · Byte-Log
    GCC_COMPILE_RC=0/CLANG_COMPILE_RC=0 + `20 E2 86 92 20` · fixR1W-Log
    ROT_RC=1 (1091/8) + GRUEN_RC=0 (1095/0) -- alles konsistent mit meinen
    eigenen Laeufen 1./2.
11. Nachbar-Stichprobe P-13 (selbst): tests/unit/CMakeLists.txt endet mit dem
    test_s13_03-Registrierungs-Block (add_test + set_tests_properties als
    letzte Zeilen, Datei 7667 Zeilen) -- Dateiende-TABU weiter eingehalten.

BAU-ENTSCHEID DIESER INKARNATION (beide Mengen, identische Lage wie R1-W/R2-W):
KEIN Re-Vollbau gefahren. Der Objektstand ist byte-identisch derselbe HEAD
c76d3116, an dem die volle Treppe + 513/513-Bilanz literal persistiert liegen
(Punkt 10 selbst gegengelesen), an dem die R2-Erstinkarnation ihre eigene
6/6-ctest-Stichprobe am damals stehenden Baum erhoben hat, und der Fix-Diff
beruehrt ausschliesslich Kommentare + String-Literale (Punkt 3 voll gelesen).
Ein Wiederholungsbau desselben Stands belastete nur den mit dem laufenden
Kombibau geteilten 3er-Slot-Deckel (Owner-Aufraeum-Modus 22.08.: sequentiell,
keine Tokens verschwenden). GEDECKT durch diese Inkarnation: Wache ROT+GRUEN,
Fix-Diff voll, Quelltext-Bytes, Anker (gcc+clang-Probe + Wachen-Logik), Format,
TABU/golden, F2-Text+Quelle, Refs/porcelain/df, Log-Gegenlesen, P-13-Stichprobe.
NICHT GEDECKT durch eigenen Frischlauf: ctest-513er-Neulauf am neu gebauten
Baum -- Traeger: K17-Endstand-Kombibau am GEMERGTEN Lande-Stand (von R1,
Fix-Stufe, R2 und R2-W uebereinstimmend deklariert).

VERTAGT-PRUEFUNG UNVERAENDERT: 0 VERTAGT in der Fix-Runde (2/2 BEHOBEN); alle
getragenen Grenzen mit benannten Traegern (Abschnitt 2 oben gilt fort; kein
Nachtrag fuegt einen neuen vertagten Posten hinzu).

VERDIKT DIESER INKARNATION: **SITZT** (2/2 BEHOBEN mit eigenen Messungen
bestaetigt, 0 neue Regressionen, 0 Rest-Funde, Restliste P-01..P-26 gilt fort --
Objekt byte-identisch unbewegt; LANDEREIF ce c76d3116 + super 1e92b77e,
H-6-Kopplung unveraendert deklariert).
