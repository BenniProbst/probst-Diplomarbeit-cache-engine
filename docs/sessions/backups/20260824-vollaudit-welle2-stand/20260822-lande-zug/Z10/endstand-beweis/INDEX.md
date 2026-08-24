# ENDSTAND-BEWEIS ce -- KONSOLIDIERTER INDEX (W2-Vollaudit-Backup)

Zusammengestellt vom Endstand-Pruefer (ab 23.08. 13:43Z Beobachter/Bilanz) am 23.08.2026.
ASCII-only. Zweck: der ce-Endstand des W2-Lande-Zugs hat seine Beweise ueber SECHS Ordner
verstreut, weil vier Schreiber nacheinander gefahren sind (Traeger-Kette KON122-L17). Dieser
Index nennt fuer JEDEN Beweis-Gegenstand den EINEN Ort. Er verschiebt und kopiert NICHTS --
die Ordner cifix2-vl3debug/ und nachlande-r4/ werden zur Erstellungszeit noch beschrieben
(Traeger cifix-vl3-debug); Umsortieren waere ein Schreib-Eingriff.

REGEL FUER DIE ZITATION: alle unten genannten Dateien sind GESICHERTE KOPIEN unter
~/backups-workflow/. Nie aus einem lebenden Build-Verzeichnis zitieren.

## 0. DIE COMMIT-KETTE DES ENDSTANDS (Objekt-Messung 23.08. ~13:50Z)

    f729b93a  (Vor-Zug-Basis; Diff-Hygiene- und gitleaks-Bezugspunkt des r1)
      ...  10 Straenge --no-ff auf lande/w2-s1s2  (Z01-Z09, Tafel Abschn. 3 der ZUG-BILANZ)
    53c5524e  lande/w2-s1s2 Tip (H-5/F-10-Nachzug)
    5ddda4e5  Endstand-Merge in development (111 Dateien +11133/-505, 0 Konflikte)
    1f0424a2  Floor-Anker 544/540/538          <-- DUAL-PUSH 1 (22.08.) -> CI 16095 FAILED
    db66714a  Heilung Teil 1: 4x NSDMI (lint:static 383082)
    b6698eaf  Heilung Teil 3: Maskierung Formen (a)/(b) + NSDMI-Paar
    b247a339  Heilung Teil 3: Form (c) Define-Flaeche   <-- DUAL-PUSH 2 (09:21) -> CI 16097 SUCCESS
    1f51eb3d  PMC-Stoergroessen-Riegel (cherry aus 5a8e2841, harmonisiert)  [lokal, ungepusht]
    3841d717  Heilung Teil 4: Riegel-AUSWEIS im Mess-Preflight + NUR-TEST-Deklaration
              (der Verschaerfungs-Patch, vom Traeger 23.08. nachm. committet; Arbeitsbaum
               danach sauber)                                              [lokal, ungepusht]
                                                          --> DUAL-PUSH 3 (14:01Z) -> CI 16101 SUCCESS
    gitleaks-/Diff-Nenner fuer Push 3: b247a339..HEAD = 2 Commits (NICHT 1f0424a2..HEAD = 5)
    [Die Pipeline von Push 3 traegt die Nummer 16101, nicht 16098 -- 16098-16100 gehoeren
     anderen Projekten/Refs. Terminal-Beweis: Abschnitt 5b unten.]

    dangling: 5a8e2841 (Riegel Weg b, revertiert; Patch-Beleg gesichert)

## 1. r1 -- ENDSTAND-KOMBIBAU @ 5ddda4e5 (22.08. 18:18-18:34Z)

Ort: ~/backups-workflow/20260822-lande-zug/Z10/

| Gegenstand | Datei | Literal / Nenner |
|---|---|---|
| Treiber-Skript | kombibau-z10-endstand.sh | — |
| Bilanz | kombibau-haupt.log | "Z10-KOMBIBAU-ENDE FAIL=0" |
| Zelle gcc-Release | gcc-rel-{configure,j1,reconfigure,build,facade,tests,ctest}.log | "100% tests passed, 0 tests failed out of 544" |
| Zelle clang-Release | clang-rel-*.log (7 Dateien) | dito 544 |
| Zelle gcc-Debug | gcc-dbg-*.log (7 Dateien) | dito 544 |
| Zelle clang-Debug | clang-dbg-*.log (7 Dateien) | dito 544 |
| J-1 SIEBEN Werkzeuge | *-j1.log je Zelle | Kopfzeile "J-1-LISTE LITERAL: comdare_adhoc_emitter_cli comdare_anatomy_codegen_cli comdare_axis_registry_gen comdare_catalog_codegen_cli comdare_measurement_axis_registry_gen comdare_overlay_source_hash_gen comdare_system_axis_registry_gen" |
| Facade REAL | gcc-rel-facade.log | "[overlay_source_hash_gen] 712 Dateien, 3420405 Bytes, sha512=9c3a0bb2... (unveraendert)" |
| Floor-Treppe (EINMAL live) | floor-treppe-z10.sh + floor-treppe-z10.log + floor-conf-*.log + floor-ctestN-*.log + floor-namen-*.txt | "INVENTUR[avx512f]: Total=544" / "[avx2]: 540" / "[basis]: 538"; comm beidseitig; "RESTORE_NAMENSLISTE=BYTE-GLEICH" |
| Gates 6/6 | gates-6of6.log | "GATE [6/6] GRUEN. NENNER: 5 Dateien byteidentisch, Anker 1x in libs/cache_engine/profile_facade/source_catalog.hpp"; GATE [5/6] "544 == 544 (exakt)" |
| gitleaks Echt | gitleaks-git-bereich.log | "17 commits scanned." / "no leaks found" == rev-list --count --no-merges f729b93a..1f0424a2 |
| gitleaks Koeder-Selbstbiss | gates-6of6.log | "SELBSTBISS: gebissen (Koeder-Laenge 26, gitleaks-Exit 1)" |
| Diff-Hygiene | diffwache-vorher-f729b93a-b4c593f5.log / diffwache-nachher-f729b93a-HEAD.log | — |
| Axis-Lock | axislock-bau.log | — |
| Protokoll | Z10-PROTOKOLL.md | — |

DELTA-DECKUNG r1 -> Push-Stand: diff 5ddda4e5..1f0424a2 = GENAU 1 Datei
scripts/ci_test_inventory_floor.txt (+27/-3), gedeckt durch Gate [5/6] + Floor-Treppe.

## 2. CI 16095 @ 1f0424a2 -- DER ROTE BEFUND (Rohkopien)

Ort: Z10/ci16095/

- lint-static-383082.log -- 4x cppcheck uninitMemberVarNoCtor
  (test_c13_selektiver_rebuild.cpp:205; test_s13_02_zielfilter_vier_faelle.cpp:138/139/208)
- test-unit-debug-383091.log (926 KB Vollkopie) -- Test 509 vl3-Bytegleich; die
  With-diff-Hunks @@ -54,6 / @@ -65,5 / @@ -104,6 / @@ -142,3 sind der Define-Kipp-Beweis
- nsdmi-fix-db66714a.diff -- der Fix Teil 1
- Z10/cifix16095/retry-383107-trace.log (850 KB) -- Diagnose-Retry, FAILED 536/537, zwei
  FLAGLOSE Laeufe (3/4 vs 2/4), alle Diffs ausschliesslich pmc_befund => Prozess-zu-Prozess-
  PMU-Varianz, kein --debug-Einfluss, 16088 war Glueck
- Z10/../../20260821-w1l-landung/cifix2-vl3debug/ci16073-job382856-trace-vollkopie.txt
  -- der AELTERE Beleg derselben Klasse ("3/4, 4/4 und 2/4 in EINEM Job"), entlastet pmcpaket

## 3. r2 -- ZWISCHENPROBE @ b6698eaf (23.08. 08:45-08:56Z) -- NICHT als Endstand zitierbar

Ort: Z10/cifix16095/ (Skript: Z10/kombibau-r2/kombibau-z10-r2.sh und cifix16095/kombibau-z10-cifix.sh)

- Zellen 1-3 GRUEN 544/544; Zelle 4 clang-dbg OHNE Bilanzzeile (ctest-Log bricht bei 265/544
  ab, 08:56:07). Deshalb Zwischenprobe, so auch vom Lead eingestuft.
- k13-bissprobe-ROT.log -- K13 fuer die Maskierung (b6698eaf): Struktur-Nenner-EXPECT biss
  literal, ctest rc=8, 0/1 passed
- gruen-lauf1..3-gcc-dbg.log -- die 3x-Wiederholungsprobe danach
- diffwache-f729b93a-b6698eaf.log (30 Commits) GRUEN
- Z10-PROTOKOLL-FORTSCHREIBUNG.md -- das laufende Protokoll der Schlussstrecke inkl.
  Par.6 (K16-Uebergabe A->B) und Par.7 (Schreiber-Marker, alle vier Traeger-Wechsel)

## 4. r3 -- KOMBIBAU @ b247a339 (23.08. 09:14-09:20Z, Traeger B)

Ort: ~/backups-workflow/20260821-w1l-landung/cifix2-vl3debug/

| Gegenstand | Datei | Literal |
|---|---|---|
| Zelle 1 gcc-Release | k17-z1-gcc-rel-bau.log / k17-z1-gcc-rel-ctest.log | "100% tests passed, 0 tests failed out of 544" |
| Zelle 2 clang-Release | k17-z2-clang-rel-bau.log / -ctest.log | dito 544 |
| Zelle 3 clang-Debug | k17-z3-clang-dbg-bau.log / -ctest.log | dito 544 |
| Zelle 4 gcc-Debug | k17-z4-gcc-dbg-bau.log / -ctest.log | dito 544 |
| Gates 6/6 | gates-6x-b247a339.log | Bereich 1f0424a2..b247a339, 3 Commits |
| K13 Form (c) Mess-rot | k13-formc-mutation-ROT.log (09:08, VOR dem Gruen-Beleg) | — |
| Riegel Weg (b), verworfen | VERWORFEN-5a8e2841-riegel-weg-b.patch (09:03) | — |
| Riegel-Nachtrag/Mechanik | nachtrag-riegel.log (09:11) | Riegel-AN vs Riegel-AUS erzeugt im plan-ci-Diff EXAKT die 383091-Flaechen (Positionen 56/67/106 wie CI @@ -54/-65/-104) |
| Ursachen-Analyse (Vorlauf) | ursache.md, repro.log, fix-beweis.log | — |

## 5. CI 16097 @ b247a339 -- DER GRUENE ENDSTAND VON PUSH 2 (Terminal-Beweis)

Ort: Z10/endstand-beweis/ (dieser Ordner; API-Kopien, erhoben 23.08. ~13:52Z)

- ci16097-pipeline.json -- status=**success**, sha=b247a339654e67828cba47f0c1ec5d5f545d1af2,
  ref=development, created 09:20:46.572Z, started 09:20:50.448Z,
  finished **10:03:32.074Z**, duration 2558s => TERMINAL.
- ci16097-jobs.json -- **27 Jobs: 26 success + 1 manual** (is_original:relock, ein manuelles
  Gate, kein Fehlschlag). Die beiden 16095-Rotstellen sind namentlich geheilt:
  **lint:static 383110 = success**, **test:unit:debug 383119 = success**.
  ZUSATZBEFUND: in 16095 waren die clang-Testzellen SKIPPED; in 16097 liefen sie und sind
  gruen -- test:unit:clang 383120 und test:unit:clang:debug 383121. Der Endstand ist damit
  auf BEIDEN Compilern durch die CI gegangen, nicht nur auf gcc.
- ci16097-jobs.txt -- dieselbe Liste als Klartext-Tafel.

## 6. r4 -- SCHLUSSSTRECKE @ Riegel + Verschaerfung (23.08. ab 13:47Z, Traeger cifix-vl3-debug)

Orte: Z10/nachlande-r4/ (Vorbereitung + Skript, vom Pruefer gestellt) und
~/backups-workflow/20260821-w1l-landung/cifix2-vl3debug/ (Vollzugs-Logs des Traegers)

VORBEREITET (Pruefer, read-only erstellt):
- nachlande-r4/VORBEREITUNG.md -- Cherry-Analyse 5a8e2841 (merge-tree: GENAU 1 Konflikt
  test_vl3, Blobs base 731ed8fd / ours a2419ac4 / theirs 6d151187), Harmonisierungs-Plan
  a-d, Verschaerfungs-Wortlaute (i)+(ii), Ablauf, Auflagen-Register
- nachlande-r4/kombibau-r4.sh -- die 4-Zellen-Treppe + Test-509 3x in build-dbg
- Z10/nachlande-riegel/ -- die Riegel-MECHANIK-Probe: p1-riegel-an.yaml (9348 B) gegen
  p2-riegel-aus.yaml (9567 B) + p3/p4 (tierci) + planner-bau.log + wache-bau.log +
  wache-gruen.log. Das ist der Objekt-Beleg dafuer, dass der Riegel genau die
  383091-Flaechen stilllegt und die Wache dabei gruen bleibt.

VOLLZUG (Traeger, laufend zur Erstellungszeit dieses Index):
- k13-riegel-ausweis-mutation-ROT.log (13:49) -- **K13-MESS-ROT DER VERSCHAERFUNG, LITERAL**:
  vier neue Erwartungen bissen an ihren Zeilen (test_experiment_plan_director.cpp:1257,
  :3243, :3261, :3263), "2 FAILED TESTS", "0% tests passed, 1 tests failed out of 1"
  (ctest #361 test_experiment_plan_director in build-dbg). Damit ist die Lead-Auflage
  "Mess-rot VOR dem Gruen-Beleg" fuer die Verschaerfung erfuellt.
- raeumung-r4.log (13:46) -- Raeumung Schritt 1, 7.5G -> 16G frei, Doppel-Bedingung
  tracked=0/csv=0 + ccache -C; die vier K17-Baeume BEHALTEN
- k17-r4-{gcc-rel,clang-rel,clang-dbg,gcc-dbg}.log (13:50:45-13:58:31Z) -- die r4-Zellen
  am Endstand **3841d717**. ACHTUNG BEIM ZITIEREN: diese vier Logs tragen die ctest-
  Bilanzzeile "100% tests passed, 0 tests failed out of 544" NICHT (r1 und r3 trugen sie).
  Der Nenner steht statt dessen in den geretteten LastTest.log-Kopien, s. naechster Punkt.
- **endstand-beweis/r4-lasttest/** -- vom Pruefer gerettete CTest-Volllogs der r4-Zellen
  (build-l1 = gcc-rel, build-l1-clang = clang-rel, build-dbg-clang = clang-dbg), letzte
  Fortschrittszeile je **544/544 Test**; dazu NENNER-NACHWEIS.md mit Zuordnung
  Baum->Zelle und den Vergleichs-Laufzeiten r1/r3/r4. GRUND DER RETTUNG: LastTest.log
  wird vom naechsten ctest im selben Baum ueberschrieben und von der Raeumung geloescht.
  OFFEN: die gcc-dbg-Zelle (build-dbg) war bei der Rettung noch nicht fertig -- ihr
  LastTest.log muss VOR der Raeumung nachgesichert werden.
- Gates 6/6 am r4-Stand: cifix2-vl3debug/gates-6x-3841d717.log (14:01Z) -- Bereich
  literal b247a339..3841d717 (2 Commits); gitleaks "2 Commits, 19079 Bytes, 0 Funde" +
  Selbstbiss Exit 1; Gate [5/6] "544 == 544 (exakt)". DUAL-PUSH 3 um 14:01Z vollzogen.

## 5b. CI 16101 @ 3841d717 -- DER GRUENE ENDSTAND VON PUSH 3 (Terminal-Beweis)

Ort: dieser Ordner (API-Kopien, erhoben 23.08. ~20:07Z nach Terminal).

- ci16101-pipeline.json -- status=**success**, sha=3841d7175086d5141fb28d6a401ae1ab4d137b30,
  ref=development, created 14:01:57.880Z, started 14:02:03.252Z,
  finished **14:43:46.468Z**, duration 2503 s => TERMINAL.
- ci16101-jobs.json -- **27 Jobs: 26 success + 1 manual** (is_original:relock), Job-Tafel
  DECKUNGSGLEICH mit 16097: lint:static 383137 success, test:unit 383145, test:unit:debug
  383146 (die 383091-Rotstelle, jetzt mit Riegel-Doppelboden), test:unit:clang 383147,
  test:unit:clang:debug 383148 -- alle success. chaos:drift 383161 success.
- Damit sind BEIDE Pushes der Zwei-Push-Ausnahme terminal gruen (16097 + 16101), die
  Ausnahme-Bedingung (streng sequentiell) wurde eingehalten und der 16095-Fail ist
  zweifach (Form c ALLEIN in 16097; Form c + Riegel-Doppelboden in 16101) geheilt.

## 5c. FULL-JOIN-ENDPROBE + PRUEFER-URTEIL (K29-Rezept a-d, 23.08. 20:07-20:09Z)

Ort: ~/backups-workflow/20260821-w1l-landung/cifix2-vl3debug/endstand-pruefer/
(FULLJOIN-ENDPROBE-URTEIL.md + probe-a-ours-theirs.txt + probe-b-diffstat.txt +
probe-c-leitsymbole.txt + probe-d-ctestN-live.txt + KON122-ENTWURFSBLOCK.md L1-L21).
Kurzurteil: 5/5 bestanden -- kein ours/theirs, Diffstat identisch je Merge, Konflikte nur
in tests/unit/CMakeLists.txt (H-9-Union), Leitsymbole praesent, ctest -N live 544 == Anker.

## 7. PAUSE-SICHERUNG (Owner-Anhalte-Order 13:40)

Ort: ~/backups-workflow/20260823-pause-sicherung/

- pause-ce-head.txt -- HEAD-Zeile 1f51eb3d
- commit-1f51eb3d-cherry-riegel.patch (10545 B) -- der harmonisierte Riegel-cherry
- pause-uncommitted-verschaerfung-1f51eb3d.patch (6519 B) + pause-uncommitted-STAT.txt
  -- die Verschaerfung (i)+(ii), 3 Dateien 42+/1-, Beitrag des Endstand-Pruefers,
  vom Traeger uebernommen (namentliche Fuehrung: KON122-L17)
- PAUSE-NOTIZ-session-41cd9459.md -- Notiz einer NICHT beteiligten Peer-Session
  (Vorsicht beim Lesen: sie beschreibt eine leere Session, nicht diesen Zug)
- Dazu super-Commit 38428099 (Abbruchsichere Pause, 3 Workflows + 6 Peer-Sessions)

## 8. WAS BEIM VOLLAUDIT-BACKUP MITMUSS (Dauerregel, Wellen-Ende W2)

1. Dieser Index + ZUG-BILANZ.md (Ordner 20260822-lande-zug/, Z01-Z10 komplett).
2. Der Fremd-Ordner ~/backups-workflow/20260821-w1l-landung/cifix2-vl3debug/ -- er traegt
   r3, K13 und den r4-Vollzug und liegt NICHT unter 20260822-lande-zug/. Ohne ihn ist der
   Endstand-Beweis unvollstaendig. (Nicht verschieben; der Traeger schreibt hinein.)
3. V91-A1-Mutationsprotokoll M1-M4 (vollzug-91-ergebnis.md Abschn. 7) und
   AB-09/fixstrecke2 -- so in der ZUG-BILANZ Abschn. 4 vorgemerkt.
4. Die CI-Terminalbelege 16095 (rot), 16097 (gruen), 16101 (gruen; Push-3-Pipeline,
   nicht 16098) als API-Kopien -- alle drei liegen in diesem Ordner bzw. Z10/ci16095/.
