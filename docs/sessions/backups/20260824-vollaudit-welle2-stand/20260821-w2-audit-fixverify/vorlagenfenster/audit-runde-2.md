# AUDIT RUNDE 2 (RE-VERIFY) — Strang "vorlagenfenster" (B-4, F2-Owner-Vorlagen-Fenster)

Re-Verifier: Fable-max, 22.08.2026. Eingang VOLL gelesen: soll-karte.md (496 Z.) +
audit-runde-1.md (178 Z.) + fix-runde-1.md (116 Z.). Alle Messungen EIGEN am Objekt
gefahren (Hauptklon + Fix-Worktree NUR LESEN; kein Schreiben noetig — 0 neue Funde).

OBJEKT (neuer Tip laut Fix-Bericht, eigenstaendig verifiziert):
- Fix-Commit a6fa04dae76777ece26d335c95eee2e031facf22 auf super-Branch
  fix/vorlagenfenster-r1, genau 1 Elternteil = 5b5a818f0c7715c25e96967d3a2572a899558cd8
  (git rev-parse a6fa04da^, literal).
- Worktree /home/comdare/wt-super-vorlagenfix: HEAD == a6fa04da, `git status
  --porcelain` LEER (clean), Branch [fix/vorlagenfenster-r1] laut `git worktree list`.
- origin-Ref-Sicherung: `git ls-remote origin refs/heads/fix/vorlagenfenster-r1` =
  a6fa04dae76777ece26d335c95eee2e031facf22 (literal; ci.skip-Push laut Fix-Bericht,
  keine Pipeline — auftragskonform).
- Commit-Trailer literal vorhanden: "Co-Authored-By: Claude Fable 5
  <noreply@anthropic.com>" (git log -1 %B).
- `git show --stat`: GENAU 2 Dateien, 10 insertions(+), 10 deletions(-) —
  docs/sessions/20260821-F2-FREEZE-CHECK-PROTOKOLL.md (6 Zeilen) +
  docs/sessions/20260821-F2-VORLAGEN-FENSTER-FINAL-konsolidiert.md (14 Zeilen).

--------------------------------------------------------------------------------
## 1. BEHOBEN-QUITTUNGEN — EIGENE MESSUNGEN (nicht abgeschrieben)

### V1-01 [MILD] Delta-Zaehler 11->12 an 4 Stellen — BESTAETIGT BEHOBEN

Eigene NULL-GEGENPROBE am Commit-Objekt (nicht am Arbeitsbaum):
`git show a6fa04da:<Datei> | grep -c -E "11 Deltas|D-01\.\.D-11"` =
**0** (FINAL-konsolidiert) und **0** (FREEZE-CHECK), je rc=1 (kein Treffer).

Eigene POSITIV-PROBEN (sed -n am git show, literal):
- D3 Z.17: "DELTAS (nur in der BAULISTE; hiermit ins Fenster gehoben — D-01..D-12
  (D-12 nachgetragen 8aae5cd2)):"
- D3 Z.86: "B-4 erfuellt: das Fenster (ENTWURF V-01..V-20 + Z-01..Z-03 + DIESE 12
  Deltas) liegt der" — ABNAHME-Formel 6 der Soll-Karte damit SELBSTKONSISTENT.
- D2 Z.79: "... 20260821-F2-VORLAGEN-FENSTER-FINAL-konsolidiert.md (12 Deltas"
- D2 Z.80: "D-01..D-12 aus der W1L-BAULISTE; A2.3a-Dopplungs-Protokoll). ..."
- D2 Z.107: "Fenster R6 vorgelegt (20+3 Bloecke + 12 Deltas; SOFORT: C-3a,
  root-Platte, Infra-Termin, O4).""

Der Fix-Bericht hatte die Audit-Fundstelle 3 korrekt PRAEZISIERT (Befund spannt Z.79+80,
zwei Zeilen) — am Diff bestaetigt: beide Zeilen editiert, sonst nichts an dem Hunk.

### V1-02 [KLEIN] D-11/D-12-Reihenfolge — BESTAETIGT BEHOBEN

Eigene Messung: `git show a6fa04da:...FINAL-konsolidiert.md | grep -n "^### D-"` =
**12 Treffer, streng aufsteigend**: D-01(19) D-02(24) D-03(29) D-04(35) D-05(40)
D-06(44) D-07(47) D-08(51) D-09(55) D-10(59) **D-11(65) D-12(71)** (literal).

BYTE-TREUE des Block-Tauschs eigenstaendig bewiesen (staerker als die Fix-Asserts):
1. SORTIER-DIFFERENZ `diff <(git show a6fa04da^:D3 | sort) <(git show a6fa04da:D3 |
   sort)` = GENAU 2 differierende Zeilen (28c28 "DIESE 11->12 Deltas", 46c46
   Z.17-Zaehler) — d. h. ALLE uebrigen Zeilen inkl. der getauschten D-11/D-12-Bloecke
   sind als Multimenge byte-identisch; der Tausch war reine Verschiebung. Fuer D2
   analog GENAU 3 differierende Zeilen (47c47/63c63/106c106 — die 3 Zaehler-Stellen).
2. ZEILENZAHLEN konstant: D3 = 88, D2 = 107 (wc -l am git show).
3. NICHT-ASCII-BYTE-BILANZ konstant: D3 vorher=152/nachher=152, D2 vorher=180/
   nachher=180 (tr -d '\000-\177' | wc -c) — der Fix fuegte NULL neue
   Nicht-ASCII-Zeichen ein; alle Delta-Substrings ("12", "(D-12 nachgetragen
   8aae5cd2))") sind reines ASCII, Bestands-Unicode unangetastet.
4. VOLLER DIFF a6fa04da^..a6fa04da gelesen: ausschliesslich die 5 Zaehler-Edits +
   der Block-Tausch (D-12-Zeilen im - und + wortgleich); keine weiteren Hunks.

--------------------------------------------------------------------------------
## 2. VERTAGT-QUITTUNGEN — TRAEGER-PRUEFUNG (je benannter Platz, eigene Objektlage)

lande-auflagen.md existiert (47 Z., voll gelesen), alle Reste mit Traeger:

| Rest | Traeger (benannt) | Eigene Objektlage-Messung 22.08. |
|---|---|---|
| L-1 [PFLICHT] Branch-Landung | Lead / W2-Lande-Zug | development ist auf 657003bb weitergezogen (7 Commits seit Fix-Basis 5b5a818f); `git log 5b5a818f..657003bb -- <die 2 Dateien>` = LEER — die parallele Lande-Arbeit beruehrte die 2 Dateien NICHT, der Merge bleibt konfliktfrei. dev@657003bb traegt erwartungsgemaess noch den 11er-Stand (2 bzw. 3 grep-Treffer) — genau der von L-1 getragene Zustand, KEIN neuer Defekt |
| L-2 [PFLICHT] Ledger-Buchung traegt die ZWOELF | Lead (Ledger = Lead-only) | KON120 ist am Ledger-Kopf INZWISCHEN ANDERWEITIG vergeben (Z.19: "KON120 (22.08.2026 frueh) — OWNER-ANTWORTEN TRANCHE 1+2 ..."); der Freeze-Check-Eintrag ist NOCH NICHT gebucht; grep "1[12] Deltas|D-01..D-1[12]" am Ledger = KEINE Fehlbuchung (einziger Treffer Z.2348 = Alt-KON94 "Full-Join 12 Deltas", anderes Thema). HINWEIS (kein Fund): die Nummern-Annahme "KON120" in Auflage + D2-Z.103-Entwurf ist ueberholt — der kuenftige Buchungszug wird KON121+ tragen; die Auflagen-SUBSTANZ (Ledger-Text traegt die 12; Entwurf nicht woertlich uebernehmen, gegen Objekt zaehlen: grep -c '^### D-' == 12) bleibt unveraendert gueltig und getragen |
| L-3 [HINWEIS] F-122-Beifang an D-04 | Lead (naechster docs-/Ledger-Zug) | Zurechnung laut Audit R1 geprueft und plausibel (S2-Synthese ~9 h nach D-12-Nachtrag); bewusst NICHT von A2.5 vollzogen — inhaltlicher Lead-Entscheid ausserhalb der Fund-Liste. Getragen |
| F-71..F-77, F-123 | Owner/Lead | Erwarteter R6-Endzustand (Soll-Karte NICHT-GEFORDERT: "Owner hat noch nicht geantwortet" ist KEIN Defekt) — unveraendert |

--------------------------------------------------------------------------------
## 3. REGRESSIONS-STICHPROBE (keine neuen Schaeden durch die Fixe)

- NUR die 2 Ziel-Dateien im Commit (stat-Literal); 0 Treffer axes/ topics/ heuristik/,
  0 golden, 0 .gitlab-ci.yml, 0 CMakeLists — TABU-Gate gedeckt.
- Sortier-Differenz + Nicht-ASCII-Bilanz (Abschnitt 1): kein Zeichen ausserhalb der 5
  Zaehler-Stellen veraendert; getauschte Bloecke wortgleich verschoben.
- clang-format-22: nicht einschlaegig (keine Lint-Datei; nur .md).
  Bau-Slot/Bau-Treppe/ctest: nicht einschlaegig (Doku-Fix ohne Compile-Gegenstand —
  deckungsgleich mit Audit P-02 und Strang-Charakter "Kein Bau-Slot noetig");
  Rot-Lauf-Logs: keine (kein Rot-Lauf gefahren, nichts zu persistieren).
- vorlagen-fenster-ergebnis.md (Nachtrag-Anfuegung): 114 Z. (vorher 98), Nachtrag ab
  Z.100 "## A2.5-FIX-NACHTRAG ..." ADDITIV ans Dateiende; Bestands-Anker Z.39,
  Z.46-48, Z.87-90, Z.95-98 wortgleich zu den UNABHAENGIGEN Vorher-Zitaten aus
  Soll-Karte (P-02/P-03/P-04/P-27, ABNAHME-Formel 8) und Audit R1 — Bestand an allen
  belegten Ankern unveraendert. (Keine committete/Backup-Vorher-Kopie auffindbar —
  git log --all leer, find leer — daher Anker-Beweis statt Voll-Byte-Diff; alle 10
  unabhaengig zitierten Anker-Zeilen treffen.)
- Fix-Branch-Basis 5b5a818f ist Ancestor-sauber; kein Rebase, keine History-Umschrift
  (1 neuer Commit obenauf).

--------------------------------------------------------------------------------
## 4. RESTLISTE GEGEN DIE SOLL-KARTE (P-01..P-29)

- P-01..P-23, P-26..P-29: unveraendert ERFUELLT — der Fix beruehrte deren Gegenstaende
  nicht (stat-Beweis: nur die 2 Lead-Dateien, nur Zaehler/Reihenfolge).
- P-24 + P-25 (Audit R1: LUECKE/Nachlauf): am Branch-Stand a6fa04da GEHEILT (eigene
  Messungen Abschnitt 1); am development-Tip wirksam ERST mit der L-1-Landung
  (getragener Zustand, s. Abschnitt 2).
- ABNAHME-Formeln 1-8 der Soll-Karte: Formel 6 jetzt selbstkonsistent ("DIESE 12
  Deltas", eigene Messung); uebrige unveraendert erfuellt.
- Soll-Karten-Spannungen S-1/S-2: durch den Fix am Branch-Stand AUFGELOEST;
  S-3/S-4/S-5/S-6: unveraendert ohne Auswirkung (keine Fix-Flaeche).
- Kein Soll-Karten-Punkt offen ohne benannten Traeger.

--------------------------------------------------------------------------------
## 5. GATE-ABGRENZUNG (beide Mengen)

GEDECKT durch dieses RE-VERIFY: die 2 Fund-Fixe (V1-01/V1-02) am Commit-Objekt
a6fa04da inkl. Byte-Treue/ASCII/TABU/Formalien (Trailer, Eltern, Push-Ref, Worktree
clean) + Traeger-Pruefung aller Reste + Regressionsfreiheit des Fix-Commits +
Bestands-Anker der Nachtrag-Anfuegung.
NICHT GEDECKT (Traeger benannt): Landung des Branches auf development (L-1, Lead/
Lande-Zug — Merge nachweislich konfliktfrei moeglich) · kuenftige Ledger-Buchung des
Freeze-Check-Eintrags mit der 12 unter KON121+ (L-2, Lead) · F-122-Uebertrag an D-04
(L-3, Lead) · Owner-Antworten R7 (Owner) · getragene Posten F-71..F-77/F-123.

## 6. VERDIKT

**SITZT** — beide Fund-Fixe eigenstaendig bestaetigt (2/2 BEHOBEN, 0 VERTAGT ohne
Traeger), 0 neue Regressionen, 0 neue Funde. Die Fenster-Substanz (12/12 B-4-Posten,
12/12 F-II, 7/7 F-I, 3/3 Zusatzbloecke, 10/10 ENTSCHIEDEN, 12/12 Deltas, 22/22
G-Deckung, 4/4 SOFORT-Zeilen) war bereits in Runde 1 vollzaehlig und ist unberuehrt.
Einziger Nicht-Fund-HINWEIS an den Lead: die KON-Nummern-Annahme "KON120" der
L-2-Auflage ist durch die zwischenzeitliche KON120-Vergabe (Owner-Antworten-Tranchen)
ueberholt — beim Buchen die dann gueltige naechste KON-Nummer verwenden, Zahl ZWOELF
gegen das Objekt zaehlen (Auflagen-Substanz unveraendert).

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
# RUNDE 2 — WIEDERANLAUF (RE-VERIFY nach Fix-Stufen-Wiederanlauf, 23.08.2026; additiv,
# Erst-Lauf-Stand oben NICHT geloescht)

Re-Verifier: Fable-max, 23.08.2026. ANLASS: Session-Abriss nach dem Erst-Lauf (oben,
22.08. 06:41); die Fix-Stufe lief am 23.08. als Wiederanlauf erneut und ergaenzte
fix-runde-1.md um Abschnitt 7 (116 -> 210 Z.) + lande-auflagen.md um den NACHTRAG 23.08.
(47 -> 96 Z.) mit einer LAGE-AENDERUNG: development traegt die Fund-Fixe inzwischen
SELBST (Lead-Commit 8ed8b268). Eingang VOLL gelesen: soll-karte.md (495 Z.) +
audit-runde-1.md (178 Z.) + fix-runde-1.md (210 Z. inkl. §7) + lande-auflagen.md (96 Z.)
+ Erst-Lauf-audit-runde-2 (oben). ALLE folgenden Messungen FRISCH am 23.08. EIGEN
gefahren (Hauptklon + Worktree NUR LESEN; git show gegen Refs; 0 Schreibzugriffe im
Repo noetig — 0 neue Funde).

## W.1 OBJEKTLAGE NEU (eigene Messungen 23.08.)

- development-Tip ZUM PRUEFZEITPUNKT: daa93fb88bbc46142a68b901897ae95443576cd0
  (23.08. 14:00:43 +0000) — JUENGER als der im Fix-§7 gemessene 38428099 (13:41);
  alle dev-Proben hier laufen am juengeren Tip daa93fb8.
- a6fa04da NICHT Ancestor von development (rc=1) — Fix-Branch weiterhin ungelandet;
  8ed8b268 IST Ancestor (rc=0) — der Lead-Fix ist wirksam.
- Branch-Topologie: `git merge-base development fix/vorlagenfenster-r1` = 5b5a818f;
  `git log development..fix/vorlagenfenster-r1` = GENAU 1 Commit (a6fa04da) — der
  Wiederanlauf der Fix-Stufe hat KEINEN neuen Commit erzeugt (Quittung §7.3 bestaetigt).
- Worktree /home/comdare/wt-super-vorlagenfix: HEAD == a6fa04da, `git status --short
  --branch` = nur "## fix/vorlagenfenster-r1" (clean); `git worktree list` fuehrt ihn.
- origin-Ref: `git ls-remote origin refs/heads/fix/vorlagenfenster-r1` =
  a6fa04dae76777ece26d335c95eee2e031facf22 — Ref-Sicherung liegt, origin == HEAD,
  kein Push noetig gewesen (Quittung bestaetigt).

## W.2 BEHOBEN-QUITTUNGEN — JETZT DOPPELT EIGEN GEMESSEN (Branch + wirksames Objekt)

### V1-01 [MILD] Delta-Zaehler 11->12 — BESTAETIGT BEHOBEN (beide Fassungen)

(a) BRANCH-Fassung a6fa04da (Commit-Objekt, frisch nachgemessen): Null-Gegenprobe
`git show a6fa04da:<Datei> | grep -c -E "11 Deltas|D-01\.\.D-11"` = 0 (FINAL) und
0 (FREEZE), je rc=1. Commit-Hash identisch zum Erst-Lauf — Inhalt per Hash-Identitaet
unveraendert; Erst-Lauf-Byte-Beweise (Sortier-Differenz, Nicht-ASCII-Bilanz) gelten fort.

(b) WIRKSAMES OBJEKT development@daa93fb8 (NEU seit Erst-Lauf): Null-Gegenprobe
`git show development:<Datei> | grep -c -E "11 Deltas|D-01\.\.D-11"` = 0 (FINAL) und
0 (FREEZE), je rc=1. POSITIV-Proben (grep -n am git show, literal):
- FINAL Z.17: "hiermit ins Fenster gehoben — D-01..D-12; VF-A1-Nachzug 22.08.:"
  (Z.18 Fortsetzung "D-12 per 8aae5cd2 nachgetragen, Zaehler hier nachgezogen):")
- FINAL Z.89 (ABNAHME): "das Fenster (ENTWURF V-01..V-20 + Z-01..Z-03 + DIESE 12
  Deltas) liegt der" — ABNAHME-Formel 6 der Soll-Karte am WIRKSAMEN Objekt
  selbstkonsistent.
- FREEZE Z.79-80: "(12 Deltas / D-01..D-12 aus der W1L-BAULISTE, D-12 nachgetragen
  8aae5cd2; A2.3a-Dopplungs-Protokoll)."
- FREEZE Z.108 (KON120-ENTWURF-Zitat): "Fenster R6 vorgelegt (20+3 Bloecke + 12
  Deltas [VF-A1-Nachzug 22.08.]; SOFORT: C-3a,"
Traeger-Commit 8ed8b268 (22.08. 06:53:59): Diff der 2 Dateien VOLL gelesen — alle
4 Fund-Stellen (FINAL Z.17/ABNAHME + FREEZE Z.79-80/Entwurf) im Diff enthalten,
Zeilenzahlen dev-Fassung FINAL 91 / FREEZE 109 (wc -l am git show, konsistent zu
den Diff-Hunks +3/+2).

### V1-02 [KLEIN] D-11/D-12-Reihenfolge — BESTAETIGT BEHOBEN (zwei zugelassene Wege)

(a) BRANCH a6fa04da (frisch): `grep -n "^### D-"` = 12 Treffer streng aufsteigend,
D-11(65) VOR D-12(71) — Audit-Option A (Block-Tausch).
(b) DEV daa93fb8 (NEU): Reihenfolge bleibt D-12(68) vor D-11(73), ABER mit
ORDNUNGSNOTIZ davor (FINAL Z.66-67, literal): "<!-- ORDNUNGSNOTIZ (VF-A2, 22.08.):
D-12 nachgetragen 21.08. 09:26 per 8aae5cd2 — Reihenfolge / vor D-11 historisch,
kein Versehen. -->" — das IST Audit-R1-FIX-WEG Option B (audit-runde-1.md Z.135-137
literal: "ODER eine Ein-Zeilen-Notiz ... am D-12-Kopf setzen. Kosmetik"), inhaltlich
sogar praeziser (Datum+SHA). Beide Wege waren ausdruecklich zugelassen; KEIN Defekt
auf keiner der beiden Fassungen.

## W.3 VERTAGT-/REST-QUITTUNGEN — TRAEGER EIGENSTAENDIG AM OBJEKT VERIFIZIERT

| Rest | Traeger laut Fix-§7/Auflagen | EIGENE Objekt-Messung 23.08. |
|---|---|---|
| Harmonisierung Branch<->dev (ersetzt L-1) | Lead, S1+S2-Lande-Zug | Ledger KON120-07 Punkt 1 (Z.91-93) literal: "VF-A1/VF-A2 als Lead-Fix VOLLZOGEN ... Harmonisierungs-Auflage gegen fix/vorlagenfenster-r1 (wt-super-vorlagenfix) an den Lande-Zug" — GEBUCHT. Zwischendoku §3.3 (Z.82-83) literal: "Beim Lande-Zug beide Fassungen HARMONISIEREN (gleicher Gegenstand -> Lead-Fassung fuehrt; Fix-Branch-Mehrwerte uebernehmen, nichts doppelt einbauen)". Traeger benannt UND ledger-gebucht |
| Worktree-Verbleib | Lead (Disposition nach Harmonisierung) | Zwischendoku §7 (Z.246-251) literal: "wt-super-vorlagenfix (a6fa04da, Fix-Stufe — §3.3-Harmonisierung) ... ALLE bleiben bis zur S1+S2-Landung" — deckt die Doktrin (Loeschung erst gruen+gemergt) |
| L-2 Ledger-Buchung traegt die ZWOELF | Lead, KON121+ | Ledger-Kopf inzwischen "NACHTRAG zu KON120-02 (22.08. nachmittags)" (Z.19) — KON120 durch Owner-Antworten-Tranchen vergeben; Freeze-Check-Eintrag WEITER NICHT gebucht (grep "1[12] Deltas": nur Alt-KON94 "Full-Join 12 Deltas", anderes Thema). Auflagen-SUBSTANZ (Text traegt die 12; gegen Objekt zaehlen) unveraendert getragen (lande-auflagen NACHTRAG L-2) |
| L-3 F-122-Beifang an D-04 | Lead | unveraendert getragen (lande-auflagen NACHTRAG); kein neuer Beruehrer der FINAL-Datei seit 8ed8b268 (git log literal) |
| D-12-INHALTS-Posten (Dock-Zahl SECHS) | Lead/Owner | Ledger Z.173-174 literal: "D-12: Dock-Zahl SECHS doppelt owner-gesetzt; 'max. 4' war Session-Vorschlag ohne Owner-Deckung — OFFEN-OWNER-Fuehrung in s8/F-17/FINAL-D-12 stale" (KON120-06(3)) — die Buchung selbst IST der Traeger; INHALTLICHER Posten ausserhalb der Fund-Liste V1-01/V1-02 |
| F-71..F-77, F-123 / Owner-Antworten | Owner/Lead | KON120-Tranchen 1+2 sind inzwischen gebucht (Ledger Z.24: "B1-B5/C1-C4/D-01-D-11 = KON120-02 GEDECKT"); zusammen mit KON120-06(3) fuer den D-12-Gegenstand sind damit alle 12 Delta-Gegenstaende ledger-seitig disponiert — KEIN Loch durch den alten 11er-Zaehler entstanden. R7-Fortgang ist NICHT Gegenstand dieses Strangs (Soll-Karte NICHT-GEFORDERT) |

## W.4 REGRESSIONS-STICHPROBE WIEDERANLAUF (keine neuen Schaeden)

- Der Fix-Wiederanlauf schrieb NUR additive Backup-Nachtraege, KEINE Repo-Datei:
  fix-runde-1.md §7 (additiv, Abschnitte 1-6 unveraendert an allen oben zitierten
  Ankern) · lande-auflagen.md NACHTRAG ab Z.48 mit explizitem "Stand oben NICHT
  geloescht" (L-1/L-2/L-3-Bestandstitel Z.6/21/30 wortgleich zu den Erst-Lauf-Zitaten
  oben, Abschnitt 2) · vorlagen-fenster-ergebnis.md "A2.5-WIEDERANLAUF-VERMERK" ans
  Dateiende (114 -> 126 Z., tail gelesen; Bestand davor inkl. A2.5-FIX-NACHTRAG
  unveraendert an den Ankern). BU-additiv-Doktrin erfuellt.
- 0 neue Commits, 0 Pushes (W.1-Topologie + origin==HEAD); Worktree clean —
  Ledger/Board/Memory von der Fix-Stufe NICHT beruehrt (der KON120-07-Eintrag ist
  ein LEAD-Akt im Lead-Commit-Zug 8ed8b268, nicht die Fix-Stufe).
- Lead-Commit 8ed8b268 (der neue Wirksamkeits-Traeger): `git show --stat` = GENAU
  3 Dateien, alle docs/sessions/ (die 2 Fund-Dateien + NEUE Zwischendoku 233 Z.);
  0 Treffer axes/topics/heuristik/golden/CMakeLists/.gitlab-ci.yml — TABU-frei.
- `git log 5b5a818f..development -- <die 2 Dateien>` am Tip daa93fb8 = GENAU
  8ed8b268 — kein weiterer Beruehrer, auch nicht zwischen 38428099 und daa93fb8.
- clang-format-22/Bau-Slot/Bau-Treppe/ctest: unveraendert nicht einschlaegig
  (reiner Doku-Gegenstand, kein Compile; deckungsgleich Audit P-02);
  Rot-Lauf-Logs: keine (kein Rot-Lauf gefahren, nichts zu persistieren).

## W.5 RESTLISTE GEGEN DIE SOLL-KARTE (Delta zum Erst-Lauf)

- P-24 + P-25 (einzige LUECKE-Punkte aus R1): im Erst-Lauf nur am Branch geheilt,
  "am development-Tip wirksam ERST mit der L-1-Landung" — JETZT am WIRKSAMEN Objekt
  selbst geheilt (dev via 8ed8b268, eigene Messungen W.2). STAERKERER Zustand als
  im Erst-Lauf-Verdikt.
- ABNAHME-Formel 6: am wirksamen Objekt selbstkonsistent (FINAL Z.89 "DIESE 12
  Deltas", eigene Messung). Formeln 1-5/7/8 unveraendert erfuellt.
- Soll-Karten-Spannung S-1 (Zaehler): an BEIDEN Fassungen aufgeloest. S-2
  (Reihenfolge): Branch getauscht (Option A), dev deklariert (Option B) — beide
  Wege audit-zugelassen; die Harmonisierung entscheidet die Endform (Lead,
  gebucht). S-3..S-6: unveraendert ohne Auswirkung.
- P-01..P-23, P-26..P-29: unveraendert ERFUELLT (kein Fix-/Lead-Commit beruehrte
  deren Gegenstaende; stat-Beweise W.4).
- Kein Soll-Karten-Punkt offen ohne benannten Traeger.

## W.6 GATE-ABGRENZUNG (beide Mengen, Stand 23.08.)

GEDECKT durch diesen Wiederanlauf-RE-VERIFY: Fund-Zustand V1-01/V1-02 am
Branch-Objekt a6fa04da UND am wirksamen dev-Tip daa93fb8 (je eigene frische
Messungen) · Formalien Branch/Worktree/origin (clean, 1 Commit, Ref liegt) ·
Traeger-Verifikation aller Reste an Ledger/Zwischendoku-Literalen ·
Regressionsfreiheit des Wiederanlaufs (nur additive Backups) und des
Wirksamkeits-Traegers 8ed8b268 (TABU-frei, einziger Beruehrer).
NICHT GEDECKT (Traeger benannt): Harmonisierung Branch<->dev im S1+S2-Lande-Zug
(Lead, KON120-07 P.1 gebucht) · Freeze-Check-Ledger-Buchung mit der ZWOELF unter
KON121+ (Lead, lande-auflagen L-2) · F-122-Uebertrag an D-04 (Lead, L-3) ·
D-12-INHALTS-Posten Dock-Zahl SECHS (Lead/Owner, KON120-06(3)) · R7-Fortgang/
restliche Owner-Posten (Owner/Lead; Tranchen 1+2 bereits gebucht, nicht Gegenstand
dieses Strangs) · Inhalte der uebrigen dev-Commits zwischen 5b5a818f und daa93fb8
(beruehren die 2 Fund-Dateien nachweislich nicht; eigene Straenge).

## W.7 VERDIKT (Wiederanlauf)

**SITZT** — beide Fund-Fixe eigenstaendig und DOPPELT bestaetigt (2/2 BEHOBEN:
Branch-Fassung a6fa04da per Option A, wirksame dev-Fassung 8ed8b268 per Option B;
Null-Gegenproben 0/0 an BEIDEN Objekten frisch gemessen), 0 VERTAGT ohne Traeger
(alle Reste ledger-/dokumenten-gebucht verifiziert), 0 neue Regressionen, 0 neue
Funde. Das Erst-Lauf-Verdikt SITZT bleibt bestehen und ist durch die Lead-Heilung
am wirksamen Objekt STAERKER unterlegt als zum Erst-Lauf-Zeitpunkt.

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
# RUNDE 2 — WIEDERANLAUF 2 (RE-VERIFY-Bestaetigungslauf, 23.08.2026 abends; additiv,
# Erst-Lauf + Wiederanlauf 1 oben NICHT geloescht)

Re-Verifier: Fable-max, 23.08.2026 abends. ANLASS: erneuter Stufen-Anlauf der
RE-VERIFY R1 (Workflow-Wiederanlauf); der Bestand oben (Erst-Lauf 22.08. + Wiederanlauf
1 vom 23.08. 14:06) wurde VOLL gelesen, ebenso soll-karte.md (495 Z.) + audit-runde-1.md
(177 Z.) + fix-runde-1.md (209 Z. inkl. §7) + lande-auflagen.md (96 Z.). ALLE folgenden
Messungen FRISCH am 23.08. abends EIGEN gefahren (Hauptklon + Worktree NUR LESEN,
git show gegen Refs; 0 Schreibzugriffe im Repo — 0 neue Funde).

## X.1 OBJEKTLAGE (eigene Messungen, 23.08. abends)

- development-Tip ZUM PRUEFZEITPUNKT: cb38cc9f05b0155a9d28afaed76d568240cfdfcb
  (23.08. 18:48:13 +0000, "docs(beweis): Rueckfragen-Vollbild 12 Wochen ...") —
  JUENGER als der in Wiederanlauf 1 gemessene daa93fb8 (14:00:43); alle dev-Proben
  hier laufen am juengeren Tip cb38cc9f.
- a6fa04da NICHT Ancestor von development (rc=1) — Fix-Branch weiterhin ungelandet;
  8ed8b268 IST Ancestor (rc=0) — der Lead-Fix bleibt wirksam.
- Topologie: `git merge-base development fix/vorlagenfenster-r1` = 5b5a818f;
  `git log development..fix/vorlagenfenster-r1` = GENAU 1 Commit (a6fa04da) —
  weiterhin kein neuer Commit auf dem Fix-Branch.
- Worktree /home/comdare/wt-super-vorlagenfix: HEAD == a6fa04da (rev-parse literal),
  `git status --short --branch` = nur "## fix/vorlagenfenster-r1" (clean);
  `git worktree list` fuehrt ihn auf [fix/vorlagenfenster-r1].
- origin-Ref: `git ls-remote origin refs/heads/fix/vorlagenfenster-r1` =
  a6fa04dae76777ece26d335c95eee2e031facf22 — Ref-Sicherung liegt, origin == HEAD.
- KERN-DELTA-MESSUNG zum juengeren Tip: `git log 5b5a818f..development -- <die 2
  Fund-Dateien>` am Tip cb38cc9f = GENAU 8ed8b268 (22.08. 06:53:59) — KEIN weiterer
  Beruehrer, auch nicht zwischen daa93fb8 und cb38cc9f. Ledger-Beruehrer
  `git log daa93fb8..development -- docs/DIPLOMARBEIT-...-LEDGER.md` = LEER —
  die in Wiederanlauf 1 verifizierte Buchungslage gilt unveraendert am neuen Tip.

## X.2 BEHOBEN-QUITTUNGEN — ERNEUT EIGEN GEMESSEN (beide Fassungen, frisch)

### V1-01 [MILD] Delta-Zaehler 11->12 — BESTAETIGT BEHOBEN (2/2 Fassungen)

Null-Gegenprobe `grep -c -E "11 Deltas|D-01\.\.D-11"` am git show:
- BRANCH a6fa04da: FINAL = 0, FREEZE = 0 (je rc=1).
- DEV cb38cc9f: FINAL = 0, FREEZE = 0 (je rc=1).
Positiv-Proben (literal, eigene sed-/grep-Ausgaben):
- BRANCH: FINAL Z.17 "— D-01..D-12 (D-12 nachgetragen 8aae5cd2)):" · Z.86 "DIESE 12
  Deltas) liegt der" · FREEZE Z.79 "(12 Deltas" · Z.80 "D-01..D-12 aus der
  W1L-BAULISTE; A2.3a-Dopplungs-Protokoll)." · Z.107 "+ 12 Deltas; SOFORT: C-3a, ...".
- DEV: FINAL Z.17 "— D-01..D-12; VF-A1-Nachzug 22.08.:" · Z.89 (ABNAHME) "DIESE 12
  Deltas) liegt der" — ABNAHME-Formel 6 am wirksamen Objekt selbstkonsistent ·
  FREEZE Z.79-80 "(12 Deltas / D-01..D-12 aus der W1L-BAULISTE, D-12 nachgetragen
  8aae5cd2;" · Z.108 "+ 12 Deltas [VF-A1-Nachzug 22.08.];".
Zeilenzahlen (wc -l am git show): Branch FINAL 88 / FREEZE 107 (konstant zur
Vor-Fix-Fassung), dev FINAL 91 / FREEZE 109 (Lead-Formulierungen +3/+2 —
deckungsgleich W.2).

### V1-02 [KLEIN] D-11/D-12-Reihenfolge — BESTAETIGT BEHOBEN (2 zugelassene Wege)

- BRANCH a6fa04da: `grep -n "^### D-"` = 12 Treffer STRENG AUFSTEIGEND, literal
  D-01(19) D-02(24) D-03(29) D-04(35) D-05(40) D-06(44) D-07(47) D-08(51) D-09(55)
  D-10(59) D-11(65) D-12(71) — Audit-Option A (Block-Tausch).
- DEV cb38cc9f: D-12(68) vor D-11(73), davor ORDNUNGSNOTIZ Z.66 literal
  "<!-- ORDNUNGSNOTIZ (VF-A2, 22.08.): D-12 nachgetragen 21.08. 09:26 per 8aae5cd2 —
  Reihenfolge ..." — Audit-Option B (Ein-Zeilen-Notiz, audit-runde-1.md Z.135-137).
- BYTE-TREUE des Branch-Tauschs ERNEUT EIGEN bewiesen (Sortier-Differenz):
  `diff <(git show a6fa04da^:F | sort) <(git show a6fa04da:F | sort)` zaehlt als
  [<>]-Zeilen FINAL = 4 (2 Zeilenpaare: die 2 Zaehler-Zeilen) und FREEZE = 6
  (3 Zeilenpaare: die 3 Zaehler-Zeilen) — ALLE uebrigen Zeilen inkl. der getauschten
  Bloecke als Multimenge byte-identisch. Deckungsgleich mit dem Erst-Lauf-Beweis
  (dort als 2c/3c-Zaehlung notiert), hier unabhaengig nachgefahren.

## X.3 VERTAGT-/REST-QUITTUNGEN — TRAEGER FRISCH AM OBJEKT VERIFIZIERT

| Rest | Traeger | Eigene Messung 23.08. abends (Tip cb38cc9f) |
|---|---|---|
| Harmonisierung Branch<->dev (ersetzt L-1) | Lead, S1+S2-Lande-Zug | Ledger Z.91-93 literal "VF-A1/VF-A2 als Lead-Fix VOLLZOGEN: Delta-Zaehler 11->12 an 4 Stellen + D-12-Ordnungsnotiz ... Harmonisierungs-Auflage gegen fix/vorlagenfenster-r1 (wt-super-vorlagenfix) an den Lande-Zug." (KON120-07 P.1, GEBUCHT); Zwischendoku Z.82-83 literal "Beim Lande-Zug beide Fassungen HARMONISIEREN (gleicher Gegenstand -> Lead-Fassung fuehrt; Fix-Branch-Mehrwerte uebernehmen, nichts doppelt einbauen)." |
| Worktree-Verbleib | Lead (nach Harmonisierung) | Zwischendoku Z.250-251 literal "wt-super-vorlagenfix (a6fa04da, Fix-Stufe — §3.3-Harmonisierung) ... ALLE bleiben bis zur S1+S2-Landung."; `git worktree list` fuehrt ihn, clean |
| L-2 Ledger-Buchung traegt die ZWOELF | Lead, KON121+ | Freeze-Check-Eintrag WEITER NICHT gebucht: grep "F2-FREEZE\|FREEZE-CHECK\|1[12] Deltas" am dev-Ledger = nur Alt-KON94 Z.2447 ("Full-Join 12 Deltas", anderes Thema) + Planungstext Z.7401-7402; KEINE Fehlbuchung mit 11; Ledger seit daa93fb8 unberuehrt (git log leer) |
| L-3 F-122-Beifang an D-04 | Lead | unveraendert getragen (lande-auflagen NACHTRAG); kein neuer Beruehrer der FINAL-Datei seit 8ed8b268 (X.1-Messung) |
| D-12-INHALTS-Posten (Dock-Zahl SECHS) | Lead/Owner, KON120-06(3) | Ledger Z.173-174 literal "(3) D-12: Dock-Zahl SECHS doppelt owner-gesetzt; 'max. 4' war Session-Vorschlag ohne Owner-Deckung — OFFEN-OWNER-Fuehrung in s8/F-17/FINAL-D-12 stale." — Buchung liegt, ausserhalb der Fund-Liste |
| F-71..F-77, F-123 / R7 | Owner/Lead | Ledger-Kopf Z.19 "NACHTRAG zu KON120-02 (22.08.2026 nachmittags ...)" mit Deckungs-Zeile "B1-B5/C1-C4/D-01-D-11 = KON120-02 GEDECKT" (Z.24); R7-Fortgang nicht Gegenstand dieses Strangs (Soll-Karte NICHT-GEFORDERT) |

## X.4 REGRESSIONS-STICHPROBE (frisch)

- a6fa04da: `git show --stat` = GENAU 2 Dateien (FREEZE 6 Zeilen, FINAL 14 Zeilen),
  10 insertions(+), 10 deletions(-); Trailer literal "Co-Authored-By: Claude Fable 5
  <noreply@anthropic.com>" (git log -1 %B, letzte Zeile). NUR docs/sessions/ —
  0 axes/topics/heuristik/golden/CMakeLists/.gitlab-ci.yml.
- 8ed8b268 (Wirksamkeits-Traeger): `git show --stat` = GENAU 3 Dateien, alle
  docs/sessions/ (2 Fund-Dateien 8/7 Zeilen + Zwischendoku 233 Z. neu) — TABU-frei.
- Einziger Beruehrer der 2 Fund-Dateien seit Fix-Basis bleibt 8ed8b268 — auch ueber
  die neuen dev-Commits bis cb38cc9f (X.1). Kein Commit dieses Stufen-Anlaufs, kein
  Push (origin == HEAD gemessen), Worktree clean — 0 Repo-Schreibzugriffe.
- Backup-Artefakte additiv intakt: vorlagen-fenster-ergebnis.md = 126 Z., Schluss =
  "## A2.5-WIEDERANLAUF-VERMERK (Runde 1, 23.08.2026 — inkrementell angefuegt)" ans
  Dateiende; Bestands-Anker Z.39 ("Kein Bau-Slot noetig (Dokument-Strang, kein
  Compile); kein Worktree, keine Commits.") und Z.87 ("... Ledger NICHT geschrieben
  (Entwuerfe in") wortgleich zu den unabhaengigen Soll-Karten-Zitaten (P-02/P-03).
  F2-VORLAGEN-FENSTER-ENTWURF.md = 481 Z. (unveraendert zur Soll-Karte).
- clang-format-22/Bau-Slot/Bau-Treppe/ctest: unveraendert nicht einschlaegig (reiner
  Doku-Gegenstand, 0 Lint-Dateien, kein Compile — deckungsgleich Audit P-02);
  Rot-Lauf-Logs: keine (kein Rot-Lauf gefahren, nichts zu persistieren).

## X.5 RESTLISTE GEGEN DIE SOLL-KARTE (Delta-Sicht)

- P-24 + P-25 (einzige LUECKE-Punkte aus R1): an BEIDEN Fassungen geheilt (X.2,
  frische Messungen am juengeren Tip) — Zustand von Wiederanlauf 1 bestaetigt.
- ABNAHME-Formel 6: am wirksamen Objekt selbstkonsistent (FINAL Z.89 "DIESE 12
  Deltas", eigene Messung X.2). Formeln 1-5/7/8 unveraendert erfuellt.
- S-1 an beiden Fassungen aufgeloest; S-2 Branch getauscht (A) / dev deklariert (B),
  Endform = Harmonisierungs-Entscheid (Lead, gebucht); S-3..S-6 unveraendert ohne
  Auswirkung. P-01..P-23, P-26..P-29 unveraendert ERFUELLT (kein Beruehrer, X.1/X.4).
- Kein Soll-Karten-Punkt offen ohne benannten Traeger.

## X.6 GATE-ABGRENZUNG (beide Mengen, Stand 23.08. abends)

GEDECKT durch diesen Bestaetigungslauf: Fund-Zustand V1-01/V1-02 am Branch-Objekt
a6fa04da UND am wirksamen dev-Tip cb38cc9f (je frische eigene Messungen) · Formalien
Branch/Worktree/origin (clean, 1 Commit, Ref liegt, Trailer) · Byte-Treue-Nachweis
(Sortier-Differenz, unabhaengig nachgefahren) · Traeger-Verifikation aller Reste an
Ledger-/Zwischendoku-Literalen am juengeren Tip · Beruehrer-Freiheit der 2 Dateien
und des Ledgers ueber die neuen dev-Commits · additive Intaktheit der
Backup-Artefakte.
NICHT GEDECKT (Traeger benannt): Harmonisierung Branch<->dev im S1+S2-Lande-Zug
(Lead, KON120-07 P.1) · Freeze-Check-Ledger-Buchung mit der ZWOELF unter KON121+
(Lead, L-2) · F-122-Uebertrag an D-04 (Lead, L-3) · D-12-INHALTS-Posten Dock-Zahl
SECHS (Lead/Owner, KON120-06(3)) · R7-Fortgang/getragene Posten F-71..F-77/F-123
(Owner/Lead) · Inhalte der uebrigen dev-Commits 5b5a818f..cb38cc9f (beruehren die
2 Fund-Dateien und den Ledger-Buchungsstand nachweislich nicht; eigene Straenge).

## X.7 VERDIKT (Bestaetigungslauf)

**SITZT** — beide Fund-Fixe zum DRITTEN Mal eigenstaendig bestaetigt (2/2 BEHOBEN an
beiden Fassungen, Null-Gegenproben 0/0 frisch am juengeren dev-Tip cb38cc9f), 0
VERTAGT ohne Traeger (alle Reste ledger-/dokumenten-gebucht, Literale frisch
verifiziert), 0 neue Regressionen (kein neuer Beruehrer, 0 Schreibzugriffe dieses
Laufs), 0 neue Funde. Erst-Lauf- und Wiederanlauf-1-Verdikt SITZT bleiben bestehen.
