# SOLL-KARTE — T-NEU-6 S-8-Traegerbau-KOPF (Strang "s8kopf")

Erhebt von: Sonnet-5-max Planungs-Erheber (S1-Aufgabe "s8kopf"), 21.08.2026.
NUR LESEN — keine Bewertung, kein Fix. Diese Karte ist Rohdaten fuer das Audit.

Objekt: ce Branch `bau/s8kopf` @ `41ee878056bd0388cd8bcf6472067e20192237c5` (Basis `66de5c09`).
Unabhaengig verifiziert (read-only): `git ls-remote origin bau/s8kopf` im ce-Hauptklon liefert
exakt `41ee878056bd0388cd8bcf6472067e20192237c5 refs/heads/bau/s8kopf` — Branch-Sicherung des
Strangs (§5 des Strang-Berichts: `git push -o ci.skip origin bau/s8kopf`) bestaetigt am Objekt.
Commit-Betreff (`git log -1`): *"feat(s8-kopf): T-NEU-6 Teil 1 — Traeger-Stufe-1-Substanz unter
`<traeger/planner/...>` (B-01 Naht-Schablone, B-14 sechs Steuerdocks, Raketen-Geruest) +
#22(ii)-Debug-Neutralitaet + Grenz-Wache"* — deckt sich wortgleich mit dem Steckbrief.

Strang-Bericht (voll gelesen): `/home/comdare/backups-workflow/20260820-w2-sofortstaffel/traegerbau-s8-ergebnis.md` (218 Zeilen).

---

## PRUEFLISTE

### Block A — Scope-Rahmen und Vorbedingungen (nicht Strang-Substanz, aber Abnahme-relevant)

**P-01 — Aufgaben-Gegenstand laut Auftrag: NUR "S-8 Teil 1", nicht das volle T-NEU-6.**
WAS: Wellenplan §14.4 Z.1790 woertlich: *"**S-8 Teil 1**: Interpreter + Director + `IPlanBuilder`
+ `--dump-plan` + Contract-Test."* (WE Sa/So-Slot). Die Fortsetzung *"**S-8 Teil 2**:
`CMakeGraphBuilder` + `CiYamlBuilder` + `experiment_plan.cmake` · Bump-Buendel ##32/##33/##34"*
steht separat als **Montag**-Posten der W2-Woche (Z.1796) — explizit NICHT Teil dieses
WE-Slots. Der Task-Steckbrief selbst nennt die Aufgabe *"T-NEU-6 S-8-Traegerbau-**KOPF**"*
(nur S-8), waehrend W2-ABFOLGE-DESIGN.md:204 den vollen Posten *"T-NEU-6 TRAEGERBAU
S-8/S-9/S-10/S-11 als W2-KOPF"* nennt.
WIE pruefbar: Diff-Menge des Commits (8 Dateien, siehe Strang-Bericht §5) darf keine
S-9/S-10/S-11-Substanz enthalten (kein `CebSystemAxisDrive`, keine Teilbaum-Serialisierung/
Cursor-Ruecklauf, kein `ceb:build`-Hart-Kompilation-Umbau).
BEHAUPTET: Ja — Strang-Bericht §5 listet exakt 8 Dateien (3 Header `traeger/planner`, 2
Test-TUs, 3 CMakeLists), keine S-9/10/11-Datei darunter.

**P-02 — Vorbedingung C-5: #29-Zielstruktur-Schnitt VOR S-8-Bau.**
WAS: W2-ABFOLGE-DESIGN.md:200-203 (C-5): *"#29 ZIELSTRUKTUR-SCHNITT 4 Traeger-Unterprojekte
als WE-Design VOR S-8-Bau"*, ABNAHME (Z.203): *"Schnitt steht vor S-8-Bau."*
WIE pruefbar: `libs/traeger/{planner,ceb,tier,hybrid}/CMakeLists.txt` muessen bereits an der
Basis `66de5c09` existieren (vor dem s8kopf-Commit).
BEHAUPTET: Ja — Strang-Bericht §1.4: *"Skeleton EXISTIERT an ce 66de5c09"* (9 Dateien,
Ledger-Task #29 bereits `[completed]` PUBLIZIERT 85c1174d/KON60-01).

**P-03 — Fessel P1→P2 (S-3 vor S-7) erfuellt.**
WAS: Wellenplan §18.7 Z.2295: *"P1 vor P2  simd_build_gate-Kopplung => S-3-Landung VOR
S-7-Bau"*; C-6-ABNAHME (W2-ABFOLGE-DESIGN.md:206) zitiert dies als *"Fessel P1->P2: S-3 ist
gelandet, S-7-Bau frei"*.
WIE pruefbar: ce-Historie zwischen S-1/S-3/S-7-Landung und Basis 66de5c09 (Ledger-Tasks #4,
#30 `[completed]`).
BEHAUPTET: implizit erfuellt (Basis 66de5c09 liegt nach der kompletten #15-Bump-Kette, die die
gesamte Stempel-Strecke S-1..S-7 traegt) — nicht vom Strang selbst behauptet, da Vorbedingung,
kein Baugegenstand.

### Block B — B-01 Naht-Schablone (Planer↔CEB, Flaeche 1)

**P-04 — Genau DREI Nachrichtenklassen hinauf, compile-hart erzwungen.**
WAS: Wellenplan §19.2 Z.2408 (B-01): *"Naht-Schablone Planer<->CEB: 3 Nachrichtenklassen
hinauf; NIE Mess-Rohdaten zum Planer (KON50-01/-02) -> S-8/S-10/#20"*. Ledger KON50-02
(Z.6352-6358) PRAEZISIERT: *"der §38-Rueckkanal traegt DREI Nachrichtenklassen: (i)
Fortschritts-Deltas ... (ii) STATUS je Anforderung erfolgreich/nicht + Fehler-LOG ... (iii)
ERGEBNIS-TRACE fuer den Nutzer"*.
WIE pruefbar: `libs/traeger/planner/include/traeger/planner/naht_nachrichten.hpp` —
`static_assert` auf genau 3 Typen; Wegwerf-Mutation (4. Typ einschmuggeln) muss COMPILE-ROT
liefern.
BEHAUPTET: Ja — Strang-Bericht §4 M1: *"4. Typ (FertigSignal) in SteuerNahtHinaufKlassen ->
COMPILE-ROT 'error: static assertion failed: KON50-02: genau DREI Nachrichtenklassen hinauf'
(Z.114)"*.

**P-05 — NIE Mess-Rohdaten zum Planer (Rueckweg-Grenze).**
WAS: Ledger KON50-01 (Z.6328-6340) woertlich: *"RUECKWEG-GRENZE: die CEB MISST und
VERARBEITET selbst; an den Planer geht NUR der ERGEBNIS-TRACE ... KEINE Mess-Rohdaten."*
Deckt sich mit Wellenplan B-01.
WIE pruefbar: Typkatalog von `naht_nachrichten.hpp` darf keinen Messwert-/Rohdaten-Typ fuehren
(Negativ-Eigenschaft — pruefbar nur durch Abwesenheit + durch T-4-Gegeneingangstest, falls
vorhanden).
BEHAUPTET: Implizit durch die geschlossene 3-Typen-Menge (P-04); der Strang-Bericht nennt
KEINEN eigenen Test, der EXPLIZIT einen Mess-Rohdaten-Typ als abgelehnt zeigt (kein T-4-Koeder
dieser Form in der M1-M9-Liste) — **Audit-Hinweis**: die Garantie steht durch Bauart (closed
enum/variant), nicht durch einen eigenen Negativtest belegt.

**P-06 — Flaeche 1 = Control-Interface, hinab die "erkannten Anforderungen".**
WAS: Ledger KON50-01 (Z.6330-6336): *"FLAECHE 1 CONTROL-INTERFACE der CEB — stream in / stream
out ... HINAB Planer -> CEB: die ERKANNTEN ANFORDERUNGEN (CEB fuehrt aus) / HINAUF CEB ->
Planer: STATUS ... + LOG-MESSAGE"*.
WIE pruefbar: Typdesign in `naht_nachrichten.hpp` (hinab-Kanal vs. hinauf-Kanal getrennt).
BEHAUPTET: Ja, laut Strang-Bericht §2 Dateiliste ist `naht_nachrichten.hpp` explizit als *"B-01
Typen+Concepts"* deklariert; Detailtiefe der hinab-Seite (gefilterte XML-Fragmente, §38-Ranges)
ist laut KON50-03 (Z.6369) explizit **S-10-Gegenstand**, nicht S-8 — siehe NICHT-GEFORDERT.

### Block C — B-14 Steuerdock-Fundament (Planer↔CEB, sechs Docks, zwei Rechtsakte)

**P-07 — SECHS Steuerdocks, je CEB-Version eines (3! = 6).**
WAS: Wellenplan §19.2 Z.2437-2438 (B-14): *"SECHS STEUERDOCKS Planer<->CEB ... (Z14784-14853)
-> S-8/S-10"*. Owner-Verbatim im Ledger (09.08., Z.17146-17150): *"Damit hat der Planer **6
STEUERDOCKS** — fuer jede CEB einen, der genau auf vorhandene einkompilierte
Messeinrichtungen passt"*. Praezisiert Z.17166-17173: *"**3! = 6** — der Planer haelt je
CEB-Version ein eigenes Steuerdock."*
WIE pruefbar: `steuerdock.hpp` — Funktion/Registry `alle_ceb_versionen()` (o.ae.) mit exakt 6
Eintraegen; Wegwerf-Mutation (einen Eintrag entfernen) muss ROT liefern.
BEHAUPTET: Ja — Strang-Bericht §4 M2: *"`out.pop_back()` in `alle_ceb_versionen()` -> ROT
'Which is: 5' vs 'Which is: 6' + 'SECHS Steuerdocks -- je CEB-Version eines (B-14)'"*.

**P-08 — Dock passt compile-hart genau auf vorhandene einkompilierte Messeinrichtungen +
gibt nur existierende Steuerbefehle frei.**
WAS: Ledger Z.17168-17173: *"passt genau auf die vorhandenen einkompilierten
Messeinrichtungen dieser CEB — nicht auf die moeglichen ... gibt nur die Steuerbefehle frei,
die laut Plan tatsaechlich existieren."* Wellenplan B-14 (Z.2437): *"zwei Rechtsakte (FREIGABE
System / DURCHSETZUNG Organ); ... variadischer Kern: Dock passt compile-hart GENAU auf
einkompilierte Messeinrichtungen"* (so auch Strang-Bericht §1.5 Wortlaut).
WIE pruefbar: Templatisierung/Concept-Guard in `steuerdock.hpp` (variadischer Kern).
BEHAUPTET: Ja (Strang-Bericht §1.5 + §2 — "variadischer Kern" explizit genannt als
Bauziel); kein dedizierter Mutations-Koeder in M1-M9 zielt jedoch spezifisch auf die
"nur existierende Befehle"-Eigenschaft — **Audit-Hinweis**: pruefen, ob dies durch reine
Typsystem-Konstruktion (kein Fehlpfad moeglich => kein Test noetig, T-2 waere sonst
"Anwesenheit statt Aussage") oder durch einen der bestehenden Tests mit abgedeckt ist.

**P-09 — Zwei Rechtsakte: FREIGABE (System-Achse) / DURCHSETZUNG (Organ-Achse), NICHT
austauschbar.**
WAS: Ledger Z.17178-17183 woertlich: *"Die Freigabe des Experiment-Baumes im Planer, und
darueber: FREIGABE der System-Achse und DURCHSETZUNG der Organ-Achse. Die Begriffe sind NICHT
austauschbar (Systemachsen werden freigegeben, Organachsen durchgesetzt)."*
WIE pruefbar: zwei getrennte Funktionen/Typen in `steuerdock.hpp` (`freigabe()` vs.
`durchsetzung()` o.ae.); Wegwerf-Mutation (Vertauschung) muss ROT liefern.
BEHAUPTET: Ja — Strang-Bericht §4 M3: *"`freigabe()` protokolliert 'durchsetzung:' -> ROT
'Which is: \"durchsetzung:target_isa\"' / FAILED RechtsakteUndGesammelterRelease"*.

**P-10 — Release NUR GESAMMELT vor/nach der Gesamt-Messung (Latenz-Reinheit).**
WAS: Ledger Z.17185-17191 woertlich: *"ERLAUBT: Logging CEB -> Planer-CLI, GESAMMELT, VOR oder
NACH der Gesamt-Messung / VERBOTEN: Senden waehrend der Messung"*. Wellenplan B-14 bestaetigt
("Release nur GESAMMELT vor/nach der Gesamt-Messung").
WIE pruefbar: derselbe Testfall wie P-09 (`RechtsakteUndGesammelterRelease`) traegt laut Name
BEIDE Eigenschaften (Rechtsakte-Trennung UND Gesammelt-Timing) in einem Testkoerper.
BEHAUPTET: Namentlich ja (Testname nennt "GesammelterRelease"); der zitierte Mutations-Beleg
(M3) zeigt jedoch nur die Rechtsakte-Verwechslung, nicht separat die Timing-Eigenschaft (kein
eigener Koeder "sendet waehrend der Messung") — **Audit-Hinweis**: pruefen, ob der Testkoerper
selbst (nicht nur der zitierte Mutant) die Gesammelt-Eigenschaft eigenstaendig sichert oder ob
das nur der Name suggeriert (T-2-Risiko: "Anwesenheit statt Aussage").

**P-11 — Docks strukturell von der Mess-Permutation/dem Mess-Nenner ENTKOPPELT.**
WAS: Ledger KON41-03 (Z.7046-7071) — Owner: *"Die Pruefdocks des Hybrid SIND NICHT die
Permutationen der Traeger Stufen ... VOELLIG FALSCH."* Konklusion: *"NUR die GLEICHSETZUNG
faellt"* — Docks bleiben eine eigene Groesse, dynamisch/maximal begrenzt, nicht aus der
Schalter-Kombinatorik abgeleitet.
WIE pruefbar: `steuerdock.hpp` darf die Zahl 6 nicht aus `2^5`/Mess-Schalter-Kombinatorik oder
aus S-19-Planungssimulation herleiten, sondern als eigenstaendige, feste Registry-Groesse
fuehren.
BEHAUPTET: Ja — Strang-Bericht §1.5 nennt explizit *"KON41-03: Docks von Mess-Nenner
ENTKOPPELT"* als befolgte Entwurfsregel.

**P-12 — SPANNUNGS-BEHAFTET: 6 vs. "max. 4 erreichbar" (R-1/OV-10) — siehe SPANNUNGEN.**
Wird dort separat gefuehrt, da es sich um eine im Quellenbestand selbst offene Owner-Frage
handelt, keine glatte Pflicht.

### Block D — B-16 Vier-Unterprojekt-Zielform

**P-13 — S-8 baut in die Vier-Unterprojekt-Zielform, NICHT in den Monolithen.**
WAS: Wellenplan §19.2 Z.2442-2443 (B-16): *"Zielform-Pflicht AB SOFORT: S-8/S-9 in die
Vier-Unterprojekt-Form; #29a Planer-Unterprojekt = erster Monolith-Schnitt (KON43 + KON47-01)
-> W2-Struktur"*. Owner-Verbatim KON43-02 (Ledger Z.6903-6907): *"S-8 (Planer-Kopf) und S-9
(CEB-Generierung) bauen in die Vier-Unterprojekt-Zielform, nicht in den Monolithen — die
Ziel-Ordnerstruktur wird VOR dem S-8-Bau (W2) geschnitten."*
WIE pruefbar: neue Header/CMake-Substanz muss unter `libs/traeger/planner/include/traeger/
planner/` liegen (nicht unter `libs/cache_engine/profile_facade/planner/`).
BEHAUPTET: Ja — Strang-Bericht §2/§5: alle 3 neuen Header + `libs/traeger/planner/CMakeLists.txt`
liegen exakt dort; `apps/experiment_planner/CMakeLists.txt` wird fuer den App-Link auf
`comdare_planner` angepasst (R-01-Vorbereitung, siehe P-19).

**P-14 — Bruecken-Regel §4.3 (#29-Design): eigene Include-Wurzel `<traeger/...>`, KEINE
Alt-Wurzeln (R5); `builder/`-Wiederverwendung NUR mit Marker `// TRAEGER-BRUECKE(#88):
<Zielort>`.**
WAS: Sekundaerquelle (vom Strang zitiert, nicht in meiner SOLL-Quellenliste, aber direkt
einschlaegig fuer B-16-Vollzug): super `docs/plaene/20260813-DESIGN-zielstruktur-vier-
traeger-unterprojekte.md` §4.3/§4.4 — vom Strang als Bau-Vorlage gelesen (Strang-Bericht
WIEDERANLAUF 21.08 Punkt 2).
WIE pruefbar: `grep -c "TRAEGER-BRUECKE(#88)"` in den neuen Headern; Wegwerf-Mutation der
Marker-Nummer muss die Grenz-Wache ROT werfen.
BEHAUPTET: Ja — Strang-Bericht §4 M9: *"Scanner: `kMarker` '#88' -> '#99' -> ROT 'Value of:
gruen.verstoesse.empty()' ..."*.

**P-15 — Grenz-Wache §4.4 (#29-Design) als eigener Google-Test: (a) keine Include-Kante
Stufe N→N+1 in `libs/traeger/`, (b) jede `traeger`→`builder`-Kante traegt den Marker.
NE-16-Pflicht (neuer Test zuerst in den Wachen-Inventar-Nenner).**
WAS: siehe P-14-Quelle; NE-16 aus dem Fallen-Register (Memory) — allgemeine Wachen-Inventar-
Pflicht, vom Strang selbst explizit gegen die zwei Nenner-Klassen (A: `.gitlab-ci.yml`-Skripte,
C: `PASS_REGULAR_EXPRESSION`-ctest-Eintraege) durchgeprueft.
WIE pruefbar: `tests/unit/test_s8_traeger_grenzwache.cpp` existiert, ist registriert (ctest -N),
liefert bei intaktem Baum GRUEN mit Literal-Ausgabe *"[grenzwache] gescannt: N Quelldateien, M
Include-Zeilen, 0 Verstoesse"*.
BEHAUPTET: Ja — Strang-Bericht §4 ERSTLAUF: *"[grenzwache] gescannt: 3 Quelldateien, 19
Include-Zeilen, 0 Verstoesse"*; M7-Mutation (echter `#include` in falscher Stufen-Richtung)
liefert *"stufen_inversion: .../naht_nachrichten.hpp:159 -> traeger/ceb/wegwerf_mutation_m7.hpp"
+ '1 Grenz-Verstoesse'"*; M8 mutiert den Scanner-Vergleichsoperator selbst (`>` -> `<`) und
zeigt ROT — das deckt beide Wache-Seiten.

### Block E — #22(ii)/OD-7: --debug-Plan-Neutralitaet (faehrt laut Plan MIT S-8)

**P-16 — Plan-Text ist byte-invariant unter `COMDARE_DEBUG_FREIGABE` ("beschleunigt, leitet
nie um").**
WAS: Wellenplan §19.1 Z.2255: *"#22(ii) --debug in die Planer-CLI (Generalproben-Schalter) —
BAU-Haelfte, faehrt MIT S-8 ... KON34-05 ('beschleunigt, leitet nie um') · KON41-01 -> S-8"*.
Ledger-Task #22 (Board, `[in_progress]`): *"--debug-CLI-Haelfte geht mit S-8 in W2 (vor der
W3-Generalprobe)"*. Wellenplan D-13 Z.402-404 nennt denselben Posten nochmals im W2-Randslot-
Register.
WIE pruefbar: Contract-Test in der Kopf-TU (`test_s8kopf_planner_kopf.cpp`), der den ueber
`construct_plan_into` erzeugten Plan-Text MIT und OHNE `COMDARE_DEBUG_FREIGABE` byte-vergleicht.
BEHAUPTET: Ja — Strang-Bericht §4 M6 (Wegwerf-Mutation am Monolithen selbst, NICHT dauerhaft):
*"`begin_plan` haengt '# debug\n' an wenn COMDARE_DEBUG_FREIGABE gesetzt -> ROT '#22(ii)
verletzt: der Thesis-Plan-Text haengt an COMDARE_DEBUG_FREIGABE (leitet um)' + Experiment-
Zwilling. Danach `git diff Director` = 0 Zeilen."* Bestaetigt: der produktive Monolith bleibt
unveraendert (0-Zeilen-Diff nach Revert), nur der Test ist neu.

**P-17 — SCOPE-GRENZE: NUR die Plan-Ebene ist gedeckt, NICHT der volle CLI-stdout-
Bytevergleich.**
WAS: Der Strang deklariert dies selbst offen (Strang-Bericht §6 Punkt 2): *"VL-3-Restposten
bleibt offen ... CLI-stdout-Bytevergleich mit/ohne --debug (apps/experiment_planner/main.cpp:
721-726) — haengt am CLI-Prozess, nicht an der dump-plan-Naht. Gedeckt ist die PLAN-EBENE."*
QUERBEZUG: Ledger-Task #101 (Board, `[completed]`) traegt separat *"W2-1: Bytevergleich-
MESSUNG planner main.cpp:515 + --debug-Matrix als EIN Pruefposten"* — das ist ein ANDERER,
bereits abgeschlossener Strang, der die CLI-Ebene abdeckt. Siehe NICHT-GEFORDERT.
WIE pruefbar: pruefen, ob main.cpp:721-726 tatsaechlich weiterhin nur den Kommentar traegt (der
Strang aendert main.cpp fuer diesen Zweck NICHT — die main.cpp-Aenderung im Commit betrifft
laut §5 nur `apps/experiment_planner/CMakeLists.txt`, nicht `main.cpp` selbst).
BEHAUPTET: Explizit als OFFEN deklariert (kein Verschweigen) — korrekt gemaess Beweis-Doktrin.

### Block F — Test-/Abnahme-Vertrag (Designplan §3, T-1..T-9 + T-11b/T-11c)

**P-18 — TDD-Vertrag T-1..T-9 (Designplan §3, Z.67-75) gilt fuer jeden neuen Test.**
WAS (Kurzfassung, woertlich Designplan Z.67-75): T-1 Rot zuerst/Wegwerf-Mutation ·
T-2 Aussage statt Anwesenheit · T-3 Nenner aus fremder Quelle · T-4 Gegeneingang ·
T-5 Orakel unabhaengig · T-6 Schwesterpflicht · T-7 Registrierung ist Teil des Tests ·
T-8 Atomare Landung (Hart-Gruen) · T-9 Testkritik naechste Welle.
WIE pruefbar: je Testfall in `test_s8kopf_planner_kopf.cpp`/`test_s8_traeger_grenzwache.cpp`
gegen die 9 Kriterien pruefen.
BEHAUPTET: T-1 (Rot-Beleg via M1-M9) ja · T-7 (Registrierung, siehe P-20) ja · T-8 (0-Diff-
Monolith, atomarer Commit mit Minimalbau) ja · T-3/T-5 (Nenner "3", "6" sind fremd-fixierte
Literale aus KON50-02/KON41-03, nicht aus dem Pruefling ruecklaufend) ja, laut Konstruktion ·
T-9 (Testkritik der Vorwelle) ist erst in der FOLGEWELLE faellig, hier nicht pruefbar.

**P-19 — T-7 Registrierung ist Teil des Tests; NUR ans Dateiende von
`tests/unit/CMakeLists.txt` (deckt sich mit der Auftrags-TABU-Regel).**
WAS: Designplan Z.73 (T-7) + Auftrags-TABU-Regel (identischer Gegenstand aus zwei
unabhaengigen Quellen: Designplan-T-7 UND die bindende Auftragsregel dieser S1-Aufgabe).
WIE pruefbar: `tail`-Diff von `tests/unit/CMakeLists.txt` zeigt die zwei neuen Bloecke NACH
allen Bestandsbloecken (hinter s6c); `ctest -N` zeigt beide Tests.
BEHAUPTET: Ja — Strang-Bericht WIEDERANLAUF 21.08 Punkt 2: *"2 Bloecke ans DATEIENDE ...
angehaengt"*; §6.5: *"mein Block steht am DATEIENDE hinter s6c"*; T-7-Literal (Strang-Bericht
Punkt 3): *"Test #507: test_s8kopf_planner_kopf" + "Test #508: test_s8_traeger_grenzwache",
Total 508"* (vor J-1/RE-CONFIGURE), spaeter 511/512 nach vollem Bau (§5).

**P-20 — T-11b Kombibau-2×2-Matrix {clang,gcc}×{Debug,Release} = 4 Zellen, literale
ctest-Bilanz — PFLICHT der LANDUNG, nicht des Einzelstrangs.**
WAS: Designplan Z.645 (T-11b): *"jede Landung ist erst gruen, wenn {clang, gcc} x {Debug,
Release} = 4 Zellen je J-1...J-4 + ctest durchlaufen ... Abnahme-Regel, kein Einzeltest-
Posten"*.
WIE pruefbar: der VOLLE 4-Zellen-Kombibau findet gemaess Staffel-1-Design NICHT im
Einzelstrang statt, sondern am gemergten Landungs-Endstand (K17-Doktrin).
BEHAUPTET: Der Strang selbst deklariert dies korrekt als NICHT-hier-erledigt: §3/§6 Punkt 5:
*"Lande-Zug: T-11b-4-Zellen-Kombibau am gemergten Endstand (lokal gefahren: gcc-Release
voll)"*. Im Strang wurde NUR gcc-Release durchlaufen (§5: *"Voller ctest-Lauf (gcc-Release,
nach kompletter Treppe): '100% tests passed, 0 tests failed out of 512'"*). **Kein Gap dieses
Strangs** — korrekt an den Lande-Zug deklariert; das Audit sollte dies NICHT als fehlenden
Beleg DIESES Strangs werten, sondern gegen den spaeteren Merge-Kombibau pruefen.

**P-21 — T-11c Mutations-Protokoll: je neuem Test ≥1 Wegwerf-Mutation mit literalem Rot +
Gegenprobe-Gruen; Koeder-Form VOR der Mutation pruefen (M-F2-Lehre).**
WAS: Designplan Z.647 (T-11c) woertlich: *"der Biss jedes neuen Tests wird per protokollierter
Wegwerf-Mutation belegt (Rot gesehen, dann zurueckgenommen) ... GEZAEHLTE Pflicht je Paket: je
neuem Test >=1 Wegwerf-Mutation mit literalem Rot + Gegenprobe-Gruen."*
WIE pruefbar: Anzahl + Literale der M1-M9-Eintraege im Strang-Bericht §4, Revert-Beleg (`git
diff` = 0 Zeilen an beruehrten Bestandsdateien, clang-format-Re-Check EXIT=0, Mutations-Rest-
Grep = 0 Treffer nach allen Reverts).
BEHAUPTET: Ja, deutlich uebererfuellt — 9 Mutationen (M1-M9) fuer 2 neue Test-TUs + die
Grenzwache-eigene Scanner-Logik; jede mit literalem Rot-Zitat + Revert-Nachweis; §4 Schluss-
Absatz: *"NACH ALLEN REVERTS: Mutations-Rest-Grep ueber alle 6 beruehrten Dateien = 0 Treffer;
git diff experiment_plan_director.hpp = 0 Zeilen ... beide TUs erneut GRUEN (6 PASSED /
3 PASSED)."*

**P-22 — Designplan §10/D-4: die S-Strecke (inkl. S-8..S-11) traegt bislang KEINEN
eigens benannten Testposten im 117er-Katalog — nur T-1..T-9 (allgemein) + T-11b/T-11c gelten.**
WAS: Designplan Z.629 (D-4) woertlich: *"S-6, S-13, S-14, S-17...S-21 fehlen im 117er-Katalog
... T-9 laeuft fuer den groessten Baublock leer."* **S-8/S-9/S-10/S-11 werden in dieser
Luecken-Aufzaehlung NICHT genannt** — weder als gedeckt noch als fehlend.
WIE pruefbar: kein spezifischer Katalogposten "S-8-irgendwas" in Designplan §2 (K1-K7-Klassen)
erwartbar; Massstab bleibt der generische T-1..T-9/T-11-Vertrag (P-18/P-21).
BEHAUPTET: n/a — Dokumentationsluecke der SOLL-Quelle selbst, kein Strang-Versaeumnis. Als
SPANNUNG/Praezisierungshinweis gefuehrt (siehe SPANNUNGEN).

### Block G — R-01 Planer-Split (eigene Binary)

**P-23 — R-01: Planer-Split ZWINGEND eigene Binary VOR Abgabe — Klasse (P), Welle
"W1/W2-KOPF".**
WAS: Wellenplan §19.7 Z.2635: *"R-01 | Planer-Split: ZWINGEND eigene Binary VOR Abgabe (R-G1;
Schnitt-Spez liegt) | r2 A40 | P | W1/W2-KOPF"*. Klassen-Regel §18.1 Z.2202: *"(P) vor F2 Fr
21.08."* — (P) bedeutet laut wiederholter Verwendung im Dokument (z. B. Designplan-Zitat
D-2/§8: *"sind (P), MUESSEN vor F2, fallen NIE"*) einen HARTEN Vor-Freeze-Pflichtposten.
C-6-ABNAHME (W2-ABFOLGE-DESIGN.md:209) zitiert die konkrete, fuer DIESEN Strang geltende
Formel: *"R-01-Schnitt vollzogen/angestossen"* — ein ausdrueckliches ODER, das eine blosse
Initiierung als Alternative zur vollen Umsetzung zulaesst.
WIE pruefbar: `libs/traeger/planner/CMakeLists.txt` — Include-Wurzel + CLI-Link-Erklaerung;
`apps/experiment_planner/CMakeLists.txt`-Diff (Verweis auf `comdare_planner`); KEIN
tatsaechlicher Executable-Split von `comdare::profile_run_facade` erwartbar (laut Deklaration).
BEHAUPTET: "angestossen", NICHT "vollzogen" — Strang-Bericht §6 Punkt 1 woertlich: *"R-01
VOLLZUG (deklariert, NICHT vollzogen): profile_facade/-Substanz-Wanderung + Link-Ersatz
(comdare_planner STATT comdare::profile_run_facade) = W7/#88 ... Vorbereitet: Include-Wurzel,
CLI-Link, Neubauten traeger-seitig."* Siehe SPANNUNGEN fuer die Einordnung dieser
Selbstauskunft gegen die (P)-Klassifizierung.

### Block H — Beweis-/Betriebsdoktrin (allgemein, aber an diesem Objekt zu pruefen)

**P-24 — GOAL v8 VII.2: Abnahme-Doktrin — Nenner, Rot-/Gruen-Lauf, frisch gewuerfelter
Koeder; "was erzwingt das Halten?".**
WAS: GOAL v8 Z.640-645 woertlich: *"Jede Abnahme traegt Nenner, Rot- und Gruen-Lauf, frisch
gewuerfelten Koeder ... 'Wir achten darauf' = nicht abgenommen."*
WIE pruefbar: jede P-04/P-07/P-09/P-13/P-15/P-16/P-21-Behauptung traegt bereits ein Literal
(siehe oben) — Formvoraussetzung erfuellt, wenn die Literale am Objekt reproduzierbar sind
(Audit-Aufgabe, nicht diese Karte).
BEHAUPTET: Formal ja (jede Mutation traegt ein eigenes, unterschiedliches Rot-Literal, keine
zwei M-Eintraege wiederholen denselben Wortlaut).

**P-25 — GOAL v8 TEIL IX: `allow_failure: true` auf JOB-Ebene ist VERBOTEN (Owner-Direktive,
Z.763-765).**
WAS: nicht direkt Baugegenstand dieses Strangs (keine CI-YAML-Aenderung im Commit), aber
PFLICHT-Gegenprobe: der Strang darf keine neue `allow_failure`-Job-Definition einfuehren.
WIE pruefbar: Commit-Diff enthaelt keine `.gitlab-ci.yml`-Aenderung (TABU-Regel des Auftrags
deckt sich hier mit der GOAL-Doktrin).
BEHAUPTET: Ja — Strang-Bericht §5 Dateiliste enthaelt keine YAML-Datei; TABU eingehalten.

**P-26 — Bau-Slot-/Beweis-Protokoll (Auftragsregel dieser S1-Aufgabe, nicht Wellenplan/GOAL,
aber Ergebnis-Bestandteil): ASCII-only, clang-format-22, Slot-Freigabe, `df -h`-Gate.**
WAS: Steckbrief-Regelwerk dieser Session.
WIE pruefbar: Strang-Bericht WIEDERANLAUF 21.08 Punkt 5-6: *"clang-format-22 ueber die 5
Lint-Dateien: erst ROT (Alignment), -i angewendet, Re-Check EXIT=0. ASCII-Check 5x nonascii=0,
Zeilen>120 5x 0 ... Bau-Slot-Protokoll: SLOT=2 genommen (traegerbau-s8), df-Gate 32G frei."*
BEHAUPTET: Ja, mit einem benannten Nebenbefund: *"CMake-Anhang: 4 Zeilen >120 = exakt die
gespiegelten Define-Zeilen (Bestand traegt an der Vorlage-Stelle dieselbe Form; Basis hat 43
solcher Zeilen in dieser Datei)"* — bewusst als Bestands-Spiegelung deklariert, nicht als
Verstoss verschwiegen.

---

## ABNAHME-FORMELN

Woertliche Abnahme-/Ziel-Kriterien der Quellen, in Rangfolge (juengste/verbindlichste zuerst):

1. **W2-ABFOLGE-DESIGN.md:207-209 (C-6, die fuer DIESEN Strang unmittelbar mandatierende
   Formel):**
   > *"ABNAHME: Traeger gebaut; B-01 3 Nachrichtenklassen ohne Mess-Rohdaten-Ruecklauf; B-14 6
   > Docks; R-01-Schnitt vollzogen/angestossen."*

2. **Wellenplan §14.4 Z.1790 (S-8 Teil 1, der fuer das WE-Fenster geltende Bauumfang):**
   > *"S-8 Teil 1: Interpreter + Director + IPlanBuilder + --dump-plan + Contract-Test."*

3. **Wellenplan §19.2 Z.2408 (B-01, woertlich):**
   > *"Naht-Schablone Planer<->CEB: 3 Nachrichtenklassen hinauf; NIE Mess-Rohdaten zum Planer
   > (KON50-01/-02) -> S-8/S-10/#20"*

4. **Wellenplan §19.2 Z.2437-2438 (B-14, woertlich):**
   > *"SECHS STEUERDOCKS Planer<->CEB; zwei Rechtsakte (FREIGABE System / DURCHSETZUNG Organ);
   > Release nur GESAMMELT vor/nach der Gesamt-Messung (Z14784-14853) -> S-8/S-10"*

5. **Wellenplan §19.2 Z.2442-2443 (B-16, woertlich):**
   > *"Zielform-Pflicht AB SOFORT: S-8/S-9 in die Vier-Unterprojekt-Form; #29a
   > Planer-Unterprojekt = erster Monolith-Schnitt (KON43 + KON47-01) -> W2-Struktur"*

6. **Ledger KON50-01 (Z.6328-6340), Owner-abgeleitete Festlegung — die Rueckweg-Grenze:**
   > *"an den Planer geht NUR der ERGEBNIS-TRACE fuer die KOMMANDOZEILE (Nutzer-Sicht) — KEINE
   > Mess-Rohdaten."*

7. **Ledger, Owner-Verbatim 09.08. (Z.17146-17150), Ursprungsquelle von B-14:**
   > *"Damit hat der Planer 6 STEUERDOCKS — fuer jede CEB einen, der genau auf vorhandene
   > einkompilierte Messeinrichtungen passt und auch nur bestimmte Steuerbefehle freigibt, die
   > tatsaechlich existieren laut Plan. Der Release kann nur unter Logging der CEB an den
   > Planer auf die CLI des Planers vor oder nach der Gesamt-Messung GESAMMELT erfolgen."*

8. **Ledger KON43-01/-02 (Z.6880-6907), Owner-Festlegung zu B-16/Bau-Reihenfolge:**
   > *"PLANER -> CEB -> TIER-BINARIES -> HYBRID [...] AUSNAHMSLOS: kein Ketten-Bau an einer
   > hoeheren Stufe, bevor die niedrigere steht."* / *"S-8 (Planer-Kopf) und S-9 (CEB-
   > Generierung) bauen in die Vier-Unterprojekt-Zielform, nicht in den Monolithen."*

9. **Designplan Z.640-649 (T-11a-c-Block-Kopf):** *"Als GEZAEHLTE Posten-Liste (3 neue
   Testklassen), noch NICHT in den 117er-Katalog eingerechnet"* — T-11b/T-11c sind PFLICHT,
   aber additiv zur Summen-Regel (kein Katalog-Nenner-Bruch, falls nicht mitgezaehlt).

10. **Designplan Z.645 (T-11b, woertlich):** *"jede Landung ist erst gruen, wenn {clang, gcc}
    x {Debug, Release} = 4 Zellen je J-1...J-4 + ctest durchlaufen [...] Abnahme-Regel, kein
    Einzeltest-Posten."* — gilt der LANDUNG, nicht dem Einzelstrang (siehe P-20).

11. **Designplan Z.647 (T-11c, woertlich):** *"GEZAEHLTE Pflicht je Paket: je neuem Test >=1
    Wegwerf-Mutation mit literalem Rot + Gegenprobe-Gruen."*

12. **GOAL v8 Z.643-645 (allgemeine Abnahme-Formvoraussetzung):** *"Zu jeder Abnahme gehoert
    die Antwort auf 'was erzwingt das Halten?' Zulaessig: ein Werkzeug oder eine ausdruecklich
    als ungedeckt benannte Stelle."*

13. **Wellenplan §19.7 Z.2635 (R-01, die uebergeordnete, NICHT auf diesen Strang allein
    begrenzte Formel):** *"Planer-Split: ZWINGEND eigene Binary VOR Abgabe"*, Klasse **(P)**.

---

## NICHT-GEFORDERT

Ausdruecklich NICHT Teil dieser Aufgabe (deklarierte Nachfolge-Zuege) — das Audit soll hierzu
KEINE Phantom-Funde erheben:

1. **S-8 Teil 2** (CMakeGraphBuilder, CiYamlBuilder, `cmake/experiment_plan.cmake`,
   Bump-Buendel ##32/##33/##34) — Wellenplan §14.4 Z.1796 terminiert dies ausdruecklich auf
   **Montag** der W2-Woche, NICHT auf den WE-Sa/So-Slot dieses Strangs.

2. **S-9 CEB-Generierung, S-10 Teilbaum-Serialisierung+Ruecklauf, S-11 `ceb:build`-Hart-
   Kompilation** — nominell Teil des vollen T-NEU-6-Postens (Wellenplan Z.2788: *"T-NEU-6
   S-8/S-9/S-10/S-11-TRAEGERBAU"*), aber der Task-Steckbrief dieses S1-Strangs benennt
   ausdruecklich nur *"S-8-Traegerbau-KOPF"*. Der Strang-Bericht bestaetigt dies durch seinen
   eigenen Titel *"S-8-KOPF (T-NEU-6-**Beginn**)"* und durch die Dateimenge (§5: nur 8 Dateien,
   keine S-9/10/11-Substanz). Diese drei S-Posten sind gemaess Wellenplan-Terminplan (Z.1797)
   fuer **Dienstag** der W2-Woche vorgesehen.

3. **B-04 Inter-Experiment-Fenster** (bidirektionale Sync-Barriere, `--auto`/manuell,
   kill-OOB) — Wellenplan §19.2 Z.2415-2416 ordnet B-04 NOMINELL dem vollen T-NEU-6-Posten zu
   (Z.2788-2789: *"T-NEU-6 [...] (deckt B-01/B-04/B-14/B-16 + R-01)"*), der Task-Steckbrief
   DIESES konkreten Strangs nennt jedoch explizit nur B-14/B-01/B-16 — B-04 fehlt dort. Ledger
   KON53-02 (Z.6145-6146, Z.6159-6161) ordnet die konkrete `--auto`-CLI-Umsetzung ohnehin der
   S-8-**Familie** in einem weiteren Sinn zu, die Barriere-Protokoll-Substanz selbst aber S-10
   (*"Barriere-Protokoll: Fertig-Signal -> beidseitiger Flush/Sync -> Drain-Quittung -> Start-
   Kommando"*). Der Strang hat `--auto` NICHT gebaut (keine Erwaehnung in §1-§6) — konsistent
   mit der engeren Steckbrief-Fassung, aber siehe SPANNUNGEN fuer den Bezugs-Widerspruch.

4. **Flaeche-3-Nutzlast der Planer↔CEB-Naht** (das eigentliche "Was genau reist als gefiltertes
   XML-Fragment hinab") — Ledger KON50-03 (Z.6369-6370) weist dies ausdruecklich **S-10** zu:
   *"S-10 bekommt seinen RAHMEN: das Control-Interface traegt Ranges hinab und Deltas+Status+
   Log hinauf -- S-10 baut die Nutzlast IN diese Naht."* B-01 (dieser Strang) liefert nur die
   TYPENSCHABLONE, nicht die Nutzlast-Serialisierung.

5. **CLI-stdout-Bytevergleich mit/ohne `--debug`** (main.cpp-Ebene, VL-3-Restposten) — vom
   Strang selbst als offen deklariert (Strang-Bericht §6 Punkt 2) UND bereits durch einen
   ANDEREN, separat gelisteten Board-Posten (#101, `[completed]`: *"W2-1:
   Bytevergleich-MESSUNG planner main.cpp:515 + --debug-Matrix als EIN Pruefposten"*)
   abgedeckt — kein offener Traeger-Verlust, sondern zwei disjunkte Teilaufgaben derselben
   #22(ii)-Familie.

6. **R-01 volle Umsetzung** (tatsaechlicher Executable-Split `comdare_planner` STATT
   `comdare::profile_run_facade`-Link) — vom Strang ausdruecklich auf **W7/#88** verschoben
   (Strang-Bericht §6 Punkt 1). Die C-6-Abnahmeformel selbst laesst dies zu ("vollzogen/
   **angestossen**"), siehe aber SPANNUNGEN fuer die Reibung mit der (P)-Klassifizierung.

7. **Monolith-Split in voller Breite** (der gesamte `libs/cache_engine`-Baum in die vier
   Unterprojekte) — Ledger KON43-01(3)/KON43-02 (Z.6893-6908) weist dies ausdruecklich dem
   Aufraeum-Posten **#88** zu, *"nicht vor F1/F2 erzwungen"*; dieser Strang fuegt nur NEUE
   Substanz in der Zielform hinzu, verschiebt keinen Bestand.

8. **P-0 (super-Seite auf ce-Skelett ziehen)** — der Strang kartiert `v32_messreihe_antrieb.hpp`
   (super) nur (Strang-Bericht §1.3), ruehrt sie nicht an. Wellenplan §15.5 stuft P-0 als
   *"BEGLEITEND, NICHT BLOCKIEREND"* ein — siehe SPANNUNGEN fuer die zeitliche Nuance
   ("wenn S-8 gebaut wird").

9. **T-9 Testkritik der neuen Tests** — laut Designplan Z.75 erst in der **Folgewelle**
   faellig (Codex-Pass ueber die neu gebauten Tests DER VORWELLE); fuer diesen frisch gebauten
   Strang naturgemaess noch nicht anwendbar.

10. **K12-2 (#22 Methodik-Override) eigenstaendig aufloesen** — der explizit benannte
    Traeger dieses Postens ist laut `karte-register.md:91` der **Di-25.-Schnitt (#96)**, NICHT
    dieser Strang. LEAD-ENTSCHEIDE Punkt 15 verlangt lediglich, die Antwort beim GEGENLESEN
    dieses Ergebnisses zu gewinnen (siehe SPANNUNGEN) — nicht, dass der Strang selbst einen
    Methodik-Override-Beschluss ausformuliert.

---

## SPANNUNGEN

Widersprueche zwischen den Quellen bzw. zwischen Quelle und Strang-Auslegung — bewusst NICHT
glattgezogen, juengere/rangschwaechere Schicht jeweils benannt:

**S-1 — R-1/OV-10: sechs Steuerdocks vs. "maximal 4 erreichbar" (OFFENE Owner-Frage, nie
geschlossen).**
Ledger Z.17195-17204 fuehrt den Konflikt selbst als unaufgeloest: OV-10 sagt *"Teilmengen-
Lesart (max. 4 erreichbar), Abnahme: 4 + belegte Begruendung warum nicht 6"* — mit Empfehlung
"ja" zu 4, weil eine echte 3!-Permutation *"ein Gate-Modell-Umbau im Identitaetsfenster mit
Bump-Folge waere"*. Direkt danach (derselbe Ledger-Absatz, Z.17199-17202) stellt der KERN vom
09.08. dem zwei Lesarten gegenueber und schliesst: *"Vorlage, keine Entscheidung meinerseits."*
— **die Frage ist bis heute (21.08., Ledger-Kopf KON119) nicht vom Owner beantwortet.** Der
Auftrag C-6 (W2-ABFOLGE-DESIGN.md:204-209, juenger als der 09.08.-Ur-Beleg) **mandatiert
explizit 6** ("B-14 6 Docks" in der ABNAHME-Zeile) — der Strang folgt dieser juengeren,
konkreten Anweisung und baut 6 (Lesart 2: *"Docks decken auch unerreichbare Varianten ab =
Vollstaendigkeit am Dock"*), dokumentiert die Spannung aber selbst transparent im
`steuerdock.hpp`-Kopf als *"VORLAGE-ZEILE"* (Strang-Bericht §1.5/§6 Punkt 3). **Einordnung:**
der Strang hat korrekt nach Rangfolge gehandelt (Auftrag C-6 > alte offene Owner-Frage), die
Owner-Frage selbst bleibt aber echt offen — das Audit sollte dies NICHT als Fehler des Strangs,
sondern als fortbestehende Owner-Vorlage werten.

**S-2 — R-01 (P)-Klasse "vor F2, faellt NIE" vs. C-6-Abnahmeformel "vollzogen/angestossen"
vs. Strang-Deklaration "W7/#88" (nach Abgabe!).**
Wellenplan §19.7 Z.2635 klassiert R-01 als **(P)** — nach der Klassen-Regel §18.1 Z.2202
bedeutet das *"vor F2 Fr 21.08."* faellig, und (P)-Posten *"fallen NIE"* (Designplan-Analogie
Z.623: *"sind (P), MUESSEN vor F2, fallen NIE"*). Die konkrete, fuer DIESEN Strang geltende
ABNAHME-Formel in C-6 (W2-ABFOLGE-DESIGN.md:209) mildert dies selbst ab: *"R-01-Schnitt
vollzogen/**angestossen**"* — ein ausdrueckliches ODER. Der Strang liest dies als
"angestossen genuegt" und verschiebt den vollen Vollzug explizit auf **W7** (Strang-Bericht §6
Punkt 1) — das liegt NACH der Abgabe (15.09.), nicht nur nach F2 (heute). **Spannung:** wenn
(P) tatsaechlich "faellt NIE vor F2" heisst, waere eine Verschiebung des VOLLEN Vollzugs bis
W7 ein Bruch der Klassen-Doktrin; wenn dagegen die konkrete C-6-Formel ("angestossen" reicht)
die massgebliche, praezisierende Auslegung FUER DIESEN Posten ist (was die Rangfolge
Auftrag>Wellenplan-Tabelle nahelegt, da C-6 die spezifischere, spaetere Zuweisung ist), ist der
Strang gedeckt. Das Audit sollte diese zwei Lesarten explizit gegen den Owner/Lead abgleichen,
nicht implizit eine davon annehmen.

**S-3 — P-0 "wird zu [...] wenn S-8 gebaut wird" — Trigger bereits gerissen oder noch nicht?**
Wellenplan §15.5 Z.2009-2015 (MARKER 16.08., juenger als §14.7 Z.1864-1867) sagt: *"P-0 wird
zu: die super-Seite auf das ce-seitige Skelett ziehen, **wenn S-8 gebaut wird**."* Der
Strang baut nur "S-8 Teil 1" (siehe P-01/NICHT-GEFORDERT Punkt 1) und kartiert
`v32_messreihe_antrieb.hpp` explizit NUR, ohne sie zu aendern (Strang-Bericht §1.3), mit der
Begruendung *"P-0 bleibt begleitend (§15.5), kein Blocker fuer S-8"* — das ist eine korrekte
Wiedergabe der ERSTEN Haelfte von §15.5 (Regel-2-Ueberholung: P-0 blockiert S-8 NICHT), aber
die ZWEITE Haelfte des Satzes ("wenn S-8 gebaut wird" als AUSLOESER fuer den super-Zug) bleibt
unadressiert. Da S-8 als Ganzes (Teil 1 + Teil 2) laut Terminplan erst am Montag der W2-Woche
vollstaendig steht, ist eine Lesart, dass der Ausloeser noch nicht erreicht ist, plausibel —
zwingend ist sie aus dem Wortlaut allein aber nicht. **Keine harte Owner-Frage, aber
klaerungswuerdig**, ob "wenn S-8 gebaut wird" den Teil-1-Zeitpunkt oder den vollen S-8-
Abschluss meint.

**S-4 — K12-2 (#22 Methodik-Override, "measurement_on/single_thread ohne Emitter-Leser"):
LEAD-ENTSCHEIDE erwartet eine Antwort aus DIESEM Ergebnis, der Strang-Inhalt beruehrt das
Thema aber nicht erkennbar.**
`karte-register.md:91` definiert K12-2 praezise als: *"K12-2 Methodik-Override
emissionsseitig unbeobachtbar [...] Architektur-Spannung (measurement_on/single_thread ohne
Emitter-Leser) am S-8-Entscheid aufloesen"* — mit explizitem Traeger **"Di-25.-Schnitt
(#96)"**, NICHT diesem Strang, und `karte-register.md:270` fuehrt K12-2/#22 unter den 4
Posten mit *"owner-gated=unklar/moeglich"* (nicht hart entschieden). LEAD-ENTSCHEIDE Punkt 15
(`LEAD-ENTSCHEIDE-zum-w2-design.md:56-57`) ordnet trotzdem an: *"K3-Teil-K-Pruefpunkt K12-2
[...] wird beim Gegenlesen des s8-Strang-Ergebnisses beantwortet."* Der Strang-Bericht enthaelt
jedoch AN KEINER STELLE die Begriffe "measurement_on", "single_thread" oder
"Emitter-Leser"/"emissionsseitig" — das tatsaechlich gebaute B-14/B-01-Substrat (6 Docks,
Rechtsakte, Naht-Typen) beruehrt dieses spezifische Thema nicht erkennbar. **Einordnung:** die
einzige plausible indirekte Antwort, die sich aus dem Strang GEWINNEN laesst, ist die
METHODISCHE Beobachtung (nicht der Fachinhalt): der Strang loeste seine EIGENE offene
Architektur-Frage (S-1, 6-vs-4-Docks) durch Weiterbau-mit-transparentem-Vermerk statt durch
Owner-Eskalation — ein Praezedenzfall fuer "Explore traegt, kein neuer Owner-Satz noetig" nach
KON41-05-Doktrin (Ledger Z.7113-7117: *"nur noch Fragen mit Festlegungscharakter gehen an den
Owner"*). Ob das die von LEAD-ENTSCHEIDE gewuenschte K12-2-Antwort tatsaechlich traegt, ist
eine Wertungsfrage fuer das Audit/den Lead, keine harte Tatsache aus diesem Bericht.

**S-5 — Designplan D-4 nennt S-8..S-11 nicht in der Testposten-Luecken-Liste — Uebersehen
oder bewusste Deckung?**
Designplan Z.629 zaehlt explizit *"S-6, S-13, S-14, S-17...S-21"* als Posten ohne
117er-Testkatalog-Eintrag auf. S-8/S-9/S-10/S-11 fehlen in dieser Aufzaehlung VOLLSTAENDIG —
weder als gedeckt noch als Luecke benannt. Da T-NEU-6 (S-8..S-11) selbst erst am 17./18.08.
(KON97-Nachtrag-Aera) als eigener Posten entstand, waehrend D-4 vom 12.08. datiert, ist die
wahrscheinlichste Erklaerung ein zeitliches Auseinanderfallen (D-4 aelter als T-NEU-6) — das
ist aber eine Vermutung dieser Karte, keine belegte Owner-Aussage. **Praktische Folge:** kein
Designplan-spezifischer Testposten-Nenner existiert fuer S-8; der generische T-1..T-9/T-11b/c-
Vertrag (Block F) ist der einzige anwendbare Massstab, und der Strang haelt ihn ein (siehe
P-18/P-21). Kein Strang-Versaeumnis, aber eine Quellenluecke, die das Audit nicht dem Strang
anlasten sollte.

**S-6 — Namensgleichheit "R-1" in zwei disjunkten Quellen (Verwechslungsfalle, memory-bekannt:
Stempel-Kuerzel/Bezeichner immer zerlegen).**
Ledger KON29-06 (Z.8756, 12.08., ALTE WF5-Runde) fuehrt eine EIGENE Frage *"R-1 F3b-KERN:
ersetzt die 32 die 3!=6-Steuerdock-Maschinerie VOLLSTAENDIG [...]?"* — das ist NICHT dasselbe
"R-1" wie das Wellenplan-§19.7-"R-01" (Planer-Split-Binary) und auch nicht dasselbe wie das
in LEAD-ENTSCHEIDE/W2-ABFOLGE-DESIGN verwendete "R-1/OV-10" (das den 6-vs-4-Docks-Streit
meint, siehe S-1 oben — dieses "R-1" ist wiederum eine VERKUERZTE Schreibweise fuer OV-10,
nicht fuer Wellenplan-R-01). Drei verschiedene "R-1"/"R-01"-Bezeichner in drei Quellen fuer
DREI verschiedene Sachverhalte (Planer-Binary-Split / Docks-vs-32-Ersetzung / Docks-vs-4-
Erreichbarkeit). Der KON29-06-Streit ist durch die spaetere, praezisere KON41-03-Entwirrung
(Z.7046-7071: "Docks != Permutationen, ZWEI verschiedene Dinge") in der Sache ueberholt/
aufgeloest (Docks werden NICHT durch die 32 ersetzt, bleiben eigenstaendig) — dieser Teil der
Verwirrung ist also bereits durch juengere Schicht geklaert; nur die 6-vs-4-Frage (S-1) bleibt
lebendig. Diese Anmerkung dient allein der Vermeidung einer Audit-Verwechslung zwischen den
drei "R-1"-Vorkommen.

---

## QUELLEN-INDEX (fuer Nachschlag)

- W2-ABFOLGE-DESIGN.md: Z.200-209 (C-5/C-6 Auftrag+Abnahme), Z.380-420 (D-11/D-13 Randslots,
  #22(ii)/OD-7/K12-2), Z.655-680 (F-V-Pruefblock K12-2/OD-7), Z.745-774 (TEIL-2-Abhaengigkeitsgraph).
- LEAD-ENTSCHEIDE-zum-w2-design.md: vollstaendig gelesen (87 Z.), insbes. Punkt 12
  (KOLLISION C-7↔traegerbau-s8) und Punkt 15 (K12-2-Gegenlese-Auftrag).
- karte-register.md (`.../20260820-welle2-audit/`): Z.29, Z.91, Z.248-251, Z.270 (K12-2-Definition
  + owner-gated-Klasse).
- Wellenplan v2: Z.1685-1711 (§14.2 S-Bauteile-Tabelle inkl. S-8-Zeile), Z.1719-1738
  (§14.3 Reihenfolge-Graph), Z.1790-1800 (§14.4 WE/W2-Terminplan), Z.1862-1867 (§14.7 Director
  existiert bereits), Z.2009-2021 (§15.5/15.6 P-0 begleitend, S-17), Z.2200-2206 (§18.1
  Klassen-Regel), Z.2290-2298 (§18.7 Fesseln), Z.2406-2452 (§19.2 Korb B, B-01..B-20),
  Z.2631-2644 (§19.7 R-01..R-10), Z.2780-2792 (§20.8 REST-REGISTER T-NEU-6).
- Designplan-tdd: Z.63-75 (§3 TDD-Vertrag T-1..T-9), Z.618-632 (§10 D-4 Luecken-Liste),
  Z.636-649 (§11 T-11a-c), Z.661-714 (§12 T-12a-e, hier NICHT s8kopf-einschlaegig).
- GOAL-V8-Dossier: Z.13-91 (Kopf-Nachtrag/Ur-Doktrin-Bloecke inkl. Steuerdock/Kanal-Zitat),
  Z.424-513 (VI.1-VI.3 Kette/Hybrid/Metaprogrammierung), Z.605-670 (VII.1-VII.3
  Fahrplan/Betriebsregeln), Z.673-789 (VIII/IX TDD-Intro + allow_failure-Doktrin).
- Ledger (KON-Kopf KON119): Z.496-497/525/547 (KON50-02-Querverweise/KON110-01), Z.6103-6218
  (KON52/53 Fenster+OOB), Z.6246-6376 (KON50/51 Naht-Sprachen+Arenen), Z.6878-6909 (KON43
  Vier-Unterprojekte), Z.7046-7107 (KON41-03/04 Docks≠Permutationen, Hybrid-Stempel),
  Z.8748-8767 (KON29-06, aeltere R-1-Frage, ueberholt), Z.17100-17206 (09.08.-Owner-Verbatim
  6-Steuerdocks+2-Rechtsakte+OV-10-Konflikt).
- Strang-Ergebnis: `traegerbau-s8-ergebnis.md`, vollstaendig gelesen (218 Z.), zitiert nach
  eigenen Abschnittsnummern §1-§6.
- Board (Session-Task-Liste): #22, #29, #95, #101, #108 (Cross-Referenzen fuer Scope-Abgrenzung).
