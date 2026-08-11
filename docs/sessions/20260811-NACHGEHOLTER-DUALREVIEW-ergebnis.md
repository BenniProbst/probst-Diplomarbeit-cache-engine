# NACHGEHOLTER DUAL-REVIEW 2026-08-11 -- SYNTHESE, WIDERSPRUCHS-AUFLOESUNG, LANDEURTEILE

AUFTRAG: 4 Pakete x 2 unabhaengige Lenses (Codex, Meta) = 8 Lens-Verdikte. Aufgabe war NICHT
mitteln, sondern Widersprueche AM OBJEKT aufloesen und je Paket ein Landeurteil geben.
Alle Ausschlag-Messungen dieser Synthese sind selbst gefahren (Abschnitt M, literal).

STAND-ANKER DIESER SYNTHESE (git rev-parse, selbst gemessen, alle 4 Worktrees 0 dirty files):
  wt-super-warn      HEAD=afa5815a  == origin/development (Branch bau/p3-guard-basis-literal)
  wt-ce-stagetopo    HEAD=68fbd930  == origin/development (Branch bau/ci-stage-topologie)
  wt-ce-d37b         HEAD=a881d468  (development, lokal); origin/development=68fbd930
                     -> P-D37B ist zum Synthese-Zeitpunkt weiterhin NICHT gelandet.
  wt-super-landung   HEAD=af55cbee  (development); origin/development=afa5815a;
                     merge-base --is-ancestor af55cbee afa5815a -> rc=0: dieses Worktree
                     liegt HINTER origin/development. Diese Datei ist neu und untracked,
                     kein Konflikt mit dem Rueckstand.

GEMEINSAME GRENZE ALLER 8 LENS-VERDIKTE UND DIESER SYNTHESE: seit dem PAT-Scrub (Task #75)
ist KEINE Pipeline-Abnahme moeglich. Jede Pipeline-Aussage in den Paketen (15666 "33/33
gruen", 15665-Zustaende) ist Protokoll des Bauenden, nicht unabhaengig geprueft. Das
betrifft 4 von 4 Paketen. Uebereinstimmung zweier Lenses ist hier KEIN Beleg -- beide
teilen dieselbe Blindstelle.

================================================================================
URTEILE AUF EINEN BLICK (Nenner: 4 Pakete)
================================================================================
  P-CI-SUPER (afa5815a, gelandet)  BLEIBT GELANDET. Folge-Commit PFLICHT: das Paar
                                   F1a+F1b schliesst die Fehlerklasse, die das Paket
                                   schliessen sollte, erst wirklich.
  P-CI-CE    (f528a4c7, gelandet)  BLEIBT GELANDET. Folge-Commit DRINGEND und VOR der
                                   naechsten gruenen test:unit-Pipeline: sonst wird
                                   test:coverage-guard nach Objektlage deterministisch rot.
  P-D37B     (a881d468, Gate)      NICHT LANDEN WIE VORGELEGT. Landefaehig nach N1-N3
                                   plus Bau-Pflicht L4. D3-7b bleibt auch danach OFFEN
                                   (Seite 1 von 3), bis super Seiten 2+3 landet.
  LEAD-SELBSTWARTUNG (68fbd930)    BLEIBT GELANDET. Folge-Commit F1-F4. Meta-Befund:
                                   das nie zweitgelesene LEAD-Paket trug 4 nachzieh-
                                   pflichtige Befunde und 1 widerlegte Unmoeglichkeits-
                                   Behauptung -- "Lead-Berichte nie uebernehmen" ist
                                   am Objekt erneut belegt.

================================================================================
1. PAKET P-CI-SUPER (afa5815a) -- BLEIBT GELANDET, FOLGE-COMMIT PFLICHT
================================================================================
Beide Lenses: BEREITS_GELANDET_MIT_BEFUND. Die Befunde decken sich im Kern (stilles
Gruen ueber leerem Bereich; Job-Variable per UI uebersteuerbar; Vorspann prueft Form,
nie Wert). Drei Differenzen waren aufzuloesen:

W1 -- WAS TUN BEI 0 COMMITS: Codex will den Zweig auf Abbruch (exit 2) stellen, mit
  main-Ausnahme "falls gewollt"; Meta haelt den blanken Abbruch fuer Dauer-Rot auf main.
  AUSSCHLAG (M3): workflow:rules der super-CI, letzte Regel "- if: '$CI_COMMIT_BRANCH'"
  -- der Job laeuft auf JEDEM Branch, auch auf main, und dort ist origin/main..HEAD
  legitim leer (dasselbe unmittelbar nach einem FF auf development). Der Bauende kannte
  den Fall (.gitlab-ci.yml:307-308 benennt ihn woertlich). ENTSCHIEDEN fuer die
  Meta-Form MIT Codex' Kern als Form-Anforderung: die zwei Nullen trennen.
    - HEAD IST der Stand der literalen Basis (main-Lauf, frisch-nach-FF): benannter
      SKIP mit literaler Aussage "geprueft wurde NICHTS", NICHT der heutige Durchfall
      zu "DIFF-HYGIENE-WACHE: GRUEN." (:581-583, M2).
    - 0 Commits gegen die gesetzte Basis in JEDER anderen Lage: Abbruch rc=2.
  Das ist zugleich das ce-Muster (Skip auf der Basis selbst, sonst harter Abbruch).

W2 -- GEGEN DIE UI-UEBERSTEUERUNG Wert-Check (Codex) oder Literal-Argument (Meta):
  AUSSCHLAG: GitLab-Praezedenz wirkt auf VARIABLEN, nie auf script-Text; und die Wache
  nimmt heute ausdruecklich kein Argument an (":339 Bereich SELBST bestimmt, nie
  uebergeben", M2). Beide Formen schliessen B2; das Literal-Argument im script-Block
  entfernt die Angriffsflaeche ganz statt sie zu bewachen -- BEVORZUGT, der harte
  Wert-Check ist die akzeptable Minimalform. OFFEN BENANNT: die Praezedenz selbst ist
  dokumentiertes GitLab-Verhalten, am Projekt 288 ohne PAT nicht messbar; hier machen
  BEIDE Lenses dieselbe (plausible) Annahme -- die Uebereinstimmung beweist nichts,
  das Literal-Argument ist gerade deshalb die robuste Wahl (haengt nicht an ihr).

W3 -- "DAS CE MACHT ES SCHON VOR": Codex hat es selbst korrigiert und meine Messung
  bestaetigt es (M4): die ce-Wache hat KEINEN --seit-basis-Modus (0 Treffer); ihr
  0-Commit-Abbruch (:353) sitzt in anderen Modi. Die super-Loesung ist zu BAUEN, nicht
  abzuschreiben. Das ist die seit Posten #77 offene Abschrift-Divergenz der zwei Wachen.

FOLGE-COMMIT (priorisiert):
  F1a Basis als Literal in den script-Text (Argument "--seit-basis origin/main" plus
      Wache argumentfaehig machen; Vorspann-Fetch-Zeile literal) ODER minimal: harte
      Wert-Pruefung im Vorspann. Nenner der betroffenen Stellen: 3 (:312, :323-324, :336).
  F1b Zwei-Nullen-Trennung in scripts/ci_diff_ascii_width_guard.sh:344-346 wie in W1
      entschieden. F1a+F1b sind EIN Paar: F1b allein macht den UI-Rueckfall rot,
      F1a allein laesst das stille Gruen fuer andere 0-Commit-Wege stehen.
  F2  T7 der Bissprobe (ci/tests/guard_basis_bissprobe.sh:374) prueft heute VORKOMMEN
      (Substring in der ganzen YAML, 1 Treffer); ein auskommentierter Aufruf zaehlte
      identisch. Gegen den Job-Block pruefen, wie es der GoogleTest fuer
      lint:diff-hygiene bereits tut (test_ci_wache_guard_basis.cpp:115).
  F3  Arm A der Bissprobe auf den gewuerfelten Koedernamen scharfstellen (heute nur
      rc=1 plus "ROT."-Literal -- jeder andere Verstoss faerbte identisch).
  F4  TEUERSTER UNGEMESSENER PUNKT (beide Lenses einig): der fail-closed-Vorspann wird
      von KEINEM Arm und keinem Test AUSGEFUEHRT. Ein Arm mit Wegwerf-Remote OHNE main,
      der den Fetch wirklich rot fallen sieht -- darauf ruht das Wort "fail-closed".
  Kleinposten: is_scoped filtert nur Endung/Basename (:392/:402, Fixture/Archiv rutscht
  in den Scope); Datei-Zaehler :356 ohne PIPESTATUS (K11-Muster im Bestand).

UNGEDECKT BLEIBT (auch nach diesem Review): Vorspann-Ausfuehrung bis F4; Pipeline 15666
(33/33 laut Protokoll) ohne PAT unbelegt; keine Wache bindet KUENFTIGE --seit-basis-
Aufrufstellen an den Vorspann (heute 1 Aufrufstelle, Deckung fest darauf verdrahtet).

================================================================================
2. PAKET P-CI-CE (f528a4c7) -- BLEIBT GELANDET, FOLGE-COMMIT VOR DER NAECHSTEN
   GRUENEN test:unit-PIPELINE
================================================================================
Beide Lenses: BEREITS_GELANDET_MIT_BEFUND -- aber mit UNGLEICHEN Befundmengen. Das ist
der lehrreichste Fall des Reviews: die Verdikte klangen einig, der schwerste Befund
stand nur in EINER Lens. Mehrheit oder Mittelung haette ihn verloren.

W1 -- DER SCHWERSTE WIDERSPRUCH: Codex sagt, die scharf geschaltete dritte Achse macht
  test:coverage-guard DETERMINISTISCH ROT (479 != 478); Meta kennt den Befund nicht und
  erwartet als ausstehende Abnahme die erste Ausgabe "GRUEN (N == N)".
  AM OBJEKT ENTSCHIEDEN FUER CODEX (M5, M6, M7):
    - .gitlab-ci.yml:511-512: build-covguard konfiguriert MIT -DCOMDARE_CE_PRUEFLINGE.
    - .gitlab-ci.yml:978: test:unit konfiguriert OHNE den Schalter; :507-508 sagt
      woertlich, dass diese Gegenrichtung BEWUSSTE T-4-Deckung ist.
    - scripts/ci_test_inventory_floor.txt:42/45-46/54-57: mit Schalter 479, ohne 478;
      das test:unit-Artefakt traegt 478 Namen (Nenner: ctest-Namen je Baum).
    - scripts/ci_test_coverage_guard.sh:818-831: JEDE comm-Abweichung setzt
      "ROT (N != M)" und CE_FREMD_ROT=1 (Exit-Klasse 4).
  FOLGE: sobald test:unit das naechste Mal gruen ist (erst dann laeuft der Guard, s. W2),
  faellt der Guard nach Objektlage rot -- auf GLEICHEM Host; auf verschiedenen Host-
  Klassen erst recht (floor :225-227: avx512f 479 / avx2 475 / basis 473). Metas
  Abnahme-Formulierung bleibt als Abnahme richtig, ihr erwartetes Ergebnis ist falsch.

W2 -- SCHEDULING-FIX: eigener Job fuer die Inventur-Kette (Codex) oder when:always am
  Guard (Meta). Beide diagnostizieren dasselbe Loch identisch: needs auf test:unit ohne
  eigenes when (selbst gemessen M8: 0 when/allow_failure/optional-Schluessel im Bereich
  :300-540) -> GitLab-Default on_success -> ein rotes test:unit SKIPPT den Guard und
  mit ihm alle 5 Wachen-Aufrufe seines script-Blocks (:363/:375/:381/Diff-Hygiene/:530).
  Der Job-Kommentar :346-348 verwechselt artifacts:when (Upload) mit Scheduling; Metas
  Live-Anker: in Pipeline 15665 (test:unit rot laut Protokoll) lief der Guard nicht.
  AUSSCHLAG fuer die KLEINSTE Form (Meta): die Inventur ist ctest-N-REGISTRIERUNG und
  wird VOR make check geschrieben (:995-1000, M5); das .test-Template veroeffentlicht
  sie when:always -- sie liegt also auch bei rotem test:unit vor. when:always am Guard
  macht die 5 Wachen wieder unbedingt, ohne neuen Job und ohne neuen Pipeline-Slot
  (Owner-Kanon: Pipelines streng sequentiell, kein zusaetzlicher Slot). Codex' Split
  bleibt die Ausweichform, falls when:always Nebenwirkungen zeigt.

W3 -- REIHENFOLGE (keine Lens-Differenz, aber die Synthese muss sie festhalten):
  F1 VOR F2. when:always ohne Operanden-Fix macht aus "jede gruene Pipeline rot am
  Guard" ein "JEDE Pipeline rot am Guard" -- die Kopplung ist heute zirkulaer: der
  rote test:unit verdeckt den Befund, der ihn melden koennte (Codex' Formulierung,
  am Objekt gestuetzt).

FOLGE-COMMIT (priorisiert):
  F1  Operanden der dritten Achse vergleichbar machen -- NICHT durch Abschalten:
      deklarierter SOLL-DELTA (die Testnamen des Blocks pruefling_slots_v1 als
      erwartete Nur-Hier-Menge; heute 1 Name, test_pruefling_fixture_ladung, floor
      :127) erhaelt BEIDE Zusagen: die T-4-Zwei-Zweig-Deckung UND den Nenner-Vergleich.
      Die Alternative "gleicher Bauweg" zerstoert die T-4-Gegenrichtung (:507-508) und
      widersprich dem eigenen Design; der Reparaturtext des Guards (:1101-1103) ist
      dann mitzuziehen.
  F2  when:always an test:coverage-guard plus Richtigstellung des Kommentars :346-348.
  F3  Host-Klasse in den Vergleich (Klassenleiter liegt versioniert in floor :225-227;
      bei Klassen-Differenz benannt abbrechen oder benannt skippen, nie still).
  F4  Stale OFFEN-Kommentar .gitlab-ci.yml:1002-1005 als [HISTORIE] markieren (selbst
      bestaetigt M5: er behauptet weiter "der VERBRAUCHER fehlt noch", 17 Kanten).
  F5  Wahrhaftigkeit der Wachen-Ausgabe (3 Stellen, alle Codex-gemessen): project:-
      needs werden als lokaler Jobname gelesen (Kopf verspricht "nicht bewertbar"-
      Ausweis, real UNAUFLOESBAR-Abbruch -- fail-closed, aber irrefuehrend); Top-Level-
      Nenner 32 statt 33 (stages-Regel frisst den Schluessel); ".pmc"-Expansion macht
      real 19 Kanten, nicht 18.
  F6  Blankes grep im Selbsttest (:83/:146) auf /usr/bin/grep bzw. awk (Hausnorm, die
      der Guard selbst zweimal begruendet umsetzt).
  EIGENER POSTEN (nicht dieses Paket): super-Schwester -- 45 needs-Zeilen ueber elf
  Stufen, KEINE Stufen-Topologie-Wache (Meta gemessen). Naechster Bau-Kandidat.

UNGEDECKT BLEIBT: die dritte Achse ist Ende-zu-Ende NIE gefahren (und wird nach W1 beim
ersten echten Lauf rot ausfallen -- das IST die ausstehende Messung); ob test:unit auf
development gerade gruen ist, ist ungemessen; die Leitung (Praefix-Zeile :529) hat
keinen Riegel -- faellt sie einem Refactoring zum Opfer, ist der Guard wieder gruen mit
"NICHT GEFAHREN" (Rueckfall-Flanke, nur Disziplin haelt sie); Allowlist bleibt eine
Abschrift eines beweglichen fremden Templates.

================================================================================
3. PAKET P-D37B (a881d468) -- DAS GATE: NICHT LANDEN WIE VORGELEGT
================================================================================
Beide Lenses: NACHBESSERN. Im Gate-Urteil besteht KEIN Widerspruch. Differenzen gab es
in der Sequenz (Codex: super-Haelfte "im SELBEN Atemzug"; Meta: erst Merge und
Kommentar-Fix, super als benannter Restposten) und im Gewicht der fail-closed-Frage.

URTEIL: NICHT LANDEN im vorgelegten Zustand. LANDEFAEHIG nach N1-N3 mit Bau-Pflicht L4.
Auch nach der Landung bleibt D3-7b OFFEN: dieses Paket ist Seite 1 von 3 (der
Wellenplan fuehrt D3-7b selbst dreiseitig); die Wirkkette bleibt tot, bis super
Seiten 2+3 landet.

  N1  MERGE VOR PUSH: 68fbd930 ist NICHT in a881d468 enthalten (selbst gemessen M9:
      is-ancestor rc=1, merge-base=669f1526). origin/development per Merge holen --
      nie rebase; trocken vorgemessen konfliktfrei (merge-tree rc=0, M9). Ohne N1:
      non-FF-Abweisung oder echter Verlust der 4 Upstream-Commits.
  N2  KOMMENTAR profile_run_entry.hpp:1272-1274 auf die SOLL-Form: die zwei
      IST-Behauptungen sind am Objekt widerlegt (M14, M10, M11): (a) "BEIDE ZUSAETZE
      ZUGLEICH KANN ES NICHT GEBEN" -- kein Riegel an keinem der drei Orte, der
      super-Host setzt beide Flags aus zwei unabhaengigen ENV-ifs (Meta gemessen);
      (b) "Der Marker faellt ... fail-closed aus" -- der Marker kennt das Token gar
      nicht (M10: 0 Treffer pruef-only in super, BEIDE Staende) und wuerde bei beiden
      Tokens provision_only RATEN, den WEICHEREN Modus (M11). Fail-closed gilt nur auf
      der Exit-Code-Ebene des Laufs (exit_code=1, am Objekt gelesen M14) -- der
      Kommentar behauptet es fuer die falsche Ebene. ZEMENTIERUNGS-GEFAHR ist der
      eigentliche Landeblocker: wer die super-Seite baut, liest "fail-closed ist
      schon da" und baut den Zweig nicht.
  N3  LANDEANWEISUNG korrigieren: Review-/Lande-Intervall ist 669f1526..a881d468
      (wahrer Gegenstand: 1 Datei, +12/-0, selbst gemessen M9). Das genannte
      68fbd930..a881d468 ist ein Divergenz-Artefakt (-704 Zeilen Scheinverlust).
  L4  NACH dem Merge: Vollbau nach J-1..J-4 plus Google Tests Debug UND Release vor
      dem Push. Grund: die Bau-Zahlen des Pakets (482 ctest, 479/480 make check) sind
      nicht mehr am Objekt belegbar (kein build-Verzeichnis im Worktree, beide Lenses),
      und der Merge holt 4 fremde Commits herein, darunter die mutmassliche (ungebaute)
      Heilung des einen gemeldeten Fehlschlags test_vs_taxonomie_klassen_grep.

WIDERSPRUCHS-AUFLOESUNG "SELBER ATEMZUG" GEGEN "SEQUENZ": AUSSCHLAG ist die gemessene
INERTHEIT der ce-Haelfte am Abnehmer (M10, M11): felder() erkennt nur "(provision-only)"
-- ein pruef-Lauf klassifiziert VOR wie NACH diesem Commit identisch als modus=voll,
und die Rot-Kette (mess_ausbeute :241-251: rot nur bei modus=voll und Summe<Mindest)
besteht heute schon, denn der Emitter setzt COMDARE_PRUEF_ONLY je Perm unbedingt.
Die ce-Haelfte zuerst zu landen ist also GEFAHRLOS (sie aendert am Abnehmer nichts)
und cross-repo-Atomik existiert ohnehin nicht -- Meta behaelt in der Sequenz recht.
Codex behaelt im KERN recht: D3-7b darf nirgends als erledigt gefuehrt werden; die
super-Seiten sind DIE naechste Landung derselben Welle, kein Irgendwann-Posten.

WAS DIE SUPER-SEITEN BAUEN MUESSEN (Seiten 2+3, aus beiden Lenses vereinigt):
  S2  ci/lauf_marker.sh: felder() um "(pruef-only)" erweitern; MODUS-Mapping
      pruef_only; fuer BEIDE Tokens zugleich ein echter fail-closed-Zweig (Abbruch,
      nicht raten) -- erst damit wird der ce-Kommentar aus N2 wahr.
  S3  ci/mess_ausbeute_wache.sh: beide Whitelists (:133 CLI, 4 Werte; :188 Marker,
      3 Werte) um pruef_only; eigener Urteils-Zweig (Warnung statt voll-Rot).
  S4  FORMAT-KOEDER beidseitig: die Bilanzzeile hat in ce 1 Produzenten und 0 Tests,
      die super-Probe testet gegen ein nachgebautes Log -- Drift faengt heute keine
      Maschine (beide Lenses; Werkzeug fehlt in beiden Richtungen).
  S5  Ausschluss-Riegel provision_only x pruef_only als Code (drei Orte: ce
      RunProfileArgs, ce Facade, super Host) statt Kommentartext an 3 Stellen.

UNGEDECKT BLEIBT: Bau-Zahlen bis L4 unbelegt; das CSV-trunc-Nebenrisiko (out_csv wird
mit ios::trunc geoeffnet BEVOR der pruef-Zweig zurueckkehrt -- ob der emittierte
S3-Pruef-Schritt je Perm auf denselben out_csv zeigt wie ein Mess-Schritt, ist nicht
verfolgt) ist ein EIGENER Posten; die super-Seiten sind in keinem der drei
super-Worktrees begonnen (Meta gemessen, von mir fuer 2 Staende bestaetigt M10).

================================================================================
4. PAKET LEAD-SELBSTWARTUNG (68fbd930) -- BLEIBT GELANDET, FOLGE-COMMIT F1-F4
================================================================================
Beide Lenses: BEREITS_GELANDET_MIT_BEFUND. Die Befunde sind fast vollstaendig
KOMPLEMENTAER (jede Lens fand, was der anderen fehlte) -- der Wert des Dual-Reviews
an einem Paket, das nie eine zweite Lens gesehen hatte. Zwei Aufloesungen:

W1 -- SHELL-KONTO: Codex laesst als Remedy "zweite Obergrenze ODER Kopf-Prosa" offen;
  Meta fordert die Ratsche (kShellObergrenze=3, EXPECT_LE). AUSSCHLAG ist der Vorfall
  selbst, am Objekt bestaetigt (M13): der switch zaehlt NUR Deckung::Keine in die
  gedeckelte Warteliste (:287-291), EXPECT_LE (:322) deckelt nur diese; das
  SHELL-Konto wuchs mit diesem Paket 2 -> 3 (Nenner: Tabellenzeilen Art::Wache mit
  Deckung::Shell), und NICHTS klapperte. Prosa haette wieder nicht geklappert ->
  RATSCHE. Dazu die Platzierung: der neue Eintrag steht in der UNGEDECKT-Sektion
  (:139-145, nach dem Kopf :132), gehoert in die SHELL-Sektion (:126-131).
W2 -- "KEIN GTEST MOEGLICH (Platte)": von BEIDEN Lenses unabhaengig widerlegt, mit
  ZWEI verschiedenen Werkzeugwegen (Codex: fertiges googletest unter /tmp/t1build,
  8 von 8 Faellen gruen; Meta: build-covguard lag konfiguriert im Worktree, 14
  Ninja-Schritte, beide ctest-Ziele, 29G frei). Konvergente Widerlegung aus
  unabhaengigen Messungen -- der staerkste Beleg des gesamten Reviews. Die
  Unmoeglichkeit war behauptet, nicht gemessen (Pruefung 3 und 4 verletzt).

FOLGE-COMMIT (priorisiert):
  F1  kKlassenUntergrenze 10 -> 11 (selbst bestaetigt M12: :316 traegt 10, der
      Kommentar :313 sagt "heute stehen (a)..(j) = 10 Klassen" -- die Liste traegt
      nach beiden Lens-Laeufen 11). Die Kontiguitaets-Pruefung (:326-334) faengt die
      Streichung der LETZTEN Klasse nicht; heute deckt das nur die zufaellige
      Aufruf-Stelle von (k). Die Ratsche ist der einzige handgepflegte Teil des
      Riegels -- sie MUSS im selben Commit mitwandern wie jede neue Klasse.
  F2  SHELL-Eintrag in die SHELL-Sektion verschieben + kShellObergrenze=3 mit
      EXPECT_LE analog :322 (W1).
  F3  Stale Prosa nachziehen, 4 Stellen: t6-Kopf :20-25 (richtig waere 12 von 22
      scripts mit 100644, 3 von 10 Wachen, Nenner 7 -- Codex nachgemessen),
      algo_semver.hpp:116 "(a)-(j)", taxonomie-Test :3 und :313 "(a)..(j)".
  F4  (k)-Prosa praezisieren: (a) ":86 ist hinter COMDARE_VERSION_HW_FLAG_ENFORCE
      gated" nachtragen (Listen-Konvention nennt gating bei (a)/(e)/(f) ausnahmslos);
      (b) "Registry = Identitaet, NICHT Erkennung" auf die gemessene Mechanik
      stellen: die Registry haelt die cpuid->Vendor-Zuordnung exklusiv und nennt
      ihre static_asserts selbst "Erkennungs-Anker"; der Planer misst nur den
      Rohstring und delegiert die Klassifikation zurueck.
  VORPRUEFUNG vor dem naechsten Vendoring-Zug: das super-Gegenorakel (D2-G5) auf
  einen 10er-Pin der Klassen-Leiter pruefen -- (k)=11 wandert sonst als Rot dorthin.

UNGEDECKT BLEIBT: Debug-Haelfte der Test-Doktrin (beide Lens-Laeufe waren Release
bzw. Fremd-Bau); CI-Gruen der Nach-Landungs-Pipeline (PAT); Substring-Match des
Riegels (block.find(basisname) -- eine kuenftige registry.hpp gaelte als benannt);
inhaltliche Wahrheit der Prosa von (a)-(j) ungeprueft -- die Stichprobe war 1 von 1
Beschreibung, und sie fand einen Fund.

================================================================================
5. DIE OFFENE ASYMMETRIE (ce bricht bei leerem Bereich ab, super bleibt gruen)
================================================================================
ENTSCHEID: AUS DEM BESTAND ENTSCHEIDBAR -- fuer die Mechanik ist KEINE Owner-Vorlage
noetig. Ein schmaler Rest dahinter ist Owner-Rang. Begruendung in vier Schritten:

(1) DIE FRAGE IST FALSCH GESTELLT: der Vergleich lief ueber zwei verschiedene MODI.
    Die ce-Wache hat keinen --seit-basis-Modus (M4, 0 Treffer); ihr Abbruch sitzt im
    --bereich- und Default-Modus. Es gibt also kein "ce sagt A, super sagt B" ueber
    denselben Gegenstand -- es gibt zwei NULLEN, die verschiedene Dinge bedeuten.
(2) DIE ZWEI NULLEN: "HEAD IST der Stand der Basis" (Lauf auf main; development
    unmittelbar nach FF) ist legitim leer -- es GIBT nichts zu pruefen. "0 Commits
    gegen eine gesetzte Basis in jeder anderen Lage" ist dagegen exakt die Signatur
    der Fehlerklasse dieses Pakets (verschobene Basis, stilles No-Op). Das ce trennt
    die beiden bereits (erklaertes Skip auf der Basis selbst, sonst Abbruch mit
    "es wurde NICHTS geprueft, also ist nichts bestanden").
(3) DER BESTAND ENTSCHEIDET DIE FORM: (i) Hausdoktrin "kein Erfolgs-Haken ohne
    literale Ausgabe" und "ein gruenes Gate deckt nur seinen Gegenstand" verbietet
    ein "GRUEN." ueber 0 gepruefte Zeilen -- der legitime Fall muss ein BENANNTER
    SKIP sein, kein Gruen-Durchfall; (ii) der Memory-Kanon "DIFF-HYGIENE misst
    PUSH-lokal, der main-FF ist das erste kumulative Gate, vor jedem FF die Wache
    ueber den FF-Bereich" liefert die Semantik; (iii) workflow:rules (M3) verbietet
    den blanken Dauer-Abbruch, weil der Job auf main laeuft. Der Merge aller drei
    ist genau die W1-Entscheidung von Paket 1: benannter Skip nur wenn HEAD die
    literale Basis ist, sonst Abbruch. Rangfolge geprueft: kein Owner-Wort steht
    dagegen, zwei Owner-Kanons stuetzen es.
(4) WAS OWNER-VORLAGE BLEIBT (schmal): nicht die Asymmetrie, sondern die kumulative
    Frage DAHINTER -- ob der FF-Bereich auf main ein ERZWUNGENES CI-Gate bekommt
    statt der heutigen Vor-FF-Pflicht von Hand. Am gleichen Baum steht development
    1 Zeile gruen gegen main 18.577 rot (Memory-Anker, Nenner: Verstoss-Zeilen der
    Wache): ein kumulatives main-Gate waere HEUTE rot und stellte "gesamte Pipeline
    immer hart gruen" gegen "Bestand invalidieren ist gewollt". Diese Kollision
    zweier Owner-Doktrinen entscheidet kein Bestandstext -- sie gehoert als kleine,
    praezise Frage in die Owner-Vorlage, NACH der Landung von F1a+F1b.

================================================================================
6. DECKUNGSBILANZ -- WAS AUCH JETZT UNGEDECKT BLEIBT
================================================================================
VOLL GEDECKT: 0 von 4 Paketen. Keines erfuellt alle vier Pruefungen einschliesslich
DECKUNG durch Werkzeug; die Luecken sind oben je Paket benannt und hier gebuendelt:

  QUERSCHNITT (trifft 4 von 4): Pipeline-Abnahme ist ohne PAT blind (Task #75).
  Alle CI-Gruen-Aussagen der Pakete sind Protokolle des Bauenden. Staerkster
  verfuegbarer Ersatz waren lokale Laeufe der Lenses -- Ersatz, kein Beleg.

  DISZIPLIN STATT WERKZEUG (6 benannte Posten, halten nur durch Verhalten):
    1. super Bilanzzeilen-Formatvertrag: 1 Produzent, 0 Tests, beidseitig (P-D37B S4).
    2. ce Stage-Allowlist: Abschrift eines beweglichen fremden Templates (P-CI-CE).
    3. Leitung der dritten Achse: Praefix-Zeile :529 ohne Riegel (P-CI-CE).
    4. SHELL-Konto ohne Ratsche, bis LEAD-F2 gelandet ist.
    5. super T7: Vorkommens- statt Wirksamkeits-Pruefung, bis SUPER-F2.
    6. Vorspann-Invariante: nichts bindet kuenftige --seit-basis-Aufrufe an den
       Vorspann (heute 1 Aufrufstelle).

  DIE TEUERSTEN UNGEMESSENEN PUNKTE JE PAKET:
    P-CI-SUPER: der fail-closed-Vorspann wurde NIE ausgefuehrt (F4).
    P-CI-CE:    die dritte Achse lief NIE Ende-zu-Ende -- und wird nach Objektlage
                beim ersten Lauf ROT ausfallen (das ist kein Gegenargument gegen die
                Landung, es ist die Begruendung fuer F1 VOR der Abnahme).
    P-D37B:     die Bau-Zahlen sind nicht mehr am Objekt (L4); die Wirkkette hat
                Werkzeug-Deckung erst mit S2-S4.
    LEAD:       Debug-Haelfte der Doktrin und die Prosa-Wahrheit von 10 der 11
                Klassen-Beschreibungen.

REIHENFOLGE-EMPFEHLUNG AN DEN LEAD (4 Positionen):
  1. P-CI-CE F1+F2 (vor der naechsten gruenen test:unit-Pipeline).
  2. P-CI-SUPER F1a+F1b (das Paar schliesst die Klasse des Pakets).
  3. P-D37B N1-N3+L4 landen; unmittelbar danach super S2+S3 als naechste Landung.
  4. LEAD F1-F4 plus Vendoring-Vorpruefung.

================================================================================
M. MESSUNGEN DIESER SYNTHESE (alle selbst gefahren, /usr/bin/grep absolut)
================================================================================
M1  Refs und Sauberkeit: siehe Stand-Anker oben (git rev-parse je Worktree; dirty-files
    je 0; Nenner: 4 Worktrees). Zusatz: merge-base --is-ancestor af55cbee afa5815a
    -> rc=0.
M2  super scripts/ci_diff_ascii_width_guard.sh gelesen: :344-346 nur HINWEIS bei 0
    Commits ("HEAD ist Vorfahr der Basis -- kein eigener Beitrag im Bereich");
    :581-583 'echo "DIFF-HYGIENE-WACHE: GRUEN." / exit 0'; :339 "Bereich SELBST
    bestimmt, nie uebergeben".
M3  super .gitlab-ci.yml:16-23 workflow:rules, letzte Regel "- if: '$CI_COMMIT_BRANCH'";
    :312 COMDARE_GUARD_BASIS_REF als Job-Variable; :323-328 Form-Pruefung ohne
    Wert-Pruefung; :307-308 "Auf main selbst ist der Bereich 0 Commit(s)".
M4  /usr/bin/grep -cF -e '--seit-basis' ce-Wache (wt-ce-stagetopo) -> 0 (rc=1);
    /usr/bin/grep -n 'NICHTS geprueft' -> :353 (Abbruchtext vorhanden).
M5  ce .gitlab-ci.yml gelesen: :511-512 (MIT Schalter), :978 (OHNE), :507-508
    (Gegenrichtung bewusst, T-4), :529-530 (Leitung), :346-348 (when-always-Irrtum),
    :351-354 (needs), :995-1000 (Inventur vor make check), :1002-1005 (stale OFFEN).
M6  floor gelesen: :42 "-> 479"; :45-46 "Ohne den Pruefling-Schalter sind es 2168
    Schritte und 478 Tests"; :54-57 Artefakt 478 Namen, byte-gleich; :225-227
    "avx512f 479 / avx2 475 / basis 473".
M7  ci_test_coverage_guard.sh:818-831 gelesen: comm-Abweichung -> "ROT (N != M)",
    CE_FREMD_ROT=1.
M8  sed -n '300,540p' ce-YAML | /usr/bin/grep -nE '^\s*(when|allow_failure|optional):'
    -> rc=1 (0 Treffer; Bereich deckt den Guard-Job-Block).
M9  git -C wt-ce-d37b: merge-base --is-ancestor 68fbd930 a881d468 -> rc=1;
    merge-base -> 669f1526; diff --stat 669f1526..a881d468 -> "1 file changed,
    12 insertions(+)"; merge-tree --write-tree 68fbd930 a881d468 -> rc=0.
M10 /usr/bin/grep -rnE 'pruef-only|pruef_only|PRUEF_ONLY' ueber ci/ + .gitlab-ci.yml
    -> rc=1 (0 Treffer) in wt-super-landung (af55cbee) UND wt-super-warn (afa5815a);
    Nenner: 2 gepruefte super-Staende.
M11 ci/lauf_marker.sh:177 erkennt nur "(provision-only)"; :238-239 MODUS=voll bzw.
    provision_only. ci/mess_ausbeute_wache.sh:132-133 Whitelist CLI (4 Werte),
    :187-188 Whitelist Marker (3 Werte), :241-251 rot NUR bei modus=voll und
    Summe<Mindest, :253 Warnung sonst.
M12 test_vs_taxonomie_klassen_grep.cpp:316 kKlassenUntergrenze=10; :313 Kommentar
    "heute stehen (a)..(j) = 10 Klassen"; :326-334 Kontiguitaet faengt nur Luecken,
    nicht die Streichung der letzten Klasse.
M13 test_t6_wachen_inventar.cpp: :126-131 SHELL-Sektion (2 Eintraege), :132
    UNGEDECKT-Kopf, :139-145 neuer SHELL-Eintrag darunter (3. SHELL-Eintrag);
    :287-291 switch zaehlt nur Deckung::Keine in die Warteliste; :322 EXPECT_LE
    nur auf die Warteliste.
M14 git show a881d468:...profile_run_entry.hpp, Bereich :1265-1300 gelesen:
    Kommentar "BEIDE ZUSAETZE ZUGLEICH KANN ES NICHT GEBEN ... Der Marker faellt
    fuer den Fall trotzdem fail-closed aus" steht literal am Objekt; der
    pruef_only-Zweig setzt exit_code=(any_pruef_ok>0 && any_pruef_failed==0)?0:1.

NICHT VON MIR NACHGEMESSEN (uebernommen mit Quelle): GoogleTest-/Bissproben-Laeufe der
Lenses; Pipeline-Protokolle; die Zaehlungen 69 Commits/7962 Zeilen (beide Lenses
uebereinstimmend am selben Anker afa5815a); Metas Fund super main.cpp:1377-1389
(zwei unabhaengige ENV-ifs); Codex' 22/12/10-Zaehlung der scripts-Modi.

SELBSTCHECK (nach dem Schreiben gefahren, literal): LC_ALL=C /usr/bin/grep -nP
'[^\x00-\x7F]' <diese Datei> -> ascii-rc=1 (0 Treffer); awk 'length>120' -> 0 von
408 Zeilen ueber 120 Zeichen.
