# AUDIT RUNDE 2 (RE-VERIFY) — Strang pmcpaket (#82 I-PMC-2/3 + #83 PMC-fail-loud)

Pruefer: Fable-max-RE-VERIFY Runde 1 (W2-Audit-Fix-Verify, 22.08.2026). Objekt: ce `bau/pmcpaket` @
**1d38263b** (unveraendert; Fix-Runde 1 erzeugte 0 Commits). Eingang VOLL gelesen: soll-karte.md
(203 Z.), audit-runde-1.md (312 Z.), fix-runde-1.md (192 Z.). ALLE nachstehenden Belege sind EIGENE
Messungen dieser Runde (Kommandos am Objekt bzw. an /tmp-Wegwerf-Kopien), KEINE Abschriften.

## DECKUNGS-ERKLAERUNG (EIN gruenes Gate deckt nur seinen Gegenstand — BEIDE Mengen)

**Von dieser Runde SELBST gemessen (Literale unten):** Objekt-Unveraendertheit (HEAD/porcelain/
origin-Ref); Patch-Artefakt (Existenz, sha256, 73 Z.); Patch-ANWENDUNG an /tmp-Kopie des super-HEAD
657003bb inkl. Wirkungs- und Hygiene-Messung; alle A-1-/A-2-Eigenbelege der Fix-Stufe (Ledger-Wortlaut,
Ledger-0-Treffer, KON120-Verbrauch, S1-Doppel-Fehlplatzierung, EN-Zwilling, 7-static_assert-Zaehlung,
SB-Z.175- und Board-#82-Literal); Code-Stichproben P-01/P-02/P-03/P-04 am Tip; TABU-Gegenprobe;
offizielle Diff-Hygiene-Wache (GUARD_RC=0); clang-format-22-Stichprobe 5 Dateien; Commit-Trailer;
super-Hauptklon-Unberuehrtheit der csv_to_latex.cpp.
**NICHT von dieser Runde gedeckt (Traeger unveraendert):** Compile-/ctest-Gruenheit am Tip — Traeger
bleibt das SB-Literal (Zweitlauf `100% tests passed, 0 tests failed out of 512`, CTEST_RC=0) plus der
K17-4-Zellen-Kombibau des Lande-Zugs am gemergten Endstand. Grund: das Objekt ist byte-identisch zum
vom Strang gebauten Stand (0 Commits seit dem Beleg), im Worktree existiert kein Build-Verzeichnis mehr
(`ls build*` leer, binaryDir-Konvention `build/<preset>` geprueft), und ein Vollbau wiederholte NUR die
bereits literal belegte gcc-Release-Zelle — bei Belegung eines der 3 geteilten Bau-Slots gegen den
laufenden W1L-Kombibau (#113) ohne jeden Deckungsgewinn (identische Abwaegung wie Audit R1 und Fix R1;
Soll-Karte P-16 weist die 3 Restzellen ausdruecklich dem Lande-Zug zu). Es wird KEIN neuer Bau-Erfolg
behauptet.

## (1) BEHOBEN-QUITTUNGEN

**Keine vorhanden.** Fix-Runde 1 quittiert beide Funde als VERTAGT (0 BEHOBEN); es gibt keine
Behoben-Behauptung, die nachzumessen waere. Die Fundmenge des Audits (A-1 MILD + A-2 KLEIN, 0 ERNST)
ist 2/2 quittiert — Vollzaehligkeit gegengezaehlt am audit-runde-1-Verdikt.

## (2) VERTAGT-QUITTUNGEN — Traeger/Platz je Fund am Objekt geprueft

### A-1 (MILD, NP-34 "in DENSELBEN Zug") — VERTAGT-Quittung TRAEGT

Platz laut Fix-Stufe: W2-Lande-Zug, super-Lande-Phase (der Gitlink-Bump-Commit-Zug selbst); Traeger
Lead/Lande-Zug. Von dieser Runde verifiziert:

1. **Traeger existiert real:** Der W2-Lande-Zug ist als eigener Prozessschritt verankert (Board #108:
   "LANDE-ZUG = eigener Fable-max-Zug nach Design TEIL 3 ... Ledger KON120 AN die Landung"; S1-Phasen-
   plan). Der Platz liegt VOR/IN der Landung — kein Tragen ueber eine Landung hinweg (Doktrin-konform).
2. **Struktur-Begruendung stichhaltig, selbst nachvollzogen:** `git diff --name-only 66de5c09..1d38263b`
   = 16 Dateien, ausnahmslos `libs/` + `tests/unit/` (0 super-Pfade); die zu aendernde Datei liegt im
   super-Repo. Ein vorgezogener separater super-Commit verfehlte "DENSELBEN Zug" erneut, weil der zu
   bumpende ce-Endstand erst im Lande-Zug entsteht. Der Fix KANN strukturell erst dort vollzogen werden.
3. **Vorlage ist anwendungsreif — von dieser Runde UNABHAENGIG BEWIESEN (eigene Wegwerf-Anwendung):**
   - Artefakt existiert: `np34-csv-to-latex-umschrift.patch`, **73 Zeilen**, sha256
     `60fa5504bcaddc09185e342e19c5cc92aaca17c51e2857d8cc6b8217e93eedab` (== Fix-Bericht, selbst gehasht).
   - Anwendung an frischer /tmp-Kopie von `git show HEAD:Code/04_csv_to_latex/csv_to_latex.cpp`
     (super-HEAD **657003bb**, Branch development): `patch -p1 --dry-run` => "checking file ..."
     **DRYRUN_RC=0**; echte Anwendung => "patching file ..." **APPLY_RC=0**. (Erste eigene Probe mit
     falscher a/-Verzeichnisstruktur schlug fehl — Bedienfehler dieser Runde, nicht des Patches;
     nach Strukturkorrektur sauber.)
   - Wirkung an der gepatchten Kopie: **STRUKTURELL0_REST=0** (vorher 4), **RAW964=4 RAW1443=4**
     (je Headline+Body in DE und EN) — exakt die Fix-Literale.
   - Hygiene am Patch: 32 `+`-Zeilen, **MAXLEN_NEU=112** (<=120), **NICHTASCII_NEU=0**.
4. **Beide Fehl-Platzierungs-Stellen real (Zusatzbefund der Fix-Stufe bestaetigt):** S1-SYNTHESE Z.247
   fuehrt "NP-34 csv_to_latex (super, F-40)" unter "**Folgepakete:**" (Block "einplanbar nach der
   Landung", Z.238) UND Z.99 unter "Phase 4 — Nachlanden": "... NP-34-super-Umschrieb ..." — beide
   heute per `sed -n` selbst zitiert. Beide muessen in die super-Lande-Phase (Phase 2) umgehaengt werden.
5. **EN-Zwilling real (Zusatzbefund bestaetigt):** `grep -n 'strukturell 0\|structurally 0'` am
   super-Hauptklon = genau **4 Treffer in 2 Rows** — DE :987/:995 (Row :986-999) **und EN :1082/:1089
   (Row :1081-1094)**. Der Patch deckt beide Rows (Hunks @@984 + @@1079, selbst gelesen).
6. **Ledger-Wortlaut-Anker haelt:** `grep -n "DENSELBEN Zug"` im Ledger => **:1363** (nach
   KON120-Wachstum; Fix-Bericht sagte "~:1363" — deckungsgleich; Anker ist der Wortlaut, nie die Zeile).

### A-2 (KLEIN, "6 static_asserts" vs. 7) — VERTAGT-Quittung TRAEGT

Platz laut Fix-Stufe: Lead-only-Ledger-Zug AN der W2-Landung (Einpflege der pmc-Entwurfszeilen,
S1-Phase-4 "Ledger-Entwuerfe einpflegen ... pmc 2") + Board-#82-Textkorrektur im selben Lead-Zug.
Von dieser Runde verifiziert:

1. **Eigene Zaehlung am Objekt:** `git show 1d38263b:libs/.../measurement/pmc_raw_event_katalog.hpp |
   grep -n 'static_assert('` = **7 Treffer**, Zeilen **:95 :96 :98 :100** (4 positive Zen5-Pins:
   vorhanden / l2.config==0x964 / coherence.config==0x1443 / beide type==PERF_TYPE_RAW) + **:103 :105
   :107** (3 Negativ-Pins: family-25 leer / GenuineIntel leer / ""/0 leer fail-closed). COUNT=7 —
   identisch mit Audit- und Fix-Zaehlung, unabhaengig erhoben.
2. **Die falsche 6 an BEIDEN Ist-Traegern heute gemessen:** SB Z.175 literal "... (fail-closed, kein
   Rateversuch; 6 static_asserts)." (per `sed -n '175p'`); Board-Task #82 traegt literal "fremde
   Modelle ehrlich leer (fail-closed, 6 static_asserts)" (Task-Liste heute gelesen).
3. **Zahl ist noch in KEINEN Ledger-Zug gereist (praeventive Korrektur moeglich):** `grep -cE
   'pmc_raw_event_katalog|RAW 0x964|0x964'` ueber den GESAMTEN Ledger = **TREFFER=0**; Ledger-Kopf Z.19
   = "KON120 (22.08.2026 frueh) — OWNER-ANTWORTEN TRANCHE 1+2 ..." (Datei **32272 Z.**) — KON120 ist
   fuer die Owner-Tranchen verbraucht und traegt die pmcpaket-Zeilen nicht. Die Fix-Praezisierung
   (Korrektur-Ort = SPAETERES Lande-KON, nicht das verbrauchte KON120) ist am Objekt richtig.
4. **TABU-Konformitaet der Fix-Stufe:** Ledger/Board sind Lead-only — der Vollzug war der Fix-Stufe per
   Order unmoeglich; der ENTWURF (Board-Text + Ledger-Zeile) liegt woertlich uebernehmbar in
   fix-runde-1.md. Richtung des Fehlers guenstig (7 am Objekt > 6 behauptet), kein Code-Delta.

**Anmerkung (kein Fund):** Der Schlusssatz der fix-runde-1.md nennt den A-2-Vollzugsort verkuerzt
"KON120-Ledger-Zug", obwohl der eigene Fliesstext praezise erklaert, dass KON120 verbraucht ist und die
Korrektur im Lande-KON mit SPAETERER Nummer reist. Der Platz ist im QUITTUNG-Absatz eindeutig benannt —
das Etikett im Schlusssatz ist unschaedlich, die Synthese sollte den Ort als "Lede-only-Ledger-Zug AN
der W2-Landung (KON-Nummer folgt)" fuehren.

## (3) REGRESSIONS-PRUEFUNG — kein Delta, keine Regression

- **Objekt unveraendert (eigene Messung):** Worktree `/home/comdare/wt-ce-pmcpaket` HEAD =
  `1d38263b017ff8aa3126650a41b208b0c8795a90`, **PORCELAIN=0**; `git ls-remote origin
  refs/heads/bau/pmcpaket` = `1d38263b...` — HEAD==origin==Audit-Tip. 0 Commits, 0 Pushes seit
  Audit R1; es existiert keine Code-Aenderung, die eine Regression tragen koennte.
- **super-Hauptklon unberuehrt:** `git status --porcelain -- Code/04_csv_to_latex/csv_to_latex.cpp`
  leer (RC=0), `git diff HEAD --stat` an der Datei leer — die NP-34-Vorlage wurde NICHT vorzeitig
  angewandt (die 4 "strukturell 0"-Treffer stehen dort korrekt noch, Vollzug gehoert in den Lande-Zug);
  die Patch-Konstruktion dieser Runde lief vollstaendig in /tmp (danach aufgeraeumt).
- **Format-Stichprobe:** `~/.local/bin/clang-format-22 --dry-run -Werror` ueber 5 geaenderte Dateien
  (pmc_startup_pruefung.hpp, pmc_raw_event_katalog.hpp, cache_engine_builder_iterator.hpp,
  test_pmc_startup_pruefung.cpp, test_pmc_raw_event_katalog.cpp) = **5/5 OK, RC=0**.
- **Offizielle Diff-Hygiene-Wache selbst gefahren:** `sh scripts/ci_diff_ascii_width_guard.sh
  66de5c09..1d38263b` => "927 Zusatzzeilen ... geprueft, davon 0 Nicht-ASCII, davon 0 ueber 120
  Spalten. ... DIFF-HYGIENE-WACHE: GRUEN." **GUARD_RC=0**.
- **TABU-Gegenprobe selbst gefahren:** name-only-Diff gegen
  `golden_fullpilot|permutation_axes|m3v2_study|axes/|topics/|heuristik/|\.gitlab-ci\.yml|registry.*\.xml`
  = 0 Treffer, **TABU_GREP_RC=1**; 16 Dateien ausnahmslos libs/ + tests/unit/.

## (4) RESTLISTE GEGEN DIE SOLL-KARTE (P-01..P-24)

Das Objekt ist byte-identisch zum von Audit R1 vollstaendig gepruefeten Stand; zusaetzlich hat diese
Runde die Kernpunkte eigenstaendig stichprobiert:

- **P-01 bestaetigt:** `ceb_pmc_compile_define` Definition :359 (+ fail-closed `Unbrauchbar => {}`
  :360), clang-Zwilling :423, Emissionen :1086/:1132/:1470/:1667 (4+1) — eigene grep-Messung am Tip.
- **P-02 bestaetigt:** Director :1705-1710 literal — `if (header_.pmc_befund.lage ==
  PmcLage::Unbrauchbar)` => `[PMC-TESTAT] ... pmc=FEHLER grund=pmc_quelle_nicht_gebaut ...` +
  `s += "      exit 1\n";` VOR jeder Messung; else-Zweig baut die Smokes.
- **P-03 bestaetigt:** Iterator :1032 `} else if (!source_available) {` — das available-Gate ist weg.
- **P-04 bestaetigt:** `builder/pmc_startup_pruefung.hpp` = **186 Zeilen**; vier Lagen :66-69, genau
  zwei Warn-Lagen (:75), Nenner-Zeile `host_biss=` :150.
- **P-18/P-19/P-21 von dieser Runde reproduziert** (s. Abschnitt 3; Trailer: `git log -1 --format=%B
  1d38263b` endet literal `Co-Authored-By: Claude Fable 5 <noreply@anthropic.com>`).
- **P-05..P-09, P-11..P-17, P-20, P-22/P-23:** unveraendert wie in Audit R1 am selben Bytestand belegt
  (P-16-Restzellen per Soll-Karten-Weisung Lande-Zug; P-11/W1-FATAL-Flip = F-41 Folgepaket,
  Board-#83-REST heute gegengelesen).
- **P-10:** = Fund A-1, VERTAGT mit geprueftem Traeger (Abschnitt 2).
- **P-24:** OFFEN-fristgerecht (Branch LANDEREIF, Board #82/#83 pending heute gelesen; Frist
  Mi 26.08. 06:00 nicht erreicht; Landung = W2-Lande-Zug).

**Getragene offene Posten unveraendert bei ihren Traegern:** F-39 (Intel-RAW nach Intel-Kreuzprobe) ·
F-40 (= A-1, Traeger geprueft) · F-41 (W1-FATAL-Flip, super-Nachzug-Fenster, im Code verdrahtet) ·
F-42 (Uncore-Rechte, Infra) · Lande-Zug-Pflichten (K17-Kombibau am Merge-Stand, H-3/H-9/H-10,
E-1-Frist, optionaler super-Grep, Thesis-Anhang-Nachzug).

## WEITERREICHUNGS-PFLICHTEN AN DIE SYNTHESE (damit die VERTAGT-Plaetze nicht verfallen)

1. **A-1:** Der W2-Lande-Zug MUSS den super-Gitlink-Bump ueber den pmcpaket-tragenden ce-Endstand IM
   SELBEN Commit-Zug mit `np34-csv-to-latex-umschrift.patch` fahren (beide Rows DE+EN; Patch geprueft
   anwendbar auf super-HEAD 657003bb — bewegt sich super vorher, Patch-Match erneut pruefen) und die
   S1-Platzierung an BEIDEN Stellen (Z.99 Phase-4 + Z.247 Folgepakete) auf die super-Lande-Phase
   umhaengen. Ohne dies tritt beim Landen exakt der vom Ledger verbotene Auseinanderlauf ein.
2. **A-2:** Im Lead-Ledger-Zug AN der Landung (KON-Nummer folgt; KON120 ist verbraucht) die beiden
   pmc-Entwurfszeilen mit **7** static_asserts einpflegen + Board-#82-Text korrigieren (woertliche
   ENTWUERFE liegen in fix-runde-1.md).

## VERDIKT

**SITZT.** 0 BEHOBEN-Quittungen (nichts nachzumessen), 2/2 VERTAGT-Quittungen mit real existierenden,
am Objekt geprueften Traegern/Plaetzen und anwendungsreifen, von dieser Runde unabhaengig bewiesenen
Vorlagen; 0 neue Regressionen (0 Commits, Objekt byte-identisch, Format-/Hygiene-/TABU-Gates
eigenstaendig gruen reproduziert); Restliste deckungsgleich mit der Soll-Karte (nur fristgerechte
Lande-/Lead-Posten mit Traegern). Keine neuen Funde. Die Fix-Verify-Schleife fuer den Strang pmcpaket
ist damit geschlossen; alles Weitere liegt beim W2-Lande-Zug/Lead (Weiterreichungs-Pflichten oben).

Ende audit-runde-2 pmcpaket.

---

## WIEDERANLAUF-NACHTRAG (23.08.2026) — Stufe erneut ausgegeben; Verdikt SITZT BESTAETIGT mit heutigen Eigen-Messungen

Anlass: Die RE-VERIFY-Stufe wurde nach Workflow-Resume (Owner-Pause 23.08., super-Commit 38428099
"ABBRUCHSICHERE PAUSE") erneut ausgegeben. Auf Platte lagen dieser Bericht (22.08., oben —
UNVERAENDERT belassen, dieser Nachtrag ist ADDITIV) und der Fix-Bericht MIT Wiederanlauf-Nachtrag
vom 23.08. 13:56 (super-Bewegung 657003bb -> 38428099, Patch dort erneut bewiesen). Diese
Wiederausgabe hat ALLE Quittungen am heutigen Objekt-Stand NEU gemessen (keine Abschriften) und ein
wesentliches LAGE-UPDATE erhoben: der W2-Lande-Zug ist inzwischen ce-seitig GELAUFEN.

### (1) BEHOBEN-Quittungen — unveraendert keine

Fix-Runde 1 (inkl. Nachtrag 23.08.) quittiert weiterhin 2/2 VERTAGT, 0 BEHOBEN, 0 Commits.
Gegenzaehlung an der Audit-Fundmenge (A-1 MILD + A-2 KLEIN, 0 ERNST): 2/2 quittiert, vollzaehlig.

### (2) VERTAGT-Plaetze — beide tragen; A-1 ist durch die Lande-Lage AKUT geworden

**Objekt-Zustand (eigene Messung heute):** Worktree `/home/comdare/wt-ce-pmcpaket`:
`HEAD=1d38263b017ff8aa3126650a41b208b0c8795a90`, Branch `bau/pmcpaket`, `PORCELAIN_LINES=0`;
`git ls-remote origin refs/heads/bau/pmcpaket` = `1d38263b...` — HEAD==origin==Audit-Tip, weiterhin
0 Commits/0 Pushes seit Audit R1. Trailer-Literal am Commit erneut gesehen
(`Co-Authored-By: Claude Fable 5 <noreply@anthropic.com>`).

**LAGE-UPDATE (neu gegenueber allen Eingangs-Dokumenten):** `git merge-base --is-ancestor 1d38263b
origin/development` im ce = **RC=0** — `bau/pmcpaket` ist in ce `development` GEMERGT: Merge-Commit
**9da4d21d** "merge(pmcpaket): W2-Lande-Zug 5/10 -- #82/#83 I-PMC-2/3 + PMC-fail-loud (bau/pmcpaket
@ 1d38263b; Audit r2 SITZT, 2/2 VERTAGT quittiert)"; die Lande-Kette lief bis **5ddda4e5**
"merge(W2-LANDE-ZUG ce-Endstand): lande/w2-s1s2 @ 53c5524e in development -- 10 Straenge +
Lande-Pflichten" (CE_DEV_TIP=b247a339). Der **super-Gitlink steht noch auf der ALT-Basis 66de5c09**
(`git ls-tree HEAD Code/external/comdare-cache-engine` am super = 66de5c09...) — der
Gitlink-Bump-Zug (= der A-1-VERTAGT-Platz) ist damit der UNMITTELBAR NAECHSTE super-Lande-Schritt.

**A-1 TRAEGT (heute vollstaendig neu bewiesen):**
1. Patch-Artefakt byte-identisch: sha256
   `60fa5504bcaddc09185e342e19c5cc92aaca17c51e2857d8cc6b8217e93eedab` (heute selbst gehasht).
2. **Patch beisst am HEUTIGEN super-Stand** (/tmp-Wegwerf-Kopie aus `git show
   HEAD:Code/04_csv_to_latex/csv_to_latex.cpp`, HEAD zum Probenzeitpunkt **6c5af357**):
   `git apply --check -p1` **GIT_APPLY_CHECK_RC=0**; `patch -p1 --dry-run` **DRYRUN_RC=0**; echte
   Anwendung **APPLY_RC=0**; Wirkung **STRUKTURELL0_VOR=4 -> STRUKTURELL0_REST=0**,
   **RAW964=4 RAW1443=4** (Headline+Body, DE+EN); Hygiene **MAXLEN_NEU=112, NICHTASCII_NEU=0**.
   /tmp geraeumt, super-Hauptklon unberuehrt. super wuchs WAEHREND der Pruefung weiter
   (6c5af357 -> **daa93fb8**, reiner docs-Commit; `git diff --name-only 6c5af357..daa93fb8` =
   1 Session-Datei, **CSV_IM_DELTA=0**) — die Probe deckt damit auch daa93fb8.
3. **Auseinanderlauf NOCH NICHT eingetreten:** csv_to_latex.cpp am super-Hauptklon unberuehrt
   (`git status --porcelain` an der Datei leer; 4 Marker `strukturell 0|structurally 0` an
   :987/:995 DE + :1082/:1089 EN stehen korrekt) UND der super-Baum referenziert das
   pmcpaket-ce noch nicht (Gitlink 66de5c09) — Textaussage und Messvermoegen des super-Standes
   sind HEUTE noch konsistent. Das Ledger-Gebot bleibt einhaltbar GENAU DANN, wenn der kommende
   Bump-Zug den Patch im selben Commit-Zug traegt.
4. Beide S1-Fehl-Platzierungs-Stellen stehen unveraendert (heute per `sed`/`grep` zitiert):
   S1 Z.99 "NP-34-super-Umschrieb" (Phase 4 — Nachlanden) und Z.247-248 "Folgepakete: ... NP-34
   csv_to_latex (super, F-40)" unter Blockkopf Z.238 "einplanbar nach der Landung" — die
   Umhaenge-Pflicht in die super-Lande-Phase gilt unveraendert und ist jetzt DRINGLICH.
5. Ledger-Wortlaut-Anker "in DENSELBEN Zug" heute bei **:1459** (Ledger 32387 Z.) — Anker ist der
   Wortlaut, nie die Zeile.

**A-2 TRAEGT (heute neu gemessen):**
1. Eigene Zaehlung am Objekt: `git show 1d38263b:libs/.../measurement/pmc_raw_event_katalog.hpp |
   grep -n 'static_assert('` = **COUNT=7** an **:95 :96 :98 :100** (positive Zen5-Pins) +
   **:103 :105 :107** (Negativ-Pins) — identisch mit Audit/Fix, unabhaengig erhoben.
2. Die falsche 6 steht unveraendert am Ist-Traeger: SB Z.175 literal "... (fail-closed, kein
   Rateversuch; 6 static_asserts)." (heute per `sed -n '175p'`).
3. Zahl weiterhin in KEINEN Ledger-Zug gereist: `grep -cE 'pmc_raw_event_katalog|RAW 0x964|0x964'`
   ueber den GESAMTEN Ledger (32387 Z.) = **0 Treffer**; einziger `6 static_assert`-Treffer bleibt
   :1468 = C-3-best_binary (ANDERER Gegenstand). Ledger-Kopf traegt "NACHTRAG zu KON120-02
   (22.08.2026 nachmittags)" — KON120 verbraucht, das Lande-KON hat noch KEINE Nummer: die
   praeventive Korrektur im Lead-Ledger-Zug AN der Landung bleibt exakt wie quittiert moeglich.

### (3) Regressionen — keine (heute eigenstaendig reproduziert)

0 Commits am Strang (byte-identisches Objekt, s.o.) — es existiert kein Code-Delta, das eine
Regression tragen koennte. Zusaetzlich heute gefahren: TABU-Gegenprobe (name-only-Diff gegen
golden/axes/topics/heuristik/YAML/registry-Muster) = 0 Treffer, **TABU_GREP_RC=1**, 16 Dateien
ausnahmslos libs/ + tests/unit/; `~/.local/bin/clang-format-22 --dry-run -Werror` ueber ALLE 15
Code-Dateien des Diffs (echte Pfade aus name-only) = **FORMAT_FAILS=0 von 15**; offizielle Wache
`sh scripts/ci_diff_ascii_width_guard.sh 66de5c09..1d38263b` = "DIFF-HYGIENE-WACHE: GRUEN.",
**GUARD_RC=0**. (Protokoll-Transparenz: ein ERSTER Format-Durchlauf dieser Runde meldete 2 FAILS —
Ursache waren ZWEI von mir GERATENE, nicht existente Pfade bei verschlucktem stderr; nach Holen der
echten Diff-Pfade 0/15. Bedienfehler dieser Runde, kein Objekt-Befund.)

### (4) Restliste gegen die Soll-Karte — deckungsgleich, ein Status-Fortschritt

Objekt byte-identisch zu R1/R2 -> P-01..P-23-Urteile tragen unveraendert. **P-24/E-1
Status-Fortschritt:** die ce-Haelfte der Landung ist VOLLZOGEN (Merge 9da4d21d, 5/10 der
Lande-Kette; VOR der Frist Mi 26.08. 06:00); AUSSTEHEND beim laufenden Lande-Zug: super-Gitlink-Bump
(traegt A-1-Patch im selben Zug), K17-Kombibau am gemergten Endstand, H-Endstand-Wachen. Getragene
Posten F-39 (Intel-RAW) / F-41 (W1-FATAL-Flip, super-Nachzug-Fenster) / F-42 (Uncore-Rechte)
unveraendert bei ihren Traegern.

### WEITERREICHUNG (aktualisiert — A-1 ist AKUT)

1. **A-1 AKUT:** Der naechste super-Zug, der den ce-Gitlink von 66de5c09 auf den
   pmcpaket-tragenden ce-Endstand (Linie 9da4d21d..5ddda4e5, CE_DEV_TIP b247a339) bumpt, MUSS
   `np34-csv-to-latex-umschrift.patch` IM SELBEN Commit-Zug tragen (beide Rows DE+EN) und die
   S1-Platzierung an BEIDEN Stellen (Z.99 + Z.247) umhaengen. Patch-Match ist fuer super
   daa93fb8 bewiesen; bewegt sich super vor dem Bump weiter, Match-Probe erneut fahren
   (Sekunden-Aufwand, Rezept im Fix-Bericht).
2. **A-2:** unveraendert — Lead-Ledger-Zug AN der Landung (KON-Nummer folgt) + Board-#82-Text;
   ENTWUERFE woertlich in fix-runde-1.md.

### VERDIKT (Wiederanlauf): **SITZT** — bestaetigt

0 BEHOBEN (nichts nachzumessen), 2/2 VERTAGT mit real existierenden, heute NEU am Objekt geprueften
Plaetzen (A-1 durch die fortgeschrittene ce-Landung akut, Vorlage frisch bewiesen; A-2 praeventiv
weiter moeglich, 0 Ledger-Reisen), 0 Regressionen (byte-identisches Objekt + Gates heute gruen
reproduziert), Restliste deckungsgleich mit der Soll-Karte (P-24 ce-Haelfte inzwischen erfuellt,
Rest fristgerecht beim laufenden Lande-Zug). Keine neuen Funde.

Ende Wiederanlauf-Nachtrag 23.08. audit-runde-2 pmcpaket.

---

## ZWEITER WIEDERANLAUF-NACHTRAG (23.08.2026, spaet) — Stufe erneut ausgegeben; Verdikt SITZT ERNEUT BESTAETIGT, alle Quittungen heute frisch gemessen

Anlass: Die RE-VERIFY-Stufe wurde nach erneutem Workflow-Resume nochmals ausgegeben. Auf Platte lagen
dieser Bericht (22.08. + Nachtrag 23.08. 14:04) und der Fix-Bericht MIT Wiederanlauf-Nachtrag
(23.08. 13:56); alle drei Eingaenge (soll-karte 203 Z., audit-runde-1 312 Z., fix-runde-1 261 Z.)
VOLL gelesen. Bestand UNVERAENDERT belassen; dieser Nachtrag ist ADDITIV. ALLE nachstehenden Zahlen
sind EIGENE Messungen dieser Wiederausgabe (keine Abschriften aus Fix-Bericht oder frueherem R2).

### DECKUNG (BEIDE Mengen)

**Selbst gemessen heute:** ce-Objekt (HEAD/porcelain/origin-Ref/Trailer), Merge-Lage (Ancestor-Probe,
Merge-Commits, dev-Tip), static_assert-Zaehlung, super-Lage (HEAD, Gitlink, csv_to_latex-Marker,
porcelain), Patch-Vollprobe an /tmp-Kopie des HEUTIGEN super-HEAD, S1-/SB-/Ledger-Literale,
TABU-Gegenprobe, clang-format 15 Dateien, offizielle Diff-Hygiene-Wache, P-01..P-04-Code-Stichproben
am Tip UND am dev-Tip, F-41-Verdrahtung, dev-Nachlauf-Regressionspruefung.
**NICHT von dieser Runde gedeckt (Traeger unveraendert):** Compile-/ctest-Gruenheit (Traeger:
SB-Literal `100% tests passed, 0 tests failed out of 512` + K17-4-Zellen-Kombibau des Lande-Zugs am
Merge-Endstand; byte-identisches Objekt, kein Bau-Slot belegt); Live-Board-Lesung (#82/#83) — Ersatz:
gesicherter Transkript-Beweis des TaskUpdate-Calls 21.08. 08:28Z mit dem woertlichen #82-Text
"... fremde Modelle ehrlich leer (fail-closed, 6 static_asserts) ..."
(`/home/comdare/backups-workflow/20260823-rueckfragen-vollbild/A51-arbeit/fenster.jsonl:844`).

### (1) BEHOBEN-Quittungen — unveraendert keine

Fix-Runde 1 (inkl. Nachtrag) quittiert 2/2 VERTAGT, 0 BEHOBEN, 0 Commits. Gegenzaehlung an der
Audit-Fundmenge (A-1 MILD + A-2 KLEIN, 0 ERNST): 2/2, vollzaehlig. Objekt byte-identisch (eigene
Messung): Worktree `/home/comdare/wt-ce-pmcpaket` HEAD =
`1d38263b017ff8aa3126650a41b208b0c8795a90`, Branch `bau/pmcpaket`, PORCELAIN_LINES=0;
`git ls-remote origin refs/heads/bau/pmcpaket` = `1d38263b...`; `git log -1 --format=%B 1d38263b`
endet literal `Co-Authored-By: Claude Fable 5 <noreply@anthropic.com>`.

### (2) VERTAGT-Plaetze — beide tragen; A-1 bleibt AKUT (Bump steht weiter aus)

**Lande-Lage heute (eigene Messung):** `git merge-base --is-ancestor 1d38263b origin/development`
RC=0; Merge `9da4d21d merge(pmcpaket): W2-Lande-Zug 5/10 ...` und Endstand `5ddda4e5
merge(W2-LANDE-ZUG ce-Endstand): lande/w2-s1s2 @ 53c5524e ...` existieren; ce dev-Tip HEUTE =
**3841d717** (Nachlauf nach b247a339, s. Abschnitt 3). super HEAD HEUTE = **cb38cc9f**
(development; erneut gewachsen seit daa93fb8/38428099); **Gitlink steht WEITER auf 66de5c09**
(`git ls-tree HEAD Code/external/comdare-cache-engine` = 66de5c09...) — der A-1-Platz
(Gitlink-Bump-Zug) liegt weiterhin VOR uns, der Auseinanderlauf ist NICHT eingetreten.

**A-1 TRAEGT (heute vollstaendig neu bewiesen):**
1. Patch byte-identisch: sha256 `60fa5504bcaddc09185e342e19c5cc92aaca17c51e2857d8cc6b8217e93eedab`,
   73 Z. (selbst gehasht/gezaehlt).
2. **Patch beisst am HEUTIGEN super-HEAD cb38cc9f** (/tmp-Wegwerf-Kopie aus `git show
   cb38cc9f:Code/04_csv_to_latex/csv_to_latex.cpp`): `git apply --check -p1` **RC=0**;
   `patch -p1 --dry-run` **RC=0**; echte Anwendung **APPLY_RC=0**; Wirkung
   **STRUKTURELL0_VOR=4 -> STRUKTURELL0_REST=0**, **RAW964=4 RAW1443=4**; Hygiene der 32
   `+`-Zeilen: **NICHTASCII_NEU=0**, **MAXLEN_NEU=112** (<=120); Datei-Gesamtprobe nach Patch:
   0 Zeilen ueber 120. /tmp geraeumt, super-Hauptklon unberuehrt (porcelain an der Datei = 0;
   4 Marker stehen an :987/:995 DE + :1082/:1089 EN, heute selbst gegrept).
3. Beide S1-Fehl-Platzierungs-Stellen stehen unveraendert (heute per `sed` zitiert): Z.99
   "NP-34-super-Umschrieb" (Phase 4 — Nachlanden) und Z.247-248 "**Folgepakete:** ... NP-34
   csv_to_latex (super, F-40) ..." unter Blockkopf Z.238 "einplanbar nach der Landung".
4. Ledger-Wortlaut-Anker "in DENSELBEN Zug" heute **:1459** (Ledger 32387 Z.).

**A-2 TRAEGT (heute neu gemessen):**
1. Eigene Zaehlung: `git show 1d38263b:libs/cache_engine/include/cache_engine/measurement/
   pmc_raw_event_katalog.hpp | grep -c 'static_assert('` = **7**, an **:95 :96 :98 :100** +
   **:103 :105 :107** — identisch mit Audit/Fix/R2, unabhaengig erhoben.
2. Falsche 6 am Ist-Traeger: SB Z.175 literal "... ALLE anderen Modelle leer (fail-closed, kein
   Rateversuch; 6 static_asserts)." (heute per `sed -n '175p'`); Board-#82-Text per gesichertem
   Transkript-Beweis (s. Deckung).
3. Zahl weiterhin in KEINEN Ledger-Zug gereist: `grep -cE 'pmc_raw_event_katalog|RAW 0x964|0x964'`
   ueber den GESAMTEN Ledger (32387 Z.) = **0**; einziger `6 static_assert`-Treffer **:1468** =
   C-3-best_binary (ANDERER Gegenstand); Ledger-Kopf = "NACHTRAG zu KON120-02 (22.08.2026
   nachmittags)" — das Lande-KON hat noch keine Nummer, die praeventive Korrektur bleibt exakt wie
   quittiert moeglich.

### (3) Regressionen — keine; dev-Nachlauf gesondert geprueft (NEU in dieser Wiederausgabe)

0 Commits durch die Fix-Stufe (byte-identisches Objekt) — es existiert kein Fix-Delta, das eine
Regression tragen koennte. Gates heute eigenstaendig reproduziert: TABU-Gegenprobe = 0 Treffer,
**TABU_GREP_RC=1** (16 Dateien: 9 libs/ + 7 tests/); `~/.local/bin/clang-format-22 --dry-run
-Werror` ueber die 15 Code-Dateien (echte Pfade aus name-only) = **FORMAT_FAILS=0 von 15**;
offizielle Wache `sh scripts/ci_diff_ascii_width_guard.sh 66de5c09..1d38263b` = "927 Zusatzzeilen
... 0 Nicht-ASCII ... DIFF-HYGIENE-WACHE: GRUEN.", **GUARD_RC=0**.
**NEU — dev-Nachlauf-Pruefung:** `5ddda4e5..origin/development` = 6 Commits (CI-16095-Heilung
Teile 1-4 + Anker-Nachzug 544/540/538). Schnittmenge mit den 16 pmcpaket-Dateien: **2 Dateien**
(Director + Director-Testdatei, beide via `3841d717` "Riegel-AUSWEIS ... Lead-Verschaerfung
23.08."). Am dev-Tip selbst gemessen: `ceb_pmc_compile_define` weiterhin 8 Treffer; der
FEHLER-Zweig lebt und ist ADDITIV VERSCHAERFT (`pmc=FEHLER grund=pmc_quelle_nicht_gebaut
befund_grund=` + fehlgrund-Ausweis, dev-Tip :1766; `exit 1` bleibt); Testdatei +28 Zeilen rein
additiv (0 Loeschungen); `TEST(PmcPflichtInvariante, ...)` x2 + `TEST(PmcFailLoud, ...)` stehen
(:3080/:3173/:3204). Die im Nachlauf neue Datei `tests/unit/support/pmc_stdout_maskierung.hpp`
ist Nachbar-Strang-Arbeit (vl3-Bytegleich-Riegel), kein pmcpaket-Gegenstand. **KEINE Regression —
die pmcpaket-Substanz wurde im Nachlauf verstaerkt, nicht geschwaecht.**

### (4) Restliste gegen die Soll-Karte — deckungsgleich

P-01..P-04 heute erneut am Tip stichprobiert: Definition :359 (+fail-closed :360 `Unbrauchbar =>
{}`), clang-Zwilling :423, Emissionen :1086/:1132/:1470/:1667 (Zusatztreffer :1081/:1127 sind
Kommentarzeilen); Unbrauchbar-Zweig :1705-1710 mit `[PMC-TESTAT] ... pmc=FEHLER
grund=pmc_quelle_nicht_gebaut` + `exit 1`; Iterator :1032 `} else if (!source_available) {`;
`pmc_startup_pruefung.hpp` 186 Z., vier Lagen :66-69, genau zwei Warn-Lagen :75, Nenner
`host_biss=` :150. P-11/F-41-Verdrahtung am Objekt gesehen (CMakeLists `message(WARNING` +
"NACH dem Super-Nachzug wird diese Warnung ein FATAL_ERROR." :121). P-18/P-19/P-21 reproduziert
(oben). P-24/E-1: ce-Haelfte GELANDET (9da4d21d, VOR der Frist Mi 26.08. 06:00); AUSSTEHEND beim
laufenden Lande-Zug: super-Gitlink-Bump (traegt A-1-Patch im selben Zug), K17-Kombibau am
Merge-Endstand, H-Endstand-Wachen. Getragene Posten F-39/F-41/F-42 unveraendert bei ihren Traegern.

### WEITERREICHUNG (unveraendert gueltig, heute erneut scharf)

1. **A-1 AKUT:** Der naechste super-Zug, der den ce-Gitlink von 66de5c09 auf den pmcpaket-tragenden
   ce-Endstand bumpt (Linie 9da4d21d..5ddda4e5; dev-Tip inzwischen 3841d717), MUSS
   `np34-csv-to-latex-umschrift.patch` IM SELBEN Commit-Zug tragen (beide Rows DE+EN) und die
   S1-Platzierung an BEIDEN Stellen (Z.99 + Z.247) umhaengen. Patch-Match ist fuer super
   **cb38cc9f** bewiesen; bewegt sich super vor dem Bump weiter, Match-Probe erneut fahren.
2. **A-2:** Lead-Ledger-Zug AN der Landung (KON-Nummer folgt; KON120 verbraucht) + Board-#82-Text
   auf **7 static_asserts**; woertliche ENTWUERFE in fix-runde-1.md.

### VERDIKT (zweiter Wiederanlauf): **SITZT** — erneut bestaetigt

0 BEHOBEN (nichts nachzumessen), 2/2 VERTAGT mit real existierenden, heute NEU am Objekt geprueften
Plaetzen und frisch bewiesener Vorlage (Patch beisst am heutigen super-HEAD cb38cc9f), 0
Regressionen (byte-identisches Objekt; Gates gruen reproduziert; dev-Nachlauf verstaerkt die
pmcpaket-Substanz additiv), Restliste deckungsgleich (P-24 ce-Haelfte erfuellt, Rest fristgerecht
beim laufenden Lande-Zug). Keine neuen Funde.

Ende zweiter Wiederanlauf-Nachtrag 23.08. audit-runde-2 pmcpaket.
