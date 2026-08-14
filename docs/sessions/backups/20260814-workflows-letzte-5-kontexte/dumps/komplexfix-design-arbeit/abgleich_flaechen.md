# PRUEFER HARMONISIERUNGS-FLAECHEN (A2.1b) -- ABGLEICH AM OBJEKT
# Stand der Messung: 2026-08-14 06:37-06:52 UTC (Fable 5 max; Repos strikt read-only)

## 0. GRUNDLAGE UND LAGE-VERSCHIEBUNG

QUELLEN: 13 von 13 leser-Dateien vorhanden (leser_01..leser_12 + leser_kern.md,
23218 Zeilen gesamt; keine Luecke). leser_kern.md (1658 von 1658 Zeilen) VOLL
gelesen -- es traegt die Sammelliste A.1-A.6 verbatim (205 von 205 Quellzeilen)
plus alle Wellen-Dumps. leser_01..12 (21560 Zeilen) vollstaendig struktur-
gesichtet (Ueberschriften-Map je Datei) + flaechenrelevante Regionen per
Schluesselwort-Extraktion (65,8-KB-Trefferliste) tiefgelesen; die Substanz zu
A1-A6 liegt in leser_kern (Findings 1-6/44-59/61/64, s7_dump, wachen_dump,
pause3); leser_02/03/05/07/09/10/12 liefern Historie (KON55-Genese, Exit-3-
Semantik, Floor-Generationen 488/489, Landekette-Doktrin).

[ROT] LAGE-VERSCHIEBUNG WAEHREND DER MESSUNG: die Drei-Stufen-Landung Stufe 1
laeuft LIVE in dieser Session. Belegte Bewegung im Messfenster:
  ce  development: 5f3f26a5 (== origin) -> 0304ebf1 (06:37Z, S-7+Wachen gemergt)
      -> a6804dfa (06:50Z, p6 gemergt); jetzt 11 von 11 Commits vor origin.
  super development: 865ff21d (06:40Z, F1 gemergt; 15 vor origin) -> ad742bdc
      (06:50Z, texgate dbef5b0f + e21 ad742bdc gemergt; 24 von 24 vor origin).
Alle SHAs/Zahlen unten tragen ihren Mess-Ref; der Komplex-Fix misst je Stufe
FRISCH nach (Finding 43; Drift-Beleg L1: 8 -> 10 -> 15 -> 24 super-Commits in
vier Quellen-Generationen).

Merge-Reihenfolge am Objekt == PAUSE-3-Order: ce S-7 (d215b127) -> Wachen
(0304ebf1) -> p6 (a6804dfa) -> [XML-Regen FEHLT]; super F1 (865ff21d) ->
texgate (dbef5b0f) -> e21 (ad742bdc). Beide seriell --no-ff.

================================================================================
## A1. tests/unit/CMakeLists.txt-Tails (S-7 x Wachen x NEU p6)
================================================================================

OBJEKTBEFUND JETZT:
- S-7 (5f3f26a5..178bb1fb): +40 Zeilen, 0 Loeschungen, EIGENER Block am
  DATEIENDE (Hotspot-Regel KON58-10 im Block-Kommentar; Namenskonvention
  test_stempel_*, NIE test_s7_*). Zwei neue Registrierungen:
  test_stempel_vollbestand_registry + test_stempel_zulassung_bruecke.
- Wachen (5f3f26a5..07a60cc7): 0 Diff-Zeilen an der Datei (Finding 54/
  wachen_dump 8 am Objekt bestaetigt).
- p6 (95cb3039..f6d13dfb): +13 Zeilen MITTIG (Region um :6660, zwischen den
  t6-Biss-Bloecken) -- neue unbedingte Registrierung test_lizenz_konsistenz.
  Diese dritte Beruehrung stand in KEINER Sammellisten-Zeile zu Flaeche 1.
- Merge-Resultat: 0304ebf1 byte-identisch zu 178bb1fb an der Datei (0 Diff-
  Zeilen); a6804dfa traegt beide Bloecke. Duplikat-Pruefung am Gesamtstand:
  231 comdare_add_test-Registrierungen, 0 Duplikat-Namen (uniq -d leer);
  test_lizenz_konsistenz genau 1 von 231.

KLASSIFIZIERUNG: Sammelliste A.1 = BEHOBEN@d215b127+0304ebf1+a6804dfa
(Auto-Union gegenstandslos: disjunkte Regionen Dateiende/mittig/0; semantische
Pruefung 0 Duplikate bei Nenner 231 erbracht). Finding 54 (CMakeLists-Teil)
BEHOBEN; wachen_dump 8 BEHOBEN.

HARMONISIERUNGS-ANWEISUNG (Rest):
Nach dem noch ausstehenden 4. ce-Posten (XML-Regen, s. A4/A5) einmalig
wiederholen und literal protokollieren:
  git show <ce-HEAD>:tests/unit/CMakeLists.txt | /usr/bin/grep -oE
  'comdare_add_test\([a-z0-9_]+' | sort | uniq -d   => SOLL leer;
  Zaehlung SOLL 231 von 231 (230 vor p6 + 1 p6). Kein weiterer Eingriff.

================================================================================
## A2. Floor EINMAL live: scripts/ci_test_inventory_floor.txt
================================================================================

OBJEKTBEFUND JETZT:
- 178bb1fb (S-7): UNTERGRENZE-Kopf, Werte 491/487/485, Messblock 'S-7-ABNAHME',
  317 Zeilen. 07a60cc7 (Wachen): ANKER-Kopf (exakt, Exit 4 BEIDSEITIG,
  Nachzug-Pflicht im SELBEN Change), Werte 489/485/483, 300 Zeilen.
- Merge 0304ebf1: ECHTE HARMONISIERUNG, kein Auto-Union: ANKER-Kopf (Wachen) +
  Werte 491/487/485 + S-7-Messblock + volle HISTORIE-Kette (489/485/483
  P1+P11; 488/484/482 S-3; 2026-08-10), 330 Zeilen. Merge-Botschaft verbatim:
  'Geteiltes Zaehlwerk ... wird NICHT per Delta addiert, sondern im
  Floor-Nachzug am Gesamtstand LIVE neu gemessen (eigener Commit).'
- [ROT] ce-HEAD a6804dfa traegt WEITER 491/487/485, aber p6 hat
  test_lizenz_konsistenz UNBEDINGT registriert (+1 auf ALLEN drei Klassen;
  p6-Diff enthaelt die Floor-Datei NICHT). Der ANKER-Guard (Exit 4 beidseitig,
  seit 0fbcb049) reisst damit am Gesamtstand: Inventur UEBER der Zeile.
  Der im Merge-Text zugesagte Nachzug-Commit existiert noch nicht (0 Commits
  nach a6804dfa).

KLASSIFIZIERUNG: Sammelliste A.2 = TEILWEISE BEHOBEN@0304ebf1 (S-7-x-Wachen-
Kollision aufgeloest, S-7-Stand gewann, ANKER-Semantik uebernommen) + OFFEN
(Live-Messung am Gesamtstand + p6-bedingter Nachzug fehlen). Finding 54
(Floor-Teil) BEHOBEN; s7_dump 3 BEHOBEN@ec3c71fa, Merge-Messung OFFEN.
KOLLISION NEU (nicht in der Sammelliste): p6 x Wachen-ANKER-Floor.

HARMONISIERUNGS-ANWEISUNG:
1. Am FINALEN ce-Gesamtstand (nach XML-Regen-Probe, s. A4/A5) EINMAL live
   messen, exakt nach Datei-Kopf-Rezept (build-covguard KALT, Pruefling-
   Schalter, make inventar, ctest -N | sort -u | wc -l; Klassen per
   cmake -D...=0 erzwingen, danach cmake -U beide Variablen; comm in BEIDE
   Richtungen). ERWARTUNG: 492/488/486 (= 491/487/485 + 1 unbedingte
   p6-Registrierung; Sprossenabstaende -4/-2 bleiben). Es gilt das LITERAL
   der Messung, nie diese Vorhersage.
2. Nachzug ALLER DREI Zahlen als eigener, sichtbarer Commit VOR dem Push
   (der Guard prueft den BAUM; ANKER-Doktrin verlangt den Nachzug im selben
   Change wie die Registrierung -- die Registrierung kam per Merge, also ist
   der unmittelbar folgende Nachzug-Commit die deklarierte Form; Merge-
   Botschaft 0304ebf1 hat genau das angekuendigt). Messblock im Datei-Kopf
   auf 'GESAMTSTAND Stufe-1-Landung <SHA>' fortschreiben, 491er-Block in die
   HISTORIE.
3. NIE Deltas addieren: 491 und 489 sind zwei AUSGANGSSTAENDE, keine
   Summanden; die 492 ist erst nach Live-Beleg gueltig.

================================================================================
## A3. Wachen-Inventar-Nenner: test_t6_wachen_inventar gegen CI-YAML
================================================================================

OBJEKTBEFUND JETZT:
- ce .gitlab-ci.yml: 0 Diff-Zeilen ueber 5f3f26a5..a6804dfa (S-7 0, Wachen 0,
  p6 0 von 44 Dateien -- YAML nicht in der p6-Liste). t6 am Gesamtstand traegt
  den Nenner '25 Top-Level-Jobs von 33 Schluesseln (5 reserviert, 3 Templates,
  alle 33 Block-Form)', kJobTabelle 28 Zeilen, S-14a-Riegel
  (contract:axis-version-lock) gedeckt, Scanner gehaertet fail-closed
  (07a60cc7). Der neue p6-ctest ist KEIN CI-Job -> Nenner unberuehrt.
- super .gitlab-ci.yml: +95/-28 Zeilen ueber origin/development..ad742bdc
  (u.a. 83e06159 NE-20 + texgate) -> der super-Meta-Gate-INVENTAR-Nenner
  (58b5aff4: M=26, 13 gefahren / 13 begruendet ausgeschlossen) ist am
  Push-Stand NEU zu enumerieren (Finding 3).

KLASSIFIZIERUNG: Sammelliste A.3 ce-Seite = BEHOBEN/BESTAETIGT am Objekt
(t6-Nenner traegt am Gesamtstand; Beweis-Vollzug laeuft im A5-Kombibau mit).
super-Seite = OFFEN (Neu-Enumeration am Push-Stand). Finding 27 (NE-16 lief im
Wachen-Paket) BEHOBEN@6eb72ace. Finding 26/28(b,c) (ce-Fassung
vor_push_alle_wachen INVENTAR-Modus, arm64-smoke :257 / relock :919-Triage) =
NICHT-MEIN-STRANG (ce-Pruefer / nach der Welle; wachen_dump 4).

HARMONISIERUNGS-ANWEISUNG:
1. ce: kein Eingriff; t6 laeuft im A5-Kombibau (4 von 4 Zellen) mit --
   4/4-t6-Faelle als Literal-Beleg zitieren.
2. super: VOR dem Push scripts/vor_push_alle_wachen.sh (INVENTAR-Modus,
   Diff-Hygiene ueber --bereich origin/development HEAD, Form 1e31cd4b)
   fahren; M am Objekt frisch zaehlen (Ausgangswert 26; YAML-Wachstum +95/-28
   kann M heben) und JEDE neue Zeile entweder fahren oder begruendet
   ausschliessen -- Bilanz 'X gefahren / Y ausgeschlossen / M gesamt' literal.

================================================================================
## A4. Lock-Regen: Overlay-Quellmenge (kOverlaySourceSet, 718 Records)
================================================================================

OBJEKTBEFUND JETZT (Schnitt beruehrte Dateien x 718er-Preimage-Menge):
- S-7: 0 von 8 Dateien -- NULL-BEWEIS kryptographisch (check GRUEN, --write
  diff-leer; s7-riegel-echtfall-20260813.log), Lock-sha256 e7263b82... an
  a6804dfa UNVERAENDERT gegen 5f3f26a5 (selbst nachgemessen).
- Wachen: 0 von 4 Dateien (scripts/ + tests/unit/, keine im Schnitt).
- p6: 0 von 44 Dateien. Verdachtstreffer 'rcu.hpp' aufgeklaert: die 2
  Lock-Records sind axis_08_concurrency_rcu.hpp (axes/concurrency_axis/ +
  topics/concurrency/), NICHT p6s reclamation/rcu_reclaim/rcu.hpp. p6-Pfade
  (api/, hbm/, indexes/, reclamation/, succinct/, builder/, tools/, apps/)
  liegen ausserhalb der Schnitt-Praefixe (organ: axes/+topics/-Homes; system/
  mess: include/cache_engine/measurement/-Praefixdateien; tier_substanz:
  anatomy/; heuristik).
- XML-Regen (N1): .xml steht in kNichtQuellEndungen (BEWUSST DRAUSSEN) ->
  kein Lock-Effekt.
- Lock am Gesamtstand: 2181 Zeilen / 718 Records, v3.

KLASSIFIZIERUNG: Sammelliste A.4 = ENTLASTET/UEBERHOLT am Objekt (die
Praemisse 'S-7-Regen (Lock v3) gegen den Wachen-Branch' traf nicht ein: KEIN
Strang beruehrt die Preimage-Menge, 0 von 56 beruehrten Dateien ueber alle
drei Straenge). Finding 45 (landender Riegel-Echtfall) = NICHT-MEIN-STRANG
(W1-Bump-Buendel, Owner-Frage D4, Kenntnisnahme).

HARMONISIERUNGS-ANWEISUNG:
1. KEIN Lock-Regen. Stattdessen am FINALEN Gesamtstand EINMAL
   comdare_axis_version_lock --check fahren (Werkzeug per J-1 bauen) und das
   Literal protokollieren: SOLL GRUEN mit '718 Dateien ... deckt 712 von 712
   Overlay-Quellen' + Lock-sha256 e7263b82... unveraendert.
2. Exit-Semantik im Protokoll fuehren: 0 gruen / 1 Digest ohne Bump / 2
   Struktur-Verletzung / 3 REGEN ERFORDERLICH (akzeptierter Bump ohne Regen
   ist seit b12afd32 NIE mehr gruen). Faellt der Check wider Erwarten NICHT
   auf 0: Ursache am Objekt klaeren (welche Datei, welche Kategorie), NIE
   blind --write -- ein --write ohne verstandene Ursache ist genau das
   Bump-Dauerloch, das Exit 3 schliesst.

================================================================================
## A5. Kombibau am Gesamtstand (KON55: gcc/clang x Debug/Release)
================================================================================

OBJEKTBEFUND JETZT:
- S-7-Eigen-Kombibau-Belege GELESEN (Finding-44-Kommando ausgefuehrt):
  4 von 4 Logs s7fix-{gcc-rel,gcc-dbg,clang-rel,clang-dbg}-ctest.log je
  '100% tests passed, 0 tests failed out of 490' (Stand 178bb1fb).
  L3 BESTAETIGT: s7fix-kombibau-master.log endet OHNE Schlussbilanz
  (letzte Zeilen J-1/J-2 rc=0; Erstfahrt per setsid-Neustart abgeloest);
  das 'ENDE fail=0' steht im REST-Log: s7fix-kombibau-rest-master.log
  'S7FIX-KOMBIBAU-REST ENDE fail=0 2026-08-13T14:58:42' -- beide Logs
  gehoeren zusammen zitiert.
- Wachen-Eigen-Kombibau: 4 Zellen je 488/488 auf 07a60cc7 (Quittung
  wachen_dump 1; Deklaration 'EIN Kombibau auf dem Gesamtstand beider
  Commits' = Finding 58, durch DIESE Flaeche gedeckt).
- Am ZUSAMMENGESETZTEN Stand (a6804dfa bzw. final) lief noch KEIN Kombibau
  (0 von 4 Zellen); Bauverzeichnisse geraeumt, df zeigt 37G frei (>8G-Gate).
- Vorbedingungs-Kette am Objekt: Floor-Nachzug fehlt (A2), XML-Regen-Frage
  offen (N1/Finding 61: Drift gemessen am aelteren super-Pin; ob der HEUTIGE
  ce-Code die committete cache_engine_axis_registry.xml reproduziert, ist am
  Gesamtstand UNGEMESSEN -- 178bb1fbs 490/490 spricht dafuer, dass die
  ce-Seite gruen ist, beweist es aber nur, falls der Roundtrip-Test in den
  490 enthalten war).

KLASSIFIZIERUNG: Sammelliste A.5 = OFFEN (Pflicht vor Push). Finding 44 [ROT]
= SOLL-Seite BEHOBEN (Belege gelesen, 4x490 + REST-ENDE fail=0), formale
Lead-Lesung damit VOLLZOGEN -- als BEHOBEN mit diesem Protokoll fuehren.
Finding 58 BEHOBEN (per Deklaration + diese Flaeche). Finding 49 (d2-Flaky
1 von 490 unter Volllast) = BEOBACHTEN im Kombibau. Finding 53/64 (N3,
EXCLUDE_FROM_ALL) = in die Anweisung uebernommen. Finding 61 [ROT] = OFFEN
(ce-Seite, VOR dem Push).

HARMONISIERUNGS-ANWEISUNG (Reihenfolge bindend):
1. XML-Regen-PROBE ZUERST (entscheidet den Endstand): 2-Pass-Bau
   comdare_axis_registry_gen fahren, XML regenerieren, git diff auf
   libs/cache_engine/algorithm_profiles/cache_engine_axis_registry.xml.
   Diff leer => N1 war Artefakt des aelteren super-Pins, KEIN ce-Commit
   (Beleg literal '0 Zeilen Diff'); der super-seitige Roundtrip heilt mit dem
   Gitlink-Bump. Diff nicht leer => XML-Commit als 4. Lande-Posten
   (PAUSE-3-Order), DANN erst weiter.
2. Floor-Nachzug nach A2 (eigener Commit, Live-Messung 492/488/486 erwartet).
3. DANN EIN Kombibau, 4 Zellen SEQUENTIELL (PIPELINES STRENG SEQUENTIELL,
   sonst OOM) auf dem finalen SHA: gcc-15 + clang 22.1.8 x Debug + Release,
   je offizieller Weg J-1..J-4 (Werkzeuge zuerst: comdare_adhoc_emitter_cli,
   comdare_anatomy_codegen_cli, alle *_registry_gen -> RE-CONFIGURE ->
   Vollbau -> volle ctest-Suite). EXCLUDE_FROM_ALL-Ziele explizit bauen
   (test_profile_roundtrip; blankes ctest im ungebauten Baum ist als
   Vollgruen-Gate ungeeignet -- N3/886-mit-474-NotRun-Falle).
4. Abnahme LITERAL je Zelle: '100% tests passed, 0 tests failed out of N'
   -- Erwartung N=491 (490 am 178bb1fb + 1 p6-Registrierung); zaehlt das
   Objekt anders, gilt das Objekt und der Grund ist zu benennen. t6- und
   lizenz-Wache laufen darin mit (Deckung A3; test_lizenz_konsistenz ist am
   Gesamtstand gruen zu erwarten: 20 von 20 neuen Quelldateien seit p6-Basis
   tragen KEINEN SPDX-Kopf, der Guard reisst nur bei FREMDEM Bezeichner
   ausserhalb ext/ -- Sanity 'eigen > 30' traegt ueber p6s 36 Koepfe).
5. Flankierung: Platten-Waechter VOR den Bauten neu starten (PAUSE-3 Posten;
   df-Gate >8G je Zelle; aktuell 37G frei); test_d2_abdeckungs_wache_nenner
   bei Einzel-Rot unter Volllast einmal isoliert wiederholen (Finding 49,
   Praezedenz 1 von 490); Raeumen mit Belegpruefung 0/0 nach Abschluss.

================================================================================
## A6. Push-Bereich: git log origin/development..HEAD BEIDER Repos
================================================================================

OBJEKTBEFUND JETZT (06:50Z):
- ce: origin/development 5f3f26a5; development a6804dfa; 11 von 11 Commits im
  Push-Bereich = 7 Branch-Commits (S-7 3: 548fecd2+ec3c71fa+178bb1fb; Wachen
  4: 092ab7e9+6eb72ace+0fbcb049+07a60cc7) + 3 Merges (d215b127, 0304ebf1,
  a6804dfa incl. p6 f6d13dfb) + p6-Inhalt. NOCH NICHT im Bereich: Floor-
  Nachzug-Commit (A2), ggf. XML-Regen-Commit (A5.1).
- super: origin/development a103e518; development ad742bdc; 24 von 24 Commits
  = 8 Luecken/Fix (76a345e3..f3017a77) + PAUSE-2-Doku + F1-Paket 4
  (915038ca+c134b70a+ff9a517b+8e9a31d2) + Sammelrunde fa75d47c + 3 Landungs-
  Merges (865ff21d F1, dbef5b0f texgate, ad742bdc e21) + deren Branch-Commits
  (texgate 4, e21 3). Designs publiziert: 2 von 2 (docs/plaene/20260813-
  DESIGN-g1-...md + -zielstruktur-vier-traeger-unterprojekte.md).
- Gitlink am super-HEAD: 5f3f26a5 (KEIN Bump -- korrekt, ce ist ungepusht).
- Ledger-Kopf = KON59 (Z.19); KON60 nirgends vergeben (0 Treffer in der
  a1-Vorlage; L5-Pruefung: kein Doppel, Luecke erklaert -> KON60 ist frei
  fuer den Lande-Nachtrag).
- BU-SOFORT offen: /tmp/a25_wachen_fix/ (Manifest + Logs) liegt NUR in /tmp;
  docs/sessions/backups/ traegt dafuer 0 Eintraege (juengster: 20260813-
  luecken-und-vollstaendigkeit). Ebenso ist das regressions-gesamtbild als
  Backup-Posten vorgemerkt (00-index 1).
- texgate x F1 an ci/anhang_forward_core.sh: im Merge dbef5b0f laut
  Botschaft 'HARMONISIERUNG der Kopfblock-Anker' aufgeloest -- die [ROT]-
  Auflage Finding 40 (11 CI-INV-Kopfzahlen am GEMERGTEN Stand nachmessen,
  Werkzeug /tmp/texgate_fix) bleibt als Nachmess-Pflicht im Push-Vorlauf.

KLASSIFIZIERUNG: Sammelliste A.6 = IN ARBEIT/OFFEN (Merges vollzogen; Push-
Vorlauf-Pflichten offen). Finding 39 BEHOBEN@dbef5b0f (texgate gelandet);
Finding 8 BEHOBEN@865ff21d (F1-Merge konfliktfrei vollzogen); verify_dump 29
Landung BEHOBEN@ad742bdc; Finding 17 BEHOBEN (Designs publiziert); Finding 11
OFFEN (KON60-Nachtrag); Finding 55 OFFEN (BU a25_wachen_fix); Finding 40 [ROT]
OFFEN; Finding 34/23 (Umbrella-CI) = NICHT-MEIN-STRANG (Owner-Frage C2).

HARMONISIERUNGS-ANWEISUNG (EIN Push je Repo, EINE CI):
1. ce-Push erst nach A2-Nachzug + A5-Kombibau; Bereich dann FRISCH zaehlen
   (11 + 1 Floor + 0..1 XML + 0..n Komplex-Fix-Commits). Diff-Hygiene-Wache
   PUSH-LOKAL ueber origin/development..HEAD (nie kumulativ).
2. super-Push-Vorlauf: (a) KON60-Ledger-Nachtrag via scripts/ledger_nachtrag.sh
   (Inhalte laut Findings 11/46/30/32: e21-ledger_vorschlag, NE-10-Korrektur
   126/83, KON59-02-Anker :919/:2809, Zaehlwerke); (b) BU-SOFORT
   /tmp/a25_wachen_fix -> docs/sessions/backups/ additiv + regressions-
   gesamtbild-Backup, je mit beissendem gitleaks-Koeder (glpat-+20 aus
   wirksamer Config, rc=1-Beweis; AWS-Koeder beissen NICHT); (c) Finding-40-
   Nachmessung der 11 CI-INV-Kopfzahlen am gemergten Stand; (d) Meta-Gate
   INVENTAR-Neu-Enumeration (A3.2). Dann EIN Push.
3. Kette streng seriell: ce-Push -> ce-CI TERMINAL SUCCESS (nie parallel
   weiterarbeiten; Landekette-Doktrin: Gitlink-Bump 31s nach ce-Push war der
   wirksamste Einzelfehler des 06.08.) -> Gitlink-Bump 5f3f26a5 -> <ce-final>
   ATOMAR mit PZW-Fussnote (finale Floor-Werte + Merge-SHAs d215b127/
   0304ebf1/a6804dfa + Kombibau-Bilanz gehoeren hinein) -> super-Push ->
   super-CI gruen. PZW-Wache laeuft im super-CI mit (5 von 5 Schema-Stellen).
4. Nach beiden Pushes: Haupt-Klon-ce-Store fetchen (L4: p6-Fetch-Auflage und
   staler Store f23c18e2 sind DERSELBE Store -- ein fetch heilt beides,
   danach 4-Klone-Sync pruefen).

================================================================================
## KOLLISIONS-REGISTER (Flaeche, Straenge, Status)
================================================================================
K-1 Flaeche 2 (Floor-Datei): S-7 (Werte 491/487/485) x Wachen (ANKER-Kopf,
    489/485/483) -- AUFGELOEST im Merge 0304ebf1 (Kopf Wachen + Werte S-7 +
    Historie); Live-Bestaetigung am Gesamtstand offen.
K-2 Flaeche 2 (Floor-Datei): p6 (+1 unbedingte Registrierung
    test_lizenz_konsistenz) x Wachen-ANKER (Exit 4 beidseitig) -- OFFEN:
    ce-HEAD a6804dfa traegt 491/487/485, SOLL nach Live-Messung 492/488/486;
    ohne Nachzug-Commit reisst der Guard am Gesamtstand. NEU, in keiner
    Sammellisten-Zeile.
K-3 Flaeche 1 (CMakeLists): S-7 (Dateiende) x p6 (mittig :6660) -- AUFGELOEST
    durch disjunkte Regionen im Merge a6804dfa; 0 Duplikate bei 231.
K-4 Flaeche 5/N1: XML-Regen-Frage x Kombibau-Reihenfolge -- OFFEN: Regen-Probe
    MUSS vor dem Kombibau laufen, sonst misst der Kombibau einen
    Nicht-Endstand (Anweisung A5.1).
K-5 super ci/anhang_forward_core.sh: texgate x F1 -- AUFGELOEST im Merge
    dbef5b0f ('HARMONISIERUNG der Kopfblock-Anker'); Finding-40-Nachmessung
    der 11 Kopfzahlen bleibt offen.

## RESTLISTE FUER DEN DESIGNER (meine Flaechen, kompakt)
OFFEN vor ce-Push: Floor-Live-Messung + Nachzug-Commit (K-2) | XML-Regen-Probe
mit 2-Pass-Diff (K-4) | Kombibau 4 Zellen final (A5.3-5) | Lock --check-Beleg
712/712 (A4.1) | A1-Duplikat-Wiederholung (billig).
OFFEN vor super-Push: KON60-Nachtrag | BU a25_wachen_fix + Gesamtbild |
Finding-40-Kopfzahlen | Meta-Gate-INVENTAR M frisch | Diff-Hygiene push-lokal.
DANACH: ce-CI gruen -> Gitlink-Bump+PZW atomar -> super-CI gruen ->
Haupt-Store-Fetch (L4).
NICHT-MEIN-STRANG (an die Schwester-Pruefer): Findings 26/28 (ce-Wachen-
INVENTAR-Modus, allow_failure-Triage :257/:919), 45/D4 (landender
Riegel-Echtfall, W1), 34/C2 (Umbrella-CI), 56 (super-Wachen-Aequivalente),
Pausen-Sorgfalt P1-P4 (eigener Pruefer).

SELBSTCHECK: ASCII-only geprueft (LC_ALL=C, Muster [^\x09\x0A\x20-\x7E],
SOLL 0 Treffer); 6 von 6 Flaechen mit Objektbefund JETZT + Anweisung; jede
Zahl mit Nenner oder Mess-Ref; keine Platzhalter; Schreibort nur
komplexfix_design_arbeit/; Repos ausschliesslich lesend beruehrt.
