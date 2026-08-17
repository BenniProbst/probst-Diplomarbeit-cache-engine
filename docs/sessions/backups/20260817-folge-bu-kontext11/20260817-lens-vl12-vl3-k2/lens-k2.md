# lens:k2 -- Verdikt: TRAEGT_MIT_FIXES

## Fund 1 [ERNST] Super-Wache faellt beim Gitlink-Bump STILL auf SKIP — die Plan-Auflage R1 ist NICHT umgesetzt, der Commit-Text erklaert sie faelschlich fuer gegenstandslos
BELEG: super /home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/Code/tests/CMakeLists.txt:348 literal:
        "-DFIXTURE=${COMDARE_CACHE_ENGINE_DIR}/tests/unit/thesis_tiere/experiment_golden_kern.xml"
(add_test NAME test_fixture_schema_experiment_golden_kern, :344-349 — zeigt weiter auf den ALTEN ce-Pfad)

super Code/tests/fixture_schema_subset_check.cmake:98-103 literal:
  if(NOT EXISTS "${FIXTURE}")
      message(STATUS "Nachbar-Checkout fehlt (FIXTURE='${FIXTURE}') -- diese Wache kann nichts aussagen.")
      message(STATUS "COMDARE-XML-WACHE-SKIP")
      return()
  endif()

super Code/tests/CMakeLists.txt:419 literal:
    SKIP_REGULAR_EXPRESSION "(^|\n)-- COMDARE-XML-WACHE-SKIP\r?(\n|$)"
(:415-417 setzt die Property u.a. auf test_fixture_schema_experiment_golden_kern)

==> Sobald der ce-Gitlink auf 44a909c1 gehoben wird, existiert die -DFIXTURE-Datei nicht mehr; die Wache druckt den Marker, ctest klassifiziert SKIP statt FAIL. Ein SKIP zaehlt in `ctest -N` weiter mit ⇒ auch kein Floor-Alarm. Stilles Gruen.

GEGENSTUECK IM PLAN (docs/plaene/20260806-PLAN-f3-f5-r4-aufraeumpass.md):
  :97-99  "DER TRAGENDE BEFUND -- R1 ist ungemindert scharf. ... Am Objekt, Code/tests/fixture_schema_subset_check.cmake:98-103, literal:"
  :127    "Reihenfolge ist bindend; Schritt 2 und 3 gehoeren in EINEN Commit."
  :138-144 Schritt 3 = R1-Haertung IM SELBEN COMMIT in **Code/tests/fixture_schema_subset_check.cmake** (Zweig aufteilen: Elternverzeichnis fehlt -> SKIP; Verzeichnis da, Datei weg -> FATAL_ERROR)
  :147-148 Schritt 4 = Mutationsprobe PFLICHT: Fixture wegnehmen, belegen dass der Test ROT wird statt SKIPPED

COMMIT-TEXT 44a909c1, Absatz D2:
  "Weg b ist gelandet, aber CE-SEITIG als eigene Schwester tests/unit/fixture_schema_subset_check.cmake -- und sie traegt die R1-Haertung des Plans bereits ... Plan-Risiko R1 ist ce-seitig damit gegenstandslos; es wandern nur der -DFIXTURE-Pfad und der Kopf."

Das ist eine Gegenstands-Vertauschung: die ce-Schwester (wt-ce-k2 tests/unit/fixture_schema_subset_check.cmake:43-48, dort tatsaechlich FATAL_ERROR) ist NICHT die Datei, auf die R1 zielt. Der Plan benennt in :138 woertlich die SUPER-Datei. Die drei Bissproben des Commits liefen ebenfalls nur gegen die ce-Schwester ⇒ Plan-Schritt 4 ist fuer den echten R1-Gegenstand nicht erbracht.
BEFUND: Der Rename ist ce-intern vollstaendig, aber die super-seitige Wache test_fixture_schema_experiment_golden_kern haengt weiter am ALTEN Dateinamen und ihr fixture_schema_subset_check.cmake behandelt eine fehlende FIXTURE als SKIP. Mit dem Gitlink-Bump verliert das super-Repo damit lautlos die einzige Vokabular-Wache ueber die ce-Naht-Fixture — genau die Klasse Fehlklassifikation, gegen die die B14-NB4-Haertung gebaut wurde. Der Commit-Text erklaert dieses Risiko fuer 'gegenstandslos', indem er die ce-Schwester an die Stelle der super-Datei setzt; der Plan bindet die Haertung ausdruecklich in dieselbe Landung.
FIX: Im Lande-Zug, super-seitig, VOR/MIT dem Gitlink-Bump (6-teiliges Rezept):
(1) Code/tests/CMakeLists.txt:348 -DFIXTURE auf .../thesis_tiere/experiment_kern_seam_fixture.xml umhaengen.
(2) Code/tests/fixture_schema_subset_check.cmake:98-103 nach Plan :138-144 aufteilen — Elternverzeichnis der FIXTURE fehlt => SKIP (Marker unveraendert, damit :419 weiter greift); Verzeichnis existiert, Datei fehlt => FATAL_ERROR mit der Begruendung 'Umbenennungs-Rueckstand, kein fehlender Checkout'.
(3) Mutationsprobe nach Plan :147-148 fahren: Fixture wegnehmen, literal belegen ROT statt SKIPPED.
(4) Code/tests/fixture_schema_subset_check.cmake:2 und :10 (Paar-Nennung + 'offene ce-Umbenennungs-Auflage') sowie Code/tests/CMakeLists.txt:339-341 auf den neuen Namen und den Vollzug nachziehen.
(5) Code/test_data_xml/SCHEMA.md:48 pruefen (Wachen-Name test_fixture_schema_experiment_golden_kern; Umbenennung des ctest-Namens ist Floor-/Inventar-beruehrend und daher eigene Entscheidung).
(6) Plan-Ist-Tabelle docs/plaene/20260806-PLAN-f3-f5-r4-aufraeumpass.md:93-94 und Ledger docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md:25279 als VOLLZOGEN nachtragen.
Hinweis (positiv geprueft): Code/tests/golden_n_consistency_check.cmake nimmt -DMASTER (super) + -DPROFILE (ce all_axes_golden.profile.xml, CMakeLists.txt:389-394) und NICHT die umbenannte Datei — von diesem Rename unberuehrt. Damit ist der Plan-Punkt :145-146 ('UNBELEGT, ob sie dort denselben Zweig hat') fuer diesen Rename erledigt.

## Fund 2 [ERNST] Der neue XML-Kopfblock — die einzige inhaltliche Zugabe des Commits — traegt sechs Zeilenbelege, die ALLE um +1 danebenliegen (auf den Vor-Commit-Stand gerechnet)
BELEG: Der Kopfblock verspricht woertlich (tests/unit/thesis_tiere/experiment_kern_seam_fixture.xml:20-21):
  "ABSICHTLICHE DIVERGENZ ZUM MASTER. ... jede der folgenden Zeilen hat einen literalen Beleg in test_experiment_kern_seam.cpp (Zeilennummer in Klammern)."

Derselbe Commit verschiebt test_experiment_kern_seam.cpp ab Zeile 3 um +1 (Hunk @@ -1,6 +1,7 @@: 2 raus, 3 rein). Die Belege sind gegen 04ac26fa gerechnet und wurden nicht nachgezogen:

  XML:23 "(180)" search_algo pruefling=ee_prt
     ALT 180: EXPECT_EQ(ep->axes_default_lookup[0].pruefling, "ee_prt");   <- passt
     NEU 180: EXPECT_EQ(ep->axes_default_lookup[0].ref, "search_algo");    <- falsch (richtig: 181)
  XML:25 "(184)" merge=fulljoin
     ALT 184: ...[1].merge_mode, "fulljoin");   NEU 184: ...[1].pruefling, "prt_art");  (richtig: 185)
  XML:26 "(185, 186)" mapping pruefling=self
     ALT 185/186: [2].pruefling "self" / [2].merge_mode "merge"
     NEU 185: merge_mode "fulljoin"  (richtig: 186, 187)
  XML:28 "(192, 193)" storage minio + endpoint
     ALT 192/193: storage_backend "minio" / storage_endpoint
     NEU 192: ASSERT_TRUE(ep.has_value());   (richtig: 193, 194)
  XML:30 "(104 bis 111)" keine OS-/RAM-Attribute
     ALT 104-111 = Kommentarblock + 4 EXPECTs;  NEU 104 = Leerzeile, NEU 112 (cas_latency_cl) faellt heraus  (richtig: 105 bis 112)
  XML:30 "(159 bis 173)"
     ALT 159 = TEST(ExperimentKernSeam, MachinesWithoutOsExpectationStayEmpty) {, ALT 173 = }
     NEU 159 = Kommentarzeile im VORHERIGEN Test  (richtig: 160 bis 174)

Alle sechs sind einheitlich ALT-basiert — es ist kein Teilversehen, sondern ein vergessener Nachzug.
BEFUND: Die 24 hinzugefuegten Zeilen sind laut Commit-Text ausschliesslich dieser Kopfblock, und sein erklaerter Wert ist gerade die literale Belegbarkeit ('damit steht die absichtliche Divergenz IN der Datei und nicht nur in einem Plandoc'). Im gelandeten Stand fuehrt jeder der sechs Zeiger auf die falsche Zeile — bei (180) und (184) sogar auf eine Assertion, die gerade NICHT die behauptete Divergenz prueft. Der Beweis, der der einzige Inhalt des Commits ist, geht ins Leere.
FIX: In tests/unit/thesis_tiere/experiment_kern_seam_fixture.xml die sechs Klammer-Angaben um +1 heben: :23 (180)->(181) · :25 (184)->(185) · :26 (185, 186)->(186, 187) · :28 (192, 193)->(193, 194) · :30 (104 bis 111)->(105 bis 112) und (159 bis 173)->(160 bis 174). Danach jeden Zeiger einmal mit `sed -n "<n>p"` gegen den NEUEN Stand gegenlesen. Dauerhafte Absicherung erwaegen: statt Zeilennummern die TEST-Namen zitieren (ParsesAxisPrueflingAndFulljoinToken, ParsesStorageSlot, MachinesWithoutOsExpectationStayEmpty, ParsesMachinesWithCoreIdentity) — die sind gegen Zeilenverschiebungen immun.

## Fund 3 [HINWEIS] 'Kein golden-Anklang mehr' gilt nur fuer Dateiname und Define — Datei-INHALT, ctest-sichtbarer Testname und Helferfunktion tragen ihn weiter
BELEG: Im INHALT der umbenannten Datei (tests/unit/thesis_tiere/experiment_kern_seam_fixture.xml):
  :35  <comdare_experiment version="2" id="diplomarbeit_golden_kern_fixture"
  :40      <name>diplomarbeit_golden_kern_fixture</name>
  :94      <binary_path>golden_kern/measurements/all_permutations.bin</binary_path>
  :95      <csv_path>golden_kern/measurements.csv</csv_path>
  :96      <latex_path>golden_kern/golden_kern_table.tex</latex_path>

In den Konsumenten:
  tests/unit/test_s3_ordnung_freigabe.cpp:54  [[nodiscard]] std::vector<cx::ExperimentMachine> golden_machines() {
  tests/unit/test_s3_ordnung_freigabe.cpp:87  TEST(S3OrdnungFreigabe, GoldenXmlTraegtDieZweiDeklariertenMaschinen) {
  tests/unit/thesis_tiere/test_experiment_kern_seam.cpp:157  // ... Die Golden-Kern-Fixture deklariert KEINE OS-Erwartung --

GEGENPROBE (entlastend): eine id-Kollision mit dem Master besteht NICHT —
  super Code/test_data_xml/experiment_golden_kern.xml:77  id="diplomarbeit_golden_kern"
  ce  experiment_kern_seam_fixture.xml:35                 id="diplomarbeit_golden_kern_fixture"
Die beiden waren schon vorher verschieden.
BEFUND: Der Commit-Betreff ('Name jetzt eindeutig') haelt fuer den DATEINAMEN und das Define — beides ist sauber und vollstaendig. Die weitergehende Lesart 'kein golden-Anklang mehr' haelt nicht: die Datei nennt sich intern weiter diplomarbeit_golden_kern_fixture, schreibt nach golden_kern/, und der ctest-SICHTBARE Testname S3OrdnungFreigabe.GoldenXmlTraegtDieZweiDeklariertenMaschinen widerspricht seiner eigenen, im selben Commit auf experiment_kern_seam_fixture.xml umgeschriebenen Assertion-Meldung (:89). Die id-Werte zu aendern waere allerdings ein WERT-Eingriff und wuerde die im Commit bewiesene C14N-Byte-Gleichheit brechen — das Zurueckhalten dort ist richtig.
FIX: Wert-neutral nachziehbar und ohne C14N-Bruch: (a) Helfer golden_machines() -> kern_seam_machines() und (b) TEST-Name GoldenXmlTraegtDieZweiDeklariertenMaschinen -> FixtureTraegtDieZweiDeklariertenMaschinen — beides beruehrt keinen XML-Wert. ACHTUNG: (b) aendert einen ctest-Namen; Floor/Inventar (scripts/ci_test_inventory_floor.txt, scripts/ci_test_registrierungs_allowlist.txt) sind mit demselben Zug zu pruefen, sonst wird aus einem Doku-Fix ein Nenner-Befund. Die golden_kern/-Ausgabepfade und die XML-id bewusst STEHEN LASSEN und im Kopfblock als 'bewusst unveraendert (Wert-Neutralitaet)' vermerken — sonst wird der naechste Leser sie 'aufraeumen' und den C14N-Beleg zerstoeren.

## Fund 4 [HINWEIS] Innerer Widerspruch in test_s3_ordnung_freigabe.cpp: der neue Kopf sagt Naht-Fixture, der unberuehrte Abschnittskommentar sagt weiter 'ECHTE golden-Maschinen-Menge'
BELEG: tests/unit/test_s3_ordnung_freigabe.cpp, NACH dem Commit:
  :20  // Die <machines>-Menge kommt aus der ce-Naht-Fixture experiment_kern_seam_fixture.xml (NUR GELESEN) --
  :21  // kein nachgebautes Fixture, dieselbe Quelle wie test_experiment_kern_seam. ...
  :84  // (1)+(2) Treffer und Kill-Switch -- an der ECHTEN golden-Maschinen-Menge
:84 liegt ausserhalb jedes Hunks des Commits (git show -M 44a909c1 -- tests/unit/test_s3_ordnung_freigabe.cpp: Hunks bei @@ -17,8 +17,10 @@, @@ -39,8 +41,8 @@, @@ -51,7 +53,7 @@, @@ -84,7 +86,7 @@ — der letzte Hunk aendert :89, nicht :84).
BEFUND: Der Commit entflicht den Kopf der Datei, laesst aber die Abschnittsueberschrift 15 Zeilen weiter unten stehen, die den alten, gerade beseitigten Sprachgebrauch fortschreibt. Genau diese Doppeldeutigkeit ('ce-Datei = die golden') war der Ausgangsbefund C5.
FIX: tests/unit/test_s3_ordnung_freigabe.cpp:84 auf 'an der Maschinen-Menge der ce-Naht-Fixture (byte-gleich zum super-Master)' umschreiben — reiner Kommentar, kein Testverhalten beruehrt.

## Fund 5 [HINWEIS] Das 494/494-Gruen deckt das SCHARFE Schema-Bein nicht — im k2-Worktree ist es strukturell nicht lauffaehig
BELEG: tests/unit/fixture_schema_subset_check.cmake:94-107 — ohne -DSCHEMA wird gesucht:
  set(SCHEMA "${CE_ROOT}/../../test_data_xml/experiment_schema.xsd")
CE_ROOT = /home/comdare/wt-ce-k2 (build/tests/unit/CTestTestfile.cmake:339 literal: "-DCE_ROOT=/home/comdare/wt-ce-k2")
=> gesucht wird /home/comdare/test_data_xml/experiment_schema.xsd
Probe: `ls -d /home/comdare/test_data_xml` -> "No such file or directory"
=> :101-106 greift, Marker COMDARE-XML-WACHE-SKIP-SCHEMA-BEIN, return() — der Test meldet trotzdem Passed (build/tests/unit/CTestTestfile.cmake:340 setzt nur LABELS + TIMEOUT, keine SKIP_REGULAR_EXPRESSION).
Protokoll build-protokolle/20260817-k2-ctest-sauber.log:181 " 88/494 Test #170: fixture_schema_subset_check_ce ....... Passed 0.00 sec", Endbilanz :991 "100% tests passed, 0 tests failed out of 494", 0 Treffer auf "skipped".
BEFUND: Der Commit-Text fuehrt als Gate 'Subset-Wache mit scharfem Schema-Bein gegen die Single-Source-XSD: rc=0 ... gueltig gegen die Single-Source-XSD' — das muss ein separater, handgefuehrter Lauf mit explizitem -DSCHEMA gewesen sein. Der ctest-Lauf, der die 494/494 traegt, hat dieses Bein NICHT gefahren. Kein Defekt am Bau (der Halb-Skip ist im Skript-Kopf :18-23 ausdruecklich so entworfen), aber die zwei Mengen gehoeren bei der Freigabe getrennt genannt.
FIX: Bei der Landung die Deckung zweiteilig ausweisen: (a) ce-standalone 494/494 = Wohlform/Nichtleer/DOCTYPE, Schema-Bein halb-geskippt; (b) das scharfe Schema-Bein laeuft erst im super-Kontext bzw. mit explizitem -DSCHEMA=Code/test_data_xml/experiment_schema.xsd — dort einmal literal mitprotokollieren (rc + Zeile 'OK -- Fixture gueltig gegen die Single-Source-XSD').

## GEPRUEFT
- (1) VOLLSTAENDIGKEIT Define: `git grep -n COMDARE_EXPERIMENT_GOLDEN_KERN` ueber den ganzen getrackten Baum = 0 Treffer; zusaetzlich `grep -rn --exclude-dir=build* --exclude-dir=.git` ueber den Arbeitsbaum = 0 Treffer; `grep -rl` in build/ = 0 Treffer (kein stale Configure)
- (1) VOLLSTAENDIGKEIT Dateiname: `git grep -in golden_kern` = 15 Rest-Treffer, jeder einzeln bewertet — 9 ausserhalb der Fixture (machine_identity.hpp:212, target_isa_complex_axis.hpp:124, CMakeLists.txt:1958+3898, test_s3_ordnung_freigabe.cpp:22, Fixture:3/12/13, test_experiment_kern_seam.cpp:4) sind ALLE entweder Verweis auf die kanonische super-Instanz Code/test_data_xml/experiment_golden_kern.xml oder der bewusste Umbenennungs-Vermerk; 6 weitere sind XML-INHALT (id/name/output-Pfade, s. HINWEIS 3). `find -name '*golden_kern*'` ausserhalb build/ = 0 Dateien
- (2) KONSUMENTEN vollstaendig umgezogen und literal nachgezaehlt: CMake add_test -DFIXTURE (tests/unit/CMakeLists.txt:1965) · 2x set()+target_compile_definitions (:3917/:3920 und :7069/:7072) · 2x #ifndef/#error (test_experiment_kern_seam.cpp:30-31, test_s3_ordnung_freigabe.cpp:44-45) · 2x parse-Aufruf (:42 bzw. :56) · ce-Wachen-Kopf fixture_schema_subset_check.cmake:4 — neue Define-Schreibweise 9x konsistent, 0 Tippfehler; die CMake-Hilfsvariablen _kern_seam_fixture / _s3_freigabe_fixture sind verschieden benannt und je genau einmal unmittelbar nach ihrer Definition benutzt (keine Kollision)
- (2) KEIN verdeckter Konsument: kein file(GLOB) ueber thesis_tiere/*.xml (nur :11 und :24 ueber Achsen-Verzeichnisse), kein configure_file/install auf die Fixture, .gitlab-ci.yml nennt nur Testnamen (:1011), scripts/ fuehrt keine XML-Namensliste, scripts/ci_test_inventory_floor.txt unberuehrt (0 Treffer im --name-only des Commits)
- (3) SEMANTIK im Datei-INHALT: Kopf-Kommentar traegt den Umbenennungs-Vermerk (:11-14), die vollstaendige und nachgezaehlt KORREKTE Leser-Liste (:16-18) und die Divergenz-Tabelle (:20-30). Leser-Zahlen am Objekt bestaetigt: test_experiment_kern_seam.cpp = 15 TEST(, davon 6 distinkte mit parse_kern() (NEU :95/:161/:177/:191/:198/:208); test_s3_ordnung_freigabe.cpp = 6 TEST(, alle 6 mit golden_machines() (:88/:95/:120/:150/:177/:208). Damit ist zugleich die im Plan (:135-137) als UNBELEGT gefuehrte Zahl '12 hartverdrahtete Naht-Tests' am Objekt belegt: 6+6=12
- (4) WERT-NEUTRALITAET unabhaengig nachgerechnet und BESTAETIGT: python3 xml.etree canonicalize(strip_text=True) ueber `git show 04ac26fa:...experiment_golden_kern.xml` und `git show 44a909c1:...experiment_kern_seam_fixture.xml` liefert beide Male 2112 Bytes / sha256 31e8d35cd943905d810ae0c1eeba87f77705aa950548f6f51b0b3ad213e16e03 — exakt die Commit-Zahl
- (4) STAERKERE Gegenprobe: `diff <(xmllint --c14n alt) <(xmllint --c14n neu)` (C14N MIT Kommentaren) zeigt AUSSCHLIESSLICH den 24-zeiligen neuen Kopfblock als Zusatz, 0 weitere Zeilen — es gibt keine stille Inhaltsaenderung an der XML
- (4) RENAME-REINHEIT: `git show --raw -M 44a909c1` = 1x R063 + 6x M, 0 A, 0 D; numstat 59+/21-, die 24+/0- der XML sind reiner Kommentar. Die Similarity 63 ist ueber Gits Default-Schwelle 50 ⇒ Rename wird ohne Sonderflag erkannt
- (4)/DIFF-HYGIENE selbst nachgemessen: 0 hinzugefuegte Zeilen >120 Spalten, 0 Nicht-ASCII in hinzugefuegten Zeilen (die >120-Zeilen in tests/unit/CMakeLists.txt sind alle Bestand, nicht im Diff)
- (5) SUPER-SEITE kartiert (nur gelesen): Code/tests/CMakeLists.txt:348 (-DFIXTURE alter Pfad) · Code/tests/fixture_schema_subset_check.cmake:98-103 (SKIP-Zweig) + :2 + :10 (Kopf/offene Auflage) · Code/tests/CMakeLists.txt:339-341 + :419 (SKIP_REGULAR_EXPRESSION) · Code/test_data_xml/SCHEMA.md:48 · docs/plaene/20260806-PLAN-f3-f5-r4-aufraeumpass.md:93-94/:127-149 · Ledger:25279 — als 6-teiliges Lande-Rezept im ERNST-Fund 1 ausformuliert
- (5) ENTLASTUNG super-seitig: Code/tests/fixture_sync_check.cmake und die zwei test_fixture_sync_*-add_tests (Code/tests/CMakeLists.txt:323-332) haengen an experiment_golden.xml bzw. prt_art_axis_registry.xml — NICHT an der umbenannten Datei. golden_n_consistency_check.cmake nimmt -DMASTER (super) + -DPROFILE (ce all_axes_golden.profile.xml, :389-394) — ebenfalls unberuehrt
- (6) VERBOTSZONEN eingehalten: `git show --name-only -M 44a909c1` = 7 Pfade, 0 davon unter golden/; der ALTE Pfad tests/unit/thesis_tiere/ war korrekt KEIN golden-Bestand; golden_fullpilot_320_binary_ids.txt und alle COMDARE_GOLDEN_320_*-Defines unberuehrt; super-Arbeitsbaum an Code/test_data_xml/ und Code/tests/ literal leer im `git status --short`
- LOKALES GRUEN gelesen (nicht gefahren): build-protokolle/20260817-k2-ctest-sauber.log:991 '100% tests passed, 0 tests failed out of 494', 0 Treffer 'skipped'; die drei Nahtstellen-Tests einzeln Passed (:181 fixture_schema_subset_check_ce, :536 test_s3_ordnung_freigabe, :554 test_experiment_kern_seam); build/build.ninja und build/tests/unit/CTestTestfile.cmake:339 tragen den NEUEN Pfad/Define ⇒ kein stale-Configure-Trugschluss
- READ-ONLY eingehalten: keine Aenderung, kein Commit, kein Bau. `git status --short` im Worktree zeigt unveraendert nur das vorgefundene untracked _wiederanlauf.sh; HEAD = 44a909c151f0f28d2dda4d5af2918bdf71f2f2e7

## NICHT GEPRUEFT
- Kein eigener Bau und kein eigener ctest-Lauf gefahren (READ-ONLY-Auftrag + knappe Platte). Das lokale Gruen stammt aus dem vorgefundenen Protokoll build-protokolle/20260817-k2-ctest-sauber.log — ich habe es gelesen, nicht reproduziert.
- Der Commit selbst fuehrt 'Vollbau und ctest ... sowie die Negativprobe am umbenannten Define' als OFFEN. Die #error-Negativprobe (Define wegnehmen => Compile-Fehler) ist in keinem Protokoll belegt und wurde von mir nicht gefahren.
- Zweiter Dialekt / Debug-Zweig: nur der eine GCC-Lauf lag als Protokoll vor. clang und Debug (Doktrin 'Google Tests, Debug UND Release'; Warnungs-Review zweimal) sind nicht belegt.
- Das SCHARFE Schema-Bein gegen Code/test_data_xml/experiment_schema.xsd nach dem Rename: im k2-Worktree strukturell nicht lauffaehig (Nachbarpfad /home/comdare/test_data_xml existiert nicht). Die Commit-Behauptung 'rc=0 ... gueltig gegen die Single-Source-XSD' ist damit von mir nicht am Objekt nachvollzogen — nur die Nicht-Lauffaehigkeit im Worktree ist belegt.
- Die super-Skip-Falle ist STATISCH belegt (add_test-Zeile + SKIP-Zweig + SKIP_REGULAR_EXPRESSION). Ich habe KEINEN super-ctest/CI-Lauf mit gehobenem Gitlink gefahren, der den SKIP literal zeigt — der Beweis am laufenden Job steht aus (und ist genau Plan-Schritt 4).
- Historik-Erhaltung des Rename (git log --follow ueber die umbenannte Datei) nicht geprueft.
- prt-art-Repo und das thesis-Repo nicht gegriffen; nur ce-Worktree + super-Arbeitsbaum.
- Remote-Staende (origin/github) und offene Pipelines nicht abgefragt.
- Die drei Bissproben und die Diff-Hygiene-Wache aus dem Commit-Text habe ich nicht nachgefahren; die Breiten-/ASCII-Aussage stammt aus meiner eigenen Messung am Diff, nicht aus dem Wachen-Lauf.
- Ob die im HINWEIS 3 vorgeschlagene Umbenennung des ctest-Namens den Floor/das Registrierungs-Inventar beruehrt, habe ich nur als Risiko benannt, nicht durchgerechnet.