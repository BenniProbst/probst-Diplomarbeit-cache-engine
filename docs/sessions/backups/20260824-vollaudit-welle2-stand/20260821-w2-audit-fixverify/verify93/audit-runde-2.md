# AUDIT RUNDE 2 (RE-VERIFY nach Fix) -- verify93

Pruefer: Fable-max-KONVERGENZ-PRUEFER+FIXER, 2026-08-23.
Gegenstand dieser Runde: die beim Rundenbeginn OFFENEN Funde des Strangs verify93 --
V93-A1 [ERNST], V93-A2 [KLEIN] (beide Erstlauf) und K-1 [KLEIN] (Resume-Audit R1).
Objekte: (a) Doku-Deliverable ~/backups-workflow/20260820-w2-sofortstaffel/verify-93-ergebnis.md
(333 Z.), (b) ~/backups-workflow/20260820-w2-sofortstaffel/STAFFEL1-SYNTHESE.md (275 Z.),
(c) ce-Hauptklon NUR LESEND gegen 66de5c09 (git show/grep/ls-tree/log/merge-base/rev-list).
Kein Bau, kein Worktree, kein Branch (verify93 ist und bleibt ein Doku-/Read-only-Strang) ->
kein Bauslot belegt; df / = 16G frei (Gate 5G erfuellt); ce porcelain = 0 nach dieser Runde.
Voll gelesen: soll-karte.md (261 Z.), audit-runde-1.md (206 Z.), GEGENLESE-GATE.md (169 Z.),
SYNTHESE-S1-AUDIT.md (119 Z.), ERSTLAUF-ENDBERICHT verify93-Restfund-Block (Z.129-150),
verify-93-ergebnis.md (333 Z.), warnungs-review.md (voll),
20260822-parallel-heilung/verify93-g2/BEWEIS.md (135 Z.).

## 0. ERGEBNIS VORAB

**VERDIKT: SITZT NACH FIX** -- 3/3 offene Funde am Objekt BEHOBEN und von dieser Runde
EIGENSTAENDIG nachgemessen (nicht aus dem Fix-Beweis uebernommen); 0 ERNST, 0 MILD offen.
1 Restposten VERTAGT mit Lande-Auflage (V93-L1, s. Abschnitt 5) -- ein stale gewordener
Lead-Synthese-Halbsatz, kein Objekt-Defekt des Strangs.
Beide Mengen: Gedeckt sind GENAU die 3 offenen Funde + die Wachen (BU-additiv, ASCII,
fremder Nenner, Falsch-Null-Gegenproben). NICHT Gegenstand dieser Runde sind die 18
P-Punkte der C-9-Pruefliste selbst (in audit-runde-1 gedeckt, Beleglage dort haelt bis auf
P-01, s.u.) und die NICHT-GEFORDERT-Liste der Soll-Karte (Gruppen B/E/F/G/H, X-12-BAU,
clang-Review-LAUF, N5-Test-BAU, Wstringop-HAERTUNG).

## 1. WARUM RUNDE 2 NOETIG WAR (Chronologie, je mit Datei-Beleg)

1. **Erstlauf** (ERSTLAUF-ENDBERICHT-wpmgr02yo-voll.md Z.130-146): verify93 =
   `"endstatus": "FIX_AUSFALL", "runden": 1` mit den Restfunden V93-A1 [ERNST] + V93-A2
   [KLEIN]. Die Fix-Runde 1 starb am Credits-Riss: Z.32 `"[S1-fix1:verify93] failed:
   You've hit your session limit"` -- der Fix wurde NIE ausgefuehrt und hinterliess KEINE
   Runden-Datei im Strang-Ordner.
2. **Resume-Audit R1** (audit-runde-1.md, 22.08. 06:26) vergab **SITZT, 18/18 ERFUELLT**.
   Der P-01-Beleg dieses Audits war jedoch dieselbe Probe, die schon den Erstbericht
   verfuehrt hatte: `find ~/backups-workflow -newermt 2026-08-17 -iname "*clang*"`. Das ist
   eine **stille Falsch-Null**: der Treffer-Dateiname traegt kein "clang".
3. **GEGENLESE-GATE.md** (22.08. 12:04) hob das als **F-1 [ERNST-NAEHE]**: das
   clang-tragende Warnungs-Review-Artefakt existiert; Auflage G2 in SYNTHESE-S1-AUDIT.md
   Z.74-84 (5 Fix-Teile).
4. **G2-Vollzug** (22.08. 12:52, Beweis: 20260822-parallel-heilung/verify93-g2/BEWEIS.md):
   fuehrte die 5 Fix-Teile additiv aus. Diese Runde 2 ist der RE-VERIFY dazu.

**Konsequenz fuer audit-runde-1:** Das Verdikt SITZT bleibt in der SACHE stehen (Status
OFFEN und Traeger W2-2/#106 fuer N1/M-6 sind unveraendert richtig), aber der P-01-BELEG
ist gefallen und durch den korrigierten Beleg dieses Abschnitts ersetzt. Ein gruenes Gate
deckt nur seinen Gegenstand: audit-runde-1 deckt P-02..P-18 weiter, P-01 deckt ab hier
diese Runde.

## 2. RE-VERIFY JE FUND (jede Zahl in dieser Runde selbst gemessen)

### V93-A1 [ERNST] -- P-01/M-6-Gegenprobe falsch: das clang-Review EXISTIERT

**(a) Das Artefakt ist real.** ~/backups-workflow/20260820-nachhol-kombibau/warnungs-review.md,
6547 B, mtime 2026-08-20 11:10, Titelzeile woertlich:
`# WARNUNGS-REVIEW ZWEIMAL (gcc DANN clang) -- Nachhol-Kombibau-Endstand c2da9d1a`.
`grep -c -i clang` = **17**. Die clang-Haelfte IST gefahren: Abschnitt "Compiler 2: clang
(Clang 22.1.8) -- Beine clang-release + clang-debug" traegt
`clang-release-build.log: 2` + `clang-debug-build.log: 2` = **4 Warnungszeilen, 2
dedupliziert** (gtest-printers.h:524:35 [-Wcharacter-conversion] +
test_axis_kind_kategorien_zuordnung.cpp:77:53 [-Wunused-const-variable]), Bilanz-Tabelle
am Dateiende bestaetigt das je Bein. Der Erstberichts-Satz "kein clang-Warnungs-Review-
Artefakt nach 17.08." ist damit objektiv falsch -- Fund BESTAETIGT.

**(b) Falsch-Null-feste Neu-Erhebung mit fremdem Nenner (T-3) und Gegeneingang (T-4).**
Statt des Dateinamen-Filters eine INHALTS-Probe ueber die Titelzeile:
- Grundgesamtheit (Nenner, in der Werkzeug-Ausgabe erzwungen):
  `find ~/backups-workflow -name '*.md' -newermt "2026-08-17 23:59" | wc -l` = **323** Dateien.
- Davon mit Titelzeile `^# WARNUNGS-REVIEW`: **1** -- und zwar GENAU
  20260820-nachhol-kombibau/warnungs-review.md.
- T-4-Gegeneingang (Zusicherung, bei der sie nicht gilt): dieselbe Probe auf
  `^# WARNUNGS-REVIEW DREIMAL` -> **0**.
=> Die Menge der Review-Artefakte nach 17.08. ist EXAKT eins; die Korrektur benennt das
richtige und einzige. Keine zweite, uebersehene Deckungsquelle.

**(c) Der korrigierte OFFEN-Umfang haelt am Repo-Objekt.** Die Korrektur behauptet:
"Deckung BIS c2da9d1a; OFFEN praezise = Delta c2da9d1a->66de5c09 (4cc3aa0f Code +
66de5c09 XML-only)". Eigene Messung im ce-Hauptklon:
- `git merge-base --is-ancestor c2da9d1a 66de5c09` -> **rc=0** (Deckungspunkt liegt wirklich
  vor dem Messobjekt).
- `git rev-list --count c2da9d1a..66de5c09` -> **6**;
  `git log --first-parent --oneline c2da9d1a..66de5c09` -> **genau 2 Zeilen**:
  `4cc3aa0f merge(v08r): V-08R fingerprint_sha SHA-256 (#95) ...` und
  `66de5c09 Fixture-Spiegel fuer den super-XSD-Verbund-Patch ... (XML-only).`
- `git show --stat 66de5c09` -> **1 file changed**:
  `tests/unit/thesis_tiere/experiment_golden.xml | 4 ++--` -> XML-only BESTAETIGT.
- `git show --stat 4cc3aa0f` -> 7 Dateien (stempel_basis.hpp, planner_version.hpp,
  g1_binary_version_stamp.hpp, test_s1_stempel_basis_vertrag.cpp,
  test_vl3_debug_flag_sperre.cpp, 2x CMakeLists) -> die Code-Haelfte BESTAETIGT.
=> Der praezisierte OFFEN-Umfang ist am Objekt exakt richtig, nicht nur plausibel.

**(d) Alle drei Fix-Teile der Auflage G2 sitzen.** Eigene greps (fixed-string):
- Teil 1 (ergebnis.md 3.1/3.4/Bilanz): `grep -c -F "G2-Vollzug" verify-93-ergebnis.md` = **6**;
  KORREKTUR-Bloecke stehen bei Z.68-75 (3.1-N1), Z.138-152 (3.4) und Z.300-304 (Bilanz);
  `grep -c -F "c2da9d1a->66de5c09"` = **4**.
- Teil 2 (Ledger-ENTWURF Abschnitt 10): ENTWURF-NACHTRAG bei Z.315-322 mit dem
  Artefakt-Verweis; `grep -c -F "warnungs-review.md" verify-93-ergebnis.md` = **4**.
- Teil 3 (STAFFEL1-SYNTHESE.md:150 F-45-Halbsatz): `grep -n -F "G2-Vollzug"
  STAFFEL1-SYNTHESE.md` -> **Z.150**, `grep -c -F "warnungs-review.md"` = **1**; Zeile 150
  traegt heute "... gruene clang-Zellen ersetzen es NICHT -- KORREKTUR 22.08. (G2-Vollzug,
  V93-A1 [ERNST]): Review EXISTIERT bis c2da9d1a (...); OFFEN praezise = Delta
  c2da9d1a->66de5c09 + W2-2-Endstand-Runde".
**STATUS V93-A1: BEHOBEN** (Status OFFEN und Traeger W2-2/S-12-Dual-CI #106/#3 bleiben
unveraendert -- korrigiert wurde der BEWEIS, nicht die Sache).

### V93-A2 [KLEIN] -- P-11-Messanker mit unvollstaendigem Repo-Pfad

Eigene Messung @66de5c09:
- Kurzform loest NICHT auf: `git show 66de5c09:include/cache_engine/abi/anatomy_fingerprint.hpp`
  -> **rc=128** (fatal) -- der Fund ist real.
- Realer Pfad existiert: `git ls-tree -r --name-only 66de5c09 --
  libs/cache_engine/include/cache_engine/abi/anatomy_fingerprint.hpp | wc -l` = **1**.
- Zeilenanker EXAKT: `sed -n '1602p;1623p'` liefert
  `/// komposit_map_wert_bei(glied, stufen_id) -- DIE EINE LESUNG der Komposit-Zeile (G3/A-03,`
  und `[[nodiscard]] constexpr std::string_view komposit_map_wert_bei(std::string_view glied,
  std::size_t stufen_id) {` -- Symbol und Zeilen unveraendert richtig.
- Fix sitzt: NACHTRAG-Bullet Z.215-219 in Abschnitt 4.3, direkt unter dem Original-Bullet.
**STATUS V93-A2: BEHOBEN.**

### K-1 [KLEIN] -- drei Pfad-Kurzformen (Resume-Audit R1, Abschnitt 5)

Eigene Messung @66de5c09, `git ls-tree -r --name-only ... | wc -l` je Pfad (SOLL 1):
- libs/cache_engine/include/cache_engine/abi/anatomy_fingerprint.hpp -> **1**
- tests/unit/thesis_tiere/test_experiment_plan_director.cpp -> **1**
  (Zeile 711 woertlich: `// Die CEB emittiert SELBST die Stufe-2 (S40.b-Hoheit: 'tier ci',
  nicht 'plan ci').` -- der Gegenproben-Anker aus P-02 lebt an diesem Pfad)
- libs/cache_engine/builder/experiment_tree/axis_variant_version_table.hpp -> **1**
Fix sitzt: `grep -c -F "PFAD-NACHTRAG" verify-93-ergebnis.md` = **2** (Block Z.324-333 am
Dateiende + Querverweis Z.218); der Block nennt alle drei Vollpfade und bindet seine
Zeilenangaben ausdruecklich an den 278-Zeilen-Originalstand.
**STATUS K-1: BEHOBEN.**

## 3. WACHEN DIESER RUNDE

- **BU-additiv (Rohdaten nie ueberschreiben):** verify-93-ergebnis.md ist von 278 auf **333**
  Zeilen gewachsen (+55, reine Einfuegungen). Die widerlegten Original-Saetze stehen
  woertlich weiter -- `grep -c -F "Kein clang-Warnungs-Review-Artefakt nach 17.08. in"` = **1**,
  `grep -c -F "enthaelt kein clang-Warnungs-Review-Artefakt nach 17.08."` = **2** (Original
  3.4 + woertliches Zitat im KORREKTUR-Block), `grep -c -F
  "include/cache_engine/abi/anatomy_fingerprint.hpp:1602"` = **1** (Original-Kurzform).
  STAFFEL1-SYNTHESE.md: **275** Zeilen VORHER wie NACHHER (Halbsatz-Anbau IN Z.150), und
  der Original-Wortlaut steht: `grep -c -F "clang-Warnungs-Review nicht gefahren; gruene
  clang-Zellen ersetzen es NICHT"` = **1**. Nichts geloescht, nichts umgeschrieben.
- **ASCII-Wache mit fremdem Nenner:** `grep -c -P '[^\x00-\x7F]' verify-93-ergebnis.md` =
  **65** -- identisch mit der VORHER-Zaehlung aus audit-runde-1 Abschnitt 2(b) ("65 Zeilen
  mit Non-ASCII"), also ein Nenner aus fremder Quelle. Je eingefuegtem Block einzeln
  gemessen (SOLL 0): Z.68-75 = 0, Z.138-153 = 0, Z.215-219 = 0, Z.300-304 = 0,
  Z.315-333 = 0. Grep-Schaerfe per Koeder bewiesen: `printf 'a\xc3\xa4b'` -> **1**.
  Alle Einfuegungen sind ASCII-only.
- **Repos unberuehrt:** ce `git status --porcelain | wc -l` = **0**; nur Lese-Kommandos
  (show/grep/ls-tree/log/rev-list/merge-base). Kein axes/topics/heuristik/golden-Pfad
  beruehrt, kein Push, kein Branch, kein Commit (der Strang hat kein Git-Objekt).
- **Ledger/Board/Memory:** nicht geschrieben (Lead-only); Entwuerfe stehen in
  lande-auflagen.md dieses Ordners.

## 4. GEGENZAEHLUNG -- Fund-Bestand vs. Erledigung

| Fund | Klasse | Quelle | Stand Rundenbeginn | Stand Rundenende | Beleg dieser Runde |
|---|---|---|---|---|---|
| V93-A1 | ERNST | Erstlauf + Gate F-1 | OFFEN (Fix-Runde 1 am Credits-Riss gestorben) | **BEHOBEN** | 2(a)-(d): Artefakt real, Nenner 323/1/0, Delta 6 Commits first-parent 2 |
| V93-A2 | KLEIN | Erstlauf | OFFEN | **BEHOBEN** | rc=128 Kurzform vs. ls-tree=1 Realpfad, Anker :1602/:1623 woertlich |
| K-1 | KLEIN | Audit R1 Abschn. 5 | OFFEN | **BEHOBEN** | 3x ls-tree=1, PFAD-NACHTRAG-Treffer=2 |
| V93-L1 | KLEIN | diese Runde | -- | **VERTAGT mit Auflage** | s. Abschnitt 5 |

3 Funde geschlossen, 1 neuer Restposten vertagt-mit-Traeger, **0 traegerlos**.

## 5. RESTFUND DIESER RUNDE -- V93-L1 [KLEIN], VERTAGT MIT LANDE-AUFLAGE

**V93-L1: Die Lead-Synthese behauptet weiterhin das Gegenteil des Objektstands.**
- Beleg: SYNTHESE-S1-AUDIT.md **Z.74** traegt unveraendert "G2 T8/verify93 KORRIGIERT: Die
  V93-A1/A2-Textfixe sind NICHT vollzogen --"; `grep -c -F "G2-Vollzug"
  SYNTHESE-S1-AUDIT.md` = **0**. Der G2-Vollzug fand am 22.08. 12:52 statt (mtime beider
  Ziel-Dateien), also 48 Minuten NACH dem Gate (12:04) -- die G2-Zeile ist seither stale.
- Wirkung: Der W2-Lande-Zug laeuft aktiv (ZUG-BILANZ.md, mtime 23.08. 13:52) und liest die
  Synthese als Auflagen-Quelle. Er koennte den bereits vollzogenen Textfix erneut auftragen
  oder -- schwerer -- die F-45-Uebernahme in den Freeze-/Di-25-Text blockiert glauben.
- Warum VERTAGT statt selbst gefixt: SYNTHESE-S1-AUDIT.md ist eine Lead-eigenhaendige Datei
  ("Owner-Order 'mach das selbst'", Z.1) mit einem aktiven zweiten Schreiber (Gate-Agent
  hat dort Abschnitt 5 angelegt) und wird waehrend des laufenden Lande-Zugs gelesen. Die
  REGELN dieses Strangs weisen Entwuerfe in die Strang-Ordner-Dateien; ein Fremdschreiben
  waehrend eines Live-Zugs verletzt die Ein-Schreiber-Doktrin.
- Traeger + wortfertiger Entwurf: **lande-auflagen.md dieses Ordners, Auflage V93-L1**
  (PFLICHT, zeitkritisch VOR der F-45-/Freeze-Text-Uebernahme).

## 6. VERDIKT

**SITZT NACH FIX** -- 0 ERNST, 0 MILD, 0 KLEIN offen am Objekt; 3/3 Funde behoben und
eigenstaendig nachgemessen; 1 Restposten (V93-L1) VERTAGT mit wortfertiger Lande-Auflage.
Die Sach-Lage des Strangs ist unveraendert: N1/M-6 bleibt OFFEN und getragen (W2-2 /
S-12-Dual-CI #106/#3), nur mit jetzt praezisem OFFEN-Umfang (Delta c2da9d1a->66de5c09 +
W2-2-Endstand-Runde) statt einer falschen Nicht-Existenz-Behauptung. Landung aus Sicht
dieses Strangs FREI, sobald V93-L1 im Lande-Zug quittiert ist.

Selbstcheck: alle REGELN-Quellen konsultiert; jede Zahl dieser Runde selbst gemessen (keine
aus BEWEIS.md, audit-runde-1.md oder den Synthesen uebernommen); Nenner in die
Werkzeug-Ausgabe gezwungen (323) und Gegeneingang gefahren (0); Grep-Schaerfe per Koeder
bewiesen; BU-additiv eingehalten (nichts geloescht); Repos nur lesend beruehrt, porcelain 0;
kein Bauslot belegt, df-Gate 16G > 5G; Ledger/Board/Memory nicht geschrieben; Bericht
ASCII-only; beide Mengen je Gate genannt.
