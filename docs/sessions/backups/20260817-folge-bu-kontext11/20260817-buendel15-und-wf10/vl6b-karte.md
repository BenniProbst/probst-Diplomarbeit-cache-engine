# VL-6b-Explorer: F5-Owner-Wort "golden bewegen + XML-Syntax/Semantik + Planer-Interpreter" — Bestands-Explore

## 1. F5-WORTLAUT (woertlich, Ledger-Ur-Segment)

**Fundstelle:** `docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md:24805`, Abschnitt "NACHTRAG 06.08.2026 vormittag-50 (OWNER-ENTSCHEIDE F1/F3/F4/F5/O-3 VERBATIM)".

> OWNER VERBATIM: "F1: Bestaetigt, war korrekt. F3: Bitte sauber die fixture nachziehen und am besten nochmal gruendlich planen. F4: [...] **F5: Bitte bewege golden und die golden Traeger, die muessen den neuen Gegebenheiten angepasst und geupdated werden, ebenfalls die Syntax und Semantik der XML wenn notwendig und der Interpreter dazu im Planer.** O-3: [...]"

**Geparste Konsequenz** (Ledger:24810, selber Nachtrag):
> "(F5) GOLDEN-UPDATE-FENSTER NEU (grosser Posten, Planung vorweg): golden + BEIDE golden-Traeger BEWEGEN -- an die neuen Gegebenheiten anpassen (search_algo-Pin-Frage geht darin auf); WENN NOETIG auch XML-Syntax+Semantik erweitern UND den Interpreter dazu im Planer nachziehen. ACHTUNG TABU-Wechselwirkung: die golden-320-Byte-Wachen/CRC-Anker werden in diesem Fenster kontrolliert NEU geankert [...] -- NICHT nebenbei, eigenes Fenster mit Gates."

**Bauplan-Traeger:** Ledger:24789 beauftragt "F5-GOLDEN-PLANUNG" (`wf_6a3096f7`) → Opus-Bauplan `docs/plaene/20260806-PLAN-golden-update-fenster.md` (55.805 Byte, bindend). Dieser Plan definiert **exakt**, was "golden" und "die golden-Traeger" sind (Plan Z.56-58):
- **golden** = `super/Code/test_data_xml/experiment_golden_kern.xml` (kanonische Trigger-Input-Basis)
- **die beiden golden-Traeger** = `experiment_golden_kern.xml` (super) **+** `ce/libs/cache_engine/algorithm_profiles/thesis_profiles/all_axes_golden.profile.xml` (Schwester-Traeger, ce)

Der Plan zerlegt den Auftrag in 8 Scope-Posten G1-G8 (Plan Z.61-73) und einen DAG S0-S7 (Z.96-133), mit **G5 = XML-Syntax** (`experiment_schema.xsd`, additiv `run_options`+`organ_subaxes`) und **G6 = "der woertliche Owner-Auftrag 'und der Interpreter dazu im Planer'"** (`ce/libs/common/serialization/xml_config_parser/xml_config_parser.{hpp,cpp}`: `struct ExperimentProfile` + `parse_experiment_profile` + `validate_experiment_profile` um die zwei Elemente erweitern).

---

## 2. ERLEDIGT-BILANZ (mit Commit-Belegen, am Objekt ce@04ac26fa / super gepruft)

### ERLEDIGT — golden + golden-Traeger-Inhalt (G1-G4, G7)

| Posten | Ist-Zustand (heute, verifiziert) | Beleg |
|---|---|---|
| **G1** kaputter `search_algo`-Pin | `experiment_golden_kern.xml:217`: `allowed_variants="k_ary interpolation"` — jetzt gueltige Registry-Namen (vorher `binary_search linear_search`, keine Registry-Treffer) | Commit `953ce412` (06.08. 10:31 UTC, ce) "fix(golden-xml+wachen): B14-NB2 -- golden-N maschinenlesbar kodiert (2^17), **Registry-Namen gepinnt**, 4 Wach-Loecher geschlossen" |
| **G2** N nicht maschinenlesbar | `experiment_golden_kern.xml:66/147`: `<run_options cap="131072"/>` jetzt vorhanden | selber Commit `953ce412` |
| **G3** F-3-Regression (3 Ein-Tool-Lanen statt Vollmenge) | `experiment_golden_kern.xml:415-417`: EIN `<combo tools="wallclock macro micro"/>` (Vollmenge in EINER CEB, wie §64/22.07. verlangt) | Teil der B14-Welle (Ledger:25025: "NEU-FUND F-3-REGRESSION [...] nachgezogen") |
| **G4/E-5** leere System-Kanaele `target_isa`/`compiler` | `experiment_golden_kern.xml:364-378` jetzt befuellt; `atomic128` bewusst leer dokumentiert ("BEWUSST NICHT [verwendet]", Z.354) | selbe Welle |
| **G7** 3 Wachen scharf, xmllint statt Regex | `Code/tests/{fixture_schema_subset_check,fixture_sync_check,golden_n_consistency_check}.cmake` existieren, alle xmllint-Pflicht ("xmllint ist Pflicht", `fixture_schema_subset_check.cmake:40`) — genau S1 des DAG | selbe Welle, 06.08. 17:34 |

Diese Arbeit lag am 06.08. (Bauplan-Schreibzeitpunkt) noch **ungelandet auf Branch `wt-b14-golden-kf6`** (Plan Z.21-23: "wt-b14 unlanded Commits: `71617a1b`, `6558c4ae`, `d8073913`, `953ce412`"); der Plan absorbierte sie ausdruecklich als eigene G1/G2/G5/G7-Posten. Sie landete ueber die **B14-Abschluss-Welle** in `development` und ist damit Teil der heutigen Historie von ce@04ac26fa.

### TEILWEISE ERLEDIGT — XML-Syntax (G5)

`super/Code/test_data_xml/experiment_schema.xsd:59` traegt `<xs:element name="run_options" ... minOccurs="0"/>`, `:81` traegt `<xs:element name="organ_subaxes" ... minOccurs="0"/>` — additiv, rueckwaerts-neutral, exakt wie G5 verlangt. Kommentare im XSD zitieren selbst "B14-NB2 (2026-08-06)" bzw. "KF-6 / Owner-A4 (B14, 2026-08-06)" als Ursprung (Commits `6558c4ae`, `953ce412`). **Die Vokabular-Erweiterung STEHT.**

### NICHT ERLEDIGT — "der Interpreter dazu im Planer" (G6) — der woertlichste Teil des Owner-Satzes

Direkt am Code verifiziert (ce@04ac26fa, heute):

- `struct ExperimentProfile` (`ce/libs/common/serialization/xml_config_parser/xml_config_parser.hpp:467-499`, komplett gelesen) hat **kein** `run_options`-Feld, **kein** `organ_subaxes`-Feld.
- `XmlConfigParser::parse_experiment_profile()` (`xml_config_parser.cpp:469-594`, komplett gelesen) liest **weder** `<run_options>` **noch** `<organ_subaxes>`.
- `run_options` existiert im Code NUR in `parse_thesis_profile` (Zeilen 450-460, fuer den **ce**-Traeger `all_axes_golden.profile.xml`) — nicht fuer den **super**-Traeger.
- `organ_subaxes`: **0 Treffer** in xml_config_parser.hpp UND .cpp zusammen (`grep -n "organ_subaxes"` beide Dateien → leer).
- `validate_profile.hpp`: **0 Treffer** fuer "run_options"/"organ_subaxes" (`grep` RC=1).

Die golden-XML selbst dokumentiert das noch **heute wortgleich** (`experiment_golden_kern.xml:299-301`):
> "HEUTE DEKLARATIV: parse_experiment_profile liest \<organ_subaxes\> noch nicht (unbekannte Wurzel-Kinder werden still ignoriert) - der Lese-, Validier- und Codegen-Kanal ist die dokumentierte ce-Auflage dieses Pakets."

Dasselbe Zitat steht bereits im Ledger vom **Abend des Auftragstages** (Ledger:23062-23064, NACHTRAG "06.08.2026 abend-1", Header :22904) — also Stunden NACH F5 selbst bereits als offen protokolliert, und ist seither **11 Tage unveraendert** (gegengeprueft: identischer Wortlaut in der Datei von heute).

**Einordnung des Bauplans selbst** (Plan Z.538, Abschnitt 8 "VOR DER ABGABE — nur wenn S1 sauber durchkommt"): G6/S4 wurde vom Plan **selbst** vorab als "Grenzfall" eingestuft: *"Der Owner-Auftrag F5 nennt den Interpreter ausdruecklich -- aber er ist zur Abgabe nicht funktional noetig [...] Empfehlung: versuchen, aber nicht erzwingen. Faellt S4 aus, ist der Zustand trotzdem konsistent [...] der Lese-Kanal ist als dokumentierte Auflage offen."* Der eigentliche **semantische Konsum** (S6 — der Wert wirkt wirklich in der Bau-Matrix) ist explizit "NACH DER ABGABE" verortet (Plan Z.540-548), weil er die binary_id-Grammatik bricht (E-4) und die Bau-Matrix auf 2.097.152 vervierfacht.

### UNGEKLAERT/NICHT SYNCHRON — G8 (ce-Naht-Fixture)

Diff `ce/tests/unit/thesis_tiere/experiment_golden_kern.xml` gegen die kanonische super-Datei: komplett verschieden (ce-Kopie traegt noch ihren 2026-07-22-Kopf). ABER: laut Ledger:24977 ("SCHEIBE-6-EXPLORE-ANTWORT verbucht") ist das **kein Bug, sondern Design** — die ce-Fixture ist laut eigenem Kopf "KEINE Kopie, sondern eine EIGENSTAENDIGE Parser-/Validator-Naht-Fixture mit ABSICHTLICH divergenten Werten [...] Byte-Sync wuerde sie rot schiessen." Diese Flaeche gehoert zum **Schwester-Auftrag F3/Scheibe-6** aus demselben Owner-Satz vom 06.08. ("F3: Bitte sauber die fixture nachziehen"), nicht zu F5s G8 im engen Sinn — Traeger dort, nicht hier offen.

---

## 3. TRAEGER-ZUORDNUNG DER OFFENEN TEILE

**Wichtiger Nebenbefund — Namenskollision:** Das Label "F5" wurde nach dem 06.08. fuer ein **zweites, tatsaechlich gelandetes** Arbeitspaket wiederverwendet: KON73-02 (Ledger:1379, spaeter, ~15.08.) fuehrt *"F5: DREI Homes mess_axes/system_axes/ORGAN_AXES (auch axes/->organ_axes, 640 Records golden-brechend -> ins EINE B2+#16-Fenster)"* — das ist die **Achsen-Verzeichnis-Umstrukturierung** (`libs/cache_engine/{organ_axes,system_axes,mess_axes}/`), NICHT der golden-XML-Inhalt aus dem Bauplan. Diese Lesart landete via Commit `5fa37f36` (16.08., Rekonstruktions-Commit, zitiert explizit "F5-Rename axes->organ_axes") im **golden-Fenster #16** (Merge `fbe898be`→development = ce `90ee6809`, dann Floor-Nachzug → `04ac26fa`; KON97/98, Ledger:207-227) und ist CI-bewiesen (26/27 gruen, Kombibau 4x "494 tests passed"). Die dazugehoerige Nachposten-Buchfuehrung (KON98, Ledger:233-237, **aktueller Stand**) nennt genau DREI offene "golden-Nachposten": (a) `all_axes_golden.profile.xml`-Wohlform, (b) telemetry-silent-Wiring, (c) E-B-Stempel-CRC-Bruch — **keiner davon ist der Interpreter-Posten G6.**

Damit: **G6 (Interpreter im Planer) ist weder im golden-Fenster #16 mitgelandet noch in dessen offizieller Nachposten-Liste erfasst.** Es ist aber **nicht heimatlos** — es hat einen vom Bauplan selbst benannten Nachfolge-Slot: Abschnitt 8 "NACH DER ABGABE" desselben Dokuments, gekoppelt an **S6** (semantischer `line_size`-Konsum) — und S6 ist seinerseits ein bekannter, mehrfach weiterverfolgter Ledger-Posten unter den Namen "KF-6 Halbzeit 2" / "B14-NB3" / `kLbufBytes` (`abi_adapter.hpp`) / `scan_field_sum` (`axis_05_memory_layout_cache_line_aligned.hpp:60`, dort weiterhin `kCacheLine=64` hart, Achse wird nicht befragt — zuletzt referenziert in Ledger:22018 "KF-6-PRAEZISIERUNG" und in der B14-NB3-Codex-Diagnose Ledger:24798).

**Der einzige echte Buchfuehrungs-Fehler ist also NICHT "Posten existiert nirgends", sondern: der bereits vom Bauplan benannte Nach-Abgabe-Slot (G6-Lesekanal als Vorstufe zu S6/KF-6-Konsum) fehlt in der aktuell aktiven Postenliste (weder Task-Nummer noch KON98-Nachposten-Paket).**

---

## 4. BLEIBT EINE OWNER-FRAGE?

**Nein.** Der Rest-Teil ("Interpreter dazu im Planer", G6) ist autonom zuordenbar:
1. Der Bauplan selbst (vom Owner nie widerrufen) hat ihn bereits disponiert: "versuchen, aber nicht erzwingen" vor Abgabe, mit explizitem OK fuer den sauberen Teilstand ohne G6.
2. Sein natuerlicher Anschluss (S6/KF-6-Konsum) ist ein bereits eingefuehrter, laufend verfolgter Posten (KF-6/B14-NB3/kLbufBytes-Familie), keine neue Entscheidung.
3. Es gibt keinen Wertungskonflikt, der einen Owner-Ein-Satz braeuchte — nur eine fehlende Zeile in der Postenliste.

**Empfehlung statt Frage:** G6 (`parse_experiment_profile` + `struct ExperimentProfile` + `validate_experiment_profile` um `run_options`/`organ_subaxes` erweitern) als expliziten Nachtrag zur KF-6/S6-Posten-Familie buchen, damit er nicht ein zweites Mal durchs Buchfuehrungs-Raster faellt.

---

## 5. GEPRUEFT / NICHT GEPRUEFT

**Geprueft (direkt am Objekt, diese Session):**
- F5-Wortlaut inkl. ±40-Zeilen-Kontext, Ledger:24765-24846 (Read-Tool, vollstaendig gelesen)
- `docs/plaene/20260806-PLAN-golden-update-fenster.md` (Kopf, Scope-Tabelle, DAG, Abschnitt 8) direkt gelesen
- `xml_config_parser.hpp` (struct ExperimentProfile, Z.467-499) und `xml_config_parser.cpp` (komplette Funktion `parse_experiment_profile`, Z.395-594) am aktuellen Checkout (ce@04ac26fa) gelesen, nicht nur gegrept
- `validate_profile.hpp`, `experiment_schema.xsd`, `experiment_golden_kern.xml`, `cache_engine_axis_registry.xml` gegrept/gelesen
- git log (Datum+Hash) fuer alle vier Kern-Dateien (xml_config_parser.{hpp,cpp}, experiment_schema.xsd, experiment_golden_kern.xml, validate_profile.hpp, experiment_plan_director.hpp) seit 06.08.
- diff ce-Naht-Fixture vs. super-Kanon (RC=0, inhaltlich verschieden)
- Gegenprobe: identisches "HEUTE DEKLARATIV"-Zitat in Ledger-Abend-Nachtrag vom 06.08. UND in der heutigen Datei

**Nicht geprueft (aus Ledger uebernommen, nicht am Objekt gegengelesen):**
- CI-Gruenstatus von Job 15936/15937 selbst (nur Ledger-Zitat, keine eigene Pipeline-Abfrage)
- Aktueller Landestatus von F3/Scheibe-6 (Schwester-Auftrag) jenseits der 06.08.-Deklaration "NEUER Posten (nach Pause)" — aus dem Scope dieses F5-Explores bewusst ausgeklammert
- prt-art-Repo selbst (nur ueber Ledger-Zitat zu #79/KON99-01 referenziert)
- Formale Owner-Bestaetigung je Einzelentscheidung E-1/E-5 (nur der resultierende Dateizustand wurde gegen die Entscheidungsvorlage abgeglichen, kein expliziter "Owner sagte X"-Beleg pro E-Punkt gesucht)

**Gegenprobe fuer den zentralen Nichtfund (G6):** durchgefuehrt — zwei unabhaengige Nullbefunde (grep ueber beide Interpreter-Dateien UND validate_profile.hpp) plus ein positiver Gegenbeleg (die Datei bezeugt den Nichtbefund seit 06.08. selbst, wortgleich bis heute), damit kein Fall der "stillen Falsch-Null".