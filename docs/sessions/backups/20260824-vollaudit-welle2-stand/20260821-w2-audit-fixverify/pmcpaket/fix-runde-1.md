# FIX RUNDE 1 — Strang pmcpaket (#82 I-PMC-2/3 + #83 PMC-fail-loud)

Fix-Stufe: Fable-max A2.5, Runde 1 (W2-Audit-Fix-Verify, 22.08.2026). Objekt: ce `bau/pmcpaket` @
**1d38263b** im Worktree `/home/comdare/wt-ce-pmcpaket`. Audit-Input: `audit-runde-1.md` (312 Z., VOLL
gelesen) — Verdikt FIXES_NOETIG: 0 ERNST, 1 MILD (A-1), 1 KLEIN (A-2). Beide Fund-Fix-Wege schliessen
einen ce-Code-Fix ausdruecklich aus; das wurde von dieser Stufe am Objekt GEGENGEPRUEFT (unten), nicht
uebernommen. Alle Belege dieser Runde sind EIGENE Messungen (Kommandos + Literale genannt), keine
Audit-Abschriften.

## OBJEKT-ZUSTAND (vor == nach; EIGENE Messung)

- `git rev-parse HEAD` im Worktree: `1d38263b017ff8aa3126650a41b208b0c8795a90` — VOR der Stufe gemessen
  und als ENDSTAND erneut: `HEAD=1d38263b017ff8aa3126650a41b208b0c8795a90 PORCELAIN=0`.
- `git status --porcelain | wc -l` = **0** (kein dirty-Stand vorhanden; nichts zu uebernehmen).
- `git ls-remote origin refs/heads/bau/pmcpaket` = `1d38263b017ff8aa3126650a41b208b0c8795a90` —
  Ref auf origin bereits gesichert (eigene ls-remote-Messung dieser Stufe).
- **0 neue Commits** in dieser Runde. Begruendung je Fund unten; deshalb kein T-1-Rot-Lauf (kein
  Code-Fund), kein clang-format-Lauf (0 geaenderte Lint-Dateien am Branch), kein Push (Ref unveraendert
  und gesichert).

## BAU-TREPPEN-ERKLAERUNG (EIN gruenes Gate deckt nur seinen Gegenstand — BEIDE Mengen)

**Nicht gefahren, mit Begruendung:** Die Bau-Treppe der Stufen-Order ist an "Fixe als NEUE Commits auf
dem Branch" gebunden. Diese Runde erzeugt 0 Commits (beide Funde sind Plan-/Ledger-Traeger-Funde ohne
ce-Code-Delta; von mir am Objekt verifiziert, s. A-1/A-2). Ein Vollbau am byte-identischen Commit
1d38263b wiederholte exakt die gcc-Release-Zelle, die der Strang-Bericht bereits literal traegt
(SB: Zweitlauf `100% tests passed, 0 tests failed out of 512`, CTEST_RC=0), und belegte einen der 3
geteilten Bau-Slots gegen den laufenden W1L-Kombibau — ohne jeden Deckungsgewinn am unveraenderten
Objekt. **Von dieser Stufe GEDECKT:** Objekt-Unveraendertheit (HEAD/porcelain/ls-remote-Literale oben),
Fund-Belege und die Wirkungs-Gegenproben der NP-34-Vorlage (unten). **Von dieser Stufe NICHT gedeckt
(Traeger unveraendert):** Compile-/ctest-Gruenheit am Tip (Traeger: SB-Literal 512/512) und der
4-Zellen-Kombibau (Traeger: W2-Lande-Zug am gemergten Endstand, K17-Doktrin; so auch die
Deckungs-Erklaerung des Audits). Es wird KEIN neuer Bau-Erfolg behauptet.

---

## FUND A-1 (MILD) — NP-34-Kopplung im Lande-Plan als "Folgepaket" geparkt

### Eigenbelege (alle von dieser Stufe frisch gehoben)

1. **Ledger-Wortlaut** (super `docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md`, `grep -n "DENSELBEN
   Zug"` → :1301 zum Messzeitpunkt; `sed -n '1296,1304p'` im Original): "NP-34 csv_to_latex.cpp:985-986
   (Kernmetrik-Text \"= 0 / nicht erhoben\", D-18) in DENSELBEN Zug buendeln, damit Textaussage und
   Messvermoegen nie auseinanderlaufen." CAVE lebender Ledger: noch WAEHREND dieser Runde wuchs die
   Datei auf 32272 Z. (KON120-Block neu am Kopf, 22.08. frueh) — der Wortlaut liegt jetzt bei ~:1363;
   Anker ist der WORTLAUT (KON106-04/NP-34), nie die Zeilennummer.
2. **Fehl-Platzierung liegt DOPPELT vor** (S1-SYNTHESE `/home/comdare/backups-workflow/
   20260820-w2-sofortstaffel/STAFFEL1-SYNTHESE.md`, selbst gelesen):
   - Z.247-248: "**Folgepakete:** W1-FATAL-Flip im super-Nachzug-Fenster (F-41) · **NP-34 csv_to_latex
     (super, F-40)** · ..." (Folgepakete = "einplanbar nach der Landung", Block-Kopf Z.238).
   - **ZUSATZBEFUND dieser Stufe:** Z.99 fuehrt den Posten AUCH in "Phase 4 — Nachlanden":
     "... NP-34-super-Umschrieb · ..." — ebenfalls NACH dem super-Push (Phase 3 endet mit "dann Push
     und GitLab-Pipeline GRUEN verifizieren", Z.92-93). Beide Traeger-Stellen muessen umgehaengt
     werden, nicht nur die vom Audit genannte.
3. **Objekt-Seite super** (`grep -rn 'strukturell 0|structurally 0' Code/` am Hauptklon, NUR LESEND):
   genau **4 Fundstellen in genau 2 Rows** — DE `Code/04_csv_to_latex/csv_to_latex.cpp` :987/:995
   (Row :986-999) und **EN-Zwilling :1082/:1089 (Row :1081-1094)**. Der EN-Zwilling ist ein
   **ZUSATZBEFUND dieser Stufe** (der Audit-fix_weg nannte nur :986-999); eine Umschrift, die nur den
   DE-Block traefe, liesse den Auseinanderlauf im EN-Anhang bestehen.
4. **ce-Seite** (eigene Lesung `git show 1d38263b:libs/cache_engine/include/cache_engine/measurement/
   pmc_raw_event_katalog.hpp`): Zen 5 (AuthenticAMD, Family 26): l2 = `PERF_TYPE_RAW 0x964`
   (`l2_cache_req_stat.ic_dc_miss_in_l2`, Demand-IC+DC-Misses in L2 ohne L2-Prefetch), coherence =
   `PERF_TYPE_RAW 0x1443` (`ls_dmnd_fills_from_sys.remote_cache`, Demand-Fills aus fremdem CCX =
   Kohaerenz-Beobachtbarer; "kein woertlicher Invalidierungszaehler im amdzen5-Satz"); fremde Modelle
   fail-closed leer. Landet pmcpaket ohne die super-Umschrift im SELBEN Zug, behauptet der generierte
   Anhang "strukturell 0", waehrend ce auf Zen 5 real misst — exakt der vom Ledger verbotene Zustand.

### Gegenpruefung "kein ce-Code-Fix" (eigenstaendig)

`git diff --name-only 66de5c09..1d38263b` enthaelt 0 super-Pfade (16 Dateien, alle libs/ + tests/unit/;
vom Audit reproduziert, von mir stichprobenhaft am name-status nachvollzogen); die zu aendernde Datei
liegt im super-Repo ausserhalb des ce-Worktrees. Der Strang pmcpaket besitzt KEINEN super-Worktree
(`git worktree list` im super: nur cidual/kampvor/s13schema/w1luecken). Ein JETZT eroeffneter separater
super-Zug wuerde das "DENSELBEN Zug"-Gebot erneut verfehlen (der ce-Endstand, den der Gitlink bumpt,
existiert erst im Lande-Zug). Bestaetigt: kein ce-Code-Fix, kein vorgezogener super-Commit.

### Vollzug dieser Stufe: anwendungsfertige, BEWIESENE Vollzugsvorlage

**Artefakt:** `/home/comdare/backups-workflow/20260821-w2-audit-fixverify/pmcpaket/
np34-csv-to-latex-umschrift.patch` (73 Zeilen, unified diff `a/Code/04_csv_to_latex/csv_to_latex.cpp`,
sha256 `60fa5504bcaddc09185e342e19c5cc92aaca17c51e2857d8cc6b8217e93eedab`). Er schreibt BEIDE Rows um:

- DE-Headline neu: "L2 + Coherence modell-gebunden real (Zen 5: `PERF_TYPE_RAW` 0x964/0x1443), sonst
  n/a; ..." — EN analog "model-bound real ... otherwise n/a".
- DE/EN-Body neu: kein portabler generischer Zaehler -> modell-gebundene Erhebung ueber den
  RAW-Event-Katalog (`pmc_raw_event_katalog.hpp`; Zen 5, Family 26: beide Kodierungen + Semantik-
  Offenlegung "Demand-IC+DC-Misses in L2 ohne L2-Prefetch" / "Demand-Fills aus dem Cache eines anderen
  CCX, der Kohaerenz-Beobachtbare des Core-PMU — ein woertlicher Invalidierungszaehler existiert im
  amdzen5-Satz nicht"); Modelle ohne Katalog-Eintrag ehrlich n/a (per-Feld-Flag), nie geraten;
  L3-AMD-Oeffnungs-Caveat, RAPL-best-effort, Intel-PCM-Windows-Ausstand bleiben erhalten; der
  Wall-Clock-Proxy-Schlusssatz gilt neu NUR fuer Modelle ohne Katalog-Eintrag.

**Beweise am Patch (alle literal in dieser Runde erhoben):**
- Block-Eindeutigkeit: Ersetzung ueber byte-exakten Match des Bestands, je Block genau 1 Treffer
  ("DE-Block ersetzt (1x, eindeutig)" / "EN-Block ersetzt (1x, eindeutig)") — d.h. der Patch passt auf
  den HEUTIGEN super-HEAD-Stand der Datei.
- Anwendbarkeit: `patch -p1 --dry-run` ok ("checking file ..."), `git apply --check -p1` **RC=0**,
  echte Anwendung an frischer Kopie + `cmp` gegen die gepruefte Fassung **byte-identisch (RC=0)**.
- Wirkung (Rot->Gruen-Aequivalent der Textbehauptung): VOR Patch 4 Treffer `strukturell 0|structurally
  0`, NACH Patch **STRUKTURELL0_REST=0**; `RAW964=4 RAW1443=4` (je Headline+Body in DE und EN).
- Hygiene: **MAXLEN_NEU=112** (alle Zusatzzeilen <= 120 Spalten), **NICHTASCII_NEU=0** (ASCII-only in
  neuen Zeilen; Bestandsdatei selbst traegt UTF-8-Altbestand ausserhalb der Bloecke, unangetastet).
- Der super-Hauptklon wurde dabei NICHT beruehrt (Konstruktion vollstaendig in /tmp-Kopien).

### ENTWURF Lande-Plan-Delta (fuer Synthese/Lead — Lande-Plan ist Lead-Traeger)

1. **Umhaengen:** F-40/NP-34 verlaesst "Folgepakete" (S1-SYNTHESE Z.247) UND "Phase 4 — Nachlanden"
   (Z.99) und wird PFLICHT-BESTANDTEIL der super-Lande-Phase (Phase 2): Der super-Commit-Zug, der den
   ce-Gitlink ueber den pmcpaket-tragenden ce-Endstand bumpt, traegt IM SELBEN Commit-Zug die
   Umschrift beider Rows (Patch oben; danach clang-format des super ueber die Datei, falls dort
   Lint-Pflicht). Formulierungsvorschlag fuer die Lande-Reihenfolge: "Phase 2, Schritt 8: ce-Gitlink-
   Bump (traegt pmcpaket) NUR ZUSAMMEN MIT np34-csv-to-latex-umschrift.patch — KON106-04 :1300-1302
   'in DENSELBEN Zug'; F-40 damit GESCHLOSSEN, nicht Folgepaket."
2. **Nicht mitgezogen (bleibt Folgepaket, eigener Traeger):** W1-FATAL-Flip (F-41) — der ist im Code
   selbst als Folgepaket mit Fenster verdrahtet und Board-#83-REST; A-1 aendert daran nichts.
3. Der EN-Zwilling (:1081-1094) ist Teil der Pflicht (Zusatzbefund oben) — der Patch deckt ihn bereits.

### QUITTUNG A-1: **VERTAGT** (Platz: W2-Lande-Zug, super-Lande-Phase/Phase 2 — der Gitlink-Bump-Zug
selbst; Traeger Lead/Lande-Zug). Der Fix KANN strukturell erst dort vollzogen werden (der zu bumpende
ce-Endstand entsteht erst im Lande-Zug; ein vorgezogener separater super-Commit verfehlte das
"DENSELBEN Zug"-Gebot erneut). Diese Stufe hat den Vollzug auf Anwendungs-Reife gebracht: gepruefter
Patch (git apply --check RC=0, Wirkungs- und Hygiene-Gegenproben literal) + Umhaenge-Entwurf fuer BEIDE
Fehl-Platzierungs-Stellen. Platz liegt VOR/IN der Landung — kein Tragen ueber die Landung hinweg.

---

## FUND A-2 (KLEIN) — "6 static_asserts" in Bericht/Board, Objekt traegt 7

### Eigenbelege (alle von dieser Stufe frisch gehoben)

1. **Eigene Zaehlung am Objekt:** `git show 1d38263b:libs/cache_engine/include/cache_engine/
   measurement/pmc_raw_event_katalog.hpp | grep -c 'static_assert('` = **7**; mit `grep -n`:
   Zeilen **:95 :96 :98 :100** (4 positive Zen5-Pins: `vorhanden`, `l2.config == 0x964`,
   `coherence.config == 0x1443`, beide `type == PERF_TYPE_RAW`) + **:103 :105 :107** (3 Negativ-Pins:
   family 25 leer, GenuineIntel leer, ""/0 leer fail-closed).
2. **Die falsche 6 am Ist-Traeger, selbst zitiert:** Strang-Bericht `/home/comdare/backups-workflow/
   20260820-w2-sofortstaffel/pmc-paket-ergebnis.md` **Z.175**: "ALLE anderen Modelle leer (fail-closed,
   kein Rateversuch; 6 static_asserts)." — und **Board-Task #82** traegt literal "fremde Modelle
   ehrlich leer (fail-closed, 6 static_asserts)". (Auch die Audit-Soll-Karte Z.61/62 uebernahm die 6
   aus dem SB — Herkunftskette, kein weiterer reisender Traeger.)
3. **Ledger-Gegenprobe (praeventiver Charakter der Korrektur), ZWEIMAL gemessen:** `grep -n
   '6 static_assert'` im Ledger liefert als einzigen Treffer die C-3-best_binary-Zeile ("Gate-
   Erweiterung 1->6 static_asserts"; :1310 frueh in der Runde, :1372 nach dem KON120-Wachstum) — ein
   ANDERER Gegenstand. **KON120 ist waehrend dieser Runde bereits gelandet** (Ledger-Kopf Z.19,
   "OWNER-ANTWORTEN TRANCHE 1+2", 22.08. frueh; Datei 32272 Z.) und traegt die pmcpaket-Zeilen NICHT:
   `grep -n 'pmc_raw_event_katalog|RAW 0x964|0x964'` ueber den GESAMTEN Ledger = **0 Treffer**. Die
   falsche Zahl ist also noch in KEINEN Ledger-Zug gereist; der vom Audit "KON120-Zug" genannte
   Traeger ist real der Ledger-Zug AN der W2-Landung (S1-Phase-4 "Ledger-Entwuerfe einpflegen ...
   pmc 2"), der eine SPAETERE KON-Nummer bekommt. Korrektur-Orte: dieser Lande-Ledger-Zug (7 statt 6
   in den beiden pmc-Entwurfszeilen) + Board-#82-Text.
4. **Richtung:** guenstig (7 Pins am Objekt > 6 behauptet) — kein Code-Defekt, reine Zahl-Korrektur.
   SB und Soll-Karte sind additive Rohdaten-/Historien-Dokumente und werden NICHT rueckwirkend
   editiert; die Korrektur reist ueber KON120/Board.

### QUITTUNG A-2: **VERTAGT** (Platz: Lead-only-Ledger-Zug AN der W2-Landung — die vom Audit
"KON120-Zug" genannte Einpflege der pmc-Entwurfszeilen; KON120 selbst ist am 22.08. frueh fuer die
Owner-Tranchen verbraucht worden und traegt die Zahl NICHT (0-Treffer-Messung oben), die Korrektur
bleibt also praeventiv VOR der ersten Ledger-Reise. Board-#82-Textkorrektur im selben Lead-Zug;
S1-Phase-4 traegt die Ledger-Entwurfs-Einpflege). Ledger/Board sind fuer diese Stufe TABU (Lead-only)
— der Vollzug ist hier per Order unmoeglich, der ENTWURF liegt unten anwendungsfertig.

### ENTWURF fuer den Lande-Ledger-/Board-Zug (Lead-only; woertlich uebernehmbar)

- **Board #82, Textkorrektur:** "... fremde Modelle ehrlich leer (fail-closed, **7 static_asserts**:
  4 positive Zen5-Pins + 3 Negativ-Pins) ..." (ersetzt "6 static_asserts").
- **Ledger-Zeile im Lande-KON (Vorschlag):** "KORREKTUR zu #82/I-PMC-3: pmc_raw_event_katalog.hpp traegt
  **7** static_asserts (:95/:96/:98/:100 positive Zen5-Pins + :103/:105/:107 Negativ-Pins family-25/
  GenuineIntel/leer), nicht 6 wie SB Z.175/Board-#82 — am Objekt 1d38263b gezaehlt (Fix-Runde 1
  pmcpaket, 22.08.); Richtung guenstig, kein Code-Delta."

---

## VOLLZAEHLIGKEITS-GATE

Audit-Fundmenge: A-1 (MILD) + A-2 (KLEIN) = 2 Funde; 0 ERNST (Gegenzaehlung am Audit-Verdikt).
Quittiert in dieser Runde: **2/2** (A-1 VERTAGT mit Platz + anwendungsreifer Vorlage; A-2 VERTAGT mit
Platz + woertlichem ENTWURF). Keine weiteren Funde erhoben; zwei ZUSATZBEFUNDE zur A-1-Traguns-Flaeche
(EN-Zwilling :1081-1094; zweite Fehl-Platzierung S1-SYNTHESE Z.99) sind in der A-1-Vorlage bereits
gedeckt und erzeugen keinen eigenen Fund. Getragene offene Posten des Audits (F-39/F-40/F-41/F-42,
Lande-Zug-Pflichten) bleiben unveraendert bei ihren Traegern.

## ARTEFAKTE DIESER RUNDE

- Dieser Bericht: `/home/comdare/backups-workflow/20260821-w2-audit-fixverify/pmcpaket/fix-runde-1.md`
- Vollzugsvorlage A-1: `/home/comdare/backups-workflow/20260821-w2-audit-fixverify/pmcpaket/
  np34-csv-to-latex-umschrift.patch` (sha256 60fa5504...eedab, 73 Z.)
- Objekt unveraendert: `bau/pmcpaket` @ 1d38263b (HEAD==origin==Audit-Tip, porcelain 0, 0 Commits,
  0 Pushes, 0 Bauten — Begruendungen oben mit Literalen).

Ende fix-runde-1 pmcpaket. 2/2 Fund-IDs quittiert; kein ce-Code-Delta (auftragsgemaess je Audit-
fix_weg, eigenstaendig gegengeprueft); Vollzugsorte benannt: W2-Lande-Zug Phase 2 (A-1) und
KON120-Ledger-Zug (A-2).

---

## WIEDERANLAUF-NACHTRAG (23.08.2026) — Stufe erneut ausgegeben; Ergebnis BESTAETIGT, Frische-Belege

Anlass: Die Fix-Stufe A2.5 Runde 1 wurde nach Workflow-Resume erneut ausgegeben. Auf Platte lagen
bereits dieser Bericht (22.08., oben — UNVERAENDERT belassen, dieser Nachtrag ist ADDITIV) und
`audit-runde-2.md` (RE-VERIFY, Verdikt **SITZT**); beide VOLL gelesen. Kein Neu-Vollzug noetig (beide
Funde sind Nicht-Code-Funde, Quittungen bleiben VERTAGT). Diese Wiederausgabe hebt HEUTIGE
Eigen-Literale und prueft die VERTAGT-Plaetze auf Frische — insbesondere die R2-Weiterreichungs-
Pflicht "bewegt sich super vorher, Patch-Match erneut pruefen": super HAT sich bewegt
(R2-Messung 657003bb -> heute 38428099).

### Objekt-Zustand HEUTE (eigene Messungen 23.08.)

- Worktree `/home/comdare/wt-ce-pmcpaket`: `git rev-parse HEAD` =
  `1d38263b017ff8aa3126650a41b208b0c8795a90`, Branch `bau/pmcpaket`, `PORCELAIN_LINES=0`;
  `git ls-remote origin refs/heads/bau/pmcpaket` = `1d38263b017ff8aa3126650a41b208b0c8795a90`.
  HEAD==origin==Audit-Tip. Weiterhin 0 Commits, 0 Pushes, 0 Bauten dieser Stufe (Begruendung
  unveraendert wie oben: 0 Code-Funde, byte-identisches Objekt; ctest-Gruenheits-Traeger bleibt
  SB-Literal 512/512 + K17-Kombibau des Lande-Zugs; Bau-Slots dem laufenden Kombibau gelassen).

### A-1-Frische (VERTAGT-Platz traegt weiter)

- super `development` HEUTE: HEAD=`38428099b69e53845ade70e19a584ae88f448ae5`. Patch-Artefakt
  byte-identisch (sha256 `60fa5504bcaddc09185e342e19c5cc92aaca17c51e2857d8cc6b8217e93eedab`,
  eigene Messung heute).
- **Patch beisst auch am NEUEN super-HEAD** (Wegwerf-Kopie in /tmp aus
  `git show HEAD:Code/04_csv_to_latex/csv_to_latex.cpp`): `git apply --check -p1` **RC=0**;
  `patch -p1 --dry-run` "checking file ..." **RC=0**; Wirkung nach echter Anwendung an der Kopie:
  `STRUKTURELL0_VOR=4` -> **`STRUKTURELL0_REST=0`**, **`RAW964=4 RAW1443=4`** (Headline+Body, DE+EN).
  super-Hauptklon unberuehrt (nur `git show`; /tmp-Kopie danach geraeumt).
- Beide Fehl-Platzierungs-Stellen stehen unveraendert (heute per `sed` zitiert): S1-SYNTHESE Z.99
  "NP-34-super-Umschrieb" (Phase 4 — Nachlanden) und Z.247-248 "**Folgepakete:** ... NP-34
  csv_to_latex (super, F-40) ..." unter Band-B "einplanbar nach der Landung" (Blockkopf Z.238).
  Der Umhaenge-Entwurf oben gilt unveraendert fuer BEIDE Stellen.
- Ledger-Wortlaut-Anker "in DENSELBEN Zug" heute bei **:1459** (Ledger auf 32387 Z. gewachsen;
  Anker ist der WORTLAUT, nie die Zeilennummer).

### A-2-Frische (VERTAGT-Platz traegt weiter)

- Eigene Zaehlung am Objekt HEUTE: `git show 1d38263b:libs/cache_engine/include/cache_engine/
  measurement/pmc_raw_event_katalog.hpp | grep -n 'static_assert('` = **COUNT=7**
  (:95/:96/:98/:100 positive Zen5-Pins: vorhanden / l2.config==0x964 / coherence.config==0x1443 /
  beide type==PERF_TYPE_RAW; :103/:105/:107 Negativ-Pins: family-25 leer / GenuineIntel leer /
  ""/0 leer fail-closed).
- Die falsche 6 steht unveraendert am Ist-Traeger: SB Z.175 literal "... ALLE anderen Modelle leer
  (fail-closed, kein Rateversuch; 6 static_asserts)." (heute per `sed -n '175p'`).
- Zahl weiterhin in KEINEN Ledger-Zug gereist: `grep -cE 'pmc_raw_event_katalog|RAW 0x964|0x964'`
  ueber den GESAMTEN Ledger (32387 Z.; Kopf traegt inzwischen "NACHTRAG zu KON120-02, 22.08.2026
  nachmittags") = **0 Treffer**; einziger `6 static_assert`-Treffer bleibt die C-3-best_binary-Zeile
  (heute :1468 — ANDERER Gegenstand). Praeventive Korrektur bleibt moeglich. Platz praezise (gemaess
  R2-Anmerkung zum Schlusssatz-Etikett): **Lead-only-Ledger-Zug AN der W2-Landung (KON-Nummer folgt;
  KON120 ist fuer die Owner-Tranchen verbraucht)** + Board-#82-Text im selben Lead-Zug — ENTWUERFE
  oben woertlich uebernehmbar.

### QUITTUNGEN (unveraendert, heute neu belegt)

- **A-1: VERTAGT** — Platz: W2-Lande-Zug, super-Lande-Phase; der Gitlink-Bump-Commit-Zug traegt
  `np34-csv-to-latex-umschrift.patch` IM SELBEN Zug (Patch heute am aktuellen super-HEAD 38428099
  erneut als anwendbar + wirksam bewiesen); F-40-Umhaengung an BEIDEN S1-Stellen (Z.99 + Z.247).
- **A-2: VERTAGT** — Platz: Lead-only-Ledger-Zug AN der W2-Landung (KON-Nummer folgt) +
  Board-#82-Textkorrektur; Zahl bis heute in keinem Ledger-Zug (0-Treffer-Messung oben).

Vollzaehligkeits-Gate: 2/2 Fund-IDs quittiert (Gegenzaehlung an der Audit-Fundmenge A-1+A-2, 0 ERNST).
Objekt-Endstand dieser Wiederausgabe: `bau/pmcpaket` @ 1d38263b017ff8aa3126650a41b208b0c8795a90
(HEAD==origin, porcelain 0, 0 neue Commits).

Ende Wiederanlauf-Nachtrag 23.08.
