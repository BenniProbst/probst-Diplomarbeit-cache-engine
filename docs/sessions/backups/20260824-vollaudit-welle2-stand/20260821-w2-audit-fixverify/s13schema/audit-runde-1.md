# AUDIT RUNDE 1 -- Strang s13schema (S1, #18-Vorstufe S-13-Schema-Kette)

Auditor: Fable-max, 22.08.2026. Objekt: ce `bau/s13schema` @ ad5c6d66 (Basis 66de5c09,
10 Dateien +1091/-78, merge-base==Basis bestaetigt) + super `bau/s13schema` @ 1e92b77e
(Basis a7e8e151, NUR `Code/test_data_xml/experiment_schema.xsd` +17/-6). Beide Branches
origin-gesichert (ls-remote: ad5c6d6645... / 1e92b77e3c...). Worktrees
/home/comdare/wt-ce-s13schema @ ad5c6d66 porcelain 0, /home/comdare/wt-super-s13schema
@ 1e92b77e porcelain 0 (selbst gemessen).

VERDIKT: **FIXES_NOETIG** (1 ERNST + 1 KLEIN; alle uebrigen Pflicht-Punkte ERFUELLT
oder korrekt deklariert offen).

--------------------------------------------------------------------------------

## 1. PUNKT-FUER-PUNKT-TAFEL (P-01..P-26 der Soll-Karte, dreiwertig)

| P | Urteil | Literal-Beleg (selbst erhoben, sofern nicht anders vermerkt) |
|---|--------|--------------------------------------------------------------|
| P-01 X-6 Schema-Zug-Subset | **ERFUELLT** | super-Diff a7e8e151..1e92b77e = NUR experiment_schema.xsd, Kommentar-only an :286-298 (RunMethodologyType) + :305-325 (WritebackMethodsType), kein Element/Typ/Attribut beruehrt (Diff voll gelesen). xmllint SELBST reproduziert: alle 4 Instanzen "validates" (super experiment_golden.xml, super experiment_golden_kern.xml, ce tests/unit/thesis_tiere/experiment_golden.xml, ce experiment_kern_seam_fixture.xml gegen die Tip-XSD). Kein '--' im XML-Kommentar (xmllint parste die XSD fehlerfrei = Wohlform-Beweis). |
| P-02 S13-01 CSV=Kind (beide Naehte) | **ERFUELLT** | ergebnis_mappe_naht.hpp: projektion_oeffnen (:641ff), Schreiben NUR in schreibe() nach Stamm-Annahme (:800ff), Stamm-Bruch-catch ENTFERNT die Datei sofort (:761ff), schliessen() entfernt/meldet false. Beide Seams: roher `std::ofstream csv{a.out_csv...}` ENTFERNT -- `git grep "ofstream csv{"` am Tip = 2 Treffer, BEIDE Kommentare ("ist ENTFERNT": profile_run_entry.hpp:782, experiment_run_entry.hpp:257), 0 lebender Code. exit haengt an persistenz_ok = stamm_ok && mappe_ok (profile:1567, experiment:571). Test test_s13_01 (171 Z., voll gelesen): Byte-Orakel A, Filter B, Stamm-Bruch-Koeder C (LXW_STR_MAX-Ausloeser, 3 Auskuenfte geprueft), Scope-Zaehl-Wache D. |
| P-03 S13-02 Ziel-Filter 4 Faelle | **ERFUELLT** (mit dokumentierter F-21-Substitution) | test_s13_02 (263 Z., voll gelesen): 4 Faelle am ECHTEN run_profile (Stub-Compile, provision_only) je literales Verzeichnis-Listing + Koeder-Abwesenheit; Fall 4 mit test-lokalem Profil-Klon -- Substitution GEDECKT: alle 11 thesis_profiles-Dateien am Tip tragen `<writeback_methods>` (selbst gezaehlt, 11/11 >= 1 Treffer; seit ce fbe48f99). Substanz der Abnahme (Profil ohne Block verliert die CSV) trifft der test-lokale Fall exakt (Default xlsx, KEINE measurements.csv). T-1-Rot literal im Strang-Bericht ([ERR] fall2/fall4, EXIT=1, Datumsstempel). T-6-Spiegel: 2 Faelle run_experiment_profile (exit dort bewusst ungeprueft -- Grund im Test-Kopf dokumentiert: Stub-Compile = nichts messbar, geprueft wird die Persistenz-Spur). |
| P-04 S13-03(a) per-Binary-Mappe | **ERFUELLT (unit-gebunden)** | Iterator: PerBinaryMappeFn-Alias (:93ff), cfg.per_binary_mappe No-Op-Default (:276ff), Aufruf an der Synchron-Naht NACH result.csv+stamp, gated auf per_binary_subdirs && !per_binary_csv.empty() (:3179ff). Fassaden-Sink mach_per_binary_mappe_sink (Naht :880ff). Test (Z): 3 Sinks + 1 Aggregat => EXPECT_EQ(zaehl .xlsx, 4u) -- Zaehl-Abnahme woertlich ("N Binaries => N Mappen + 1 Aggregat-Mappe"). Echte Mess-Lauf-Verdrahtung = P-22 (deklariert offen). |
| P-05 S13-03(b) Resume-Vertrag | **ERFUELLT** | Vertrags-Kommentar am result.csv-Schreibblock (Iterator :3107-3117, woertlich "RESUME-VERTRAG ... AUSSERHALB des ... Ziel-Filters ... WEITERHIN und BEDINGUNGSLOS"). Sink fasst result.csv STRUKTURELL nie an: oeffnen() nutzt den Anker nur fuer parent_path(), Stamm-/Kind-Name aus Zeitstempel (`<datum>-<zeit>.xlsx` / `__S001.csv`, Naht :442-481 gelesen). Test: K1 (lazy_try_resume_binary findet Vertrag im Nur-xlsx-bin_dir, rows byte-geprueft), K2/K3 als Byte-Wache (result.csv+stamp EXPECT_EQ vorher/nachher), R-Positivprobe N->N+1 + Gegeneingang fremder Praefix. K2 in "pruefbarer Form" (Byte-Identitaet + exists-Vorbedingung des measurement_sink-Gates) -- dokumentierte, von der Soll-Karte so gerahmte Abbildung des woertlichen Lauf-Rezepts; M4-Mutation (Sink ueberschreibt result.csv -> 2 Tests rot) belegt den Biss. |
| P-06 H-6 Lande-Kopplung | **ERFUELLT (Zusage)** | BEIDE Commit-Volltexte gelesen: super 1e92b77e "LANDE-KOPPLUNG (deklariert): dieser super-Commit landet im SELBEN Lande-Ereignis wie ce bau/s13schema ... die Kommentar-Semantik (S13-02-Persistenz) beschreibt sonst einen Stand, den ce noch nicht traegt"; ce ad5c6d66 "LANDE-KOPPLUNG: beide Branches im SELBEN Lande-Ereignis". Vollzug = Lande-Zug (STAFFEL2 Phase 1 Schritt 3 <-> Phase 2 Schritt 11, H-6 bindend) -- nicht Sache dieses Strangs. |
| P-07 T-1/T-11c | **ERFUELLT** | T-1-Rot-Protokoll S13-02 mit Literalen im Strang-Bericht (Z.97-105). M1-M5 je mit exakter Fehlermeldung + EXIT=1 (Bericht Z.133-138). Reste-Gegenprobe SELBST gefahren: `git grep "T-11c-MUTATION" ad5c6d66` = 0 Treffer. Wegwerf-Mutationen am Objekt naturgemaess nicht mehr sichtbar (T-11c-Design); Protokoll-Form (Vorher/Nachher je Mutation) liegt. |
| P-08 T-2 Aussage | **ERFUELLT (Substanz)** | Byte-EQ auf vollem Dateiinhalt (test_s13_01 A), Listing-Mengen + Endungs-Zaehlungen (test_s13_02), EXPECT_EQ(4u)/EXPECT_EQ(rows, "...") (test_s13_03). Explizite Selbstzuordnung "T-2" fehlt im Bericht -- kosmetisch, kein Fund. |
| P-09 T-3 Nenner fremd | **ERFUELLT (Substanz)** | test_s13_02 kommentiert woertlich "Die Grundgesamtheit der Faelle ist die FALL-MATRIX des Designs (4.1), nicht dieser Test"; N=3 test-lokale Vorgabe gegen Dateisystem-Zaehlung; Scope-Wache zaehlt Datei-Bytes (zeilen_in) gegen Pruefling-zeilen(). |
| P-10 T-4 Gegeneingang | **ERFUELLT** | test_s13_03 (R): "EXPECT_FALSE(... 'resume-v6\|ANDERE-config' ...)" -- fremder Praefix resumiert NICHT; zusaetzlich bin2-ohne-Stamp-Negativfall; test_s13_01 (B) Nur-xlsx-Abwesenheit. |
| P-11 T-5 Orakel unabhaengig | **ERFUELLT** | Erwartungs-String im Test gerechnet (kKopf+blob+zeile3+zeile4), K2/K3-Orakel = VOR dem Sink eingefrorene Datei-Bytes (csv_vorher/stamp_vorher). |
| P-12 T-6 Schwesterpflicht | **ERFUELLT** | Identischer Schnitt an BEIDEN Seams (beide Diffs voll gelesen: gleiche Struktur mappe.oeffnen -> projektion_oeffnen -> fail-fast -> emit-nur-Mappe -> stamm_ok/csv_ok/persistenz_ok); xml_config_parser.hpp X-6-Zwilling an BEIDEN Strukturen (ThesisProfile :341 + ExperimentProfile :493); Test-Spiegel 2 Experiment-Faelle. |
| P-13 T-7 Registrierung | **ERFUELLT** | add_test-Delta Basis->Tip = 99->102 (+3, selbst gezaehlt); Block am DATEIENDE (Diff beginnt @7574 von 7576 Basis-Zeilen; Tip 7667 Z.); ctest -N "#511/#512/#513" literal im Bericht; Ausfuehrungs-Biss durch M1-M5 belegt (rote Mutationen setzen laufende Tests voraus). |
| P-14 T-8 atomare Landung | **NOCH NICHT FAELLIG** | Erst am Merge nach development pruefbar (Lande-Zug); Feature-Branch traegt Test+Bau in EINEM Commit ad5c6d66. |
| P-15 T-9 Testkritik | **NOCH NICHT FAELLIG** | Per Definition Folgewelle (Codex-Pass); kein Anspruch im Bericht. |
| P-16 T-11b 4-Zellen | **TEILWEISE (by design, offener Nachweis)** | Strang fuhr 1 Zelle (gcc-Release, volle Treppe J-0b..J-4, Bericht literal); 4-Zellen-Kombibau = Lande-Zug am GEMERGTEN Endstand (K17/H-7-Doktrin, STAFFEL2 Phase 4 identisch fuer alle 18 Straenge). Kein Strang-Defekt; D-1-Formel "Debug+Release, gcc+clang" fuer dieses Paket noch NICHT literal erbracht -- Lande-Zug-Pflicht. |
| P-17 Reihenfolge S13-01->02->03 | **ERFUELLT** | Bericht-Plan + Vollzug: Schema-Zug ZUERST (super-Commit), dann T-1-Rot, dann Bau, dann Tests/Mutationen; C-8-Zwang ("Schema-Zug EIN Commit zuerst -> S13-01->02->03") eingehalten. |
| P-18 W-A/W-B/W-C | **ERFUELLT** | W-A/W-B selbst reproduziert (4x "validates", Instanzen byte-unveraendert: super-Diff traegt keine Instanz, ce-Diff keine golden-Datei). W-C NICHT ANWENDBAR: kein neues XSD-Element (Kommentar-only-Diff selbst gelesen; `<export>` = X-1/S13-04, nicht dieser Strang). |
| P-19 TABU + Formal-Gates | **TEIL-LUECKE -> FUND S13A-F1 (ERNST)** | TABU: `git diff --name-only 66de5c09..ad5c6d66 \| grep axes/\|topics/\|heuristik/` = 0 Treffer (selbst). golden: 0 golden-Dateien im Diff (selbst). CMakeLists nur ans Dateiende: JA (s. P-13). clang-format-22: SELBST gefahren, `--dry-run -Werror` ueber alle 8 Lint-Dateien RC=0. **ABER ASCII: die projekteigene Wache `scripts/ci_diff_ascii_width_guard.sh "66de5c09..HEAD"` meldet ROT -- 8 Nicht-ASCII-Zusatzzeilen** (Nenner literal: "1091 Zusatzzeilen ... davon 8 Nicht-ASCII, davon 0 ueber 120 Spalten"), waehrend der Bericht "ASCII-Wachen: 0 Treffer" behauptet. Details unter FUND S13A-F1. |
| P-20 U-1/Z-1 J-1-Rezeptfix | **ERFUELLT** | super-Basis a7e8e151 IST der U-1-Fix-Commit ("docs(w2/u-1): s13-J-1-Rezeptfix (comdare_-Target-Namen + J-4-Stufe) ... ROT-Vorbedingung vor #18", git log literal); Strang-Treppe mit comdare_-Namen RC=0 laut Bericht. Z-1-Bedingung ("Fix ist drin") am Objekt erfuellt. |
| P-21 D-5 Golden-Neutralitaet | **ERFUELLT** | 0 golden-Dateien im ce-Diff (selbst); Byte-Orakel-Test pinnt Zeilen-Identitaet; W-A/W-B (P-01). |
| P-22 Echte Iterator-Verdrahtung | **LUECKE, KORREKT DEKLARIERT (= F-25 OFFEN, getragen)** | "EHRLICHE NICHT-DECKUNG" im Bericht + Commit-Text; Traeger: Mess-Fenster Sa/So (S13-05..07 am Objekt). KEIN neuer Fund (getragener OFFENER Posten F-25). |
| P-23 S13-04 Export-Element | **NICHT GELIEFERT, KORREKT WEITERGEREICHT** | Staffel-3-Zuweisung durch die juengere operative Schicht (LEAD-ENTSCHEIDE Nr. 14, STAFFEL1-SYNTHESE par.5, STAFFEL2 5.3); D-1-Block fuehrt S13-04 im Di-25-Buendel. Kein Strang-Fund (Soll-Karte Spannung Nr. 2). Folge: #18 bleibt zu Recht pending. |
| P-24 D-2 Mappe bedingungslos im RAM | **ERFUELLT** | oeffnen() :457-461: "(1) DER STAMM -- BEDINGUNGSLOS. Hier steht mit Absicht kein `if (wahl_.xlsx)`" -- Stamm entsteht immer; Filter wirkt nur in schliessen()/projektion. |
| P-25 Vorbedingung #16 | **ERFUELLT** | `git merge-base --is-ancestor 04ac26fa 66de5c09` -> "IST VORFAHR" (selbst, literal). |
| P-26 KON32-01 Gesamtschau | **TEILWEISE (korrekt)** | Beide Heilungs-Haelften (Ziel-Filter + per-Binary-Format) GEBAUT (P-03/P-04/P-05); Export-Element (P-23) fehlt -> Toleranz "(a)" bleibt formal in Kraft, Board-#18 pending (Task-Board bestaetigt). Owner-Verbatim am Ledger :8457-8473 SELBST gegengelesen -- Soll-Karten-Zitate exakt. |

## 2. ZUSATZPRUEFUNGEN

**(a) TDD-Vertrag je neuem Test:** siehe P-07..P-13. Alle drei Tests: T-1/T-11c mit
literalem Rot (Bericht) + Reste-Gegenprobe 0 (selbst); T-3-Nenner fremd (Fall-Matrix/
N=3/Datei-Bytes); T-4-Gegeneingaenge vorhanden; T-7 registriert am Dateiende, +3
add_test. T-11c-Koeder-Formen im Bericht je Mutation benannt (M1-M5 mit Vorher/Nachher).

**(b) GOAL-Doktrinen:** allow_failure n/a (keine YAML beruehrt -- Diff-Dateiliste
vollstaendig gelesen, .gitlab-ci.yml NICHT dabei; TABU eingehalten). xlsx-Doktrin: dieser
Strang IMPLEMENTIERT sie (csv=Kind, D-2-Owner-Verbatim im Naht-Kopf). Ledger/Board/Memory:
vom Strang NICHT geschrieben (Diff-Dateiliste; Ledger-Zeilen als ENTWURF im Bericht --
korrekt). Hart-Gruen: siehe FUND S13A-F1 (die Landung wuerde am Diff-Hygiene-Gate rot).
Secrets: keine Vault-/Token-Beruehrung im Diff.

**(c) Abnahme-Formeln woertlich:** S13-01-ABNAHME (Koeder ErgebnisSchreibFehler-CSV +
golden-byte-identisch) ERFUELLT (Test C + A, M2/M3). S13-02-ABNAHME (4 Faelle mit
literalem Listing + Koeder je Fall + Profil-Blatt-Scope-Koeder) ERFUELLT -- 4. Fall per
dokumentierter Substitution (F-21; Bestandsprofil-Vorgabe war am Objektstand 20.08.
unerfuellbar, 11/11 mit Block selbst nachgezaehlt); Scope-Koeder = Zaehl-Wache (D).
S13-03-ABNAHME (Zaehl-Test N=>N+1-Mappen + 3 Koeder) ERFUELLT (Z/K1/K2K3/R); Koeder 2 in
Byte-Wachen-Form (dokumentiert, s. P-05). D-1-Gesamt-ABNAHME ("Debug+Release, gcc+clang")
= Lande-Zug (P-16). "Ein gruenes Gate deckt nur seinen Gegenstand": dieser Audit nennt je
Zeile BEIDE Mengen (geprueft: Diff, Tests, Wachen-Laeufe; NICHT geprueft: Vollbau/ctest-
Neulauf, s. (d)).

**(d) Bericht-Behauptungen am Objekt:**
- BESTAETIGT (Stichproben, je selbst): xmllint 4/4 · TABU 0 · clang-format-22 RC=0 ueber
  8 Lint-Dateien · Mutations-Reste 0 · beide origin-Refs = Tips · Worktrees porcelain 0 ·
  11/11 Profile mit Block · m3v2_smoke csv+xlsx, base_pilot/wdk Nur-xlsx · super-Leser
  lesen measurements.csv (mess_ausbeute_wache.sh: `find ... -name 'measurements.csv'`) ·
  lauf_marker parst token-weise, unbekannte Token ignoriert (felder(), :188-200) --
  persistenz_ok= additiv-vertraeglich; PFEIL_UTF8=$(printf '\342\206\222') :117 = der
  Pfeil ist PARSE-ANKER (vertragstragend) · 0 fertig-Zeilen-Leser in ce tests/apps/scripts
  (git grep = 0) · test_t2a_f4 asserted KEINE measurements.csv-Existenz (1 Treffer = nur
  Zuweisung a.out_csv) -- Default-xlsx-Umstellung regressionsfrei fuer den Bestand ·
  fixture_schema_subset_check.cmake :101-104 dokumentiert das uebersprungene Schema-Bein ·
  git ls-tree build/ am Tip = 0 (Gate-Claim haelt) · 04ac26fa Vorfahr der Basis.
- **FALSIFIZIERT: "ASCII-Wachen: 0 Treffer"** -- die projekteigene Wache meldet ROT mit
  8 Nicht-ASCII-Zusatzzeilen (FUND S13A-F1). Die 2 selbst gefangenen Cyrillic-e-Funde
  waren offenbar eine Homoglyphen-Probe, nicht der Lauf der Repo-Wache ueber den Bereich.
- NICHT-PRUEFBAR-OHNE-NEUBAU: "ctest 513/513" (build/ entfernt; Neubau kostet Bau-Slot
  und wird durch den Fix ohnehin invalidiert). Konsistenz-Beleg dreifach: Basis-Nenner
  510 stimmt gegen s19 (510+2=512), pmcpaket (510+2=512), s13 (510+3=513) -- der
  Fix-Verify und der K17-Endstand-Kombibau erbringen den frischen Literal-Beweis.

## 3. FUNDE

### S13A-F1 (ERNST) -- Diff-Hygiene-Wache ROT: 8 Nicht-ASCII-Zusatzzeilen; Bericht behauptet "0 Treffer"
LITERAL (selbst gefahren, wt-ce-s13schema @ ad5c6d66):
`sh scripts/ci_diff_ascii_width_guard.sh "66de5c09..HEAD"` -> "DIFF-HYGIENE-WACHE: ROT."
mit Nenner "1091 Zusatzzeilen in selbst verfasstem Code geprueft, davon 8 Nicht-ASCII,
davon 0 ueber 120 Spalten". Die 8 Zeilen (Tip-Zeilennummern):
- experiment_run_entry.hpp:255, :263 -- Kommentar-Trennzeichen `──` (U+2500)
- experiment_run_entry.hpp:272 -- NEUE FEHLER-Ausgabe "...nicht herstellbar -- ... << \" → \"" (U+2192)
- experiment_run_entry.hpp:563 -- fertig-Zeile `<< " persistenz_ok=..." << " → " << a.out_csv...` (U+2192, PARSE-ANKER)
- experiment_run_entry.hpp:570 -- Kommentar `(Binary × Setting)` (U+00D7)
- profile_run_entry.hpp:799 -- NEUE FEHLER-Ausgabe mit `→`
- profile_run_entry.hpp:1543 -- fertig-Zeile mit `→` (PARSE-ANKER)
- profile_run_entry.hpp:1549 -- Kommentar `— kein async/detached` (U+2014)
WIRKUNG: Die Wache laeuft in JEDER ce-Pipeline vor dem Bau (.gitlab-ci.yml:448-457,
Bereich = Push; :495-506 kumulativ gegen origin/main) -- die Landung dieses Diffs macht
den Lande-Push und danach JEDE development-Pipeline (kumulatives Gate bis zum main-FF)
und den main-FF selbst ROT. Hart-Gruen-Doktrin verletzt; die Bericht-Behauptung haelt
am Objekt nicht. (Hintergrund: die Basis-Fassungen beider Seam-Dateien tragen 112/103
Nicht-ASCII-BESTANDS-Zeilen aus der Vor-Wache-Aera -- der Bestand ist geduldet, der
ZUWACHS nicht; die Wache dokumentiert genau das in ihrem Kopf.)
FIX_WEG (konkret, im Worktree /home/comdare/wt-ce-s13schema):
1. 4 Kommentar-Zeilen ASCII-fizieren: exp:255/:263 `──` -> `--`; exp:570 `×` -> `x`;
   prof:1549 `—` -> `--`.
2. 2 neue FEHLER-Zeilen (exp:272, prof:799): `" → "` -> `" -> "` -- NICHT vertragstragend
   (lauf_marker ankert nur "RUN_PROFILE fertig:"/"RUN_EXPERIMENT fertig:"-Zeilen; die
   Stamm-FEHLER-Zeilen desselben Diffs nutzen bereits ASCII "--").
3. 2 fertig-Zeilen (exp:563, prof:1543): der Pfeil ist PARSE-ANKER der super-Wache
   (ci/lauf_marker.sh:117 `PFEIL_UTF8=$(printf '\342\206\222')`; "Pfad = alles NACH dem
   Pfeil") -- Ausgabe-Byte MUSS U+2192 bleiben. Quelltext-ASCII herstellen ueber
   Escape-Sequenz: den Roh-Pfeil im String-Literal durch die ASCII-Schreibweise
   ersetzen -- aus dem Roh-Byte-Pfeil wird im Quelltext exakt die sechs
   ASCII-Zeichen \u2192 (String-Inhalt dann `" \u2192 "`;
   narrow literal, UTF-8-Execution-Charset beider
   Compiler emittiert identische 3 Bytes E2 86 92; Kommentar dazu: "Escape statt
   Roh-Byte: Diff-Hygiene-ASCII, Ausgabe-Byte identisch, Anker lauf_marker.sh
   PFEIL_UTF8"). Alternative (gleichwertig): Stream-Kette so umbrechen,
   dass die pfeiltragende Zeile BYTE-IDENTISCH zur Basis-Zeile bleibt (persistenz_ok=-
   Token als eigene neue ASCII-Zeile VOR der unveraenderten csv_ok=->-Zeile; Token-
   Reihenfolge ist fuer den token-weisen Parser irrelevant) -- dann traegt keine
   Zusatzzeile den Pfeil.
4. Verifikation: clang-format-22 ueber beide Dateien (Umbruch-Stabilitaet!), dann
   `sh scripts/ci_diff_ascii_width_guard.sh "66de5c09..HEAD"` -> Soll "0 Nicht-ASCII" +
   GRUEN literal; Byte-Probe der fertig-Zeile (ein Testlauf von test_s13_02 druckt sie
   NICHT -- stattdessen `printf`-Vergleich des emittierten Strings im Binary oder ein
   run_profile-Smoke) ODER schlicht: unveraenderte-Basis-Zeilen-Variante waehlen; danach
   Bau-Treppe + ctest (3 s13-Tests + Bestands-Suite) im Bau-Slot; Commit mit Trailer,
   `git push -o ci.skip origin bau/s13schema`.

### S13A-F2 (KLEIN) -- Resume-Vertrag-Carve-out ohne Interpretations-Vermerk im Ledger-Entwurf
Der Owner-Satz (Ledger KON32-01, :8465-8473, selbst gegengelesen): "ES WIRD NUR
PER-BINARY-XLSX GEBEN. Der heutige Code sendet result.csv ... das SOLL je Binary ist
xlsx". Das Design (K4/D1) interpretiert result.csv+stamp als BETRIEBSZUSTAND ausserhalb
des Filters und vermerkt die Alternative selbst als W3-Nachfolgeposten (Z.481-483) --
der Strang baute exakt diese Interpretation (korrekt gegenueber vorliegendem Design).
Der LEDGER-ENTWURF [S13-03 GEBAUT] im Strang-Bericht nennt den Carve-out, aber NICHT,
dass er eine Design-INTERPRETATION mit offener Owner-Feinabstimmung ist (Soll-Karte
Spannung Nr. 1: "nicht als glatt erledigt fuehren"). Nach diesem Strang liegt weiterhin
eine per-Binary-CSV-Datei (result.csv) auf der Platte -- nur nicht mehr als
Auswerte-Format.
FIX_WEG: EINEN Satz an den LEDGER-ENTWURF [S13-03 GEBAUT] im Strang-Bericht anfuegen
(Datei /home/comdare/backups-workflow/20260820-w2-sofortstaffel/s13-schema-kette-ergebnis.md,
ENTWURF-Block Z.145ff): "result.csv-Fortbestand = Design-Interpretation von KON32-01
(Betriebszustand, kein Auswerte-Format); Owner-Feinabstimmung offen, Alternative
(Resume auf Mappe) als W3-Nachfolgeposten in K4/D1 Z.481-483 vermerkt." Traegt der Lead
beim KON120-Zug ein; KEINE Ledger-Schreibung durch den Strang/Auditor.

## 4. GETRAGENE OFFENE POSTEN (KEINE Funde -- nur gelistet)
- F-25 (OFFEN): per_binary_mappe-Vollkette im echten Mess-Lauf -> Mess-Fenster Sa/So (=P-22).
- F-24 (DOKUMENTIERT): Registry-Enum-Wache nur im --validate-Zweig -> X-/S13-04ff-Traeger.
- S13-04 Export-Element (KON27-02 Option b) -> Staffel 3 / D-1-Di-25-Buendel (=P-23);
  KON32-01-Toleranz (a) bleibt bis dahin formal in Kraft, #18 pending.
- X-1..X-5/X-7..X-9 Schema-Zug-Rest -> Traeger S13-04ff (D-3-"EIN Commit" im engsten
  Wortsinn erst mit dem zweiten Schema-Commit erfuellt -- Soll-Karte Spannung Nr. 4,
  organisatorisch durch Staffel-Schnitt gedeckt).
- T-11b 4-Zellen-Kombibau + T-8-Atomaritaet + H-6-Vollzug + H-9-Blockfolge + Floor/H-7 ->
  Lande-Zug (STAFFEL2 Phase 1 Schritt 3 / Phase 2 Schritt 11 / Phase 4).
- T-9 Codex-Testkritik -> Folgewelle.

## 5. BEIDE MENGEN (Gate-Ehrlichkeit dieses Audits)
GEPRUEFT: beide Branch-Diffs vollstaendig; 3 neue Testdateien vollstaendig; Naht-oeffnen/
schliessen/schreibe am Tip; Commit-Volltexte; xmllint (4 Instanzen, selbst); Diff-Hygiene-
Wache (selbst, ROT); clang-format-22 (selbst, RC=0); TABU/golden/Dateiende/Mutations-
Reste/Refs/Worktrees/Profile-Zaehlung/Leser-Grep/Vorfahr (je selbst, literal); Ledger
KON32-01-Fenster; Soll-Quellen (W2-ABFOLGE-DESIGN C-8/D-1/S3-Slot, LEAD-ENTSCHEIDE voll,
Designplan par.3+T-11/T-12-Definitionen, STAFFEL1/2-Synthesen s13-relevante Teile).
NICHT GEPRUEFT: frischer Vollbau/ctest-Lauf (Begruendung in 2(d) -- Fix invalidiert ihn
ohnehin; Fix-Verify + K17-Endstand tragen den Literal-Beweis); die reale CI-Ausfuehrung
der Wachen (erst am Lande-Push messbar); Wegwerf-Mutationen selbst (revertiert, nur
Protokoll + 0-Reste-Gegenprobe); super-seitige ctest-Wirkung der XSD-Kommentare
(fixture_schema_subset laeuft xmllint-gleich -- durch meinen xmllint-Lauf substanzgedeckt).
