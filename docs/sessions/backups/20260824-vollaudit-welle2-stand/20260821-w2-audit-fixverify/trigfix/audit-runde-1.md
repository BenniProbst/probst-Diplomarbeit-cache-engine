# AUDIT RUNDE 1 — Strang trigfix (S2: E-7/R-12 E-07-Gate-Kriterien + E-8/R-13 unwahre Messgroessen)

Auditor: Fable-max-AUDITOR (W2-Audit-Fix-Verify, 2026-08-21). Objekt: ce `bau/trigfix` @
`0f900dcf405578c8406edf2edc63d1ee3d2bcbe3` (Basis `66de5c09`; merge-base == Basis, `git rev-list
--count 66de5c09..0f900dcf` = **1** Commit; `git diff --name-status`: **genau 5 Dateien** — A
e07_gate_kriterien.hpp, A test_e07_gate_kriterien.cpp, A test_e8_bytes_in_use_peak_demo.cpp,
M tests/unit/CMakeLists.txt, M experiment_demo.hpp; +687/−2). Methode: NUR-LESEN am ce-Hauptklon
(git show/diff/grep gegen Refs) + eine slotlose Standalone-Bissprobe ausserhalb aller Worktrees
(`probe/`, s. u.). KEIN Fix-Commit noetig, KEIN Vollbau gefahren (Begruendung s. „Zwei Mengen").

**VERDIKT: SITZT** (0 ERNST, 0 MILD; 3 KLEIN als Doku-/Robustheits-Notizen, blockiert nichts —
KLEIN-1 aus Runde 1, KLEIN-2/KLEIN-3 aus der unabhaengigen Wiederanlauf-Verifikation 22.08.,
s. ANNEX unten; alle Kern-Literale am 22.08. FRISCH re-deriviert, nicht nur uebernommen).

---

## 0. Eigene, unabhaengige Beweise dieses Audits (Literale)

- **Standalone-Bissprobe** am Header VOM TIP (`git show 0f900dcf:libs/cache_engine/profile_facade/
  e07_gate_kriterien.hpp`, g++ 13 `-std=c++23 -Wall -Wextra`, COMPILE-RC=0, 0 Warnungen — beweist
  zugleich „header-only, nur stdlib, umbrella-frei": kompiliert mit einzigem `-Ilibs/cache_engine`):

  ```
  P1 GRUEN: go=1 kriterien=10/10 literale=23/23 befunde=0
  P2 ENTFERNUNG: 23/23 Einzelentfernungen ergeben NO-GO
  P3 LEER: go=0 nenner_0_23_in_ausgabe=1
  P4 ECHO: go=0 (muss 0 sein)
  P5 FLAG=2: go=0 (muss 0 sein)
  P6 DELTA-0: go=0 ungueltig_befund=1
  AUDIT-PROBE-ERGEBNIS: ALLE OK (fehler=0)  / RC=0
  ```
  (persistiert: `trigfix/probe/audit_probe_e07.cpp` + `audit_probe_e07_ausgabe.log`; Header-Kopie
  vom Tip liegt daneben.)
- **ASCII**: alle 692 hinzugefuegten Diff-Zeilen `grep -cP '[^\x00-\x7F]'` = **0**;
  Positiv-Kontrolle derselben Pipeline: 116 Zeilen mit `E07_` (Wache beisst, keine stille Null).
- **clang-format-22** (`~/.local/bin/clang-format-22 --dry-run -Werror`) ueber alle 4 Lint-Dateien
  vom Tip: **4x CF-OK, GESAMT-RC=0** (eigenstaendig nachgefahren, nicht nur Berichts-Zitat).
- **Greps**: `git grep 'E07_' 66de5c09` (hpp/cpp/cmake/sh/yml/CMakeLists) = **0 Dateien**; am Tip
  = 2 Dateien (Header 60 Zeilen, Test 56). super @ a7e8e151 ohne docs/external = **0**.
  Wirksamkeits-Gegenprobe `COMDARE_GOLDEN_N_RANGE` @ Basis mit exakt dem Berichts-Filter = **30**
  Treffer (Berichts-Zahl bestaetigt).
- **Registrierung**: `comdare_add_test(` in tests/unit/CMakeLists.txt Basis **245** → Tip **247**
  (= +2, Dedup-Gegenzaehlung); neuer Block Z.7576-7598, Datei endet Z.7598 → **DATEIENDE-Regel
  eingehalten, nichts folgt danach**.
- **Worktree/Remote**: `/home/comdare/wt-ce-trigfix` HEAD = 0f900dcf, porcelain **0**, `build/`
  NICHT vorhanden; `git ls-remote origin refs/heads/bau/trigfix` = **0f900dcf** (Ref gesichert).
- **CLU-Heilungs-Commit**: `c1c76c87` existiert, Datum **Thu Aug 6 15:31:50 2026**, Botschaft
  woertlich wie zitiert („die CLU-Kette bis zum LETZTEN Verbraucher geschlossen … B14-NB4,
  Landeblocker").

**Zwei Mengen (EIN gruenes Gate deckt nur seinen Gegenstand):** (A) Von MIR literal geprueft:
alles oben + alle Datei-Inhalte am Tip + Soll-Quellen-Anker. (B) NICHT von mir wiederholt (kein
Vollbau; Slot-Deckel 3 geteilt mit laufendem W1L-Kombibau, Audit-Mandat = git-show-Verifikation):
die ctest-Bilanz „512/512, #511/#512 Passed" und die gtest-Rot-Laeufe des Strangs — dafuer gilt
das Strang-Literal, von mir auf INNERE KONSISTENZ geprueft (s. Tafel P-09/P-14) und durch die
Standalone-Probe (A) semantisch gegengedeckt. Drei Geschwister-Straenge derselben Basis 66de5c09
bezeugen den 510er-Bestand unabhaengig (s19: 512 nach +2; messfenster: 511 nach +1; ph89: 511
nach +1).

---

## 1. PUNKT-FUER-PUNKT-TAFEL (P-01..P-19 der Soll-Karte, dreiwertig)

| P | Urteil | Beleg (Literal) |
|---|---|---|
| P-01 Gegenstand/Position/Blockade | **ERFUELLT** | V0=0 E07_-Treffer @ Basis (eigener Grep, Gegenprobe 30), V1>0 am Tip; Header existiert als `libs/cache_engine/profile_facade/e07_gate_kriterien.hpp` (A im name-status); Test registriert (CMakeLists 7583-7590, Labels `e07;gate;kriterien;b10;wachen;koeder` im Diff woertlich). `ctest -N`-Sichtbarkeit: Menge B, Strang-Literal `504/512 #511 … 505/512 #512 Passed` + statischer +2-Beweis. |
| P-02 K1-K5 UND N1-N3, 22(+1) Literale, fail-closed | **ERFUELLT** | `kPflichtLiterale` = `std::array<…, 23>` — nachgezaehlt K1:3, K2:1, K3a:3, K3b:3, K3c:2, K4:5, K5:2, N:4 = 23; die 22 Dossier-Namen 1:1 wortgleich gegen die Dossier-Tabelle (beide Fassungen gelesen), +1 = `E07_WINDOW_COUNT` (deklarierte B5.a-SCHAERFUNG, Header-Kopf nennt sie; „nur schaerfen/parametrisieren" im Dossier Abschn. 2 woertlich verifiziert). Fail-closed-Klassen ALLE implementiert und von meiner Probe gebissen (P2 23/23, P3-P6). GO nur bei `befunde.empty() && 23/23 && 10/10`, `go` default false. 10 Kriterien = `kKriterienNamen` K1,K2,K3a,K3b,K3c,K4,K5,N1,N2,N3. |
| P-03 Abgrenzung „implementiert" != „GO erbracht" | **ERFUELLT** | 5-Dateien-Diff enthaelt KEINEN Harness/Emitter (kein Aufrufer von `e07_gate_auswerten` ausser dem Test); Bericht Abschn. 8.1 deklariert B10-Beweislauf offen; getragen durch F-100 (STAFFEL2:190), G-1 (:228-230), Board #114. |
| P-04 R-13 Gegenstand/Frist | **ERFUELLT** | Beide Groessen adressiert, je eigene Erfuellungs-Klasse (P-05/P-06); geliefert 21.08. = vor JEDER Frist-Lesart (26.08. bzw. „vor erstem Batch" ab 29.08.). |
| P-05 CLU-64 | **ERFUELLT** (als Verifikation, deklariert) | Am Tip (echter Pfad `libs/cache_engine/include/cache_engine/measurement/system_axis.hpp`, CLU-Zweig ~:317-360): Nenner aus Snapshot `axis_stats[5][2]/[5][3]/[5][5]`, `cache_lines==0 \|\| line_bytes==0 → mark_source_unavailable()` („FAIL-CLOSED und mit Absicht" woertlich), Rechnung `(field_bytes*100u)/(cache_lines*line_bytes)` — **kein Literal 64 im Code** (einzige 64er nur in Historien-Kommentaren). Heilung = fremder Commit c1c76c87 (06.08., existiert, Botschaft verifiziert) — kein Code-Diff dieses Strangs, korrekt so (NICHT-GEFORDERT-Liste). Die 3 Verifikations-Tests existieren + sind registriert am Tip (test_b14_layout_scan_line_subaxis: 8 CMake-Treffer; test_clu_per_layout :2624; test_m_contract_system_axis_wurzel :5092ff). Gruen-Laeufe: Menge B (Strang-Literale „ALLE OK"/„PASSED 14"). |
| P-06 Peak-Schreiber-Zensus | **ERFUELLT** | Eigener Voll-Grep `bytes_in_use_peak` am Tip deckt den 6er-Zensus: (1) `measurement_snapshot.hpp:145` = `axis_stats[6][1]` + B7-DEKLARATION :69-76 woertlich („FEHL-ETIKETTIERUNG, hier DEKLARIERT", A8-Auflage 3); (2) WIDE `cache_engine_builder_iterator.hpp:706/:716` + n/a-Zellen ~:903-905 (`zelle_sep("n/a")` x3); (3) `system_axis.hpp:361ff` MEMORY_FOOTPRINT → SourceUnavailable; (4) f15 Pfad A :614/:628 honest-0; (5) f15 Pfad B :413-415 `serialize_measurements_pipeline16_csv` (traegt deklarierten POD); (6) `experiment_demo.hpp` — gefixt. KEIN weiterer Wert-URSPRUNG gefunden; restliche Treffer sind Konsumenten/Schema-Namen (result_aggregator-Serialisierung, `tools/latex_anhang/main.cpp:94` CSV-Leser = KK-9-P-5-Doku-Rest, Ledger:25480, GETRAGEN; ABI-Felddeklaration; schema_freeze/pipeline_csv_schema-Namenslisten). |
| P-07 Demo-Fix live/peak | **ERFUELLT** | Diff literal: `live_bytes_in_use += value_size_bytes; peak = max(peak, live)` NUR bei erfolgreichem Insert (`if (p)`), `live -= …` NUR im nicht-leeren Erase-Zweig (kein Unterlauf), Zuweisung `record.bytes_in_use_peak = peak_bytes_in_use` ersetzt `stats.total_bytes_allocated`; `bytes_allocated` bleibt korrekt kumulativ. Test: Strom MIT Freigaben, live 1,2,3,2,1,2 → soll_peak=384 < soll_total=512 (**EXPECT_LT peak < bytes_allocated = der Biss**), plus monotoner Gegen-Strom (peak==total NUR ohne Freigabe) und Read/Scan-Probe (peak unbewegt, op_count=5). Rot-Literal des Strangs („512 / soll_peak … 384", „actual: 512 vs 512") deckt sich EXAKT mit den Assertions am Tip. |
| P-08 Snapshot-POD unangetastet | **ERFUELLT** | `measurement_snapshot.hpp` NICHT im 5-Dateien-Diff (name-status literal); WIDE-n/a-Emission + Wache `test_a8s3_csv_klasse_c.cpp:146-154` (W5/C3: `alloc_bytes_in_use_peak` == SourceUnavailable-Token, „NIE '0'") am Tip verifiziert. Vorlage-Zeile (E-24/owner-gated) korrekt NICHT gebaut → F-103/O-B getragen. |
| P-09 T-1 ROT ZUERST | **ERFUELLT** | R-13: echtes Rot am unfixierten Objekt (Literal im Bericht, konsistent mit Test-Text am Tip — die alte Zuweisung ergaebe exakt 512 vs 384). R-12: Wegwerf-Mutation `go = true \|\| (…)` → „20 FAILED von 22"; von mir NACHGERECHNET: exakt 2 der 22 Tests asserten nur `EXPECT_TRUE(go)` (GruenesProtokoll…, TraegerLog…), alle uebrigen 20 mindestens ein `EXPECT_FALSE(erg.go)` → 20/22-Arithmetik stimmt am Objekt. |
| P-10 T-2 AUSSAGE | **ERFUELLT** | Exakte Wert-Assertions am Tip: `EXPECT_EQ(kriterien_erfuellt, 10)`, `EXPECT_EQ(literale_vorhanden, 23)`, Ausgabe-Substrings `…=10/10`, `…=23/23`, `EXPECT_EQ(peak, 384)`, Befund-Klassen-Texte (UNGUELTIG/UNBEKANNT/KONFLIKT/WERTEBEREICH) — keine reinen Existenz-/Absturz-Proben. |
| P-11 T-3 NENNER FREMD | **ERFUELLT** | GRUEN-Protokoll = 23 HANDGESCHRIEBENE Zeilen im Test (nicht generiert); Nenner 10/23 als eingefrorene Literale mit Dossier-Kommentar; soll_peak/soll_total aus dem Op-Strom hergeleitet (Kommentar + Arithmetik im Test). Die Entfernungs-SCHLEIFE iteriert zwar `e07::kPflichtLiterale` (Pruefling), aber jede Header-Drift risse das handgeschriebene 23-Zeilen-Protokoll (FEHLT- bzw. UNBEKANNT-Befund) → fremder Anker haelt. |
| P-12 T-4 GEGENEINGANG | **ERFUELLT** | Je Kriterium >=1 beissender Verstoss am Tip nachgelesen: K1-Bruch + K1-Nullfenster, K2=3, K3a=2, Delta-0-UNGUELTIG (woertlicher Befund-Check), K3b ohne Delta, ID-Set-Bruch beisst K3b UND K3c (`kriterium_erfuellt[3]` UND `[4]`), K4 off-by-one + done=2, K5=0, N1=1, N2=1, N3=1; Gegeneingaenge abc/leer/-1/0x10/„ 1 2"/ohne-`=`, Flag=2, Konflikt-vs-identisches-Doppel, Echo-Rueckeinspeisung. |
| P-13 T-6 SCHWESTERPFLICHT | **ERFUELLT** | Der 6er-Zensus (P-06) IST die Schwesterpflicht, von mir per Voll-Grep gegengeprueft (kein 7. Wert-Ursprung). R-12: T-6 sachlich nicht anwendbar (Neubau) — konsistent keine Behauptung. |
| P-14 T-7 REGISTRIERUNG | **ERFUELLT** (statisch) / Menge B (Laufzeit) | Block am DATEIENDE (7576-7598, Datei endet 7598); +2 `comdare_add_test` (245→247); Labels gesetzt. `ctest -N`/Bilanz 510→512: Strang-Literal + 3 Geschwister-Zeugen derselben Basis. |
| P-15 T-8 ATOMAR | **ERFUELLT** (a) / korrekt OFFEN (b) | (a) EIN Commit (rev-list --count = 1), Test+Fix+Registrierung atomar. (b) development-Landung = Lande-Zug mit K17-Kombibau (W2-ABFOLGE-DESIGN:12-13 woertlich verifiziert „CI ist nie Erstpruefung") — nicht Pflicht dieses Strangs; Bericht 8.4 deklariert es. |
| P-16 T-11c MUTATION | **ERFUELLT** | Soll-Karten-Massstab „>=1 ECHTE Mutationsprobe je TESTPAKET mit literalem Rot + Revert-Gruen": Paket e07 = Immer-GO-Mutation (20/22 rot → 22 gruen), Paket e8 = echtes Tag-1-Rot (die staerkere T-1-Form; der Bestand WAR der Mutant). Beobachtung (kein Fund, da Massstab erfuellt): die 2 GRUEN-Seite-Tests des e07-Pakets und e8-Tests 2/3 (am unfixierten Objekt gruen geboren) tragen keinen EIGENEN Mutations-Beleg — Kandidat fuer den T-9-Codex-Pass der Folgewelle. |
| P-17 T-9 TESTKRITIK | **OFFEN (Folgewelle, nicht diesem Strang anrechenbar)** | Dieses Audit ist die erste unabhaengige Pruef-Instanz (Standalone-Bissprobe + Code-Durchsicht = Teil-Einloesung); der formale Codex-Pass der Folgewelle bleibt als Pflicht bestehen. |
| P-18 K13 beidseitig | **ERFUELLT** | GRUEN-Nenner (Probe P1 + Tests 1/2) UND ROT-Seite (leer + 23/23 Einzelentfernungen + Kriteriums-Koeder + Form-Gegeneingaenge) — beide Richtungen literal, von mir unabhaengig reproduziert (P1/P2). |
| P-19 Fail-closed | **ERFUELLT** | Alle 7 Klassen implementiert; meine Probe beisst 4 davon direkt (P3 leer, P4 Echo, P5 Wertebereich, P6 Delta-0), Entfernung=FEHLT via P2; UNBEKANNT/KONFLIKT/UNLESBAR im Test am Tip nachgelesen. „Kann nicht pruefen → nie gruen" strukturell erfuellt (`go` default false, GO nur als bewiesene Konjunktion). |

**NICHT-PRUEFBAR:** keiner der 19 Punkte. (Die Laufzeit-Bilanzen sind als Menge B deklariert,
nicht NICHT-pruefbar — sie sind am Objekt konsistent belegt und durch Menge A semantisch gedeckt.)

---

## 2. GOAL-Doktrinen (b)

- **ASCII-only neue Zeilen**: ERFUELLT (0/692, Positiv-Kontrolle 116 — eigene Messung).
- **allow_failure/JOB-Ebene**: nicht beruehrt — Diff enthaelt keine YAML (ERFUELLT durch Enthaltung).
- **TABU-Zonen**: ERFUELLT — 0 Dateien unter axes/ topics/ heuristik/ organ_axes/ im Diff; golden
  byte-unberuehrt (keine golden-Datei im Diff); tests/unit/CMakeLists.txt NUR Dateiende;
  .gitlab-ci.yml unberuehrt.
- **Ledger-/Board-Schreibverbot**: ERFUELLT — ce-Diff kann den super-Ledger nicht tragen und
  enthaelt keine docs/; Ledger-ENTWURF liegt korrekt nur im Strang-Bericht (Abschn. 6).
- **clang-format-22**: ERFUELLT, 4/4 CF-OK (eigener Nachlauf).
- **K13-Random-Koeder-Nuance**: die Koeder sind strukturierte Protokoll-Verstoesse (fuer einen
  arithmetischen Gate-Pruefer die tragfaehige Form; urandom-Klasse ist durch die
  UNLESBAR-Gegeneingaenge abgedeckt) — Praxis aller Geschwister-Straenge, kein Delta.

## 3. Abnahme-Formeln (c) — woertlich gehalten?

1. **„Kriterien implementiert"** (W2-ABFOLGE:473): JA — Pruefer + 22 Wachen-Tests + Registrierung;
   GO-Formel des Dossiers (K1-K5 UND N1-N3, je Familie eine GUELTIGE Differenz-Probe,
   Delta-0=UNGUELTIG) 1:1 im Code (K3a/b/c einzeln gefuehrt, Schrumpf-Pflicht, UNGUELTIG-Befunde).
2. **„beide Groessen wahr/deklariert"** (W2-ABFOLGE:475): JA — CLU-64 WAHR (am Objekt verifiziert,
   fail-closed n/a-Zweig); bytes_in_use_peak: alle 6 Schreiber WAHR (demo, jetzt) oder
   DEKLARIERT/EHRLICH (B7-POD, WIDE n/a, SourceUnavailable, honest-0, POD-Traeger) — kein stiller
   Fehlwert verbleibt.
3./4. **Wellenplan 2646/2647** („vor 26.08."): geliefert 21.08. — erfuellt in beiden Frist-Lesarten.
5./6. **Ledger-GO-Kriterium/Dossier**: als PRUEFER erfuellt; das GO-VERDIKT selbst haengt am
   B5.b-Emitter (#114) — genau die von der Abnahme-Formel gedeckte Abgrenzung.
7. **„vor dem ersten Batch"** (Ledger:24743): erfuellt (s. 3./4.).
8. **T-1-Formel** (Designplan:67): erfuellt (echtes Rot bzw. protokollierte Mutation, s. P-09).
9. **Fail-closed-Formel** (GOAL:305-308): erfuellt (s. P-19, Probe-Literale).
10. **K17-Kombibau** (W2-ABFOLGE:12-13): bindet den LANDE-Merge — hier korrekt nur
    gcc-Release-Kette; als Lande-Pflicht gelistet (s. 5.).

## 4. Bericht-Stichproben (d) — Behauptungen am Objekt

ALLE gezogenen Stichproben HALTEN: 1 Commit/5 Dateien/Basis 66de5c09 (git-Literale) · E07_ ce+super
0 Treffer · GOLDEN_N_RANGE=30 · 23 Literale/10 Kriterien (Array-Zaehlung + Probe) · 22 Tests
(TEST-Makro-Zaehlung) · 20-von-22-Mutations-Rot (Struktur-Nachrechnung) · +2-Registrierung am
Dateiende · CF-GRUEN (nachgefahren) · [new branch]-Push (ls-remote=0f900dcf) · porcelain 0 ·
build/ entfernt · B7-/WIDE-/a8s3-/f15-Zensus-Zitate (alle Fundstellen nachgelesen) · c1c76c87
(Datum+Botschaft) · Dossier-Identitaets-Behauptung (Kriterien-Kern beider Fassungen wortgleich,
Soll-Karte hatte es bereits gegengelesen; von mir am Backup-Dossier Z.36-64 + Sessions-Dossier
erneut bestaetigt). **0 Behauptungen gefallen.**

## 5. Getragene OFFENE Posten (KEINE Funde — bereits im FINDINGS-Bestand/Board)

- **B10-BEWEISLAUF B5.b (Emitter)** — F-100 (TEIL)/G-1, Board **#114**, FRIST vor Trigger Mi
  26.08. 06:00 (trigger-blockierend). Der Pruefer steht; das GATE ist damit NICHT „GO".
- **Peak-POD-Quelle** (Wire-Slot/Zeitreihe, ABI/E-24, owner-gated) — F-103/O-B.
- **KK-9 P-5 Doku-Rest** (latex_anhang liest die deklarierte POD-Spalte nach Namen) — Ledger:25480,
  stehend, kein trigfix-Delta.
- **Karten-Hygiene** rest_karte_r3 C5 als GEHEILT fuehren — F-101 (Phase-5-Konsolidierung).
- **T-9-Testkritik der neuen Tests** in der Folgewelle (P-17; inkl. der P-16-Beobachtung).
- **Lande-Hinweise** (Lande-Zug, STAFFEL2:127): H-9 (CMakeLists-Dateiende-Harmonisierung ueber
  alle S1+S2-Bloecke) + H-16 (profile_facade/-Ordner mit s19/ph89 — alles NEUE Dateien, additiv);
  K17-Kombibau am Merge-Stand.

## 6. FUNDE

**KLEIN-1 — Latenter Endlos-Schleifen-Pfad im Test-Helfer `ersetze()`**
(`tests/unit/test_e07_gate_kriterien.cpp`, Helfer `ersetze`, Zeile `pos = nl + 1;`): endet die
Eingabe NICHT mit `\n`, liefert `find('\n', pos)` npos, `pos = npos + 1` ueberlaeuft zu 0 → die
Schleife laeuft endlos und `out` waechst unbegrenzt. HEUTE UNERREICHBAR: `gruen_protokoll()` endet
mit `\n`, `ersetze` haengt jedem Ersatz selbst `\n` an, alle Aufrufstellen sind terminiert (deshalb
KLEIN, kein Verhaltens-Defekt am Objekt; dieselbe Kopie lebt bewusst in meiner Audit-Probe).
FIX-WEG: im Lande-Zug oder T-9-Pass eine Zeile haerten —
`pos = (nl == std::string::npos) ? proto.size() : nl + 1;` (Datei
`tests/unit/test_e07_gate_kriterien.cpp`, Symbol `ersetze`, eine Zeile; kein Bau-Ereignis, Test
bleibt semantisch identisch).

Keine ERNST-, keine MILD-Funde. Kein Phantom aus NICHT-GEFORDERT (Emitter, T-11b-Quadmatrix,
POD-Peak-Quelle, CLU-Code-Fix, T-11a/T-12a-e, YAML, Ledger-Eintrag — alle als nicht gefordert
verifiziert, s. Soll-Karte, von diesem Audit bestaetigt).

## 7. Spannungen der Soll-Karte — Audit-Sicht

1. **CLU-Staleness der Planquelle** (Karte 17.08. vs. Heilung 06.08.): am Objekt bestaetigt
   (c1c76c87 zwei Tage VOR Wellenplan-Datum); Strang hat korrekt verifiziert statt doppelt gebaut.
   Traeger: F-101/Karten-Konsolidierung. Kein Fund.
2. **B10-Checklisten-Wortlaut generisch** (Ledger:27196) vs. Nachbuchung (Ledger:25370-25379): beide
   Stellen von mir gelesen — additiv, kein Widerspruch; Stolperfalle bleibt dokumentiert. Kein Fund.
3. **R-13-Frist-Unschaerfe** (Spalte 26.08. vs. „vor erstem Batch"): praktisch folgenlos (geliefert
   21.08.). Kein Fund.
4. **Zwei Dossier-Fassungen**: Kriterien-Kern wortgleich (von Soll-Karte gegengezaehlt, von mir an
   den 22 Literal-Namen erneut geprueft). Kein Fund.

## 8. Fazit

Der Strang liefert exakt den beauftragten Zuschnitt (R-12 Kriterien-Pruefer + R-13
Verifikation/Heilung), haelt alle anwendbaren TDD- und GOAL-Pflichten, deklariert alle
Abgrenzungen selbst und traegt keine falsche Beweis-Behauptung. **SITZT** — landereif im
S2-Lande-Zug (Reihenfolge-Hinweise H-9/H-16 beachten); der trigger-blockierende Folge-Posten ist
ausschliesslich #114 (B5.b-Emitter, vor Mi 26.08. 06:00).

---

## ANNEX — WIEDERANLAUF-VERIFIKATION 22.08.2026 (unabhaengige Re-Derivation, frische Literale)

Anlass: die Runde-1-Instanz vom 21.08. hat den Bericht fertig persistiert (19:01), aber kein
Schema-Ergebnis mehr zurueckgegeben (Abriss-Klasse wie LEAD-ENTSCHEIDE Nr. 19, Fable-Kontingent).
Doktrin „kein Haken ohne eigenen literalen Output": ALLE tragenden Beweise wurden am 22.08. FRISCH
erhoben, nicht aus Runde 1 uebernommen. Objekt unveraendert: `bau/trigfix` @ `0f900dcf…3d2bcbe3`,
`merge-base 66de5c09..tip == 66de5c09`, 1 Commit, 5 Dateien (+687/−2), Trailer
`Co-Authored-By: Claude Fable 5 <noreply@anthropic.com>` im Commit-Body literal.

### A1. Frische Literale (alle 22.08. neu gefahren)

- **Standalone-Bissprobe RE-DERIVIERT**: Header FRISCH vom Tip extrahiert nach
  `probe/rerun-20260822/`; sha256 `3369e880f42a4921…` == Runde-1-Kopie (byte-identisch);
  Neukompilat `g++ -std=c++23 -Wall -Wextra -I libs/cache_engine` → **COMPILE-RC=0**; Lauf:
  `P1 GRUEN: go=1 kriterien=10/10 literale=23/23 befunde=0` · `P2 ENTFERNUNG: 23/23` ·
  `P3 LEER: go=0 nenner_0_23_in_ausgabe=1` · `P4 ECHO: go=0` · `P5 FLAG=2: go=0` ·
  `P6 DELTA-0: go=0 ungueltig_befund=1` · `AUDIT-PROBE-ERGEBNIS: ALLE OK (fehler=0)` /
  **RUN-RC=0** (persistiert: `probe/rerun-20260822/audit_probe_e07_rerun_ausgabe.log`).
- **ASCII**: 687 Add-Zeilen (`grep '^+'` ohne `+++`), **0 Nicht-ASCII**, Positiv-Kontrolle 116
  E07_-Zeilen. PRAEZISIONS-KORREKTUR zur Runde-1-Zahl „692": die 692 enthielt die 5
  `+++`-Diff-Kopfzeilen (687+5); die Substanz (0 Nicht-ASCII) ist identisch.
- **clang-format-22**: 4/4 `CF-OK`, `CF-GESAMT-RC=0` — frisch im Worktree `wt-ce-trigfix`
  (HEAD im selben Kommando bestaetigt = 0f900dcf).
- **Greps/Refs**: `git grep -l 'E07_'` @ Basis (hpp/cpp/cmake/sh/yml/CMakeLists) = **0 Dateien**,
  @ Tip = **genau 2** (Header+Test); `ls-remote origin refs/heads/bau/trigfix` = **0f900dcf**.
- **Registrierung**: `comdare_add_test(` **245 → 247**; Tip-Datei endet Z. **7598** mit dem
  trigfix-Block (tail-3 literal = e8-LABELS-Zeilen) → DATEIENDE-Regel bestaetigt.
- **Peak-Zensus per eigenem Voll-Grep am Tip**: 6 Wert-Urspruenge wie im Bericht
  (`measurement_snapshot.hpp:145` END-Wert + B7-Deklaration :74 · WIDE `:716`
  `;alloc_bytes_in_use_peak;…` · `system_axis.hpp:362` MEMORY_FOOTPRINT→SourceUnavailable ·
  f15 `:614/:628` honest-0 · f15-Pfad B ueber den deklarierten POD-Serializer `:230/:264` ·
  `experiment_demo.hpp:91` = `peak_bytes_in_use` FIX); **kein 7. Wert-Ursprung** — Resttreffer
  sind Konsumenten/Schema-Namen (result_aggregator :43/:44/:74/:96, ABI-Felddeklaration,
  pipeline_csv_schema/schema_freeze-Namenslisten, latex_anhang :94 = KK-9-P-5-Doku-Rest,
  Ledger:25480 GETRAGEN).
- **CLU am Tip**: `system_axis.hpp` CLU-Zweig rechnet
  `(field_bytes*100u)/(cache_lines*line_bytes)` aus `axis_stats[5][2]/[5][3]/[5][5]`;
  `cache_lines==0 || line_bytes==0 → mark_source_unavailable()` („FAIL-CLOSED und mit Absicht"
  woertlich); **kein 64-Literal im Code** (nur Historien-Kommentar). **VERSCHAERFUNG gegenueber
  Runde 1**: `git merge-base --is-ancestor c1c76c87 66de5c09` → **ANCESTOR-VON-BASIS=JA** — die
  Heilung liegt IN der Strang-Basis selbst (Datum `Thu Aug 6 15:31:50 2026`, Botschaft woertlich
  verifiziert); die Karten-Staleness (SPANNUNG 1) ist damit git-topologisch bewiesen.
- **Wachen/Registrierungen am Tip**: a8s3-W5 literal („`alloc_bytes_in_use_peak` … NIE '0'",
  `sample_status_token(SourceUnavailable)`), CLU-Verifikations-Trio registriert
  (`test_clu_per_layout` :2624 · `test_m_contract_system_axis_wurzel` :5092ff ·
  `test_b14_layout_scan_line_subaxis` :6592ff).
- **API-Kreuzprobe e8-Test** (neu in diesem Annex): `run_single_experiment(std::string const&,
  std::uint64_t, Strategy&, std::span<Operation const>, std::uint32_t)` am Tip == Test-Aufruf;
  `struct Operation {OperationKind op; std::uint64_t key_id; std::uint32_t scan_length}` ==
  Aggregat-Init des Tests; `OperationKind` Insert=2/Erase=5/Read=0/Scan=3 vorhanden;
  `a01_hoard/hoard_adapter.hpp` existiert am Tip (`git cat-file -e` = JA).
- **Soll-Quellen-Anker frisch**: Ledger 25375-25377 (B10-Nachbuchung) · 24743 (R-13-Ursprung) ·
  27196 (B10 generisch) · 25480 (KK-9 selbst-entlastet) · 27226 (A8-S3-Owner-Entscheid) ·
  26501 (CLU-Haertest-Befund) — alle 6 Fenster woertlich wie zitiert; beide Dossier-Fassungen:
  GO-Kriterium wortgleich (Backup :64, zweistufig :82), 22-Literal-Kern identisch nachgezaehlt.
- **Mutations-Arithmetik selbst nachgerechnet**: exakt 2 der 22 e07-Tests tragen KEIN
  `EXPECT_FALSE(…go)` (GruenesProtokoll…, TraegerLog…) → Immer-GO-Mutation muss exakt **20/22**
  rot machen; deckt das Strang-Literal „20 FAILED TESTS von 22".
- **FINDINGS-Gegenprobe**: STAFFEL1-SYNTHESE = **0** Treffer trigfix/E-07/bytes_in_use_peak/CLU
  (negatives Ergebnis); STAFFEL2 traegt F-100(TEIL)/F-101/F-102(BEHOBEN)/F-103(OWNER), G-1, O-B,
  H-9/H-16 — alles GETRAGEN, nichts davon hier als Fund gedoppelt.

Menge B unveraendert (deklariert, nicht re-gefahren): die ctest-Bilanz „512/512, #511/#512
Passed" und die gtest-Rot-Laeufe des Strangs — semantisch durch die Standalone-Probe gedeckt,
statisch durch +2-Registrierung und die 3 Geschwister-Zeugen derselben Basis; der bindende
Laufzeit-Beweis der LANDUNG ist der K17-Kombibau am Merge-Stand (W2-ABFOLGE:12-13).

### A2. Zwei ZUSAETZLICHE KLEIN-Funde (eigene Code-Lektuere 22.08.; beide unerreichbar im
heutigen Verhalten, beide Ein-Zeilen-Haertungen fuer den Lande-Zug/T-9-Pass)

**KLEIN-2 — `setze()`-Lambda indexiert bei unbekanntem Kriteriums-Namen out-of-bounds**
(`libs/cache_engine/profile_facade/e07_gate_kriterien.hpp`, `e07_gate_auswerten` Phase 3):
`std::find(kKriterienNamen…, name)` ohne end()-Guard; ein Name ausserhalb der 10er-Liste ergaebe
`idx==10` → Schreiben auf `kriterium_erfuellt[10]` (UB). HEUTE UNERREICHBAR: alle 10 Aufrufe
sind Compile-Zeit-Literale aus exakt der Liste („K1"…„N3"). FIX-WEG: eine Zeile
`if (it == kKriterienNamen.end()) return;` (oder `assert`) vor dem Index-Zugriff — Datei
e07_gate_kriterien.hpp, Symbol `setze`, kein Verhaltens-Delta, Neukompilat einer TU.

**KLEIN-3 — Tippfehler „Unguelig" im Testnamen** (`tests/unit/test_e07_gate_kriterien.cpp`,
`TEST(E07GateKriterien, AntiScheinGruenDeltaNullProbeIstUnguelig)` + lokale Variable
`unguelig`): fehlendes „t" (soll „Ungueltig"). REIN KOSMETISCH — die gepruefte Befund-Zeichenkette
„UNGUELTIG" ist korrekt geschrieben, die Wache beisst (Probe P6 frisch bestaetigt). FIX-WEG:
Rename beider Bezeichner im T-9-Pass (Symbol-Umbenennung, kein Semantik-Delta; ctest-Name des
Binaries bleibt `test_e07_gate_kriterien`, Bilanz unveraendert).

### A3. Annex-Fazit

Runde-1-Verdikt in allen Punkten BESTAETIGT und an einer Stelle VERSCHAERFT (c1c76c87 =
Ancestor der Basis). P-01..P-16, P-18, P-19: ERFUELLT mit frischen Literalen; P-17 OFFEN
(Folgewelle, strukturell). **VERDIKT bleibt SITZT** (0 ERNST, 0 MILD, 3 KLEIN). Getragene
OFFENE Posten unveraendert: #114/G-1 (trigger-blockierend, vor Mi 26.08. 06:00), F-103/O-B
(owner-gated), F-101-Karten-Hygiene, T-9-Folgewellen-Pass (nimmt KLEIN-1..3 mit), K17-Kombibau
im Lande-Zug.

---

## ANNEX 2 — DRITTE AUDIT-INSTANZ 23.08.2026 (formale Tafel-Uebernahme P-07a/S-5/S-6 + eigene Tiefen-Messung)

Anlass: die Soll-Karte traegt seit ihrer Runde 2/3 (22./23.08.) drei "[NEU ggue. Runde 1]"-Stellen
(P-07a, SPANNUNG 5, SPANNUNG 6), die der Haupttext + Annex 1 dieses Audits zeitlich nicht mehr
erreichen konnten; ihre Runde 3 empfiehlt ausdruecklich die FORMALE Uebernahme in die P-Tafel.
Diese dritte Instanz hat ALLE tragenden Kern-Literale frisch erhoben (nicht uebernommen) und die
SPANNUNG-5-Empfehlung ("pruefen, ob PermutationResult/memory_ratio in die produktive
Kampagnen-Kette eingespeist wird") mit einer EIGENEN, TIEFEREN Objekt-Messung beantwortet.

### B1. Objekt-Stand unveraendert (frische Literale 23.08. spaet)

- `git log --oneline -1 0f900dcf` = `feat(w2-trigfix): R-12 E-07-Gate-Kriterien ausfuehrbar +
  R-13 bytes_in_use_peak wahr (E-7/E-8)`; `rev-list --count 66de5c09..0f900dcf` = **1**;
  `diff --stat` = **5 Dateien, +687/−2** (name-status: 3xA, 2xM, wortgleich zu Runde 1).
- `ls-remote origin refs/heads/bau/trigfix` = **0f900dcf405578c8406edf2edc63d1ee3d2bcbe3**;
  `git worktree list` zeigt `/home/comdare/wt-ce-trigfix` @ 0f900dcf.
- Commit-Body traegt den Trailer `Co-Authored-By: Claude Fable 5 <noreply@anthropic.com>`
  (grep-Zaehler = 1).
- ASCII: 687 Add-Zeilen (ohne `+++`-Kopfzeilen), `grep -cP '[^\x00-\x7F]'` = **0**.
- Registrierung: `comdare_add_test(` Basis **245** -> Tip **247**; Tip-Datei endet Z. **7598**
  mit den e8-LABELS-Zeilen des trigfix-Blocks (tail-25 literal nachgelesen) — DATEIENDE-Regel.
- Standalone-Bissprobe FRISCH GELAUFEN (persistiertes Binary `probe/rerun-20260822/`):
  `P1 GRUEN: go=1 kriterien=10/10 literale=23/23 befunde=0` … `AUDIT-PROBE-ERGEBNIS: ALLE OK
  (fehler=0)`, **PROBE-RC=0**; Header-Hash am Tip `3369e880f42a4921…` == persistierte Kopie
  (byte-identisch, sha256 beidseitig frisch).
- Ledger-Tail (letzte 400 der jetzt 32387 Zeilen): **0** Treffer
  `trigfix|R-12|R-13|E-07|B10|#114` — keine Nachbuchung seit der Soll-Karten-Runde 3.
- STAFFEL2-Fenster frisch nachgelesen: F-100 (TEIL/B10-Beweislauf OFFEN, G-1) · F-101
  (GEHEILT/Karten-Konsolidierung) · F-102 (BEHOBEN) · F-103 (OWNER-GATED) · Lande-Reihenfolge
  Schritt 8 = `bau/trigfix` (H-16 + H-9; additiv) — deckungsgleich mit Abschnitt 5.

### B2. Formale Tafel-Uebernahme (Erweiterung der P-Tafel aus Abschnitt 1)

| P | Urteil | Beleg (Literal, eigene Erhebung 23.08.) |
|---|---|---|
| P-07a B10/B-10-Namenskollision | **ERFUELLT** (Strang zieht die Trennung korrekt) | Eigener Grep: Wellenplan Z.**2430** = `B-10  Hybrid: Tier-Bau/-Laden IMMER durch die CEB delegiert; Standard-compare->release VOR …` — sachfremder Korb-B-Posten (§19.2); der Strang-Bericht zitiert durchgehend NUR die VOR-TRIGGER-CHECKLISTE/E-07-Linie (Ledger 25375/27196), nie die Hybrid-Delegation. Fallstrick dokumentiert, kein Fund. |
| S-6 Kl.-Legende (P) vs. Tabellenfrist | **ERFUELLT** (dokumentierte Quellen-Reibung, kein Fund) | Eigenes Fenster: Wellenplan Z.**1443-1444** woertlich `(P) PREIMAGE-WIRKSAM aendert die SHA JEDER Binary -> MUSS vor F2 (Fr 21.08.) …`; Z.**2646-2647** tragen fuer R-12/R-13 die Klasse `P` MIT Tabellenfrist `vor 26.08.` (die (M)-Frist-Formel). Operative Lesart der juengeren Schicht (W2-ABFOLGE Slot E "S4 … vor 06:00") gewinnt; Lieferung 21.08. erfuellt ohnehin BEIDE Lesarten. |
| S-5 Produktions-Reichweite experiment_demo | **ERFUELLT mit PRAEZISIERUNG** (eigene Tiefen-Messung, s. B3) | `run_single_experiment`: weiterhin 0 Aufrufer ausserhalb tests/ (einziger Nicht-Test-Treffer `abi/resolve_baustein.hpp:13` ist ein KOMMENTAR, kein Include — nachgelesen). Der Demo-Fix erreicht keine produktive CSV; die R-13(b)-Batch-Dringlichkeit lag am Demo-Ort nicht vor. Fix bleibt inhaltlich richtig (Soll-Karten-Formel: "praezisieren, nicht zurueknehmen"). |

### B3. EIGENE TIEFEN-MESSUNG zu SPANNUNG 5: die PermutationResult-Kette ist produktiv erreichbar — aber ueber einen ANDEREN, nie befuellten Pfad

Die Soll-Karten-Empfehlung ("pruefen, ob PermutationResult/memory_ratio … in die produktive
Kampagnen-Kette (CSV/xlsx) eingespeist wird") beantwortet diese Instanz mit einer vollstaendigen
Ketten-Verfolgung am Tip (alle Literale frisch):

1. `apps/cache_engine_builder/main.cpp:183` instanziiert `comdare::builder::ExperimentDriver`
   (die CEB-App linkt `comdare_builder_experiment_driver`, CMakeLists:22).
2. `experiment_driver.cpp:489-506`: `comdare_measurement_record_v1 rec{};` (ZERO-INIT) ->
   `m->run_workload(inst, wl, &rec)` -> `pr.record = rec` -> `aggregator.add(...)`.
3. Die MODUL-Seite befuellt `bytes_in_use_peak` NIE: `git grep 'bytes_in_use_peak *='` am Tip
   liefert repo-weit NUR measurement_snapshot.hpp:145 (B7-deklariert), experiment_demo.hpp:91
   (der Fix), f15-Kommentar :614, latex_anhang :94 (Leser); die codegen-Template-Bodies
   (`art_body/b2tree_body/coco_trie_body.hpp.template`, "V16.3: minimaler Stub") schreiben nur
   `version`/`cycles_total`/ops — das Peak-Feld bleibt 0.
4. `result_aggregator.cpp` (execution_engine): `export_csv` emittiert `pipeline16_csv_header()`
   MIT blanker Spalte `bytes_in_use_peak` (Wert = die Zero-Init-0) nach
   `opts_.output_dir / "measurements.csv"` (experiment_driver.cpp:518); `compare_all` rechnet
   `memory_ratio` aus demselben Feld (`(base_mem > 0) ? … : 1.0` — bei 0-Basis ehrlich 1.0).
5. EINORDNUNG DER REICHWEITE (A-7-Kriterien des Ledger-Nachtrags 27398 angewandt): die CEB-App
   ist im CI NUR als Kommentar praesent (`.gitlab-ci.yml:736` — betrifft den Iterator-HEADER;
   das `contract:experiment_driver`-Gate baut/laeuft nur `test_experiment_driver_v13`, KEINE
   Mess-CSV). Die OFFIZIELLE Kampagnen-/Thesis-CSV entsteht in `profile_run_entry.hpp:786`
   via `ex::lazy_csv_header()` (WIDE) — dort ist `alloc_bytes_in_use_peak` EHRLICH "n/a"
   (Zensus-Stelle 2, Wache test_a8s3). Der experiment_driver-Export ist die ALT-Architektur
   (REV 7.6/V16.3-Stubs, System-B-Schicht; Ledger #193/#215-Umfeld), manuell startbar,
   ausserhalb des Trigger-/Batch-Pfads.

**Konsequenz fuer die bestehenden Behauptungen:** Die Zensus-Behauptung des Strangs ("alle
Produktiv-Schreiber") und die P-06-/Annex-Formulierung "kein 7. Wert-URSPRUNG" halten fuer
EXPLIZITE Zuweisungen an das Feld (frisch grep-bewiesen). Der hier vermessene Fluss ist KEIN
Schreiber, sondern ein NIE-BESCHRIEBEN-Export: die Zero-Init-0 des ABI-records wandert
unkommentiert als Zahl in die pipeline16-CSV/JSON des Alt-Treibers. Materiell dieselbe Klasse
wie f15-Pfad-A (honest-0) — dort DEKLARIERT (Anti-Phantom-Kommentar, P4-gated), hier ohne
Deklarationszeile. Strang-fremd (Bestand identisch an der Basis 66de5c09, nicht im Diff),
ausserhalb der Batch-Urgency, daher KLEIN, nicht MILD — aber zu fuehren, damit die
R-13-Formel "kein stiller Fehlwert verbleibt" auch fuer die dormante Kette dokumentiert ist.

### B4. NEUER FUND (aus der Tiefen-Messung; blockiert nichts)

**KLEIN-4 — Alt-Treiber-Export emittiert nie-befuelltes `bytes_in_use_peak` (Zero-Init-0)
undeklariert** (`libs/cache_engine/builder/experiment_driver/experiment_driver.cpp:489`
`rec{}` + `libs/execution_engine/src/result_aggregator.cpp` `export_csv`/`export_json`,
Spalte/Feld `bytes_in_use_peak`): im CEB-App-Weg (System-B-Alt-Kette, manuell startbar, kein
CI-/Batch-Pfad) traegt die phase7-`measurements.csv` eine numerische 0 unter Peak-Etikett, die
nie gemessen wurde — im Gegensatz zu f15-Pfad-A ohne honest-0-Deklaration am Ort. Kein
Strang-Delta (Bestand an der Basis), keine Batch-/Abnahme-Wirkung (offizielle Kampagnen-CSV =
WIDE, ehrlich n/a). FIX-WEG (Folge-/T-9-/Karten-Pass, kein Lande-Blocker): EINE
Deklarations-Kommentarzeile an `experiment_driver.cpp:489` (Muster f15 `:614`: "honest-0,
Alt-Treiber ohne Peak-Quelle; echte Quelle = E-24/B7-Aufloesungssatz") ODER, falls der
Alt-Treiber je reaktiviert wird, treibereigene live/peak-Zaehlung nach dem
experiment_demo-Muster in die Template-Bodies; zusaetzlich denselben Halbsatz in die
F-101-Karten-Konsolidierung aufnehmen.

### B5. Annex-2-Fazit

Alle drei Soll-Karten-Zusaetze sind jetzt FORMAL in der Tafel (P-07a, S-5, S-6 — je ERFUELLT
mit eigenem Literal); die SPANNUNG-5-Empfehlung ist mit einer vollstaendigen Ketten-Messung
beantwortet und hat einen vierten KLEIN-Fund geliefert (Alt-Treiber-Deklarations-Rest,
strang-fremd). Kern-Literale des Objekts am 23.08. erneut frisch bestaetigt (B1). **VERDIKT
bleibt SITZT** (0 ERNST, 0 MILD, 4 KLEIN — KLEIN-1..3 unveraendert, KLEIN-4 neu; alle vier fuer
den T-9-/Folge-Pass, keiner blockiert die Landung). Getragene OFFENE Posten unveraendert
(#114/G-1 vor Mi 26.08. 06:00 trigger-blockierend; F-103/O-B owner-gated; F-101; K17-Kombibau
im Lande-Zug; H-9/H-16 in der Lande-Reihenfolge Schritt 8).
