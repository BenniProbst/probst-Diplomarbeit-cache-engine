# KOMPLEX-FIX DESIGN (v4.3/A2.1b Stufe 2) -- Auftragsdokument fuer den Komplex-Fix-Workflow
# Erstellt: 14.08.2026 frueh, DESIGNER-Phase des KOMPLEX-FIX-DESIGN-Workflows (wf_3b74b5cc-5c5-Familie)
# FIX-RUNDE 14.08. (gleiche Familie): Pruefpunkt-2-Nachlese #99-#103 (Deckung 152/152),
# Floor-Form-Korrektur #47/A2/P1 (:25-33 statt :22-28; 'eigener Commit' ENTFALLEN per :35-41),
# S3.5 um #15/#16/#34 (Dispositions-Pflichtzeilen) + #99d/#101b ergaenzt.

## KOPF

ZWECK: Dieses Dokument faellt dem KOMPLEX-FIX-WORKFLOW zu. Er laeuft NACH den seriellen
Merges der Drei-Stufen-Landung (Stufe 1, vollzogen) auf dem ZUSAMMENGESETZTEN Stand
BEIDER Repos und VOR dem einen Push je Repo (Stufe 3). Er fixt/verifiziert; das Design
selbst hat NICHTS gebaut. Owner-Order 13.08. (praezisiert): Tieflesen/Einlesen-Subagenten
= Fable 5 XHIGH; Analyse/Auswertung/Review/Fix am Ende = Fable 5 max. Owner-GO liegt vor:
Drei-Stufen-Landung + Komplex-Fix + F1-Echtlauf NACH grossem Explore (Phase 0, Teil D).

STAND-SHAs (aus abgleich_ce/abgleich_super uebernommen UND vom Designer 14.08. ~07:10Z
frisch nachgemessen; der Komplex-Fix misst je Stufe FRISCH nach -- Finding-43-Lehre,
Drift-Beleg: super 8 -> 10 -> 15 -> 24 -> 27 Commits in fuenf Quellen-Generationen):
  ce  origin/development = 5f3f26a5 ; lokal development = 643102fb (12 von 12 voraus:
      3 S-7-Commits 548fecd2+ec3c71fa+178bb1fb, 4 Wachen 092ab7e9+6eb72ace+0fbcb049+
      07a60cc7, 1 p6 f6d13dfb, 3 Merges d215b127/0304ebf1/a6804dfa, 1 Floor-Nachzug
      643102fb "492/488/486, +1 je Sprosse aufgeklaert").
  super origin/development = a103e518 ; lokal development = 09cd97a3 (27 von 27 voraus:
      8 Luecken/Fix 76a345e3..f3017a77, PAUSE-2 2cbcc6b5, 4 F1 915038ca+c134b70a+
      ff9a517b+8e9a31d2, Sammelrunde fa75d47c, 3 Merges 865ff21d/dbef5b0f/ad742bdc,
      4 texgate bb03d53b+2cea7287+6bd5b263+5363eebb, 3 e21 f1b05256+bd02e7ab+fe7bb459,
      2 Design-Publikationen 85c1174d (Zielstruktur, alle Namen 'planner' per Owner-B3)
      + 6e796ae5 (G-1 mit STATUS-NACHTRAG), 1 Ledger KON60 09cd97a3).
  Gitlink am super-HEAD = 5f3f26a5 (KEIN Bump -- korrekt, ce ungepusht; Bump+PZW erst
  nach ce-CI-Gruen). Ledger-Kopf = KON60 (Z.19, 27383 Zeilen); KON61 = 0 Treffer (FREI,
  vom Designer gemessen). Lock-sha256 am ce-HEAD = e7263b82 (unveraendert). Floor am
  ce-HEAD = 492/488/486. MANUAL_RUN.md:279 traegt WEITER ':1310ff', real liegt
  '(3b) PDF-GATE' bei ci/anhang_forward_core.sh:1321 (Designer-Messung am HEAD).
  Worktrees super 5 von 5 (Haupt-Klon 18a0bdf3 auf b-ci-rueckschrieb-beide-zeiger!,
  wt-f1-1x1 8e9a31d2, wt-super-e21 fe7bb459, wt-super-landung 09cd97a3, wt-super-texgate
  5363eebb); ce-Worktrees wt-ce-mess-ordnung 178bb1fb + wt-ce-wachen 07a60cc7 (beide
  gemergt, Abbau erst nach CI-gruen + Submodul-Branch-Pruefung).

QUELLEN-DECKUNG DES DESIGNERS (beide Mengen benannt): 4 von 4 abgleich_*.md VOLL gelesen;
leser_kern.md VOLL (Teil 1 Sammelliste 205/205 Quellzeilen als Anker-Datei + Teile 2-11,
188 Eintraege); leser_01..12 (2800 Eintraege) per Status-Sweep erhoben (2211 Eintraege
mit Status offen/teilweise/vertagt extrahiert, je Quelle aggregiert) und gegen die vier
Pruefer-Klassifikationen trianguliert; die 21 von den Pruefern nicht einzeln benannten
Quell-Workflows (406 der 2211 offenen Eintraege, u.a. w2mylldp8/wp8u862m5/wr08h0dkm/
ww7eb5key/wf8v44w0f/w7k80iq48) per Stichwort-Falsifikationsprobe (push/landung/merge/
floor/registry/lock/kombibau/gitlink/ROT/Pflicht) gegengeprueft: 0 neue Vor-Push-Posten;
alle Treffer sind verwaltete Historie (Task #40 38-NE/20-Auftraege, W-Plan-Slots,
beantwortete Owner-Fragen, durch rescue-/Wellen-Landungen ueberholt). Objektmessungen
dieses Kopfs vom Designer selbst (git read-only, /usr/bin/grep absolut).

KORREKTUR DER FIX-RUNDE 14.08. (Pruefpunkt 2): der Status-Sweep deckte nur 147 von 152
Quell-JSONs; 5 standen in KEINEM leser_*.md (SOLL-Batch leser_03, i%12==2) -- die
21-Workflows-Falsifikationsprobe kann das bauartbedingt nicht decken, sie zieht nur aus
VORHANDENEN Leser-Eintraegen. Die Fix-Runde hat die 5 (wr48236je idx 62, wbckbar4m
idx 86, wjh71oern idx 110, w7rrni258 idx 122, wuwemnde5 idx 134) aus dumps_leser03/
VOLL nachgelesen (5 von 5), am gelandeten Stand gemessen (ce 643102fb, super 09cd97a3)
und als #99-#103 in Teil B eingearbeitet: Deckung 152 von 152. leser_03s Meldung
'13 von 13 vollstaendig gelesen' ist am Objekt falsch (5 batch-fremde, bereits gedeckte
Dateien doppelt gelesen statt der eigenen 5). Querverweis-Korrektur: der
F1_NICHT_BELEGT-Verweis auf wuwemnde5 steht in leser_kern.md:387, nicht in
abgleich_pausen:387 (dort :357 nur der fix-f1-endbeleg-Ausloeser).

NENNER-BILANZ: Teil A = 6 Harmonisierungs-Flaechen (A1..A6). Teil B = 103 Posten
(Findings 1..64 der Sammelliste + 34 weitere Funde 65..98 aus Leser-/Pruefer-Dateien
+ 5 Nachlese-Posten 99..103 der Fix-Runde 14.08., je EINER pro nachgelesener Quelle).
Teil C = 4 Pausen-Sorgfalt-Pflichtposten P1..P4 (mit R1..R10-Disposition). Teil D =
EIN Paket, 15 Schritte in 5 Phasen + Verify + A2.5-Fix. Teil E = 10 Owner-Antworten
eingearbeitet (A1, A2/C1, B1, B2, B3, B4, B5, C2, D3, D4).

DISPOSITIONS-VOKABULAR (Teil B): FIX-IM-KOMPLEXFIX | SCHON-BEHOBEN@SHA+Beleg |
LANDUNGS-HARMONISIERUNG (erledigt die Landung beim Merge; KF prueft nach) |
UEBERHOLT+Beleg | EIGENER-POSTEN-Wx (terminierte W-Plan-/Task-Arbeit, NICHT vor Push) |
DUPLIKAT-von-#n. LUECKEN SIND PFLICHT: kein Posten ist "Randfall" oder "NOTIZ" --
jeder traegt Fix-Anweisung ODER belegte Disposition.

================================================================================
## TEIL A -- HARMONISIERUNGS-FLAECHEN (Sammelliste A.1-A.6, Stand nach Landung Stufe 1)
================================================================================

ABGRENZUNG LANDUNG vs KOMPLEX-FIX: Die LANDUNG (Stufe 1) hat beim Merge harmonisiert:
serielle --no-ff-Merges, Floor-Konflikt S-7-x-Wachen aufgeloest (ANKER-Kopf Wachen +
Werte S-7), Floor-Nachzug als eigener Commit 643102fb (492/488/486 live), texgate-x-F1-
Kopfbloecke harmonisiert (dbef5b0f), Designs publiziert (planner-Umbenennung B3),
KON60 gebucht. Der KOMPLEX-FIX prueft NACH den Merges nach und erledigt die Restpflichten
VOR dem Push. Nichts aus Teil A wird doppelt gebaut.

### A1. tests/unit/CMakeLists.txt-Tails (S-7 x Wachen x p6)
OBJEKTBEFUND (Designer 07:1xZ, HEAD 643102fb): 231 comdare_add_test-Registrierungen,
0 Duplikat-Namen (uniq -d leer; 230 vor p6 + 1 test_lizenz_konsistenz). S-7 Dateiende
+40, Wachen 0 Diff-Zeilen, p6 +13 mittig (~:6660) -- disjunkte Regionen, Auto-Union
gegenstandslos. STATUS: BEHOBEN durch Landung; Wiederholung nach jedem KF-ce-Commit.
ANWEISUNG (Komplex-Fix, nach letztem ce-Commit des Pakets):
  git -C <ce> show HEAD:tests/unit/CMakeLists.txt | /usr/bin/grep -oE
  'comdare_add_test\([a-z0-9_]+' | sort | uniq -d
MESSKOMMANDO: s.o.; Zaehlung mit /usr/bin/grep -cE.
ERLEDIGT-KRITERIUM: uniq -d leer UND Zaehlung == 231 (oder neuer Wert mit benanntem
Grund, falls das Paket registriert -- SOLL: das Paket registriert NICHTS).

### A2. Floor scripts/ci_test_inventory_floor.txt -- EINMAL live am Gesamtstand
OBJEKTBEFUND: Nachzug-Commit 643102fb EXISTIERT ("Floor-Nachzug nach S-7+Wachen+P6 --
492/488/486, +1 je Sprosse aufgeklaert"); Datei-HEAD traegt avx512f 492 / avx2 488 /
basis 486; ANKER-Semantik (Exit 4 beidseitig, Nachzug-Pflicht) aus dem Wachen-Paket.
Die frueher offene K-2-Kollision (p6 +1 unbedingte Registrierung gegen Wachen-ANKER)
ist damit am Objekt geschlossen. STATUS: BEHOBEN durch Landung; die LIVE-Bestaetigung
laeuft im A5-Kombibau mit (die Floor-Wache isst im covguard-Bau ihr eigenes Futter).
ANWEISUNG: KEIN weiterer Floor-Eingriff. Falls das KF-Paket wider SOLL einen ctest
registriert: Nachzug ALLER drei Zahlen im SELBEN Change (ANKER-Doktrin, Datei-Kopf
:25-33 autoritativ -- eigener sichtbarer Diff-Teil im selben Change; die 'eigener
Commit'-Pflicht ist per Datei-Kopf :35-41 ausdruecklich ENTFALLEN/Historie --
Fix-Runden-Messung 14.08. am gelandeten HEAD 643102fb).
MESSKOMMANDO: im A5-Kombibau (build-covguard KALT, Pruefling-Schalter, make inventar,
ctest -N | sort -u | wc -l; Klassen per cmake -D...=0 erzwingen, danach cmake -U beide).
ERLEDIGT-KRITERIUM: Guard-Literal "genau erreicht: X == Anker Y" je Host-Klasse
(492/488/486) im Kombibau-Log; es gilt das LITERAL der Messung, nie die Vorhersage.

### A3. Wachen-Inventar-Nenner (ce t6 / super Meta-Gate)
OBJEKTBEFUND: ce .gitlab-ci.yml 0 Diff-Zeilen ueber 5f3f26a5..643102fb -> t6-Nenner
"25 Top-Level-Jobs von 33 Schluesseln (5 reserviert, 3 Templates)" traegt am Gesamtstand;
p6-ctest ist KEIN CI-Job. super .gitlab-ci.yml +95/-28 ueber origin..HEAD -> der
Meta-Gate-INVENTAR-Nenner (58b5aff4: M=26, 13 gefahren / 13 begruendet ausgeschlossen)
ist am Push-Stand NEU zu enumerieren.
ANWEISUNG: (a) ce: kein Eingriff; t6 laeuft im A5-Kombibau mit (4 von 4 Zellen), t6-Fall
je Zelle als Literal zitieren. (b) super: VOR dem Push scripts/vor_push_alle_wachen.sh
(INVENTAR-Modus, Diff-Hygiene ueber --bereich origin/development HEAD, Form 1e31cd4b)
fahren; M frisch zaehlen (Ausgangswert 26, YAML-Wachstum kann M heben); JEDE neue Zeile
fahren ODER begruendet ausschliessen.
MESSKOMMANDO: scripts/vor_push_alle_wachen.sh --bereich origin/development HEAD (super).
ERLEDIGT-KRITERIUM: Bilanz-Literal "X gefahren / Y ausgeschlossen / M gesamt" mit
X+Y==M am Push-Stand; ce-t6 4 von 4 Zellen gruen.

### A4. Lock/algo_version-Flaeche (kOverlaySourceSet, 718 Records)
OBJEKTBEFUND: KEIN Strang beruehrt die Preimage-Menge (S-7 0 von 8, Wachen 0 von 4,
p6 0 von 44 -- rcu-Verdacht aufgeklaert: Lock-Records sind axis_08_concurrency_rcu.hpp,
nicht p6s reclamation/rcu.hpp); .xml steht in kNichtQuellEndungen (Regen-Probe lockfrei);
Lock-sha e7263b82 am HEAD 643102fb unveraendert (Designer-Messung). Sammelliste A.4
("S-7-Regen gegen Wachen-Branch") war UEBERHOLT -- kein zweiter Regen-Stand existiert.
ACHTUNG NEU (Designer): der Teil-B-Posten #48 (simd_build_gate.hpp-Kommentar) beruehrt
eine Datei unter include/cache_engine/measurement/ -- VOR dem Edit Lock-Mitgliedschaft
messen (Anweisung in #48); danach gilt die Exit-Semantik hier.
ANWEISUNG: KEIN Lock-Regen auf Verdacht. Am FINALEN Gesamtstand EINMAL
comdare_axis_version_lock --check fahren (Werkzeug per J-1 bauen) und Literal
protokollieren. Exit-Semantik im Protokoll fuehren: 0 gruen / 1 Digest ohne Bump /
2 Struktur / 3 REGEN ERFORDERLICH. Faellt der Check nicht auf 0: Ursache am Objekt
klaeren (welche Datei, welche Kategorie), NIE blind --write.
MESSKOMMANDO: <build>/comdare_axis_version_lock --check (nach J-1-Werkzeugbau).
ERLEDIGT-KRITERIUM: Literal "718 Dateien ... deckt 712 von 712 Overlay-Quellen" +
Lock-sha e7263b82 unveraendert ODER (nur bei #48-bedingtem Regen) neuer Lock-sha im
selben Commit mit deklarierter Kommentar-only-Ursache und Check GRUEN danach.

### A5. Kombibau am Gesamtstand (KON55: gcc-15 + clang 22.1.8 x Debug + Release)
OBJEKTBEFUND: Eigen-Kombibauten der Straenge liegen vor (S-7 4x "0 tests failed out of
490" auf 178bb1fb -- Erst-Master OHNE ENDE-Zeile, ENDE fail=0 NUR im REST-Master
s7fix-kombibau-rest-master.log 14:58:42Z, L3; Wachen 4x488/488 auf 07a60cc7). Am
ZUSAMMENGESETZTEN Stand lief noch KEIN Kombibau (0 von 4 Zellen). XML-Regen-Frage (F61)
entscheidet den End-SHA.
ANWEISUNG (Reihenfolge bindend): (1) ALLE ce-Code-/Daten-Fixes des Pakets ZUERST
(Teil D Phase 1: #48-Kommentar, dann XML-Regen-Probe #61 -- Regen-Schritte NACH
Code-Fixes, sonst misst der Regen einen Nicht-Endstand). (2) DANN EIN Kombibau,
4 Zellen SEQUENTIELL (PIPELINES STRENG SEQUENTIELL, sonst OOM) auf dem finalen SHA:
je offizieller Weg J-1..J-4 (Werkzeuge zuerst: comdare_adhoc_emitter_cli,
comdare_anatomy_codegen_cli, alle *_registry_gen -> RE-CONFIGURE -> Vollbau -> volle
ctest-Suite). EXCLUDE_FROM_ALL-Ziele explizit bauen (test_profile_roundtrip,
CMakeLists:5557); blankes ctest im ungebauten Baum ist als Vollgruen-Gate ungeeignet
(N3-Falle 886/474 Not-Run). (3) Platten-Waechter VORHER neu starten (PAUSE-3 Posten 7;
df-Gate >8G je Zelle). (4) test_d2_abdeckungs_wache_nenner bei Einzel-Rot unter
Volllast EINMAL isoliert wiederholen (F49-Praezedenz 1 von 490). (5) Raeumen mit
Belegpruefung 0/0. t6- und test_lizenz_konsistenz laufen mit (Deckung A3/D2-Rest;
Lizenz-Wache am Gesamtstand gruen zu erwarten: Guard reisst nur bei FREMDEM Bezeichner
ausserhalb ext/, Sanity eigen>30 traegt).
MESSKOMMANDO: /usr/bin/grep -E 'tests passed|failed out of' <zell-log> je Zelle;
Master-Log-Tail mit ENDE-Zeile.
ERLEDIGT-KRITERIUM: 4x Literal "100% tests passed, 0 tests failed out of N" am finalen
SHA -- Erwartung N=491 ohne / 492 mit Pruefling-Schalter (490 am 178bb1fb + 1 p6);
zaehlt das Objekt anders, gilt das Objekt und der Grund ist zu benennen; Master-ENDE
"fail=0" + Raeum-Beleg 0/0; Floor-Guard-Literale (A2) im selben Lauf.

### A6. Push-Bereich beider Repos (EIN Push je Repo, EINE CI)
OBJEKTBEFUND: ce 12 voraus (Kopf), super 27 voraus (Kopf); Designs publiziert 2 von 2;
KON60 gebucht; BU a25_wachen_fix FEHLT (docs/sessions/backups: juengster Eintrag
20260813-luecken-und-vollstaendigkeit, 0 Treffer 'wachen'); PAUSE-3-Dokument NICHT
committet (nur PAUSE-2 2cbcc6b5); MANUAL_RUN.md:279 stale ':1310ff' vs real :1321;
gh-scrub/development 276 hinter origin; Haupt-Klon auf b-ci-rueckschrieb-beide-zeiger.
ANWEISUNG: (a) ce-Push erst nach A5; Bereich FRISCH zaehlen (12 + 0..n KF-Commits);
Diff-Hygiene-Wache PUSH-LOKAL ueber origin/development..HEAD (nie kumulativ, MEMORY).
(b) super-Push-Vorlauf im Paket (Teil D Phase 3/4): KON61-Sammel-Nachtrag (EIN
Schreiber via scripts/ledger_nachtrag.sh; Inhalte #30/#32/#33/#35/#46/#67/#68/#80/#89
u.a.), BU-SOFORT (a25_wachen_fix + PAUSE-3 + regressions-gesamtbild, je mit beissendem
gitleaks-Koeder glpat-+20 aus wirksamer Config, rc=1-Beweis; AWS-Koeder beissen NICHT),
F40-Kopfzahlen-Nachmessung inkl. MANUAL_RUN:279, Meta-Gate-INVENTAR (A3.b),
Diff-Hygiene push-lokal. (c) Kette streng seriell NACH dem Komplex-Fix: ce-Push ->
ce-CI TERMINAL SUCCESS (nie parallel weiterarbeiten; Landekette-Doktrin 06.08.:
Gitlink-Bump 31s nach ce-Push war der wirksamste Einzelfehler) -> Gitlink-Bump
5f3f26a5 -> <ce-final> ATOMAR mit PZW-Fussnote (finale Floor-Werte + Merge-SHAs +
Kombibau-Bilanz hinein) -> super-Push -> super-CI gruen (PZW-Wache 5 von 5 laeuft mit).
(d) NACH beiden Pushes: Haupt-Klon-ce-Store fetchen (L4-Verbund #82), 4-Klone-Sync.
MESSKOMMANDO: git rev-list --count origin/development..HEAD je Repo (frisch);
Wachen-Laeufe wie A3/Diff-Hygiene.
ERLEDIGT-KRITERIUM: alle Vorlauf-Posten dreiwertig quittiert; beide CIs TERMINAL
SUCCESS; PZW dual gruen; Bereichszahlen im Protokoll mit Nenner.

================================================================================
## TEIL B -- ALLE FINDINGS (64 Sammelliste + 34 weitere Funde + 5 Nachlese 99-103)
================================================================================
Format je Zeile: Nr | Quelle | Gegenstand | Ort | DISPOSITION | Fix-Anweisung |
Erledigt-Kriterium. Belege: T0-T3 = abgleich_ce-Snapshots; Designer-Messungen 07:1xZ.

--- A. MERGE-REGRESSIONS-PRUEFFLAECHEN (1-6) ---

1 | Sammelliste A.1 | CMakeLists-Auto-Union S-7 x Wachen | ce tests/unit/CMakeLists.txt |
  SCHON-BEHOBEN@0304ebf1+a6804dfa (nur S-7 aendert die Datei, Tail +40; Wachen 0; p6
  mittig; 231/231, 0 Duplikate -- Designer-Messung am HEAD) | Rest: Flaeche A1
  wiederholen nach letztem KF-ce-Commit | uniq -d leer, Zaehlung 231.
2 | Sammelliste A.2 | Floor EINMAL live messen | ce scripts/ci_test_inventory_floor.txt |
  SCHON-BEHOBEN@643102fb (Nachzug-Commit 492/488/486, +1 je Sprosse aufgeklaert;
  ANKER-Kopf) | Rest: Live-Bestaetigung im A5-Kombibau | Guard-Literal "X == Anker Y"
  je Klasse im Kombibau-Log.
3 | Sammelliste A.3 | Wachen-Inventar-Nenner | ce t6 / super Meta-Gate 58b5aff4 |
  ce-Haelfte SCHON-BEHOBEN@0304ebf1 (0 neue CI-Jobs, Nenner 25/33 gueltig); super-Haelfte
  FIX-IM-KOMPLEXFIX | Flaeche A3.b: INVENTAR-Modus ueber --bereich, M frisch | Bilanz
  X+Y==M literal am Push-Stand.
4 | Sammelliste A.4 | algo_version-/Lock-Flaeche | ce tools/axis_version_lock/ |
  UEBERHOLT (kein Strang beruehrt Preimage, 0 von 56 Dateien; Lock dev==origin,
  sha e7263b82) | Rest: Flaeche A4 --check-Beleg am Endstand | Literal 718/712-712 +
  sha unveraendert (bzw. #48-Regen deklariert).
5 | Sammelliste A.5 | Kombibau KON55 + voller ctest am Gesamtstand | ce | FIX-IM-
  KOMPLEXFIX (Pflicht vor Push) | Flaeche A5 komplett (Reihenfolge bindend) | 4x
  "0 tests failed out of N" (Erwartung 491/492) + ENDE fail=0 + Raeumen 0/0.
6 | Sammelliste A.6 | super Push-Bereich/Diff-Hygiene/PZW | super | FIX-IM-KOMPLEXFIX
  (Vorlauf) + Kette nach KF | Flaeche A6; Zahl "8 lokale Commits" ist STALE (real 27,
  Designer-Messung; L1/5.4: Abweichung in Owner-Kommunikation deklarieren) | alle
  Vorlauf-Quittungen + beide CIs gruen + PZW dual.

--- B. F1-FIX-RESTE (7-10) ---

7 | [F1] verify_dump 7 | WF-Rezept-/Task-#41-Text: bash statt sh; AF_SNAP_ROOT_STRICT=
  false Labor-Pflicht-Env; 9-Spalten-required[]; op_lookup_p50_ns=1310 | Task-#41-Text
  (ausserhalb Repo) | FIX-IM-KOMPLEXFIX (Protokoll/Task-Pflege, kein Repo-Commit) |
  Task-#41-Text per TaskUpdate um die vier Korrekturen ergaenzen; in die naechste
  Kontextuebergabe uebernehmen | Task-Text traegt die vier Werte literal.
8 | [F1] | Landung des F1-Zweigs | super | SCHON-BEHOBEN@865ff21d (merge --no-ff,
  4 Commits ancestor; Merge-Probe durch vollzogenen konfliktfreien Merge gegenstandslos)
  | keine | im Push-Bereich enthalten.
9 | [F1] | Thesis \InputIfFileExists-Hebung lc_surface (de:64ff/en:63ff, Muster
  de:103-283) | Thesis anhang/de/A_measurements.tex | EIGENER-POSTEN-nach-F1
  (Owner/Lead-Vormerkung, verify_dump 4) | keine im KF | Vormerkung steht im
  KON61-Nachtrag (eine Zeile).
10 | [F1] | HONEST-EMPTY-Nenner: matrixplot=0 UND honestempty>=1 UND nie-ausgefuehrt=0 |
  Pruef-Rezepte | FIX-IM-KOMPLEXFIX (Rezept-Zeile) | Nenner-Formel in das Lande-/
  Echtlauf-Protokoll und Task-#41-Text uebernehmen (mit #7 in einem Zug) | Rezept-Text
  traegt die Formel.

--- B. e21-RESTE (11-16) ---

11 | [e21] | Ledger-Nachtrag aus ledger_vorschlag, KON-Nummer vergeben | super Ledger |
  SCHON-BEHOBEN@09cd97a3 (KON60-11 "E-21-VOLLZUG": A-1-Kette, Marker, E-Block-Bilanz,
  #21 abgeschlossen; Nummern-Vergabe gemessen 0-Treffer vor Buchung) | Rest-Inhalte
  anderer Lieferanten -> #30/#32/#33/#35/#46 via KON61 | KON60-11 am Objekt (erfuellt).
12 | [e21] | E-2 "mit mehr Kontext"-Neuvorlage gegenstandslos | Owner-Vorlage |
  SCHON-BEHOBEN@fa75d47c (D2-Kenntnisnahme) + KON60-11(5) E-Block-Bilanz "E-2
  SCHON_ERLEDIGT ... GEGENSTANDSLOS" | keine | Ledger-Zeile vorhanden.
13 | [e21] | E-4c KON-57/E-26 TEST-Skip Owner-Frage | Vorlage Teil III | SCHON-BEHOBEN@
  09cd97a3 (KON60-09: D3 "Wie empfohlen, Freigabe." -- VOLL-ctest bleibt Pflicht, KEIN
  Fingerprint-Test-Skip; drei Ebenen getrennt gebucht) | keine | KON60-09 am Objekt.
14 | [e21] | Dateinamens-Divergenz A-1-Vorlage | docs/plaene | SCHON-BEHOBEN@f1b05256
  (FORM-Name liegt so im gemergten Branch, ad742bdc ancestor) | keine | Datei am HEAD.
15 | [e21] | A-3-Rotation 776 Runner-Registration-Token | GitLab-Instanz | UEBERHOLT
  als Session-Posten (Owner-Antwort A2/C1: Infra-Handout geschrieben, Owner loest
  Infra aus -- kein Session-Bau) | keine im KF; Vollzug beim Owner/Infra | KON61-Zeile
  "C1 an Infra uebergeben" (mit #30-Block).
16 | [e21] | non-ASCII im BESTAND minio-Vorlage Z.1-56 | docs/plaene/...minio-keys... |
  UEBERHOLT (Lead-Entscheid per Empfehlung gefaellt: NEIN, Bestand ist Bestand; nur
  neue Zeilen ASCII -- Sammelliste-Empfehlung uebernommen, keine Gegenstimme in 3
  Quellen) | keine (Bestand nicht anfassen) | KON61-Zeile als Entscheid-Vermerk.

--- B. DESIGN-DUO (17-20) ---

17 | [Design] | Publikation beider Designs als docs/plaene/20260813-DESIGN-*.md |
  super | SCHON-BEHOBEN@85c1174d+6e796ae5 (Designer-Messung: beide am HEAD getrackt;
  Zielstruktur durchgaengig 'planner', 0 planer-Zielnamen) | keine | Dateien am HEAD.
18 | [Design] | F-G1-11/-12 + 15 F-G1-Fragen an Owner | design_g1 | TEIL-UEBERHOLT:
  F-G1-1/-2 ANGENOMMEN (B2 autonom, 6e796ae5), F-G1-11 aus Bestand per B1/(iii)
  aufgeloest (KON60-08); OFFEN BEIM OWNER bleiben F-G1-3..-10 + F-G1-12 (9 von 12) |
  KF-Anteil = #98 (Konstruktions-Nachtrag) | STATUS-NACHTRAG 6e796ae5 + #98 quittiert.
19 | [Design] | Matrix-Drittzaehlung #67/S-6d + Par.6.4-Nachpruefung | Wellenplan/#67 |
  EIGENER-POSTEN-W (S-6d-Neuerhebung; 29er-Definition uebernehmen, 142 historisch --
  Zeile faellt in #32/KON61) | keine im KF | KON61 traegt die 29er-Uebernahme-Zeile.
20 | [Design] | Ein-Schreiber-Check Wurzel-CMakeLists.txt beim Skeleton-Commit |
  ce CMakeLists.txt Z.737-753 | EIGENER-POSTEN-WE-15./16. (nach ce-Freigabe/Push) |
  keine im KF; Vormerkung im Protokoll | Vormerk-Zeile im KF-Abschlussprotokoll.

--- B. LUECKEN-WF (21-34) ---

21 | [Luecken] | super-Job test:abnahme06-voll mit --ctest-liste | super
  .gitlab-ci.yml:1132ff | EIGENER-POSTEN-W (nach der Welle; verbatim Bau-Anweisung
  liegt in luecken_dump 5: cross-project-Artefakt ODER needs-Job, Selbsttest, dann
  --ctest-liste; 6 Formel-Zahlen literal, kein allow_failure) | keine im KF |
  W-Slot-Zuweisung im KF-Abschlussprotokoll.
22 | [Luecken] | D2-G6: 3 Roundtrip-Gates Skip-Vermerk + Kommentar + Stash-Koeder |
  ce tests/unit/CMakeLists.txt:5609/:5639/:5654 (Anker-Drift dokumentiert, T1) |
  EIGENER-POSTEN-naechster-ce-Slot (Bau-Anweisung (a)+(b) verbatim in luecken_dump 7;
  KEIN Vor-Push-Blocker: stille Abschaltung heute indirekt gefangen Floor+D1c) |
  keine im KF | W-Slot-Zuweisung protokolliert.
23 | [Luecken] | D3-4 Director-Grandchild BATCH-BILANZ A+B==C + Inhalts-Gate je Batch |
  ce experiment_plan_director.hpp (0 Treffer BATCH-BILANZ, T1) | EIGENER-POSTEN-
  naechster-ce-Slot (verbatim Bau-Anweisung luecken_dump 8; T-1 rot zuerst) | keine
  im KF | W-Slot-Zuweisung protokolliert.
24 | [Luecken] | ##23-R1: 3 von 11 Profilen xlsx additiv | ce thesis_profiles/
  {base_pilot,m3v2_smoke,wdk_fairness_example}.profile.xml (Designer-Messung am HEAD:
  exakt diese 3 mit 0 xlsx-Treffern, 8 mit 2) | FIX-IM-KOMPLEXFIX (aufgewertet durch
  Owner-B4 "Es gibt keine CSV ohne xlsx und xlsx ist Standard" -- Erzeugungs-Doktrin;
  Profile ohne xlsx-Deklaration widersprechen dem Standard) | Block aus
  m3v2_study.profile.xml:181-183 additiv in die 3 Profile (<method value="xlsx"/> +
  Kommentarzeile); ADDITIV halten (S-13/#18 darf ersetzen); B4-Historie-Explore-Beleg
  (Phase 0) an den Commit haengen | Abnahme: alle 11 Profile /usr/bin/grep -c xlsx
  >= 1 (Nenner 11 literal im Commit-Text).
25 | [Luecken] | ##26 M==N haerten | super ci/mess_ausbeute_wache.sh (:355-358 alt) |
  FIX-IM-KOMPLEXFIX (Owner-Zuweisung KON60-05 woertlich "FIX-FORM (Komplex-Fix)") |
  harter M==N-Zweig NUR bei modus=voll: leere CSV im Vollmodus = exit 1 MIT
  unveraenderter Befund-AUSGABE ("Herabgestuft wird das URTEIL, nie die AUSGABE");
  Warnung bleibt fuer provision_only/pruef_only (dort per Bauart unerfuellbar);
  Bissproben-Fall in ci/tests/mess_ausbeute_bissprobe.sh (2 CSVs, eine auf Kopfzeile
  reduziert => rot mit "M von N", Gegenprobe gruen; T-1 rot zuerst); KOLLISION 5.5
  beachten: Anker (:355-358, awk :262) am HEUTIGEN Objekt NEU ziehen (Strang-C
  a1ee9780 hat die n/a-Zaehlung umgebaut); Explore-Beleg anhaengen; formale
  GO-Luecke (KON60-05) nachrichtlich fuehren | Bissprobe rot->gruen literal +
  Wache am Objekt mit neuen Ankern committet.
26 | [Luecken] | NE-19a ce-Kampagne (34/36) + vor_push_alle_wachen ce-INVENTAR-Modus +
  NE-20 arm64-smoke/relock | ce scripts/ + .gitlab-ci.yml:257/:919 (Designer-Messung:
  beide allow_failure:true am HEAD; relock ist rules when:manual) | GETEILT:
  (a) pipefail-Kampagne EIGENER-POSTEN-W (eigenes Paket, Stufen-Form); (b) ce
  vor_push_alle_wachen INVENTAR-Modus EIGENER-POSTEN-naechster-ce-Slot (super-Vorlage
  58b5aff4+1e31cd4b); (c) NE-20-Triage FIX-IM-KOMPLEXFIX: an :257 und :919 je
  DEKLARIERTE-AUSNAHME-Kommentar in 83e06159-Form setzen ODER Zeile entfernen --
  Empfehlung: beide DEKLARIEREN (arm64-smoke = fehlender arm64-Runner/Infra;
  relock = manueller Wartungsjob, when:manual; ZELLE-vs-JOB-Regel zitieren) | (c):
  beide Stellen tragen Kommentar mit Begruendung im selben ce-Commit; (a)/(b):
  W-Slot protokolliert.
27 | [Luecken] | NE-16 t6-Inventar | ce | SCHON-BEHOBEN@0304ebf1 (via Wachen-Merge;
  6eb72ace: 25/33 + S-14a-Riegel gedeckt; kein Doppelbau) | keine | t6 gruen in A5.
28 | [Luecken] | NE-10 S-3/S-7-Zahlen | ce | SCHON-BEHOBEN@d215b127 (via S-7-Merge;
  Zahlen 126/83 verifiziert) | Ledger-Haelfte -> #46 | KON61 traegt NE-10-Block.
29 | [Luecken] | ci/tests/-Probes-Kampagne (14 dash-Dateien ~360 KB) +
  xml_wellformed_guard Stufen-Form | super ci/tests/ | EIGENER-POSTEN-W (eigenes
  Paket nach der Welle, Hausform 76a345e3) | keine im KF | W-Slot protokolliert.
30 | [Luecken] | KON59-02-Anker-Drift: ce relock :898->:919, super ergebnis:holen
  :2751->:2809 | beide YAMLs | FIX-IM-KOMPLEXFIX (KON61-Zeile; Werte liegen,
  luecken_dump 36) | im KON61-Sammel-Nachtrag die korrigierten Anker verbuchen;
  VORHER am gemergten Stand frisch messen (texgate/Luecken-Straenge verschieben
  Zeilen; Designer: relock :912-919 bestaetigt) | KON61 traegt gemessene Anker.
31 | [Luecken] | E-Serien-Kollision der Triage aufgeklaert verbuchen | Ledger |
  SCHON-BEHOBEN@09cd97a3 (KON60-11(5): E-Block-Bilanz mit WARNZEILE "mindestens 5
  kollidierende E-Serien -- IMMER Gegenstand pruefen, nie Nummer") | keine |
  KON60-11(5) am Objekt.
32 | [Luecken] | Zaehlwerk-Aufloesungen: 137=123+7+6+1 (drei Vermerke :5272/:5395/
  :5470 schliessen) + #67 29er-Definition (142 historisch) + KON11-01-Elferliste
  (4 widerlegt/1 teil/5 halten) | Ledger | FIX-IM-KOMPLEXFIX (KON61-Zeilen; Designer-
  Messung: 0 Treffer '137'/'Elfer' im KON60-Block) | alle drei Bloecke in den
  KON61-Sammel-Nachtrag (Texte liegen in luecken_dump 17/18/19) | KON61 traegt
  drei Bloecke mit Nennern.
33 | [Luecken] | B5-Seriell-Entscheid (A/E-Schnittmenge: B5 seriell HINTER S-5 ->
  S-6a-Fenster; mess_achsen_naht.hpp Seriell-Slot) | Ledger/W1-Plan | FIX-IM-
  KOMPLEXFIX (KON61-Zeile; Frist vor Mo 17.08.; in #24 verbucht, Ledger-Zeile fehlt
  -- Designer-Messung 0 Treffer im KON60-Block) | W1-Plan-Zeile in KON61 (Text
  luecken_dump 20) | KON61 traegt B5-Seriell-Zeile.
34 | [Luecken] | Umbrella-CI strukturell rot seit 06.03. | Umbrella comdare/projekte |
  UEBERHOLT als Session-Posten (Owner-Antwort C2: Nachmessung erledigt, Fehlbild
  seit mind. 10.08., letzte gruene 06.03.; Entscheid a/b/c beim Owner) | keine im
  KF; KON61-Zeile "C2 erhoben, Owner entscheidet" | KON61-Zeile vorhanden.

--- B. FRUEHER AUFGELAUFEN (35-38) ---

35 | [Triage #31] | Ledger-Verbuchung 13 Branch-Urteile (8 ausbuchen/4 ueberholt/
  1 landen) + Hygiene | Ledger + Worktrees | FIX-IM-KOMPLEXFIX (KON61-Zeile) +
  Hygiene NACH Push | KON61: 13 Urteile verbuchen (p6 GELANDET@a6804dfa; ce-Objekt:
  18 von 18 lokale Neben-Branches enthalten, A.6 abgleich_ce; dazu #80-Remote-Liste);
  Hygiene-Liste: Store-2-Auscheck (#82), wf-Worktrees -15/-16 frei, wf_e22d25ef erst
  nach Sichtung der 17 untracked Skripte, d3naht-Gitlink nie committen, Haupt-Klon-
  Branch-Rueckkehr | KON61-Block + Hygiene-Liste im Abschlussprotokoll.
36 | [P6] | bau/p6-lizenz-umsetzung landen | ce | SCHON-BEHOBEN@a6804dfa (T2;
  f6d13dfb einziger Branch-Commit; 44/44-Kollisionsflaeche vom Lead aufgeloest) |
  Rest: Kombibau+test_lizenz_konsistenz in A5 (Pruefpflicht) + 4 Task-#42-Auflagen
  gegenpruefen (davon Lizenz-Detail #74) | A5 gruen + Auflagen-Check quittiert.
37 | [Monitor] | P3-Regel-Kandidat Monitor-Lebendprobe | Arbeitsweise v4.x |
  EIGENER-POSTEN-Umbrella (naechste v4.x-Fortschreibung) | keine im KF | KON61-
  Vormerkzeile.
38 | [#81] | Wiederhol-Verify W0b (Task #43) | super W0b-Endstaende | FIX-IM-
  KOMPLEXFIX als Teil der VERIFY-STUFE (Teil D: der adversarische Verify prueft die
  W0b-Bauposten mess_ausbeute/frische/lauf_marker/persist_sammler/anhang_forward +
  emittierte Director-YAML MIT Pipeline-Messung -- die Pipeline-Messung kann erst
  nach dem Push real laufen: dann als Stufe-3-Nachlauf mit 15764-Trace + neuen
  Job-IDs; Ergebnis mit #81-Referenz via ledger_nachtrag.sh) | Verify-Report nennt
  #81 mit Job-IDs; Ledger-Zeile nach Push.

--- C. TEXLIVE-GATE (39-43) ---

39 | [texgate] | 4 Commits landen | super | SCHON-BEHOBEN@dbef5b0f (Merge; Worktree
  wt-super-texgate nach CI-gruen freigeben -- erst nach Push) | keine | Merge am HEAD.
40 | [texgate] | [ROT] 11 CI-INV-Kopfzahlen am GEMERGTEN Stand nachmessen | super
  ci/anhang_forward_core.sh + MANUAL_RUN.md | FIX-IM-KOMPLEXFIX | Werkzeug/
  Schleifen-Probe /tmp/texgate_fix am HEAD wiederholen; ALLE Kopfblock-/Zeilen-Anker
  messen und nachziehen; Designer-Vorbefund: MANUAL_RUN.md:279 ':1310ff' stale,
  real '(3b) PDF-GATE' = ci/anhang_forward_core.sh:1321 (F1-Merge +13 Z. davor,
  texgate weitere Zeilen) -- MANUAL_RUN.md:279 auf :1321ff nachziehen; datierte
  Verweise NICHT anfassen (Doku-nie-loeschen) | alle 11 Kopfzahlen + :279 stimmen
  am HEAD (Kommando-Protokoll mit Soll==Ist je Zeile).
41 | [texgate] | TeX im Runner-PATH | gitlab-runner-Host | UEBERHOLT als Frage
  (Owner C3 Kenntnisnahme erteilt); empirische Antwort = erster scharfer
  anhang:forward-Lauf NACH Push; Projekt-Variablen (TEXLIVE_AVAILABLE/ANHANG_FORWARD)
  per PAT beim Echtlauf pruefen | keine im KF | Echtlauf-Protokoll (Stufe 4).
42 | [texgate] | PDF-Gate-Listen-Erweiterung bei 2. Hauptdokument (EN) | super ci |
  EIGENER-POSTEN-W (eigener Design+Bau+Verify-Zug, seit 6bd5b263 laut erzwungen;
  kaskadiert in E-18-SNAP-Vertrag) | keine im KF | KON61-Vormerkzeile.
43 | [texgate] | Standort-Angaben je Stufe FRISCH messen | Prozess | UEBERHOLT/
  UEBERNOMMEN als Prozessregel (alle vier Pruefer + dieser Designer praktizieren sie;
  Kopf dieses Dokuments) | keine | Regel steht im Kopf.

--- C/D. S-7 (44-53) ---

44 | [S-7] | [ROT] Kombibau-Restlauf-Belege lesen | s1-logs | SCHON-BEHOBEN (Belege
  DOPPELT gelesen: abgleich_ce A.8 + abgleich_pausen 3(4), je 4x "0 tests failed out
  of 490" + REST-Master "ENDE fail=0 14:58:42"; L3: Erst-Master endet OHNE ENDE-Zeile)
  | Rest: #66 -- Lesung AKTENKUNDIG im KF-Protokoll | Protokoll zitiert BEIDE
  Master-Logs + 4 Zellen-Literale.
45 | [S-7] | landender Riegel-Echtfall | ce Lock-Domaene | UEBERHOLT als KF-Posten
  (KON60-04: Ort = S-6-Fenster im W1-Bump-Buendel #15/#24/#38a2+d; Owner D4
  Kenntnisnahme + Explore-Gegenpruefung -> #97/Phase 0) | keine Bau-Aktion im KF |
  Phase-0-Explore-Quittung (#97).
46 | [S-7] | NE-10-Ledger-Korrektur (mp_size 126 nicht 122, 123 Literale 97+2+24,
  enabled=83, bvset AKTIV, Riegel-Praemisse falsch) | Ledger | FIX-IM-KOMPLEXFIX
  (KON61-Zeile; Riegel-Praemisse-Haelfte SCHON-BEHOBEN@09cd97a3 KON60-04
  UEBERHOLT-Marker KON58-01; Zahlen-Haelfte fehlt -- Designer-Messung 0 Treffer
  '126' im KON60-Block) | NE-10-Zahlenblock in KON61 (Text s7_dump 4) | KON61
  traegt 126/83/123-Block.
47 | [S-7] | MEMORY-/Task-Nachzug zur Floor-Commit-Form (S-7-Zeitstand nannte "eigener
  Commit") | Memory/Task-Texte | FIX-IM-KOMPLEXFIX (Protokoll-/Memory-Pflege, kein
  Repo-Commit) | Memory-Zeile + Task-Texte auf "im SELBEN Change (eigener sichtbarer
  Diff-Teil; Datei-Kopf :25-33 autoritativ)" stellen -- NICHT auf "eigener Commit":
  der gelandete ANKER-Kopf (scripts/ci_test_inventory_floor.txt @ 643102fb) erklaert
  die "eigener Commit"-Pflicht :35-41 ausdruecklich fuer ENTFALLEN (Historie/
  deprecated); der fruehere #47-Zieltext ":22-28 eigener Commit" stammte aus dem
  S-7-Zeitstand der Sammelliste und ist am Objekt widerlegt (Fix-Runde 14.08.;
  deckungsgleich mit der A2-Anweisung) | Memory-Aenderung im KF-Protokoll vermerkt;
  Memory-/Task-Text zitiert "im SELBEN Change".
48 | [S-7] | STALE-Kommentar simd_build_gate.hpp:196-197 (verweist
  build_orchestrator.hpp:458-459) | ce libs/cache_engine/include/cache_engine/
  measurement/simd_build_gate.hpp:196 (Designer bestaetigt am HEAD; realer Gate-Block
  heute libs/cache_engine/builder/build_orchestrator/build_orchestrator.hpp:783ff,
  Meldungs-Emission :794/:826) | FIX-IM-KOMPLEXFIX (1 Kommentarzeile) | VORHER
  Lock-Mitgliedschaft messen: /usr/bin/grep -c 'simd_build_gate' <ce>/tools/
  axis_version_lock/axis_version.lock; (a) 0 Treffer: nur Kommentar editieren
  (":458-459" -> beim Fix frisch gemessene Zeile, heute ":783ff"); (b) >=1 Treffer:
  Edit + comdare_axis_version_lock --write IM SELBEN Commit, Ursache "comment-only"
  im Commit-Text, danach --check GRUEN literal (A4-Exit-Semantik) | Kommentar nennt
  den gemessenen Ort; --check GRUEN am Endstand.
49 | [S-7] | Flaky-Kandidat test_d2_abdeckungs_wache_nenner unter Volllast (1 von
  490 einmalig) | ce tests/unit | FIX-IM-KOMPLEXFIX als Beobachtungs-Auflage in A5
  (bei Einzel-Rot: EINMAL isoliert wiederholen, Ergebnis protokollieren; kein
  Code-Eingriff) | s. A5(4) | A5-Protokoll traegt den Fall (oder "trat nicht auf").
50 | [S-7] | j14.sh SRC hartkodiert | /home/comdare/s1-logs/j14.sh:8 | EIGENER-
  POSTEN-Werkzeughygiene (ausserhalb Repo; Nachfolger j14-s7fix-kombibau.sh existiert;
  der A5-Kombibau nutzt die parametrisierte Nachfolger-Form) | keine im KF |
  A5 faehrt NICHT ueber j14.sh (Protokoll nennt das Skript).
51 | [S-7] | P4-Weiche (Homes-Verzeichnisform rueckt S-7-Header ggf. in den
  Fingerprint) | ce Header-Kopf | UEBERHOLT als Handlungsposten (dokumentiert;
  Entscheid faellt bei P4/#16) | keine | Header-Hinweis existiert (s7_dump).
52 | [S-7] | kVollausbau nicht signaturfaehig | ce algo_semver.hpp:1232 |
  SCHON-BEHOBEN@09cd97a3 (KON60-06: B5 = Status-quo-Bestaetigung, KEINE Zulassung,
  KEIN Katalog-Ausbau; 7 Fundstellen alle in algo_semver.hpp) | keine | KON60-06.
53 | [S-7] | ctest-Erwartung 490/491 + J-4 EXCLUDE_FROM_ALL | ce CMakeLists:5557 |
  FIX-IM-KOMPLEXFIX als Rezept-Zeile (in A5-Anweisung uebernommen; Erwartung am
  Gesamtstand 491/492) | s. A5(2) | A5-Protokoll nennt N mit Grund.

--- C/D. WACHEN-PAKET (54-59) ---

54 | [Wachen] | Branch-Tip 07a60cc7 landen; Floor-Flaeche | ce | SCHON-BEHOBEN@
  0304ebf1 (exakt der Tip im Merge; c0ff9986 inhaltsgleich aufgegangen, diff leer)
  + Floor-Rest SCHON-BEHOBEN@643102fb | Rest: A5-Bestaetigung | A5 gruen.
55 | [Wachen] | BU-SOFORT /tmp/a25_wachen_fix (18 Eintraege: 00_MANIFEST + 13 Logs +
  Koeder) | super docs/sessions/backups/ | FIX-IM-KOMPLEXFIX (Designer-Messung:
  0 Treffer 'wachen' in backups am HEAD; /tmp fluechtig!) | additiv nach
  docs/sessions/backups/20260814-a25-wachen-fix/ committen; VORHER gitleaks-Scan
  mit beissendem Koeder (glpat-+20 aus WIRKSAMER Config-Regel, rc=1-Beweis, dann
  Datei-Scan rc=0; AWS-Koeder beissen NICHT -- Fallen-Register) | Commit am HEAD +
  Scan-Kette literal im Commit-Text (K13-Form 5d67207b).
56 | [Wachen] | super-Aequivalente derselben Wachen-Klassen nicht erhoben | super |
  EIGENER-POSTEN-W (nach der Welle; deckt auch #88 da_unit GLOBAL-APPEND) | keine
  im KF | KON61-Vormerkzeile.
57 | [Wachen] | RAHMEN-Soll "2172 Ninja-Schritte" stale (live 2188) | Rezept-Texte |
  UEBERHOLT als Einzelfix (Prozessregel: bei Zitierung live bestaetigen; Floor-Kopf
  nennt keine Schrittzahl) | keine; A5 protokolliert die live gemessene Schrittzahl |
  A5-Protokoll traegt Ist-Zahl.
58 | [Wachen] | Kombibau-Interpretation (1 Kombibau statt 8 Vollbauten) | -- |
  SCHON-BEHOBEN (deklariert; durch A5 am Gesamtstand gedeckt) | keine | A5 gruen.
59 | [Wachen] | Scanner-Kante '"k" :' fail-closed | ce test_t6 | SCHON-BEHOBEN@
  07a60cc7 (gewollte Richtung, 0 von 33 betroffen, dokumentiert+gehaertet) |
  keine | t6 gruen in A5.

--- D. F1-DUAL-LENS (60-64) ---

60 | [F1-Lens] | Landereifer F1-Branch @ 8e9a31d2 | super | SCHON-BEHOBEN@865ff21d
  (gelandet; da_unit 405/405 R+D) | keine | Merge am HEAD.
61 | [F1-Lens] | [ROT] N1 Registry-XML-Drift: test_axis_registry_roundtrip |
  ce libs/cache_engine/algorithm_profiles/cache_engine_axis_registry.xml (juengster
  Commit 774a5d5f; KEIN Regen-Commit auf development -- Designer-Messung am HEAD) |
  FIX-IM-KOMPLEXFIX (4. ce-Lande-Posten; VOR dem Push, sonst faellt der contract-Job)
  | 2-Pass-Bau comdare_axis_registry_gen am Gesamtstand fahren, XML regenerieren,
  git diff auf die Datei. OBJEKT-EINSCHRAENKUNG (abgleich_ce K10/D4): der Fund wurde
  im super-Worktree wt-f1-1x1 gegen aelteren ce-Pin f23c18e2 gemessen; das zitierte
  Beispiel memory_layout_packed_bitmap steht in BEIDEN XML-Staenden -- 0-Diff ist
  ZULAESSIG (dann Kenntnisnahme-Protokoll statt Commit, N1 = Artefakt des alten
  Pins, super-Roundtrip heilt mit Gitlink-Bump); Diff nicht leer -> XML-Commit,
  DANN erst Kombibau (A5-Reihenfolge) | Literal "0 Zeilen Diff" ODER Regen-Commit +
  anschliessend gruener Roundtrip im A5-ctest.
62 | [F1-Lens] | 16b latexmk-PDF-Gate im CI | super anhang:forward | UEBERHOLT als
  KF-Posten (= anhang:forward-Job des Echtlaufs NACH der Landung, Gate seit texgate
  hart on; geplant, kein Rest) | keine im KF | Echtlauf (Stufe 4).
63 | [F1-Lens] | N2 Colorbar-Tick-Kollision | 05_diagram_generator | EIGENER-
  POSTEN-W (Kosmetik Tick-Dedupe; Bestand seit P2, testfixiert) | keine im KF |
  KON61-Vormerkzeile.
64 | [F1-Lens] | N3 blankes ctest 886/474 Not-Run ungeeignet | super build-test |
  FIX-IM-KOMPLEXFIX als Rezept-Zeile (Gate = 'ctest -L da_unit' bzw. make check;
  Roundtrip-Werkzeuge nur nach explizitem 2-Pass-Bau) | in Lande-/CI-Rezepte +
  A5/#61-Anweisungen uebernommen (geschehen) | Rezept-Texte tragen die Zeile.

--- WEITERE FUNDE AUS DEN LESER-/PRUEFER-DATEIEN (65-98) ---

65 | abgleich_flaechen K-2 | NEUE Kollision p6 x Wachen-ANKER-Floor (+1 unbedingte
  Registrierung, in KEINER Sammellisten-Zeile) | ce Floor | SCHON-BEHOBEN@643102fb
  (Nachzug-Commit 492/488/486; Merge-Botschaft 0304ebf1 hatte ihn angekuendigt) |
  Rest: A5-Bestaetigung | A5-Guard-Literal.
66 | abgleich_pausen R2 | F44-Beleg-Lesung AKTENKUNDIG machen (beide Master-Logs,
  L3) | KF-Protokoll | FIX-IM-KOMPLEXFIX | im KF-Abschlussprotokoll die 4 Zellen-
  Literale + Erst-Master-Befund (endet in J-1/J-2) + REST-Master "ENDE fail=0
  2026-08-13T14:58:42" woertlich zitieren | Protokoll-Abschnitt vorhanden.
67 | abgleich_pausen R5 | F1-Lens-Zaehlkorrektur: Journal autoritativ 16 Funde ->
  24 Quittungen [7 BEHOBEN/16 ENTLASTET/1 VERTAGT]; Kopfzeile "20 [4/15/1]"
  unpraezise | Sammelliste-Kopf | FIX-IM-KOMPLEXFIX (KON61-Zeile) | Zaehlkorrektur
  in KON61 verbuchen; Design fuehrt die Journal-Zahlen | KON61-Zeile vorhanden.
68 | abgleich_pausen R7 + Designer | zweites honest-empty-Paket b-honest-empty |
  super Branch b-honest-empty @ 838612f3 | UEBERHOLT (Designer-Messung: 0 voraus /
  622 hinter development = VOLLSTAENDIG ENTHALTEN; keine Datei-Flaeche offen) |
  KON61-Ausbuchungszeile; lokale Branch-Loeschung als Hygiene nach Push (Regel:
  gruen+gemergt); remotes rescue/b-honest-empty-final NUR mit Owner-GO anfassen |
  KON61-Zeile + Hygiene-Liste.
69 | abgleich_pausen R9 | NEUE LAGE Owner-Antworten (6e796ae5/09cd97a3) gegen
  Vorlage-Posten abgleichen | dieses Design | SCHON-BEHOBEN (Teil E dieses Dokuments
  arbeitet alle 10 Antworten ein; B1/B2-Posten nicht mehr "offen" uebernommen) |
  keine | Teil E.
70 | abgleich_pausen R10 | stale Task-IDs in Sammellisten-Kopfzeilen (L2) |
  Prozess | FIX-IM-KOMPLEXFIX (KON61-Doktrin-Zeile: Workflow-Identitaet nur ueber
  runId/Journal) | eine Zeile im KON61 | Zeile vorhanden.
71 | abgleich_ce C11 | 12 'super docs/'-Etiketten im ce-Quelltext + fehlendes
  docs-only-Gate | ce Quelltext | EIGENER-POSTEN-W (Doku-Ordnung nach der Welle;
  kein Landungs-Blocker) | keine im KF | KON61-Vormerkzeile (Sammelblock W-Posten).
72 | abgleich_ce C17e | N-1 ascii-width-guard dirname-Bindung | super/ce Wachen |
  EIGENER-POSTEN-W (#40-Familie, klein) | keine im KF | im #40-Rahmen gefuehrt.
73 | abgleich_ce C22 | Skip-Gate-Kommentar build_orchestrator: Zeilen-Anker
  :289-300 UEBERHOLT (heute orch_make_stem/kStemMax); inhaltliche Nachpruefung am
  heutigen Ort | ce build_orchestrator.hpp | EIGENER-POSTEN (naechstes Paket mit
  Schreibrecht auf die Datei; NICHT KF -- kein tragender Defekt belegt, nur
  Pruefauftrag) | keine im KF | W-Slot protokolliert.
74 | abgleich_ce C35 | michael_lockfree (LGPL-Repo-Text/Sperrvermerk): 0 Treffer im
  gelandeten LICENSE_AUDIT_EXT.md | ce LICENSE_AUDIT_EXT.md @ a6804dfa |
  FIX-IM-KOMPLEXFIX als PRUEF-Posten (p6-Nacharbeit): die 4 Task-#42-Auflagen
  gegen den gelandeten p6-Stand pruefen; fehlt der michael_lockfree-Vermerk laut
  Auflage, EINE additive Audit-Zeile im ce-Commit nachziehen; traegt die Auflage
  ihn nicht, als Owner-Lizenz-Detail in KON61 vermerken | Auflagen-Check dreiwertig
  quittiert; Audit-Datei ODER KON61-Zeile.
75 | abgleich_ce C39 | hetero_core_dispatch-CT-Etikett + prod2_raptor_lake-
  Registry-ID-Drift | ce | EIGENER-POSTEN-W7 (#21/#22-Umfeld) | keine im KF |
  KON61-Vormerkzeile (Sammelblock).
76 | abgleich_ce C40a | stale TODO measurement_axis_registry.xml:57-60 (W2-B,
  Par.32-F1/F7; Aussage "3 Mess-Modi existieren NICHT als Typen" nach D3-7b
  fraglich) | ce libs/.../measurement/measurement_axis_registry.xml | EIGENER-
  POSTEN-W2-B (prueft das W2-B-Paket) | keine im KF | im W2-B-Auftrag gefuehrt.
77 | abgleich_ce C40c | Plan-Ist-Anker stale + S1/S2-Header
  (version_stamp_interface.hpp) fehlen | ce S-Strecke | EIGENER-POSTEN-W1
  (Versionierungs-Interface-Plan; Plan-Anker vor Bau aktualisieren) | keine im KF |
  im W1-Auftrag gefuehrt.
78 | abgleich_ce C40e | paper_ref-Divergenz PRT + PAPER_REFERENCES-Luecken A17/A24 |
  Doku | EIGENER-POSTEN-W (Doku-Posten) | keine im KF | Sammelblock KON61.
79 | abgleich_ce C41a | b-pmc-l3-honest WIP nie committet | ce PMC-Strecke |
  EIGENER-POSTEN-W2 (#24) | keine im KF | im #24-Rahmen gefuehrt.
80 | abgleich_ce C43 | Remote-Branch-Bestand: 8 von 13 origin bau/b-* enthalten,
  5 NICHT (90bca126 b-m2-pmc-invariante, 81651f6e b-m3v2-pmc-window, 3f0d989d
  b-pmc-errno-diag, 237d0952 p2-warnstufe, 708cf156 p3-ci-clang-pflicht) --
  Ausbuchung IST das Triage-Urteil | ce origin | FIX-IM-KOMPLEXFIX (KON61-Zeile
  mit #35); Remote-Loeschung NUR mit explizitem Owner-GO (Memory-Regel) | Liste in
  KON61 verbuchen, KEINE Loeschung | KON61-Zeile mit 8/5-Nenner.
81 | abgleich_super 1.2/4.3 | gh-scrub/development 276 hinter origin | super
  Spiegel | EIGENER-POSTEN-Hygiene (beim naechsten Scrub-Sync; kein Lande-Blocker)
  | keine im KF | Hygiene-Liste im Abschlussprotokoll.
82 | abgleich_super 1.1/4.3 + verify_dump 33 + abgleich_ce C05 | Haupt-Klon auf
  b-ci-rueckschrieb-beide-zeiger + staler ce-Modules-Store (origin/dev=f23c18e2)
  + Store-2-Auscheck (ce-Submodul lt. Triage auf b-m2-pmc-invariante @ 90bca126) |
  /home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine | EIGENER-
  POSTEN-Hygiene-NACH-Push (L4-Verbund: EIN fetch heilt Store; danach 4-Klone-Sync
  + Branch-Rueckkehr pruefen; waehrend der Landung TABU -- Haupt-Baum nicht
  anfassen) | keine im KF vor Push | Hygiene-Liste; nach Push Vollzug mit
  fetch-Beleg.
83 | abgleich_super 4.3 | Thesis-Doppel-Submodul-Frage (historisch mehrfach
  vorgelegt, nicht in Sammelrunde) | Owner | EIGENER-POSTEN-Owner-Slot (naechste
  Vorlage mitfuehren oder ausbuchen) | keine im KF | KON61-Vormerkzeile.
84 | abgleich_super 4.3 | ##58b '|| echo honest-empty' 0 Vorkommen | super ci |
  EIGENER-POSTEN-W (Pruefposten vor W4-Bau) | keine im KF | Sammelblock KON61.
85 | abgleich_super 4.3 | doc-anchor-check-Wachen-Vorschlag | super | EIGENER-
  POSTEN-W (Vorschlag, W-Platz; F40-Klasse systemisch -- 2. Grossflaechen-Fall
  dokumentiert) | keine im KF | Sammelblock KON61.
86 | abgleich_super 4.3 | F1-Endbeleg-PDF-Tabellenzeile MANUAL_RUN | super |
  EIGENER-POSTEN-Echtlauf (#41-Kette, Stufe 4) | keine im KF | Echtlauf-Protokoll.
87 | abgleich_super 4.3 | Register-leerer-Klassen-Artefakt | super | EIGENER-
  POSTEN-W (#40 klein) | keine im KF | im #40-Rahmen.
88 | abgleich_super 4.3 | super-Abdeckungs-Invariante / da_unit-Sammel-Target ohne
  GLOBAL-APPEND | super | EIGENER-POSTEN-W (faellt unter #56-Posten) | keine im
  KF | mit #56 gefuehrt.
89 | verify_dump 18(8) | apps-Zaehlung 9 statt "10" (KON47-01) | Ledger | FIX-IM-
  KOMPLEXFIX (KON61-Zeile: korrigieren oder 10. Binary benennen -- Objektbefund
  9 add_executable) | eine Zeile in KON61 | Zeile vorhanden.
90 | luecken_dump 1/6 (abgleich_ce K34-Rest) | f15_compare_cli_smoke Inventar-
  Sichtbarkeit | ce CI | EIGENER-POSTEN-NACH-Push (1 Zeile: im naechsten gruenen
  ce-test:unit-Log pruefen, dass f15_compare_cli_smoke in build/Testing/
  ctest_unit_inventar.txt steht) | keine im KF vor Push | Stufe-3-Nachlauf-Zeile.
91 | luecken_dump 4 (abgleich_ce K37-Rest) | optionale timeout-Zeile 84m am Job
  test:coverage-guard | ce .gitlab-ci.yml | EIGENER-POSTEN-naechster-ce-Slot
  (optional; eine YAML-Zeile; nicht Vor-Push-pflichtig) | keine im KF | W-Slot
  protokolliert.
92 | luecken_dump 2/10/11 | Wellenplan-/Restlisten-Pflege: '5 Bloecke (6 Vorkommen,
  1 if/else-Paar)' nachtragen; ##08-Rest streichen (3 Messungen als Begruendung);
  ##20-B streichen + Vollzugs-Fussnote | super Wellenplan v2 | EIGENER-POSTEN-W
  (Doku-Pflege, datierte Nachtraege, nie loeschen) | keine im KF | Sammelblock
  KON61 (Pflege-Vormerk).
93 | luecken_dump 31 | Text-Gegenlese der 6 b2-Quittungen (5d67207b, eacd3182,
  58b5aff4, 1e31cd4b, 83e06159, 76a345e3) | KF-Verify | FIX-IM-KOMPLEXFIX (Auftrag
  an die VERIFY-STUFE: Quittungstexte gegen Objekt lesen; Objekt selbst ist bereits
  entlastet) | Verify prueft 6 von 6 | Verify-Report nennt 6/6 dreiwertig.
94 | pause3 7 | Platten-Waechter-Neustart vor Kombibau | Betrieb | FIX-IM-
  KOMPLEXFIX (Flankierung A5(3): run_in_background-Waechter df -BG, <=9G KRITISCH,
  <=14G WARNUNG, sleep 60; volle Platte legt auch Hooks lahm -- MEMORY) | vor A5
  starten, nach A5 beenden (Monitore nie stumm haengen lassen) | Waechter-Start/
  Stop im A5-Protokoll.
95 | abgleich_ce C10d | fixture_schema_subset_check-Werkzeug + Codex-Auflagen
  (Nichtleer-Pruefung, CDATA-Kante, Skip-bei-fehlend=rot) | ce (0 Dateien am Baum)
  | EIGENER-POSTEN-Task-#16 (Werkzeug kommt erst mit dem Golden-Fenster) | keine
  im KF | im #16-Auftrag gefuehrt.
96 | abgleich_ce C02 | Task #16 (golden festschreiben) seit T2 ENTFESSELT (P11 in
  origin UND P6 gemergt -- beide Vorbedingungen erfuellt) | Task #16 | FIX-IM-
  KOMPLEXFIX (Task-Text-Fortschreibung + KON61-Zeile "entfesselt"; Bau selbst
  bleibt WE+W1-Posten) | TaskUpdate #16 + KON61-Zeile | beide vorhanden.
97 | Owner D4 (Auftrag an KF) | Riegel-Echtfall-GEGENPRUEFUNG als Explore-Posten |
  s1-logs + ce Lock | FIX-IM-KOMPLEXFIX (Phase 0): READ-ONLY nachpruefen:
  (a) s7-riegel-echtfall-20260813.log existiert (2944 B) + Symlink 20260814;
  (b) Sequenz ROT Exit 1 -> --write (e580a636) -> GRUEN "718 ... 712 von 712" ->
  byte-identische Ruecknahme im Log woertlich; (c) Lock-sha am HEAD e7263b82
  unveraendert; (d) S-7-NULL-BEWEIS (0 Preimage-Bytes) gegen Diff-Liste (8 Dateien)
  | Explore-Quittung mit 4 Literalen | 4 von 4 Punkte belegt.
98 | KON60-08 + Owner B1 | F-G1-11-KONSTRUKTION aus Bestand (keine weitere
  Rueckfrage-Runde) | super docs/plaene/20260813-DESIGN-g1-...md | FIX-IM-
  KOMPLEXFIX (DOKUMENT-Nachtrag, kein Code): datierter KONSTRUKTIONS-NACHTRAG am
  publizierten G-1-Design: Kind-Stempel = das KOMPILAT (4 Zeilen, ZWEI separate
  Arrays System+Organ, nur Haupt-Achsen, nur Eingebautes); G-1-Slot-Projektion
  w-FUEHREND wenn die erzeugende CEB w traegt; (iii)-Wallclock-Definition woertlich
  (separater check-point measure wrapper CEB-seitig um das Gesamt-Experiment "vom
  Aufruf bis zur Fertigstellung"; Messfehler-Bestimmung als Belegungs-PAARE, genau
  EIN Schalter Unterschied; Anzahl gefahrener Belegungen entscheidet S-19);
  CebVersionen-Alias (konfiguration.hpp:40-44) als benannter Umbaupunkt; DAZU
  Phase-0-Bestands-Explore der START-Grenze (KON51-01 Lade-Verantwortung, KON25-08
  Raketen-Mechanik) -- erst Explore, dann ggf. praezise Frage, NICHT raten. Der
  WRAPPER-BAU selbst ist W-Strecke (B1-B5/#24) nach dem von Owner-B1 angeordneten
  10-Wochen-Explore -- NICHT Teil dieses Pakets | Design-Datei traegt den
  datierten Nachtrag; Explore-Quittung zur Start-Grenze liegt (Befund oder
  praezise Folgefrage).

--- NACHLESE DER 5 UNGELESENEN QUELL-JSONs (99-103; FIX-RUNDE 14.08.) ---

Nenner: 152 Quell-JSONs, 147 von Lesern gedeckt, 5 nachgelesen (Kopf-KORREKTUR).
Alle Objekt-Belege dieser 5 Zeilen sind Fix-Runden-Messungen 14.08. an ce 643102fb
und super 09cd97a3 (git read-only).

99 | Nachlese wuwemnde5 (F1-Beleg-Workflow, Quittung F1_NICHT_BELEGT) | F1-Glied-2-
  Kette: 5 offene Punkte des Workflows | super Code/05_diagram_generator + ci +
  Task #40/#41 | GETEILT: (a) 1x1-matrix-plot-Fatal (4 von 64 Artefakt-Dateien;
  pgfplots verlangt >=2x2) SCHON-BEHOBEN@865ff21d -- Fix-Commit 915038ca "Groessen-
  Wache 1x1/1xN/Nx1 -> HONEST-EMPTY statt pgfplots-Fatal" (+316/-15 inkl. Tests;
  ancestor-Messung). ORTSKORREKTUR: der Generator liegt in super
  Code/05_diagram_generator; ce traegt 0 'appendix_generator'-Pfade am HEAD -- die
  wuwemnde5-Ortsangabe "ce M08 comdare_appendix_generator" nicht weitertragen.
  (b) Kanal-Echtlauf (COMDARE_DURCHSTICH + COMDARE_ANHANG_FORWARD, Rule :2438):
  gedeckt als Stufe 4 (#41/#62/#86, Teil D DANACH; HONEST-EMPTY-Nenner #10;
  Task #41). (c) CI-Gate-Luecke "AF_PDF_GATE=auto ohne TeX prueft NICHTS":
  SCHON-BEHOBEN via texgate-Paket (Gate hart on, dbef5b0f; Runner-Variablen-Check
  per PAT beim Echtlauf = #41). (d) NE-01-ZAHLEN-KORREKTUR: die in NE-01 zitierte
  ns_per_op=644.020 gehoert NICHT zu Job 376333 -- echt ist n_ops=10000,
  ns_per_op=1199.047 (identisch in 3 von 3 CSV-Formen; '644' 0 Treffer im
  114244-B-Trace): FIX-IM-KOMPLEXFIX (KON61-Zeile via S3.5 + TaskUpdate #40/NE-01
  via S4.4; Herkunft der 644.020 dort als offen vermerken, nie weiter zitieren).
  (e) Thesis-Klon-Zustand (20260931-overleaf-diplomarbeit: lokaler Branch
  development = 863170f angelegt, main 11 hinter origin, Baseline-PDF/latexmk-Reste
  unversioniert): EIGENER-POSTEN-Hygiene-NACH-Push im #82-Zug (4-Klone-Sync) |
  (a)-(c) keine KF-Aktion, Belege in dieser Zeile; (d) S3.5+S4.4; (e) Hygiene-
  Liste | (d) KON61-Zeile + Task-#40-Text nennt 1199.047; (e) Hygiene-Liste nennt
  den Thesis-Klon.
100 | Nachlese w7rrni258 (E18-SNAP-Bau 06.08., Review-Verdikt LANDEBEREIT) |
  E-18-SNAP-Landung + 4 offene Lead-Entscheide | super ci/anhang_forward_core.sh +
  .gitlab-ci.yml | SCHON-BEHOBEN am Objekt: bda34e79 ist ancestor von HEAD
  09cd97a3; core.sh traegt 9 Treffer AF_COMPILE_SNAPSHOT, super-YAML 5 Treffer
  thesis_compiles -- gelandet in weiterentwickelter Form (Branches landung/
  e18-snap + landung/e18-snap-neu existieren; SNAP_PENDING 0 Treffer im YAML: der
  06.08.-Patch wurde nicht woertlich uebernommen, die Funktion ist da). Lead-
  Entscheide aufgeloest: Patch -> funktional gelandet; .gitignore-Negation ->
  durch compile-export.txt-Namensform gegenstandslos (*.log-Regel :52
  unveraendert); COMDARE_TEXLIVE_AVAILABLE -> #41-Echtlauf-Check; Repo-Wachstum
  ~1-5 MB je scharfem Lauf -> im E-18-SNAP-Vertrag gefuehrt (#42 kaskadiert
  dorthin) | keine KF-Aktion | Belege in dieser Zeile; der Echtlauf (Stufe 4)
  prueft den Schnappschuss real.
101 | Nachlese wjh71oern (KON45-Workflow 12.08.: Hybrid-Stempel + Festplatten-IO +
  E-WARMUP) | KON45-Vollzug + 2 Reste | Ledger + ce Kommentare + BU | GETEILT:
  (a) KON45 GELANDET (Ledger; Task #27 "Vorlage steht"); HY-A-Bump-Buendel,
  Comp-Gate, B1-B5-Mitfuehrung = W-Strecke #15/#24/#38a2+d (verwaltete Historie);
  die drei Ein-Satz-Vorlagen (Zell-Warmup, IO-Typ, Map-VALUE ##51) gehen mit der
  naechsten Owner-Vorlagen-Runde (OF-3). (b) Text-stale GliedCount-Kommentare:
  bestandslog_factory.hpp:87 "acht" + mess_achsen_naht.hpp:181 "= 8" (Fix-Runden-
  Nebenfund, gleiche Klasse) gegen real 9 (anatomy_fingerprint.hpp:416,
  static_assert :641): EIGENER-POSTEN-W (naechstes ce-Paket mit Schreibrecht,
  Muster #73; die Quelle disponiert selbst "naechster Aufraeum-Commit");
  KON61-Vormerkzeile im Sammelblock. (c) BU-Nachweis der drei Explore-Rohdaten am
  Objekt NICHT belegt (0 Treffer wjh71oern in alle-journale-20260812.tar.gz,
  467 Eintraege; kein 20260812-*-BU-Verzeichnis; nur kon-quellen/ledger-nachtrag-
  kon45.md liegt): FIX-IM-KOMPLEXFIX im S3.4-Zug -- Nachweis erbringen ODER
  additiv nachholen (BU-SOFORT) | (b) Vormerkzeile; (c) S3.4 | (b) KON61-
  Sammelblock traegt die Zeile; (c) BU-Commit ODER Nachweis dreiwertig im
  Protokoll.
102 | Nachlese wbckbar4m (R4 CI-Abdeckung 06.08.) | R4-Landung + Doppel-Key-
  Vorbefund | ce scripts/ + .gitlab-ci.yml | SCHON-BEHOBEN/GELANDET am Objekt:
  scripts/ci_test_coverage_manifest.sh + ci_test_coverage_guard.sh + Selbsttest
  liegen am HEAD 643102fb -- die R4-Mechanik ist die heutige A2-/Floor-Grundlage
  (CI-Praezedenz 15751: coverage-guard gruen, Selbsttest 5/5). Vorbefund
  "contract:axis-version-lock DOPPELT definiert (letzter Key gewinnt, Tripwire de
  facto aus)" am Objekt GEHEILT: genau 1 Schluessel am HEAD (Zeile 801, Zaehlung
  /usr/bin/grep -c = 1; die 06.08.-Doppeldefinition existiert nicht mehr).
  Ehrliche-Grenzen-Liste der Wache = dokumentierte Bauart, keine Posten | keine
  KF-Aktion | Belege in dieser Zeile; t6/A3 zaehlt die Schluessel-Menge mit.
103 | Nachlese wr48236je (Modi-Explore 07.08., Gedaechtnisluecken-Heilung) |
  4-Modi-Katalog bestaetigt; offene Enden | Plan-/Owner-Strecke | UEBERHOLT als
  Vor-Push-Posten: reiner Wissens-Explore, im Plan-Bestand aufgegangen
  (RunMethodology 4 Werte, XML-Wahl exactly-one, CUSTOM_COMPILE kein Modus).
  Offene Enden sind Owner-/W-Strecke, KEIN KF: D-1 PMU-Domaene in der Mess-
  Identitaet ("VOR DEM ERSTEN BATCH"-Fessel), O-C/D-7 pe_policy-Werteset,
  mess_geltung-Spalte (Namen zur Owner-Abnahme), platform-Spalten-Reparatur
  (Profil-Literal statt messender Maschine) -- alle im PMC-/W2-Rahmen (#24/#79;
  Owner-Antworten 10.08.: PMC = Meta-Meta-Achse) bzw. der naechsten Owner-
  Vorlage; "Modus-x-Plattform-Matrix existiert nicht" ist Doku-Nichtexistenz,
  kein Defekt | keine im KF | im #24-/W2-/Vorlagen-Rahmen gefuehrt; diese Zeile
  dokumentiert die Zuordnung.

================================================================================
## TEIL C -- PAUSEN-SORGFALT (Pflicht-Posten P1-P4; Owner-Auflage 13.08.)
================================================================================
Grundlage: abgleich_pausen.md hat alle 5 pausierten Workflows (F1-Fix wf_a7e55a90-2a8,
Luecken wf_046aab6c-928, S-7 wf_81efb13f-45b, Wachen wf_b6b05f65-923, F1-Lens
wf_61f2b36f-712) gegen ihre ORIGINAL-Scripts geprueft (Zeile fuer Zeile) und an den
Journalen verifiziert. Der Komplex-Fix uebernimmt die vier Achsen als PFLICHT-POSTEN
mit dem jeweils verbleibenden Rest:

P1 AUFTRAGS-DECKUNG: BEFUND VOLL bei 5 von 5, mit 5 DEKLARIERTEN, quellenseitig
   begruendeten Abweichungen (bash/sh; Riegel-Praemisse stale KON58-01; Floor-Commit-
   Form "eigener Commit" per DAMALIGEM Datei-Kopf -- als historische S-7-Abweichung
   tragbar, als Vorwaerts-Regel FALSCH: seit dem gelandeten ANKER-Kopf gilt "im
   SELBEN Change" (:25-33), "eigener Commit" ENTFALLEN (:35-41), s. #47/A2;
   Branchname lt. Task-Order; Kombibau-Interpretation 1x4 statt 8). PFLICHT-FIX: die 5 Abweichungen als Block in das
   KF-Abschlussprotokoll + KON61 (eine Sammelzeile) -- Quittungen NIE als P1-Beleg
   nehmen, nur das Objekt (Praezedenz: Wachen-Verify fand fehlende 6eb72ace-Quittung;
   S-7-Quittung transport-abgeschnitten).
   ERLEDIGT: Protokoll-Block + KON61-Zeile vorhanden.
P2 CACHE-STALE-KONTEXT: GEHEILT in allen 5 (Resume-Fix-Straenge per NEUMESSUNG am
   Endstand; Resume-Bau-Straenge per STAND-UPDATE-Block). PFLICHT-FIX: KEINER offen;
   in das Protokoll uebernehmen, dass kein stale Einfluss in Commits gefunden wurde
   (Nachweis-Zeilen aus abgleich_pausen 1-5).
   ERLEDIGT: Protokoll-Vermerk.
P3 WIP-UEBERNAHME: 3 von 3 WIP-Commits beweisbar aufgegangen (c642c35d Delta 3 Zeilen
   diagram_generator, geprueft; 6b89fce5 4 von 4 Inhalte disponiert, Sicherungs-Branch
   wip/luecken-stufe2-pause-1308 steht befohlen; c0ff9986 diff zu 07a60cc7 = 0 Bytes).
   Verlust 0/3, ungeprueft 0/3, Doppelfassung 0/3. PFLICHT-FIX: KEINER offen;
   Protokoll-Vermerk. Der Sicherungs-Branch bleibt STEHEN (Script-Order) bis nach
   CI-gruen; Abbau nur nach Worktree-Lebenszyklus-Regel.
   ERLEDIGT: Protokoll-Vermerk.
P4 FIX-STUFEN-VOLLSTAENDIGKEIT: Bilanzen F1-Fix 9->9, Luecken 7->7, S-7 5->5 (der
   1 VERTAGT am Objekt geschlossen), Wachen 5->5, F1-Lens 16->24 (Aufspaltung, jede
   Fund-Nr gedeckt; Kopfzeilen-Zaehlung "20 [4/15/1]" NICHT weitertragen -> #67).
   Zwischen Stop und Resume aufgelaufene Zusatz-Funde: keine (belegt). PFLICHT-FIX:
   Zaehlkorrektur #67 in KON61; sonst Protokoll-Vermerk.
   ERLEDIGT: KON61-Zeile (#67) + Protokoll-Vermerk.

RESTPOSTEN-DISPOSITION R1-R10 (aus abgleich_pausen 8, Stand vom Designer nachgezogen):
R1  Registry-XML-Regen [ROT] -> Teil B #61 (FIX-IM-KOMPLEXFIX, Phase 1).
R2  F44-Beleg aktenkundig -> #66 (Protokoll).
R3  Floor-EINMAL-Messung -> SCHON-BEHOBEN@643102fb, Rest A5 (#2/#65).
R4  Wachen-BU-SOFORT -> #55 (Phase 3).
R5  Zaehlkorrektur -> #67 (KON61).
R6  Task-#41-/Rezept-Text -> #7/#10 (Protokoll/TaskUpdate).
R7  zweites honest-empty-Paket -> #68 (UEBERHOLT am Objekt: 0 voraus/622 hinter).
R8  e21-/texgate-Merges + KON-Nummer -> SCHON-BEHOBEN@ad742bdc/dbef5b0f/09cd97a3;
    naechste freie Nummer = KON61 (Designer-Messung 0 Treffer; KON35-Praezedenz:
    nie doppelt, nie Luecke unerklaert -- Vergabe im Nachtrag begruenden).
R9  Owner-Antworten-Lage -> #69/Teil E (eingearbeitet).
R10 Workflow-Identitaet nur ueber runId/Journal -> #70 (KON61-Doktrin-Zeile).

================================================================================
## TEIL D -- PAKETIERUNG (EIN Paket, KON57-Muster)
================================================================================

FORM: EIN Paket, EIN Workflow (Fable 5 max fuer Analyse/Review/Fix; Einlese-/Explore-
Subagenten Fable 5 XHIGH -- Owner-Order 13.08. praezisiert; MEMORY-Kopfzeile "ueberall
nur Fable 5 max" gilt fuer Steuerung/Auswertung, die XHIGH-Praezisierung ist die
juengere Owner-Order fuer Tieflesen). Schreibrechte: ce-Worktree der Landung
(wt-super-landung/Code/external/comdare-cache-engine) + super wt-super-landung --
EIN Schreiber je Worktree; git commit nimmt die GANZE Staging-Area (kein add -A).
KEIN Push im Paket (Push = Stufe 3 danach). Jede Zahl mit Nenner; /usr/bin/grep
absolut; rc NIE hinter einer Pipe (K11); ASCII-only fuer neue Zeilen; gitleaks-Koeder
glpat-+20 aus wirksamer Config-Regel.

REIHENFOLGE (mit Begruendung: Code-Fixes VOR Regen-Schritten, damit der Regen den
Endstand sieht; Kombibau+Lock+Floor am ENDE EINMAL am finalen SHA; super-Schritte
nach ce, damit KON61 die finalen ce-SHAs verbuchen kann):

PHASE 0 -- GROSSES EXPLORE (Owner-GO-Bedingung; read-only):
  S0.1  Objekt-Stand frisch messen (SHAs, Bereiche, Anker; Kopf-Werte verifizieren).
  S0.2  #97 Riegel-Echtfall-Gegenpruefung (D4) -- 4 Literale.
  S0.3  #98-Explore Start-Grenze der Wallclock-Klammer (KON51-01/KON25-08; Befund
        oder praezise Folgefrage, nicht raten).
  S0.4  B4-Historie-Explore (xlsx/csv-Doktrin-Kette; Beleg fuer #24-Commit und
        #25-Commit; 10-Wochen-Explore-Norm: Rohtranskripte zuerst, Falsch-Null-
        Fallen Encoding/Case/95-Zeichen-Umbruch).
  S0.5  B2-Widerspruchs-Check zitieren (0 von 8 Kollisionen im 62er-Katalog --
        bereits erhoben, nur referenzieren).
PHASE 1 -- ce CODE/DATEN (Reihenfolge bindend):
  S1.1  #48 simd_build_gate-Kommentar (mit Lock-Mitgliedschafts-Messung; ggf.
        Lock--write im selben Commit, deklariert).
  S1.2  #61 XML-Regen-Probe (2-Pass; 0-Diff zulaessig; bei Diff Commit).
  S1.3  #24 xlsx-Bloecke in 3 Profile (additiv; B4-Beleg im Commit-Text).
  S1.4  #26c allow_failure-Deklarationen :257/:919 (Kommentar-Zeilen, ein Commit).
  S1.5  #74 Task-#42-Auflagen-Check (ggf. 1 Audit-Zeile).
        Begruendung Buendelung: alle ce-Objekt-Aenderungen VOR der einmaligen
        Messkette; jeder Schritt eigener Commit mit Nenner-Text.
PHASE 2 -- ce MESSKETTE EINMAL am finalen SHA:
  S2.1  #94 Platten-Waechter starten (df-Gate).
  S2.2  A1-Duplikat-Check (231er-Messung) + A4 Lock --check (712/712-Literal).
  S2.3  A5 Kombibau 4 Zellen sequentiell (J-1..J-4; EXCLUDE_FROM_ALL explizit;
        t6/lizenz/Floor-Guard mitlaufend; #49-Beobachtung; Raeumen 0/0; Waechter
        danach beenden).
PHASE 3 -- super FIXES:
  S3.1  #25 ##26-M==N-Haertung + Bissprobe (T-1 rot zuerst; Anker frisch).
  S3.2  #40 Kopfzahlen-Nachmessung + MANUAL_RUN:279-Nachzug (11 Zahlen Soll==Ist).
  S3.3  #98 G-1-Konstruktions-Nachtrag (Dokument, datiert).
  S3.4  #55 BU a25_wachen_fix + PAUSE-3-Dokument + regressions-gesamtbild additiv
        (je Koeder-Scan-Kette literal) -- BU-SOFORT-Regel; dazu #101c KON45-
        Explore-Rohdaten: Nachweis erbringen ODER additiv nachholen (Fix-Runden-
        Messung: 0 Treffer wjh71oern im 20260812-Journal-Tarball, 467 Eintraege).
  S3.5  KON61-Sammel-Nachtrag via scripts/ledger_nachtrag.sh, EIN Schreiber, EIN
        Block (Inhalte: #15 "C1 an Infra uebergeben" (mit #30-Block), #16
        non-ASCII-Bestand-Entscheid-Vermerk, #30 Anker, #32 Zaehlwerke, #33
        B5-Seriell, #34 "C2 erhoben, Owner entscheidet", #35+#80 Branch-Urteile
        13+5, #46 NE-10, #67 Zaehlkorrektur, #68 honest-empty-Ausbuchung, #70
        runId-Doktrin, #89 apps=9, #96 #16-entfesselt, #99d NE-01-Zahlen-
        Korrektur 1199.047, P1-Block, Vormerkzeilen #9/#37/#42/#56/#63/#71/#75/
        #78/#83/#84/#85/#92/#101b als EIN Sammelabschnitt "NACH DER WELLE";
        Vergabe-Begruendung KON61 mit 0-Treffer-Messung). Fix-Runden-Nachtrag
        14.08.: #15/#16/#34 waren von ihren Dispositionen zwingend versprochene
        KON61-Zeilen und fehlten in dieser Liste (Pruefpunkt 1/7). Begruendung
        Position: NACH allen Code-Fixes, damit die verbuchten SHAs final sind.
PHASE 4 -- ABSCHLUSS-GATES (super+ce):
  S4.1  A3.b Meta-Gate INVENTAR-Modus (M frisch, X+Y==M).
  S4.2  A6 Diff-Hygiene PUSH-LOKAL beide Repos (origin/development..HEAD).
  S4.3  A1-Wiederholung falls Phase-3-Commits ce beruehrten (SOLL: nein).
  S4.4  Abschlussprotokoll: #7/#10 (Task-#41-Text), #47 (Memory-Nachzug "im
        SELBEN Change", :25-33), #99d (TaskUpdate #40/NE-01-Text: 1199.047 statt
        644.020), #66 (F44-Zitate), #20-Vormerk, Hygiene-Listen (#81/#82/#99e
        Thesis-Klon, Worktree-Abbau erst nach CI-gruen+Submodul-Branch-Pruefung),
        P1-P4-Vermerke; BEIDE Mengen nennen: geprueft UND nicht geprueft (ein
        gruenes Gate deckt nur seinen Gegenstand).

QUITTUNGS-PFLICHT: JEDER Posten der Phasen 0-4 wird DREIWERTIG quittiert
(BEHOBEN@SHA / ENTLASTET+Beleg / VERTAGT+Ort+Frist); Anzahl Quittungen == Anzahl
Posten (P4-Doktrin); Platzhalter ("TEST", leere Abschnitte) gelten als Ausfall.

VERIFY-STUFE (eigene Workflow-Phase, adversarisch, Fable 5 max; Zuarbeit XHIGH):
  V1  P1-Nachpruefung DIESES Pakets gegen DIESES Design (Posten fuer Posten am
      Objekt; Quittungen zaehlen nicht als Beleg).
  V2  #93 Text-Gegenlese der 6 b2-Quittungen.
  V3  #38/#81-Anteil: W0b-Endstaende am Objekt (Pipeline-Messung als Stufe-3-
      Nachlauf kennzeichnen).
  V4  Mess-Wiederholung der Kernzahlen (Floor-Guard-Literale, 231, 712/712,
      ctest-N) UNABHAENGIG vom Bau-Log.
  V5  Koeder-Stichprobe: mindestens EIN Guard-Biss beidseitig frisch (K13; z.B.
      ##26-Bissprobe rot->gruen).
A2.5-FIX-STUFE (eigene Workflow-Phase): Verify-Funde im SELBEN Paket beheben
(LUECKE=BEHEBUNGS-PFLICHT, kein "Randfall"); danach betroffene Gates EINMAL
wiederholen; neue Funde -> Sammelliste-Nachtrag; BU der Workflow-Rohdaten SOFORT
nach Fertigstellung (additiv).

DANACH (NICHT Teil des Pakets, Stufe 3 der Drei-Stufen-Landung): ce-Push -> ce-CI
TERMINAL SUCCESS -> Gitlink-Bump 5f3f26a5 -> <ce-final> ATOMAR mit PZW-Fussnote ->
super-Push -> super-CI gruen -> Hygiene (#81/#82/#90, Worktree-/Branch-Abbau nach
Regel) -> A1-DURCHZUG (KON60-03: alle 18 Organ-Achsen required, EIN Workflow,
Sechs-Stationen-Abnahme je Achse) -> F1-Echtlauf (Messung + ANHANG_FORWARD,
bash-Rezept, HONEST-EMPTY-Nenner #10) -> F1-Endbeleg.

================================================================================
## TEIL E -- OWNER-ANTWORTEN 13.08.: EINARBEITUNG (verbindlich)
================================================================================

A1 (C-3a): "ALLE Organ-Achsen-required GEMEINSAM in EINEM Workflow-Durchzug, volle
  Verlinkung, anhand existierender fast vollstaendiger Beispiele; C-3a-Fallregel
  obsolet." -> Gebucht KON60-03. KONSEQUENZ: #46-Objektlage (Tripwire :272
  unberuehrt) bleibt bis zum A1-Durchzug; der Durchzug ist NACH dem Push terminiert
  (eigener Workflow, Sechs-Stationen-Abnahme je Achse, K-3-Rest schliessen oder als
  Grenze deklarieren); die Mi-19.08.-Frist und Fallregel 18.6(3) sind GEGENSTANDSLOS.
  Im KF: nichts bauen; Findings mit A1-Bezug (K46) auf UEBERHOLT gestellt.
A2/C1 (MinIO-Keys, Token-Rotation): Infra-Handout geschrieben (Cluster-Repo), Owner
  loest Infra aus -- KEIN Session-Bau. -> #15 UEBERHOLT; KON61-Zeile "an Infra
  uebergeben"; Task #10 bleibt beim Owner/Infra.
B1 (Wallclock/Kind-Stempel): 10-Wochen-Explore, "alles laengst entschieden";
  Wallclock = separater check-point measure wrapper um die GESAMT-Experiment-
  Ausfuehrung auf CEB-Seite (Aufruf bis Fertigstellung); Differenz MIT/OHNE
  Tier-Messfuehler = Messfuehler-Messfehler; Tier-Binaries tragen die im Plan
  definierten Stempel ihres KOMPILATS (getrennte Kategorien Mess/System/Organ,
  ZWEIPHASIG oder DREIPHASIG je Achsen-Kategorie). -> Gebucht KON60-08 ("(iii)-
  Wallclock-Definition"; F-G1-11 aus Bestand; "KONSTRUKTION im Komplex-Fix, keine
  weitere Rueckfrage-Runde"). EINARBEITUNG: #98 = Dokument-Konstruktions-Nachtrag
  + Start-Grenzen-Explore IM KF; der WRAPPER-CODE-BAU ist B1-B5-/W-Strecke (#24)
  NACH dem 10-Wochen-Explore -- RANGFOLGE Owner > Plan: die Explore-Pflicht der
  Owner-Antwort geht der Formulierung "Konstruktionsarbeit Komplex-Fix" im
  6e796ae5-STATUS-NACHTRAG vor, soweit CODE gemeint waere; DOKUMENT-Konstruktion
  geschieht hier. Messfehler-Bestimmung als Belegungs-PAARE (genau EIN Schalter
  Unterschied); Anzahl gefahrener Belegungen entscheidet allein S-19.
B2 (G-1-Vokabular): "nach Explore autonom uebernehmen, wenn kein Widerspruch gegen
  Achsen/Syntax." -> VOLLZOGEN: 0/8-Kollisions-Explore lag vor; F-G1-1 (EIN Parser)
  + F-G1-2 (m / b h t / w ma mi) autonom uebernommen (6e796ae5, KON60-07). F-G1-3..
  -10/-12 bleiben Owner-Fragen (9 von 12) -- KEINE stille Selbst-Beantwortung im KF.
B3 (Zielstruktur-Namen ENGLISCH, "planner" statt "planer"): VOLLZOGEN VOR
  Publikation -- 85c1174d fuehrt durchgaengig 'planner' (Designer-Messung: 0
  planer-Zielnamen, 23 planner-Treffer; Namens-Stand-Zeile im Kopf, R5/Par.6.1
  nachgezogen; Kollision mit Bestand profile_facade/planner aufgeloest: EIN Name).
  Im KF: nur Bestaetigungs-Messung im Verify (V1), kein Eingriff. Sonst Design
  bestaetigt (Defaults stehen).
B4 (xlsx-Doktrin): "Es gibt keine CSV ohne xlsx und xlsx ist Standard" +
  10-Wochen-Explore zur Historie. -> Gebucht KON60-05 (xlsx=STAMM, csv=KIND;
  Erzeugungs-Doktrin, KEINE Platten-Existenz-Regel; ##26-Wache bekommt KEINE
  xlsx-Existenz-Pruefung). KONSEQUENZEN IM KF: #24 (3 Profile xlsx additiv,
  aufgewertet zur Doktrin-Angleichung) + #25 (##26-Fix-Form woertlich per
  KON60-05) + S0.4-Explore-Beleg an beide Commits. Formale GO-Luecke (B4/B5 ohne
  woertliche "Freigabe") wird NACHRICHTLICH gefuehrt, nicht verschwiegen.
B5 (kVollausbau): "KEINE Einschraenkung der Implementierung gegen den Plan --
  genauso wie geplant." -> Gebucht KON60-06 (Status quo, keine Signatur-Zulassung,
  kein Katalog-Ausbau). Im KF: #52 zu; NICHTS bauen.
C2 (Umbrella-CI): Nachmessung erledigt (Fehlbild seit mind. 10.08., letzte gruene
  06.03.) -> #34 als Session-Posten UEBERHOLT; Entscheid (a/b/c) beim Owner;
  KON61-Zeile.
C3/D1/D2 (Kenntnisnahmen): zugestellt/verbucht (fa75d47c + KON60-11); keine Aktion.
D3 (Voll-ctest + Lager): "Voll-ctest bleibt Pflicht in jeder Pipeline" -> A5/D-
  Messkette fahren die VOLLE Suite (kein Test-Skip); "Lager verwaltet ALLE
  Traeger-Stufen mit und ueberspringt Builds bei gleichem Teilprojekt-Commit
  (Stempel = Identitaet/Cache-Schluessel/Lager-Schluessel/Skip-Marke/Einordnung)"
  -> Lager-Bau = W-Strecke (S-17/D3-Novum "Teilprojekt", KON60-09, dreigeteilte
  Buchung Compiler/Test/Build-Skip); im KF KEIN Lager-Bau.
D4 (Riegel-Echtfall): Kenntnisnahme MIT Explore-Gegenpruefung -> #97 in Phase 0;
  landender Echtfall bleibt Pflichtschritt des naechsten echten algo_version-Bumps
  (S-6-Fenster, KON60-04).

================================================================================
## OFFENE FRAGEN (nicht blockierend; KEINE Rueckfrage-Runde vor dem Paket)
================================================================================
OF-1  B4/B5 tragen kein woertliches Bau-GO ("Freigabe" nur an C3/D1/D2/D3/D4
      vergeben); der ##26-Bau stuetzt sich auf KON60-05-Zuweisung + Dauerregel
      LUECKE=BEHEBUNG -- die formale Luecke wird in der naechsten Owner-Vorlage
      nachrichtlich gefuehrt (kein Blocker).
OF-2  Start-Grenze der Wallclock-Klammer ("vom Aufruf": liegt Pruefdock-Laden/
      Anschliessen in der Gesamtzeit?) -- erst S0.3-Bestands-Explore; nur falls
      der Bestand sie nicht hergibt, praezise Owner-Frage in der naechsten Vorlage.
OF-3  F-G1-3..-10 + F-G1-12 (9 von 12) bleiben Owner-Entscheide der naechsten
      Vorlagen-Runde (mit C-3a-Vollzugsbericht, Umbrella-C2, Thesis-Doppel-
      Submodul #83, Vormerkungen #9/#42/#63, KON45-Ein-Satz-Vorlagen Zell-Warmup/
      IO-Typ/Map-VALUE ##51 aus #101a).

SELBSTCHECK: ASCII-only (LC_ALL=C, Muster [^\x09\x0A\x20-\x7E], SOLL 0 Treffer --
nach dem Schreiben am Objekt gemessen); keine Platzhalter, keine leeren Abschnitte;
jede Zahl mit Nenner oder Mess-Ref; alle 103 Teil-B-Posten mit Disposition UND
Anweisung/Kriterium; Schreiborte nur tmp/komplexfix_design.md + Arbeitsverzeichnis;
Repos ausschliesslich lesend beruehrt (git log/show/diff/branch/worktree/ls-tree/
rev-list/rev-parse/status).
