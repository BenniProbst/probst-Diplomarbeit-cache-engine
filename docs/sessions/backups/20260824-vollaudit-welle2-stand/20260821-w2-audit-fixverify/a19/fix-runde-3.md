# FIX RUNDE 3 - Strang a19 (A2.5-Fix-Stufe), 23.08.2026

Rolle: Fable-max-Konvergenz-Pruefer+Fixer (S2-Aufgabe a19), Fortsetzung nach Riss.
Eingang VOLL gelesen: soll-karte.md (401 Z.) | audit-runde-1.md (117 Z.) | fix-runde-1.md
(107 Z.) | audit-runde-2.md (203 Z., Verdikt FIXES_NOETIG) | lande-auflagen.md (63 Z.) |
beide VORHER-Beweiskopien. Juengster Verdikt-Stand bei Rundenbeginn: audit-runde-2.md
= FIXES_NOETIG (A19-F4) -- der Fix dazu lag am Objekt bereits vor, war aber unquittiert
(-> fix-runde-2.md nachgereicht).

Objekt: /home/comdare/backups-workflow/20260820-w2-sofortstaffel/a19-volltexte-ergebnis.md
(vorher 390 Z., md5 76d4af7e; nachher 505 Z., md5 8118bd19; Vorher-Stand gesichert als
a19-volltexte-ergebnis.VORHER-fix-r3.md). Zweite beruehrte Datei: lande-auflagen.md
(vorher 63 Z., md5 04c8e98e; nachher 140 Z., md5 49fdc471; Vorstand als
lande-auflagen.VORHER-fix-r3.md).

DOKU-STRANG: kein Bau-Gegenstand, kein Bauslot belegt (regelkonform: es fand kein Bau statt),
kein Vollbau, keine Rot-Laeufe, kein ctest, kein clang-format-Pfad (nur Markdown).
Repos NUR GELESEN (super: grep/sed/git log am Ledger + Session-Docs; ce: nur worktree/branch-
Negativproben; prt-art unberuehrt). Ledger/Board/Memory/Synthese NICHT geschrieben --
alle Lead-only-Anteile gehen als L4/L5/L6 in lande-auflagen.md.

--------------------------------------------------------------------------------
## QUITTUNGEN (dreiwertig, je mit eigenem Beleg)

### A19-F5 [MILD] -> BEHOBEN
FUND: Die D-04-Praemissen-VORLAGE-ZEILE in Abschn. 3.4 -- die der Lead laut S2SYN Z.212/255
als F-122 ins F2-Fenster traegt -- war durch die Owner-Antwort Tranche 2 UEBERHOLT. Sie haette
(a) einen bereits erteilten Owner-Entscheid erneut erbeten und (b) dem Owner einen Halbsatz
vorgelegt, den seine eigene Antwort widerlegt.

FIX (additiv, nichts geloescht):
1. Abschn. 3.4, direkt nach der VORLAGE-ZEILE: datierter NACHTRAG-Absatz (30 Z.) nach dem
   Muster des F1-Fixes -- VORLAGE-ZEILE ausdruecklich ENTWERTET ("NICHT mehr an Fenster/Owner
   zu uebertragen"), die drei Folgen einzeln benannt, dann eine ERSATZ-ZEILE formuliert, die
   aus der Entscheid-Bitte eine KENNTNISNAHME macht.
2. Abschn. 3.2(e): 5-Zeilen-NACHTRAG -- der dort zitierte F2-Fenster-Stand vom 21.08. ist
   ueberholt; das Fenster fuehrt den Block aber weiter als Entscheid (Lead-Sache, L4).
3. Abschn. 3.4, erster Spiegelstrich: 3-Zeilen-Zeiger, damit die Aussage "Rest = enge
   Ratifikation, owner-gated" nicht ohne Korrektiv gelesen wird.
4. Lade-Auflagen: L2 mit UEBERHOLT-Banner versehen (gilt nur noch fuer den Anker-Mechanismus),
   neue L4 mit Sachstand, drei Folgen (Uebertrag/Fenster/S2SYN) und Herkunfts-Anmerkung.

EIGENER BELEG (in dieser Runde selbst gehoben):
(a) Ledger Z.137-140 (KON120-02 TRANCHE 2) literal: 'D-04 "mathematisches Definitions-Bereich
    Command pattern" VOLLES GO ALLE Familien (Hermite/Splines/B-Splines/Linien/quadratisch<=3/
    Log/Wurzel; Entropie-Filter 1, Fehlerrate-Filter 2; eigene Matlab-aehnliche Definitions-
    Sprache, Lager-Ablage; 12W-Explore + "Komponente 1 bis 4" suchen)'.
(b) Owner-Wortlaut, docs/sessions/20260822-SESSION-owner-antworten-tranche-1-2-zuordnung-und-
    vollzug.md Z.102-113: "Volles GO fuer ALLE diese Felder als mathematisches Definitions-
    Bereich Command pattern." und "Die enge Hermite-Ratifikation aus D-04-alt ist damit
    ERWEITERT, nicht widerrufen: Hermite bleibt EINE der erlaubten Familien."
(c) KON121, Ledger Z.62-64: "PRAEZISIERUNG zu KON120-02: der 21.08.-Hermite-Ratifikations-
    vorschlag ist durch D-04 UEBERHOLT (nicht vollzogen)"; Zweitbeleg in
    docs/sessions/20260822-SESSION-zwischendoku-vollpruefung-offene-und-vergessene-arbeit.md
    Z.310-316 (dort ausserdem: "OV-1-Konsolidierung NIE vollzogen (3 Stacks leben)").
(d) IDENTITAETS-GEGENPROBE gegen die Label-Kollisions-Warnung S-2 der Soll-Karte: Die
    Owner-Tranche-2-Buchstaben decken sich 1:1 mit den F2-Fenster-Deltas -- D-02 (type_phase_
    rank-Rename), D-05 (G-1-Restfragen), D-06 (ce-Standalone-SCHEMA-Bein), D-07 (cp/ce-
    Klammerformen), D-10 (OV-16+OV-17) sind in Ledger Z.137-145 und F2FENSTER Z.25-64 jeweils
    derselbe Gegenstand. Es ist also dasselbe D-04, nicht eines der vier gleichnamigen
    Ledger-Fremdthemen. Dieser Abgleich war noetig, weil S-2 genau davor warnt.
(e) DRINGLICHKEITS-BELEG (der Uebertrag steht noch aus, der Fix kommt also rechtzeitig):
    `grep -c "Praemissen-Hinweis"` im F2-Fenster = 0; der D-04-Block steht dort unveraendert
    in Z.36-39 als "[ENTSCHEID, EIN Satz] ... EIN Entscheid erbeten" (Datei-mtime 22.08. 06:44).
(f) HERKUNFT (Beweislage, nicht Vorwurf): Der D-04-Beleg kam mit Commit 657003bb
    (22.08. 06:32:44) -- DERSELBEN Commit-Ladung, die KON120-05 brachte, also VOR Fix R1
    (06:58) und vor Audit R2 (07:08). Die drei Vorrunden haben KON120-05 gehoben, KON120-02
    danebenstehen lassen. Der Fund ist nachgezogen, nicht neu entstanden.

WARUM MILD (Einordnung nach dem Praezedenzfall A19-F1): Gleiche Klasse -- eine
weiterzureichende VORLAGE-ZEILE ist durch eine juengere KON ueberholt, die Design-
SELBSTCHECK-Regel "Entschiedenes NIE als offen" ist beruehrt. Schaerfer als F1 ist nur, dass
hier zusaetzlich ein SACHLICH widerlegter Halbsatz an den Owner gegangen waere; milder ist,
dass der Uebertrag nachweislich noch nicht stattgefunden hat. Die Recherche-Substanz des
Strangs ist NICHT betroffen: die Sachfrage-Chronologie (08.08. 09:44), das 7h-spaetere
Etikett, E-5 und die OG-52-Schliessung stehen unveraendert -- sie sind durch die Owner-Antwort
sogar bestaetigt worden.

### A19-F6 [KLEIN] -> BEHOBEN
FUND: Der Zaehl-Halbsatz in 3.2(c) ("OV-1\b" = 2 Treffer nach dem F3-Fix) ist erneut
untererfasst; seit KON121 gibt es DREI.
FIX: In 3.2(c) additiv ergaenzt (in-place-Verlaengerung der bestehenden Klammer, exakt das
Muster des F3-Fixes aus Runde 1) mit Treffer, Fundstelle, Commit, Einordnung als
Status-Erwaehnung sowie einer Praezisierung des Schluss-Halbsatzes. Das AENDERUNGS-PROTOKOLL
im FIX-NACHTRAG R3 haelt den Original-Wortlaut literal fest.
EIGENER BELEG: `grep -nP 'OV-1\b'` am Ledger (23.08., 32387 Z.) = GENAU DREI Treffer --
Z.61 (KON121-Explore-Kern, "OV-1 nie vollzogen"), Z.12433 (KON7-05-Kontext), Z.18474
("Gegenprobe OV-1 = 8"). Herkunft des Neutreffers per `git log -S 'OV-1 nie vollzogen'`:
GENAU EIN Commit, 00c341a0 vom 22.08. 07:10:22 -- er entstand 40 Sekunden vor dem Fix-R2-
Schreibzugriff (07:11) und konnte von Audit R2 (07:08) noch gar nicht gesehen werden. Die
Zaehlung "GENAU ZWEI" in audit-runde-2.md war zum Messzeitpunkt korrekt.
KERNAUSSAGE HAELT: Auch Z.61 ist keine Buchung, sondern eine Status-Erwaehnung innerhalb der
D-04-Explore-Verbuchung. Praezisiert wurde nur der Geltungsbereich des Schluss-Halbsatzes.

--------------------------------------------------------------------------------
## VOLLZAEHLIGKEITS-GATE
Offene Funde bei Rundenbeginn: A19-F4 (aus Audit R2) -- am Objekt bereits behoben, in
fix-runde-2.md nachquittiert und in dieser Runde unabhaengig nachgemessen.
Neu erhobene Funde dieser Runde: A19-F5, A19-F6 -- beide oben quittiert.
Bilanz: 6 Funde ueber drei Runden (F1..F6), davon 6 BEHOBEN, 0 ENTLASTET, 0 VERTAGT.
Gegenzaehlung an den Berichten: audit-runde-1.md traegt drei "### A19-F"-Koepfe,
audit-runde-2.md einen, audit-runde-3.md zwei = 6. Keine Quittung fehlt, keine doppelt.

## AENDERUNGS- UND ASCII-BILANZ (Beweis)
diff VORHER-fix-r3 -> Endstand: 116 Zeilen neu, GENAU 1 Bestandszeile in-place ersetzt
(3.2(c)-Schlusszeile; Original-Wortlaut im AENDERUNGS-PROTOKOLL des FIX-NACHTRAGs R3 literal
festgehalten, Vollstand in der Beweiskopie). Fuenf Hunks: 277c277,285 | 297a306,310 |
311a325,327 | 322a339,368 | 390a437,505. Nichts geloescht.
Nicht-ASCII ueber ALLE eingefuegten Zeilen (`diff | grep '^>' | grep -P '[^\x00-\x7F]'`):
**0 Treffer** in BEIDEN Dateien -- diese Runde hat kein einziges Nicht-ASCII-Zeichen
eingefuegt (die erste Fassung enthielt 12 Gedankenstriche/Mittelpunkte, alle vor Rundenabschluss
auf "--" bzw. "|" transliteriert; die Bestandszeilen blieben unangetastet).
TABU-Zonen: `git status --porcelain` in ce ueber axes/topics/heuristik/tests/unit/CMakeLists.txt/
.gitlab-ci.yml = leer; Ledger + docs/sessions = leer (0 Schreibzugriffe). clang-format: n/a.

## EIN-GATE-REGEL (beide Mengen)
Dieses Fix-Gate deckt: die zwei Funde A19-F5/F6 am Doku-Objekt a19-volltexte-ergebnis.md,
die Nachquittierung von A19-F4 und die Uebergabe der Lead-only-Anteile (L4/L5/L6).
Es deckt NICHT: die Lead-only-Schreibungen selbst (F2-Fenster-D-04-Block, S2SYN Z.210/212/
255/308, Ledger), den F5-Mirroring-Objektstatus und die uebrigen KON120-05-Restposten
(Traeger #84-Umfeld/Infra), die #96-Buchung (Di 25.), den 12W-Explore aus der D-04-Antwort
(Traeger #119) sowie jeden Bau-/ctest-Gegenstand (der Strang hat keinen) und die uebrigen
17 Staffel-Straenge.

STATUS: Alle Funde BEHOBEN; Strang a19 bleibt LANDEREIF, jetzt mit erfuellter Audit-Auflage
und einer STEHENDEN Auflage (L5), die die Anker-Drift-Schleife am Uebergabepunkt schliesst.
