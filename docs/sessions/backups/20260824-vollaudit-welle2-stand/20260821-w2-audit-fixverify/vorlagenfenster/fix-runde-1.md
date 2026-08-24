# FIX RUNDE 1 — Strang "vorlagenfenster" (A2.5, Fable-max-Fix-Stufe, 22.08.2026)

Auftrag: Audit-Funde V1-01 [MILD] + V1-02 [KLEIN] aus audit-runde-1.md (178 Z., VOLL
gelesen). Beide Funde sitzen in den 2 committeten LEAD-Dateien auf super/development
(D2 = FREEZE-CHECK-PROTOKOLL, D3 = FINAL-konsolidiert); die Strang-Lieferung selbst
(ENTWURF + Ergebnisbericht unter ~/backups-workflow/20260820-w2-sofortstaffel/) ist laut
Audit Abschnitt 5 fundfrei — dort war nichts zu korrigieren, nur der A2.5-FIX-NACHTRAG
zu dokumentieren (geschehen, s. u.).

## 1. EIGENE VOR-VERIFIKATION (nicht vom Audit abgeschrieben; Hauptklon NUR LESEN)

- development-Tip zum Pruefzeitpunkt: 5b5a818f0c7715c25e96967d3a2572a899558cd8;
  `git merge-base --is-ancestor` fuer 8aae5cd2 UND 3e9ec644 je rc=0 (beide Ancestor).
- Fundstelle 1 (D3 Z.17, via `git show development:...`): Zeile endet auf
  "D-01..D-11):" — bestaetigt.
- Fundstelle 2 (D3 Z.86): "DIESE 11 Deltas" — bestaetigt.
- Fundstelle 3 (D2 Z.79-80): "(11 Deltas" am Zeilenende 79 + "D-01..D-11 aus der
  W1L-BAULISTE" am Zeilenanfang 80 — PRAEZISIERUNG gegenueber dem Audit: der Befund
  "(11 Deltas D-01..D-11" spannt sich ueber ZWEI Zeilen; der Fix musste beide beruehren.
- Fundstelle 4 (D2 Z.107): "+ 11 Deltas" — bestaetigt.
- V1-02: `grep -n "^### D-"` am development-Stand = 12 Treffer, "### D-12" an Z.65 VOR
  "### D-11" an Z.70 — bestaetigt.
- Commit-Selbstauskunft: `git log -1 8aae5cd2` traegt literal "... Fenster damit 12
  Deltas" — die 11er-Stellen sind reiner Nachlauf, Objekt-Substanz 12/12.
- Strang-Dateien unter 20260820-w2-sofortstaffel/: grep nach 11er-Delta-Zaehlung in
  F2-VORLAGEN-FENSTER-ENTWURF.md und vorlagen-fenster-ergebnis.md = 0 einschlaegige
  Treffer (die "15 Delta-Zeilen" in ergebnis.md Z.57 betreffen Teil 4 des ENTWURFs,
  vom Audit unter 2(d)3 als korrekt aufgeloest) — kein Korrekturbedarf in der
  Strang-Lieferung.

## 2. FIX-VOLLZUG (docs-Nachtrags-Commit im eigenen Fix-Worktree)

Der Doku-Strang besass keinen Worktree (0 Commits, Audit P-02). Der Audit-FIX-WEG
verlangt den docs-Nachtrags-Commit "im Lande-/Fix-Worktree des zustaendigen Strangs" —
also Fix-Worktree NEU angelegt, gepinnt auf den selbst gepruefte Stand:

- `git worktree add -b fix/vorlagenfenster-r1 /home/comdare/wt-super-vorlagenfix
  5b5a818f...` rc=0; HEAD == 5b5a818f (literal), status clean. Hauptklon-Arbeitsbaum
  und development-Ref unberuehrt (parallele Lande-Arbeit ungestoert).
- 5 Zaehler-Edits (alle eingefuegten Substrings reines ASCII):
  1. D3 Z.17: "D-01..D-11):" -> "D-01..D-12 (D-12 nachgetragen 8aae5cd2)):"
     (Wortlaut exakt nach Audit-FIX-WEG Punkt 1)
  2. D3 Z.86: "DIESE 11 Deltas" -> "DIESE 12 Deltas"
  3. D2 Z.79: "(11 Deltas" -> "(12 Deltas"
  4. D2 Z.80: "D-01..D-11 aus der W1L-BAULISTE" -> "D-01..D-12 aus der W1L-BAULISTE"
  5. D2 Z.107: "+ 11 Deltas" -> "+ 12 Deltas"
- V1-02 per BLOCK-TAUSCH (die staerkere der beiden Audit-Optionen): D-12-Block
  (Z.65-68) und D-11-Block (Z.70-74) byte-treu vertauscht (python3, rb/wb-Modus, nur
  Zeilen-Verschiebung, 4 Grenz-Asserts gruen, Zeilenzahl 88 unveraendert); die
  Nachtrag-Historie bleibt via Z.17-Vermerk "(D-12 nachgetragen 8aae5cd2)" dokumentiert.
- clang-format-22: nicht einschlaegig (keine Lint-Datei beruehrt, nur .md).
  Bau-Slot: nicht einschlaegig (DOKU-Strang, kein Compile — auftragskonform).
  df-Gate: 36G frei (>5G).

COMMIT: a6fa04dae76777ece26d335c95eee2e031facf22 auf fix/vorlagenfenster-r1,
"docs(sessions): F2-Fenster Delta-Zaehler 11->12 an 4 Stellen + D-11/D-12-Reihenfolge
(A2.5-Fix V1-01/V1-02)", Trailer Co-Authored-By gesetzt; `git show --stat`:
2 Dateien, 10 insertions(+), 10 deletions(-) — AUSSCHLIESSLICH die 2 docs/sessions-
Dateien (TABU-Flaechen unberuehrt; Ledger/Board/Memory NICHT geschrieben).

PUSH: `git push -o ci.skip origin fix/vorlagenfenster-r1` rc=0, "[new branch]";
`git ls-remote origin refs/heads/fix/vorlagenfenster-r1` =
a6fa04dae76777ece26d335c95eee2e031facf22 (Ref-Sicherung literal bestaetigt, KEINE
Pipeline).

## 3. NACH-VERIFIKATION AM COMMIT (Beweisort = Commit-Objekt, nicht Arbeitsbaum)

- NULL-GEGENPROBE: `git show a6fa04da:<Datei> | grep -c -E "11 Deltas|D-01\.\.D-11"`
  = 0 (FINAL-konsolidiert) und 0 (FREEZE-CHECK).
- REIHENFOLGE: `git show a6fa04da:...FINAL-konsolidiert.md | grep -n "^### D-"` =
  12 Treffer streng aufsteigend: D-01(19) D-02(24) D-03(29) D-04(35) D-05(40)
  D-06(44) D-07(47) D-08(51) D-09(55) D-10(59) D-11(65) D-12(71).
- POSITIV-PROBEN (grep am neuen Stand): Z.17 "...hiermit ins Fenster gehoben — D-01..
  D-12 (D-12 nachgetragen 8aae5cd2)):" · Z.86 "...DIESE 12 Deltas) liegt der" ·
  D2 Z.79 "...FINAL-konsolidiert.md (12 Deltas" · Z.80 "D-01..D-12 aus der
  W1L-BAULISTE..." · Z.107 "Fenster R6 vorgelegt (20+3 Bloecke + 12 Deltas; ...".

## 4. DOKU-STRANG-ARTEFAKTE

- LANDE-AUFLAGEN geschrieben:
  /home/comdare/backups-workflow/20260821-w2-audit-fixverify/vorlagenfenster/lande-auflagen.md
  (L-1 Branch-Landung Pflicht · L-2 KON120 traegt die ZWOELF, Entwurf nicht woertlich
  uebernehmen · L-3 F-122-Beifang als getragener Lead-Posten, bewusst NICHT von A2.5
  vollzogen: inhaltlicher Lead-Entscheid ausserhalb der Fund-Liste).
- A2.5-FIX-NACHTRAG-Abschnitt ANS DATEIENDE von
  /home/comdare/backups-workflow/20260820-w2-sofortstaffel/vorlagen-fenster-ergebnis.md
  angefuegt (98 -> 114 Z., Bestand byte-unveraendert, append rc=0).

## 5. QUITTUNGEN (dreiwertig, Vollzaehligkeits-Gate 2/2 Fund-IDs)

### V1-01 [MILD] — BEHOBEN
Beleg (eigen): super-Commit a6fa04dae76777ece26d335c95eee2e031facf22 auf
fix/vorlagenfenster-r1 (origin ls-remote literal bestaetigt). Alle 4 Stellen tragen die
12: D3 Z.17 "D-01..D-12 (D-12 nachgetragen 8aae5cd2)):" + Z.86 "DIESE 12 Deltas"
(= ABNAHME-Formel 6 jetzt selbstkonsistent) + D2 Z.79/80 "(12 Deltas / D-01..D-12 aus
der W1L-BAULISTE" + Z.107 "+ 12 Deltas". Null-Gegenprobe am Commit 0/0 Treffer
"11 Deltas|D-01..D-11". Der Ledger-Anteil des Fundes (KON120 MUSS die 12 tragen) ist
KEIN offener Defekt (KON120 existiert noch nicht; Ledger = Lead-only) und als
PFLICHT-Auflage L-2 in lande-auflagen.md verankert.

### V1-02 [KLEIN] — BEHOBEN
Beleg (eigen): `git show a6fa04da:...FINAL-konsolidiert.md | grep -n "^### D-"` =
D-01..D-12 streng aufsteigend (D-11 jetzt Z.65, D-12 jetzt Z.71); Tausch byte-treu
(rb/wb-Verschiebung, 4 Grenz-Asserts, Zeilenzahl 88 konstant, Diff der Datei 7+/7-
inkl. der 2 Zaehler-Zeilen); Nachtrag-Herkunft bleibt am Z.17-Vermerk ablesbar.

## 6. GATE-ABGRENZUNG (beide Mengen) + RESTE

GEDECKT: die 2 Funde in den 2 committeten Lead-Dateien am Branch-Stand a6fa04da
(origin-gesichert). NICHT GEDECKT (Traeger benannt): Landung des Branches auf
development (Lande-Zug, L-1) · KON120-Ledger-Buchung mit der 12 (Lead, L-2) ·
F-122-Rest-Uebertrag an D-04 (Lead, L-3) · getragene offene Posten F-71..F-77/F-123
(Owner/Lead, unveraendert). Kein Bau, kein ctest (DOKU-Strang, auftragskonform —
"KEIN Bau-Slot noetig"); Rot-Lauf-Logs: keine (kein Rot-Lauf gefahren).
Worktree /home/comdare/wt-super-vorlagenfix bleibt stehen bis gruen+gemergt.

--------------------------------------------------------------------------------
## 7. WIEDERANLAUF-RE-VERIFIKATION (A2.5 Runde 1, 23.08.2026 — additiv angefuegt)

ANLASS: Wiederanlauf der Fix-Stufe R1 nach Session-Abriss (Erst-Lauf 22.08.
06:32-06:35). Bestand VOLL gelesen: audit-runde-1.md (178 Z.) + dieser Bericht
(Abschnitte 1-6, 116 Z.) + lande-auflagen.md (47 Z.) + audit-runde-2.md (133 Z.,
Verdikt SITZT, 2/2 BESTAETIGT BEHOBEN). Alle folgenden Messungen FRISCH am 23.08.
selbst gefahren (nicht aus Erst-Lauf/Audit abgeschrieben).

### 7.1 Branch-Stand unveraendert bestaetigt (eigene Messungen 23.08.)

- Worktree /home/comdare/wt-super-vorlagenfix: HEAD == a6fa04da, `git status
  --short --branch` = nur "## fix/vorlagenfenster-r1" (clean); `git worktree list`
  fuehrt ihn auf [fix/vorlagenfenster-r1].
- origin-Ref: `git ls-remote origin refs/heads/fix/vorlagenfenster-r1` =
  a6fa04dae76777ece26d335c95eee2e031facf22, rc=0 — Ref-Sicherung liegt weiterhin;
  KEIN neuer Push noetig (origin == HEAD).
- Topologie: `git merge-base development fix/vorlagenfenster-r1` = 5b5a818f;
  `git log development..fix/vorlagenfenster-r1` = GENAU 1 Commit (a6fa04da);
  5b5a818f ist Ancestor von development (rc=0) — kein Fremd-Commit, kein Rebase.
- Positiv-Proben am Worktree-Objekt (grep -n): FINAL Z.17 "...D-01..D-12 (D-12
  nachgetragen 8aae5cd2)):" · Z.86 "...DIESE 12 Deltas) liegt der" · FREEZE Z.79
  "(12 Deltas" · Z.107 "+ 12 Deltas". Null-Gegenprobe "11 Deltas" beide Dateien
  = 0/0 (grep -c, rc=1).
- Reihenfolge: `grep -n "^### D-"` = 12 Treffer streng aufsteigend, D-11(65) vor
  D-12(71).
- Byte-Treue Block-Tausch EIGEN nachgemessen (korrekte Fenster): D-12-Block alt
  (git show 8aae5cd2:...FINAL... Z.65-68) vs neu (HEAD Z.71-74): diff rc=0;
  D-11-Block alt (Z.70-74) vs neu (Z.65-69): diff rc=0 — beide BYTE-IDENTISCH.

### 7.2 LAGE-AENDERUNG seit Audit R2: development traegt die Fixe INZWISCHEN SELBST

- development-Tip 23.08.: 38428099 ("docs: ABBRUCHSICHERE PAUSE 23.08.",
  2026-08-23 13:41:26 +0000). a6fa04da ist NICHT Ancestor von development (rc=1)
  — der Fix-Branch blieb ungelandet.
- ABER: dev-Commit 8ed8b268efdbac08a5c99f3e681e9fc7dc113b44 (22.08. 06:53:59,
  ~21 min NACH a6fa04da; "docs: Zwischendoku Vollpruefung ... + VF-A1/VF-A2-
  Delta-Zaehler-Fix (11->12, D-12-Ordnungsnotiz)") hat als LEAD-FIX dieselben
  Fund-Gegenstaende auf development geheilt — Diff VOLL gelesen:
  - V1-01-Substanz: FINAL Z.17-18 "D-01..D-12; VF-A1-Nachzug 22.08.: D-12 per
    8aae5cd2 nachgetragen, Zaehler hier nachgezogen):" + ABNAHME "DIESE 12
    Deltas" + FREEZE "(12 Deltas / D-01..D-12 aus der W1L-BAULISTE, D-12
    nachgetragen 8aae5cd2; ..." + KON120-ENTWURF-Zitat "+ 12 Deltas
    [VF-A1-Nachzug 22.08.]".
  - V1-02 per AUDIT-OPTION B (Ein-Zeilen-Notiz statt Tausch): HTML-Kommentar vor
    D-12 "<!-- ORDNUNGSNOTIZ (VF-A2, 22.08.): D-12 nachgetragen 21.08. 09:26 per
    8aae5cd2 — Reihenfolge vor D-11 historisch, kein Versehen. -->"; die
    D-12-vor-D-11-Reihenfolge BLEIBT dort bestehen (deklariert statt getauscht).
- EIGENE Null-Gegenprobe am WIRKSAMEN Objekt (dev-Tip 38428099):
  `git show development:<Datei> | grep -c -E "11 Deltas|D-01\.\.D-11"` = 0
  (FINAL) und 0 (FREEZE).
- `git log 5b5a818f..development -- <die 2 Dateien>` = GENAU 8ed8b268 (einziger
  Beruehrer seit der Fix-Basis).
- LEAD-DISPOSITION LIEGT BEREITS (kein Entscheid dieser Stufe noetig):
  Zwischendoku 20260822-SESSION-zwischendoku-vollpruefung-...md §3.3 setzt die
  HARMONISIERUNGS-AUFLAGE literal: "Beim Lande-Zug beide Fassungen HARMONISIEREN
  (gleicher Gegenstand -> Lead-Fassung fuehrt; Fix-Branch-Mehrwerte uebernehmen,
  nichts doppelt einbauen)"; §7 fuehrt wt-super-vorlagenfix unter "ALLE bleiben
  bis zur S1+S2-Landung". Ledger KON120-07 Punkt 1 (dev-Ledger Z.91-93) BUCHT
  den Lead-Fix + die Harmonisierungs-Auflage gegen fix/vorlagenfenster-r1.
- L-2-Lage frisch: Freeze-Check-Eintrag am dev-Ledger WEITER NICHT gebucht
  (grep "F2-FREEZE|FREEZE-CHECK|1[12] Deltas": nur Alt-KON94 Z.2447 "Full-Join
  12 Deltas" (anderes Thema) + Planungstext Z.7401f); KON120 ist durch die
  Owner-Antworten-Tranchen vergeben — Buchung wird KON121+ tragen (deckt sich
  mit Audit-R2-Hinweis, hier eigenstaendig am 23.08.-Objekt bestaetigt).
  Beifang-Kenntnis: dev-Ledger Z.173-174 fuehrt den D-12-INHALT (Dock-Zahl
  SECHS doppelt owner-gesetzt, OFFEN-OWNER-Fuehrung in FINAL-D-12 stale) —
  INHALTLICHER Lead-/Owner-Posten ausserhalb der Fund-Liste, hier nur notiert.

### 7.3 KONSEQUENZ DES WIEDERANLAUFS

- QUITTUNGEN BLEIBEN 2/2 BEHOBEN — jetzt DOPPELT belegt: Branch-Fassung
  a6fa04da (Option A Block-Tausch, origin-gesichert) UND wirksame dev-Fassung
  8ed8b268 (Option B Ordnungsnotiz; Null-Gegenprobe 0/0 am dev-Tip EIGEN
  gemessen). Beide Wege sind vom Audit-FIX-WEG ausdruecklich zugelassen.
- KEIN neuer Commit in diesem Wiederanlauf (0 offene Fund-Reste am wirksamen
  Objekt; ein weiterer Branch-Commit wuerde die per KON120-07 beauftragte
  Harmonisierung nur erschweren). KEIN Push (origin == HEAD, gemessen).
- lande-auflagen.md um NACHTRAG 23.08. ergaenzt: L-1 in der Fassung "Branch-
  Landung PFLICHT" ist UEBERHOLT — es gilt die staerkere KON120-07/§3.3-
  Harmonisierungs-Auflage (Lead-Fassung fuehrt, nichts doppelt); L-2 Substanz
  unveraendert mit Nummern-Update KON121+; L-3 unveraendert.
- Sofortstaffel-Ergebnisbericht: kurzer Wiederanlauf-Vermerk additiv angefuegt
  (der dortige A2.5-Nachtrag nannte noch "L-1 Branch landen").
- GATE-ABGRENZUNG AKTUALISIERT — GEDECKT: Fund-Zustand V1-01/V1-02 am
  Branch-Stand UND am development-Tip (je eigene Messungen). NICHT GEDECKT
  (Traeger benannt): Harmonisierung Branch<->dev beim S1+S2-Lande-Zug
  (Lead, KON120-07) · Ledger-Buchung des Freeze-Checks mit der ZWOELF unter
  KON121+ (Lead) · F-122-Uebertrag an D-04 (Lead, L-3) · D-12-INHALTS-Posten
  "SECHS owner-gesetzt, FINAL-D-12-Fuehrung stale" (Lead/Owner, dev-Ledger
  Z.173-174) · getragene Posten F-71..F-77/F-123 (Owner/Lead).
- Worktree bleibt stehen (Zwischendoku §7: bis S1+S2-Landung; Doktrin: Loeschung
  erst gruen+gemergt, hier zusaetzlich erst nach Harmonisierungs-Entscheid).
