# PLAN F3 / F5 / R4 / B12 UND DER ABSCHLUSS-AUFRAEUMPASS

> **ZEIGER (08.08.2026): die geltende Kandidatenliste ist `20260808-KANDIDATENLISTE-75-abschluss-aufraeumpass.md`.**
> Dieser Plan bleibt gueltig als **AP-01…AP-13-Erhebung** (die Einzel-Nachweise je AP-Posten sind dort
> nicht wiederholt) — aber er deckt nur 13 der inzwischen **126** gefuehrten Kandidaten ab. Sein
> eigener Posten **AP-13** („die VOLLSTAENDIGKEITS-LUECKE der Liste selbst") ist mit der zentralen
> Liste abgearbeitet: AP-13 hatte den Befund korrekt gestellt, zwei Tage vor der Ledger-Reconciliation.
> Ein Nachtrag aus dem Zusammenfuehren: **AP-01 (leere 3D-caption) ist ERLEDIGT** — nachgewiesen an
> `Code/05_diagram_generator/diagram_generator.cpp` (`data.title = surface3d_title(...)`, super
> `7969a02c`); Ledger `:6926` und das Register fuehren ihn noch als offen.

> Stand 06.08.2026 abends. READ-ONLY-Erhebung, keine Code-Edits, kein Commit.
> Jeder Posten gegen den HEUTIGEN Objektstand geprueft; jede Zahl mit Bezugsgroesse.
> Nicht Belegbares ist als UNBELEGT gekennzeichnet.

---

## 0. MESSANKER UND METHODE

### 0.1 Der Objektstand, selbst gemessen

| Gegenstand | Wert (am Objekt erhoben) |
|---|---|
| super `development` | `f874c9eb8a6a46936eb7c887e3e0fd90408c7c5f` |
| ce `development` (= Gitlink im super) | `e7aa124445e5ddab461251bdb43f81e4562b9213` |
| Thesis-Zeiger `Code/external/20260931-overleaf-diplomarbeit` | `8970465dcc6fff41a1e1ab74606d6dce2a457224` (Gate 8) |
| Thesis-Zeiger `thesis/diplomarbeit` (ZWEITER Checkout desselben Repos) | `29a1700de18fe...` -- **liegt VOR Gate 8** |
| prt-art | `c6f07540e7e8...` |

**ABWEICHUNG ZUM AUFTRAG, harmlos, aber zu vermerken:** der Auftrag nennt super `85b74237`.
Am Objekt liegen zwischen `85b74237` und `f874c9eb` **4 Commits**, deren Diff **genau eine Datei**
beruehrt (`docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md`); der ce-Gitlink ist **0-mal** beruehrt.
Der Bau-Stand ist also identisch zum Auftragsstand, nur die Buchfuehrung ist weitergelaufen.

**LIVE-SCHREIBER-WARNUNG (methodisch relevant):** waehrend dieser Erhebung war der Ledger
**aktiv in Bearbeitung** durch eine Parallel-Linie (`git status` zeigte ` M` auf der Datei, mtime
19:04:53 bei Erhebungszeit 19:05:26; die Datei wuchs waehrend der Lesung von 5798 auf 5808 Zeilen,
und Abschnitt-Anker verschoben sich um 10 Zeilen). **Konsequenz fuer dieses Dokument: es zitiert
INHALTS-Anker (Ueberschrift + Wortlaut), nicht Zeilennummern des Ledgers.** Zeilennummern werden nur
fuer Quelldateien verwendet, die in dieser Zeit unveraendert waren.

### 0.2 Die Quellenlage, nach Alter sortiert (die juengste gewinnt)

| # | Quelle | Zeit 06.08. | fuer diesen Plan tragend |
|---|---|---|---|
| 1 | `docs/plaene/20260806-PLAN-lb6-stufe1-oeb-baumform.md` | 19:08 | nein (LB-6, eigener Strang) |
| 2 | `docs/plaene/20260806-PLAN-wellenplan-vollbild-und-parallelisierung.md` | 19:07 | **JA** -- fuehrt die 10er-Kandidatenliste und die Bandzuordnung |
| 3 | `docs/plaene/20260806-PLAN-testoffensive-und-gruene-pipeline.md` | 18:06 | teilweise |
| 4 | `docs/sessions/20260806-ANKLAGE-kostenklammern-plan-diff.md` | 16:58 | teilweise |
| 5 | `docs/plaene/20260806-PLAN-host-belegung-batch-plan-ablage.md` | 16:35 | nein |
| 6 | `docs/sessions/20260806-FAHRPLAN-hauptstrang-landung.md` | 16:24 | **JA** (Bau-Block-Klausel) |
| 7 | `docs/sessions/20260806-REGISTER-todo-konsolidierung-14-tage.md` | 14:40 | **JA** (Kandidatenliste 1-8, Nr. 9, Nr. 10) |
| 8 | `docs/plaene/20260806-PLAN-golden-update-fenster.md` | 12:49 | **JA** (F5) |
| 9 | `docs/plaene/20260806-PLAN-scheibe6-weg-a-fixture-entflechtung.md` | 12:42 | **JA** (F3) |
| 10 | Ledger `nachmittag-10` | live | **JA** |

Die beiden juengsten Plandokumente (2 und 1) sind **nach** der Erhebung entstanden, die diesem
Auftrag zugrunde lag; Quelle 2 wurde deshalb hier vollstaendig gegengelesen und aendert an zwei
Stellen das Ergebnis (siehe AP-01 und die Doppelbuchung von AP-02).

### 0.3 Was nicht geprueft wurde (Scope-Ehrlichkeit)

- **Kein Bau, kein ctest, keine Pipeline-Ausloesung.** Alle Aussagen ueber Compiler-/Test-Verhalten
  sind Quelltext-Lesungen, nicht Laufbeweise. Wo ein Laufbeweis noetig waere, steht es dabei.
- **Kein Worktree unter `/home/comdare/wt-*` beruehrt** (Auftragsauflage).
- **Kein `git` in Codex** (Auftragsauflage); alle Repo-Messungen wurden hier direkt erhoben.

---

## 1. POSTEN F3 -- SCHEIBE-6 WEG A (Fixture-Entflechtung)

### 1.1 Plan-Zitat mit Datum

**Owner verbatim, 06.08. vormittag-50** (Ledger, Abschnitt "OWNER-ENTSCHEIDE F1/F3/F4/F5/O-3"):

> "F3: Bitte sauber die fixture nachziehen und am besten nochmal gruendlich planen."

**Plan `docs/plaene/20260806-PLAN-scheibe6-weg-a-fixture-entflechtung.md` (06.08. 12:42),
Schritt 0 -- VORBEDINGUNG:**

> "B14 muss gelandet sein. `fixture_schema_subset_check.cmake` und die `add_test`-Zeilen existieren
> heute nur in `wt-b14-golden` ... Pruefkommando: `test -f Code/tests/fixture_schema_subset_check.cmake`
> im `development`-Arbeitsbaum muss RC=0 liefern."

### 1.2 Ist-Stand am Objekt

| Pruefpunkt | Messung | Folge |
|---|---|---|
| `Code/tests/fixture_schema_subset_check.cmake` | **existiert** (14810 Byte) | Vorbedingung **erfuellt** |
| `Code/tests/golden_n_consistency_check.cmake` | **existiert** (31506 Byte) | B14-super vollstaendig gelandet |
| B14-super-Commit `1ba29b63` | `merge-base --is-ancestor` gegen super/development: **JA** | gelandet |
| B14-ce-Commit `16a173f2` | `merge-base --is-ancestor` gegen ce/development: **JA** | gelandet |
| ce-Fixture-Name | weiterhin `tests/unit/thesis_tiere/experiment_golden_kern.xml` | **Rename NICHT vollzogen** |
| `add_test(NAME test_fixture_schema_experiment_golden_kern ...)` | `Code/tests/CMakeLists.txt:170-175`, `-DFIXTURE=${COMDARE_CACHE_ENGINE_DIR}/tests/unit/thesis_tiere/experiment_golden_kern.xml` | haengt am ALTEN Namen |
| Schritt 3 des Plans (CI-Heimat der Naht) | durch R4 erledigt, **strenger als geplant** (Abschnitt 3) | entfaellt |

**DER TRAGENDE BEFUND -- R1 ist ungemindert scharf.** Der Plan (Abschnitt 3, "Stumm-Wachen-Risiko
R1") verlangt, dass die Wache nach der Umbenennung nicht still skippt. Am Objekt,
`Code/tests/fixture_schema_subset_check.cmake:98-103`, literal:

```
if(NOT EXISTS "${FIXTURE}")
    message(STATUS "Nachbar-Checkout fehlt (FIXTURE='${FIXTURE}') -- diese Wache kann nichts aussagen.")
    message(STATUS "COMDARE-XML-WACHE-SKIP")
    return()
endif()
```

Die B14-NB4/NB5-Haertungen haben **SCHEMA** und **MASTER** auf FATAL gezogen (`:87-97`, mit
ausgeschriebener Begruendung "kein Nachbar-Checkout, also kein SKIP") und die Werkzeug-Pflicht
vorgezogen (`comdare_xml_require_tool` VOR jedem Skip). **Genau die eine Unterscheidung, die Weg a
braucht -- "Verzeichnis da, Datei weg" = FATAL statt SKIP -- fehlt.** Sie fehlt konsistent, nicht
versehentlich: sie wird erst durch die Umbenennung ueberhaupt erreichbar.

### 1.3 Verdikt

**FAELLIG, ABER NICHT VOR DER ABGABE.** Die Vorbedingung ist erfuellt, der Owner-GO liegt vor
(vormittag-50), die Planung ist geschrieben ("am besten nochmal gruendlich planen" ist mit dem
46 KB-Plandoc erfuellt). Der Plan selbst empfiehlt in Abschnitt 6.2 die Ausfuehrung **nach der
Abgabe**; nichts an der Abgabe haengt daran. Der juengste Wellenplan (19:07) fuehrt Weg a **nicht**
unter den Vor-Trigger-Paketen -- damit bleibt die Nach-Abgabe-Verortung die juengste Aussage.

**Kein Owner-Entscheid offen. Reine Bau-Aufgabe.**

### 1.4 Bau-Anweisung

**Reihenfolge ist bindend; Schritt 2 und 3 gehoeren in EINEN Commit.**

1. **Rename im ce** (`git mv`, damit die Historie mitgeht):
   `tests/unit/thesis_tiere/experiment_golden_kern.xml` -> der im F3-Plan festgelegte Zielname.
2. **Naht-Konsumenten nachziehen** -- die im F3-Plan gezaehlten hartverdrahteten Naht-Tests:
   `tests/unit/CMakeLists.txt`, `tests/unit/thesis_tiere/test_experiment_kern_seam.cpp`,
   `libs/cache_engine/include/cache_engine/measurement/machine_identity.hpp`,
   `.../measurement/target_isa_complex_axis.hpp`.
   **Vor dem Bau nachzaehlen:** die Plan-Zahl "12 hartverdrahtete Naht-Tests" (Ledger vormittag-50)
   ist in dieser Erhebung **NICHT nachgemessen worden** -- sie gilt hier als UNBELEGT und ist im
   ersten Bauschritt am Objekt zu bestaetigen.
3. **R1-Haertung im SELBEN Commit** (`Code/tests/fixture_schema_subset_check.cmake`):
   den `if(NOT EXISTS "${FIXTURE}")`-Zweig aufteilen --
   *(a)* Elternverzeichnis der FIXTURE existiert **nicht** -> Nachbar-Checkout fehlt -> SKIP (wie
   heute, Marker unveraendert, damit die `SKIP_REGULAR_EXPRESSION` weiter greift);
   *(b)* Elternverzeichnis existiert, Datei fehlt -> **FATAL_ERROR** mit der Begruendung
   "der Nachbar ist ausgecheckt, die erwartete Fixture fehlt darin -- das ist ein Umbenennungs-
   Rueckstand, kein fehlender Checkout".
   Dieselbe Unterscheidung ist in `golden_n_consistency_check.cmake` zu pruefen (sie traegt laut
   B14-NB4 dieselbe Skip-Disziplin) -- **UNBELEGT, ob sie dort denselben Zweig hat; vor dem Bau lesen.**
4. **Gegenprobe (Mutationsprobe, Pflicht):** nach dem Bau die Fixture testweise wegnehmen und
   belegen, dass der Test **rot** wird statt SKIPPED -- literal im Gate-Log.
5. Gitlink-Bump im super, Ledger-Nachtrag.

### 1.5 Datei-Beruehrungen

- **ce:** `tests/unit/thesis_tiere/experiment_golden_kern.xml` (Rename), `tests/unit/CMakeLists.txt`,
  `tests/unit/thesis_tiere/test_experiment_kern_seam.cpp`,
  `libs/cache_engine/include/cache_engine/measurement/machine_identity.hpp`,
  `libs/cache_engine/include/cache_engine/measurement/target_isa_complex_axis.hpp`
- **super:** `Code/tests/fixture_schema_subset_check.cmake` (**R1**), ggf.
  `Code/tests/golden_n_consistency_check.cmake`, `Code/tests/CMakeLists.txt` (`:170-175` und `:211`),
  Gitlink, Ledger

### 1.6 Aufwand

**~2,5 h** -- uebernommen aus dem F3-Plan (dessen eigene Schaetzung), **plus** die R1-Haertung, die
dort als eigener Schritt gefuehrt ist. Eigene Plausibilisierung: 5 ce-Dateien + 3 super-Dateien,
davon eine mit echter Logik-Aenderung; der Rest ist mechanischer Pfad-Nachzug. Die Mutationsprobe
(Schritt 4) ist der teuerste Einzelposten, weil sie einen zweiten ctest-Lauf braucht.

---

## 2. POSTEN F5 -- GOLDEN-UPDATE-FENSTER

### 2.1 Plan-Zitat mit Datum

**Owner verbatim, 06.08. vormittag-50:**

> "F5: Bitte bewege golden und die golden Traeger, die muessen den neuen Gegebenheiten angepasst und
> geupdated werden, ebenfalls die Syntax und Semantik der XML wenn notwendig und der Interpreter
> dazu im Planer."

**Ledger-Konsequenz derselben Stelle (Lead-Verbuchung, 06.08.):**

> "(F5) GOLDEN-UPDATE-FENSTER NEU (grosser Posten, Planung vorweg) ... ACHTUNG TABU-Wechselwirkung:
> die golden-320-Byte-Wachen/CRC-Anker werden in diesem Fenster kontrolliert NEU geankert
> (Alt-golden-darf-brechen-Doktrin: erst additiv, Aufraeumen unter Absprache) -- NICHT nebenbei,
> eigenes Fenster mit Gates."

### 2.2 Ist-Stand am Objekt -- der additive Kern ist BEREITS GEBAUT

Der F5-Plan (12:49) zerlegt den Posten in S0..S7 mit einem **ABGABE-SCHNITT zwischen S5 und S6**.
Am Objekt gemessen, in `Code/test_data_xml/experiment_golden_kern.xml` (super) und im ce-Interpreter:

| F5-Anker | Messung am Objekt | Verdikt |
|---|---|---|
| G1 kaputter Achsen-Pin | `search_algo` traegt Registry-Namen, nicht `binary_search`/`linear_search` | **geheilt** |
| G2 N nicht kodiert | `allowed_variants` **23-mal** im Dokument; `<run_options cap="131072" build_version="golden_kern"/>` (Z.246) | **geheilt**, maschinenlesbar |
| G3 F-3-Regression | `<combo tools="wallclock macro micro"/>` (Z.416) -- **eine** Kombo | **geheilt** |
| G5 XSD-Vokabular | `run_options` und `organ_subaxes` additiv im Schema | **geheilt** |
| G6 Interpreter | `profile_run_entry.hpp` liest `run_options` (`:612-614` cap/n_ops, `:190/:195/:198/:199` Overrides) | **geheilt** |
| S6-Vorbereitung | `<organ_subaxes><cacheline>...` deklariert (Z.325-332), Eigenkommentar Z.299: "HEUTE DEKLARATIV: parse_experiment_profile liest `<organ_subaxes>` noch nicht" | **bewusst offen** |
| G7 Wachen | `fixture_schema_subset_check.cmake` ist xmllint-/XSD-validierend, nicht Regex-Teilmenge | **geheilt, staerker als geplant** |

**Gegenprobe zum Interpreter, selbst gefahren:** `grep -rn "organ_subaxes"` ueber
`Code/external/comdare-cache-engine/libs/cache_engine` -> **0 Treffer**. Der Block ist im XML
deklariert und im Code **nicht konsumiert** -- exakt der geplante Zustand vor dem Abgabe-Schnitt.

**DER GRUND, WARUM DAS SCHON GEBAUT IST:** die additiven Stufen sind **nicht** als eigene F5-Welle
gefahren, sondern in der B14-NB2-Heilung mitgelandet (die XML traegt den Eigenvermerk
"NB2-HEILUNG 2026-08-06"). Die Ein-Schreiber-Regel auf der golden-XML hat die beiden geplanten
Wellen faktisch verschmolzen. **Das ist eine Buchungs-Abweichung, kein Substanz-Problem** -- aber es
erklaert, warum der F5-Plan als "offen" gefuehrt wird, obwohl S0-S5 am Objekt stehen.

### 2.3 Was offen bleibt

**(a) G8 -- die ce-Naht-Fixture folgt dem erweiterten Vokabular nicht.**
`Code/external/comdare-cache-engine/tests/unit/thesis_tiere/experiment_golden_kern.xml` traegt die
neuen Elemente nicht. Kein Test haengt heute daran (die Wache prueft Gueltigkeit gegen die XSD und
Teilmengen-Treue, nicht Vollstaendigkeit) -- **klein, kein Blocker**.

**(b) S6 / A8 -- der semantische `line_size`-Konsum. TABU-beruehrend, Owner-Entscheid E-4.**
Am Objekt nachgemessen, `libs/cache_engine/builder/experiment_tree/axis_path_serialization.hpp:40`:

```
inline constexpr std::array<std::string_view, 18> kCompositionAxisNames = {
    "search_algo", ... "persistence_target"};
```

`serialize_composition_path<P>()` emittiert daraus **genau 18 Segmente** -- das ist die `binary_id`.
Ein scharfgeschalteter `organ_subaxes`-Konsum haengt ein **19.** Segment an
(`cacheline.line_size=<n>`) und **bricht damit den rohen Zeilen-Join alt-gegen-neu ueber die
`binary_id`**. Der F5-Plan sagt es in der Kanten-Tabelle selbst:

> "S6 bricht die Mess-Archiv-Grammatik. Zwei Tage vor der Abgabe die Join-Faehigkeit der vorhandenen
> Messdaten zu brechen ist kein vertretbares Risiko."

### 2.4 Verdikt

**Additiver Teil (S0-S5): ERLEDIGT, mitgelandet in B14-NB2 -- die Buchung ist nachzuziehen, nicht der Bau.**
**Rest (G8): kleiner Bau, jederzeit, kein Gate.**
**S6/A8: OWNER-ENTSCHEID E-4, ausdruecklich NACH dem Abgabe-Schnitt. Kein Bau vor der Abgabe.**

Von den 6 TABU-Posten sind 5 laut Plan **gar nicht** zu oeffnen; der sechste (Wire-/`binary_id`-
Grammatik) nur unter E-4.

### 2.5 Owner-Frage (nur fuer S6, nach der Abgabe zu stellen)

> **E-4-Folgefrage:** Der `cacheline.line_size`-Konsum haengt ein 19. Segment an die `binary_id` und
> macht damit den rohen Zeilen-Join gegen die vorhandenen Mess-CSV unmoeglich. Zwei Wege:
> **(a)** Segment anhaengen und im Auswerte-Pfad eine Join-Bruecke bauen (alt = 18 Segmente, neu = 19,
> Praefix-Join); **(b)** `line_size` NICHT in die `binary_id`, sondern als eigene CSV-Spalte fuehren
> (Grammatik bleibt 18, der Wert bleibt trotzdem sichtbar).
> Empfehlung: **(b)**, weil sie die Archiv-Grammatik nicht anfasst und die Doktrin "Messdaten nie
> loeschen / Join-Faehigkeit erhalten" ohne Bruecke einhaelt.

### 2.6 Datei-Beruehrungen

- **G8 (klein):** ce `tests/unit/thesis_tiere/experiment_golden_kern.xml`
- **S6 (nur nach E-4):** ce `libs/cache_engine/profile_facade/xml_config_parser.{hpp,cpp}`,
  `libs/cache_engine/builder/experiment_tree/axis_path_serialization.hpp`, dazu jede
  `binary_id`-Byte-Wache und der Auswerte-Pfad

### 2.7 Aufwand

- **G8:** ~30 min (eine XML-Datei, keine Logik). Schaetzung, Basis: reine Vokabular-Angleichung.
- **S6:** **nicht serioes schaetzbar ohne E-4** -- der Aufwand haengt vollstaendig daran, ob die
  `binary_id`-Grammatik angefasst wird. Weg (b) waere klein (~2-3 h), Weg (a) zieht das
  Mess-Archiv und alle Byte-Wachen mit und ist ein eigenes Fenster mit Gates.

---

## 3. POSTEN R4 -- CI-ABDECKUNGS-INVARIANTE

### 3.1 Plan-Zitat mit Datum

**Ledger `mittag-1` (06.08.), SOFORT-POSTEN R4:**

> "die Naht in die ce-CI aufnehmen ... R4 laeuft als erster Slot NACH B14-NB3-ce."

**Ledger `mittag-7` (06.08.), Owner-Direktive, die den Zuschnitt aendert:**
"WURZEL STATT AUSSCHLUSS -- R4 neu aufgesetzt als Vollstaendigkeits-Invariante ... Auftrag auf die
GANZE Klasse erweitert."

### 3.2 Ist-Stand am Objekt

| Pruefpunkt | Messung |
|---|---|
| `dcb2f08f` Vorfahr von ce/`development` | **JA** (`merge-base --is-ancestor`) |
| `COMDARE_TEST_CTEST_ARGS: "-LE contract\|pmc"` | **entfernt**; steht nur noch als auskommentierte Historie in `.gitlab-ci.yml:577` |
| neue Auswahl `test:unit` | `scripts/ci_test_coverage_manifest.sh:127-128`: `CE_COV_MODE_test_unit="-LE"`, `CE_COV_PATT_test_unit='pmc'` -- **nur noch `pmc` ausgeschlossen** |
| `pmc`-Klasse gedeckt | `CE_COV_MODE_pmc="-L"` / `CE_COV_PATT_pmc='pmc'` (`:62-63`), gefahren im `.pmc`-Job (Hardware-Gate) |
| Wache | `scripts/ci_test_coverage_guard.sh` existiert, Job `test:coverage-guard` |
| Selbstaussage im gelandeten YAML | "R4 (2026-08-06) -- DER WURZELSCHNITT ... am 2026-08-06 liefen 9 Tests in KEINEM Job (test_experiment_kern_seam, test_experiment_projection, test_merge_plan_directive, test_experiment_plan_director, test_experiment_dock_payload, test_progress_delta, test_gn_cell_filter, test_org18_persistence_target, test_phase_b_effective_search_algo_contrast)" |

Der juengste Wellenplan (19:07) bestaetigt die Landung unabhaengig: "R4-CI-Abdeckungs-Invariante +
Diff-Hygiene-/ASCII-Wache | `3133f226` (enth. `dcb2f08f`, `597ecffe`, `557d8023`) | **JA**
(Merge `b5e0e4e7`)".

### 3.3 Verdikt

**ERLEDIGT -- und strenger geloest als der Posten verlangte.** Der Posten wollte
`test_experiment_kern_seam` additiv in einen Job heben; gebaut wurde die Entfernung des
`contract`-Ausschlusses **an der Wurzel** plus eine Live-Invariante, die die Vereinigung aller
Job-Auswahlen gegen `ctest -N` haelt. **Schritt 3 des F3-Plans (CI-Heimat der Naht) beschreibt
denselben Gegenstand und ist damit ebenfalls erledigt** -- zwei Fundstellen, ein Loch, zu.

**Keine offene Arbeit. Kein Owner-Entscheid.**

### 3.4 Nicht-erledigt-Teil (Abgrenzung, damit R4 nicht zu viel gutgeschrieben wird)

Die Bilanz "407 von 407" stammt aus dem Wachen-Lauf und ist hier **nicht nachgefahren** (kein Bau
erlaubt) -- sie gilt als **berichtet, nicht selbst gemessen**. Was selbst gemessen ist: der
Ausschluss ist weg, das Manifest existiert, die Wache existiert, der Commit ist Vorfahr.

### 3.5 Datei-Beruehrungen / Aufwand

Keine (bereits geschehen: `ce/.gitlab-ci.yml`, `ce/scripts/ci_test_coverage_manifest.sh`,
`ce/scripts/ci_test_coverage_guard.sh`).

---

## 4. POSTEN B12 UND DER B-REST

### 4.1 Plan-Zitat mit Datum

**Owner verbatim, 05.08. nachmittag-3:**

> "OK, aber es soll doch entweder CSV xor xlsx schreiben und xlsx ist default? Alles andere ist
> unnoetiger overhead. Das ist ein strategy pattern, keine chain of responsabilities"

**Owner verbatim zu B12 (Antwort F2 im 6er-Block):**

> "CSV laesst sich schlechter auswerten, das muss auch noch mit in die Abgabe vor der Messung, ich
> stimme dir zu, mach es nach deiner Empfehlung."

### 4.2 Ist-Stand am Objekt

`grep -rn "xlsx"` ueber `Code/external/comdare-cache-engine/libs` liefert **10 Treffer in 3 Dateien**
-- und **keiner davon ist ein Writer**:

- `builder/bestandslog/lager_pfad_grammatik.hpp` (Pfad-/Namens-Grammatik)
- `builder/bestandslog/lager_ziel_strategie.hpp:166` -- Kommentar
  "`Mess-CSV/xlsx -> NAS measure-drop (Default)`"
- `include/cache_engine/measurement/axis_error.hpp` (Fehlerklasse)

Im super (`Code/0*/`, die Auswerte-Facade) **0 Treffer**. **Es gibt heute keinen xlsx-Writer und
keine Format-Strategie.** Der Mess-Pfad schreibt CSV.

**Bandzuordnung nach der juengsten Quelle** (Wellenplan 19:07, Abschnitt "P2 (Messwert-Lager, laut
Leitplanke 4 'VOR Messbeginn Pflicht')"):

> "**Lager-Kaskaden + xlsx-GERUEST** (B12-Geruest; Owner-KERN xlsx=DEFAULT, Strategy CSV XOR xlsx)
> | **OFFEN** -- Geruest ist Pflicht VOR Messbeginn, Fuellung -> P4"

### 4.3 Verdikt

**GETEILT, und die Teilung ist die entscheidende Aussage:**

- **Das GERUEST (Strategy-Naht + xlsx-Writer) ist VOR-MESSBEGINN-PFLICHT**, nicht P4. Es steht
  woertlich im Owner-Satz ("das muss auch noch mit in die Abgabe vor der Messung") und im juengsten
  Wellenplan im P2-Band. **Wer B12 pauschal nach P4 schiebt, verletzt eine Owner-Terminierung.**
- **Die FUELLUNG** (Lager mit echten Messdaten befuellen) ist P4, nach dem Trigger.

Kein Owner-Entscheid offen -- die Form ist entschieden (GoF-Strategy, genau eine aktive Strategie je
Lauf, xlsx = Default, Doppelschreibung = Regression).

### 4.4 Bau-Anweisung (Geruest-Anteil)

1. Format-Strategie als **CT-Strategy im Muster des `SpoolWriter<Backend>`** (Praezedenz liegt in
   `builder/bestandslog/lager_ziel_strategie.hpp` und ist dort ausgeschrieben: Backend als
   Template-Parameter mit Concept-Guard, **kein Laufzeit-Schalter**; die Wahl faellt VOR dem Lauf
   aus XML/Env). Das haelt den Owner-KERN "keine Laufzeit-Weiche" ein.
2. `xlsx`-Writer mit **genau derselben Spaltenordnung** wie der CSV-Writer -- die
   Spalten-Reihenfolge ist mess-schema-tragend (siehe P2-P8-Schema-Posten).
3. XML-Steuerung: die Wahl gehoert in `<run_options>` (dort liegt bereits cap/n_ops/platform/
   build_version), nicht in argv -- "die XML mit Planer ueberschreibt STETS die Default-Optionen".
4. **Negativ-Gate:** ein Test, der belegt, dass **nie beide** Formate zugleich geschrieben werden
   (die Doppelschreibung ist ausdruecklich als Regression benannt).

### 4.5 Datei-Beruehrungen

ce: neuer Writer unter `libs/cache_engine/builder/` (Ort im Bau-Fenster festzulegen), die
Rueckschreibe-Naht im `cache_engine_builder_iterator.hpp`, `<run_options>`-Parsing in
`profile_run_entry.hpp`, XSD im super (`Code/test_data_xml/`), Tests unter `tests/unit/`.

### 4.6 Aufwand

**Schaetzung ~1 Tag fuer das Geruest** (eigene Schaetzung; Basis: ein neuer Writer + eine
Strategy-Naht + XML-Feld + 2 Tests, ohne Fremd-Bibliothek -- ein minimaler xlsx-Schreiber ist ein
ZIP-Container mit XML-Teilen und braucht keine Dependency). **UNBELEGT:** ob eine vendorierte
xlsx-Bibliothek vorgesehen ist; die Vendoring-Doktrin (vendor -> faithful -> selfcontained) waere
dann zusaetzlich zu bedienen und der Aufwand steigt.

---

## 5. DER ABSCHLUSS-AUFRAEUMPASS

### 5.1 Die Termin-Doktrin, zuerst -- weil sie alles andere ordnet

**Owner-KERN verbatim** (Ledger, "Abschluss-Aufraeumpass"):

> "nach der Bearbeitung aller bekannten Aufgaben die deprecated header und toter code aufgeraeumt
> und entfernt werden muessen"

**Juengste Verortung** (Wellenplan 19:07, Band NACH-ABGABE):

> "**Sec.75-Abschluss-Aufraeumpass** (EIN Paket, ultracode VOR+NACH) mit der fortgeschriebenen
> Kandidatenliste"

**KLARE ANTWORT AUF DIE TERMIN-FRAGE:**

- **VOR die Abgabe gehoert vom Aufraeumpass: NICHTS.** Kein einziger Kandidat ist abgabe-tragend.
  Zwei Kandidaten haben Beruehrung mit abgabe-tragenden Dingen (AP-09 `axis_inventory.tex` und
  AP-02 1xN-Matrix), aber beide sind **Auslassungen, keine Fehler im Abgabe-Dokument**: der Anhang
  kompiliert heute, und ein fehlendes Diagramm ist kein rotes Gate.
- **NACH der Abgabe: der ganze Pass, als EIN Paket**, mit ultracode VOR und NACH (Owner-Regel), weil
  ein Aufraeumpass per Konstruktion viele Dateien beruehrt und deshalb genau die Welle ist, die
  einen Disjunktheits-Beweis braucht.
- **Die einzige Ausnahme-Klasse:** Kandidaten, die **nebenbei** in einer ohnehin laufenden Welle
  fallen (wie AP-01 heute im Graph-Umbau). Die duerfen mitlaufen -- aber sie duerfen **kein eigenes
  Fenster** eroeffnen. Das ist genau der Unterschied zwischen "Aufraeumen" und "Aufraeumpass".

### 5.2 Die Kandidatenliste, vollstaendig gefuehrt

**Umnummerierung, mit Begruendung:** die Register-Liste zaehlt `1.` bis `10.`; die historische
Sec-75-Liste im Ledger zaehlt `(1)`, `(20)`, `(22)`, `(23)`, `(30)`, `(31)`, `(54)`, `(71)`-`(74)`,
`(81)`, `(83)`-`(87)`. **Diese beiden Nummernraeume kollidieren** -- `1.` (leere 3D-caption) und
`(1)` (built_skip) sind verschiedene Gegenstaende, `4.` und `(73)` dagegen derselbe. Die
Nummernkollisions-Falle ist im Register selbst als Mechanik-Vermerk gefuehrt
("Namenskollisionen loeschen Inhalt still"). **Dieses Dokument fuehrt deshalb Praefix-IDs
`AP-01..AP-13` und nennt bei jedem die Alt-Nummer.** Die Alt-Nummern bleiben gueltig, nichts wird
gestrichen -- es kommt nur ein eindeutiger Schluessel davor.

Legende Beleg-Spalte: **BELEGT** = am Objekt heute selbst gemessen; **UNBELEGT** = im Repo nicht
auffindbar; **BERICHTET** = aus einer Quelle uebernommen, nicht selbst nachgefahren.

---

#### AP-01 (Register `1.`) -- leere 3D-caption

- **Anspruch:** `write_surface3d` setzt `data.title` nie -> leeres `\caption{}`.
- **Ist-Stand:** `Code/05_diagram_generator/diagram_generator.cpp:1305-1307` traegt heute literal:
  `// P1a: EIN Titel fuer Achsen-Beschriftung, Platzhalter und Caption (vorher blieb data.title leer ->`
  `// leere \caption{}; fiel nicht auf, weil der Writer bis P1a nicht in der Facade verdrahtet war).`
  `data.title = surface3d_title(metric, de);`
- **Beleg:** **BELEGT** (Quelltext gelesen).
- **VERDIKT: ERLEDIGT HEUTE** (Graph-Umbau, super `31af5a92`, Vorfahr von `development`).
  **STREICHEN aus der Kandidatenliste.**
- **ACHTUNG, Buchfuehrungs-Befund:** der **juengste** Wellenplan (19:07) fuehrt AP-01 weiterhin als
  offenen Kandidaten. Das ist am Objekt widerlegt. Die Liste muss an dieser Stelle korrigiert
  werden -- sonst wandert ein erledigter Posten in den Nach-Abgabe-Pass und kostet dort Pruefzeit.

---

#### AP-02 (Register `2.`) -- 1xN-/Nx1-Matrix-Bestandsfehler

- **Anspruch:** `diagram_generator` bricht fatal, wenn der Korpus nur **einen** Algorithmus ODER nur
  **einen** Workload enthaelt.
- **Ist-Stand:** in `diagram_generator.cpp` existiert **nur** die Leer-Wache
  (`:237  if (data.matrix.empty() || data.matrix[0].empty()) return status_empty_input;`).
  Eine Suche nach `nx == 1`, `ny == 1`, `nx < 2`, `ny < 2`, `nx <= 1`, `ny <= 1` liefert
  **0 Treffer**. Der Emitter schreibt unverandert `mesh/cols=<nx>` und
  `xtick={0,1,...,<nx-1>}` (`:465-467`) -- bei `nx==1` also `xtick={0,1,...,0}`.
- **Beleg:** **BELEGT** fuer "kein Guard vorhanden". **BERICHTET** (nicht selbst nachgefahren) fuer
  "bricht fatal" -- dazu braeuchte es einen pdflatex-Lauf.
- **VERDIKT: OFFEN.**
- **DOPPELBUCHUNG, zu bereinigen:** derselbe Posten steht im juengsten Wellenplan **zweimal** --
  einmal im Band **P4 (nach Trigger)** ("1xN-/Nx1-Matrix-Fatal im `diagram_generator`
  (Bestandsfehler)") und einmal in der **Aufraeumpass-Liste**. Zwei Heimaten heisst in der Praxis
  keine. **Empfehlung: Heimat = P4**, weil es ein echter **Bestandsfehler** ist (falsches Verhalten)
  und nicht toter Code -- und weil ein einzelner Algorithmus im Korpus bei einem Teil-Messlauf
  realistisch ist. Aus der Aufraeum-Liste streichen und im P4-Band belassen.
- **Datei:** `Code/05_diagram_generator/diagram_generator.cpp`. **Aufwand:** ~1 h (Guard + Test).

---

#### AP-03 (Register `3.`, Alt-Nr. `(86)`) -- "wormhole-Muster"-Benennung

- **Anspruch (Ledger, Truth-Check):** "(86) Kosmetik: Commit `27ef28ea` nennt 'wormhole-Muster',
  textuell exakt ist hot/start-Muster (verhaltensgleich)."
- **Ist-Stand:** die Commit-Botschaft von `27ef28ea` traegt die Formulierung tatsaechlich:
  "... Statistik-/Observer-Block bewusst ungegated (wormhole-Muster; Posten 82 geheilt statt
  registriert; ...)". **Eine Commit-Botschaft ist unveraenderlich** -- sie zu korrigieren hiesse
  Historie umschreiben, was die Doktrin "nie rebase, immer merge" verbietet.
- **Der korrigierbare Teil existiert aber:** dieselbe Formulierung steht **im Quelltext**, in
  `libs/cache_engine/axes/lookup/axis_03a_search_algo_original_surf.hpp:182`
  ("... per if constexpr (enabled) gegated (wormhole-Muster); der Statistik-/Observer-Block laeuft ...").
  Zweite, davon unabhaengige Fundstelle: `axes/prefetch_axis/axis_07_prefetch_real_descent.hpp:19`
  ("Wormhole-Muster") -- die ist inhaltlich **korrekt** (dort geht es um Prefetch-Distanz) und
  gehoert **nicht** angefasst.
- **Beleg:** **BELEGT** (beide Fundstellen gelesen).
- **VERDIKT: UMWIDMEN, nicht streichen.** Der Kandidat zielt heute auf ein unerreichbares Objekt
  (Commit-Botschaft) und verfehlt das erreichbare (Code-Kommentar).
  **Neue Fassung: "Code-Kommentar `axis_03a_search_algo_original_surf.hpp:182` benennt das Muster
  falsch (wormhole statt hot/start); die Commit-Botschaft `27ef28ea` bleibt unveraendert, weil
  Historie nicht umgeschrieben wird -- der Ledger-Vermerk ist die Korrektur."**
- **Datei:** ce `libs/cache_engine/axes/lookup/axis_03a_search_algo_original_surf.hpp`.
  **Aufwand:** ~5 min.

---

#### AP-04 (Register `4.`, Alt-Nr. `(73)`) -- cacheline-Default-Literal

- **Anspruch (Ledger):** "(73) `axes/cacheline/node_width_config.hpp:54` Default-Literal 64 in der
  EIGENEN Achse (kein Fremdgang, Konsistenz-Kandidat)."
  Spaetere Ledger-Zeile verschaerft: "node_width_config.hpp:54 fuehrt `line_bytes = 64` als DEFAULT
  (0 Aufrufer)".
- **Ist-Stand:**
  `:54  [[nodiscard]] static constexpr std::size_t node_width_bytes(std::size_t line_bytes = 64) noexcept {`
  `grep` ueber das ganze ce-Repo nach `node_width_bytes` liefert **3 Treffer**:
  die Definition (`:54`), ein Verweis in einem Kommentar (`axes/alloc/alloc_hw_config.hpp:81`) und
  **einen echten Konsumenten**: `tests/unit/test_ff2_node_width_subaxis.cpp:84`
  `static_assert(WideNodeW16::node_width_bytes() == 16 * 64);` -- **dieser Aufruf nutzt genau den
  Default**.
- **Beleg:** **BELEGT**.
- **VERDIKT: OFFEN, aber die Etikettierung "0 Aufrufer" ist FALSCH und wird hiermit korrigiert.**
  Es ist **kein toter Code**, sondern ein Konsistenz-Posten: die Achse fuehrt ein hartes 64, waehrend
  die neuere `padded_aos_field_sum`-Naht `line` bewusst **ohne** Default fuehrt. Eine Entfernung des
  Defaults zieht die Test-Zeile mit (`node_width_bytes(64)` explizit).
- **Datei:** ce `libs/cache_engine/axes/cacheline/node_width_config.hpp`,
  `tests/unit/test_ff2_node_width_subaxis.cpp`. **Aufwand:** ~20 min.
- **KOPPLUNG:** haengt am selben `line_size`-Komplex wie F5-S6 (Abschnitt 2.3b). **Nicht vor E-4
  anfassen**, sonst wird zweimal an derselben Semantik geschraubt.

---

#### AP-05 (Register `5.`) -- A8-S6 "17 stale-Kommentar-Stellen"

- **Anspruch (Ledger, A8-S3-Welle):** "S6-Kommentar-Kandidaten-Liste fortgeschrieben
  (17er-stale-Kommentare abi_adapter/observable_tier/search_algorithm_anatomy/iterator/perm_runner --
  **Liste im Wellen-Backup**, S6 leitet live ab)."
- **Ist-Stand -- drei getrennte Befunde:**
  1. **Die Original-Liste ist im Repo nicht auffindbar.** Sie liegt laut Ledger "im Wellen-Backup";
     `docs/sessions/backups/` traegt `20260804-a8-s1-welle`, `-a8-s3-welle`, `-a8-s5-planung`, aber
     die 17er-Stellenliste war in dieser Erhebung **nicht** darin auffindbar. -> **UNBELEGT.**
  2. **Der Umfang ist unterschaetzt.** Ein mechanischer Zaehler ueber ce
     (`libs` + Header, Muster `alle 17` ODER `17 Achsen`) liefert **77 Fundstellen** -- gegen die
     Registerangabe "17 Stellen". Bezugsgroesse: zwei Suchmuster, nur ce, nur `.hpp`/`.cpp`.
  3. **Ein grosser Teil dieser 77 ist NICHT stale.** Beispiele, am Objekt gelesen:
     `source_catalog.hpp:135` "17 Achsen je 2, persistence_target (K17) auf 1 GEPINNT" und
     `:170` "17 Achsen je 2 x persistence_target je 1 = 131072" sind **heute korrekt** -- sie
     beschreiben die golden-Struktur (2^17 = 131072 bei 18 Achsen mit einer gepinnten).
     Ein blinder 17->18-Sweep wuerde die golden-Semantik **falsch** machen.
  4. **Neue, belegte Fundstellen ausserhalb der 5 benannten Dateien:**
     `libs/cache_engine/profile_facade/lazy_adhoc_source_gen.hpp:80` ("kanonische **17**-Slot-Ordnung")
     und `:135` ("die **17** Flyweight-Tabellen") -- beide beziehen sich auf `kCompositionAxisNames`,
     das am Objekt **18** Eintraege hat (`axis_path_serialization.hpp:40`). Das sind echte
     Stale-Stellen, und sie stehen in einer Datei, die in der Register-Aufzaehlung fehlt.
- **VERDIKT: OFFEN, mit korrigiertem Zuschnitt.** Der Kandidat ist **kein Sweep**, sondern eine
  **Einzelfall-Pruefung mit Semantik-Entscheid je Stelle** (17 = Achsenzahl -> stale;
  17 = Exponent/gepinnte Struktur -> korrekt).
- **Bau-Anweisung:** (1) mechanisch alle Fundstellen erheben und mit Bezugsgroesse ausweisen;
  (2) je Stelle klassifizieren in {stale-Achsenzahl, korrekt-Exponent, historisch-mit-Vermerk};
  (3) nur die erste Klasse aendern, die dritte mit "Zwischenstand Juli 2026"-Vermerk versehen;
  (4) Gegenprobe: nach dem Pass darf keine Stelle mehr "17" als **Achsenzahl** fuehren.
- **Aufwand:** ~3-4 h (Schaetzung; Basis: 77 Fundstellen x Einzelentscheid, ohne Bau).

---

#### AP-06 (Register `6.`, Alt "Posten 45") -- stale-17er-Spuren

- **Anspruch (Ledger, Forensik-Block):** "Stale-17er-Spuren (Posten 45, golden_kern-Drift
  [von B14 geheilt], anatomy_version_stamp [OP-11: 18]) sind Zwischenstands-Reste 19.-25.07."
- **Ist-Stand:** Der Posten hat **zwei Teilspuren**, und sie stehen heute verschieden da:
  - **golden_kern-Drift: geheilt** (durch B14, siehe Abschnitt 2.2 -- die XML fuehrt heute
    `allowed_variants` je Achse und ein maschinenlesbares `cap`).
  - **`anatomy_version_stamp`: OFFEN, und die Stelle ist exakt benennbar.** In
    `libs/cache_engine/include/cache_engine/abi/anatomy_version_stamp.hpp` sagt der **Dateikopf**
    (`:4-5`): "Diese Zeile wird aus den **17** Kompositions-Achsen-Typen der AdHocComposition
    abgeleitet" -- waehrend dieselbe Datei bei `:39` `inline constexpr std::size_t
    kOrganAxisCount = 18;` fuehrt, bei `:53` "aus den **18** benannten Achsen-Aliassen" schreibt und
    bei `:103-108` den 18. Slot als A8.2-Heilung ausdruecklich dokumentiert.
    **Der Kopf widerspricht dem Rumpf derselben Datei.**
- **Beleg:** **BELEGT** (beide Stellen gelesen).
- **VERDIKT: TEILWEISE ERLEDIGT.** Teilspur 1 zu, Teilspur 2 offen und praezise lokalisiert.
- **Datei:** ce `libs/cache_engine/include/cache_engine/abi/anatomy_version_stamp.hpp:4-5`.
  **Aufwand:** ~5 min. **Gehoert wegen der Winzigkeit in denselben Griff wie AP-05.**

---

#### AP-07 (Register `7.`) -- M1-M3 der Teil-2-Review

- **Anspruch (Ledger vormittag-27):** "DUAL-REVIEW SPLIT: **Fable LANDEBEREIT** (5 Pakete; T2-A
  offen kein Einwand; **M1-M3=Aufraeumpass**)."
- **Ist-Stand:** Der **Inhalt** von M1, M2 und M3 ist im Repository nicht auffindbar. Gesucht wurde
  in `docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md`, `docs/sessions/*.md`, `docs/plaene/*.md` und
  `docs/sessions/backups/20260806-neuanker-teil2/` (enthaelt nur `gates/`). Gefunden wurden
  ausschliesslich **Verweise** auf das Kuerzel (Register-Liste Punkt 7, Wellenplan-Liste Punkt 7),
  nirgends die drei Befundtexte.
- **Beleg:** **UNBELEGT.**
- **VERDIKT: NICHT AUSFUEHRBAR IN DIESER FASSUNG.** Ein Kandidat, dessen Gegenstand nicht benannt
  ist, kann weder gebaut noch abgenommen noch gestrichen werden -- er ist genau die Klasse, vor der
  Regel 10 warnt ("ein Paketschnitt, der nur in einem Session-Dokument steht, existiert fuer die
  Ausfuehrung nicht"), nur eine Stufe schlimmer: hier steht er in **gar keinem** Dokument.
- **VORGEHEN (kein Bau):** Vor dem Aufraeumpass sind die drei Befundtexte aus dem
  Fable-Review-Ergebnis der Teil-2-Uebernahme zu bergen (Workflow-Journal der Welle) und **als
  eigene Kandidaten AP-07a/b/c mit Datei und Zeile** in die Liste zu schreiben. Bis dahin bleibt
  AP-07 als **Platzhalter mit UNBELEGT-Marke** stehen -- **nicht** streichen (Owner-Doktrin: nichts
  ersatzlos entfernen).
- **Aufwand Bergung:** ~30 min. **Aufwand Bau:** unbekannt, weil Gegenstand unbekannt.

---

#### AP-08 (Register `8.`) -- honest-0-Musterfortsetzung

- **Anspruch (Register verbatim):** "honest-0-MUSTERFORTSETZUNG: die honest-empty-Doktrin
  (nie-ausgefuehrt=Auslass, echt-0=eigene Klasse) auf kuenftige Writer/Graph-Umbauten uebertragen
  (E1-E4-Karten-Residuum)."
- **Ist-Stand:** Die Doktrin ist im Code **implementiert und dokumentiert** -- `diagram_generator.cpp`
  fuehrt sie an mindestens zwei Orten mit ausgeschriebener Begruendung
  (`:288-290` 2D-Pfad, `:1312-1320` 3D-Pfad, jeweils mit `write_honest_empty_placeholder` und
  dem Vermerk "E-2b: any_data zaehlt jetzt AUCH ausgefuehrte Nullen als Daten").
- **Beleg:** **BELEGT** fuer die zwei bestehenden Orte.
- **VERDIKT: STRUKTURELL OFFEN, KEIN ABSCHLIESSBARER KANDIDAT.** Es gibt keinen Zustand, in dem
  dieser Posten "erledigt" ist -- er ist eine **Auflage an kuenftige Writer**, kein Aufraeum-Objekt.
- **UMWIDMEN:** aus der Aufraeum-Kandidatenliste **herausnehmen** und als **stehende Auflage** in
  dieselbe Klasse buchen wie die V-03-Rest-Auflage ("bei jedem Umzug ..."). Begruendung: eine Liste,
  die einen nie abschliessbaren Posten fuehrt, kann nie leer werden -- und eine Liste, die nie leer
  wird, verliert ihre Funktion als Abnahme-Instrument. Der Inhalt geht **nicht** verloren, er
  wechselt nur die Klasse.

---

#### AP-09 (Register `Nr. 9`) -- `axis_inventory.tex` nie eingebunden

- **Anspruch (Register verbatim):** "Die Facade SCHREIBT die Datei
  (`Code/08_appendix_generator/appendix_generator.cpp:423`), aber KEINE .tex des Thesis-Repos bindet
  sie ein -- dieselbe Luecken-Klasse wie die 23 Graph-Abbildungen (Gate 8), nur aelter/laenger
  unbemerkt."
- **Ist-Stand, an BEIDEN Thesis-Checkouts gemessen:**
  - Schreiber vorhanden: `Code/08_appendix_generator/appendix_generator.cpp:423`
    (`write_axis_inventory_table(out_dir / "axis_inventory.tex", registries, lang)`).
  - `grep -rn "axis_inventory"` ueber `Code/external/20260931-overleaf-diplomarbeit/` (= der
    **Gate-8-Stand** `8970465d`): **0 Treffer**, RC=1.
  - Dieselbe Suche ueber `thesis/diplomarbeit/` (= der aeltere Zeiger `29a1700d`): **0 Treffer**.
  - **Gegenprobe, dass Gate 8 wirklich lief:** `\InputIfFileExists` in
    `anhang/de/A_measurements.tex` -- **29** im Gate-8-Stand gegen **6** im Vor-Gate-8-Stand;
    Delta **23**, exakt die 23 Graph-Abbildungen. Gate 8 hat also die Graph-Abbildungen
    eingebunden und `axis_inventory.tex` **nicht**.
- **Beleg:** **BELEGT**, beidseitig.
- **VERDIKT: OFFEN.** Braucht einen kleinen Entscheid, keinen grossen Bau.
- **Owner-/Lead-Frage:** *In welchen Anhang-Abschnitt gehoert die Achsen-Inventar-Tabelle
  (Organ-Slots T00-T17 + System-Realm + Mess-Realm)?* Vorschlag: **Anhang B (Code-Struktur)**, weil
  die Tabelle das Achsen-Inventar der Implementierung ausweist und Anhang A die **Messreihen**
  fuehrt. Alternativ Anhang E (Architektur-Entscheidungen).
- **Datei:** Thesis-Repo `anhang/de/*.tex` + `anhang/en/*.tex` (**DE+EN paritaetisch**, sonst
  entsteht die naechste Luecke). **Aufwand:** ~20 min nach dem Entscheid.
- **NEBENBEFUND, eigener Posten:** die **zwei Checkouts desselben Thesis-Repos** im super
  (`thesis/diplomarbeit` = `29a1700d`, `Code/external/20260931-overleaf-diplomarbeit` = `8970465d`)
  stehen auf **verschiedenen Staenden**. Genau diese Konstellation hat heute Regel 8 ausgeloest
  (Zeiger kann rueckwaerts zeigen). Das ist **kein** Aufraeum-Kandidat, sondern eine offene
  Struktur-Frage: braucht das Projekt zwei Checkouts desselben Repos? -> als Frage ins
  Nach-Abgabe-Fenster, hier nur vermerkt.

---

#### AP-10 (Register `Nr. 10`, Alt "A24"/"B-1") -- referenzlose `using SearchAlgo`-Aliase

- **Anspruch (Register verbatim):** "referenzlose `using SearchAlgo`-Aliase
  `abi_adapter.hpp:440/:545`."
- **Ist-Stand -- die Zeilenanker sind stale, und der Umfang ist groesser:**
  In `libs/cache_engine/anatomy/abi_adapter.hpp` gibt es heute **vier** `using SearchAlgo`:

  | Zeile | Kontext (Funktion ab) | im Rumpf referenziert? |
  |---|---|---|
  | 595 | `run_workload(...)` ab `:592` | **NEIN** -- im Block `595..704` genau 1 Vorkommen (die Deklaration) |
  | 710 | Segment-Latenz V1 ab `:705` | **NEIN** -- im Block `710..813` nur die Deklaration (ein weiterer Treffer ist ein Kommentar mit "SearchAlgorithm-Achsen") |
  | 819 | Segment-Latenz V2 ab `:814` | **NEIN** -- im Block `814..1100` (Funktion endet vor `:1142`) nur die Deklaration |
  | 2406 | Klassen-Ebene, `using Composition = ...` | **JA, stark benutzt** -- >10 Verwendungen (`:2419`, `:2426`, `:2440`, `:2461`, `:2465`, ...) |

  Alle drei referenzlosen Stellen stehen direkt neben einem `EffectiveSearchAlgo`, das die Arbeit
  tut -- das erklaert, wie sie entstanden sind.
- **Beleg:** **BELEGT** fuer "3 Deklarationen ohne Rumpf-Referenz". **UNBELEGT** bleibt, ob der
  Compiler sie meldet: `-Wunused-local-typedefs` (Teil von `-Wall`) verhaelt sich in Templates
  anders; das kann nur ein Bau zeigen, der hier nicht erlaubt war.
- **VERDIKT: OFFEN, mit korrigierten Ankern.** Die Registerangabe `:440/:545` trifft heute keine der
  Stellen; sie ist auf `:595`, `:710`, `:819` zu berichtigen, und die Zahl von **2 auf 3** zu heben.
  Zeile `:2406` ist **kein** Kandidat und darf nicht mitgeloescht werden.
- **Datei:** ce `libs/cache_engine/anatomy/abi_adapter.hpp`. **Aufwand:** ~10 min + ein Bau als
  Gegenprobe.

---

#### AP-11 (NEU, 06.08. abends) -- `COMDARE_VARIANT_GATE` ist durch F7-(b) obsolet

- **Anspruch (aus dem Auftrag als Kandidat vorgeschlagen):** toter Code.
- **Ist-Stand -- der Kandidat LEBT, und zwar vollstaendig verdrahtet:**

  | Fundstelle | Rolle |
  |---|---|
  | `profile_facade/planner/experiment_plan_director.hpp:956` | `append_forward_var_literal(vars, "COMDARE_VARIANT_GATE")` -- der Planer reicht die Variable in die Job-Env durch |
  | `profile_facade/profile_run_entry.hpp:461` | `char const* const vg = std::getenv("COMDARE_VARIANT_GATE");` -- aktiver Leser |
  | `profile_facade/profile_run_entry.hpp:453` | Kommentar: "Gated auf COMDARE_VARIANT_GATE=true; Default AUS => leerer String => Variant-Gate AUS => byte-neutral" |
  | `tests/unit/thesis_tiere/test_experiment_plan_director.cpp:741` | Erwartungsliste der durchgereichten Variablen |
  | ebd. `:849` | `::setenv("COMDARE_VARIANT_GATE", "true", 1);` |
  | ebd. `:861` | `EXPECT_EQ(count_occurrences(yaml, "    COMDARE_VARIANT_GATE: \"true\"\n"), 1u);` |

- **Die Obsoleszenz ist dagegen belegt -- vom Code selbst, an zwei Stellen:**
  `profile_facade/toolchain_stamp_naht.hpp:406` und
  `include/cache_engine/abi/anatomy_fingerprint.hpp:287` tragen beide woertlich
  "**F7-(b): damit wird COMDARE_VARIANT_GATE funktional obsolet**";
  `builder/build_variant_sidecar.hpp:29` sagt es ein drittes Mal
  ("COMDARE_VARIANT_GATE ist damit funktional obsolet").
- **VERDIKT: KANDIDAT JA -- aber als *deprecated*, NICHT als *tot*.**
  Der Owner-KERN nennt beides ("die **deprecated header** und **toter code**"); dieser Fall ist
  eindeutig die erste Klasse. **Die Etikettierung ist entscheidend, weil die Vorgehensweise
  unterschiedlich ist:** toter Code faellt mit `grep`-Beweis "0 Aufrufer"; ein deprecated Mechanismus
  faellt erst, wenn der **Nachfolger nachweislich alles traegt** und die drei Tests mitgezogen sind.
- **Vorbedingung vor der Entfernung (hart):** F7-(b) muss vollstaendig gelandet und gemessen sein
  (das Versionierungs-Interface steht im NACH-ABGABE-Band des Wellenplans). Solange das
  bvset-Glied nicht in jedem relevanten Pfad im Fingerprint steht, ist die Env-Bruecke der einzige
  Weg -- und ihre Entfernung waere ein stiller Deckungsverlust.
- **Datei:** ce `profile_facade/planner/experiment_plan_director.hpp`,
  `profile_facade/profile_run_entry.hpp`, `tests/unit/thesis_tiere/test_experiment_plan_director.cpp`
  (3 Testfaelle), dazu die 3 Kommentar-Stellen. **Aufwand:** ~1 h **nach** F7-(b).

---

#### AP-12 (NEU, 06.08. abends) -- die zwei DEPRECATED-Mess-Jobs `measure:smoke` / `measure:golden-320`

**HIER WIRD EINE ENTLASTUNG WIDERRUFEN.** Die Vor-Erhebung meldete zu diesem Punkt
"0 Treffer im ganzen Repo ... **Kein Aufraeum-Kandidat mehr -- bereits weg, nichts zu tun**".
**Das ist falsch, und der Fehler ist die Suchgrenze:** gesucht wurde in `ce/.gitlab-ci.yml`.
Die Jobs stehen im **super**.

- **Ist-Stand, am Objekt:**
  - `.gitlab-ci.yml:651  measure:smoke:` und `.gitlab-ci.yml:738  measure:golden-320:` -- beide
    **existieren als definierte Jobs**.
  - Beide tragen die Selbst-Etikettierung (`:663-667`): "**DEPRECATED-Fallback** (2026-07-21 ...):
    dieser STATISCHE Smoke-Job ist durch die dynamische Kette (planer:delegate -> ceb -> tier ...)
    **abgeloest**. Er laeuft NUR NOCH mit ZUSAETZLICHEM `COMDARE_STATIC_SMOKE_FALLBACK=="true"`
    (Default AUS) ... **NICHT geloescht (Pilot-Historie)**."
  - **UND SIE SIND DIE EINZIGEN TRAEGER DES PMC-FLAGS IM MESS-PFAD:**
    `:677` und `:768` fuehren je `cmake -B build -G Ninja -DCOMDARE_V32_ENABLE=ON
    **-DCOMDARE_ENABLE_PMC=ON** -DCMAKE_BUILD_TYPE=Release`, jeweils mit der Begruendungszeile
    "I-PMC-1 (F9, User 2026-07-16 'PFLICHT fuer Vollstaendigkeit aller perf-Messwerte')".
  - **Gegenprobe im Planer:** `grep -n "PMC\|pmc"` ueber
    `libs/cache_engine/profile_facade/planner/experiment_plan_director.hpp` liefert den
    **PMC-Preflight** (`:1352-1364`, `cmake --build build --target m3v2_pmc_smoke
    linux_perf_pmc_smoke` + `ctest -L pmc`) -- **aber an keiner Stelle ein
    `-DCOMDARE_ENABLE_PMC=ON` fuer den Configure**. Die dynamische Kette baut also **ohne** das Flag.
  - **Asymmetrie-Befund:** die Rules unterscheiden sich. `measure:smoke` braucht **zwei**
    Bedingungen (`COMDARE_RUN_MEASURE=="true"` **und** `COMDARE_STATIC_SMOKE_FALLBACK=="true"`),
    `measure:golden-320` dagegen nur **eine** (`:760  - if: '$COMDARE_RUN_MEASURE == "true"'`).
    Der als "nur noch mit Zusatz-Flag" beschriebene Fallback gilt fuer den Voll-Lauf-Job also
    **nicht** -- ein echter Messlauf startet ihn mit.
- **Beleg:** **BELEGT** (alle Zeilen gelesen).
- **VERDIKT: KANDIDAT JA (deprecated), ABER MIT HARTER SPERRE.**
  **Entfernung ist verboten, solange die PMC-Pflicht nicht als Invariante in der dynamischen Kette
  haengt.** Wer diese beiden Jobs im Aufraeumpass loescht, loescht die letzten beiden Stellen im
  Mess-Pfad, an denen `-DCOMDARE_ENABLE_PMC=ON` ueberhaupt vorkommt -- und stellt damit genau den
  Zustand her, vor dem Ledger `nachmittag-10` Abschnitt E warnt (honest-0 statt echter Zaehler,
  mehrtaegig unbemerkt).
- **Reihenfolge (bindend):** (1) PMC-Flag als **Invariante** in die dynamische Kette (nicht an einen
  Job-Namen); (2) die PMC-Wache so drehen, dass "Quelle nicht gebaut" ein **Fehler** ist statt eines
  Skips; (3) **erst dann** duerfen die beiden Alt-Jobs fallen. Schritte (1) und (2) sind bereits als
  Owner-Entscheid vor Phase 6 registriert (Ledger `nachmittag-10` H) -- dieser Kandidat **haengt
  daran**, er eroeffnet nichts Neues.
- **Zusatz-Befund als eigene Zeile:** die Rules-Asymmetrie (`measure:golden-320` ohne
  Fallback-Bedingung) ist **unabhaengig vom Aufraeumpass** zu klaeren -- entweder ist der Job
  wirklich deprecated, dann fehlt ihm die zweite Bedingung, oder er ist es nicht, dann ist der
  Kommentar falsch. **Beides ist billig zu pruefen und beruehrt den Messlauf direkt.**
- **Datei:** super `.gitlab-ci.yml`. **Aufwand:** Sperr-Pruefung ~15 min; Entfernung ~30 min
  **nach** (1) und (2).

---

#### AP-13 (NEU, 06.08. abends) -- die VOLLSTAENDIGKEITS-LUECKE der Liste selbst

**Das ist der schwerste Befund dieses Abschnitts, und er betrifft nicht einen Kandidaten, sondern
die Liste.** Die 10er-Liste (Register 14:40, unveraendert uebernommen in den Wellenplan 19:07) ist
**nicht** die vollstaendige Sec-75-Kandidatenmenge. Der Ledger fuehrt zusaetzlich mindestens
folgende, **nummerierte und nie zurueckgezogene** Kandidaten, von denen **keiner** in der 10er-Liste
steht:

| Alt-Nr. | Gegenstand | heute am Objekt |
|---|---|---|
| `(20)` | Stamp-Write ohne `flush()`/`good()`-Check, `cache_engine_builder_iterator.hpp:1790-1791` | **nicht geprueft** (UNBELEGT) |
| `(22)` | Bestands-ASCII-Sweep | **BELEGT, Groessenordnung bestaetigt:** `grep -rlP '[^\x00-\x7F]'` ueber ce `libs`+`tests` (`.hpp`/`.cpp`) = **962 Dateien**. Register nannte 1132 fuer einen weiteren Scope. |
| `(23)` | `(void)`-ohne-`try` | **nicht geprueft** (UNBELEGT) |
| `(30)` | `test_s5_artifact_cache_bounded` festes Tempdir + `remove_all` | **BELEGT, OFFEN:** `:42  path const base = ::comdare::test::user_tmp_dir() / "comdare_s5_bounded";` + `remove_all(base)` an `:43` und `:233` -- zwei Parallel-Instanzen zerstoeren sich gegenseitig |
| `(31)` | Presence-/Registrierungs-Weg-Asymmetrie (`make_fingerprint_key_fn` trimmt, `lager_contains` nimmt roh) | **nicht geprueft** (UNBELEGT) |
| `(54)` | 4 stale Zeilen-Anker im `abi_adapter`-Kopf | **nicht geprueft** (UNBELEGT) -- plausibel, da die Anker `:440/:545` aus AP-10 nachweislich gewandert sind |
| `GA-09` | 7 Waisen-TUs (nie registrierte Test-Uebersetzungseinheiten) | **BELEGT, ALLE SIEBEN OFFEN:** je Datei existiert der Quelltext unter `tests/unit/`, und `grep` in `tests/unit/CMakeLists.txt` liefert **0 Treffer**: `br4_emit.cpp`, `br4_load.cpp`, `kf16_e2e_real_build.cpp`, `test_a9b_active_deklaration_inert.cpp`, `test_c3b_kanal_merge_beleg.cpp`, `test_d4b_container_dll.cpp`, `test_rf2_admission_marker_inert.cpp` |
| `(71)`/`(72)`/`(74)` | A1-Scheibe Wurf-Vertrag | laut Wellenplan "in Landung" (A1) |
| `(81)` | D1-Fassaden-Schnitt (einfacherer Template-Kopf-Schnitt), ausdruecklich "NACH ABGABE" | offen (by design) |
| `(83)`-`(87)` | Familien-Gate-Universen, Observer-Copy-Semantik, h81-Wachen-Haertung, `organ_hull_` Level-2 | im Register als eigene NACH-ABGABE-Zeilen gefuehrt, **aber nicht in der Kandidatenliste** |

**Warum das schwer wiegt:** `GA-09` ist der Fall, an dem sich die Doktrin selbst misst -- der
Ledger nennt die Regel woertlich ("nie registrierte TUs = toter Code -> am Ende entfernen"), und
genau dieser Kandidat fehlt in der Liste, die der Owner-KERN "Liste statt Sammelwort" erzwungen hat.
**Es ist dieselbe Fehlerklasse wie der LB-Paketschnitt aus `nachmittag-10` F: eine Konsolidierung,
die eine Quellenklasse auslaesst, liest das Schweigen der ausgelassenen Klasse als Abwesenheit.**
Hier war die ausgelassene Klasse die **Alt-Sec-75-Nummerierung im Ledger-Rumpf**; die Konsolidierung
hat nur die juengsten Nachtraege eingesammelt.

- **VERDIKT: die Kandidatenliste ist UNVOLLSTAENDIG und muss vor dem Aufraeumpass zusammengefuehrt
  werden.** Das ist **kein Bau**, sondern ein Buchfuehrungs-Pass.
- **Bau-Anweisung (Buchfuehrung):** einen mechanischen Durchlauf ueber den Ledger nach dem Muster
  `Par.75|Paragraf-75|Sec.75|AUFRAEUM` fahren, **jede** dort vergebene Nummer einsammeln, gegen die
  10er-Liste schneiden, und die Vereinigung als **eine** Liste mit `AP-`-Praefix fuehren. Je Zugang
  den Alt-Anker (Ledger-Ueberschrift) mitschreiben.
- **Aufwand:** ~1 h.

---

### 5.3 Bilanz der Kandidatenliste

| Klasse | Anzahl | IDs |
|---|---|---|
| **ERLEDIGT, zu streichen** | 1 | AP-01 |
| **TEILWEISE erledigt** | 1 | AP-06 (Teilspur golden_kern-Drift zu, `anatomy_version_stamp` offen) |
| **OFFEN, belegt, ausfuehrbar** | 6 | AP-02, AP-03 (umgewidmet), AP-04, AP-05, AP-09, AP-10 |
| **OFFEN, aber gesperrt/vorbedingt** | 2 | AP-11 (nach F7-(b)), AP-12 (nach PMC-Invariante) |
| **NICHT AUSFUEHRBAR (Gegenstand unbekannt)** | 1 | AP-07 |
| **UMWIDMEN, aus der Liste heraus** | 1 | AP-08 (stehende Auflage statt Kandidat) |
| **Meta-Posten (Liste selbst)** | 1 | AP-13 |

**Drei Etikettierungen wurden korrigiert** (kein Kandidat wurde ersatzlos gestrichen -- Owner-Doktrin):

1. **AP-01 gestrichen** -- weil am Objekt geheilt (Graph-Umbau). Begruendung liegt im Quelltext.
2. **AP-04 umetikettiert** von "0 Aufrufer" auf "ein Konsument, der genau den Default nutzt".
   Ein Kandidat, der als toter Code gefuehrt wird, aber einen `static_assert` traegt, wuerde beim
   Entfernen einen gruenen Test brechen -- die falsche Etikette haette den Aufwand um den Faktor
   der Ueberraschung erhoeht.
3. **AP-12 wieder-ANGEKLAGT** -- die Vorerhebung hatte den Posten entlastet ("bereits weg"),
   die Suche hatte aber nur das ce-Repo abgedeckt. Am Objekt leben beide Jobs im super und tragen
   das einzige PMC-Flag des Mess-Pfads.

Dazu **zwei Umwidmungen** (AP-03 vom Commit-Text auf den Code-Kommentar; AP-08 vom Kandidaten zur
stehenden Auflage) und **eine Anker-Korrektur** (AP-10: `:440/:545` -> `:595/:710/:819`, 2 -> 3).

---

## 6. WAS DURCH DIE HEUTIGEN LANDUNGEN ERLEDIGT IST

Alle Zeilen per `merge-base --is-ancestor` gegen den jeweiligen `development` geprueft.

| Gegenstand | Beleg am Objekt | Folge fuer diesen Plan |
|---|---|---|
| **R4** (CI-Abdeckungs-Invariante) | `dcb2f08f` Vorfahr von ce/dev; `-LE contract\|pmc` nur noch als Historien-Kommentar `:577`; Manifest + Guard vorhanden | **Posten R4 geschlossen**; zusaetzlich **F3-Schritt 3 gegenstandslos** |
| **B14 (super)** | `1ba29b63` Vorfahr; `Code/tests/fixture_schema_subset_check.cmake` + `golden_n_consistency_check.cmake` im Baum | **F3-Vorbedingung erfuellt** |
| **B14 (ce)** | `16a173f2` Vorfahr | dito |
| **B14-NB2 (golden-XML)** | `experiment_golden_kern.xml` traegt `run_options`, `organ_subaxes`, 23x `allowed_variants`, eine `combo`-Zeile | **F5 S0-S5 faktisch erledigt** (mitgelandet, nicht separat gefahren) |
| **T2-A** | `6c300e68` Vorfahr von ce/dev | P0-Bau-Block zu 3/4 gelandet |
| **Posten 92** | `3bbcb8ed` Vorfahr | -- |
| **Graph-Umbau (super)** | `31af5a92` + `b35aea1b` Vorfahren von super/dev | **AP-01 erledigt** (leere 3D-caption) |
| **Thesis Gate 8** | Zeiger `8970465d`; `\InputIfFileExists` in `A_measurements.tex` **6 -> 29** (Delta 23) | **AP-09 NICHT erledigt** -- Gate 8 hat die 23 Abbildungen eingebunden, `axis_inventory.tex` nicht |
| **ASCII-/Breiten-Wache** | im R4-Buendel (`597ecffe`, `557d8023`) enthalten | betrifft NEUE Zeilen; der **Bestands**-Sweep bleibt Aufraeum-Kandidat (AP-13/`(22)`, 962 Dateien) |

**Was heute NICHT gelandet ist** (Gegenprobe, damit die Bilanz ehrlich ist):
`fdfa68ee` (A1) und `5c4cf900` (E18-SNAP-NB2) sind **keine** Vorfahren von ce/`development`.
Beide liegen als rescue-Refs -- und genau das ist laut Regel 9 **keine Landung**.

---

## 7. TERMIN-ZUORDNUNG, GESAMMELT

| Posten | vor der Abgabe (Fr 08.08.) | nach der Abgabe |
|---|---|---|
| **F3 Weg a** | nein | **ja** (Plan-Empfehlung 6.2; Owner-GO liegt vor) |
| **F5 S0-S5** | -- (bereits gelandet) | -- |
| **F5 G8** (ce-Naht-Fixture) | optional, ~30 min | ja, unkritisch |
| **F5 S6** (`line_size`-Konsum) | **NEIN -- TABU/E-4** | ja, mit Owner-Entscheid |
| **R4** | -- (erledigt) | -- |
| **B12 GERUEST** | **JA -- "vor der Messung", Owner-Terminierung** | -- |
| **B12 Fuellung** | nein | ja (P4) |
| **Aufraeumpass AP-02** | nein (Heimat P4) | ja |
| **Aufraeumpass AP-03/04/05/06/10** | **nein** | ja, als EIN Paket |
| **AP-09** (`axis_inventory.tex`) | nein -- **aber** der Entscheid (welcher Anhang) kann sofort fallen | Bau danach |
| **AP-07** (Bergung der M1-M3-Texte) | nein | ja, **vor** dem Pass |
| **AP-11 / AP-12** | **nein, gesperrt** | ja, nach F7-(b) bzw. PMC-Invariante |
| **AP-13** (Listen-Zusammenfuehrung) | nein | **ja, als ERSTER Schritt des Passes** |

---

## 8. OWNER-FRAGEN AUS DIESEM PLAN (gesammelt, keine sofortige Antwort noetig)

1. **E-4-Folgefrage (F5-S6):** 19. `binary_id`-Segment mit Join-Bruecke **oder** eigene CSV-Spalte
   ohne Grammatik-Aenderung? -- **Empfehlung: eigene Spalte** (Abschnitt 2.5). *Nach der Abgabe.*
2. **AP-09:** In welchen Anhang gehoert `axis_inventory.tex`? -- **Vorschlag: Anhang B**, DE+EN
   paritaetisch. *Kann sofort entschieden werden, Bau danach.*
3. **AP-12 Nebenfrage:** `measure:golden-320` traegt **nicht** die
   `COMDARE_STATIC_SMOKE_FALLBACK`-Bedingung, die sein eigener DEPRECATED-Kommentar behauptet.
   Ist der Job deprecated (dann fehlt die Bedingung) oder nicht (dann ist der Kommentar falsch)?
   -- *beruehrt den Messlauf, deshalb vor Phase 6.*
4. **AP-09-Nebenbefund:** Zwei Checkouts desselben Thesis-Repos im super auf verschiedenen Staenden
   (`thesis/diplomarbeit` = `29a1700d`, `Code/external/20260931-overleaf-diplomarbeit` = `8970465d`).
   Ist die Doppelung gewollt? -- *nach der Abgabe.*

---

## 9. SELBSTCHECK

- ASCII-only ausserhalb der Zitate: ja (keine Umlaute, kein Paragrafen-Zeichen, keine Box-Drawing-Zeichen).
- Jede Zahl mit Bezugsgroesse: ja (Suchmuster + Scope je Zaehlung ausgewiesen).
- Nicht Belegbares als UNBELEGT markiert: AP-07 (Gegenstand), AP-05 (Original-Liste), AP-10
  (Compiler-Verhalten), AP-13 (vier Alt-Kandidaten ungeprueft), F3 (Zahl "12 Naht-Tests"),
  R4 (Bilanz 407/407 = BERICHTET).
- Kein Code editiert, kein Commit, kein Worktree unter `/home/comdare/wt-*` beruehrt.
- Widerrufene Vor-Erhebungs-Aussage ausdruecklich als solche gekennzeichnet: AP-12.
