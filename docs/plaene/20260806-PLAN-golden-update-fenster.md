# PLAN: GOLDEN-UPDATE-FENSTER (Owner-F5) -- bindender Bauplan

> **Status:** BAUPLAN, Phase 2 der Welle `wf_6a3096f7` ("F5-GOLDEN-PLANUNG", Ledger `docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md:4209`).
> Phase 1 = Sonnet-Ist-Erhebung (Vorlauf-Ergebnis, in diesem Dokument verarbeitet und punktuell am Objekt nachgeprueft).
> **KEIN Code-Bau, KEIN Commit in diesem Dokument.** Es liefert Reihenfolge, Gates, Anker-Verfahren und Owner-Entscheid-Vorlagen.
>
> **Owner-Auftrag F5 VERBATIM** (Ledger `:4193`, NACHTRAG 06.08. vormittag-50):
> "Bitte bewege golden und die golden Traeger, die muessen den neuen Gegebenheiten angepasst und geupdated werden,
> ebenfalls die Syntax und Semantik der XML wenn notwendig und der Interpreter dazu im Planer."

## 0. IST-ANKER (literal geprueft 2026-08-06)

Pfad-Kuerzel: `super/` = `/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine`,
`ce/` = `super/Code/external/comdare-cache-engine`,
`wt-b14/` = `/home/comdare/wt-b14-golden` (blockierter Worktree, Branch `b14-golden-kf6`).

| Anker | Wert |
|---|---|
| super HEAD | `161247c5` |
| ce HEAD (im super-Submodul) | `3bbcb8ed` |
| wt-b14 HEAD | `953ce412`, Branch `b14-golden-kf6` |
| wt-b14 merge-base gegen super HEAD | `3585541b` -- die Branch ist **hinter** dem gelandeten Stand |
| wt-b14 unlanded Commits | `71617a1b`, `6558c4ae`, `d8073913`, `953ce412` (**VIER**, nicht drei -- der Ist-Bericht nannte nur drei) |
| wt-b14 ce-Submodul-Zeiger | `7969b399` -- **veraltet** gegen den gelandeten `3bbcb8ed` |
| `xmllint` verfuegbar | JA: `/usr/bin/xmllint`, libxml `20914`, Feature-Liste enthaelt `Schemas` |

**Zwei Korrekturen am Ist-Bericht** (beide am Objekt geprueft):

1. Der Ist-Bericht sagt, die Vokabular-Wache `fixture_schema_subset_check.cmake` liege nur in `wt-b14`. Richtig ist:
   sie kam mit dem **vierten**, ebenfalls ungelandeten Commit `71617a1b` ("Vokabular-Wache fuer das NEU-PAAR ...,
   #48-Scheibe-6 vollzogen"). Im gelandeten super existiert in `super/Code/tests/` **ausschliesslich**
   `fixture_sync_check.cmake` (geprueft: `ls Code/tests/*.cmake`), registriert als genau zwei Tests
   (`super/Code/tests/CMakeLists.txt:146` und `:151`, Properties `:156-158`). Es sind also **drei** Wachen
   ungelandet, nicht zwei.
2. Der Ist-Bericht bricht in Abschnitt 4 ab. Die dort offene Frage ist hiermit beantwortet: `parse_experiment_profile`
   liest **weder** `run_options` **noch** `organ_subaxes` (`ce/libs/common/serialization/xml_config_parser/xml_config_parser.cpp:454-558`,
   vollstaendige `root->child(...)`-Kette). `run_options` wird ausschliesslich im **thesis**-Dialekt gelesen
   (`xml_config_parser.cpp:425`, `parse_thesis_profile`). Der Befund "heute deklarativ" ist damit bestaetigt.

**Ein dritter Befund, den der Ist-Bericht nicht hat** (er ist der teuerste des ganzen Fensters, s. Abschnitt 4 TABU-6):
`profile_to_tree.hpp:82-86` erzeugt aus einer deklarierten `cacheline`-Sub-Achse eine **statische** Ebene
(`AxisLevel{"cacheline.line_size", ..., true, ""}`). `serialize_composition_path` emittiert dagegen exakt die
**18** Segmente aus `kCompositionAxisNames` (`ce/libs/cache_engine/builder/experiment_tree/axis_path_serialization.hpp:40,62-64`);
`cacheline` steht dort **nicht** drin. Der KF-6-Konsum haengt das Segment also ueber einen **anderen** Emissionsweg an
(Muster `with_shape_segment`, ebd. `:94-103`). Die Folge steht im wt-b14-Vermerk
`wt-b14/.../NOTIZ-binary-id-grammatik-der-archive.md`: neue Laeufe tragen ein zusaetzliches Segment,
**kein Zeilen-Join alt-gegen-neu ueber die rohe binary_id mehr**. Das ist ein Bruch der Mess-Archiv-Grammatik
und damit ein OWNER-ENTSCHEID (E-4), kein Bau-Detail.

---

## 1. ZIEL UND SCOPE

### 1.1 Ziel

Die **kanonische Trigger-Input-Basis** `super/Code/test_data_xml/experiment_golden_kern.xml` und ihr
Schwester-Traeger `ce/libs/cache_engine/algorithm_profiles/thesis_profiles/all_axes_golden.profile.xml`
sollen (a) **widerspruchsfrei**, (b) **maschinenlesbar vollstaendig** und (c) **dauerhaft bewacht** sein,
bevor der Trigger (Ziel Do 07.08.) den Voll-Bau aus ihnen ableitet.

### 1.2 IM SCOPE (was bewegt wird)

| # | Gegenstand | Datei:Zeile | Was genau |
|---|---|---|---|
| G1 | **golden-Instanz: kaputter Pin** | `super/Code/test_data_xml/experiment_golden_kern.xml:96` | `allowed_variants="binary_search linear_search"` sind **keine Registry-Namen**. `ce/libs/cache_engine/algorithm_profiles/cache_engine_axis_registry.xml:9-14` fuehrt fuer `search_algo` (Slot T00) genau vier Bausteine: `k_ary`, `interpolation`, `eytzinger`, `linear_scan`. `validate_experiment_profile` Pruefung (5) (`ce/libs/cache_engine/profile_facade/validate_profile.hpp:1249-1258`) setzt `r.ok=false` und meldet "UNGUELTIGE allowed_variant". **Die kanonische golden-XML ist im gelandeten Stand nicht validierbar.** -> Owner-Entscheid E-1. |
| G2 | **golden-Instanz: N nicht kodiert** | ebd. `:95-99` | Nur zwei Achsen genannt, 16 ungenannt = Voll-Sweep gegen die Registry-Kardinalitaeten -> rechnerisch ~6e10, nicht 2^17. Der Owner-Kanon `N = 2^17 = 131072` existiert maschinenlesbar **nur** im Schwester-Traeger (`all_axes_golden.profile.xml:163`, `<run_options cap="131072" .../>`). |
| G3 | **golden-Instanz: F-3-Regression** | ebd. `:136-140` | Drei separate Ein-Tool-Combos (`wallclock` / `macro` / `micro`) = drei CEB-Lanen. Sektion 64 / Owner 22.07. hat den Default auf die **Vollmenge in EINER CEB** gestellt; `all_axes_golden.profile.xml:221-226` ist seitdem korrigiert, `experiment_golden_kern.xml` **nicht**. Reine Nachzieh-Korrektur, kein Entscheid. |
| G4 | **golden-Instanz: leere System-Kanaele** | ebd. `:107-120` | `target_isa` (seit A4 20.07. im XSD `super/Code/test_data_xml/experiment_schema.xsd:421` und im Parser `xml_config_parser.cpp:121`) ist ungenutzt. `compiler/atomic128` (XSD `:355`, Parser `:111`) ebenfalls -> Owner-Entscheid E-5. |
| G5 | **XML-Syntax (XSD-Vokabular)** | `super/Code/test_data_xml/experiment_schema.xsd` | Additiv `run_options` + `organ_subaxes`, beide `minOccurs="0"` = rueckwaerts-neutral. Vokabular **zeichengleich** zum thesis-Dialekt, damit die spaetere Parser-Naht EINE Lese-Funktion bleibt. -> Owner-Entscheid E-3. |
| G6 | **Interpreter im Planer** | `ce/libs/common/serialization/xml_config_parser/xml_config_parser.{hpp,cpp}` | `struct ExperimentProfile` (`xml_config_parser.hpp:441-473`) um `run_options` + `organ_subaxes` erweitern; `parse_experiment_profile` (`xml_config_parser.cpp:454-558`) um die zwei `root->child(...)`-Glieder; `validate_experiment_profile` um die passenden Pruefungen. **Das ist der woertliche Owner-Auftrag "und der Interpreter dazu im Planer".** |
| G7 | **Wachen** | `super/Code/tests/` + `super/Code/tests/CMakeLists.txt` | Die drei ungelandeten Wachen scharf stellen -- aber **auf xmllint-Grundlage** statt auf Regex (s. S1). |
| G8 | **ce-Naht-Fixture** | `ce/tests/unit/thesis_tiere/experiment_golden_kern.xml` + `test_experiment_kern_seam.cpp` (**15** `TEST(`, geprueft) | Muss dem erweiterten Vokabular folgen, sonst prueft die Naht ein totes Schema. Beruehrt F3/Scheibe-6 (s. 1.4). |

### 1.3 AUSDRUECKLICH NICHT IM SCOPE

| Nicht bewegt | Begruendung |
|---|---|
| `all_axes_golden.profile.xml` **inhaltlich** | Sie ist die deklarative Spiegelung des CRC-Ankers und laut `experiment_golden_kern.xml:21` "bleibt unangetastet". Sie wird in diesem Fenster **nur gelesen**. Ausnahme nur unter Owner-Entscheid E-1 Option B. |
| `experiment_golden.xml` (Alt-Paar, 110 Z.) + ce-Kopie + `test_fixture_sync_experiment_golden` | Sie treiben weiterhin real den Antriebs-Test (`super/Code/02_messung_driver/CMakeLists.txt:132` setzt `COMDARE_V32_EXPERIMENT_GOLDEN_XML` auf `../test_data_xml/experiment_golden.xml`; Konsument `super/Code/02_messung_driver/tests/test_v32_messreihe_antrieb.cpp:74`). **Additiv-daneben-Doktrin**: die Byte-Wache bleibt byte-unberuehrt in Kraft. Aufraeumen (Umhaengung) ist F3/Scheibe-6, unter Absprache. |
| `kNewGolden131072Crc64` / `FullSourceCatalog` / `golden_320_catalog` | Sie haengen an der **ce-Registry-Reihenfolge**, nicht an den XML-Traegern. In diesem Fenster wird die Registry nicht bewegt -> kein Re-Anker (s. Abschnitt 3 A5). |
| Die 6 TABU-Dateien | s. Abschnitt 4. Fuenf werden **nicht** angefasst; die sechste (Wire/binary_id-Grammatik) nur unter Owner-Entscheid E-4. |
| ce-Konsum von `line_size` (KF-6 Halbzeit 2) | Gehoert in dieses Fenster **nur als Deklaration** (G5). Der **Konsum** ist Schritt S6 und steht unter E-4. |
| Codegen-NTTP-Emission der Line-Groessen | Post-Abgabe (s. Abschnitt 8). |

### 1.4 ABGRENZUNG GEGEN DIE ZWEI PARALLEL LAUFENDEN WELLEN

Beide beruehren dieselben Dateien. **Ein-Schreiber-Regel je Datei ist bindend.**

| Welle | Ledger | Besitzt exklusiv | F5 darf dort NICHT schreiben |
|---|---|---|---|
| **B14-NB3** `wf_afd2df95` | `:4206` | `super/Code/tests/fixture_schema_subset_check.cmake`, `super/Code/tests/golden_n_consistency_check.cmake`; ce-seitig `axis_05_memory_layout_cache_line_aligned.hpp`, `abi_adapter.hpp` | S1 und S6 sind **Auflagen an diese Welle**, nicht eigene F5-Bauschritte. F5 liefert ihr die Leitplanke und das Gate. |
| **F3-SCHEIBE-6** `wf_41e47ee7` | `:4206` | Umbenennung/Entflechtung der ce-Naht-Fixture `experiment_golden_kern.xml` + der 15 Naht-Tests | F5 aendert die ce-Fixture **inhaltlich** (G8), F3 benennt sie **um**. **Reihenfolge-Entscheid: F5 zuerst inhaltlich, F3 danach umbenennen** -- eine Umbenennung unter laufender Inhaltsaenderung erzeugt einen Konflikt ohne Gewinn. F3 ist ohnehin als "nach der Pause" registriert (Ledger `:4193`). |

---

## 2. REIHENFOLGE ALS DAG

### 2.1 Der DAG

```
                          [S0] Entsperrung wt-b14
                          (Merge dev, ce-Zeiger 3bbcb8ed)
                                    |
              +---------------------+---------------------+
              |                                           |
   [S1] Wach-Fundament: xmllint                [S2] VOKABULAR: XSD additiv
        statt Regex-Lexer                           run_options + organ_subaxes
        (loest 4 Codex-HOCH an der Wurzel)          (minOccurs=0, rueckwaerts-neutral)
              |                                           |
              |                          +----------------+----------------+
              |                          |                                 |
              |               [S3] INSTANZ super                [S4] INTERPRETER ce
              |                    golden_kern.xml                   parse_experiment_profile
              |                    G1..G4 + run_options                  + validate
              |                    + organ_subaxes                   (parallel zu S3 baubar,
              |                          |                            Landung NACH S2)
              |                          |                                 |
              |               [S3b] ce-Naht-Fixture nachziehen (G8)        |
              |                          |                                 |
              +---------------+----------+---------------------------------+
                              |
                    [S5] WACHEN NEU ANKERN (ZULETZT)
                    test_golden_n_consistency + test_fixture_schema_* scharf
                    + Biss-Beweis je Wache
                              |
                    ===== ABGABE-SCHNITT (Fr 08.08.) =====
                              |
                    [S6] SEMANTISCHER KONSUM line_size (ce)   <-- unter OWNER-ENTSCHEID E-4
                    kLbufBytes ableiten, scan_field_sum an die Achse binden,
                    Wrapper-Audit, RAII; binary_id-Grammatik bricht
                              |
                    [S7] Aufraeumpass: Alt-Paar umhaengen (F3/Scheibe-6)  <-- unter Absprache
```

### 2.2 Begruendung jeder Kante

| Kante | Warum zwingend |
|---|---|
| S0 -> alles | `wt-b14` steht auf merge-base `3585541b` und traegt einen **veralteten ce-Zeiger** `7969b399` gegen den gelandeten `3bbcb8ed`. Wer darauf weiterbaut, landet spaeter eine **Submodul-Ruecksetzung**. Merge (nie rebase) zuerst. |
| S1 -> S5 | Die Wache ist das **Beweisinstrument** von S5. Ein Instrument mit vier bekannten Lueckern (Codex-SUPER-HOCH, Ledger `:4207`) kann keinen Biss-Beweis tragen. **xmllint existiert und kann Schemas** (geprueft) -- die vier Regex-Befunde (CDATA-im-Kommentar, keine Entity-Expansion, ASCII-Namensgrenze, nur textueller Truncation-Riegel) sind **alle vier Symptome derselben Wurzel**: ein Regex-Lexer ist kein XML-Parser. Vier Regex-Pflaster heilen die Wurzel nicht. Das ist die Ledger-Leitplanke `:4206` und sie ist hiermit als Bau-Vorgabe bestaetigt. |
| S1 -> S2, S1 -> S3 | **Nein, diese Kante existiert nicht.** S2/S3 duerfen parallel zu S1 gebaut werden; nur die **Landung** von S5 haengt an S1. Das ist der Parallelitaets-Gewinn des Fensters. |
| S2 -> S3 | **Vokabular vor Instanz.** `<run_options>` und `<organ_subaxes>` in der Instanz, bevor die XSD sie kennt, macht `xmllint --schema` rot. Reihenfolge umgekehrt ist ein garantierter Rotlauf. |
| S2 -> S4 | **Vokabular vor Interpreter.** Der Parser liest, was das Schema definiert. Ein Interpreter gegen ein noch nicht entschiedenes Vokabular ist Wegwerfarbeit (E-3 entscheidet den Umfang). |
| S3 \|\| S4 | **Parallel baubar**: verschiedene Repos, disjunkte Dateien, keine Compile-Kopplung (die Instanz ist Daten, der Parser ist Code). **Nicht parallel landbar** -- die Landebahn ist seriell (Fahrplan-Leitplanke 2, `docs/plaene/20260806-FAHRPLAN-parallel-sequenz-optimiert.md`). |
| S4 -> S6 | **Interpreter vor semantischer Nutzung.** Solange `parse_experiment_profile` `organ_subaxes` nicht liest, ist der Block wirkungslos und die Bau-Matrix unveraendert. Genau diese Wirkungslosigkeit ist das, was S2/S3 **abgabe-sicher** macht. Wer S6 vorzieht, schaltet die Faktor-4-Bau-Matrix und den binary_id-Bruch scharf, bevor die Wachen stehen. |
| S3, S4 -> S5 | **Byte-/Vokabular-Wachen ZULETZT neu ankern.** Eine Wache, die waehrend der Instanz-Aenderung mitwandert, beweist nichts. Erst Ist einfrieren, dann Wache dagegen setzen, dann Biss-Beweis. |
| S5 -> S6 | Ohne stehende Wache ist der binary_id-Bruch in S6 nicht **eingegrenzt** -- man saehe nicht, ob nur `cacheline` oder auch die 18 Organ-Segmente wanderten. |
| ABGABE-SCHNITT vor S6 | S6 bricht die Mess-Archiv-Grammatik (Abschnitt 0, dritter Befund). Zwei Tage vor der Abgabe die Join-Faehigkeit der vorhandenen Messdaten zu brechen ist kein vertretbares Risiko. |

### 2.3 Parallel-Fenster (CPU-Leitplanke beachten)

Fahrplan-Leitplanke 1 (`docs/plaene/20260806-FAHRPLAN-parallel-sequenz-optimiert.md`): max EIN ce-Voll-Gate
(`-j6 nice`, 2-Pass-Configure, Doppellauf) + max EIN super-Slot (`-j3 nice`).

- **super-Slot:** S0 -> S2 -> S3 -> S3b -> S5 (die ganze Kette ist super-seitig, ausser S3b).
- **ce-Slot:** S4 (Interpreter) laeuft **parallel** dazu, braucht aber das Vokabular-Ergebnis aus S2 als Eingabe -> S4 startet, sobald E-3 entschieden ist, nicht erst wenn S2 gelandet ist.
- **read-only parallel, jederzeit:** die Biss-Beweis-Skripte fuer S5 vorbereiten (Abschnitt 3, Spalte "Biss-Beweis").

---

## 3. ANKER-NEUSETZUNG

**Owner-Doktrin (bindend):** "Alt-golden darf brechen, aber ERST ADDITIV, Aufraeumen unter Absprache"
(`feedback_alt_golden_darf_brechen_erst_additiv_dann_aufraeumen_unter_absprache.md`).

Verfahren fuer **jeden** Anker, ohne Ausnahme, in dieser Reihenfolge:
1. **ALT-WERT DOKUMENTIEREN** -- literal, mit Werkzeug-Ausgabe, im Datei-Kopf am Ort des Ankers (Praezedenz: `ce/libs/cache_engine/profile_facade/source_catalog.hpp:183-189` zeigt den `[MISMATCH]`-Werkzeug-Output des letzten Bruchs im Klartext).
2. **NEU ERZEUGEN** -- mit dem offiziellen Werkzeug, nie von Hand gerechnet.
3. **BISS-BEWEIS** -- eine absichtliche Verletzung einbauen, Wache muss ROT werden, Verletzung zuruecknehmen, Wache muss GRUEN werden. Ohne diesen Doppellauf ist eine "gruene" Wache nicht von einer stummen unterscheidbar. (Falle: `reference_drift_guard_faengt_anhaengen_nicht.md`; `reference_gruene_tests_zementieren_alte_ordnung.md`.)

| # | Anker / Wache | Ort | Bewegt? | Additiv oder harter Schnitt | Verfahren + Biss-Beweis |
|---|---|---|---|---|---|
| **A1** | `test_fixture_sync_experiment_golden` (Byte-Gate Alt-Paar) | `super/Code/tests/CMakeLists.txt:146-150`, `fixture_sync_check.cmake` | **NEIN** | -- | Bleibt byte-unberuehrt in Kraft. **Gate:** `git diff --exit-code` auf beide Dateien am Fenster-Ende + Test gruen. Der Alt-Traeger treibt weiter `02_messung_driver`. |
| **A2** | `test_fixture_schema_experiment_golden_kern` (Vokabular-Wache Neu-Paar) | ungelandet, `wt-b14/Code/tests/fixture_schema_subset_check.cmake` + `CMakeLists.txt:181` | **JA -- neu scharf** | **ADDITIV** (neue Wache neben A1, andere Datei, anderes Paar) | (1) Alt-Wert = "es gibt keine Wache" (im Kopf so vermerken). (2) Lexer auf `xmllint --noent --schema` umstellen (S1). (3) **Biss:** ein erfundenes Element `<zzz_kein_vokabular/>` in `experiment_golden_kern.xml` -> Test MUSS FATAL; entfernen -> gruen. Zusaetzlich der Codex-Gegenbeweis: ein `<![CDATA[...]]>` **innerhalb** eines Kommentars und ein `<?pi -- ?>`-Paar -> mit xmllint gruen (Regex-Lexer waere hier falsch gelaufen). |
| **A3** | `test_golden_n_consistency` (Ketten-Wache der zwei Traeger) | ungelandet, `wt-b14/Code/tests/golden_n_consistency_check.cmake` + `CMakeLists.txt:+188-194` | **JA -- neu scharf** | **ADDITIV** (voellig neue Wache, bricht nichts Bestehendes) | (1) Alt-Wert: keine. (2) Prueft laut ihrem Kopf `:16-24`: gleiche Achsen-Menge, je Achse gleiche Auspraegungs-Menge, gleiches Produkt, Produkt == `cap` **beider** Seiten. (3) **Biss, drei Verletzungen einzeln:** (a) eine Achse aus `axes_default_lookup` entfernen -> FATAL "Achsen-Menge"; (b) `interpolation` -> `eytzinger` tauschen -> FATAL "Auspraegungs-Menge"; (c) `cap="131072"` -> `cap="131071"` -> FATAL "cap != Produkt". Alle drei zuruecknehmen -> gruen. **Erst wenn alle drei gebissen haben, ist die Wache abgenommen.** |
| **A4** | `test_experiment_kern_seam` (ce-Naht, **15** `TEST(`) | `ce/tests/unit/thesis_tiere/test_experiment_kern_seam.cpp` | **JA -- Erwartungen wandern** | **ADDITIV**, solange nur neue Erwartungen fuer `run_options`/`organ_subaxes` **hinzukommen**. **HARTER SCHNITT** nur, falls eine bestehende Erwartung fallen muss -> dann **OWNER-ENTSCHEID**, einzeln vorlegen. | (1) Alt-Wert = die 15 Testnamen literal listen (`grep -n '^TEST(' ...`). (2) Neue Faelle **anhaengen**, bestehende nicht umschreiben. (3) **Biss:** die neuen Faelle gegen eine Fixture **ohne** `run_options` laufen lassen -> muessen rot sein. **Achtung:** der Ledger nennt hier historisch "12" (`:4385`) -- der Ist ist **15**. Die Ledger-Zahl ist veraltet und wird beim Abschluss mitgezogen. |
| **A5** | `kNewGolden131072Crc64 = 0x56F1B721C72DC10EULL` | `ce/libs/cache_engine/profile_facade/source_catalog.hpp:190`, bewacht von `ce/tests/unit/test_e24_c10_g6_identitaets_bilanz.cpp:93,178-180` | **NEIN** | -- | **Wird in diesem Fenster NICHT ausgeloest.** Begruendung literal: der Anker haengt am rein CT-definierten `FullSourceCatalog = CatalogAxes<2,...,2,1>` (`source_catalog.hpp:139`) und damit an der **Registry-Reihenfolge der ersten-2-Enabled-Bausteine** -- nicht an der XML. Der E-1-Pin `k_ary`+`interpolation` **sind** bereits die ersten zwei Enabled-Eintraege (`cache_engine_axis_registry.xml:10-11`). Die XML uebernimmt den Ist, sie verschiebt ihn nicht. **Gate:** `grep -c '0x56F1B721C72DC10E'` liefert am Fenster-Ende denselben Wert wie am Anfang; `static_assert catalog_axis_product<FullSourceCatalog>() == 131072` (`:169-171`) unveraendert. **Verfahren, falls E-1 Option B gewaehlt wird** (dann bewegt sich die Registry-Reihenfolge doch): `comdare_gen_golden_fullpilot --crc64` ausfuehren, den **literalen** Werkzeug-Output samt `[MISMATCH]`-Zeile in den Kopf-Kommentar `source_catalog.hpp:183-189` schreiben, neuen Wert an **zwei** Stellen eintragen (`source_catalog.hpp:190` UND `test_e24_c10_g6_identitaets_bilanz.cpp:93`), Biss: alten Wert kurz wiederherstellen -> Test MUSS rot. |
| **A6** | `golden_320_catalog` + die vier `golden_fullpilot_320_binary_ids{,_abi4,_abi5,_abi6}.txt` | `source_catalog.hpp:144`, `ce/tests/unit/thesis_tiere/` | **NEIN** | -- | Hart-TABU (Ledger `:153`). Haengt an anderen Traegern. **Gate:** `git diff --exit-code` auf die vier `.txt` + `static_assert catalog_axis_product<golden_320_catalog>() == 320` (`:172-173`) unveraendert. |
| **A7** | `kMaxMaterializableCatalogCardinality = 4096` + Guard-des-Guards | `source_catalog.hpp:205,209-212` | **NEIN** | -- | **Gate:** unveraendert. Wenn er bricht, hat jemand `FullSourceCatalog` bewegt -- genau das soll er melden. |
| **A8** | binary_id-Grammatik (`serialize_composition_path`, 18 Segmente) | `ce/libs/cache_engine/builder/experiment_tree/axis_path_serialization.hpp:40,62-64` | **NEIN in S0-S5. JA in S6.** | **HARTER SCHNITT -> OWNER-ENTSCHEID E-4** | In S0-S5 unberuehrt, weil der Konsum fehlt. **Gate fuer S5:** ein Testlauf muss binary_ids mit **exakt 18** Segmenten liefern, wie die Archive (`NOTIZ-binary-id-grammatik-der-archive.md`). In S6 waechst ein `cacheline.line_size=<n>`-Segment an -- ab dort ist kein roher Join alt-gegen-neu mehr moeglich. Verfahren dann: Alt-Grammatik in der NOTIZ dokumentieren (liegt vor), Projektions-Regel auf die 18 Organ-Segmente festschreiben, Biss = ein Vergleichs-Skript, das den rohen Join versucht und **fehlschlagen muss**. |

**Zusammenfassung additiv vs. hart:**
Von acht Ankern sind **drei additiv neu** (A2, A3, A4), **vier unberuehrt** (A1, A5, A6, A7), und **genau einer**
ist ein harter Schnitt (A8) -- und der liegt **hinter** dem Abgabe-Schnitt und unter Owner-Entscheid E-4.
Das Fenster ist damit bis S5 **vollstaendig additiv**.

---

## 4. TABU-BEHANDLUNG

Grundlage: Ledger `:153` (V6.5, hart-TABU) und `:225` (V5.8), mit dem Vermerk vom 26.07.
(ABI-7 `.A7.`, Observer-POD **1344** Version 8 -- **nicht** 1416, 18 Organ-Achsen T00-T17).
Auftragslage: "die golden-320-Byte-Wachen/CRC-Anker werden in diesem Fenster kontrolliert NEU geankert" (Ledger `:4193`).
**Ergebnis der Pruefung: fuenf der sechs TABU-Posten muessen dafuer gar nicht geoeffnet werden.**

| TABU-Posten | Ort | Angefasst? | Warum / Warum nicht | Gate, das den Beweis liefert |
|---|---|---|---|---|
| **TABU-1** `golden_fullpilot_320*` (4 `.txt`) + `CatalogAxes<4,4,5,4>=320` | `ce/tests/unit/thesis_tiere/golden_fullpilot_320_binary_ids{,_abi4,_abi5,_abi6}.txt`, `source_catalog.hpp:144` | **NEIN** | Sie haengen am CT-Katalog, nicht an den XML-Traegern. Der F5-Auftrag betrifft die Traeger. Der Ledger sagt es selbst: "bleiben davon unberuehrt, weil sie an anderen Traegern haengen" (`:4218`). | `git diff --exit-code -- ce/tests/unit/thesis_tiere/golden_fullpilot_320_binary_ids*.txt` **RC=0** am Fenster-Ende, plus `static_assert(...==320)` (`source_catalog.hpp:172-173`) unveraendert, plus `test_axis_sweep_pilot` / `test_profile_roundtrip` / `test_smoke_coverage_profile` gruen. |
| **TABU-2** `permutation_axes.xml` (Legacy-11-Achsen-Katalog) | `ce/libs/cache_engine/algorithm_profiles/permutation_axes.xml` | **NEIN** | Read-only per Entscheid E12 (Ledger `:225`): "NICHT informations-redundant zur ce-Registry, bleibt TABU-read-only". Nichts im F5-Auftrag braucht ihn. | `git diff --exit-code` **RC=0**. |
| **TABU-3** `m3v2_study.profile.xml` | `ce/libs/cache_engine/algorithm_profiles/thesis_profiles/m3v2_study.profile.xml` | **NEIN** | Sie ist die deckungsgleiche Referenz zu `golden_320_catalog`. F5 bewegt weder den 320er noch die Registry. | `git diff --exit-code` **RC=0** + `test_profile_roundtrip` gruen. |
| **TABU-4** `system_axis_registry.xml` | `ce/libs/cache_engine/include/cache_engine/measurement/system_axis_registry.xml` | **NEIN** | Der `target_isa`-Kanal existiert bereits vollstaendig -- im XSD (`experiment_schema.xsd:421-477`) **und** im Parser (`xml_config_parser.cpp:121-132`). G4 belegt nur die **Instanz** mit `x86_64`. Registry-Angebot unveraendert; die Instanz waehlt aus dem Angebot. | `git diff --exit-code` **RC=0**. Zusatzbeweis, dass die Belegung wirklich aus dem Angebot stammt: `validate_experiment_profile` gruen auf der neuen Instanz. |
| **TABU-5** `cache_engine_axis_registry.xml` (inkl. Registry-`mp_list`) | `ce/libs/cache_engine/algorithm_profiles/cache_engine_axis_registry.xml` | **NEIN -- und das ist der Kern des Entwurfs** | Der ganze G1-Pin-Fix funktioniert **weil** die XML die Registry-Namen **uebernimmt**, nicht weil die Registry sich bewegt. `k_ary`/`interpolation` sind bereits `enabled="true" golden_wired="true"` und stehen an Position 1 und 2 (`:10-11`). Genau deshalb bleibt A5 (CRC64) unberuehrt. Haette man stattdessen die Registry an die XML angepasst, waere das TABU-5 **und** TABU-1 **und** A5 auf einmal. | `git diff --exit-code` **RC=0** + `kNewGolden131072Crc64` literal unveraendert + `test_e24_c10_g6_identitaets_bilanz` gruen. |
| **TABU-6** PODs / Wire (`ComdareTierObserverSnapshot` POD 1344 v8, ABI-7 `.A7.`, `kV3AxisSchema`, `GenusBindingTraits`, `serialize_composition_path`) | `ce/libs/cache_engine/builder/experiment_tree/axis_path_serialization.hpp:40,62-64` u.a. | **NEIN bis S5. JA in S6.** | **Der einzige echte TABU-Kontakt des Fensters.** Bis S5 ist `organ_subaxes` reine Deklaration -- `parse_experiment_profile` liest sie nicht, `profile_to_tree.hpp:82-86` sieht sie nie, `serialize_composition_path` emittiert weiter genau 18 Segmente. In S6 (Konsum) waechst ein `cacheline.line_size`-Segment an und die Mess-Archiv-Joins brechen. | **Gate fuer S0-S5 (Nicht-Beruehrungs-Beweis):** ein Lauf auf der **neuen** golden-XML muss binary_ids mit **exakt 18** Segmenten liefern -- byte-identisch zur Archiv-Grammatik in `NOTIZ-binary-id-grammatik-der-archive.md`. Plus: `git diff --exit-code` auf `axis_path_serialization.hpp` RC=0. **Gate fuer S6:** eigenes Fenster, eigener Owner-GO (E-4). |

**Fazit der TABU-Pruefung:** die im Ledger `:4193` angekuendigte "kontrollierte Oeffnung" der TABU-Liste ist
fuer S0-S5 **nicht noetig**. Die Liste bleibt geschlossen; das Fenster kommt mit dem Uebernehmen bestehender
Registry-Namen und additiven Schema-Optionalitaeten aus. Das ist ein besseres Ergebnis als geplant und
sollte dem Owner so gemeldet werden. Geoeffnet wird ausschliesslich TABU-6, und ausschliesslich in S6.

---

## 5. ENTSCHEIDUNGS-VORLAGEN FUER DEN OWNER

> Verbose formuliert (Owner-Regel E-21: Rueckfragen ausformuliert, kein Kuerzel ohne Erklaerung).
> Kein `AskUserQuestion` -- Forks als Klartext.

### E-1: Der `search_algo`-Pin (BLOCKER -- die kanonische golden-XML ist heute nicht validierbar)

**Lage.** `experiment_golden_kern.xml:96` schreibt `allowed_variants="binary_search linear_search"`.
Diese zwei Namen existieren in der ce-Registry **nicht**. `search_algo` (Slot T00) fuehrt genau vier
Bausteine: `k_ary`, `interpolation`, `eytzinger`, `linear_scan` (`cache_engine_axis_registry.xml:10-13`).
`binary_search` gibt es nur als `binary_search_fanout` -- und das ist ein Baustein der **anderen** Achse
`cache_traversal` (`:15ff`). Der Validator lehnt die Datei hart ab (`validate_profile.hpp:1249-1258`).
Das muss so oder so bewegt werden; die Frage ist **wohin**.

| Option | Was passiert | Konsequenz je Traeger |
|---|---|---|
| **A: `k_ary interpolation`** (= wt-b14-Entwurf) | Uebernimmt exakt das, was der Schwester-Traeger schon sagt (`all_axes_golden.profile.xml:36`). Es ist die "erste 2 Enabled-`name()`"-Semantik, an der der ganze golden-Raum definiert ist. | `experiment_golden_kern.xml`: heilt. `all_axes_golden.profile.xml`: **unberuehrt**. `kNewGolden131072Crc64`: **unberuehrt**. `golden_fullpilot_320*`: unberuehrt. Registry: unberuehrt. Bau-Matrix: unveraendert. `test_golden_n_consistency` wird sofort gruen. |
| **B: `k_ary linear_scan`** (= die semantische Absicht hinter den alten Platzhaltern: "binaere Suche" = `k_ary` mit k=2, "lineare Suche" = `linear_scan`) | Waere inhaltlich das ehrlichere Paar -- aber es ist ein **anderer golden-Raum**. | **BEIDE Traeger muessen bewegt werden**, sonst widersprechen sie sich. `all_axes_golden.profile.xml:36` gilt laut `experiment_golden_kern.xml:21` als "unangetastet" -- diese Zusage faellt. Weil der Raum als "erste 2 Enabled" definiert ist, muesste zusaetzlich die **Registry-Reihenfolge** (`cache_engine_axis_registry.xml:10-13`) `interpolation` und `linear_scan` tauschen -> **TABU-5 geoeffnet** -> `FullSourceCatalog`-ids aendern sich -> **`kNewGolden131072Crc64` bricht** -> Re-Anker an zwei Stellen (A5-Verfahren) -> `test_e24_c10_g6_identitaets_bilanz` neu, alle vorhandenen Mess-Archive nicht mehr direkt vergleichbar. |
| **C: alle vier Werte auf `search_algo`** | Die Achse voll sweepen. | Produkt wird `4 * 2^16` statt `2^17` -> `cap="131072"` waere falsch, `test_golden_n_consistency` rot, `static_assert(catalog_axis_product<FullSourceCatalog>() == 131072)` (`source_catalog.hpp:169-171`) bricht den Compile. Nur mit vollem Katalog-Umbau machbar. |

**EMPFEHLUNG: A.** Sie ist die einzige, die den Blocker heilt **ohne** einen einzigen TABU-Posten zu oeffnen
und ohne die vorhandenen Messdaten zu entwerten. Die semantische Absicht hinter B geht nicht verloren -- sie
wird im Datei-Kopf festgehalten ("binary search" = `k_ary`, "linear search" = `linear_scan`) und bleibt als
Nach-Abgabe-Posten offen. B ist ein eigenes ABI-/CRC-Fenster, kein Zwei-Tage-Vorgang.

### E-2: Das Alignment bei `line_size = 32`

**Lage, in Worten.** Die Cache-Line-Unterachse soll vier Werte bauen: 32/64/128/256. An der Scan-Stelle mit
Record-Groesse 48 gilt `round_up(48, 32) = 64` -- der **Schritt** (Stride) ist bei 32 und 64 also derselbe.
Der Unterschied liegt woanders: im **Alignment der Speicher-Anforderung**. Heute ist beides hart 64:
`scan_field_sum` hat `constexpr std::size_t kCacheLine = 64` (`ce/libs/cache_engine/axes/layout/axis_05_memory_layout_cache_line_aligned.hpp:60`),
und `abi_adapter.hpp` fordert dreimal `allocate(kLbufBytes, 64)` (`:464`, `:563`, `:694`) und gibt dreimal mit 64 frei
(`:528`, `:606`, `:913`). Wenn die Achse das Alignment steuern soll, sinkt es bei `line_size=32` auf 32.

| Option | Was gemessen wird | Konsequenz |
|---|---|---|
| **A: Stride aus der Achse ableiten, Alignment bleibt >= 64** (`max(line_bytes, 64)`) | `line_size` 32 und 64 sind messtechnisch **identisch** -- eine dokumentierte Aequivalenzklasse `{32,64} -> 64`, `128 -> 128`, `256 -> 256`. | Sicher: keine Unter-Alignierung, kein stiller Bruch bei Code, der 64 voraussetzt. Preis: 2 der 4 KF-6-Zellen sind messtechnisch entartet -- die Bau-Matrix waechst um Faktor 4, der Erkenntnisgewinn um Faktor 3. Das ist in der Arbeit als Aequivalenzklasse **sauber darstellbar**, nicht als Defekt. |
| **B: Alignment folgt strikt der Achse** (32 bei `line_size=32`) | `line_size=32` wird echt unterscheidbar: der Puffer kann auf einer 64-Byte-Linie **gespalten** liegen -- Split-Line-Zugriffe sind genau der Effekt, den eine Cache-Line-Achse messen soll. | Hoechste Mess-Validitaet. Risiko: **jeder** Konsument, der stillschweigend 64-Alignment annimmt, bricht lautlos. Codex hat genau hier schon zugeschlagen ("Forwarding heilt nur EINE Huelle, jeder weitere Wrapper faellt lautlos auf 64", Ledger `:4207`). Erfordert den vollstaendigen Wrapper-Audit **vorher**, nicht nachher. |
| **C: `line_size=32` aus dem golden-Satz streichen** (nur 64/128/256) | Bau-Matrix Faktor 3 statt 4, keine entartete Zelle. | Widerspricht der Owner-A4-Vorgabe verbatim ("es muessen dennoch alle unterstuetzt sein, sofern von der Hardware freigegeben"). |

**EMPFEHLUNG: A fuer dieses Fenster, B als registrierter Nach-Abgabe-Posten.**
Begruendung ohne Beschoenigung: B ist die inhaltlich richtige Antwort, aber B setzt den vollstaendigen
Wrapper-Audit voraus, und der laeuft gerade erst an (B14-NB3 ce-Phase, Ledger `:4206`). Zwei Tage vor der
Abgabe ein Alignment abzusenken, dessen Konsumenten noch nicht vollstaendig kartiert sind, ist genau die Art
stiller Bruch, die spaeter als Mess-Fehler auftaucht. A ist ehrlich darstellbar; die Aequivalenzklasse
`{32,64} -> 64` ist ein **Ergebnis**, kein Versaeumnis -- sie folgt aus `round_up(48,32)=64` und laesst sich
in der Arbeit in zwei Saetzen begruenden. Bei B waere die Alternative, sie unbegruendet zu behaupten.

### E-3: Der Umfang der XSD-Erweiterung

**Lage.** `super/Code/test_data_xml/experiment_schema.xsd` kennt heute keinen Kanal fuer `run_options`
(das maschinenlesbare N) und keinen fuer `organ_subaxes` (die Organ-Sub-Achsen). `grep organ_subaxes|run_options`
liefert 0 Treffer. Beides fehlt **nur** im `comdare_experiment`-Dialekt; der `comdare_thesis_profile`-Dialekt
hat beides seit langem.

| Option | Umfang | Konsequenz |
|---|---|---|
| **A: minimal -- nur `run_options`** | +1 Element, +1 `complexType` (`cap` required, Rest optional). | N wird maschinenlesbar, `test_golden_n_consistency` kann arbeiten. Aber `organ_subaxes` bleibt unausdrueckbar -> die KF-6-`line_size`-Deklaration ist im **kanonischen** Traeger strukturell nicht moeglich -> Owner-A4 bleibt unerfuellt und muss in einem zweiten Schema-Fenster nachgeholt werden. |
| **B: Entwurfs-Umfang -- `run_options` + `organ_subaxes` mit allen drei Sub-Achsen-Gruppen** (`cacheline`, `node_width`, `alloc_hw`), Vokabular **zeichengleich** zum thesis-Dialekt, alles `minOccurs="0"` | ca. +100 Zeilen XSD (der wt-b14-Entwurf liegt fertig vor). Nur `cacheline` wird tatsaechlich belegt; die anderen zwei sind leere, dokumentierte Kanaele. | Rueckwaerts-neutral (alle Bestands-Instanzen validieren weiter). Die spaetere Parser-Naht bleibt **EINE** Lese-Funktion -- kein zweites Namens-System. Der Code fuehrt die drei ohnehin als **eine** Gruppe (`parse_thesis_profile`, `profile_to_tree.hpp:82-97`, `resolve_axis_refs_against_trio`); ein Einzel-Zuschnitt nur auf `cacheline` waere ein willkuerlicher Schnitt. |
| **C: maximal -- zusaetzlich `xs:enumeration` auf die Wertraeume** (`line_size` auf 32/64/128/256 festnageln) | XSD wird zur Wertraum-Autoritaet. | **Abzulehnen.** Die Wertraum-Autoritaet ist der Code (`cacheline_config.hpp`: `CacheLineSize{B32,B64,B128,B256}` x `CacheLineAlignment{none,cache_line_aligned,padded}` x `SwPrefetchHint{none,T0,T1,T2,NTA}` = 60). Eine Enumeration im Schema erzeugt eine zweite Quelle, die bei jeder additiven Wertraum-Erweiterung bricht -- gegen die Single-Source-Doktrin. `xs:string` (wie bei `numa_node`/`page` unter `target_isa`) ist hier die richtige Wahl. |

**EMPFEHLUNG: B.** Sie erfuellt den F5-Auftrag ("Syntax und Semantik der XML wenn notwendig") vollstaendig,
in **einem** Schnitt statt in zweien, bleibt rueckwaerts-neutral, und der Entwurf existiert bereits. Sie
kostet keine Laufzeit-Aenderung, weil der Parser den Block bis S4 nicht liest.

### E-4: Der binary_id-Grammatik-Bruch beim `line_size`-Konsum (S6) -- **NEUER PUNKT**

**Lage, in Worten.** Sobald der Planer `organ_subaxes` wirklich **liest** und `cacheline` konsumiert,
entsteht laut `profile_to_tree.hpp:82-86` eine statische Ebene, und die erzeugten binary_ids tragen ein
zusaetzliches Segment `cacheline.line_size=<n>`. Die vorhandenen Mess-Archive (z.B.
`20260726-164259-d03-strukt-r-erstbeleg/measurements.csv`) tragen **18** Segmente ohne `cacheline`.
Ab dem Konsum ist **kein Zeilen-Join alt-gegen-neu ueber die rohe binary_id mehr moeglich**.
Das ist der einzige TABU-Kontakt des Fensters.

| Option | Konsequenz |
|---|---|
| **A: S6 hinter die Abgabe legen** (Plan-Vorschlag) | Die Abgabe-Kette bleibt auf der 18-Segment-Grammatik; alle vorhandenen Messdaten bleiben roh joinbar. `organ_subaxes` steht als **Deklaration** in der kanonischen XML (A4 dokumentarisch erfuellt), wirkt aber nicht. Preis: die KF-6-Line-Size-Messung ist zur Abgabe nicht gefahren. |
| **B: S6 vor der Abgabe, mit Projektions-Regel** | Vergleiche laufen ueber eine Projektion auf die 18 Organ-Segmente, `cacheline` wird gesondert behandelt. Preis: die Bau-Matrix vervierfacht sich (4 x 2^17 = 524288 Tier-Binaries, mit System-Block 4 x 4 x 2^17 = 2097152) -- das ist zwei Tage vor der Abgabe kein realistischer Voll-Bau. |
| **C: S6 vor der Abgabe, aber `line_size` auf den Default-Wert 64 beschraenkt** | Grammatik bricht trotzdem (das Segment kommt an, auch mit einem Wert), Bau-Matrix aber unveraendert. Schlechteste Kombination: Bruch ohne Erkenntnisgewinn. |

**EMPFEHLUNG: A.** B ist rechnerisch nicht in zwei Tagen zu bauen, C bricht ohne Gegenwert.

### E-5: `compiler/atomic128` in der golden-Instanz

**Lage.** Der Kanal existiert im Schema (`experiment_schema.xsd:355-375`) und im Parser
(`xml_config_parser.cpp:111`), Werte `no_cx16|cx16`. Die golden-Instanz laesst ihn leer. Es gibt **keinen
Ist-Beleg**, welcher der beiden Werte die golden-Baseline ist.

| Option | Konsequenz |
|---|---|
| **A: leer lassen** (= CEB-Default), im Kopf ausdruecklich begruenden statt still auslassen | Bau-Matrix unveraendert. Der Kanal ist als "bewusst ungesetzt" dokumentiert, nicht als "vergessen". |
| **B: auf einen Wert pinnen** | Setzt einen Beleg voraus, den es nicht gibt -- ein geratener Wert ist eine erfundene Baseline. |
| **C: beide Werte deklarieren** | **Verdoppelt die Bau-Matrix** ohne inhaltliche Deckung. |

**EMPFEHLUNG: A.** Das ist auch die Wahl des wt-b14-Entwurfs, und sie ist dort korrekt begruendet.

---

## 6. SCHRITTE, GATES, ABBRUCH-KLAUSELN

> Die Gate-Formulierungen sind **woertlich uebernehmbar** in Wellen-Auftraege.
> Doktrin: kein Erfolgsvermerk ohne **literale** Werkzeug-Ausgabe (`feedback_no_success_marks_without_literal_output.md`).
> 2-Pass-Configure heisst `configure -> BAU -> configure`; die Bestandszahl ist literal zu pruefen (Ledger `:4207`: 404 != 408).

### S0 -- Entsperrung des Worktrees

**Tun:** In `/home/comdare/wt-b14-golden`: `git fetch` + **`merge`** von `development` (NIE `rebase`,
`feedback_nie_rebase_immer_merge.md`). ce-Submodul-Zeiger von `7969b399` auf den gelandeten `3bbcb8ed` ziehen.

**GATE S0:**
> "Merge ist konfliktfrei abgeschlossen (literal: `git log --oneline -1` zeigt den Merge-Commit).
> `git -C Code/external/comdare-cache-engine rev-parse HEAD` liefert **`3bbcb8ed`** oder einen **Nachfahren** davon --
> literal ausgeben. `git merge-base --is-ancestor 3bbcb8ed <ce-HEAD>` liefert RC=0.
> Kein `git status` zeigt eine Submodul-Ruecksetzung."

**STOPP:** Wenn der Merge Konflikte in `experiment_golden_kern.xml`, `experiment_schema.xsd` oder
`Code/tests/CMakeLists.txt` erzeugt -> **anhalten und dem Lead melden**, nicht aufloesen. Diese drei Dateien
haben parallel laufende Schreiber (Abschnitt 1.4).

**Aufwand:** S (< 30 min). **Risiko:** niedrig, aber blockierend fuer alles.

### S1 -- Wach-Fundament: xmllint statt Regex-Lexer

**Eigentuemer: Welle B14-NB3 `wf_afd2df95`, super-Phase.** F5 liefert die Leitplanke, baut hier nicht selbst.

**Tun:** Die Regex-Lexer-Passagen in `fixture_schema_subset_check.cmake` und `golden_n_consistency_check.cmake`
durch `xmllint`-Aufrufe ersetzen (`--noent` fuer Entity-Expansion, `--schema` fuer die Struktur-Pruefung,
`--xpath` fuer die Extraktion). Verfuegbarkeit ist geprueft: `/usr/bin/xmllint`, libxml `20914`, Feature `Schemas`.

**GATE S1:**
> "Alle vier Codex-SUPER-HOCH sind am **Objekt reproduziert und danach widerlegt**, jeweils mit literaler Ausgabe:
> (a) `<![CDATA[]]>` innerhalb eines XML-Kommentars -- alt: falscher Schnitt, neu: korrekt;
> (b) ein entity-erzeugtes Element -- alt: unsichtbar, neu: sichtbar (`--noent`);
> (c) ein Element mit Nicht-ASCII-Startzeichen -- alt: uebersehen, neu: erfasst;
> (d) eine Fehlverschachtelung bzw. ein dupliziertes Attribut -- alt: gruen, neu: **FATAL**.
> Zusaetzlich: `xmllint --noout --schema experiment_schema.xsd <jede Instanz in Code/test_data_xml/>` RC=0 fuer **alle** Instanzen.
> Falls `xmllint` in einer CI-Umgebung fehlt: der Test SKIPt sauber ueber `SKIP_REGULAR_EXPRESSION` und **verschweigt das nicht** --
> ein stiller Ausfall der Wache ist ein Fehlschlag dieses Gates."

**STOPP:** Wenn `xmllint` die vier Punkte **nicht** alle abdeckt -> anhalten, **kein** Rueckfall auf Regex-Pflaster,
Rueckfrage an den Owner. (Regex ist die Wurzel aller vier Befunde; vier Pflaster heilen sie nicht --
`feedback_no_quick_fixes.md`.)

**Aufwand:** M. **Risiko:** mittel -- CI-Verfuegbarkeit von `xmllint` ist auf **allen 8 Docker-Distros** zu belegen,
nicht nur lokal (`feedback_build_matrix_8_docker_distros_full_platform_doctrine.md`).

### S2 -- Vokabular: XSD additiv erweitern

**Tun:** Gemaess Owner-Entscheid **E-3**. Der Entwurf liegt in `wt-b14/Code/test_data_xml/experiment_schema.xsd`
(`RunOptionsType`, `OrganSubAxesType`, beide Wurzel-Elemente `minOccurs="0"`).

**GATE S2:**
> "(1) `xmllint --noout --schema Code/test_data_xml/experiment_schema.xsd <F>` liefert RC=0 fuer **jede** `.xml` unter
> `Code/test_data_xml/` -- Liste literal ausgeben, keine Datei auslassen (Rueckwaerts-Neutralitaets-Beweis).
> (2) Die Attribut- und Element-Namen der neuen Typen sind **zeichengleich** zum thesis-Dialekt --
> literal gegen `ce/.../xml_config_parser.cpp:425-432` (`ThesisRunOptions`) und gegen
> `ce/.../all_axes_golden.profile.xml:163` diffen, Ausgabe zeigen.
> (3) Kein bestehendes Element wurde geaendert: `git diff` auf die XSD zeigt **ausschliesslich** Hinzufuegungen (`+`-Zeilen) --
> `git diff --numstat` literal ausgeben, die Loeschzahl muss 0 sein.
> (4) ASCII-Selbstcheck aus dem Diff: 0 Nicht-ASCII-Zeichen in neuen Kommentaren."

**STOPP:** Wenn `git diff --numstat` eine Loeschzahl > 0 zeigt -> anhalten. Die Erweiterung ist per Definition additiv.

**Aufwand:** S (Entwurf liegt vor). **Risiko:** niedrig.

### S3 -- Instanz: `experiment_golden_kern.xml` nachziehen

**Tun:** G1 (Pin-Fix nach **E-1**), G2 (18 Achsen mit expliziten `allowed_variants`, Produkt 2^17, plus
`<run_options cap="131072"/>`), G3 (F-3-Regression: `:136-140` drei Combos -> **eine** Vollmengen-Combo,
deckungsgleich zu `all_axes_golden.profile.xml:225`), G4 (`target_isa` mit `x86_64`; `atomic128` nach **E-5**
leer **mit begruendendem Kommentar**), `<organ_subaxes>` mit `line_size` 32/64/128/256 nach **E-3 B**.

**GATE S3:**
> "(1) `xmllint --noout --schema Code/test_data_xml/experiment_schema.xsd Code/test_data_xml/experiment_golden_kern.xml` RC=0.
> (2) Das **Produkt** der 18 `allowed_variants`-Listen ist literal nachgerechnet und ausgegeben: es muss **131072** sein
> und gleich dem `cap`-Attribut.
> (3) Jeder einzelne `allowed_variants`-Wert ist ein `baustein name` der ce-Registry
> (`ce/.../cache_engine_axis_registry.xml`) -- der Beleg ist ein **gruener Lauf von `validate_experiment_profile`**
> mit `r.ok == true` und `r.errors` leer, Ausgabe literal.
> (4) Die Achsen-Menge ist **deckungsgleich** zu `all_axes_golden.profile.xml` `<permute_axes>` -- 18 Achsen, je Achse dieselben Werte.
> (5) `git diff --exit-code -- Code/external/comdare-cache-engine/libs/cache_engine/algorithm_profiles/thesis_profiles/all_axes_golden.profile.xml`
> liefert **RC=0** -- der Schwester-Traeger wurde nur gelesen.
> (6) `git diff --exit-code -- Code/test_data_xml/experiment_golden.xml` liefert **RC=0** -- das Alt-Paar ist byte-unberuehrt.
> (7) TABU-Nicht-Beruehrungs-Beweis: `git diff --exit-code` RC=0 auf `permutation_axes.xml`, `m3v2_study.profile.xml`,
> `system_axis_registry.xml`, `cache_engine_axis_registry.xml`, `golden_fullpilot_320_binary_ids*.txt`, `axis_path_serialization.hpp`."

**STOPP:** Wenn (3) rot ist -> **nicht** die Registry anpassen, sondern die XML. Die Registry ist TABU-5.
Wenn (5) oder (6) rot ist -> sofort anhalten, additiv-daneben-Doktrin verletzt.

**Aufwand:** M (Entwurf liegt vor, aber nach E-1/E-3/E-5 nachzuziehen). **Risiko:** niedrig, sobald die Entscheide stehen.

### S3b -- ce-Naht-Fixture nachziehen (G8)

**Tun:** `ce/tests/unit/thesis_tiere/experiment_golden_kern.xml` um die neuen Kanaele erweitern -- **absichtlich
mit abweichenden Werten**, wie ihr eigener Kopf-Kommentar (`:2-10`) es fuer alle uebrigen Felder auch tut.
Sie ist **keine Kopie**. Neue Faelle in `test_experiment_kern_seam.cpp` **anhaengen**, die 15 bestehenden nicht umschreiben.

**GATE S3b:**
> "(1) Die Fixture validiert gegen die erweiterte XSD (`xmllint --noout --schema`, RC=0).
> (2) Die **15** bestehenden `TEST(`-Faelle sind unveraendert -- Namensliste vor/nach literal diffen, Differenz leer.
> (3) Die neuen Faelle sind rot gegen eine Fixture **ohne** die neuen Bloecke (Biss-Beweis, Ausgabe zeigen) und gruen mit.
> (4) **Kein** Byte-Sync-Test wurde fuer dieses Paar angelegt -- die Divergenz ist Absicht (`experiment_golden_kern.xml:2-10` in ce)."

**STOPP:** Wenn ein bestehender der 15 Faelle fallen muss -> **OWNER-ENTSCHEID**, einzeln vorlegen, nicht selbst entscheiden.

**Aufwand:** M. **Risiko:** mittel -- **Kollisionsgefahr mit F3/Scheibe-6** (Abschnitt 1.4). Reihenfolge: F5 inhaltlich zuerst.

### S4 -- Interpreter im Planer (ce)

**Tun:** `struct ExperimentProfile` (`xml_config_parser.hpp:441-473`) um `run_options` und `organ_subaxes`
erweitern; `parse_experiment_profile` (`xml_config_parser.cpp:454-558`) um die zwei `root->child(...)`-Glieder --
**Vokabular-gleich** zur thesis-Seite, damit die Lese-Logik geteilt wird statt dupliziert; `validate_experiment_profile`
um die passenden Pruefungen (mindestens: `cap` > 0; `cap` == Produkt der `allowed_variants`).

**GATE S4:**
> "(1) Ein Parser-Test liest `experiment_golden_kern.xml` und liefert `run_options.cap == 131072` und
> `organ_subaxes.cacheline.line_sizes == {32,64,128,256}` -- Werte literal ausgeben.
> (2) **Rueckwaerts-Neutralitaet:** eine Instanz **ohne** die zwei Bloecke parst weiterhin erfolgreich
> (`std::optional` hat einen Wert) und die neuen Felder sind leer/ungesetzt -- literal belegen.
> (3) Die Lese-Logik fuer `run_options` ist mit `parse_thesis_profile` (`xml_config_parser.cpp:425`) **geteilt**,
> nicht dupliziert -- die gemeinsame Funktion benennen.
> (4) **KEIN Konsum:** `profile_to_tree` erhaelt die Sub-Achsen in diesem Schritt **nicht**. Beweis: ein Lauf auf der
> neuen golden-XML liefert binary_ids mit **exakt 18** Segmenten, byte-gleich zur Archiv-Grammatik. Eine id literal ausgeben und zaehlen.
> (5) ce-Voll-Gate: 2-Pass-Configure (`configure -> BAU -> configure`), Bestandszahl literal, Doppellauf 2x seriell,
> `git diff --exit-code` auf `axis_path_serialization.hpp` RC=0."

**STOPP:** Wenn (4) mehr als 18 Segmente liefert -> **sofort anhalten**. Dann ist S6 versehentlich mitgelaufen und
TABU-6 ist ohne Owner-GO offen (E-4).

**Aufwand:** M-L. **Risiko:** mittel -- hier ist die Versuchung am groessten, "gleich mitzukonsumieren".
Gate (4) ist genau dagegen gebaut.

### S5 -- Wachen neu ankern (ZULETZT)

**Tun:** `test_fixture_schema_experiment_golden_kern` (A2) und `test_golden_n_consistency` (A3) im gelandeten
`super/Code/tests/CMakeLists.txt` registrieren, neben den beiden bestehenden (`:146`, `:151`).
Label `da_unit;fixture_sync`, `TIMEOUT 60`, `SKIP_REGULAR_EXPRESSION "FIXTURE-SYNC-SKIP"` -- Muster von `:156-158`.

**GATE S5:**
> "(1) `ctest -L fixture_sync` listet jetzt **vier** Tests statt zwei -- literal ausgeben.
> (2) **Biss-Beweis A2:** ein erfundenes Element in `experiment_golden_kern.xml` -> Test FATAL (Ausgabe zeigen);
> entfernen -> gruen (Ausgabe zeigen).
> (3) **Biss-Beweis A3, drei einzelne Verletzungen, jede fuer sich:**
> (a) eine Achse aus `axes_default_lookup` entfernen -> FATAL 'Achsen-Menge';
> (b) `interpolation` -> `eytzinger` -> FATAL 'Auspraegungs-Menge';
> (c) `cap="131072"` -> `cap="131071"` -> FATAL 'cap != Produkt'.
> Alle drei zuruecknehmen -> gruen. **Alle drei muessen gebissen haben**, sonst ist die Wache nicht abgenommen.
> (4) **A1 unberuehrt:** `test_fixture_sync_experiment_golden` gruen, `fixture_sync_check.cmake` `git diff --exit-code` RC=0.
> (5) super-Voll-Gate gruen mit literaler Bestandszahl; Pipeline hart gruen (`feedback_gesamte_pipeline_immer_hart_gruen.md`).
> (6) Der Nicht-Beruehrungs-Beweis aus S3 Gate (7) wird **wiederholt** und ist erneut RC=0."

**STOPP:** Wenn eine der drei A3-Verletzungen **nicht** beisst -> die Wache ist stumm und darf **nicht** landen.
Eine stumme Wache ist schlimmer als keine: sie erzeugt falsches Vertrauen
(`reference_drift_guard_faengt_anhaengen_nicht.md`).

**Aufwand:** M. **Risiko:** niedrig im Bau, **hoch im Wert** -- das ist der Schritt, der das Fenster beweisbar macht.

### S6 -- Semantischer Konsum `line_size` (NACH DER ABGABE, unter E-4)

**Tun:** `kLbufBytes` aus `line_bytes_of<Self>()` ableiten statt hart 64
(`abi_adapter.hpp` **drei** Pfade x **drei** Literale: `462/464/528`, `562/563/606`, `693/694/913`);
`scan_field_sum` an die Achse binden statt `kCacheLine=64`
(`axis_05_memory_layout_cache_line_aligned.hpp:60`); vollstaendiger Wrapper-Audit;
`catch(...) { return 0; }` durch RAII ersetzen (Codex-CE-MITTEL, Ledger `:4207`);
Instanziierungs-Tests fuer 32/128/256 ueber **alle drei** Pfade.
**Eigentuemer: Welle B14-NB3 `wf_afd2df95`, ce-Phase.**

**GATE S6:**
> "(1) `static_assert(kLbufBytes >= (kRecords-1) * kMaxStride + sizeof(std::uint32_t))` in **allen drei** Pfaden.
> (2) Instanziierungs-Tests fuer `line_size` 32/128/256 ueber alle drei Pfade, gruen, Ausgabe literal.
> (3) **Kein Leak:** RAII statt `catch(...) { return 0; }`, mit Sanitizer-Beleg.
> (4) `scan_field_sum` liefert bei `line_size=256` einen **anderen** Wert als bei 64 (Beweis, dass die Achse wirklich
> durchschlaegt und die Bindung nicht kosmetisch ist -- Muster der B14-Gegenprobe B256, Ledger `:4207`).
> (5) binary_id-Grammatik: die neue id traegt **19** Segmente; die Projektions-Regel auf die 18 Organ-Segmente ist
> implementiert **und** ein Skript beweist, dass der **rohe** Join alt-gegen-neu fehlschlaegt (negativer Beweis)."

**STOPP:** Ohne expliziten Owner-GO zu **E-4** wird dieser Schritt **nicht** begonnen. Er oeffnet TABU-6.

**Aufwand:** L. **Risiko:** hoch.

### S7 -- Aufraeumpass (unter Absprache)

Alt-Paar `experiment_golden.xml` umhaengen bzw. deprecaten, `02_messung_driver` auf den Neu-Traeger ziehen,
Doppelung der Text-Helfer in den zwei `.cmake`-Wachen in ein `xml_text_utils.cmake` zusammenfuehren
(als Sektion-75-Kandidat bereits im Kopf von `golden_n_consistency_check.cmake:33-35` notiert).
**Gehoert zu F3/Scheibe-6 und zum Abschluss-Aufraeumpass**
(`feedback_abschluss_aufraeumpass_deprecated_code_entfernen.md`). Doku wird **nie geloescht**, nur deprecatet.

---

## 7. AUFWAND UND RISIKO -- UEBERSICHT

| Schritt | Aufwand | Risiko | Hauptrisiko in einem Satz |
|---|---|---|---|
| S0 Entsperrung | S | niedrig | Merge-Konflikt in den drei Mehr-Schreiber-Dateien. |
| S1 xmllint-Fundament | M | **mittel** | `xmllint` muss auf **allen 8 Docker-Distros** da sein, nicht nur lokal. |
| S2 XSD additiv | S | niedrig | Praktisch keins -- `minOccurs="0"` ist per Konstruktion neutral. |
| S3 Instanz | M | niedrig | Rechenfehler beim 2^17-Produkt; Gate (2) faengt ihn. |
| S3b ce-Fixture | M | **mittel** | Kollision mit F3/Scheibe-6 an derselben Datei. |
| S4 Interpreter | M-L | **mittel** | Versehentlicher Mitkonsum -> TABU-6 offen; Gate (4) faengt ihn. |
| S5 Wachen ankern | M | niedrig (Bau) | Eine stumme Wache landet -- der Drei-fach-Biss faengt es. |
| S6 Konsum | L | **hoch** | binary_id-Grammatik bricht; Mess-Archive nicht mehr roh joinbar. |
| S7 Aufraeumen | M | niedrig | Wache wird durch die Umhaengung stumm (die Kern-Risikofrage von F3). |

---

## 8. EHRLICHE EINORDNUNG: VOR ODER NACH DER ABGABE (Fr 08.08.)

Rest-Budget zum Trigger-Ziel **Do 07.08.**: knapp ein Tag. Zur Abgabe **Fr 08.08.**: knapp zwei.
Parallel laufen sechs Wellen (Ledger `:4206`), die Landebahn ist **seriell** und beim Lead.

### VOR DER ABGABE -- realistisch

| Schritt | Warum realistisch |
|---|---|
| **S0** | Mechanisch, unter 30 Minuten, blockiert alles andere. |
| **S2 (XSD)** | Der Entwurf liegt fertig; nach E-3 ist es ein Uebernehmen mit Gate. |
| **S3 (Instanz)** | Der Entwurf liegt fertig; nach E-1/E-5 ein Nachziehen. **Muss** vor der Abgabe, weil `experiment_golden_kern.xml` heute **den Validator nicht besteht** (G1) und sie die Trigger-Input-Basis ist. |
| **S5 (Wachen)** | Der Bau liegt fertig; es fehlt das S1-Fundament und der Biss-Beweis. |

### VOR DER ABGABE -- **nur wenn S1 sauber durchkommt**

| Schritt | Bedingung |
|---|---|
| **S1 (xmllint)** | Haengt daran, ob `xmllint` auf allen 8 Distros verfuegbar ist. **Rueckfall-Plan, falls nicht: S5 landet ohne A2, nur mit A3.** A3 (`golden_n_consistency`) ist ein **Werte-Vergleich**, kein Vokabular-Lexer -- ihre Regex-Abhaengigkeit ist erheblich kleiner. A2 (Vokabular-Teilmenge) ist die mit den vier Codex-Lueckern. **Ohne S1 laesst man A2 lieber ungelandet, als sie stumm zu landen.** |
| **S3b (ce-Fixture)** | Nur wenn F3/Scheibe-6 bis dahin **nicht** angelaufen ist. Sonst nach der Abgabe, zusammen mit F3. |
| **S4 (Interpreter)** | **Grenzfall.** Ehrlich: es ist eine ce-Aenderung mit Voll-Gate (2-Pass-Configure, Doppellauf) und der ce-Slot ist belegt. Der **Owner-Auftrag F5 nennt den Interpreter ausdruecklich** -- aber er ist zur Abgabe **nicht funktional noetig**: bis S6 ist der gelesene Wert ohnehin ungenutzt. **Empfehlung: versuchen, aber nicht erzwingen.** Faellt S4 aus, ist der Zustand trotzdem konsistent und ehrlich beschreibbar: das Vokabular steht, die Instanz ist vollstaendig und validierbar, der Lese-Kanal ist als dokumentierte Auflage offen. Das ist ein **sauberer** Teilstand, kein halber. |

### NACH DER ABGABE -- ausdruecklich

| Schritt | Warum |
|---|---|
| **S6 (Konsum)** | Bricht die binary_id-Grammatik (E-4) und vervierfacht die Bau-Matrix auf 2097152 Tier-Binaries. In zwei Tagen weder baubar noch verantwortbar. |
| **S7 (Aufraeumpass)** | Doktrin: Aufraeumen unter Absprache, am Ende. |
| **E-1 Option B** (falls der Owner sie doch will) | Oeffnet TABU-5, bricht `kNewGolden131072Crc64`, entwertet die Archiv-Vergleichbarkeit. Eigenes ABI-Fenster. |
| **E-2 Option B** (Alignment folgt der Achse) | Setzt den vollstaendigen Wrapper-Audit voraus. |
| **Codegen-NTTP-Emission der Line-Groessen** | Haengt an S6. |

### Der ehrliche Satz zum Schluss

Was zur Abgabe **steht**, wenn S0/S2/S3/S5 durchlaufen: die kanonische Trigger-Input-Basis ist zum ersten Mal
**validierbar** (heute ist sie es nicht), ihr N ist **maschinenlesbar** (heute nur Fliesstext), sie ist
**deckungsgleich** zum Schwester-Traeger (heute widerspricht sie ihm rechnerisch um zehn Groessenordnungen),
und diese Deckung ist **bewacht** statt behauptet. Kein einziger TABU-Posten wurde dafuer geoeffnet, kein
Anker neu gesetzt, kein Messdatum entwertet.

Was **nicht** steht: `line_size` wirkt nicht. Der KF-6-Vollausbau ist zur Abgabe eine **Deklaration**, keine
Messung. Das ist so zu benennen und nicht zu beschoenigen.

---

## 9. OFFENE VERIFIKATIONS-PUNKTE (vor Baubeginn zu schliessen)

1. **Emissionsweg des `cacheline`-Segments.** `serialize_composition_path` emittiert 18 Segmente aus
   `kCompositionAxisNames` (`axis_path_serialization.hpp:40,62-64`); `cacheline` steht dort nicht.
   Der wt-b14-Vermerk behauptet dennoch ein zusaetzliches Segment. **Die Emissionsstelle ist vor S6 am Objekt
   zu belegen** (Verdacht: `with_shape_segment`, ebd. `:94-103`). Solange sie nicht belegt ist, ist die
   Faktor-4-Rechnung eine plausible Annahme, kein Beweis.
2. **`xmllint` auf allen 8 Docker-Distros.** Lokal geprueft (libxml `20914`, Feature `Schemas`).
   CI-seitig **ungeprueft** -- entscheidet ueber S1 (s. Abschnitt 8).
3. **Ledger-Zahl `:4385` sagt "12" Naht-Tests, der Ist ist 15.** Beim Abschluss mitziehen.
4. **Codex-Befunde generell.** Codex lief in einer Sandbox **ohne Tool-Zugriff** (bwrap-Loopback-Fehler,
   Ledger `:4207`) -- reine Inline-Diff-Lesung. Jeder Befund ist vor der Umsetzung am Objekt zu reproduzieren.
   Das gilt fuer alle vier SUPER-HOCH in S1 und ist dort als Gate formuliert.

---

*Erstellt 2026-08-06 als Phase 2 von `wf_6a3096f7`. Ist-Anker: super `161247c5`, ce `3bbcb8ed`, wt-b14 `953ce412`.
Kein Code gebaut, kein Commit gesetzt.*
