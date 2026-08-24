# AUDIT RUNDE 1 — Strang "s8kopf" (T-NEU-6 S-8-Traegerbau-KOPF)

Auditor: Fable-max (S1-Audit "s8kopf"), 22.08.2026. NUR-LESEN am ce-Hauptklon (git show/diff
gegen Branch-Refs); KEIN Schreibzugriff auf Objekt, Ledger, Board, Memory.

OBJEKT: ce Branch `bau/s8kopf` @ `41ee878056bd0388cd8bcf6472067e20192237c5`,
Basis `66de5c09` (merge-base literal bestaetigt: `git merge-base 41ee8780 66de5c09` =
`66de5c0972290ec1ae3d219988ecc207d8f5de6b`). Remote-Sicherung bestaetigt:
`git ls-remote origin bau/s8kopf` = `41ee8780... refs/heads/bau/s8kopf`.
Diff-Menge (git diff --stat 66de5c09..41ee8780): **8 Dateien, +1266/-5** — exakt die
Strang-Bericht-§5-Liste (3 Header traeger/planner + 2 Test-TUs + 3 CMakeLists).
Worktree-Endstand verifiziert: `/home/comdare/wt-ce-s8kopf` @ 41ee8780, porcelain leer (0 Zeilen).

EINGANG voll gelesen: soll-karte.md (597 Z., P-01..P-26 + Abnahme-Formeln + NICHT-GEFORDERT +
SPANNUNGEN) · traegerbau-s8-ergebnis.md (218 Z.) · LEAD-ENTSCHEIDE (87 Z.) · W2-ABFOLGE-DESIGN
C-5/C-6/C-7 (Z.200-220) + D-13 (Z.396ff) · STAFFEL1/2-SYNTHESE s8-Zeilen (F-15..F-19, H-15).

**VERDIKT: SITZT** (0 ERNST, 0 MILD, 2 KLEIN). Kein Fix-Commit noetig; die 2 KLEIN-Posten
sind Doku-/Protokoll-Notizen fuer den Lande-Zug, keine Code-Aenderung am Strang.

---

## 1. PUNKT-FUER-PUNKT-TAFEL (P-01..P-26, dreiwertig)

### Block A — Scope-Rahmen

**P-01 Nur "S-8 Teil 1", keine S-9/10/11-Substanz — ERFUELLT.**
Diff-Menge = exakt 8 Dateien (--stat literal oben); Gegen-Grep ueber den vollen Diff:
`CebSystemAxisDrive|Teilbaum-Serial|cursor_ruecklauf|ceb:build` = **0 Treffer**. Keine Datei
ausserhalb {libs/traeger/planner, tests/unit, apps/experiment_planner/CMakeLists.txt}.

**P-02 Vorbedingung C-5 (#29-Schnitt VOR S-8-Bau) — ERFUELLT.**
`git cat-file -e 66de5c09:libs/traeger/{planner,ceb,tier,hybrid}/CMakeLists.txt` = 4x OK
(Skeleton existiert an der BASIS, vor dem s8kopf-Commit). Wurzel-Anschluss am Tip:
CMakeLists.txt:741 `add_subdirectory(libs/traeger)` (vor apps/tests) — Berichts-Claim haelt.

**P-03 Fessel P1->P2 (S-3 gelandet, S-7 frei) — ERFUELLT (Vorbedingung, nicht Baugegenstand).**
Basis 66de5c09 = W1-Schlussstein der #15-Kette (Board #15 completed: Kette ...->66de5c09,
CI 16049 SUCCESS; S-7-Landung Board #4 completed, Merge d215b127 davor). Die C-6-Zeile
(W2-ABFOLGE-DESIGN:206) deklariert die Fessel selbst als erfuellt.

### Block B — B-01 Naht-Schablone

**P-04 Genau DREI Nachrichtenklassen hinauf, compile-hart — ERFUELLT.**
Objekt `naht_nachrichten.hpp`: `SteuerNahtHinaufKlassen = std::tuple<FortschrittsDelta,
StatusFehlerLog, ErgebnisTrace>` (geschlossene Whitelist, `ist_in_tupel`-Kern; Struktur-
Gleichheit genuegt NICHT). Erzwingung: Test-TU Z.114-115 `static_assert(std::tuple_size_v<...>
== kLedgerNachrichtenKlassenHinauf, "KON50-02: genau DREI Nachrichtenklassen hinauf")` —
das M1-Rot-Literal des Berichts ("Z.114") verankert exakt hier. T-3: die 3 steht als
Ledger-ABSCHRIFT-Konstante im Test, nicht aus dem Pruefling gelesen.

**P-05 NIE Mess-Rohdaten zum Planer — ERFUELLT, sogar mit EIGENEM Negativtest.**
Der Soll-Karten-Audit-Hinweis ("Garantie nur durch Bauart, kein eigener Negativtest") ist am
Objekt WIDERLEGT-im-guten-Sinn: Test-TU NEGATIVPROBE 1 `struct MessRohdatenPaket { ...
traegt_mess_rohdaten = true; double werte[8]; }` + `static_assert(!trg::SteuerNahtHinauf<
MessRohdatenPaket>, "KON50-01: Mess-Rohdaten fallen durch")` — ein expliziter T-4-Gegeneingang
der geforderten Form. Zusaetzlich traegt jeder Naht-Typ den Marker-Anker
`traegt_mess_rohdaten = false`, und der Concept prueft ihn als EIGENE Bedingung (Header-
Kommentar: Bruch wird "als EIGENE Verletzung sichtbar").

**P-06 Flaeche 1 hinab/hinauf getrennt — ERFUELLT.**
Richtungs-Tags `NahtHinauf`/`NahtHinab`, Hinab-Traeger `GefiltertesXmlFragment` (KON51-01)
mit eigenem Concept `SteuerNahtHinab`; Kreuz-Negativproben im Test (`!SteuerNahtHinauf<
GefiltertesXmlFragment>`, `!SteuerNahtHinab<FortschrittsDelta>`). OOB: GENAU EIN Typ
`FertigSignal` (KON52-01) mit Whitelist-Concept + Zweit-OOB-Negativprobe (`ZweitesOobSignal`
faellt durch). Nutzlast-Serialisierung korrekt NICHT gebaut (S-10, NICHT-GEFORDERT #4).

### Block C — B-14 Steuerdocks

**P-07 SECHS Docks, je CEB-Version — ERFUELLT.**
`SteuerdockRegistry::alle_ceb_versionen()`: Aufzaehlung per `std::next_permutation` ueber die
3-elementige `kToolingHauptKette` — die 6 ist ERGEBNIS, **kein 6-Literal im Header** (verifiziert:
einzige Instrument-Aufzaehlung ist das 3er-Array). Test zaehlt den Nenner FREMD (eigene
Owner-KERN-Abschrift {Wallclock,Makro,Mikro} + unabhaengige next_permutation-Zaehlung,
`ASSERT_EQ(fakultaet_gezaehlt, 6u)` mit Ledger-Z.17168-Zitat), prueft Eindeutigkeit (set),
Vollzaehligkeit (jede Anordnung = Permutation der Abschrift), Determinismus (2 Aufrufe
elementweise gleich) und Ordnungs-Gleichheit gegen die fremde Folge. M2-Literal ("Which is: 5"
vs "6" + "SECHS Steuerdocks -- je CEB-Version eines (B-14)") verankert an der realen
EXPECT-Message.

**P-08 Dock passt compile-hart GENAU / fremder Befehl ist KEIN CODE — ERFUELLT.**
Der Soll-Karten-Hinweis (kein dedizierter Mutations-Koeder) loest sich am Objekt: die
Eigenschaft ist als **compile-harte requires-Probe IM Test** gesichert, nicht bloss Bauart:
`static_assert(!DockZweifach::bietet_an<EinrichtungFremd>(), "Dock passt GENAU auf
Einkompiliertes")` + `static_assert(!KannFreigabe<DockZweifach, EinrichtungFremd>, "fremde
Einrichtung: Befehl ist kein Code")` + Gegenstueck fuer durchsetzung. Variadischer Kern am
Objekt: `template <class... Einkompiliert> class Steuerdock` mit
`requires(ist_einkompiliert<E, Einkompiliert...>)` an BEIDEN Rechtsakten.

**P-09 Zwei Rechtsakte NICHT austauschbar — ERFUELLT.**
Getrennte Typen ohne Basis/Konversion (`FreigabeSystemAchse`/`DurchsetzungOrganAchse`);
Test: `!std::is_convertible_v` beidseitig + requires-Proben "FREIGABE nimmt keinen
Durchsetzungs-Akt"/"DURCHSETZUNG nimmt keinen Freigabe-Akt" (getauschter Aufruf = kein Code).
Laufzeit-Protokoll-Probe `RechtsakteUndGesammelterRelease` (freigabe:target_isa /
durchsetzung:allocator_strategy in fixer Folge) — M3-Rot-Literal ("durchsetzung:target_isa")
verankert exakt an protokoll_[0]-Erwartung.

**P-10 Release NUR GESAMMELT — ERFUELLT (Timing-Eigenschaft EIGENSTAENDIG gesichert).**
Der Soll-Karten-Hinweis (T-2-Risiko "nur der Name") loest sich am Objekt: das Timing ist
compile-hart als Nicht-Repraesentierbarkeit gebaut UND getestet — `enum ReleaseFenster` kennt
NUR `VorGesamtMessung/NachGesamtMessung`; Test: `static_assert(!HatWaehrendGesamtMessung<
trg::ReleaseFenster>, "Release WAEHREND der Messung: kein Wert dafuer")` +
`!HatWaehrend<...>`. Einzelzeilen-Senden existiert als API nicht (nur
`release(GesammelterRelease const&)` — "unrepresentierbar statt verboten"); der Testkoerper
prueft den gesammelten Akt (2 Release-Zeilen in Entstehungsfolge).

**P-11 Docks vom Mess-Nenner ENTKOPPELT (KON41-03) — ERFUELLT.**
`steuerdock.hpp` importiert keinen Mess-Nenner (kein 2^5/32, kein S-19-Bezug; Kopf-Kommentar
"Diese Datei traegt darum KEINEN Mess-Nenner und importiert keinen"); die 6 entsteht allein
aus der 3!-Permutation der Tooling-ORDNUNG (KON34-03-Abgrenzung im Kopf ausgeschrieben).

**P-12 (= Spannung S-1) — kein Pruefpunkt, siehe Abschnitt 4.**

### Block D — B-16 Vier-Unterprojekt-Zielform

**P-13 Neubau in der Zielform, nicht im Monolithen — ERFUELLT.**
Alle 3 Header liegen unter `libs/traeger/planner/include/traeger/planner/` (Diff-Pfade
literal); `libs/traeger/planner/CMakeLists.txt` traegt `target_include_directories(
comdare_planner INTERFACE .../include)` + `cxx_std_23`; `apps/experiment_planner/CMakeLists.txt`
linkt `comdare_planner` ZUSAETZLICH zu `comdare::profile_run_facade` (R-01-Vorbereitung, kein
Ersatz — deklariert). Monolith-Diff: experiment_plan_director.hpp NICHT im Diff (0 Zeilen),
main.cpp NICHT im Diff (0 Dateien im Namens-Diff).

**P-14 Bruecken-Regel Par. 4.3 — ERFUELLT (leer erfuellt + Wache scharf).**
Die 3 neuen Header ziehen NUR std (Include-Zaehlung am Objekt: naht 5, steuerdock 7,
rakete 7 = **19 Include-Zeilen** — deckt das Grenzwache-Erstlauf-Literal "3 Quelldateien,
19 Include-Zeilen, 0 Verstoesse" ARITHMETISCH am Objekt); builder/-Includes in den Headern:
3x 0 Treffer => kein Marker noetig. Die Marker-Erzwingung lebt in der Wache (kMarker
`TRAEGER-BRUECKE(#88):`, M9-Mutation #88->#99 mit Rot-Literal an der realen
EXPECT-Message "markierte Bruecke ist erlaubt (gezaehlter #88-Posten)").

**P-15 Grenz-Wache Par. 4.4 als Google-Test + NE-16 — ERFUELLT.**
`tests/unit/test_s8_traeger_grenzwache.cpp` (248 Z. am Tip) existiert und ist registriert
(Block am DATEIENDE, s. P-19). Beide Regeln implementiert: (a) `ziel_stufe > stufe` =
stufen_inversion (M8 mutierte genau diesen Vergleich), (b) builder-Kante ohne Marker auf
Zeile/Vorzeile = bruecke_ohne_marker. Koeder BEIDSEITIG IM Test (WegwerfBaum, Koeder A/B mit
IDENTITAETS-Pruefung Datei+Zeile + Gegenproben inkl. erlaubter N+1->N-Richtung);
STILLE-NULL-GEGENPROBE (leerer Scan waere ROT: `EXPECT_GE(quell_dateien, 3u)` /
`EXPECT_GE(include_zeilen, 3u)`). NE-16: neue Tests sind reine gtest-ctest-Eintraege —
Gegen-Grep im Diff: `PASS_REGULAR_EXPRESSION` = **0**, keine YAML-Datei im Diff => beide
Wachen-Inventar-Nenner-Klassen (A/C) unberuehrt, wie deklariert. `COMDARE_TEST_TMP_BUILD_TAG`
ist verzeichnisweit definiert (Basis tests/unit/CMakeLists.txt:64) — Kommentar-Claim haelt.

### Block E — #22(ii) Debug-Neutralitaet

**P-16 Plan-Text byte-invariant unter COMDARE_DEBUG_FREIGABE — ERFUELLT.**
Test `S8KopfDebugNeutralitaet.DumpPlanTextByteInvariantUnterDebugFreigabe`: Lauf A
(unsetenv garantiert abwesend) vs. Lauf B (setenv "true" — exakt der CLI-Gate-Wert),
Thesis- UND Experiment-Zwilling (T-6), `EXPECT_FALSE(...empty())`-Nichtleer-Wachen (keine
leere-Gleichheit-Falle), Umgebungs-Restaurator (T-8). NAHT-DECKUNG verifiziert am Objekt:
beide `construct`-Ueberladungen tragen Default-Parameter (Director Z.2179/Z.2228:
`combo_selector = {}, ...`) — der 2-Arg-Testaufruf faehrt DENSELBEN Walk, den
`construct_plan_into` (profile_run_facade.cpp:1040, dump-plan-Aufrufstelle :1132) mit leeren
Defaults nimmt ("A5 combo leer=>Identitaet"); --dump-plan ist als "Director + PlanTextBuilder"
dokumentiert (profile_run_facade.hpp:259-Zone). M6 (Wegwerf am Monolith-begin_plan) bewies den
Biss; Endstand: Director im Branch-Diff = 0 Zeilen (byte-identisch zur Basis).

**P-17 Scope-Grenze PLAN-EBENE, CLI-stdout offen deklariert — ERFUELLT.**
Deklaration dreifach am Objekt (Test-TU-Kopf, Commit-Message, Bericht §6.2). main.cpp im Diff
unveraendert; der VL-3-Kommentar steht am Objekt bei main.cpp **Z.714-719** (Z.717-718:
"die stdout-Byte-Gleichheit mit/ohne --debug ist NICHT gemessen (Audit 17.08., VL-3-Restposten:
Bytevergleich = offener Pruef-Posten, Welle-2-Fix)") — der zitierte Anker ":721-726" trifft
den [debug]-stderr-Block direkt darunter (Z.720-723): Zitat-Drift ~4 Zeilen im selben Block,
Substanz-Behauptung haelt (=> FUND S8A-02, KLEIN). CLI-Ebene separat gedeckt durch Board #101
(completed) — kein Traeger-Verlust.

### Block F — Test-/Abnahme-Vertrag

**P-18 T-1..T-9 je neuem Test — ERFUELLT (Detail-Tafel in Abschnitt 2).**

**P-19 T-7 Registrierung NUR am DATEIENDE — ERFUELLT.**
Diff-Hunk beginnt bei Z.7574 (nach dem s6c-Block, dem letzten Bestandsblock) und haengt
59 Zeilen an; Datei-Ende am Tip = der s8-Block (Z.7576-7635 von 7635 Gesamtzeilen — tail
literal geprueft: beide `comdare_add_test`-Bloecke sind die letzten Eintraege, NICHTS folgt).
Kopf-TU spiegelt den Director-Include-/Define-Satz + `comdare_planner`; Grenzwache std-only +
`COMDARE_TRAEGER_WURZEL`-Define. ctest-Literale des Berichts ("Test #507/#508" vor J-1,
"511/512 ... Passed" + "512/512 ... Passed" nach voller Treppe) sind konsistent mit dem
Basis-Nenner 510, der von den Schwester-Straengen unabhaengig bestaetigt wird (s19: 512 mit
+2 · messfenster: 511 mit +1 · s8: 512 mit +2 — drei unabhaengige Berichte, ein Nenner).

**P-20 T-11b 4-Zellen-Kombibau — ERFUELLT-ALS-DEKLARIERT (Lande-Zug-Pflicht, kein Strang-Gap).**
Strang fuhr gcc-Release voll ("100% tests passed, 0 tests failed out of 512", CTEST-EXIT=0)
und deklariert T-11b explizit an den Lande-Zug (§6.5) — deckungsgleich mit Designplan Z.645
("Abnahme-Regel der LANDUNG, kein Einzeltest-Posten") und K17-Doktrin. Das Audit bucht T-11b
als OFFENE LANDE-PFLICHT des Merge-Endstands (traegt bereits: Staffel-Synthese H-1/K17).

**P-21 T-11c Mutations-Protokoll — ERFUELLT (9 Mutationen fuer 9 Testfaelle, uebererfuellt).**
Alle 9 Rot-Literale (M1-M9) verankern an REALEN Code-/Test-Stellen am Objekt (je geprueft):
M1 static_assert Z.114-115 · M2 `out.pop_back()`-Ziel `alle_ceb_versionen()` existiert +
EXPECT-Message wortgleich · M3 protokoll_[0]-Erwartung "freigabe:target_isa" · M4
`kFolgeCeb = {Tier, Hybrid}` + Message "erst Tier (Owner-Wort)" · M5 spur-Groesse 2 +
Message "je Emission: erst bauen, dann verifizieren" · M6 EXPECT-Message "#22(ii) verletzt:
der Thesis-Plan-Text haengt an COMDARE_DEBUG_FREIGABE (leitet um)" + Experiment-Zwilling ·
M7 ADD_FAILURE-Format `grund << ": " << datei << ":" << zeile << " -> " << ziel` produziert
exakt das zitierte "stufen_inversion: ...:159 -> traeger/ceb/wegwerf_mutation_m7.hpp"
(naht am Tip 157 Z. + 2-Zeilen-Anhang = 159 plausibel) · M8 Vergleich `ziel_stufe > stufe`
existiert als einzige Richtungs-Logik · M9 kMarker-Konstante "#88". Keine zwei M-Literale
wiederholen denselben Wortlaut (P-24-Form). Revert-Beweis: Branch-Diff enthaelt WEDER
Director- noch Scanner-Mutationsreste (8-Dateien-Menge, Mutations-Muster 0 Treffer);
Worktree-porcelain leer.

**P-22 D-4-Katalogluecke S-8 — n/a (Quellenluecke, kein Strang-Versaeumnis; Spannung S-5).**
Massstab bleibt T-1..T-9/T-11b/c — angewandt und erfuellt (P-18/P-21).

### Block G — R-01

**P-23 R-01 "vollzogen/angestossen" — ERFUELLT in der Variante ANGESTOSSEN (C-6-Formel-konform).**
Am Objekt: eigene Include-Wurzel (CMake `target_include_directories ... include`), CLI-Link
(`comdare_planner` in apps/experiment_planner), VOLLZUGS-Deklaration W7/#88 woertlich in
`libs/traeger/planner/CMakeLists.txt` ("(2) VOLLZUG (deklariert, W7/#88 -- NICHT hier): ...
die CLI linkt dann comdare_planner STATT comdare::profile_run_facade"). Die C-6-ABNAHME
(W2-ABFOLGE-DESIGN:209) laesst "angestossen" ausdruecklich als ODER zu. Die (P)-Klassen-
Spannung (S-2) bleibt Owner/Lead-Vorlage — getragen als F-18, siehe Abschnitt 4.

### Block H — Beweis-/Betriebsdoktrin

**P-24 GOAL VII.2 Abnahme-Form — ERFUELLT.** Jede Kern-Behauptung traegt ein eigenes Literal;
vom Audit REPRODUZIERT am Objekt: ASCII-Zaehlung, Ueberlaengen 4/43, Include-Zaehlung 19,
clang-format-EXIT=0, merge-base, ls-remote, Skeleton-Existenz (Detail in Abschnitt 3).

**P-25 allow_failure-Verbot / keine CI-YAML — ERFUELLT.**
Namens-Diff enthaelt keine .gitlab-ci.yml; Gegen-Grep `allow_failure` im vollen Diff = **0**.

**P-26 Bau-Slot/ASCII/clang-format/df-Protokoll — ERFUELLT (Format/ASCII am Objekt reproduziert;
Slot/df nach Aktenlage).**
REPRODUZIERT: (1) Non-ASCII in ALLEN Added-Zeilen des Diffs = **0**. (2) Zeilen >120 in
Added-Zeilen = **genau 4** = exakt die gespiegelten Define-Zeilen des CMake-Anhangs; Basis-
Datei traegt **43** solcher Zeilen (beide Berichts-Zahlen wortgenau bestaetigt).
(3) clang-format-22 `--dry-run -Werror` ueber die 5 Lint-Dateien VOM TIP extrahiert:
**CLANG_FORMAT_EXIT=0**. Slot-Protokoll (SLOT=2, df 32G, Freigabe) und build/-Entfernung
(git ls-files build = 0 UND find csv/xlsx = 0 — rm-build-Memory-Regel befolgt) sind
Prozess-Behauptungen des Laufzeitpunkts: retrospektiv NICHT-PRUEFBAR, aber protokolliert,
in sich konsistent und ohne Gegenindiz (Worktree-Endstand porcelain leer bestaetigt).

---

## 2. (a) TDD-VERTRAG JE NEUEM TEST

test_s8kopf_planner_kopf (6 Tests, 4 Suites — Zaehlung am Objekt: 6 TEST-Makros):
- T-1 Rot/Mutation: M1-M6 je Testfall, Literale verankert (P-21). ERFUELLT.
- T-2 Aussage: Byte-Gleichheit, Nenner-Gleichheit, Ordnungs- und Protokoll-Inhalte,
  compile-harte Negativproben — keine reine Anwesenheitspruefung. ERFUELLT.
- T-3 Nenner fremd: 3 = Ledger-Abschrift-Konstante; 6 = eigene next_permutation-Zaehlung ueber
  eine EIGENE Instrument-Abschrift ("Bewusst NICHT kToolingHauptKette gelesen"); Tiefe 3 =
  kOwnerTiefe, Kette selbst gewandert (mit <=-Endloswachen). ERFUELLT.
- T-4 Gegeneingang: 6 Klassen (MessRohdatenPaket · StrukturKlon · ZweitesOobSignal ·
  Rechtsakt-Tausch beidseitig · EinrichtungFremd · TerminalProbe-Emission). ERFUELLT.
- T-5 Orakel unabhaengig: Gleichheits-Orakel zweier Laeufe unter Umgebungs-Delta;
  Permutations-Orakel unabhaengig gezaehlt. ERFUELLT.
- T-6 Schwesterpflicht: Thesis+Experiment-Zwilling im Debug-Test; hinauf/hinab/OOB alle
  drei Naht-Seiten geprueft. ERFUELLT.
- T-7 Registrierung: Dateiende-Block + ctest-Nummern-Literale (P-19). ERFUELLT.
- T-8 Atomar: EIN Commit, Monolith 0-Diff, Env-Restaurator im Test. ERFUELLT.
- T-9: naechste Welle (NICHT-GEFORDERT #9). Vormerk unten.
- T-11c: 6 Mutationen fuer 6 Tests. ERFUELLT.

test_s8_traeger_grenzwache (3 Tests, 1 Suite — 3 TEST-Makros):
- T-1: M7 (echter Baum, Identitaets-Rot) + M8/M9 (Scanner selbst = Pruefling in der TU,
  zulaessige Ausnahme laut Protokollvermerk). ERFUELLT.
- T-2/T-4: Koeder A/B + Gegenproben + erlaubte Gegenrichtung + Stille-Null-Wache. ERFUELLT.
- T-3/T-5: Stufen-Karte als eigene Abschrift der #29-Par.-4.2-Ordnung; Marker-Konstante
  fremd fixiert. ERFUELLT.
- T-7: Dateiende-Block, std-only-Registrierung. ERFUELLT.
- T-9-VORMERK (naechste Welle, KEIN Fund): Scanner-Testkritik im TU-Kopf benennt
  Blockkommentar-/#ifdef-/Makro-Grenzen; ZUSAETZLICH unbenannt: mehrstufig-relative
  Include-Formen ("../../ceb/...") matcht `traeger_ziel_stufe` nicht (nur "traeger/NAME/"
  irgendwo oder "../NAME/" am Anfang). Kanonische Form ist per R5 ohnehin Pflicht;
  Kandidat fuer die T-9-Testkritik der Folgewelle.

---

## 3. (b) GOAL-DOKTRINEN + (c) ABNAHME-FORMELN + (d) BERICHT-STICHPROBEN

(b) GOAL/Auftrags-Doktrinen — ALLE EINGEHALTEN, je Literal:
- ASCII-only neue Zeilen: 0 Non-ASCII ueber ALLE Added-Zeilen des Diffs (LC_ALL=C grep -P).
- allow_failure: 0 Treffer im Diff; keine YAML-Datei beruehrt.
- TABU-Zonen: 8-Dateien-Menge enthaelt nichts unter axes/ topics/ heuristik/; keine
  golden-Datei; tests/unit/CMakeLists.txt NUR Dateiende-Anhang (Hunk ab Z.7574+, 0 Loeschungen
  im Bestand dieser Datei — Diff zeigt +59/-0 dort).
- Ledger/Board/Memory-Schreibverbot: Ledger-Text NUR als ENTWURF im Strang-Bericht §6.6
  ("Lead-only, NICHT von mir geschrieben"); kein docs/-Pfad im ce-Diff.
- Commit-Trailer: `Co-Authored-By: Claude Fable 5 <noreply@anthropic.com>` vorhanden (git log -1 literal).
- Branch-Sicherung: ls-remote-Beweis oben (push -o ci.skip laut Bericht; Remote-Ref steht).

(c) Abnahme-Formeln woertlich:
1. C-6 (W2-ABFOLGE-DESIGN:208-209): "Traeger gebaut" — Stufe-1-KOPF-Substanz gebaut (im
   Staffel-Zuschnitt dieses Strangs: S-8 Teil 1; S-9..S-11 + B-04 = deklarierte Folge-Slots
   Mo/Di, NICHT-GEFORDERT #2/#3 — die C-6-VOLLbreite deckt erst die Posten-Familie) ·
   "B-01 3 Nachrichtenklassen ohne Mess-Rohdaten-Ruecklauf" — ERFUELLT (P-04/P-05) ·
   "B-14 6 Docks" — ERFUELLT (P-07) · "R-01-Schnitt vollzogen/angestossen" — ERFUELLT als
   "angestossen" (P-23). => Die fuer DIESEN Strang mandatierte Formel ist woertlich erfuellt.
2. Wellenplan Z.1790 "S-8 Teil 1: Interpreter + Director + IPlanBuilder + --dump-plan +
   Contract-Test": alle 4 Bestandsglieder am Objekt verifiziert (Director an Basis 2461
   Zeilen per wc -l; construct-API Z.2179/2228; --dump-plan-Fassade profile_run_facade.hpp:259-
   Zone; construct_plan_into .cpp:1040 mit dump-plan-Aufruf :1132; Bestands-Contract-Test
   existiert) + NEUE Contract-Tests des Strangs. Bestands-Pflicht (verdrahten statt neu
   entwerfen) eingehalten: 0 Monolith-Zeilen geaendert.
3.-8. B-01/B-14/B-16/KON50-01/6-Docks-Verbatim/KON43: je in P-04..P-15 mit Literal gedeckt.
9.-11. T-11a-c: P-20/P-21.
12. GOAL "was erzwingt das Halten?": static_asserts + Grenzwache + registrierte ctest-Eintraege;
    ungedeckte Stellen AUSDRUECKLICH benannt (VL-3-CLI-stdout, R-01-Vollzug, S-9/S-10-Nutzlast,
    T-11b-Zellen 2-4). ERFUELLT.
13. R-01-(P)-Formel: siehe Spannung S-2 (Owner/Lead-Vorlage, getragen als F-18).

(d) Bericht-Stichproben am Objekt (Zahlen mit Nenner):
- 8 Dateien +1266/-5: BESTAETIGT (--stat).
- Zeilenzahlen am Tip: naht 157 / steuerdock 199 / rakete 168 / kopf-TU 405 / grenzwache 248 —
  konsistent mit Format-Pass-Notiz (156->157 "u.a."; grenzwache 253->248 durch Realignment).
- Director 2461 Z. an Basis: BESTAETIGT (wc -l).
- "6 PASSED / 3 PASSED": TEST-Makro-Zaehlung 6 bzw. 3 am Objekt: BESTAETIGT.
- Grenzwache-Erstlauf "3 Quelldateien, 19 Include-Zeilen": arithmetisch am Objekt BESTAETIGT
  (5+7+7=19 ueber genau 3 Quelldateien unter libs/traeger/).
- "4 Zeilen >120 = gespiegelte Defines; Basis 43": BEIDE Zahlen exakt BESTAETIGT.
- clang-format Re-Check EXIT=0: REPRODUZIERT (EXIT=0 am Tip-Extrakt).
- Skeleton an Basis (#29): 4x cat-file OK; Wurzel-Anschluss :741 BESTAETIGT.
- ctest 508->512-Erklaerung (bedingte Bloecke nach J-1+RE-CONFIGURE): plausibel + quer-
  korroboriert (Basis-Nenner 510 in drei unabhaengigen Strang-Berichten); die bedingten
  Bloecke in tests/unit haengen an prt-art-/Registry-EXISTS-Gates, NICHT am Overlay-Werkzeug
  (0 overlay-Treffer in tests/unit/CMakeLists.txt) => keine Registrierungs-Luecke durch S8A-01.
- NICHT haltende Behauptungen: KEINE Substanz-Behauptung gefallen; 2 Praezisions-Notizen
  als KLEIN-Funde unten (Werkzeugliste J-1; Zeilen-Anker main.cpp).

---

## 4. SPANNUNGEN (Einordnung, keine Strang-Fehler) + K12-2-GEGENLESE-ANTWORT (ENTWURF fuer den Lead)

- **S-1 (6 vs. "max. 4 erreichbar", R-1/OV-10)**: Strang folgte korrekt der juengeren, konkreten
  C-6-Anweisung (6) und traegt die offene Owner-Frage transparent im steuerdock.hpp-Kopf
  ("Faellt der Owner-Entscheid anders, ist die Registry-Aufzaehlung der EINE Ort der Zahl").
  GETRAGEN als F-17 (OFFEN-OWNER) — kein Fund. Owner-Vorlagen-Zeile bleibt faellig (Staffel-1-
  Synthese Punkt 8 traegt sie bereits).
- **S-2 (R-01 (P)-Klasse vs. "angestossen" vs. W7-Vollzug)**: Die fuer den Strang geltende
  C-6-Formel ist erfuellt ("angestossen"). Die Rest-Spannung — ob die (P)-Klassifizierung
  (Wellenplan Z.2635/§18.1) einen VOLLZUG vor F2 verlangt, waehrend der Strang W7/#88
  deklariert — ist eine QUELLEN-Auslegungsfrage fuer Owner/Lead, KEIN Objekt-Delta;
  Substanz getragen als F-18. EMPFEHLUNG an den Lead: beim KON120-Zug die R-01-Zeile mit
  beiden Lesarten der Soll-Karte (S-2) vorlegen, nicht implizit eine annehmen.
- **S-3 (P-0-Ausloeser "wenn S-8 gebaut wird")**: Teil-1-Stand; super-Seite nur kartiert
  (F-19, OFFEN begleitend §15.5). Lesart "Ausloeser = voller S-8-Abschluss (Mo)" plausibel;
  Klaerung im Di-25-Schnitt moeglich. Kein Fund.
- **S-4 / K12-2 (LEAD-ENTSCHEIDE Punkt 15 — Antwort aus dem Gegenlesen), ENTWURF**:
  Das gebaute S-8-Substrat (Naht-Typen, 6 Docks, Rechtsakte, Raketen-Geruest) beruehrt die
  K12-2-Flaeche (measurement_on/single_thread ohne Emitter-Leser) NICHT — 0 Treffer der
  Begriffe im Diff und im Bericht. Aus dem s8-Ergebnis GEWINNBAR ist nur die METHODISCHE
  Antwort: der Strang hat seine eigene owner-offene Architektur-Frage (6-vs-4) nach
  KON41-05-Doktrin per Weiterbau-mit-transparentem-Vermerk-an-EINER-Code-Stelle geloest —
  dasselbe Muster taugt fuer K12-2 (kein neuer Owner-Satz noetig, solange die Aufloesung
  eine benannte, einstellige Code-Stelle mit Vorlage-Vermerk bleibt). Der FACHLICHE
  K12-2-Traeger bleibt der Di-25-Schnitt (#96) laut karte-register:91 — dieses Audit
  bestaetigt: aus dem s8-Objekt ist KEINE fachliche K12-2-Aufloesung ableitbar.
- **S-5 (D-4 nennt S-8..S-11 nicht)**: Quellenluecke; generischer T-Vertrag angewandt. Kein Fund.
- **S-6 (drei "R-1"-Bezeichner)**: beachtet; keine Verwechslung in dieser Tafel (R-01 =
  Planer-Split; R-1/OV-10 = Dock-Erreichbarkeit; KON29-06-R-1 = ueberholt durch KON41-03).

## 5. GETRAGENE OFFENE POSTEN (aus F-01..F-123 — NUR GELISTET, keine Funde)

- F-15 Karten-Drift Director 2352->2461 (DOKUMENTIERT; am Objekt 2461 bestaetigt).
- F-16 VL-3-Rest CLI-stdout-Bytevergleich (OFFEN, W2-1-Buendel mit F-46/F-47; #101 deckt CLI-Ebene).
- F-17 R-1/OV-10 Dock-Zahl-Owner-Vorlage (OFFEN-OWNER; Vorlage-Zeile faellig).
- F-18 R-01-Vollzug W7/#88 (OFFEN geplant; + S-2-Lesarten-Vorlage, s.o.).
- F-19 P-0 super-Seite nur kartiert (OFFEN begleitend §15.5).
- H-1/K17 (S1-Synthese): tests/unit/CMakeLists.txt-Dateiende = geteilte Anhang-Flaeche ALLER
  Straenge (+10 Tests, Endstand-Soll 520) — Harmonisierung + T-11b-4-Zellen-Kombibau am
  gemergten Endstand = Lande-Zug-Pflicht.
- H-15 (S2-Synthese): traeger/-Baum s8kopf x vollzug91 (traeger/ceb) — Lande-Reihenfolge
  beachten, gegen s8kopf sichten.

## 6. FUNDE

**S8A-01 (KLEIN) — J-1-Treppe im Strang mit 6 statt der doktrinaeren 7 Werkzeuge gefahren/berichtet.**
Strang-Bericht WIEDERANLAUF 06:40 Punkt 4 + Commit-Message nennen 6 Werkzeuge;
`comdare_overlay_source_hash_gen` fehlt in der Aufzaehlung, EXISTIERT aber am Objekt
(66de5c09: tools/overlay_source_hash_gen/CMakeLists.txt:44 `add_executable(...)`;
cmake/overlay_source_hash.cmake:30ff mit FATAL bei Fehlen). Die Begruendung des Strangs
("alle *_registry_gen am Objekt = genau diese 3") deckt nur die *_registry_gen-Teilmenge,
nicht die volle J-1-Liste (Memory/Auftrag: SIEBEN). WIRKUNG HIER NACHWEISLICH NULL:
(i) tests/unit/CMakeLists.txt traegt 0 overlay-bedingte Registrierungen (grep overlay = 0;
EXISTS-Gates betreffen prt-art/Registry-Pfade), (ii) der finale Vollbau `--target all` baute
das Werkzeug vor dem ctest-Lauf ohnehin, (iii) Basis-Nenner 510 dreifach quer-korroboriert.
FIX-WEG: KEINE Code-Aenderung. Lande-Zug (K17-Kombibau am Merge-Endstand, ohnehin Pflicht
aus H-1/P-20) faehrt die VOLLE 7-Werkzeug-Treppe (J-0b -> J-1 SIEBEN inkl.
comdare_overlay_source_hash_gen -> RE-CONFIGURE -> all -> ctest); im Lande-Protokoll die
7er-Liste literal ausweisen. Zustaendig: Lande-Zug-Traeger; Referenz: Memory
reference_lokale_vollbau_luecken_falsches_gruen.

**S8A-02 (KLEIN) — Zeilen-Anker "main.cpp:721-726" fuer den VL-3-Kommentar um ~4 Zeilen verschoben.**
Am Objekt (Datei im Diff unveraendert, Basis==Tip) steht der VL-3-Kommentar bei
apps/experiment_planner/main.cpp **Z.714-719** (Z.717-718 tragen das Literal "stdout-Byte-
Gleichheit ... NICHT gemessen ... VL-3-Restposten: Bytevergleich = offener Pruef-Posten,
Welle-2-Fix"); Z.720-723 ist der [debug]-stderr-AUSSCHUSS-Block. Der Anker ":721-726" (Strang-
Bericht §1.2/§6.2, Test-TU-Kopf, Commit-Message) zeigt also auf den stderr-Block statt auf den
Kommentar — Substanz-Behauptung haelt, nur der Zeilen-Anker ist unpraezise.
FIX-WEG: Dokumentarisch, KEIN Pflicht-Codefix vor der Landung: beim naechsten Anfassen der
Kopf-TU (z. B. Lande-Harmonisierung H-1) den Anker in test_s8kopf_planner_kopf.cpp
(Kopf-Kommentar + Abschnitts-Kommentar, Symbol: "main.cpp:721-726") auf "main.cpp:714-719"
korrigieren ODER den Zeilen-Anker durch das Marker-Zitat ("VL-3-Restposten ... Welle-2-Fix")
ersetzen; dieselbe Korrektur im Ledger-ENTWURF-Wortlaut ist nicht noetig (der ENTWURF traegt
keinen Zeilen-Anker). Berichtsseitig: diese Audit-Notiz genuegt als Korrektur-Aktenlage.

## 7. VERDIKT

**SITZT** — 0 ERNST, 0 MILD, 2 KLEIN (S8A-01 Protokoll-Notiz Werkzeugliste, S8A-02
Zitat-Anker). Alle 26 Prueflisten-Punkte ERFUELLT bzw. korrekt deklariert/getragen; die
drei Soll-Karten-Audit-Hinweise (P-05/P-08/P-10) loesen sich am Objekt POSITIV (explizite
Negativproben/static_asserts vorhanden). Lande-Zug-Pflichten (kein Strang-Gap, bereits
getragen): T-11b-4-Zellen-Kombibau + clang-Lauf am Merge-Endstand mit VOLLER 7-Werkzeug-
Treppe (S8A-01) · CMakeLists-Dateiende-Harmonisierung (H-1) · traeger/-Sichtung gegen
vollzug91 (H-15) · Owner-Vorlagen R-1/OV-10 (F-17) und R-01/(P)-Lesarten (F-18/S-2).
