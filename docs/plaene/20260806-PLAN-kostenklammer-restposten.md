# PLAN -- Kostenklammer-Restposten (K-01..K-10, KK-1..KK-9, V-Posten)

**Stand der Erhebung:** ce `47c4ef1d`, super `72eab9ae` (06.08.2026 abends).
**Stand der zugrundeliegenden Anklage:** ce `e7aa1244`, super `9f5ff1d2`.
**Gegenprobe zur Drift:** `git diff --stat e7aa1244..HEAD` ueber alle sieben Befund-Dateien ist
**LEER** -- keine der heutigen Landungen (T2-A, B14, A1-NB2, CI-Invariante) hat eine Befundstelle
angefasst. Alle Fundstellen in diesem Dokument sind am **heutigen** HEAD `47c4ef1d` selbst gelesen,
nicht aus der Anklageschrift uebernommen.

**Status: PLANUNGSDOKUMENT. Nichts committet, nichts geaendert, kein Worktree beruehrt.**

---

## 0. DIE GRENZE DER DOKTRIN -- Kopf dieses Dokuments, weil sie alles Folgende ordnet

Die Owner-Doktrin (Ledger nachmittag-6, verbatim) lautet:

> "wir sind entschieden GEGEN Kostenklammern und FUER maximale sauberkeit und hohes Niveau bei der
> Implementierung"

Die daraus gefuehrte Arbeits-Definition (Ledger nachmittag-6, bindend): *Eine KOSTENKLAMMER ist jede
Bedingung, die eine geplante Faehigkeit nur deshalb auslaesst, weil sie heute nichts kostet /
niemand liest / inert ist. "Heute unerreichbar" ENTLASTET NICHT.*

**UND HIER DIE GRENZE, die am 06.08. gemessen worden ist und ohne die die Doktrin ins Gegenteil
kippt:**

> **Die Doktrin richtet sich gegen ausgelassene FAEHIGKEITEN, nicht gegen bewusst bezahlte
> VOLLSTAENDIGKEIT.**

Der gemessene Beleg: eine Formwache laeuft ueber **alle** Atome der Selektion statt beim ersten
Verstoss abzubrechen -- **820 ms fuer 2^17 Atome**, und dafuer eine ehrliche Diagnosezahl statt
eines blossen ersten Treffers. **Das ist RICHTIG so.** Wer diese 820 ms als "Kosten" anklagt,
wendet die Doktrin falsch herum an: hier wurde nichts ausgelassen, sondern etwas bezahlt.

**Operative Unterscheidung fuer jeden Posten unten (Pruefreihenfolge):**

| | Kostenklammer (zu beseitigen) | Bezahlte Vollstaendigkeit (zu schuetzen) |
|---|---|---|
| Was passiert mit der Faehigkeit? | sie wird **ausgelassen** | sie wird **erbracht** |
| Begruendungsform | "liest ohnehin niemand", "ist heute inert", "kostet sonst" | "kostet, liefert dafuer eine ehrliche Zahl / fail-closed" |
| Verhalten im Grenzfall | raet, oder ueberspringt still | bricht ab, oder meldet beziffert |
| Richtige Reaktion | **entfernen** | **stehen lassen, notfalls verteidigen** |

**Zusatzregel aus derselben Sitzung (Ledger nachmittag-6, Kosten-Auflage):** eine Haertung gegen
Kostenklammern darf **selbst keine** einbauen -- die Formpruefung laeuft IN der ohnehin
durchlaufenen Digest-Schleife mit, nicht als zweiter Durchgang. Das ist die Bauform, die beide
Seiten der Grenze erfuellt.

**Zweite bindende Owner-Zeile (nachmittag-6):** *"Jede einzelne Ledger Aussage gehoert geprueft
gegen den code."* Dieses Dokument hat sie in beide Richtungen angewandt -- es korrigiert unten
**drei Aussagen der Anklage selbst**, nicht nur Aussagen des Codes.

---

## 1. DIE ENTLASTUNGEN -- der wertvollste Abschnitt, weil er Arbeit spart

Sieben Positionen sind **keine offenen Posten**. Vier davon waren am Anklagestand noch offen und
haben sich seither oder unter Nachmessung aufgeloest.

### 1.1 K-01 / KK-2 -- `COMDARE_BESTANDSLOG` "wird nirgends gesetzt": **WIDERLEGT**

- **Beleg:** `experiment_plan_director.hpp:952-955` reicht die Variable per
  `append_forward_var_literal` real in das **generierte** CI-YAML durch (vier Variablen:
  `COMDARE_BESTANDSLOG`, `_DOC_KEY`, `_OWNER_UUID`, `_MASCHINE`).
- **Test-Beleg:** `test_experiment_plan_director.cpp:845-860` setzt per `::setenv` und erwartet das
  Literal im Emissions-Ergebnis.
- **Fehlerklasse der Anklage:** ein Repo-Grep wurde als Laufzeit-Aussage gelesen. **Regel-Zeile (4)
  aus nachmittag-8:** *bei GENERIERTEN Artefakten beweist die Abwesenheit im Quell-Repo nichts.*
- **Was bleibt:** eine **Infra-/Owner-Frage, keine Code-Frage** -- faehrt der Trigger-Lauf mit
  gesetzter Variable? Das haengt an Runner-Env / GitLab-Projektvariablen und ist vom Repo aus nicht
  entscheidbar. **Der Code-Teil ist beantwortet.**

### 1.2 K-05 / KK-3 -- doppelter Job-Schluessel `contract:axis-version-lock`: **GEHEILT**

Am HEAD `47c4ef1d` selbst nachgemessen:

- **Genau eine** Definition (`.gitlab-ci.yml:447`), **unbedingt** (kein `rules:`).
- Der Kommentarblock `:432-445` dokumentiert die Zusammenfuehrung vom 06.08. und benennt die
  Wurzel: die zweite Fassung war `rules`-gegatet auf `COMDARE_AXIS_LOCK_CHECK`, das **nirgends
  gesetzt** war -- der Tripwire lief drei Wochen in **keinem** Lauf, bei gruener Pipeline.
- Bewusst auf der **staerkeren** Wirkung vereinigt: "Ein opt-in-Gate waere die schwaechere Fassung
  und ist damit bewusst NICHT uebernommen."
- **Rueckfall-Wache neu:** `scripts/ci_yaml_key_guard.sh`, gefahren in `test:coverage-guard`, als
  **erste** Stufe (`.gitlab-ci.yml:236-244`): erst der BESTAND der Jobs, dann ihre ABDECKUNG.

**Das ist die dritte Entlastung des Tages und der Beleg dafuer, dass Nachmessen am Objekt sich
lohnt** -- die Anklage fuehrte den Posten noch als offen.

### 1.3 K-08 -- `COMDARE_VARIANT_GATE`: **ENTLASTET** (funktional obsolet per F7-(b))

Drei Code-Stellen dokumentieren die Ablesung: `toolchain_stamp_naht.hpp:406`,
`build_variant_sidecar.hpp:16-29`, `anatomy_fingerprint.hpp:287`. Die bvset-Identitaet (Glied [6]
des Format-3-Preimage) deckt ab, was das Variant-Gate leisten sollte. **Kein Bau.**

### 1.4 K-07 -- 234-V-b Shaped-Emission: **ENTLASTET** (default-OFF ist der spezifizierte Zustand)

Code-Zustand unveraendert bestaetigt (nur Test-Konsumenten). Default-OFF ist hier **nicht** die
verbotene Begruendungsform, sondern die Spezifikation selbst. **Kein Bau.**

### 1.5 K-09 -- `target_isa`-Unterachsen: **im Kern ENTLASTET**

Echte Konsumenten existieren und sind benannt: `target_isa_sub_axes.hpp`, `alloc_hw_config.hpp`,
`numa_page_probe_linux.hpp` u.a. **Restluecke = Validierungsabdeckung**, nicht fehlende Faehigkeit.
-> geht in den Aufraeumpass (F3/F5/R4), nicht in die Vor-Trigger-Kette.

### 1.6 K-04 -- doppeltes Fingerprint-Leeren: **RECHTS UMKLASSIFIZIERT zu bezahlter Vollstaendigkeit**

Das ist der Musterfall fuer den Kopf dieses Dokuments.

- **Ort:** `profile_run_entry.hpp:1005-1012` (`na`-Zellwert-Wache, W10-C4) und `:434-450`
  (T2-C-Sonde `tier_realversion_ist_bekannt()`).
- **Anklage-Praemisse war:** K-01 sei tot, also seien beide Wachen unerreichbar und damit unnoetig.
  **Diese Praemisse ist durch 1.1 widerlegt** -- die Ebene ist ERREICHBAR.
- **Was die Wachen tun (Code woertlich, `:431-434`):** *"Eine unbestimmte Identitaet darf keinen
  Skip tragen: der Provider faellt weg, damit kein `.fingerprint` entsteht, und dll_is_current gibt
  bei leerer Erwartung IMMER false zurueck ... Ehrlicher Neubau statt geratener Wiederverwendung."*
- **Einordnung:** beide sind **fail-closed-Korrektheitswachen**, die eine unvollstaendige Identitaet
  **nicht raten**. Sie lassen keine Faehigkeit aus -- sie bezahlen einen Neubau fuer eine ehrliche
  Aussage. Exakt die geschuetzte Seite der Grenze.
- **Gegenprobe, dass der positive Pfad erreichbar bleibt** (Codex, unabhaengig):
  `tier_realversion_ist_bekannt()` sondiert den aktiven Treiber real
  (`-dumpfullversion`/`-dumpversion`, `toolchain_stamp_naht.hpp:317-349`); im Normalpfad
  (Default-Treiber) liefert sie `true`. `false` **nur** bei tatsaechlich fehlendem oder nicht
  sondierbarem Treiber.
- **Termin: entfaellt. Kein Bau. Nicht anfassen.**

### 1.7 KK-9 -- `bytes_in_use_peak`: **weitgehend selbst-entlastet**, ein Rest bleibt (s. 2.5)

Die konkrete Anklage-Behauptung (Fehlkonsum in `apps/f15_compare/main.cpp`) ist **nicht
bestaetigt**: `f15_compare/main.cpp:493` weist die Spalte ausdruecklich als honest-0 aus
(*"PMU-/Energie-Spalten UND bytes_allocated/bytes_in_use_peak = honest-0"*), `:508` schreibt
`10x honest-0`. Kein Fehlkonsum des END-Werts. Der Rest ist ein Doku-/Anhang-Posten, kein
Messfehler -- s. 2.5.

### 1.8 Bestandslog-Scope (K-02, K-03, KK-4, KK-6, KK-8): **vertagt und ENTSCHIEDEN, nicht uebersehen**

Ledger nachmittag-8 Abschn. E und nachmittag-10 Abschn. H fuehren beides ausdruecklich:
`present_`-Gate fuer die `offen > 0`-Abschneidung **und** die Verfeinerung der Formwache (Atom statt
plan-global) -- **nach der Abgabe, zusammen mit Option 2 der Plan-Ablage.** Eine getroffene und
protokollierte Vertagung ist keine Kostenklammer.

### 1.9 Nicht hier verhandelt: KK-1 (PMC)

Laeuft als **eigener Workflow** (`20260806-PLAN-p-pmc-1-messkette.md`). Hier nur als Kontext fuer
KK-5 und V-C mitgefuehrt. **Nicht doppelt bearbeiten.**

---

## 2. DIE OFFENEN POSTEN, nach Schaerfe

**Entduplizierte Nummerierung.** Pass A = Rohfundliste (`K-*`), Pass B = Anklageschrift (`KK-*`).

| Konsolidiert | Pass A | Pass B | Thema | Schaerfe | Termin |
|---|---|---|---|---|---|
| **P-1** | -- | KK-5 | `allow_failure: true` am Voll-Mess-Batch | **MESSVALIDITAET** | **VOR Trigger** |
| **P-2** | K-06 | -- | Push-Observer ueber die `.so`-Grenze | ZERSTOERTE GEPLANTE FAEHIGKEIT | nach Abgabe |
| **P-3** | K-10 | -- | `COMDARE_LEGACY_MESSREIHEN` -- Gate existiert nicht | NIVEAU (**verschaerft**) | nach Abgabe |
| **P-4** | -- | KK-7 | `active_telemetry_is_silent()` liefert literal `false` | NIVEAU | GOLDEN-UPDATE-Fenster |
| **P-5** | -- | KK-9 (Rest) | `bytes_in_use_peak` traegt den END-Wert | SAUBERKEIT | vor Anhang-Bau |

---

### P-1 [MESSVALIDITAET] `allow_failure: true` am generierten Voll-Mess-Batch -- Pass B (KK-5)

**Ort:** `libs/cache_engine/profile_facade/planner/experiment_plan_director.hpp:1372-1373`, in
`emit_batch_measure_job` (gemessen ce-HEAD 54106bc9: `git grep allow_failure` = 1 Treffer @1373, Kommentar direkt darueber @1372; Alt-Anker :1332-1333 war um 40 gedriftet). (Hinweis: die weiteren Anker in diesem Abschnitt -- `:1300`, `:1336-1364` u.a. -- sind NICHT nachgemessen und stehen auf dem Alt-Stand.)

**IST, am Objekt gelesen:**

    :1372  // Sichtbarkeits-Doktrin: Mess-Fehler => CSV 'failed' + Log, die Pipeline bleibt gruen (nicht still verschluckt).
    :1373  s += "  allow_failure: true\n";

`allow_failure` steht **auf JOB-Ebene**, ausserhalb von `rules:` -- es deckt damit den **ganzen
Job**, nicht nur die Mess-Zellen.

**PLAN-SOLL (zwei Quellen, beide zitiert):**

1. Memory-KERN `feedback_measurement_failure_visibility_csv_failed_not_null_plus_log` regelt die
   **ZELL**-Ebene: einzelne Mess-Fehler sichtbar als `'failed'` statt NULL.
2. **§66-N2** (Ledger Z.3499, 23.07., Owner-KERN=Gesetz) verlangt fuer die PMC-Strecke:
   **"BEIDE hart (kein Gate/allow_failure)"**.

**DIFF -- die Zell-Doktrin ist auf die Job-Ebene ausgedehnt worden, wo sie laut §66-N2 nicht gilt.**
Was am selben Job zusaetzlich unter `allow_failure` faellt (Codex-Gegenpruefung, von mir am Objekt
nachgelesen):

| Fehlerquelle im emittierten `script` | Zeile |
|---|---|
| Submodul-/Setup-Prolog, `cd Code` | `:1336-1339` |
| CMake-Configure der CEB | `:1341-1343` |
| Bau des `comdare-messung-driver` | `:1344` |
| fehlender / nicht ausfuehrbarer Driver (`exit 1`) | `:1349-1350` |
| **der #37-PMC-Preflight selbst** | `:1352-1364` |

**DIE SCHAERFE LIEGT IN DER LETZTEN ZEILE.** Der Kommentar des Preflights sagt woertlich
(`:1360-1361`): *"Unter `set -e` bricht ein Exit != 0 den Batch ehrlich ab -- HART in BEIDEN
Profilen, auch smoke (§66-N2 'beide hart')."* Und `:1352-1358` benennt die Gefahr exakt: *"ohne
Preflight koennte eine Lane eine mehrtaegige Messung mit kaputtem perf_event_open durchlaufen und
lauter 0-Zaehler produzieren"*.

**Beides ist gleichzeitig wahr und genau das ist der Befund:** job-**intern** ist der Preflight
hart (`set -euo pipefail`, `:1346`) -- er bricht den Batch ab. Pipeline-**weit** ist er weich: der
rote Batch ist erlaubt, die Pipeline bleibt gruen. **Die Lane stirbt still.** Bei einer mehrtaegigen
Messung ueber mehrere Lanes heisst das: eine Lane liefert nichts, und kein Signal sagt es an.

**Wirkung je rules-Zweig** (`:1368-1373`, gemessen ce-HEAD 54106bc9: `rules:` @1368, `allow_failure` @1373):
- `smoke` -> `when: on_success`, laeuft automatisch, **bleibt pipeline-weich**.
- sonst -> `when: manual` (320er-§41-Gate). Ohne manuellen Start laeuft dort auch der Preflight
  nicht.

**Doktrin-Einordnung:** Das ist **keine** bezahlte Vollstaendigkeit. Die Faehigkeit "eine kaputte
Mess-Lane wird sichtbar" wird ausgelassen, und die Begruendungsform ("die Pipeline bleibt gruen")
ist genau die verbotene. Zugleich ist es dieselbe Fehlerklasse wie der PMC-Sperrposten aus Ledger
nachmittag-10 Abschn. E: **eine Wache, die eine andere Frage beantwortet als die gestellte.**

**BAU-ANWEISUNG (Vorschlag, Owner-Entscheid noetig -- s. Owner-Frage):**
1. `allow_failure: true` vom Job **entfernen**; die Zell-Sichtbarkeit bleibt unberuehrt (sie sitzt
   im CSV-Schreiber, nicht am Job).
2. Falls Mess-**Zell**-Fehler weiterhin pipeline-neutral bleiben sollen: **nicht** ueber
   `allow_failure`, sondern ueber den Exit-Code des Mess-Aufrufs -- die Zelle schreibt `'failed'`
   und der Aufruf endet 0; **Preflight, Configure, Bau und Driver-Existenz behalten ihren harten
   Exit.** Das trennt die zwei Ebenen sauber, statt sie mit einem Job-Flag zu vermengen.
3. Regressionstest gegen `test_experiment_plan_director.cpp`: das emittierte YAML enthaelt
   `allow_failure` **nicht** mehr am Mess-Batch (Literal-Erwartung, wie beim
   `COMDARE_BESTANDSLOG`-Test `:845-860` bereits vorgemacht).

**OWNER-FRAGE (blockierend, weil sie den Trigger beruehrt):** Soll ein Mess-Batch-Job die Pipeline
rot faerben duerfen? §66-N2 sagt fuer die PMC-Strecke ja. Fuer die Mess-**Zellen** sagt der
Sichtbarkeits-KERN nein. **Der Vorschlag oben erfuellt beide** -- aber er aendert das
Pipeline-Verhalten des Trigger-Laufs und gehoert deshalb vor den Trigger entschieden, nicht danach
entdeckt.

**Termin: VOR dem Trigger, in derselben Welle wie die PMC-Reparatur (KK-1) -- gleiche Zeilenregion,
gleicher Job.** Getrennt zu fahren erzeugt eine Kollision.

---

### P-2 [ZERSTOERTE GEPLANTE FAEHIGKEIT] Push-Observer ueber die `.so`-Grenze -- Pass A (K-06)

**Ort:** `libs/cache_engine/src/measurement/measurable_concept.hpp:6-13` (Plan-Zitat im Datei-Kopf),
`:52-58` (Begruendung), `:65-83` (der `#ifdef`).

**PLAN-SOLL -- der Code zitiert es selbst (`:9-13`, User-Direktive 2026-05-25, verbatim):**

> "Die Statistik sollte jeweils Observer bereitstellen koennen, um extern ganz einfach verschiedene
> Achsen auswerten zu koennen. Dabei verwenden die Observer Instanziierungen das Template Pattern
> der jeweiligen Achse, weil schliesslich jede Achse denselben Typ an statistischer Auswertung
> verwendet."

Der Kopf zeigt `:21-25` sogar die vorgesehene Anwendung: `obs.on_event([](auto const& snap){...})`.

**IST:** Die Mechanik ist fertig (`on_event`/`notify`/`has_callback`, `:66-72`), aber unter
`#ifdef COMDARE_CE_ENABLE_OBSERVER_PUSH`; im Default-Zweig bleibt ein NullNotify (`:81`).
Begruendung im Code (`:55-56`): *"Ueber die extern-C-Modulgrenze wird NIE ein Subscriber gesetzt --
die Auswertung laeuft rein PULL"*.

**KORREKTUR AN DER ANKLAGE (erste von drei).** Die Anklage sagte, das Flag sei *"in
`.gitlab-ci.yml`/CMakePresets/Skripten an keiner Stelle gesetzt (grep, 0 Treffer ausser 3
Unit-Test-Targets)"*. **Das ist unvollstaendig und in der Schlussfolgerung falsch:** es gibt eine
**offizielle CMake-Option**.

    CMakeLists.txt:168-170   option(COMDARE_CE_ENABLE_OBSERVER_PUSH "..." OFF)
    CMakeLists.txt:171-173   if(COMDARE_CE_ENABLE_STATISTICS AND COMDARE_CE_ENABLE_OBSERVER_PUSH)
                                 add_compile_definitions(COMDARE_CE_ENABLE_OBSERVER_PUSH=1)

**Zahlen mit Bezugsgroesse:** 24 Funddateien repo-weit, davon **17 Build-Artefakte** (`build*/`),
**2 Doku**, **5 Quellbaum** (`CMakeLists.txt`, `tests/unit/CMakeLists.txt`, `measurable_concept.hpp`,
2 `axis_03a_*`-Header). Aktivierungen: **3 Test-Targets** (`tests/unit/CMakeLists.txt:372, 384,
399`). In `ci/` und `scripts/`: **0 Treffer** (RC=2, kein Verzeichnis-Treffer). In `.gitlab-ci.yml`:
**0**.

**Nebenbedingung, von Codex gefunden und von mir am Objekt bestaetigt:** `COMDARE_CE_ENABLE_STATISTICS`
wird unter `COMDARE_RELEASE_MODE` bzw. `!COMDARE_MEASUREMENT_MODE` **zwangsweise OFF gesetzt**
(`CMakeLists.txt:137-145`). Im Release-/funktional-only-Bau ist das Push-Flag daher wirkungslos --
was korrekt und beabsichtigt ist.

**PRAEZISIERTER DIFF -- die Anklage traf die richtige Luecke mit der falschen Begruendung:**

| | Anklage | Ist |
|---|---|---|
| Das **FLAG** | "nirgends setzbar" | **erreichbar** per `-DCOMDARE_CE_ENABLE_OBSERVER_PUSH=ON`, dokumentierte Option, Default OFF |
| Der **SUBSCRIBER-WEG** | (nicht getrennt betrachtet) | **fehlt** -- 0 produktive `on_event`-Registrierungen ausserhalb `tests/`; die 7 echten Registrierungen liegen alle in den 3 Testquellen |
| Die `.so`-Strecke | -- | ist **PULL** (`observable_tier.hpp:182-203`, `apps/perm_runner/main.cpp:32-47`) |
| Die C-ABI | -- | **hat** einen `notify`-Zeiger (`module_abi_v1.hpp:93-106`), der generierte Modulcode ignoriert `engine`, der produktive Driver uebergibt `nullptr` (`codegen.cpp:33,157,172`; `experiment_driver.cpp:316,468`) |

**Das ist der eigentliche Befund, und er ist schaerfer als der angeklagte:** der Wire-Slot fuer
Push **existiert bereits in der ABI** und wird produktiv mit `nullptr` bedient. Es fehlt also nicht
die Architektur, sondern die Verdrahtung.

**Doktrin-Einordnung:** Zerstoerte geplante Faehigkeit. Die Begruendung *"wird NIE ein Subscriber
gesetzt"* ist die verbotene Form -- sie beschreibt den Ist-Zustand und leitet daraus die
Berechtigung ab, ihn nicht zu aendern. **Aber:** der Default-OFF selbst ist **legitim** (zero-cost
im Hot-Pfad, Apparat-Reinheit Meta #6) -- angeklagt gehoert nicht das Flag, sondern das fehlende
Subscriber-Wiring.

**BAU-ANWEISUNG (nach Abgabe, Aufraeumpass):**
1. Den `notify`-Zeiger der `module_abi_v1` produktiv bedienen statt `nullptr`
   (`experiment_driver.cpp:316,468`) -- ABI-Slot ist vorhanden, kein ABI-Bruch.
2. Im generierten Modulcode `engine` durchreichen statt ignorieren (`codegen.cpp:33,157,172`).
3. Die Kommentar-Zeile `:55-56` **mitziehen** -- sie wird mit Schritt 1 unwahr.
4. Erst dann ist `-DCOMDARE_CE_ENABLE_OBSERVER_PUSH=ON` mehr als ein Test-Schalter.

**OWNER-FRAGE:** Ist der PULL-Weg (`tier_observe`) die **beabsichtigte Ersetzung** der
User-Direktive von 2026-05-25, oder soll Push zusaetzlich verdrahtet werden? Wenn Ersetzung: dann
gehoert die Direktive im Datei-Kopf als **superseded** markiert, statt sie als unerfuelltes SOLL
stehen zu lassen (Doku-nie-loeschen-Doktrin: deprecaten, nicht entfernen). **Diese Entscheidung
kostet nichts und schliesst den Posten sauber.**

**Termin: nach Abgabe.** Beruehrt weder Golden noch Messgueltigkeit.

---

### P-3 [NIVEAU -- VERSCHAERFT gegenueber der Anklage] `COMDARE_LEGACY_MESSREIHEN` -- Pass A (K-10)

**Ort:** `xml_config_parser.hpp:14`, `xml_config_parser.cpp:147`, `test_data_sets.xml:5`.

**IST, Teil 1 -- das zitierte Gate existiert nicht.** Repo-weit (Quellbaum, `build*/` ausgenommen)
**genau 3 Treffer, alle 3 Kommentare**. Kein `#ifdef`, kein `getenv`, keine CMake-`option()` dieses
Namens. Der Code (`xml_config_parser.cpp:147`) rechtfertigt einen stehengelassenen Legacy-Slot mit:
*"bleibt fuer den COMDARE_LEGACY_MESSREIHEN-gated Legacy-Pfad stehen"* -- **er beruft sich auf einen
Schutzmechanismus, den es nicht gibt.**

**IST, Teil 2 -- KORREKTUR AN DER ANKLAGE (zweite von drei), und sie macht den Posten SCHWERER.**
Die Anklage entlastete sich selbst mit: *"der Legacy-Pfad ist durch die leere `test_data_sets.xml`
ohnehin praktisch abgeschnitten"*. **Das ist am Objekt widerlegt** (Codex-Fund, von mir vollstaendig
nachgelesen):

- `test_data_sets.xml` **existiert** und traegt **3 echte Datensaetze**: `ycsb_a` (`:11-16`),
  `ycsb_c_zipfian` (`:18-23`), `commoncrawl_urls` (`:25-30`).
- Der Parser liest die Datei **unbedingt** in den Slot: `xml_config_parser.cpp:149`
  `cfg.test_data_sets = parse_one(root_dir / "test_data_sets.xml");` -- **kein Gate davor**.
- `parse_one` erkennt `test_data_set` ausdruecklich als Eintragstyp (`:175-178`).
- **Es gibt einen lebenden, multiplizierenden Konsumenten:** `permutation_loop.cpp:12-18` --
  `reserve(... * cfg.test_data_sets.size())` und `for (auto const& tds : cfg.test_data_sets)`;
  ebenso `experiment_driver.cpp:109,115`.
- **Und der Default-Konfigpfad zeigt genau dorthin:** `CMakeLists.txt:479-481` setzt
  `COMDARE_BUILDER_CONFIG_DIR` auf
  `${CMAKE_CURRENT_SOURCE_DIR}/libs/cache_engine/builder/example_configs` -- das Verzeichnis, in dem
  die nicht-leere Datei liegt.

**Der Code-Kommentar behauptet zwei Tatsachen ueber die Welt, beide falsch** (`xml_config_parser.cpp:143-145`
und `.hpp:9-15`): *"`test_data_sets.xml` existiert nirgends (0x)"* -- sie existiert -- und der Slot
*"wird NICHT befuellt"* -- er wird mit 3 Eintraegen befuellt.

**Strukturelle Zusatzbeobachtung (nicht angeklagt, aber wichtig fuer die Fix-Richtung):** waere der
Slot wirklich leer, liefe die **innerste** Schleife in `permutation_loop.cpp:18` nie -- `enumerate()`
lieferte **0 Deskriptoren**. Die Datei ist auf diesem Pfad also **lasttragend**, nicht Beiwerk. Ein
"Aufraeumen" durch Leeren der Datei wuerde den Legacy-Treiber **still auf 0 Permutationen** setzen.

**DIFF:** Zwei Doku-Aussagen widersprechen dem Ist; die Begruendung "ist ohnehin gegated" haelt in
**keinem** ihrer beiden Glieder. Das ist die Fehlerklasse, die der Owner-KERN
`feedback_behauptungen_verifizieren_layer_vertraege_halten` und Regel-Zeile (3) aus nachmittag-8
adressieren: *"X existiert nirgends" ist eine VOLLSTAENDIGKEITSAUSSAGE.*

**Warum trotzdem NIVEAU und nicht MESSVALIDITAET:** die **Mess-Strecke der Diplomarbeit** laeuft
ueber den E4-/Profil-Weg (`parse_thesis_profile` / `<datasets>`), nicht ueber das
Legacy-4-Datei-Schema; und der Auto-Run des Builders ist gegatet (`COMDARE_AUTO_RUN_BUILDER`,
Default **OFF**, `CMakeLists.txt:473-475`). **Kein heutiger Messwert haengt daran.** Der Schaden ist
falsches Sicherheitsgefuehl plus ein Ist-Widerspruch in drei Dateien.

**BAU-ANWEISUNG (nach Abgabe, Aufraeumpass -- billig, rein textlich, ausser Punkt 3):**
1. Die drei Kommentare auf den Ist-Stand bringen: das Gate `COMDARE_LEGACY_MESSREIHEN` **gibt es
   nicht** -- entweder ehrlich als "ungegated" ausweisen oder das Gate real bauen.
2. `xml_config_parser.cpp:143-145` und `.hpp:9-15`: die Behauptung "existiert nirgends (0x)"
   streichen, den tatsaechlichen Inhalt (3 Datensaetze) benennen.
3. **Owner-Entscheid noetig, s.u.,** falls das Gate real gebaut werden soll.

**OWNER-FRAGE:** Soll `COMDARE_LEGACY_MESSREIHEN` als echtes Gate gebaut werden (dann: CMake-Option
mit Default OFF plus `#ifdef` um `:149`, und die Konsequenz "0 Permutationen im Legacy-Treiber"
bewusst tragen), **oder** wird der Legacy-Pfad als ungegatet-aber-deprecated ehrlich ausgewiesen und
das Gate-Zitat entfernt? **Empfehlung: Variante 2** -- ein Gate zu bauen, das den einzigen Pfad
seiner eigenen Datei abschneidet, waere Aufwand ohne Faehigkeitsgewinn; die Doktrin verlangt
Ehrlichkeit, nicht zwingend einen Schalter.

---

### P-4 [NIVEAU] `active_telemetry_is_silent()` liefert literal `false` -- Pass B (KK-7)

**Ort:** `libs/cache_engine/profile_facade/profile_run_facade.cpp:240-242` (Rueckgabe), `:505`
(einziger Aufrufer).

**IST, woertlich (`:241`):**

    return false; // Default = Active (TelemetryMode::Active); A9.3 golden-neutral: kein Profil-Wiring (s.o.)

**PLAN-SOLL, am Objekt belegt:** die Profile deklarieren `<telemetry mode="on" silent="true"/>` --
**in 11 Profil-XML** unter `libs/cache_engine/algorithm_profiles/thesis_profiles/`, darunter das
golden-Profil selbst (`all_axes_golden.profile.xml:127`) sowie `m3v2_study.profile.xml:132`,
`m3_golden_coverage.profile.xml:116`, `m3v2_smoke.profile.xml:66`, `cacheline_study.profile.xml:93`
u.a. Der KERN *"E4-XML ist die autoritative Bauanleitung"* wird an dieser Stelle **nicht** erfuellt:
der deklarierte XML-Wert erreicht den Code nicht.

**IST-Begruendung, ehrlich im Code (`:234-239`):** ein Durchreichen haenge `+tel=silent` ans
golden-`build_version` und **breche die Byte-Identitaet**; das Wiring sei *"ein bewusst
golden-BRECHENDER Folge-Schritt (eigene Absprache)"*.

**DIFF:** Der Code weiss, dass er das SOLL nicht erfuellt, sagt es, und verschiebt es. Das ist
**kein stiller Fehler** -- die Herkunft ist dokumentiert und die Absprache existiert. Aber:
Dokumentation allein macht eine aufgeschobene Faehigkeit nicht zu bezahlter Vollstaendigkeit.
Ein **echter** Konsument von `build_system_axis_levels()` haengt an dieser Bedingung (`:500-509`,
Anti-Drift) -- solange `active_telemetry_is_silent()` konstant `false` ist, ist der ganze Block
**toter Code**, und der Registry-Anti-Drift-Beweis, den er erbringen soll, wird nie gefuehrt.

**Doktrin-Einordnung:** Grenzfall, bewusst als NIVEAU eingestuft. Die Faehigkeit ist ausgelassen
(verbotene Seite), aber die Begruendung ist **nicht** "liest niemand", sondern "bricht golden" --
ein echter, bezifferbarer Konflikt mit einer anderen Zusage (Byte-Identitaet). **Solche Konflikte
loest man im dafuer vorgesehenen Fenster, nicht nebenbei.**

**BAU-ANWEISUNG:** gehoert in das **GOLDEN-UPDATE-Fenster**
(`20260806-PLAN-golden-update-fenster.md`), zusammen mit allen anderen golden-brechenden Schritten
-- niemals einzeln, weil jeder Einzelschritt einen eigenen Neu-Anker der golden-Vektoren erzwaenge.
Umsetzung dann: `telemetry_silent` aus dem `ExperimentProfile` durchreichen statt `false` zu
konstantisieren; `+tel=silent` erscheint im `build_version`; golden-Vektoren neu ankern.

**Termin: GOLDEN-UPDATE-Fenster, nach Abgabe. Eigene Owner-Absprache liegt vor.**

---

### P-5 [SAUBERKEIT] `bytes_in_use_peak` traegt den END-Wert -- Pass B (KK-9, Restanteil)

**Ort:** `libs/cache_engine/builder/measurement_snapshot.hpp:53-60` (Deklaration + Begruendung),
`:124` (Zuweisung), `:164`/`:196` (Spaltennamen), `:177`/`:205` (Werte).

**IST:** `m.bytes_in_use_peak = r.observer.axis_stats[6][1]; // END-Wert (bytes_in_use)` (`:124`).
Die Fehl-Etikettierung ist **selbst deklariert** (`:54-59`, "A8-S3 / Befund B7, 2026-08-04"), samt
Begruendung, warum der Name bleibt (CSV-Spaltennamen stabil, Alt-Mess-CSV ist Archiv,
`tools/latex_anhang` liest positions-frei nach Namen) und samt ehrlicher Parallel-Aussage im
WIDE-Schema (`alloc_bytes_in_use_peak == "n/a"`,
`cache_engine_builder_iterator.hpp:515,525`). Zusatzzeile `:122-123` sagt sogar: *"Hier wird bewusst
NICHTS umgerechnet: ein aus dem Momentanwert 'gerechneter' Peak waere die schlimmere Luege."*

**Das ist ueberwiegend die geschuetzte Seite der Grenze** -- eine bezahlte, ehrlich ausgewiesene
Unvollstaendigkeit statt einer geratenen Zahl.

**WAS BLEIBT (und nur das):** die **kanonischen** Serializer `serialize_measurements_csv` (`:156-183`)
und `serialize_measurements_pipeline16_csv` (`:187-208`) schreiben den END-Wert unter dem
Spaltennamen **`bytes_in_use_peak`** -- laut Kommentar (`:186`) die Quelle *"fuer die bestehende
LaTeX-Pipeline 04/05"*. Ein kuenftiger unabhaengiger Konsument dieser 16-Spalten-CSV liest ihn als
Peak. Die ehrliche Gegen-Aussage steht nur im **WIDE**-Schema, nicht in der Pipeline-CSV.

**Gegenprobe zur Anklage (dritte Korrektur):** `tools/latex_anhang/main.cpp` **parst** das Feld,
**gibt es aber in keiner Tabelle aus** -- heute entsteht also kein falsches Anhangs-Bild.
`f15_compare/main.cpp:493,508` weist die Spalte ausdruecklich als honest-0 aus.

**BAU-ANWEISUNG (vor Anhang-Bau, nicht blockierend fuers Messfenster):** Wenn die Spalte in den
Anhang soll -- **entweder** die Spalte in der Pipeline-CSV umbenennen (`bytes_in_use_end`) und die
Stufen 04/05 nachziehen, **oder** eine echte Peak-Quelle erschliessen (Wire-Slot oder periodische
`tier_observe`-Zuege), dann fallen Etikett und Wert zusammen. **Wenn die Spalte nicht in den Anhang
soll:** eine Zeile in der Anhang-Doku, dass sie ausgelassen ist -- und der Posten ist geschlossen.

**OWNER-FRAGE (klein, aber gehoert vor den Anhang-Bau):** Soll `bytes_in_use` ueberhaupt im Anhang
erscheinen? Wenn nein, entfaellt der ganze Posten.

---

## 3. DIE V-POSTEN (Ledger-Zusagen gegen Code)

| # | Ledger-Zusage | Code-Gegenprobe am HEAD `47c4ef1d` | Status |
|---|---|---|---|
| **V-D** | Sec.32-F4 / GN-8 / O-4: "hartes CI-Gate" fuer `axis-version-lock` | **Selbst nachgemessen: ERFUELLT.** Eine unbedingte Definition (`.gitlab-ci.yml:447`), Doppel-Key entfernt, Rueckfall-Wache `ci_yaml_key_guard.sh` als erste Stufe (`:244`). | **GELOEST** (war zum Anklagestand offen) |
| **V-C** | §66-N2 (Z.3499): "BEIDE hart (kein Gate/allow_failure)" | **Zweigeteilt, s.u.** | **teils erfuellt, teils verletzt** |
| **V-B** | nachmittag-2 (05.08.): "Default-Modus-Konsequenz owner-gedeckt (F7)" | F7-Kanon (01.08., Abschn. 6) nennt "opt-in" ausdruecklich als **verworfenen** Vorschlag G-C1. Der Opt-in-Charakter besteht (`COMDARE_BESTANDSLOG` bleibt Env-Gate) -- **aber** durch 1.1 ist belegt, dass es ein **real erreichbares** Opt-in ist, kein totes. | **praezisiert, Schwere von "schwer" auf "leicht"** |
| **V-02** | nachmittag-2: "P11 prueft das Env" | Gegengeprueft: `P11` bezeichnet den **pgrep-Kollisionsschutz** (`.measurement_preflight_no_foreign_driver`), **nicht** eine `COMDARE_BESTANDSLOG`-Pruefung. Die VOR-TRIGGER-CHECKLISTE fuehrt es selbst noch als offen: *"B9 P11-Pre-Flight-CHECKLISTE konsolidieren (pgrep-Exklusivitaet, COMDARE_BESTANDSLOG, ...)"*. | **Absichtserklaerung, kein bestehender Mechanismus** |
| **V-A / V-E** | I-PMC-1 "erledigt" / honest-100%-Doktrin vs. `NullPmcSource` | Gehoert zu KK-1 (eigener Workflow). | **hier nicht geprueft** |
| **V-F** | `bestandslog_active` prueft Existenz statt Wert | Im Bestandslog-Scope bearbeitet (s. 1.8). | **nicht neu aufgerollt** |

### V-C ausfuehrlich -- weil die Anklage hier die Haelfte richtig hatte und die Begruendung fehlte

**Die Anklage sagte:** *"die ce-eigenen `pmc:amd`/`pmc:intel`-Jobs halten §66-N2 korrekt (kein
`allow_failure`, `-DCOMDARE_ENABLE_PMC=ON`) -- die Doktrin ist an der Stelle erfuellt, an der sie
nichts kostet."*

**Am Objekt ist das Ergebnis richtig, die Begruendung aber unvollstaendig -- und die Luecke war
gefaehrlich.** Beide Jobs tragen sehr wohl ein `rules:`-Gate:

    .gitlab-ci.yml:147-151   pmc:amd    rules: - if: '$COMDARE_PMC_LANES =~ /amd/'
    .gitlab-ci.yml:153-157   pmc:intel  rules: - if: '$COMDARE_PMC_LANES =~ /intel/'

Das ist **syntaktisch exakt die Form**, die bei `contract:axis-version-lock` drei Wochen lang einen
Tripwire stillgelegt hat (dort: `rules: - if: $COMDARE_AXIS_LOCK_CHECK == "true"`, Variable
**nirgends gesetzt**). **Die entscheidende Messung ist deshalb nicht die Form, sondern ob die
Variable gesetzt ist.** Gemessen:

    .gitlab-ci.yml:52   COMDARE_PMC_LANES: "amd intel"      <- globaler Pipeline-Default

**6 Treffer repo-weit** (ce, ohne `build*/`): 1 Setzung (`:52`), 1 Doku-Kommentar (`:137`), 2
Gate-Verwendungen (`:151`, `:157`), 2 lesende Skript-Stellen
(`ci_test_coverage_manifest.sh:64`, `ci_test_coverage_guard.sh:245`). **Beide Lane-Namen matchen den
Default** -> beide Jobs sind im Normallauf **instanziiert**, `.pmc` traegt
`-DCOMDARE_ENABLE_PMC=ON` (`:119`) und **kein** `allow_failure`.

**Praezisierte Doktrin-Lesart (aus dem Kommentarblock `:135-143` selbst):** §66-N2 heisst nicht
"bedingungslos beide", sondern **"jede DEKLARIERTE Lane ist hart"** -- `COMDARE_PMC_LANES`
deklariert die Maschinenmenge des Clusters, damit ein anderer Cluster mit nur einer Vendor-Lane
verschiffen kann, ohne eine Phantom-Pflicht auf eine nicht existierende Maschine zu erben.
**Das Gate ist ein DEKLARATIONS-Gate mit gesetztem Default, kein inertes Opt-in.**

> **LEHRE FUER DIE FEHLERKLASSEN-PRUEFLISTE (neu, aus diesem Vergleich):**
> **Zwei `rules: - if: $VAR`-Gates gleicher Form koennen entgegengesetzte Wahrheit haben.**
> Die Form ist kein Befund. Der Befund entsteht erst mit der Messung *"wird die Variable irgendwo
> GESETZT -- und in welchem Scope?"*. `COMDARE_AXIS_LOCK_CHECK`: nirgends -> drei Wochen inert.
> `COMDARE_PMC_LANES`: `.gitlab-ci.yml:52` -> aktiv. **Wer nur die Form sieht, meldet entweder einen
> Fehlalarm oder uebersieht einen echten Stillstand.**

**Fazit V-C:** erfuellt fuer die ce-Jobs `pmc:amd`/`pmc:intel` (mit der obigen, praeziseren
Begruendung); **verletzt am Mess-Batch** (P-1) -- also genau an der Stelle, an der die Doktrin
etwas kostet.

---

## 4. TERMINIERUNG -- was vor die Abgabe gehoert und was nicht

**Frist: Abgabe Fr 08.08., Trigger Do 07.08.**

### 4.1 VOR dem Trigger (Do 07.08.)

| Posten | Warum vor dem Trigger | Aufwand |
|---|---|---|
| **P-1** (`allow_failure` am Mess-Batch) | Es aendert das Verhalten **des Trigger-Laufs selbst**. Danach entdeckt = mehrtaegige Messung mit still gestorbener Lane. | klein im Code (1 Zeile raus + Exit-Code-Trennung + 1 Test), **Owner-Entscheid ist der lange Teil** |
| **KK-1 / PMC** | eigener Workflow, **gleiche Zeilenregion und gleicher Job wie P-1** -> **zwingend dieselbe Welle**, sonst Kollision | s. `20260806-PLAN-p-pmc-1-messkette.md` |

**Ausserhalb dieses Dokuments, aber in derselben Vor-Trigger-Kette** (aus Ledger nachmittag-10
Abschn. F, hier nur als Erinnerung, weil der Paketschnitt buchhalterisch verlorengegangen war):
**LB-6 / Stufe 1 der Lager-Basis-Tests** ist Vor-Trigger-**PFLICHT**, nicht "kann".

### 4.2 VOR dem Anhang-Bau (nicht trigger-blockierend)

| Posten | Entscheid |
|---|---|
| **P-5** (`bytes_in_use_peak`) | Owner-Frage: erscheint `bytes_in_use` im Anhang? Bei **nein** entfaellt der Posten vollstaendig. |

### 4.3 NACH der Abgabe

| Posten | Fenster |
|---|---|
| **P-4** (telemetry silent) | **GOLDEN-UPDATE-Fenster** -- golden-brechend, Absprache liegt vor, niemals einzeln fahren |
| **P-2** (Push-Observer) | Aufraeumpass; Owner-Frage "PULL ersetzt Push?" schliesst ihn ggf. **ohne Bau** |
| **P-3** (`COMDARE_LEGACY_MESSREIHEN`) | Aufraeumpass; Empfehlung Variante 2 = rein textliche Heilung |
| K-09-Restluecke (Validierungsabdeckung `target_isa`) | Aufraeumpass F3/F5/R4 |
| `present_`-Gate + Formwachen-Verfeinerung (1.8) | nach Abgabe, mit Option 2 der Plan-Ablage -- **bereits entschieden** |

### 4.4 Die drei offenen OWNER-FRAGEN, gesammelt

1. **P-1 (blockierend, vor Trigger):** Darf ein Mess-Batch-Job die Pipeline rot faerben? Der
   Vorschlag in P-1 erfuellt Zell-Sichtbarkeit **und** §66-N2 gleichzeitig -- er braucht nur ein GO.
2. **P-2 (nicht blockierend):** Ersetzt der PULL-Weg die User-Direktive von 2026-05-25 dauerhaft?
   Bei **ja** genuegt ein superseded-Vermerk im Datei-Kopf, kein Bau.
3. **P-3 (nicht blockierend):** Gate real bauen oder Legacy-Pfad ehrlich als ungegatet ausweisen?
   **Empfehlung: ausweisen.**

---

## 5. BELEGBASIS UND METHODIK

- **Reihenfolge (Owner-Anordnung eingehalten):** zuerst Planung + Ledger rueckwaerts ab Z.4202
  (nachmittag-10 -> nachmittag-9 -> nachmittag-8 -> nachmittag-6 -> nachmittag-5), **dann** der Code.
  Juengste Fassung gilt.
- **Jede Fundstelle** in diesem Dokument per `Read` bzw. `/usr/bin/grep -n` (absolut, GNU grep 3.11
  -- nicht die ugrep-Shell-Funktion, s. Ledger nachmittag-6 Abschn. C) am HEAD `47c4ef1d`
  **selbst gelesen**, nicht aus Berichten uebernommen.
- **Jede Zahl mit Bezugsgroesse** angegeben (24 Funddateien davon 17 Build-Artefakte; 3 von 3
  Treffern Kommentare; 11 Profil-XML; 6 Treffer `COMDARE_PMC_LANES` in 5 Dateien).
- **Codex-Gegenpruefung** (`mcp__codex__codex`, `approval-policy:never`,
  `sandbox:workspace-write`, `cwd=Code/external/comdare-cache-engine`, Thread
  `019fd888-24c1-7232-a6c6-a815fd1580aa`, **kein `git`**) ueber die vier Posten mit Delta zur
  Anklage. Ergebnis: 1x BESTAETIGT (P-1), 3x PRAEZISIERT (P-2, V-C, P-3).
- **Codex meldete ehrlich**, dass seine Sandbox `grep`/`sed`/`cat` vor dem Prozessstart blockierte
  und es gegen einen Read-only-Spiegelstand `e7aa1244` las. **Deshalb ist jede Codex-Aussage, die in
  dieses Dokument eingegangen ist, von mir am HEAD `47c4ef1d` gegengelesen worden** -- insbesondere
  der P-3-Fund (`test_data_sets.xml` nicht leer), der den Posten verschaerft.
- **Kein Worktree unter `/home/comdare/wt-*` beruehrt.** Gelesen wurde ausschliesslich der
  super-Arbeitsbaum und das ce-Submodul darunter.
- **ASCII-Deklaration (damit es keine stille Annahme bleibt):** dieses Dokument ist ASCII-only mit
  **genau einer** bewussten Ausnahme -- dem Paragraf-Zeichen in den Zitier-Tokens `§66-N2`, `§41`,
  `§62-B`. Das ist der korpus-kanonische Bezeichner dieser Festlegungen (er steht so im Ledger
  **und** im zitierten Code-Kommentar `experiment_plan_director.hpp:1360`); ihn zu ersetzen wuerde
  die Auffindbarkeit gegen Ledger und Quelltext brechen. Gemessen: `grep -nP '[^\x00-\x7F]'` liefert
  **9 Zeilen, alle 9 nur wegen dieses einen Zeichens**, 0 sonstige Nicht-ASCII-Zeichen.
- **Drei Korrekturen an der Anklage selbst** (Owner-Zeile "jede Aussage gegen den Code"):
  (1) P-2 -- die CMake-`option()` existiert, das Flag ist erreichbar;
  (2) P-3 -- `test_data_sets.xml` ist **nicht** leer, der Posten wird dadurch **schwerer**;
  (3) V-C -- die PMC-Jobs **haben** ein `rules:`-Gate, es ist nur nicht inert.

---

## 6. BILANZ

**Fuenf offene Posten** (P-1 Messvaliditaet / P-2 zerstoerte Faehigkeit / P-3 + P-4 Niveau /
P-5 Sauberkeit), **davon genau einer vor dem Trigger** (P-1, gebuendelt mit KK-1).

**Sieben Entlastungen**, davon drei am heutigen Objekt neu gewonnen: K-01/KK-2 (widerlegt),
K-05/KK-3 + V-D (geheilt), K-04 (umklassifiziert zu geschuetzter bezahlter Vollstaendigkeit).
Sie sind der wertvollste Teil dieses Dokuments, weil jede von ihnen einen Bau-Auftrag streicht,
den die Anklage erzeugt haette.

**Die Doktrin hat in beide Richtungen gearbeitet:** sie hat P-1 und P-2 als echte Auslassungen
freigelegt -- und sie hat K-04 und P-5 davor bewahrt, als "Kosten" wegoptimiert zu werden, obwohl
sie genau das sind, was die Doktrin schuetzen soll.
