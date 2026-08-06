# PLAN 06.08.2026 -- SCHEIBE 6 / WEG A: Entflechtung der gleichnamigen ce-Fixture

> OWNER-ENTSCHEID F3 VERBATIM (Ledger vormittag-50, DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md:4225):
> "F3: Bitte sauber die fixture nachziehen und am besten nochmal gruendlich planen."
>
> STATUS DIESES DOKUMENTS: PLANUNG. Kein Bau, kein Commit, keine Umbenennung vollzogen.
> Alle Aussagen unten sind am Objekt erhoben (Datei:Zeile), nicht aus dem Ledger uebernommen.

---

## 0. IST-ERHEBUNG AM OBJEKT (Grundlage; Abweichungen zum Ledger explizit markiert)

### 0.1 Die zwei gleichnamigen Dateien

| Rolle | Pfad | Zeilen | Kopf-Selbstaussage |
|---|---|---|---|
| MASTER (kanonisch seit 27.07.) | `Code/test_data_xml/experiment_golden_kern.xml` | 172 | `:3-4` "experiment_golden_kern.xml / KANONISCH AB #48. Jede Schema-Evolution zuerst HIER (STETS gepflegt)." |
| ce-FIXTURE (test-lokal) | `Code/external/comdare-cache-engine/tests/unit/thesis_tiere/experiment_golden_kern.xml` | 77 | `:2-4` "KERN #48-S4 TEST-FIXTURE (ce-lokal, 2026-07-22). Spiegelt die KERN-Elemente ... (KEIN Sync-Gate; rein test-lokal)." |

Die ce-Datei ist also KEINE Kopie und war nie als solche deklariert. Sie ist eine eigenstaendige
Parser-/Validator-Naht-Fixture, die ausdruecklich MEHR und ANDERES traegt als der Master
(`:4-5`: "BEWUSST valide (validate_experiment_profile ok=true ohne registry_dir): sie ergaenzt die fuer
die Validierung erforderlichen Felder ... ueber die reine Struktur-Referenz hinaus").

### 0.2 Jede absichtliche Divergenz mit Zweck (am Objekt, beide Dateien gelesen)

| # | Stelle ce-Fixture | Wert ce | Wert MASTER | Zweck der Divergenz |
|---|---|---|---|---|
| D1 | `:11` / `:16` id + metadata/name | `diplomarbeit_golden_kern_fixture` | `diplomarbeit_golden_kern` (`:22`/`:27`) | Selbst-Kennzeichnung als Fixture. Von KEINEM Test asserted (gepr[ueft: `test_experiment_kern_seam.cpp` enthaelt keine Assertion auf `ep->id` / metadata). |
| D2 | `:31-35` `<lebewesen>` | 3 Tiere (prt_art, art, hot) | 7 Tiere (`:54-62`) | Minimalmenge, die `phase@pruefling="prt_art"` aufloesbar macht. Groesse ist nicht asserted, aber `validate` braucht die Aufloesung. |
| D3 | `:45` `axis ref="search_algo"` | `pruefling="ee_prt"` | `pruefling="prt_art"` (`:98`) | ce uebt den ENGINE-id-Zweig des pruefling-Aufloesers; der Master den LEBEWESEN-id-Zweig. Literal asserted: `test_experiment_kern_seam.cpp:180`. |
| D4 | `:46` `axis ref="path_compression"` | `merge="fulljoin"` | `merge="merge"` (`:99`) | ce ist der EINZIGE Ort, an dem der dritte merge-Token `fulljoin` samt Phase-3-Bindungs-Regel positiv durchlaeuft. Literal asserted: `:184`. |
| D5 | `:47` dritte Achse `mapping` | `pruefling="self" merge="merge"` | existiert im Master NICHT | ce uebt den self-Marker-Zweig (CacheEngine). Literal asserted: `:185-186`; Zaehler `axis_pruefling_checked==3` `:214`. |
| D6 | `:70` `<storage>` | `backend="minio" endpoint="minio.comdare.local"` | `backend="local"` (ohne endpoint, `:166`) | ce uebt den minio-Zweig INKLUSIVE endpoint-Attribut; der Master den Default-Zweig. Literal asserted: `:192-193`. |
| D7 | fehlend in ce | -- | `<template>` `:35`, `<datasets>` `:131-135`, `<measurement_tooling>` `:139-143`, `<run_methodology>` `:151-153`, `<measurement_framework>` `:155`, `<writeback_methods>` `:158-162` | Die Fixture traegt bewusst NUR die vier #48-S4-Naht-Elemente plus das Validierungs-Minimum. Alles Weitere ist Master-Territorium. |
| D8 | ce traegt KEINE OS-Attribute an `<machine>` `:27-28` | -- | ebenfalls keine | Das ist eine ABSICHTLICHE Nicht-Deklaration und selbst ein Beweis: `test_experiment_kern_seam.cpp:159-173` (`MachinesWithoutOsExpectationStayEmpty`) haengt daran. Die Leere ist hier LOAD-BEARING. |
| D9 | ce traegt KEINE `ram_frequency_mhz` / `cas_latency_cl` `:27-28` | -- | ebenfalls keine | Gleiches Muster: `:104-111` asserted die 0-Marke ("NICHT-DEKLARIERT-Marke, nicht 0 MHz"). |

Byte-identisch zwischen beiden: `<execution_engines>`, `<machines>`-Werte, `<phases>`, `<system_axes>`,
`<workloads>`, `<op_types>`, die drei `<output>`-Pfade.

FOLGERUNG (bestaetigt): ein Byte-Sync-Gate ist auf diesem Paar strukturell unmoeglich. D3-D6 und D8/D9
sind nicht Drift, sondern der Testgegenstand.

### 0.3 Konsumenten -- vollstaendige Liste (grep ueber beide Repos, ohne build-Trees/Session-Backups)

**(a) Die Uebersetzungseinheit**
`Code/external/comdare-cache-engine/tests/unit/thesis_tiere/test_experiment_kern_seam.cpp` (290 Zeilen).

**LEDGER-KORREKTUR (wichtig, am Objekt gezaehlt):** die Ledger-Zeile
`DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md:4445` und der Kopf von
`fixture_schema_subset_check.cmake:8` sprechen von "12 hartverdrahteten Tests". Das Ist ist:
**15 TEST-Bloecke in der TU, davon lesen GENAU 6 die Fixture-Datei** (ueber `parse_kern()` `:39-42`).
Die anderen 9 bauen ihr `ExperimentProfile` in C++ (`make_base_ep()` `:46-57`) oder schreiben eine
Temp-XML (`parse_experiment_with_machines()` `:74-90`) und sind von der Umbenennung NICHT betroffen.
Die "12" ist also zu hoch gegriffen -- die Naht-Flaeche ist kleiner und schaerfer als angenommen.

Die 6 fixture-lesenden Tests, je mit der Naht, die sie beweist:

| # | TEST | Zeile | Bewiesene Naht | Fixture-Wert, an dem er haengt |
|---|---|---|---|---|
| T1 | `ParsesMachinesWithCoreIdentity` | `:93-112` | `<machines>`-Parser: Kern-Identitaet cpu_fabrication+ram_pair, hostname nur Hint; PLUS 0-Marke der zwei target_isa-Glieder | `:26-29` |
| T2 | `MachinesWithoutOsExpectationStayEmpty` | `:159-173` | A14/OS-U2 Byte-Identitaets-Zusicherung: 4 OS-Felder leer bei Nicht-Deklaration; + `machines_checked==2` | `:26-29` (Abwesenheit) |
| T3 | `ParsesAxisPrueflingAndFulljoinToken` | `:175-187` | `<axis pruefling=..>` alle DREI Aufloesungs-Zweige (engine-id / lebewesen-id / self) + merge-Token replace/fulljoin/merge | `:45-47` (D3, D4, D5) |
| T4 | `ParsesStorageSlot` | `:189-194` | `<output><storage backend endpoint>` inert-Slot, minio-Zweig mit endpoint | `:70` (D6) |
| T5 | `ParsesPhaseIdNamespace` | `:196-203` | `phase@id_namespace`: leer bei Stufe1, gesetzt bei Stufe2/Stufe3 | `:38-40` |
| T6 | `ValidatesOkWithNewCounters` | `:206-217` | validate ok==true + die 5 neuen Zaehler (machines 2 / storage 1 / axis_pruefling 3 / axis_merge 3 / id_namespace 2) | die ganze Datei |

**(b) Die CMake-Verdrahtung ce-seitig**
`Code/external/comdare-cache-engine/tests/unit/CMakeLists.txt:3316-3334`:
- `:3316` `comdare_add_test(test_experiment_kern_seam SOURCES thesis_tiere/test_experiment_kern_seam.cpp ...)`
- `:3333` `"COMDARE_EXPERIMENT_GOLDEN_KERN=\"${PROJECT_SOURCE_DIR}/tests/unit/thesis_tiere/experiment_golden_kern.xml\""`
- `:3334` `set_tests_properties(... LABELS "contract;profiles;e4;incd")`
- Vorspann-Kommentar `:3313-3315` ("ADDITIV: eigene Fixture experiment_golden_kern.xml + eigenes Source-File ... Fixture wird NUR GELESEN")

**(c) Die super-seitigen CMake-Wachen**

| Wache | Ort | Deckt | Beruehrt die ce-_kern-Fixture? |
|---|---|---|---|
| `fixture_sync_check.cmake` (Byte-Gate) | `Code/tests/fixture_sync_check.cmake:1-61`, registriert `Code/tests/CMakeLists.txt:147-158` | ALT-Paar `experiment_golden.xml` + `prt_art_axis_registry.xml` | NEIN. Zeigt ausschliesslich auf `experiment_golden.xml` (`:148`) bzw. die prt-Registry (`:153`). |
| `fixture_schema_subset_check.cmake` (Vokabular-Gate, Weg b) | **NUR in `wt-b14-golden`**, `Code/tests/fixture_schema_subset_check.cmake:1-335`, registriert `Code/tests/CMakeLists.txt:170-183` | NEU-Paar (`-DFIXTURE=...ce.../experiment_golden_kern.xml` `:174`) + zweites Bein auf dem Alt-Paar `:178-183` | JA -- das ist die einzige Wache, die den ce-Pfad literal nennt. |
| `golden_n_consistency_check.cmake` (Ketten-Gate, B14-NB2) | **NUR in `wt-b14-golden`**, registriert `Code/tests/CMakeLists.txt:192-196` | MASTER `experiment_golden_kern.xml` gegen ce `all_axes_golden.profile.xml` | NEIN (nur Master + Profil-Traeger). |

**LAGE-KORREKTUR:** Weg b ist **NICHT GELANDET**. `fixture_schema_subset_check.cmake` existiert
ausschliesslich im Worktree `/home/comdare/wt-b14-golden` (Branch `b14-golden-kf6` @ `953ce412`);
im `development`-Stand (`e75db8f9`) existiert die Datei nicht. Der Ledger-Stand mittag-1 fuehrt B14 als
**NICHT landefaehig (NB3 noetig)**. Das ist die harte Reihenfolge-Bedingung fuer alles Weitere (siehe 2.0).

**(d) Doku-Referenzen auf den ce-Pfad (kein Test, keine Wache -- reine Doku-Wahrheit)**
- `Code/external/comdare-cache-engine/libs/cache_engine/include/cache_engine/measurement/machine_identity.hpp:30`
  ("Beispiel-Deklaration: tests/unit/thesis_tiere/experiment_golden_kern.xml")
- ebenda `:211` ("Anwender-XML uebernommen (tests/unit/thesis_tiere/experiment_golden_kern.xml)")
- `.../measurement/target_isa_complex_axis.hpp:124` (nennt `experiment_golden_kern.xml` ohne Pfad -- heute
  nicht entscheidbar, welche der beiden Dateien gemeint ist; genau das Symptom des Namensproblems)
- `test_experiment_kern_seam.cpp:3` und `:30` (Kommentar + `#error`-Text)

**(e) Sonstige Leser: KEINE.** Kein `file(GLOB)` ueber `tests/unit/thesis_tiere/*.xml` (geprueft:
`tests/unit/CMakeLists.txt:11` und `:24` globben ausschliesslich Achsen-Verzeichnisse). Kein Treiber,
kein CI-Skript, keine `.gitlab-ci.yml`-Zeile nennt die Datei.

### 0.4 Das Namens-/Pfad-Problem -- warum es heute kollidiert

Es gibt **keine technische** Kollision: die zwei Dateien liegen in verschiedenen Repos und werden ueber
zwei verschiedene Compile-Defines/Variablen adressiert. Die Kollision ist eine **Bedeutungs-Kollision**
mit vier konkreten Schadensbildern, alle am Objekt belegbar:

1. **Der Dateiname luegt.** Die ce-Datei heisst wie die kanonische Instanz, ist aber weder Kopie noch
   kanonisch. Die Wahrheit steht nur im Kopf-Kommentar (`:2-4`) -- ein grep/ein Werkzeug/ein Reviewer
   sieht sie nicht. Genau das Muster, das der Audit als F27/TABU-11-Muster benennt
   (`docs/plaene/20260722-AUDIT-nacht-abweichungen-VERDIKT.md`, Befund C5).
2. **Referenzen werden mehrdeutig.** `target_isa_complex_axis.hpp:124` nennt den blossen Dateinamen --
   heute nicht aufloesbar. Dasselbe gilt fuer jede Ledger-/Plandoc-Zeile.
3. **Der falsche Reflex ist eingebaut.** Der naheliegende "Aufraeum-Unfall" ist, das Byte-Gate
   `fixture_sync_check.cmake` per zweiter `add_test`-Zeile auf das Neu-Paar umzuhaengen. Das schoesse
   T1-T6 sofort rot (D3-D6). Der Kopf von `fixture_schema_subset_check.cmake:4-11` beschreibt genau
   diesen Reflex als abgewehrt -- aber die Abwehr ist ein Kommentar, keine Struktur.
4. **Was bei einer Umbenennung bricht (vollstaendig, es ist wenig):**
   - `tests/unit/CMakeLists.txt:3333` -- Compile-Define zeigt ins Leere. **Bruchbild: LAUT.**
     `parse_kern()` `:41` liefert `nullopt`, alle 6 Tests scheitern an ihrem `ASSERT_TRUE(ep.has_value())`
     (`:95`, `:161`, `:177`, `:191`, `:198`, `:208`). Kein stilles Gruen ce-seitig.
   - `wt-b14-golden/Code/tests/CMakeLists.txt:174` -- `-DFIXTURE=` zeigt ins Leere.
     **Bruchbild: STUMM.** Siehe Risiko R1 -- das ist die eigentliche Gefahr dieses Pakets.
   - 4 Doku-Kommentare (0.3 d). **Bruchbild: STUMM** (keine Wache auf Doku-Pfade).
   - Nichts sonst.

### 0.5 Historie: Weg a / Weg b im Original

`docs/plaene/20260722-AUDIT-nacht-abweichungen-VERDIKT.md`, A-Liste, Befund C5 -- Wortlaut:

> **C5 ce-Fixture gleichnamig-divergent ohne Sync-Wache**: Deck = Dossier S4 ("eigene Testdatei, additiv")
> + transparenter Datei-Kopf ("KEIN Sync-Gate; rein test-lokal"); funktionale Divergenz gewollt (uebt
> fulljoin/minio/self). AUFLAGE Scheibe 6: umbenennen (z.B. experiment_kern_seam_fixture.xml) oder
> ctest-Wache "Fixture (Teilmenge von) Master-Schema" -- F27/TABU-11-Muster nicht stehen lassen.

Die zwei Wege waren also von Anfang an **ODER**-verknuepft, und der Rename kam mit einem konkreten
Namensvorschlag. Gebaut wurde Weg b (`fixture_schema_subset_check.cmake:13-18` dokumentiert die
Entscheidung und haelt Weg a ausdruecklich als offene ce-Auflage fest: "Der Rename ist ein ce-Commit und
faellt unter die Ein-Schreiber-Regel ... die Umbenennung bleibt als dokumentierte ce-Auflage offen").

Zwei weitere Auflagen aus derselben A-Liste, die formal in Scheibe 6 haengen (hier NICHT eingeplant,
aber benannt, damit sie nicht verloren gehen):
- **C4-Folge-TODO**: Positiv-Test `identity='CacheEngine'` (die Fixture waere sein natuerlicher Traeger).
- **C6**: `axes_default_lookup@enabled` Parser-Default `false` -- vor dem ersten Konsumenten drehen oder
  Attribut deprecaten.

---

## 1. ZIELBILD

### 1.1 Nachher-Zustand

| Datei | Pfad NACHHER | Aenderung |
|---|---|---|
| MASTER | `Code/test_data_xml/experiment_golden_kern.xml` | **UNVERAENDERT** (Name, Ort, Inhalt). Er ist der kanonische Traeger; er weicht nicht aus. |
| ce-Fixture | `Code/external/comdare-cache-engine/tests/unit/thesis_tiere/experiment_kern_seam_fixture.xml` | **NUR UMBENANNT** (`git mv`). Inhalt bleibt byte-identisch bis auf den erweiterten Kopf-Kommentar (1.3). |

Der Name folgt dem Vorschlag aus C5 und ist zugleich selbst-erklaerend: er traegt den Namen seiner
Uebersetzungseinheit (`test_experiment_kern_seam.cpp`) und das Wort `fixture`. Verzeichnis bleibt
`tests/unit/thesis_tiere/` -- dort liegen alle Test-XML der TU-Familie; ein Verschieben brauchte keinen
Zweck und wuerde nur zusaetzliche Pfad-Naht erzeugen.

Compile-Define: `COMDARE_EXPERIMENT_GOLDEN_KERN` -> `COMDARE_EXPERIMENT_KERN_SEAM_FIXTURE`.
Begruendung: das Define traegt heute das Wort "GOLDEN_KERN" und wuerde die Verwechslung sonst im
C++-Quelltext konservieren. Der `#error`-Text `:30` wird mitgezogen.

**INHALTS-ENTSCHEID (bewusst):** die Werte D1-D9 bleiben **unangetastet**. Weg a ist eine reine
Namens-/Plumbing-Operation. Jede Wert-Aenderung waere F5-Territorium (siehe 5.) und wuerde die
Beweisbarkeit dieses Pakets zerstoeren ("nur der Name hat sich bewegt" ist per `git diff -M` in einer
Zeile belegbar; sobald Inhalt mitwandert, ist es das nicht mehr).

**D1 (id/metadata) bleibt ebenfalls stehen** (`diplomarbeit_golden_kern_fixture`). Es ist die letzte
verbliebene "golden_kern"-Spur in der Fixture, aber sie ist hier ehrlich: sie sagt "abgeleitet von der
golden-kern-Struktur, aber Fixture". Keine Assertion haengt daran (am Objekt geprueft), also waere die
Aenderung risikolos -- aber sie waere auch grundlose Bewegung. NICHT aendern.

### 1.2 Kopf-Kommentar MASTER (nachher)

`Code/test_data_xml/experiment_golden_kern.xml:2-21` bleibt inhaltlich stehen und bekommt **einen
additiven Absatz** (die Doku-nie-loeschen-Doktrin gilt; nichts wird ersetzt):

> ABGRENZUNG (Scheibe 6 / Weg a, 2026-08-XX): diese Datei ist die KANONISCHE Instanz. Die ce-seitige
> Parser-/Validator-Naht-Fixture heisst seit der Entflechtung
> `tests/unit/thesis_tiere/experiment_kern_seam_fixture.xml` (frueher gleichnamig) und ist BEWUSST
> divergent -- sie uebt die Zweige, die diese Datei nicht traegt (pruefling=engine-id, merge=fulljoin,
> pruefling=self, storage backend=minio mit endpoint). Sie ist KEINE Kopie; ein Byte-Sync-Gate auf dem
> Paar waere falsch. Gemeinsame Wache ist das Vokabular gegen experiment_schema.xsd
> (`Code/tests/fixture_schema_subset_check.cmake`).

### 1.3 Kopf-Kommentar ce-Fixture (nachher)

`.../experiment_kern_seam_fixture.xml:2-10` behaelt seinen kompletten heutigen Text (er ist korrekt) und
bekommt **zwei additive Bloecke**: einen Umbenennungs-Vermerk und -- entscheidend -- die
**Divergenz-Tabelle als Doku IN der Datei**, damit die Absicht nicht mehr nur in einem Plandoc lebt:

> UMBENANNT 2026-08-XX (Scheibe 6 / Weg a, AUDIT-VERDIKT Befund C5): frueher
> `experiment_golden_kern.xml` -- gleichnamig mit der kanonischen super-Instanz
> `Code/test_data_xml/experiment_golden_kern.xml`, ohne Kopie zu sein. Der Name ist jetzt eindeutig.
>
> ABSICHTLICHE DIVERGENZ ZUM MASTER (KEIN Drift -- das ist der Testgegenstand; jede Zeile hat einen
> literalen Beleg in test_experiment_kern_seam.cpp):
>   - lebewesen: 3 statt 7 (Minimalmenge zur Aufloesung von phase@pruefling)
>   - axis search_algo pruefling="ee_prt" statt "prt_art" -> uebt den ENGINE-id-Zweig    [:180]
>   - axis path_compression merge="fulljoin" statt "merge" -> einziger Positiv-Lauf des
>     dritten Tokens samt Phase-3-Bindung                                                 [:184]
>   - dritte Achse mapping pruefling="self" -> uebt den self-Marker-Zweig                 [:185-186]
>   - storage backend="minio" endpoint=".." statt backend="local" -> uebt den
>     endpoint-tragenden Zweig                                                            [:192-193]
>   - KEINE OS-/RAM-Attribute an <machine>: die ABWESENHEIT ist load-bearing (Byte-
>     Identitaets-Zusicherung additiver Attribute)                                        [:104-111, :159-173]
> WER DIESE WERTE AN DEN MASTER ANGLEICHT, LOESCHT DIE BEWEISE. Schema-Evolution dagegen MUSS
> nachgezogen werden: beide Dateien werden gegen dasselbe experiment_schema.xsd auf Vokabular geprueft
> (super Code/tests/fixture_schema_subset_check.cmake).

Damit ist die Owner-Auflage "die absichtliche Divergenz muss DOKUMENTIERT bleiben, nicht verschwinden"
nicht nur erfuellt, sondern **verstaerkt**: sie steht nachher in der Datei selbst, nicht in einem Ledger.

### 1.4 Wachen-Zielbild

| Wache | nachher |
|---|---|
| `fixture_sync_check.cmake` + seine 2 `add_test` | **BLEIBT UNVERAENDERT UND SCHARF.** Sie bewacht das ALT-Paar `experiment_golden.xml` (weiterhin produktiv: `test_experiment_parser`, `test_experiment_projection`, `test_experiment_plan_director` haengen daran, `tests/unit/CMakeLists.txt:3308/:3360/:3416`) und die prt-Registry. Sie wird **nicht** obsolet und **nicht** umgehaengt. Ihre Abloesung ist E7-Single-Source / Bruecke I7 und gehoert NICHT in dieses Paket. |
| `fixture_schema_subset_check.cmake` | **BLEIBT der Gurt** -- Weg a ersetzt Weg b nicht, er ergaenzt ihn. Genau EINE Zeile wandert (`-DFIXTURE=` Pfad), plus der Kopfblock `:13-18` wird von "offene Auflage" auf "erledigt am ..." gedreht. PLUS die Haertung aus R1. |
| `golden_n_consistency_check.cmake` | unberuehrt. |
| NEU | ce-seitig: `test_experiment_kern_seam` in einen CI-`-R`-Job heben (R4). |

---

## 2. SCHRITTFOLGE

### 2.0 Schritt 0 -- VORBEDINGUNG (hart, kein Bau davor)

**B14 muss gelandet sein.** `fixture_schema_subset_check.cmake` und die `add_test`-Zeilen `:170-196`
existieren heute nur in `wt-b14-golden` @ `953ce412`; B14 steht laut Ledger auf **NICHT landefaehig,
NB3 noetig**. Wer Weg a vorher anfasst, ist **zweiter Schreiber** auf `Code/tests/CMakeLists.txt` und
`Code/tests/fixture_schema_subset_check.cmake`.

- Pruefkommando (literal, vor Start): `test -f Code/tests/fixture_schema_subset_check.cmake` im
  `development`-Arbeitsbaum muss RC=0 liefern. Solange RC=1: **NICHT STARTEN**.
- Alternativ-Weg, falls B14 bis zur Abgabe nicht landet: Weg a wird **komplett** in die B14-NB3-Welle
  eingefaltet (ein Schreiber, ein Worktree) -- nicht daneben gefahren.

Zweite Vorbedingung: **Ein-Schreiber-Regel ce.** `Code/external/comdare-cache-engine` steht heute auf
`development` @ `3bbcb8ed`; die ce-Landebahn ist seriell. Weg a braucht ein Fenster ohne parallele
ce-Welle auf `tests/unit/CMakeLists.txt`.

### 2.1 Schritt 1 -- ce: Umbenennung + Test-Nachzug (EIN Commit, ce-Repo)

Betroffene Dateien (vollstaendig, 4 Stueck + 1 Move):

| Datei | Aenderung |
|---|---|
| `tests/unit/thesis_tiere/experiment_golden_kern.xml` | `git mv` -> `experiment_kern_seam_fixture.xml`; danach Kopf-Kommentar `:2-10` um die zwei Bloecke aus 1.3 erweitert. **Kein Wert veraendert.** |
| `tests/unit/CMakeLists.txt` | `:3333` Define umbenennen + Pfad nachziehen; Vorspann-Kommentar `:3313-3315` (Dateiname) nachziehen. |
| `tests/unit/thesis_tiere/test_experiment_kern_seam.cpp` | `:3` Kommentar-Pfad; `:29-31` `#ifndef`/`#error`-Name + Text; `:41` `COMDARE_EXPERIMENT_KERN_SEAM_FIXTURE`. Sonst **keine Zeile** -- insbesondere keine Assertion, kein Testname. |
| `libs/cache_engine/include/cache_engine/measurement/machine_identity.hpp` | `:30` + `:211` Pfad nachziehen. |
| `.../measurement/target_isa_complex_axis.hpp` | `:124` Dateiname nachziehen UND eindeutig machen (ce-Fixture vs super-Master benennen). |

**Beweis, dass keine Naht verloren geht** (alles literal, nichts geraten):
1. `git diff -M --stat` zeigt die XML als **Rename mit ~100% Similarity** (der einzige Delta-Anteil ist
   der additive Kopf-Block). Ein Rename mit niedriger Similarity waere der Beweis, dass jemand Inhalt
   mitbewegt hat -> Abbruch.
2. `git show --format= --name-status` -- genau 1 `R`-Zeile, 4 `M`-Zeilen, 0 `A`/`D`.
3. Wert-Diff explizit: `git diff -M -- <alt> <neu>` gefiltert auf Zeilen, die nicht mit `<!--`/Kommentar
   beginnen, muss **leer** sein.
4. `ctest -R '^test_experiment_kern_seam$' -V` -- **15/15 passed**, und im `-V`-Log muss der
   Fixture-Pfad mit dem NEUEN Namen erscheinen (Gegenprobe, dass nicht versehentlich eine alte Kopie
   gelesen wird).
5. **Biss-Beweis ce (Pflicht):** temporaer `git mv` der Fixture beiseite -> `ctest -R
   '^test_experiment_kern_seam$'` muss **RC != 0** liefern mit 6 Fehlern an den `ASSERT_TRUE(ep.has_value())`
   -- Beleg, dass die 6 Tests die Datei WIRKLICH lesen und nicht stumm gruen sind. Zurueckbewegen.
6. Gegenprobe auf Alt-Namen: `grep -rn "experiment_golden_kern" ce/` darf **nur noch** Treffer liefern,
   die den super-Master meinen (heute: `machine_identity.hpp`, `target_isa_complex_axis.hpp` -> nach dem
   Nachzug eindeutig formuliert). Ziel: 0 mehrdeutige Treffer.

### 2.2 Schritt 2 -- super: Wachen-Nachzug (EIN Commit, super-Repo, zusammen mit dem Gitlink-Bump)

| Datei | Aenderung |
|---|---|
| `Code/tests/CMakeLists.txt` | `:174` `-DFIXTURE=...thesis_tiere/experiment_golden_kern.xml` -> `.../experiment_kern_seam_fixture.xml`. Der Bloecke-Kommentar `:160-169` nennt den neuen Namen und den Grund. Die Zeilen `:149-158` (Alt-Paar-Byte-Gate) **bleiben unberuehrt** -- das ist explizit zu belegen (`git diff` beruehrt sie nicht). |
| `Code/tests/fixture_schema_subset_check.cmake` | (a) Kopf `:13-18`: "die Umbenennung bleibt als dokumentierte ce-Auflage offen" -> "ERLEDIGT 2026-08-XX: die ce-Fixture heisst jetzt experiment_kern_seam_fixture.xml; Weg a UND Weg b liegen jetzt beide vor -- der Name ist eindeutig, das Vokabular bleibt bewacht." Alt-Text nicht loeschen, sondern als Historie stehen lassen (Doku-Doktrin). (b) **Haertung aus R1** (siehe 3.). |
| `Code/external/comdare-cache-engine` (Gitlink) | Bump auf den ce-Commit aus Schritt 1 -- **im selben super-Commit** wie die Pfad-Aenderung. Das ist die Kern-Sicherung gegen R1. |
| `docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md` | Nachtrag: F3 vollzogen; C5 geschlossen; die "12 Tests"-Zahl auf 15/6 korrigiert (die falsche Zahl steht in `:4445` und wandert sonst weiter). |

**Beweis, dass keine Naht verloren geht:**
1. `ctest -L da_unit` im super-Build: die Wache `test_fixture_schema_experiment_golden_kern` muss
   **PASSED** melden, **nicht SKIPPED**. Das ist der zentrale Nachweis. Der ctest-Statuswechsel
   PASSED->SKIPPED ist genau das Schadensbild R1 -- er muss aktiv ausgeschlossen werden, indem der
   Testreport-Status literal zitiert wird (nicht nur "0 tests failed").
2. `ctest -L fixture_sync` -- alle Wachen der Familie, Zahl vorher == Zahl nachher (heute 2 im
   `development`, 5 nach B14). Eine gesunkene Zahl = eine verlorene Wache.
3. **Biss-Beweis super (Pflicht, beide Richtungen):**
   - (i) ce-Fixture temporaer wegbewegen bei VORHANDENEM ce-Checkout -> die Wache muss nach der
     R1-Haertung **FATAL** melden (heute: stiller SKIP). RC=1 erwartet.
   - (ii) In die ce-Fixture temporaer ein Phantom-Attribut einsetzen (z.B. `<axis phantom_x="1" .../>`)
     -> `VOKABULAR-DRIFT (FIXTURE)`, RC=1. Beleg, dass die Wache nach dem Pfadwechsel noch beisst und
     nicht ins Leere zeigt.
   - (iii) Sauberer Stand -> RC=0.
4. `git diff` des super-Commits darf **keine** Zeile in `fixture_sync_check.cmake` und keine der beiden
   Alt-Paar-`add_test`-Bloecke enthalten.

### 2.3 Schritt 3 -- ce: CI-Heimat fuer die Naht (EIN Commit, ce-Repo; ADDITIV)

**Befund am Objekt, der dieses Paket erst vollstaendig macht:** `test_experiment_kern_seam` traegt
`LABELS "contract;profiles;e4;incd"` (`tests/unit/CMakeLists.txt:3334`). Der Sammel-Job `test:unit`
laeuft mit `COMDARE_TEST_CTEST_ARGS: "-LE contract|pmc"` (`ce/.gitlab-ci.yml:479`) -- schliesst ihn also
aus. Und in **keinem** `-R`-Regex der `.gitlab-ci.yml` kommt sein Name vor (alle `ctest`-Zeilen geprueft:
`:118, :164, :183, :208, :248, :281, :303, :335, :371, :393, :452, :495`).

**Folge: die 6 Naht-Tests laufen heute in KEINEM CI-Job.** Sie sind ein Phantom-Verifikationssignal --
exakt das "Muster-F"-Loch, das derselbe Job-Block schon fuenfmal geheilt hat (`ce/.gitlab-ci.yml:309-327`
dokumentiert die Vorgaenger M-CE-25 / M-CE-27 / F18 / F29 woertlich).

Aenderung: `test_experiment_kern_seam` in `contract:profile_coverage` aufnehmen --
`ce/.gitlab-ci.yml:334` (`--target`-Liste) und `:335` (`-R`-Regex), mit datiertem Kommentar im Muster der
bestehenden Eintraege.

**Beweis:** Pipeline-Job-Log zeigt `test_experiment_kern_seam` mit `Passed` und einer Testzahl > vorher.

### 2.4 Schritt 4 -- Doku/Ledger (im super-Commit aus 2.2 mitlaufend)

- Ledger-Nachtrag (siehe 2.2).
- `docs/plaene/20260722-AUDIT-nacht-abweichungen-VERDIKT.md`: **nicht editieren** (Audit-Dokumente sind
  Zeitzeugen). Der Verweis "C5 erledigt" gehoert in den Ledger, nicht in den Audit.
- Dieses Plandoc bekommt eine Abschlusszeile "VOLLZOGEN am ..., ce `<sha>`, super `<sha>`".

### 2.5 Reihenfolge und Atomaritaet -- zusammengefasst

```
[0] B14 gelandet?  --NEIN--> STOP (oder Weg a in NB3 einfalten)
     |JA
[1] ce-Commit:  git mv + 4 Datei-Nachzuege        -> ce-Gate lokal + Biss-Beweis (2.1.5)
[2] super-Commit: FIXTURE-Pfad + Haertung R1
                  + GITLINK-BUMP  (EIN Commit!)   -> ctest -L da_unit, PASSED nicht SKIPPED
                                                     + Biss-Beweise (2.2.3 i/ii/iii)
[3] ce-Commit:  CI-Heimat contract:profile_coverage (additiv, unabhaengig landbar)
[4] Ledger/Plandoc-Abschluss
```

Schritt 1 und 2 sind **nicht** atomar machbar (zwei Repos). Der Zwischenzustand ist genau das
R1-Fenster -- deshalb muss der Gitlink-Bump zwingend im selben super-Commit liegen wie die
Pfad-Aenderung, und die Haertung R1 muss **vor** Schritt 1 in der Wache liegen (siehe 3./R1).

---

## 3. RISIKO-ANALYSE -- welche Wache wird STUMM?

### R1 (SCHWER, das Kernrisiko des ganzen Pakets): die Vokabular-Wache skippt still

**Mechanik am Objekt:** `wt-b14-golden/Code/tests/fixture_schema_subset_check.cmake:61-64`

```
if(NOT EXISTS "${FIXTURE}")
    message(STATUS "FIXTURE-SYNC-SKIP: Nachbar-Checkout fehlt (FIXTURE='${FIXTURE}').")
    return()
endif()
```

plus `Code/tests/CMakeLists.txt:197-198`
`SKIP_REGULAR_EXPRESSION "FIXTURE-SYNC-SKIP"`.

Nach der Umbenennung existiert `.../experiment_golden_kern.xml` ce-seitig nicht mehr. Zeigt die
`add_test`-Zeile noch dorthin, meldet die Wache **SKIPPED** -- und ctest zaehlt SKIPPED nicht als
Fehler. Ein `-L da_unit`-Lauf bleibt gruen. Die einzige Wache des Neu-Paares ist abgeschaltet, und
niemand sieht es.

**Warum das nicht durch Sorgfalt allein zu loesen ist:** super und ce sind getrennte Repos, verbunden
ueber einen Gitlink. Es gibt IMMER Kombinationen, in denen der Zustand eintritt und die sich nicht
verbieten lassen:
- alter super-Checkout + neuer ce-Submodul-Stand (jeder, der ce zuerst aktualisiert),
- neuer super-Checkout + alter ce-Gitlink (Bisect, Rescue-Branch, Worktree mit altem Submodul),
- jeder Worktree, in dem `git submodule update` nicht lief.
Der Skip-Zweig war fuer "Submodul gar nicht ausgecheckt" gedacht -- er faengt hier aber "Datei im
vorhandenen Checkout heisst anders", und das ist eine echte Fehlverdrahtung.

**GEGENMASSNAHME (verpflichtend, VOR Schritt 1 zu landen):** den Skip-Zweig praezisieren -- genau die
Disziplin, die derselbe Dateikopf `:36-42` fuer SCHEMA/MASTER schon eingefuehrt hat, jetzt auch fuer
FIXTURE:

```
# Der Skip gilt NUR fuer "ce-Nachbar-Checkout fehlt". Existiert das ce-Fixture-VERZEICHNIS,
# ist ein fehlendes FIXTURE keine fehlende Nachbarschaft, sondern eine falsch verdrahtete
# add_test-Zeile (z.B. nach einer Umbenennung) -> FATAL, kein SKIP.
get_filename_component(_fixdir "${FIXTURE}" DIRECTORY)
if(NOT EXISTS "${FIXTURE}")
    if(EXISTS "${_fixdir}")
        message(FATAL_ERROR
            "fixture_schema_subset_check: FIXTURE '${FIXTURE}' fehlt, aber das Verzeichnis "
            "'${_fixdir}' EXISTIERT -- der ce-Checkout ist da, nur die Datei nicht. Das ist KEIN "
            "fehlender Nachbar, sondern eine falsch verdrahtete add_test-Zeile (Umbenennung?). "
            "Kein SKIP, kein stummes Gruen.")
    endif()
    message(STATUS "FIXTURE-SYNC-SKIP: Nachbar-Checkout fehlt (FIXTURE='${FIXTURE}').")
    return()
endif()
```

Danach ist der Zwischenzustand aus 2.5 **laut** (roter da_unit) statt stumm. Zusaetzlich:
Gitlink-Bump im selben super-Commit (2.2), damit das Fenster in der Haupt-Linie die Breite null hat.

**Belegpflicht:** Biss-Beweis 2.2.3(i) mit ALT/NEU-Kontrast -- ALT (heutige Wache) muss RC=0/SKIPPED
liefern (der Beweis, dass das Loch real war), NEU RC=1. Ohne diesen Kontrast ist die Haertung
unbelegt.

### R2 (MITTEL): dieselbe Falle im Byte-Gate des ALT-Paares

`Code/tests/fixture_sync_check.cmake:26-31` hat exakt dieselbe Struktur (`NOT EXISTS MASTER OR NOT
EXISTS KOPIE` -> SKIP). Weg a fasst das Alt-Paar nicht an, also passiert dort **jetzt** nichts. Aber:
sobald Scheibe 6 spaeter das Alt-Paar wirklich abloest (Umbenennung/Verschiebung nach `deprecated/`),
tritt R1 dort in identischer Form auf. Das ist im Dossier als R5 bereits notiert
(`docs/plaene/20260722-PLAN-48-xml-gate-DOSSIER.md:177`).

**Gegenmassnahme:** dieselbe Verzeichnis-Praezisierung **im selben Commit** auch in
`fixture_sync_check.cmake` einziehen -- sie kostet 6 Zeilen, ist heute wirkungslos (beide Dateien
existieren) und ist genau dann da, wenn sie gebraucht wird. Belegt ueber denselben Biss-Beweis auf dem
Alt-Paar (Datei wegbewegen -> FATAL statt SKIP).

### R3 (MITTEL): die Divergenz-Doku verduennt sich beim naechsten Angleich-Reflex

Nach der Umbenennung ist die Datei eindeutig -- aber der Reflex "die Fixture hinkt dem Master
hinterher, ich gleiche mal an" bleibt moeglich, und **keine Wache** faengt ihn: das Vokabular-Gate
prueft NAMEN, keine Werte (`fixture_schema_subset_check.cmake:29-32` benennt das ehrlich als
Nicht-Ziel). Wer D3-D6 an den Master angleicht, schiesst T3/T4 rot -- das ist laut, gut. Wer aber D8/D9
"vervollstaendigt" (OS-/RAM-Attribute ergaenzt, weil der Master sie spaeter traegt), schiesst T1/T2 rot
-- ebenfalls laut. **Alle Wert-Angleichungen sind also ce-seitig laut.** Das Restrisiko ist nur, dass
jemand dann die Tests "mitzieht" statt zurueckzurollen.

**Gegenmassnahme:** die Divergenz-Tabelle mit Zeilen-Belegen IN der Fixture (1.3) -- sie macht beim
Rot-Werden sofort sichtbar, dass der Wert der Testgegenstand ist. Zusaetzlich der Satz "WER DIESE WERTE
AN DEN MASTER ANGLEICHT, LOESCHT DIE BEWEISE" woertlich im Kopf.

### R4 (MITTEL, Bestandsloch -- unabhaengig von der Umbenennung, aber hier zu heilen)

Die 6 Naht-Tests laufen in **keinem CI-Job** (Belege in 2.3). Das heisst: die gesamte
`<machines>`/`axis@pruefling`/`fulljoin`/`storage`-Naht ist heute **nur lokal** bewacht. Wenn dieses
Paket die Fixture umbenennt und dabei etwas kaputt geht, faengt es **keine Pipeline**. Und umgekehrt:
"Pipeline hart gruen" waere fuer dieses Paket ein **wertloses Gate**, solange das Loch besteht.

**Gegenmassnahme:** Schritt 3 (2.3) ist damit nicht optional, sondern die Voraussetzung dafuer, dass
das CI-Gate dieses Pakets ueberhaupt etwas aussagt. Er kann und sollte **vorgezogen** werden (additiv,
umbenennungs-unabhaengig, sofort landbar) -- dann existiert vor der Umbenennung ein gruener
CI-Referenzlauf, gegen den sich nachher vergleichen laesst.

### R5 (NIEDRIG): stale Doku-Pfade

`machine_identity.hpp:30/:211` und `target_isa_complex_axis.hpp:124` zeigen nach der Umbenennung ins
Leere. Keine Wache faengt Doku-Pfade.
**Gegenmassnahme:** im selben ce-Commit nachziehen (2.1) + Abschluss-grep (2.1.6) mit der harten
Bedingung "0 mehrdeutige Treffer".

### R6 (NIEDRIG): `xmllint --schema` auf der ce-Fixture

Die Fixture traegt `xsi:noNamespaceSchemaLocation="experiment_schema.xsd"` (`:13`), aber **in ce
existiert keine einzige `.xsd`** (am Objekt geprueft: `find ce -name '*.xsd'` = leer). Ein
`xmllint --schema`-Lauf funktioniert nur mit explizitem Pfad auf `super
Code/test_data_xml/experiment_schema.xsd`. Das ist heute so und aendert sich nicht -- aber wer das Gate
"xmllint 4/4" nach der Umbenennung nachfaehrt, muss den Schema-Pfad explizit angeben, sonst wird
schweigend nur auf Wohlgeformtheit geprueft.
**Gegenmassnahme:** Gate-Kommando in 4. literal ausformuliert.

### R7 (NIEDRIG): Zwei-Schreiber auf `Code/tests/CMakeLists.txt`

B14/NB3 und F5 fassen dieselbe Datei an.
**Gegenmassnahme:** Schritt 0 (2.0) + die Reihenfolge-Empfehlung in 5.

---

## 4. GATES (literal, so zu fahren und so zu zitieren)

**G1 -- Wachen-Familie super (der zentrale Gate)**
```
ctest --test-dir <super-build> -L fixture_sync --output-on-failure -V
```
ERWARTUNG literal: jede Wache mit Status `Passed`. **`Skipped` ist ein FEHLSCHLAG dieses Pakets**, auch
wenn ctest gruen meldet. Im Bericht ist die Statusliste je Testname zu zitieren, nicht die
Zusammenfassung. Erwartete Menge nach B14: `test_fixture_sync_experiment_golden`,
`test_fixture_sync_prt_registry`, `test_fixture_schema_experiment_golden_kern`,
`test_fixture_schema_experiment_golden`, `test_golden_n_consistency` = 5/5 Passed, 0 Skipped.

**G2 -- super Voll-Gate**
```
ctest --test-dir <super-build> -L da_unit --output-on-failure
```
ERWARTUNG: Zahl `N/N` >= dem Vor-Stand (heute 116/116 laut B14-NB2-Beleg). Eine gesunkene Gesamtzahl
ist ein verlorener Test, kein "aufgeraeumt".

**G3 -- ce-Naht**
```
ctest --test-dir <ce-build> -R '^test_experiment_kern_seam$' --output-on-failure -V
```
ERWARTUNG: `15 tests from ExperimentKernSeam` / `15 PASSED`. Im `-V`-Log muss der NEUE Fixture-Pfad
vorkommen (`grep experiment_kern_seam_fixture.xml` im Log).

**G4 -- ce Voll-Gate**
```
ctest --test-dir <ce-build> --output-on-failure    (bzw. das etablierte 408/408-Doppellauf-Gate)
```
ERWARTUNG: Zahl unveraendert gegen den Vorlauf; Doppellauf 2x seriell.

**G5 -- xmllint (beide Instanzen, expliziter Schema-Pfad wegen R6)**
```
xmllint --noout --schema Code/test_data_xml/experiment_schema.xsd \
        Code/test_data_xml/experiment_golden_kern.xml
xmllint --noout --schema Code/test_data_xml/experiment_schema.xsd \
        Code/external/comdare-cache-engine/tests/unit/thesis_tiere/experiment_kern_seam_fixture.xml
xmllint --noout --schema Code/test_data_xml/experiment_schema.xsd \
        Code/test_data_xml/experiment_golden.xml
xmllint --noout --schema Code/test_data_xml/experiment_schema.xsd \
        Code/external/comdare-cache-engine/tests/unit/thesis_tiere/experiment_golden.xml
```
ERWARTUNG: 4/4 `validates`, Exit 0. (Das ist der etablierte "xmllint 4/4"-Gate der B14-Welle, hier mit
dem neuen Fixture-Namen.)

**G6 -- BISS-BEWEISE, beidseitig, mit ALT/NEU-Kontrast (Pflicht; ohne sie ist das Paket unbelegt)**

| # | Praeparat | ALT (vor Haertung) | NEU (nach Haertung) |
|---|---|---|---|
| B1 | ce-Fixture wegbewegen, ce-Checkout vorhanden | Wache `Skipped`, RC=0 -- **das Loch** | `FATAL_ERROR`, RC=1 |
| B2 | Phantom-Attribut in die ce-Fixture (`phantom_x="1"`) | RC=1 (`VOKABULAR-DRIFT (FIXTURE)`) | RC=1, identische Meldung -- Beleg, dass der Pfadwechsel die Wache nicht ins Leere zeigen liess |
| B3 | Phantom-Element in den MASTER | RC=1 (`VOKABULAR-DRIFT (MASTER)`) | RC=1 unveraendert |
| B4 | ALT-Paar-Kopie wegbewegen (R2) | `Skipped`, RC=0 | `FATAL_ERROR`, RC=1 |
| B5 | Fixture-Define im ce-CMake auf alten Namen zeigen lassen | -- | `ctest -R test_experiment_kern_seam` RC!=0, 6 Fehler an `ASSERT_TRUE(ep.has_value())` |
| B6 | sauberer Endstand | -- | alle RC=0 |

**G7 -- Rename-Reinheit**
```
git -C <ce> show --format= --name-status <sha>     -> genau 1 R-Zeile, 0 A, 0 D
git -C <ce> show -M --stat <sha>                   -> Similarity der XML nahe 100%
```
Plus: Wert-Diff (Nicht-Kommentar-Zeilen) der umbenannten XML == leer.

**G8 -- ASCII / TABU**
- ASCII-only in allen geaenderten Dateien: `LC_ALL=C grep -n '[^\x00-\x7F]' <datei>` == leer je Datei
  (Zahl literal nennen: "0").
- TABU-Diff-Check: der Diff beider Commits darf **keine** der 11 TABU-Dateien beruehren
  (`docs/plaene/20260722-PLAN-48-xml-gate-DOSSIER.md:156-171`). Insbesondere:
  `permutation_axes.xml`, `golden_fullpilot_320_binary_ids.txt`, `all_axes_golden.profile.xml`,
  `m3v2_study.profile.xml`, `m3_smoke_coverage`, die 4 Registry-XML, die 8 `*.test_data.xml`,
  `prt_art_axis_registry.xml`. Beleg: `git show --name-only` gegen die Liste, Treffer == 0.
- **golden-Neutralitaet:** der Diff beruehrt keine binary_id-tragende Datei; `test_profile_roundtrip`
  (golden binary_count == 320) bleibt unveraendert gruen. Beleg literal zitieren.

**G9 -- Pipeline**
super- und ce-Pipeline hart gruen am VOLL-SHA. **Mit dem Vorbehalt aus R4**: solange Schritt 3 nicht
gelandet ist, sagt die ce-Pipeline ueber diese Naht nichts aus -- das ist im Bericht so zu schreiben,
nicht als Gruen zu verkaufen.

---

## 5. ABGRENZUNG ZUM GOLDEN-UPDATE-FENSTER (F5)

### 5.1 Was F5 ist (Owner verbatim, Ledger `:4225`)

> "F5: Bitte bewege golden und die golden Traeger, die muessen den neuen Gegebenheiten angepasst und
> geupdated werden, ebenfalls die Syntax und Semantik der XML wenn notwendig und der Interpreter dazu
> im Planer."

Konsequenz-Zeile im Ledger `:4230`: golden + BEIDE Traeger bewegen; wenn noetig XML-Syntax+Semantik
erweitern UND den Planer-Interpreter nachziehen; die golden-320-Byte-Wachen/CRC-Anker werden dabei
**kontrolliert neu geankert** -- eigenes Fenster mit Gates.

### 5.2 Schnitt -- die Trennlinie ist WERTE vs. NAMEN

| Gegenstand | Fenster | Begruendung |
|---|---|---|
| ce-Fixture umbenennen (`git mv`) | **HIER (Weg a)** | reine Identitaets-Frage, wert-neutral |
| Compile-Define umbenennen, TU-Nachzug, Doku-Pfade | **HIER** | Folge des Renames |
| `-DFIXTURE=`-Pfad in der Wache, R1-Haertung, R2-Haertung | **HIER** | Folge des Renames + die Falle, die er aufreisst |
| CI-Heimat fuer `test_experiment_kern_seam` (R4) | **HIER** (vorziehbar) | additiv, unabhaengig, macht die Gates dieses Pakets erst aussagekraeftig |
| Kopf-Kommentar-Bloecke (Divergenz-Doku) | **HIER** | dokumentiert genau den Zustand, den der Rename schafft |
| MASTER-Inhalt bewegen (Achsen, `allowed_variants`, `run_options`, `organ_subaxes`, N-Kodierung) | **F5** | Wert-/Semantik-Aenderung |
| `experiment_schema.xsd` erweitern, `SCHEMA.md` | **F5** | Schema-Evolution |
| `all_axes_golden.profile.xml` (zweiter Traeger, heute TABU) | **F5** | kontrollierte TABU-Oeffnung, eigener Gate-Satz |
| Planer-Interpreter (`parse_experiment_profile`, `validate_profile`) | **F5** | Code-Naht |
| search_algo-Pin `{k_ary, interpolation}` vs `{k_ary, linear_scan}` (offene Owner-Frage, Ledger `:4259`) | **F5** | bewegt beide Traeger |
| Neue Naht-Tests fuer in F5 neu eingefuehrte Elemente | **F5**, Traeger ist die dann eindeutig benannte Fixture | Weg a liefert F5 den sauberen Traeger |
| Alt-Paar `experiment_golden.xml` ausmustern / `deprecated/` | **WEDER NOCH** -- eigener Rest-Scheibe-6-Posten (E7-Single-Source / Bruecke I7), nach 320er + User-GO | drei produktive Test-Suiten haengen daran |
| C4 (`identity='CacheEngine'`-Positivtest), C6 (`@enabled`-Default) | **WEDER NOCH** -- offene A-Listen-Auflagen, benannt, nicht eingeplant | keine Owner-Freigabe eingeholt |

### 5.3 REIHENFOLGE -- Empfehlung mit Begruendung

**EMPFEHLUNG: B14/NB3 -> Weg a -> F5.**

Begruendung, in der Reihenfolge der Staerke:

1. **Zwang (nicht verhandelbar):** beide brauchen B14 gelandet. `fixture_schema_subset_check.cmake` und
   `golden_n_consistency_check.cmake` existieren nur in `wt-b14-golden`; F5 will die Ketten-Wache ohnehin
   anfassen (sie kodiert N und den Achsen-Raum). Ohne B14 sind beide Pakete Zweit-Schreiber.
2. **Weg a ist wert-neutral, F5 nicht.** Ein Rename mit ~100% Similarity ist in einer Zeile
   beweisbar (`git diff -M`). Laeuft er NACH F5 oder in F5 hinein, geht diese Beweisbarkeit verloren:
   Namens- und Wert-Aenderung im selben Fenster sind nicht mehr trennbar auseinanderzuhalten, und genau
   diese Vermischung hat den C5-Zustand ueberhaupt erst erzeugt.
3. **Weg a macht F5 sicherer.** F5 arbeitet mit greps ueber "golden" und "golden_kern" quer durch beide
   Repos. Solange zwei Dateien gleich heissen, ist jeder solche grep mehrdeutig -- und F5 ist genau die
   Welle, in der ein Angleich-Reflex auf die Fixture den groessten Schaden anrichtet (er wuerde die
   D3-D6-Beweise loeschen, waehrend gleichzeitig alle Werte legitim in Bewegung sind, also niemand
   stutzt). Die Umbenennung ist die billigste verfuegbare Absicherung dagegen.
4. **Doppelarbeit vermeiden.** Beide Pakete fassen `Code/tests/CMakeLists.txt` an. Weg a beruehrt dort
   genau eine Zeile (`:174`) und den zugehoerigen Kommentarblock. Laeuft Weg a zuerst, muss F5 diese
   Zeile nicht erneut anfassen. Umgekehrt muesste Weg a nach F5 in einer moeglicherweise stark
   umgebauten Datei operieren.
5. **Reissleine, falls die Reihenfolge nicht haltbar ist:** startet F5 zwingend zuerst (z.B. weil es
   abgabe-kritisch ist und Weg a nicht), dann wird Weg a **Schritt 1 von F5** -- als erster, separater,
   wert-neutraler Commit INNERHALB des F5-Fensters, mit denselben Gates. **Nie parallel**: zwei
   Schreiber auf `Code/tests/CMakeLists.txt` + der ce-Fixture ist die Kollision, die dieses Plandoc
   gerade zu verhindern versucht.

---

## 6. AUFWAND UND EINORDNUNG

### 6.1 Aufwand

| Schritt | Umfang | Netto-Aufwand | Gate-Zeit |
|---|---|---|---|
| 0 Vorbedingungs-Pruefung | 1 Kommando | 5 min | -- |
| 1 ce: Rename + 4 Nachzuege | 1 Move, ~12 geaenderte Zeilen | 30-40 min | ce-Gate (G3+G4) |
| 2 super: Pfad + R1/R2-Haertung + Gitlink | ~2 Zeilen Pfad + ~14 Zeilen Haertung + Kommentare | 40-50 min | G1+G2+G5 |
| 3 ce: CI-Heimat | 2 Zeilen `.gitlab-ci.yml` + Kommentar | 15 min | Pipeline |
| 4 Ledger/Doku | 1 Nachtrag | 15 min | -- |
| G6 Biss-Beweise (6 Praeparate, ALT/NEU) | -- | 45-60 min | -- |

**Netto ohne Voll-Gates: ~2,5 h.** Mit ce-Voll-Gate im Doppellauf und Pipeline-Warte: **ein halber
Arbeitstag** in Kalenderzeit, davon der groesste Teil Wartezeit.

Risikoklasse: **niedrig**. Kein Achsen-Code, keine binary_id, keine Messdaten, keine Emission, kein
Fingerprint. Golden-neutral (G8). Der einzige echte Denkfehler-Kandidat ist R1, und der ist mit einer
Struktur-Haertung plus Biss-Beweis abgeraeumt.

### 6.2 Vor oder nach Abgabe (Fr 08.08.)?

**EMPFEHLUNG: NACH der Abgabe -- mit einer klar benannten Ausnahme.**

Gegen "vor Abgabe":
- Der Owner-Entscheid ist ein GO, aber kein Dringlichkeits-Signal ("bitte sauber nachziehen, und am
  besten nochmal gruendlich planen" -- die Betonung liegt auf Sorgfalt).
- Nichts an der Abgabe haengt daran: keine Messung, kein Thesis-Text, kein Binary, keine Zahl. Der
  Zustand ist seit dem 22.07. stabil und **dokumentiert** (Datei-Kopf + Audit-A-Liste) -- er ist eine
  Hygiene-Schuld, keine Regression.
- Die Vorbedingung (B14 gelandet, 2.0) ist heute **nicht erfuellt** und liegt nicht in der Hand dieses
  Pakets. B14 steht auf NB3.
- Die Frist-Lage ist eng: Trigger Do 07.08., Abgabe Fr 08.08., F1 (Planer-Binary-Split) ist HARTES GO
  und bau-kritisch. Jede Stunde am Fixture-Namen ist eine Stunde nicht am Trigger-Pfad.
- Weg b (die Vokabular-Wache) deckt den Zustand bereits ab, sobald B14 landet: der Name bleibt
  mehrdeutig, aber das F27/TABU-11-Muster "gleichnamig-divergent OHNE JEDE Wache" steht dann nicht mehr.

Fuer "vor Abgabe" spricht **ein** Argument, und es ist ein gutes:
- **R4 ist ein Bestandsloch, kein Rename-Folgeschaden.** Dass die 6 Naht-Tests in keinem CI-Job laufen,
  gilt **heute** und trifft die `<machines>`-/`pruefling`-/`fulljoin`-/`storage`-Naht -- also Elemente,
  die F5 gleich bewegen will. Das ist eine echte, aktuelle Verifikationsluecke.

**Daraus der konkrete Vorschlag:**

1. **Schritt 3 (CI-Heimat, R4) VORZIEHEN** -- sofort, unabhaengig, additiv, ~15 min, kein Rename noetig,
   keine B14-Abhaengigkeit. Er schliesst ein reales Loch **vor** dem F5-Fenster und liefert nebenbei den
   gruenen Referenzlauf, gegen den Weg a spaeter vergleicht. Das ist der einzige Teil dieses Pakets, der
   vor der Abgabe verdient ist.
2. **Schritte 1, 2, 4 (der eigentliche Rename) NACH der Abgabe** -- oder frueher, falls (a) B14/NB3
   landet UND (b) ein super-Slot frei ist UND (c) F5 unmittelbar danach startet (dann als F5-Schritt-1
   nach 5.3(5)).
3. **Nicht** in die Trigger-Nacht schieben und **nicht** parallel zu F5 fahren.

Diese Einordnung ist eine Empfehlung mit offengelegter Begruendung -- sie ist kein Entscheid. Wenn der
Owner Weg a vor der Abgabe will, ist er in ~2,5 h Netto-Arbeit machbar, sobald B14 gelandet ist; die
Gates in 4. gelten dann unveraendert.

---

## 7. WAS DIESER PLAN BEWUSST NICHT TUT

- Kein Byte-Sync auf dem Neu-Paar (strukturell falsch, siehe 0.2).
- Keine Abloesung von `fixture_sync_check.cmake` (das Alt-Paar ist produktiv, 1.4).
- Keine Wert-Aenderung an MASTER oder Fixture (F5-Territorium, 5.2).
- Kein Verschieben der Fixture in ein anderes Verzeichnis (zweckfrei, 1.1).
- Keine Aenderung an der Audit-Datei `20260722-AUDIT-nacht-abweichungen-VERDIKT.md` (Zeitzeuge, 2.4).
- Keine Erledigung von C4/C6 (benannt, nicht freigegeben, 0.5).
- Kein Bau, kein Commit, kein Push im Rahmen dieser Planung.

---

## SELBSTCHECK

- ASCII-only: ja (Diff-geprueft vor Ablage; keine Umlaute, keine typografischen Zeichen, keine Emoji).
- Alle Datei:Zeile-Anker am Objekt gelesen, nicht aus Ledger/Plandoc uebernommen.
- Zwei Ledger-Aussagen am Objekt **korrigiert** und als Korrektur markiert: (a) "12 hartverdrahtete
  Tests" -> 15 TESTs in der TU, davon 6 fixture-lesend (0.3 a); (b) "GEBAUT wurde Weg b" -> gebaut,
  aber **nicht gelandet**, existiert nur in `wt-b14-golden` @ `953ce412` (0.3 c).
- Ein Befund, der in keiner Vorlage stand: `test_experiment_kern_seam` laeuft in **keinem CI-Job**
  (R4, Belege in 2.3).
- Kein Bau, kein Commit, keine Datei ausserhalb dieses Plandocs veraendert.
