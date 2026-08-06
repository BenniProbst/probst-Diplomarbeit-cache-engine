# PLAN: LB-6 STUFE 1 -- OE-B-DUMMY-LAGER AUF BAUM-FORM, ZEILEN VERBATIM ZURUECKGELESEN

> **Status:** BAUPLAN (Vor-Trigger-Pflicht LB-6, Stufe 1). **KEIN Code-Bau, KEIN Commit aus diesem
> Dokument.** Er liefert Plan-Deckung, Ist-Stand am Objekt, den Delta, ausfuehrbare Bisse,
> CI-Einhaengung, Golden-/TABU-Beleg, Aufwand und ein ehrliches Termin-Urteil.
>
> **Erhoben am 2026-08-06 am Objekt**, Baum `ce/` = `super/Code/external/comdare-cache-engine`,
> `ce` HEAD = `e7aa1244` (identisch mit dem konfigurierten Bau-Baum `ce/build/land`).
> Pfad-Kuerzel: `super/` = `/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine`.
>
> **Stufe 2 (Binary-Stubs) ist NICHT Gegenstand dieses Plans** -- sie haengt am
> Versionierungs-Interface und liegt nach der Abgabe. Sie steht nur als Folgeposten in Abschnitt 10.

---

## 1. PLAN-DECKUNG (woertlich, beide Quellen am Objekt nachgelesen)

### 1.1 Der Owner-Entscheid OE-B (01.08.)

`super/docs/sessions/20260801-FAHRPLAN-vollbau4-beweise-g6-trigger.md:200-201`:

> "OE-B: GO in Owner-Form: Dummy-Lager im temp-Verzeichnis, Binaries als TEXTDATEIEN mit
> Stempel-String, Test als GOOGLE-TEST (nicht Shell-Skript)."

Dazu die verdraengte aeltere Fassung, ebenfalls woertlich (`...KONSOLIDIERT...md`, Abschnitt
VERDRAENGTE AELTERE AUSSAGEN):

> "Beweis 2 als Shell-/minio-Hydration-Smoke -> OE-B (01.08.): GOOGLE-TEST mit Dummy-Lager im
> temp-Verzeichnis, Binaries als Textdateien mit Stempel-String"

### 1.2 Der Paketschnitt-Posten LB-6 (F9-Kette)

`super/docs/sessions/20260801-KONSOLIDIERT-gesamtarchitektur-lager-batch-eta-sha512.md:76`
(Abschnitt "F9: LAGER-BAUM-PAKETSCHNITT (KRITISCHER PFAD)"):

> "**LB-6 BEWEISE (haengt an allem):** OE-B-GTest-Dummy-Lager (Textdateien mit Stempel-String) auf
> Baum-Form erweitert; Beweis 1 (Batch-Wiederaufnahme-Konstruktion, OE-A), Beweis 2 (Hydration
> verified>0 UND pruned>0), Beweis 4 (Bestandslog-E2E gegen echtes minio + Takeover-Zweig);
> Truncate-/Spin-Lock-Konkurrenz-Test."

Und der Rang, aus derselben Datei:

> "Vor-Trigger-Pflicht-Paketschnitt Lager-Baum-Vollausbau (F9: erst Baum fertig, dann
> Voll-Bau-Trigger; 'der Voll-Bau-Trigger IST der Baum-Vollausbau')."

### 1.3 Die Ledger-Verankerung (juengster Stand)

`super/docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md:4408-4425` (NACHTRAG 06.08. nachmittag-10,
Abschnitt F) traegt beide Zitate nach und stellt fest, dass der Paketschnitt LB-0..LB-6
**buchhalterisch verloren** war (Muster `LB-[0-9]`: 0 Treffer im Ledger, 0 im TODO-REGISTER 06.08.
mit 474 Zeilen; Gegenprobe an der Quelle 3 Treffer). Der Folgeposten dort, woertlich (`:4465`):

> "**Stufe 1 der Lager-Basis-Tests ist Vor-Trigger-PFLICHT, nicht 'kann'** -- LB-6 deklariert sie so.
> Die Restarbeit ist klein und golden-neutral (die Bausteine sind gebaut, sie wurden nur nie
> zusammengefuehrt), sie beruehrt keine Produktivdatei. **Empfehlung: VOR dem Trigger Do 07.08.**"

**Dieser Plan ist die Ausfuehrungsform genau dieses Folgepostens.**

### 1.4 Die Owner-Verschaerfung "jede Zeile verbatim" (06.08.)

Owner 06.08., dritte von drei aufeinander aufbauenden Nachrichten, verbatim
(Memory `project_lager_basis_tests_dummy_strategien_stempel`):

> "Ich erwarte laut Plan eine dummy Strategie fuer den Tests des Lagers um aus simulierten
> Textdokumenten die Stempel auszulesen und **jede Zeile verbatim auszuwerten** und dasselbe mit
> compile Binary stubs fuer das Stempelsystem zu wiederholen (Binary compile der eigentlich nur das
> statische Stempel interface der Versionierung enthaelt als leere Tier-Binary). Das sind die
> erwarteten Basis Tests fuer das Lagersystem."

Vorher, dieselbe Kette:

> (1) "Wie die Stempel Test-Zeichenkette fuer die Pruefung des lager-Aufbaus mithilfe von
> Dummy-Textdokumenten wurde nicht gelesen??"
>
> (2) "Das war eine Testwelle mit google tests, um die Struktur des Lagers zu pruefen und die Stempel
> mit Textdateien zu simulieren anstatt eines factory patterns fuer das Erkennen von Stempeln aus
> Binaries und Messwerttabellen (xlsx Legenden sheet wie geplant)"

**WAS DIE VERSCHAERFUNG GEGENUEBER OE-B HINZUFUEGT -- und es ist genau ein Wort:** OE-B verlangt, dass
die Binary eine TEXTDATEI MIT Stempel-String IST (Schreibrichtung). Die Verschaerfung verlangt, dass
der Stempel aus dem Textdokument **AUSGELESEN** und **JEDE ZEILE VERBATIM AUSGEWERTET** wird
(Leserichtung, zeilenweise). Das ist kein Stil-Wunsch: die Dummy-Strategie ist der Test-Ersatz fuer
die spaetere **Factory**, die Stempel aus echten Binaries und aus dem xlsx-Legenden-Sheet erkennt --
eine Attrappe, die nur schreibt und nie liest, simuliert die Factory nicht, sie simuliert nur den
Schreiber.

---

## 2. IST-STAND AM OBJEKT (jede Zahl mit Bezugsgroesse)

### 2.1 Anker

| Anker | Wert | Beleg |
|---|---|---|
| `ce` HEAD (Submodul-Checkout) | `e7aa1244` | `git -C ce rev-parse --short HEAD` |
| Registrierte ctest-Tests im Baum `ce/build/land` | **407** | `ctest -N`, "Total Tests: 407" |
| davon mit LABEL `pmc` | **2** | `ctest -N -L pmc`, "Total Tests: 2" |
| davon im Job-Schnitt `-LE pmc` | **405** | `ctest -N -LE pmc`, "Total Tests: 405" |
| `test_g1_binary_version_stamp` | Test **#362**, LABELS `m;blut` | `ctest -N -LE pmc`; `ce/tests/unit/CMakeLists.txt:4399` |
| `test_lb0_lager_pfad_grammatik` | Test **#394**, **keine** LABELS, TIMEOUT 60 | `ce/build/land/tests/unit/CTestTestfile.cmake:793-794` |
| `test_lb1_knoten_heuristik_log` | Test **#395**, **keine** LABELS, TIMEOUT 60 | `ce/build/land/tests/unit/CTestTestfile.cmake:795-796` |
| TEST-Makros in `test_lb0...` | **33** (`grep -c "^TEST"`) | -- |
| TEST-Makros in `test_lb1...` | **23** (`grep -c "^TEST"`) | -- |
| Lauf der drei TUs, lokal | literal: `100% tests passed, 0 tests failed out of 3` | `ctest -R "^test_lb0...$\|^test_lb1...$\|^test_g1...$"` |

### 2.2 Drei Bausteine -- und keiner vereint Schreiben UND zeilenweises Zurueckdesen

**(a) Der Zeilen-Anker existiert, aber ohne Dateisystem.**
`ce/tests/unit/test_g1_binary_version_stamp.cpp:28-40` traegt `split_lines()` (anonymer Namespace),
`:77` zerlegt den Block, `:81-104` prueft **vier Zeilen einzeln** per `EXPECT_EQ` gegen ihre jeweilige
Single-Source (`planner_version_stamp()`, `g1_ceb_contract_version()`, `g1_build_type_label()`,
durchgereichter Suffix). **Aber der Block kommt direkt aus `g1_binary_version_block(sys)`** --
in-process, nichts wird geschrieben und wieder gelesen. Grep-Gegenprobe: `fstream` und `filesystem`
kommen in dieser TU **0-mal** vor.

**(b) Das echte Dateisystem existiert, aber ohne Rueckdesen.**
`ce/tests/unit/test_lb0_lager_pfad_grammatik.cpp:542` `Lb3Einlagerung.OeBDummyLagerBeideRealmsAufEchtemDateisystem`
schreibt den Stempel-String
`"[vereint,O2,avx2][a,b,c]+bt=Release"` (`:548`) real ueber `bl::make_filesystem_ablage()` (`:544-545`)
in ein Temp-Verzeichnis (Fixture `TempLager`, `:118-138`) und prueft `fs::exists(...)` (`:551`),
Nachbarschaft des Test-Logs (`:554-555`), Realm-Disjunktheit (`:561-562`) und Idempotenz des Knotens
(`:565-567`). **Der Inhalt wird nie zurueckgelesen** -- nicht als Ganzes und schon gar nicht zeilenweise.

**(c) Der zweite Realm-Ort ebenso.**
`ce/tests/unit/test_lb1_knoten_heuristik_log.cpp:522` `Lb1DummyLager.KnotenLogLebtImRealenBaumNebenDenBlaettern`
schreibt denselben Stempel-String real via `ablage.datei_schreiben(knoten + "/perm.dll", ...)` (`:527`,
Fixture `TempKnoten` `:106-124`) und liest danach ueber `bl::lade_knoten_log()` (`:545`) **den
Knoten-Log** zurueck -- nicht den Stempel-Text, und nicht Zeile fuer Zeile.

### 2.3 Der Truncate-/Spin-Lock-Konkurrenz-Test: vorhanden, aber nur zur Haelfte das, was LB-6 nennt

`ce/tests/unit/test_lb1_knoten_heuristik_log.cpp:420`
`TruncateZustandsmaschine.ZweiSchreiberKonkurrenzGenauEinerTruncatetDieZaehlungBleibtKonsistent`
und `:448` `...CrashMittenInDerInventurHinterlaesstDieMarkeUndHeiltNurPerNeuAufnahme` beweisen die
**Zustandslogik** (genau ein Truncate, konsistente Zaehlung 40, Crash-Marke, Heilung nur per
Neu-Inventarisierung).

**Was sie NICHT beweisen:** beide `TEST_F` laufen auf `FakeAblage` (In-Memory, `:51`), nicht auf
`bl::make_filesystem_ablage()`; der "zweite Schreiber" ist ein **verschachtelter, sequenzieller**
zweiter `mit_knoten_lock`-Aufruf innerhalb desselben Callbacks. Grep-Gegenprobe in der ganzen TU:
`make_filesystem_ablage` **1** Treffer (Zeile 524, der Dummy-Lager-Test), `std::thread`/`<thread>`
**0** Treffer. **Die Konkurrenz auf einem echten Spin-Lock-File ist unbelegt.**

### 2.4 Ein Nebenbefund, der die Konkurrenz-Stufe blockiert (verifiziert)

`TempLager` (`test_lb0:118-137`, Konstruktor `:120-125`) und `TempKnoten` (`test_lb1:106-124`,
Konstruktor `:108-113`) bilden ihre Wurzel als
**fester Name direkt unter** `fs::temp_directory_path()` (`"comdare_lb0_lager"` bzw.
`"comdare_lb1_knoten"`) und rufen im Konstruktor **`fs::remove_all(basis)`**.

Genau diese Klasse ist im Repo bereits geheilt -- aber woanders: `ce/tests/unit/comdare_test_tmp.hpp`
(`#278/#24` 06.07. + HAERTUNG Posten 69 04.08.) haelt fest, dass feste Namen direkt unter
`temp_directory_path()` auf Shell-Runnern mit fremden Usern kollidieren UND dass mehrere Worktrees
desselben Users einander die Fixtures loeschen (dort belegt: 15683 Eintraege in einer gemeinsamen
Wurzel, Flake-Klasse ~27% an zwei benannten Tests). Die Doktrin dort woertlich: "Alle Test-Temp-Pfade
gehoeren deshalb unter dieses uid-suffixierte Unterverzeichnis."

**Verbreitung, gezaehlt:** **39** TUs unter `ce/tests/unit/*.cpp` rufen `user_tmp_dir()`,
**12** benutzen `temp_directory_path()` direkt -- `test_lb0` und `test_lb1` gehoeren zu den 12.
Ob die uebrigen 10 ebenfalls festen Namen + `remove_all` kombinieren, ist **UNBELEGT** (nicht geprueft;
dieser Plan behauptet nichts darueber).

**Folge fuer diesen Plan:** solange die Wurzel fest ist, wuerde ein echter Nebenlaeufigkeits-Test
(Abschnitt 6, Stufe 1b) auf einem Runner mit zwei parallelen Bau-Baeumen nicht die Spin-Lock-Semantik
messen, sondern die Kollision zweier ctest-Laeufe. **Die Haertung ist Vorbedingung von 1b, nicht
Kosmetik.**

---

## 3. DER DELTA (was genau fehlt -- keine Neuerfindung noetig)

Alles Traegende ist gebaut. Es fehlt **genau ein Biss**, an zwei Orten, plus ein Fixture-Wechsel:

| # | Fehlt | Vorlage existiert |
|---|---|---|
| D1 | **Rueckdesen** des geschriebenen Stempels im Binaries-Realm | Schreibweg `test_lb0:542-567`; Lese-Naht `BaumAblage::datei_lesen` (`lager_baum_writer.hpp:468`, Filesystem-Impl `:493`) |
| D2 | **Rueckdesen** des geschriebenen Stempels neben dem Knoten-Log | Schreibweg `test_lb1:522-527`; dieselbe Naht |
| D3 | **Zeilenweise verbatim-Auswertung** des Zurueckgelesenen | `split_lines()` + Zeilen-`EXPECT_EQ` in `test_g1_binary_version_stamp.cpp:28-40,81-104` |
| D4 | Ein **mehrzeiliger** Stempel-Fixture (der heutige ist einzeilig -> "jede Zeile" waere trivial erfuellt) | Vier-Zeilen-Form `g1_binary_version_block()`, gepinnt in `test_g1:81-104` |
| D5 | (Vorbedingung fuer 1b) **kollisionsfeste Temp-Wurzel** in beiden Fixtures | `comdare_test_tmp.hpp` `user_tmp_dir()`, in 39 TUs im Einsatz |
| D6 | (Stufe 1b) **echte Nebenlaeufigkeit** auf `make_filesystem_ablage()` statt `FakeAblage` | Sequenzielle Konkurrenz-Form `test_lb1:420-446`; Filesystem-Naht `test_lb1:524` |

**Kein neuer Header noetig** (ausser dem optionalen geteilten Test-Helfer, Biss B-1).
**Keine neue CMake-Registrierung noetig** -- beide TUs haengen bereits an `comdare_add_test`
(`ce/tests/unit/CMakeLists.txt:4957` und `:4970`).
**Keine Produktivdatei beruehrt.**

---

## 4. BAU-ANWEISUNG (ausfuehrbar, mit Bissen)

Reihenfolge ist bindend: B-1 vor B-2/B-3 (sonst dreifache Kopie derselben Helferfunktion),
B-4 vor B-6.

### B-1 -- Geteilte Zeilen-Helferin (neuer Test-Header)

**Datei (neu):** `ce/tests/unit/stempel_zeilen.hpp`
**Muster:** exakt `comdare_test_tmp.hpp` -- header-only, `#pragma once`, kein CMake-Ziel, Einbindung
per Anfuehrungszeichen (`#include "stempel_zeilen.hpp"`; Praezedenz: `kf16_e2e_real_build.cpp:6`,
`test_234_va_shaped_adapter.cpp:16`, `test_45_sosd_uint64_loader.cpp:7`).

**Inhalt:** `namespace comdare::test { [[nodiscard]] inline std::vector<std::string>
split_lines(std::string const&); }` -- **wortgleich uebernommen** aus
`test_g1_binary_version_stamp.cpp:28-40` (inklusive des defensiven Rest-Zweigs fuer
nicht-`\n`-terminierte Inhalte und des Kommentars, der genau das erklaert).

**Biss:** `test_g1_binary_version_stamp.cpp` bindet den Header ein und **loescht seine lokale
Kopie**; die vier Zeilen-`EXPECT_EQ` (`:84-104`) bleiben unveraendert. Damit gibt es genau eine
Zerlegungs-Regel im Repo -- die Alternative (drei Kopien) ist die Drift-Falle, vor der der
`test_lb0`-Kopf in seiner eigenen Sprache warnt ("ein Fork der Grammatik faellt hier auf").

**Abnahme:** `test_g1_binary_version_stamp` bleibt gruen, Verhalten unveraendert (reiner Umzug).

### B-2 -- Binaries-Realm: schreiben, zurueckdesen, jede Zeile einzeln

**Datei:** `ce/tests/unit/test_lb0_lager_pfad_grammatik.cpp`,
Test `Lb3Einlagerung.OeBDummyLagerBeideRealmsAufEchtemDateisystem` (`:542`).

**Biss 2a -- die Ablage festhalten statt zweimal wegzuwerfen.** Heute (`:544-545`) wird
`bl::make_filesystem_ablage()` zweimal als Temporary in die Writer gereicht; der Test hat danach
keinen Lese-Griff. Neu: **ein** `auto const ablage = bl::make_filesystem_ablage();` anlegen und
beiden Writern uebergeben. Damit steht `ablage.datei_lesen(...)` zur Verfuegung -- **die offizielle
Naht, kein `std::ifstream`**, kein neuer Include, und der Rueckweg beweist zugleich, dass beide
Richtungen derselben Naht zusammenpassen.

**Biss 2b -- mehrzeiliger Stempel-Fixture (D4).** `stempel` (`:548`) wird von einem einzeiligen
String auf einen **`\n`-terminierten Vier-Zeilen-Block in Stempel-Form** gehoben, gebildet aus einem
`std::array<std::string,4>` **erwarteter** Zeilen (Zeilen-Form nach dem Vorbild
`test_g1:84-104`: Planer-Selbst-Zeile, `ceb-contract=`, `build-type=`, `build-version=`; die
Werte bleiben simulierte Dummy-Werte -- der Owner nennt die Stufe ausdruecklich
"simulierte Textdokumente"). Der geschriebene Block ist die Zusammensetzung genau dieses Arrays.

**Biss 2c -- der eigentliche Rueckdes-Biss.** Nach `ASSERT_TRUE(b.ok())`:

1. `auto const roh = ablage.datei_lesen(b.blatt_pfad);` -> `ASSERT_TRUE(roh.has_value())`
   (Negativ-Aussage mitnehmen: der Lese-Zweig der Naht ist belegt, nicht nur `fs::exists`).
2. `auto const zeilen = comdare::test::split_lines(*roh);`
3. `ASSERT_EQ(zeilen.size(), 4u)` **und** `EXPECT_EQ(std::count(roh->begin(), roh->end(), '\n'), 4)`
   -- Anzahl UND Terminierung, wie `test_g1:81-83`.
4. **Schleife ueber alle vier Zeilen mit `EXPECT_EQ(zeilen[i], erwartet[i]) << "Zeile " << i`** --
   das ist "jede Zeile verbatim". Zusaetzlich je Zeile die Praefix-Probe
   (`rfind("build-version=",0)==0u` usw.), damit ein vertauschtes Zeilenpaar nicht durchrutscht.
5. **Negativ-Probe (Pflicht, sonst ist es ein Schoenwetter-Test):** eine bewusst verfaelschte
   Erwartungszeile in einem eigenen Block gegen den Rueckleser fuehren und
   `EXPECT_NE` belegen -- die TU haelt sich per Kopfkommentar selbst auf "GOLDEN-STRING ODER
   NEGATIV-PROBE" (`test_lb0:5`) fest.

**Biss 2d -- Test-Log daneben, auch lesend.** Das Test-Log (`:553`, `bl::test_log_neben("perm.dll")`,
Inhalt `"ctest: 0 failed\n"`) ebenfalls zurueckdesen und **seine eine Zeile** verbatim pruefen. Das
schliesst die LED-68b-Zusage ("Test-Log liegt NEBEN der Binary") auf der Leseseite.

**Abnahme B-2:** Die Zeilen des Stempels und die Zeile des Test-Logs stammen literal aus der Platte,
nicht aus der Variablen, die geschrieben wurde -- der Vergleich laeuft gegen das **Erwartungs-Array**,
nie gegen `stempel` selbst (sonst prueft der Test `x == x`).

### B-3 -- Knoten-Realm: derselbe Biss auf `perm.dll`

**Datei:** `ce/tests/unit/test_lb1_knoten_heuristik_log.cpp`,
Test `Lb1DummyLager.KnotenLogLebtImRealenBaumNebenDenBlaettern` (`:522`).

`ablage` liegt hier bereits als benannte Variable vor (`:524`) -- der Griff existiert schon.

**Biss 3a:** `ablage.datei_schreiben(knoten + "/perm.dll", ...)` (`:527`) bekommt denselben
mehrzeiligen Stempel-Block wie B-2 (identische Zeilen-Form; das ist der Punkt: **ein** Stempel-Bild
in beiden Realms, sonst driften die zwei Dummy-Lager auseinander).

**Biss 3b:** Nach dem gruenen `mit_knoten_lock`-Zyklus (`:544`):
`ablage.datei_lesen(knoten + "/perm.dll")` -> `split_lines` -> Zeilen einzeln gegen dasselbe
Erwartungs-Array. **Und die Zusatz-Aussage, die nur hier moeglich ist:**
`EXPECT_EQ` der Zeilen **nach** dem Truncate-/Inventur-Lauf -- die Inventarisierung schreibt den
Knoten-Log, und der Beweis ist, dass sie das **Blatt daneben unangetastet** laesst. Genau diese
Nachbarschafts-Invariante ("das Log lebt im realen Baum NEBEN den Blaettern") behauptet der Testname
heute, ohne sie am Blatt-Inhalt zu pruefen.

**Abnahme B-3:** Die vier Stempel-Zeilen sind nach Lock-Zyklus + Truncate + Inventur byte-gleich;
`bl::lade_knoten_log` bleibt wie gehabt gruen (`ast_vollstaendig()`, `binaries == 1u`).

### B-4 -- Kollisionsfeste Temp-Wurzel (Vorbedingung fuer B-6, empfohlen auch ohne)

**Dateien:** `test_lb0...:118-137` (`TempLager`), `test_lb1...:106-124` (`TempKnoten`).

**Biss:** `#include "comdare_test_tmp.hpp"` und die Wurzel von
`fs::temp_directory_path() / "comdare_lb0_lager"` auf
`comdare::test::user_tmp_dir() / "comdare_lb0_lager"` (analog `comdare_lb1_knoten`) drehen.
`remove_all`/`create_directories` bleiben unveraendert -- sie sind dann auf eine uid- UND
build-verzeichnis-eindeutige Wurzel eingeschraenkt und koennen keinen fremden Lauf mehr abraeumen.

**Abnahme:** beide TUs gruen; der Pfad in einem `<< `-Diagnosetext (oder einmalig lokal
ausgegeben) traegt uid- und Build-Tag-Anteil.

### B-5 -- Verifikations-Pflichtlauf (kein Erfolg ohne literale Ausgabe)

1. Bau der beruehrten Ziele im bestehenden Baum `ce/build/land` (konfiguriert, kein Neu-Konfigurieren).
2. **ctest-Doppellauf** ueber den Job-Schnitt `-LE pmc`; erwartet literal
   `100% tests passed, 0 tests failed out of 405` -- Bezugsgroesse: heute 407 registriert, 2 mit
   LABEL `pmc`.
3. **`ctest -N` Namens-Diff** gegen den Stand vor dem Biss: **leer**, wenn kein neuer Test angelegt
   wird (B-2/B-3 erweitern bestehende Tests). Legt B-6 einen neuen `TEST_F` an, ist der Diff
   **genau eine Zeile** -- und die gehoert in die Commit-Botschaft.
4. **cf22 / `lint:format`** ueber die beruehrten Dateien -- Lehre aus Ledger `:4335-4345`
   (nachmittag-10, Abschnitt B): T2-A und B14 landeten "ohne je gegen cf22 gefahren zu sein",
   `lint:format` prueft **ganze Dateien**, nicht Diffs; das kostete zwei Nachzugs-Commits in zwei
   Repos.
5. **ASCII-Selbstcheck** aus dem Diff (0 Nicht-ASCII in hinzugefuegten Zeilen).
6. Working Tree danach eingefroren (`git status --porcelain` leer), Ledger-Nachtrag mit
   LB-6-Stufen-Kennung -- **Regel-Zeile 10** (`LEDGER:4457-4462`): ein Paketschnitt, der nur im
   Session-Doc steht, existiert fuer die Ausfuehrung nicht.

### B-6 -- Stufe 1b (OPTIONAL, siehe Termin-Urteil): echte Konkurrenz auf echtem Dateisystem

**Datei:** `test_lb1_knoten_heuristik_log.cpp`, neuer `TEST` neben `Lb1DummyLager`.

**Biss:** `TempKnoten` (nach B-4) + `bl::make_filesystem_ablage()` + **zwei `std::thread`**, die
`mit_knoten_lock` auf denselben Knoten fuehren; Erwartung wie in der sequenziellen Form
(`:420-446`): genau **einer** bekommt `LockOutcome::ok` und truncatet, der andere
`lock_unavailable`, die Zaehlung bleibt konsistent, die Lock-Datei
(`bl::lock_key_for(bl::knoten_log_pfad(knoten))`) ist am Ende **weg**.

**FLAKE-AUFLAGE (nicht verhandelbar, sonst faellt die Pipeline-Doktrin "immer hart gruen"):** die
Erwartung darf **nicht** lauten "Thread A gewinnt", sondern nur "**genau einer** gewinnt" (Summe
`ok == 1`, Summe `lock_unavailable == 1`); kein `sleep`-basiertes Timing; die `SkriptUhr` bleibt die
Zeitquelle, damit Frist-Faelle deterministisch sind. Ohne diese Form ist B-6 ein Flake-Generator und
gehoert **nicht** vor den Trigger.

---

## 5. CI-EINHAENGUNG (belegt, keine eigene CI-Aenderung noetig)

**Beide TUs tragen keine ctest-LABELS** -- gepruefte Quelle ist der konfigurierte Baum, nicht die
Vermutung: `ce/build/land/tests/unit/CTestTestfile.cmake:794` und `:796` fuehren als Properties nur
`TIMEOUT "60"` und `_BACKTRACE_TRIPLES`, **kein `LABELS`**.

Der Job `test:unit` faehrt den **Komplement-Schnitt**: `ce/scripts/ci_test_coverage_manifest.sh:127-129`
setzt `CE_COV_MODE_test_unit="-LE"`, `CE_COV_PATT_test_unit='pmc'`, `CE_COV_GATE_test_unit="always"`.
Ausgeschlossen wird also **nur** die `pmc`-Klasse (2 von 407 Tests). Label-lose Tests sind damit
**per Konstruktion** eingeschlossen -- und bleiben es auch, wenn B-6 einen neuen Test anlegt, solange
dieser kein Label bekommt.

**Empirische Gegenprobe im Baum `e7aa1244`:** `ctest -N -LE pmc` listet `Test #362
test_g1_binary_version_stamp`, `Test #394 test_lb0_lager_pfad_grammatik`, `Test #395
test_lb1_knoten_heuristik_log` -- alle drei beruehrten TUs sind gedeckt.

**Warum das ausdruecklich hier steht:** genau diese Naht ist heute repariert worden. Vor dem
R4-CI-Wurzel-Fix (`baaaea62` + `dcb2f08f`, Ledger `:5071-5076` und `:5145-5186`) schnitt die
Job-Auswahl `-LE contract|pmc` -- alles mit Label `contract` fiel still aus **jedem** Job. Der Fix
zog den Wurzelschnitt auf `-LE pmc` und stellte `test:coverage-guard`
(`ce/scripts/ci_test_coverage_guard.sh`) als eigenen Gate-Job daneben. **Konsequenz fuer diesen Plan:
B-1..B-6 duerfen keinem der beruehrten Tests ein Label geben.** Ein Label ist hier kein Ordnungsmerkmal,
sondern ein potenzieller Ausschluss.

Laufzeit-Bezugsgroesse: `ce`-Pipeline **15025** = SUCCESS, 279 s, 20 Jobs (19 `success`, 1 `manual`
`is_original:relock`, 0 `failed`) auf genau `e7aa1244` (Ledger `:4207-4212`).

---

## 6. GOLDEN- UND TABU-BELEG

**Golden-neutral -- belegt, nicht behauptet.** Beide TUs schreiben ausschliesslich unter
`fs::temp_directory_path()`: **je genau 1** Treffer von `temp_directory_path` je Datei
(`test_lb0:121`, `test_lb1:109`), Unterverzeichnisse `comdare_lb0_lager` bzw. `comdare_lb1_knoten`.
Nach B-4 liegt die Wurzel unter `comdare::test::user_tmp_dir()` -- ebenfalls unterhalb von
`temp_directory_path()`, nur uid- und build-eindeutig.

Grep auf `minio|golden|/mnt/|nas` (case-insensitiv) liefert **6** Treffer, **alle in Kommentaren oder
in der Test-Vokabel "GOLDEN-STRING"**, kein einziger als Pfad oder Ziel:

    test_lb0:5    "// ... entweder einen GOLDEN-STRING oder eine NEGATIV-PROBE."
    test_lb0:13   "// ... Kein minio, kein Netz, kein mc."
    test_lb0:142  "// (1) GOLDEN-STRINGS der Grammatik -- die drei A9-Namens-Beispiele ..."
    test_lb0:182  "// (2) GOLDEN-STRINGS der Ordner-Ebenen -- A9-Doc 6.1."
    test_lb0:321  "// LB-0: Baum-Pfad == minio-Objekt-Praefix. EINE Funktion, keine zweite Uebersetzung."
    test_lb1:9    "// ... Kein minio, kein Netz, kein mc; die Zeit kommt ueber eine SKRIPT-Uhr ..."

**TABU-Beleg:**

- **Keine Produktivdatei.** Der Delta beruehrt ausschliesslich `ce/tests/unit/*` (2 bestehende TUs,
  1 neuer Test-Header, optional 1 Umzug in `test_g1`). **Kein Header unter
  `libs/cache_engine/builder/bestandslog/`**, keine ABI-Datei, keine `binary_id`-Welt.
- **Keine golden-XML/CSV, kein `experiment_golden_kern.xml`, keine Registry.**
- **Kein `algo_sig`, kein Fingerprint-Preimage, kein Stempel-Format im Produktivcode** -- die
  Zeilen-Form wird im **Test** erwartet, nicht im Produktivcode veraendert. (Die Stempel-Homonymie
  ist in beiden TU-Koepfen ausdruecklich festgehalten -- `test_lb0:15-21`, `test_lb1:12-16`: gemeint
  ist der LAGER-/SIDECAR-Stempel, **nicht** `bestandslog::slice_plan_stamp` `|bau=` und **nicht** der
  einkompilierte Versionierungs-Stempel. Dieser Plan bleibt beim Lager-Stempel.)
- **Kein Netz, kein minio, kein `mc`, kein NAS, kein Cluster.** Damit auch kein Konflikt mit der
  Cluster-read-only-Doktrin.
- **Messdaten unberuehrt** (kein `build/`-Aufraeumen; die Doktrin "Mess-CSV im Bau-Verzeichnis"
  bleibt gewahrt, weil kein Bau-Verzeichnis geloescht wird).

---

## 7. AUFWANDSSCHAETZUNG

| Biss | Umfang | Schaetzung |
|---|---|---|
| B-1 geteilter Zeilen-Helfer + Umzug in `test_g1` | 1 neue Datei ~30 Zeilen, 1 TU angepasst | 15-20 min |
| B-2 Binaries-Realm (2a-2d) | ~40-55 hinzugefuegte Zeilen in 1 Test | 35-45 min |
| B-3 Knoten-Realm (3a-3b) | ~25-35 hinzugefuegte Zeilen in 1 Test | 20-30 min |
| B-4 Temp-Wurzel-Haertung | 2 Fixtures, je 2 Zeilen + 1 Include | 15 min |
| B-5 Verifikation (Bau, Doppellauf, `-N`-Diff, cf22, ASCII, Ledger) | -- | 25-35 min |
| **Summe Stufe 1 (B-1..B-5)** | **~110-140 hinzugefuegte Test-Zeilen, 0 Produktivzeilen** | **~2,0-2,5 h** |
| B-6 Stufe 1b (echte Konkurrenz) | 1 neuer `TEST`, 2 Threads, Flake-Auflage | **+1,5-2,0 h**, Rest-Flake-Risiko |

Dazu je Landung eine CI-Runde; Bezugsgroesse Pipeline 15025 = **279 s**.

Der Bau-Baum `ce/build/land` ist **bereits konfiguriert** (407 Tests registriert) -- es faellt ein
inkrementeller Bau von 2-3 TUs an, kein Voll-Bau. Das ist die Grundlage der Zeitschaetzung; ein
erzwungener Voll-Bau wuerde sie umwerfen.

---

## 8. TERMIN-EINORDNUNG (ehrlich)

**Frist-Lage:** Abgabe **Fr 08.08.**, Trigger-Ziel **Do 07.08.** LB-6 ist als **Vor-Trigger-Pflicht**
deklariert (F9: "der Voll-Bau-Trigger IST der Baum-Vollausbau"), und der Ledger-Folgeposten
(`:4465`) empfiehlt Stufe 1 ausdruecklich **VOR** dem Trigger.

### 8.1 Was passt: Stufe 1

**JA.** B-1..B-5 sind ~2,0-2,5 h, test-only, golden-neutral, ohne CMake-Ziel-Aenderung, ohne
Produktivdatei, in einem bereits konfigurierten Baum, in einem Job, der bereits gruen faehrt. Das ist
vor Do 07.08. unterzubringen, auch neben anderer Arbeit.

### 8.2 Was NICHT passt: LB-6 als Ganzes

**NEIN -- und das muss offen gesagt werden, sonst wiederholt sich genau der Buchungsfehler, den
Abschnitt F des Ledger-Nachtrags nachmittag-10 ruegt.** LB-6 nennt vier Gegenstaende. Stufe 1 deckt
den ersten und die Haelfte des vierten:

| LB-6-Gegenstand | Lage | Vor Do 07.08.? |
|---|---|---|
| OE-B-GTest-Dummy-Lager **auf Baum-Form erweitert** | Baum-Form steht (LB-0..LB-1 gebaut+getestet); es fehlt der Rueckdes-Biss | **JA** = dieser Plan |
| **Beweis 1** (Batch-Wiederaufnahme-Konstruktion, 2 Layer, versions-scharfer per-Binary-Nachbau) | OE-A: **PFLICHT zu konstruieren, kein Minimal-Ersatz**. Ledger `:5775` fuehrt ihn unter **B10** unveraendert als offen ("V7.4-4+1-Beweise + G6(J-0..J-5) auf GEEICHTEM Stand NEU erbringen"); keine Zeile zwischen 01.08. und heute meldet Vollzug | **NEIN** -- eigenes Paket (Driver-E2E), nicht Stunden |
| **Beweis 2** (Hydration `verified>0` UND `pruned>0`) | per K2 auf dem Fake-mc-Weg akzeptiert; Substanz in `ce/tests/unit/test_g3_prune.cpp` (Verify-Matrix, `PruneNeverTouchesMeasureData`) und `test_g3_lager_presence.cpp` | ausserhalb dieses Deltas |
| **Beweis 4** (Bestandslog-E2E gegen **echtes minio** + Takeover-Zweig) | echtes minio = Infra. **Cluster-read-only-Doktrin** -- strukturell ausserhalb der Reichweite dieser Rolle | **NEIN** -- Owner/Infra |
| Truncate-/**Spin-Lock-Konkurrenz**-Test | Zustandslogik belegt (`test_lb1:420,448`), **echte** Nebenlaeufigkeit auf echtem FS **unbelegt** (0 `std::thread`) | **TEILWEISE** -- B-6, nur mit Flake-Auflage |

### 8.3 Der kleinste Umfang, der die Zusage einloest

**Genau drei Dinge:**

1. **B-1 + B-2 + B-3** -- der Rueckdes-Biss in beiden bestehenden Tests, mit mehrzeiligem
   Stempel-Fixture und Zeile-fuer-Zeile-`EXPECT_EQ` plus Negativ-Probe. Das ist die woertliche
   Einloesung von "aus simulierten Textdokumenten die Stempel auszulesen und jede Zeile verbatim
   auszuwerten". **Ohne den mehrzeiligen Fixture (D4) ist die Zusage NICHT eingeloest** -- bei einem
   einzeiligen Stempel ist "jede Zeile" eine leere Aussage.
2. **B-5** -- der Verifikations-Pflichtlauf mit literaler Ausgabe.
3. **Eine deklarierte Herabstufung** von Beweis 1, Beweis 4 und der echten Nebenlaeufigkeit
   **im Ledger UND in der VOR-TRIGGER-CHECKLISTE**, mit Datum und benanntem Owner-Entscheidpunkt.
   Ohne diesen dritten Punkt wird "LB-6 Stufe 1 fertig" beim naechsten Lesen zu "LB-6 fertig" --
   und das waere dieselbe Verlustklasse, die den Paketschnitt ueberhaupt erst verschwinden liess.

**B-4** kostet 15 min und beseitigt eine im Repo bereits dokumentierte Flake-Klasse; Empfehlung:
mitnehmen. **B-6** ist der einzige Posten mit echtem Terminrisiko -- wenn die Zeit bis Do knapp
wird, ist er der Kandidat fuer die deklarierte Verschiebung, **nicht** der Rueckdes-Biss.

---

## 9. OFFENE OWNER-ENTSCHEIDE AUS DIESEM PLAN

- **E-1 (klein, Bau-intern entscheidbar):** Bleibt der mehrzeilige Stempel ein **lokaler
  Dummy-Fixture** (so die Owner-Wortwahl "simulierte Textdokumente"), oder wird er an die echte
  Single-Source `pf::g1_binary_version_block()` gebunden? Zweiteres bindet die Attrappe drift-frei an
  die Produktiv-Form, verlangt aber eine **zusaetzliche Include-Kante**: `profile_facade` liegt unter
  `ce/libs/cache_engine/profile_facade`, waehrend `test_lb0`/`test_lb1` heute nur
  `libs/cache_engine/builder`, `.../include`, `.../src` und `libs/common` sehen
  (`CMakeLists.txt:4959-4963` und `:4972-4976`). **Empfehlung: Stufe 1 lokal** (Dummy heisst Dummy),
  die Bindung an die echte Single-Source gehoert zu **Stufe 2**, wo die Binary den Stempel wirklich
  traegt.
- **E-2:** Faehrt B-6 vor dem Trigger oder danach? (Siehe 8.3.)
- **E-3 (angrenzend, NICHT von diesem Plan zu entscheiden):** Beweis 1 (B10) und Beweis 4 (minio)
  bleiben laut juengstem Ledger-Stand offen. Beweis 4 ist Infra-gebunden.

---

## 10. FOLGEPOSTEN: STUFE 2 (BINARY-STUBS) -- NACH DER ABGABE, NICHT HIER

Der Owner nennt Stufe 2 in derselben Nachricht: "dasselbe mit compile Binary stubs fuer das
Stempelsystem zu wiederholen (Binary compile der eigentlich nur das statische Stempel interface der
Versionierung enthaelt als leere Tier-Binary)".

**Sie gehoert NICHT in dieses Fenster:** sie haengt am gesonderten Versionierungs-Interface
(F7 = Option b, `super/docs/plaene/20260806-PLAN-versionierungs-interface-stempel.md`) -- der Stub
ist genau die Binary, die **nur** dieses Interface traegt. Interface-Bau und Stub-Test gehoeren in
dieselbe Planung, und die liegt nach der Abgabe.

**Die Vorlage existiert bereits und ist am Objekt geprueft:**
`ce/tests/unit/genus_buildvariant_avx2.cpp`, **30 Zeilen** (`wc -l`), eine **echt kompilierte
SHARED-Bibliothek ohne Anatomie-Rumpf**: drei winzige `constexpr`-Achsen-Attrappen (`DenseBytePage`,
`Avx2Ext`, `X86_64Hw`) und ein einziges Makro
`COMDARE_DEFINE_BUILD_VARIANT_INSPECTION(comdare_build_variant_inspect, ...)`. Gebaut wird sie in der
boost-freien DLL-Schleife `ce/tests/unit/CMakeLists.txt:3583` / `:3599-3601`
(`add_library(${_dll} SHARED ...)`, Ziel `perm_buildvariant_avx2`).

**Sie nennt sich selbst "dieser Stub"** -- Kopfkommentar der Datei, woertlich:

> "GO-3 A1 (2026-07-12): dieser Stub ist ein POD-ROUNDTRIP-Beweis (Etikett-Transport), KEINE
> Build-Wahrheit -- er deklariert die Avx2-Form bewusst OHNE ISA-Flag (Legacy-Makro). Build-Wahrheit
> (Etikett == Maschinencode) beweisen die real-Wrapper-DLLs via
> COMDARE_DEFINE_BUILD_VARIANT_INSPECTION_CHECKED (genus_buildvariant_real_*.cpp)."

**Was Stufe 2 daraus macht:** dieselbe 30-Zeilen-Form, aber das Makro traegt statt der
Build-Varianten-Inspektion **das statische Versionierungs-Stempel-Interface**; der Host laedt die
`.so`, zieht die Stempel-Zeilen ueber die echte `.dll`-Grenze und faehrt **denselben zeilenweisen
Verbatim-Vergleich wie Stufe 1** darueber. Der geteilte Helfer aus B-1 wird dort unveraendert
wiederverwendet -- das ist der zweite Grund, ihn jetzt als Header und nicht als Kopie anzulegen.

**Ausdruecklich NICHT Teil dieses Plans:** kein Bau, keine Terminzusage, keine Aufwandsschaetzung
fuer Stufe 2 in diesem Fenster.

---

## 11. SELBSTCHECK

- ASCII-only ausserhalb der Zitate: ja (Zitate stehen als Blockzitate und sind ihrerseits ASCII).
- Jede Zahl mit Bezugsgroesse: 407 registriert / 2 `pmc` / 405 im Schnitt; 33 bzw. 23 TEST-Makros;
  39 vs. 12 Temp-Doktrin; 30 Zeilen Stub; 279 s Pipeline 15025.
- **UNBELEGT gekennzeichnet:** (a) ob die uebrigen 10 TUs mit direktem `temp_directory_path()`
  ebenfalls festen Namen + `remove_all` kombinieren; (b) Beweis 1 und Beweis 4 -- keine Ledger-Zeile
  zwischen 01.08. und 06.08. meldet Vollzug, B10 (`LEDGER:5775`) fuehrt sie unveraendert als offen.
- Kein Commit, kein Edit an Code aus diesem Dokument.
