# Warnungen und Ausgabe bei Messfehlern -- wenn ein Wert da ist, aber nicht traegt

> **Erhebungsstand:** 2026-08-06, spaeter Abend.
> **Quellstaende, am Objekt geprueft:** ce-Arbeitsbaum `/home/comdare/wt-landung`, Branch
> `development`, HEAD **`2b5ecd29`** (`fix(pmc): m3v2_pmc_smoke misst jetzt ein echtes Fenster
> statt eines leeren Batches`, 06.08. 22:10); `22e17f57` (errno-Kanal) ist Vorfahr
> (`git merge-base --is-ancestor` -> `YES`). Zweitklon
> `Code/external/comdare-cache-engine` steht auf `90bca126` und traegt beides **nicht**.
> **Modus:** READ-ONLY erhoben. Kein Edit, kein Commit, kein Worktree-Eingriff; diese Datei ist
> die einzige geschriebene.
> **Suchen** ausschliesslich mit `/usr/bin/grep` (der Shell-`grep` ist auf ugrep umgebogen und
> liefert bei manchen Mustern still 0).
> **SSOT:** `docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md` (im Folgenden `LEDGER:<Zeile>`).
>
> **Schwesterdokument, das NICHT wiederholt wird:**
> `docs/plaene/20260806-PLAN-hybrid-architektur-pmc-achsen-zuordnung.md` ordnet die
> **Achsen-Zugehoerigkeit** der Hybrid-/PMU-Frage und schlaegt die Konfigurations-Spalten
> `pe_policy` / `ran_on_core_type` / `pmu_domain` vor (dort Abschnitt 5.3, Zeilen 803-808).
> **Dieses Dokument ist dazu komplementaer:** es behandelt nicht, WO die Achse haengt, sondern
> **welchen ZUSTAND ein Messwert haben kann und wie dieser Zustand ausgegeben wird.** Wo beide
> Dokumente dieselbe Spalte nennen, ist die Nennung hier bewusst deckungsgleich.

---

## 1. Der Owner-KERN und was er festlegt

**Owner, 2026-08-06, verbatim:**

> "hat eine CPU nicht das pinning Feature (zusammen mit einem OS Kernel der das auch
> unterstuetzen und durchreichen muss), kann eine Maschine nicht pinnen und **muss die PMC Werte
> tatsaechlich mit der Warnung ausgeben, dass die Werte nicht tragen, weil der Ort der
> Ausfuehrung nicht bekannt ist**."

Vier Festlegungen, die im Folgenden nicht mehr hinterfragt werden:

| # | Festlegung | Ausschluss, den sie mit sich bringt |
|---|---|---|
| K-1 | Die Werte **werden ausgegeben** | Kein Unterdruecken, kein Weg-Filtern, kein `failed` |
| K-2 | Die Warnung ist **Pflicht** | Kein stillschweigendes Fuehren als gueltiger Messwert |
| K-3 | Grund ist der **unbekannte Ort der Ausfuehrung** | Nicht "Messfehler", sondern **Unbestimmtheit** |
| K-4 | Faehigkeit haengt an **CPU UND OS-Kernel**, beide zur Laufzeit geprueft | Keine statische Annahme (Owner-Regel `feedback_hardware_erkennung_factory_laufzeit_nie_statisch`) |

### Die Unterscheidung, um die es geht

Ein Wert kann **da** sein und trotzdem **nicht tragen**. Das ist ein dritter Zustand neben
"gemessen" und "fehlt" -- und genau dieser dritte Zustand hat im heutigen System **kein Wort**.

Die kanonische Zell-Taxonomie kennt vier Nicht-Zahl-Token
(`libs/cache_engine/include/cache_engine/measurement/axis_error.hpp`, von mir gelesen):

- `axis_error.hpp:143-151` -- `sample_status_token`: `Ok -> "ok"` (Aufrufer rendert die Zahl),
  `NotApplicable -> "n/a"`, `SourceUnavailable -> "n/a"`, `Failed -> "failed"`.
- `axis_error.hpp:172-178` -- `admission_status_token(Gesperrt) -> "gesperrt"`.
- `axis_error.hpp:183-188` -- `build_cell_status_token(NichtGebaut) -> "nicht_gebaut"`.

Und ihre tragende Drei-Wege-Definition, `axis_error.hpp:115-117` verbatim:

```
//   failed       (D2, SampleStatus)     = GEMESSEN und dabei GESCHEITERT,
//   gesperrt     (D1, AdmissionStatus)  = gebaut/baubar, aber NICHT ZUGELASSEN, deshalb nicht gemessen,
//   nicht_gebaut (D1, BuildCellStatus)  = es gibt gar keine Binary, der Bau selbst ist gescheitert.
```

**Der Owner-Fall ist keins davon.** `failed` waere falsch (es wurde gemessen), `n/a` waere falsch
(es liegt eine Zahl vor), `gesperrt`/`nicht_gebaut` sind D1-Aussagen ueber den Bau. Es fehlt eine
**fuenfte Semantik: Zahl vorhanden, Geltung unbestimmt.**

### Die Doktrin, in die sich das einordnet -- Wortlaut, Fundstelle, Stand

**Wortlaut** (Owner 2026-07-16), Memory
`~/.claude/projects/-home-comdare/memory/feedback_measurement_failure_visibility_csv_failed_not_null_plus_log.md`,
kanonisiert in `LEDGER:1550` (§16.2-M4):

> "In der Wissenschaft geht nicht immer alles glatt, aber das muss SICHTBAR sein." Scheitert ein
> Achsen-Algorithmus (Crash/Exception/nicht-lauffaehig), steht in der Messwert-Zelle "failed" --
> NICHT null/0; zusaetzlich wird neben der CSV ein Log aggregiert, der den Experiment-Fortschritt
> DIESER CSV dokumentiert. [...] Der Harness faengt per-Algorithmus-Fehler -> Zelle="failed" +
> Log -> misst weiter (kein Lauf-Abbruch).

Primaereintrag `LEDGER:524` (2026-07-16 SPAET+++, autoritativ, woertlich "**failed** statt
null/0" + "neben der CSV aggregierter Log"). **Kein Superseded-Vermerk** an §16.2-M4, LED:524
oder LED:2913 gefunden.

**Umsetzungsstand -- der Ledger sagt es selbst.** `LEDGER:1553` bewertet die **Dokumentation**
("**VOLL DOKUMENTIERT** (keine Luecke)"), `LEDGER:2913` bewertet die **Umsetzung**:

> "- **[§16.2-M4]** Fehler-Sichtbarkeit -- CSV-Zelle 'failed' (nicht null) + aggregierter Log
> (bindende User-Doktrin, in §48 nur implizit ueber Fehlerklassen abgedeckt) (**TEIL, hoch**)."

Das ist kein Widerspruch, sondern zwei Aussagen ueber zwei Dinge. **LED:2913 ist die zutreffende
Aussage ueber den Code**, und dieses Dokument sagt, woran genau der Rest fehlt.

---

## 2. DIE ZUSTANDS-LEITER

**Das ist die eigentliche Leistung dieses Dokuments.** Ohne diese Trennung ist jede Warnung
beliebig: eine Warnung, die nicht sagt, WOVON sie den Wert unterscheidet, ist nur Rauschen mit
gutem Gewissen.

### 2.0 Der Befund, der die Leiter erzwingt: heute sind es DREI orthogonale Achsen, gefaltet in EINE Zelle

Am Objekt lassen sich drei voneinander unabhaengige Fragen unterscheiden:

| Achse | Frage | Heute ausdrueckbar? |
|---|---|---|
| **A -- Existenz** | Steht in der Zelle eine Zahl oder ein Marker? | JA (`zell_ersatz`, `cache_engine_builder_iterator.hpp:574-586`) |
| **B -- Grund der Abwesenheit** | Warum steht keine Zahl da? | TEILWEISE -- `n/a` faltet **zwei** Gruende (`axis_error.hpp:147-148`) |
| **C -- Geltung eines VORHANDENEN Werts** | Traegt die Zahl, die da steht? | **NEIN als System** -- nur drei ad-hoc-Einzelfaelle |

Die drei ad-hoc-Faelle der Achse C existieren bereits und sind der Beweis, dass die Achse
gebraucht wird:

1. `two_phase_valid` -- `cache_engine_builder_iterator.hpp:317` verbatim:
   `// two_phase_valid=false => Messung UNGUELTIG (nicht als valide werten).` Eine eigene
   CSV-Spalte (`:462`), gerendert bei `:721`. **Eine Zahl steht da, und eine Nachbarspalte sagt,
   dass sie nicht traegt.** Das ist bereits exakt die vom Owner verlangte Form.
2. `quality_flag` -- `cache_engine_builder_iterator.hpp:806-820`: statistischer
   Median-Multiplikator-Ausreisser, "REIN STATISTISCH + DATENERHALTEND: setzt ausschliesslich das
   additive row.quality_flag-Feld (0/1), beruehrt KEINE bestehende Spalte/keinen Messwert" (`:815-816`).
3. `scaled_` -- `linux_perf_pmc_source.hpp:346` verbatim:
   `bool scaled_ = false; ///< >=1 gelesener Wert wurde multiplex-hochskaliert (Schaetzung)`.
   Drei Schreibzugriffe (`:283`, `:292`, `:300`), **null Lesezugriffe**. Der Vorbehalt "dieser Wert
   ist hochgerechnet" wird korrekt erhoben und **nirgends ausgegeben**.

Dazu das eine **vollstaendig gebaute** Vorbild ausserhalb der Messwerte,
`libs/cache_engine/include/cache_engine/measurement/ram_frequency_reading.hpp:53-67` (gelesen):

```
enum class RamFrequencyProvenance : std::uint8_t {   // "geordnet: kleinerer Wert = hoeheres Vertrauen"
    ConfiguredMeasured  = 0, // Stufe 1: konfigurierter Ist-Takt (privilegierte Quelle)
    SpdJedecBase        = 1, // Stufe 2: JEDEC-Nennrate aus dem SPD-EEPROM (unprivilegiert)
    DeclaredNotMeasured = 2, // Stufe 3: Deklarationswert der Anwender-XML
};
enum class RamReadingState : std::uint8_t {          // "bewusst getrennt vom Stufen-Ranking"
    NichtErhoben = 0, // Default: es liegt KEIN Wert vor (nie als 0 MT/s lesen)
    Erhoben      = 1, // ein Wert liegt vor; seine Herkunft steht in der Provenienz
};
```

**Genau diese Trennung -- ZUSTAND (Achse A/B) getrennt vom VERTRAUENSRANG (Achse C) -- ist die
Antwort auf den Owner-KERN.** Sie ist gebaut, in der Thesis beschrieben
(`thesis/diplomarbeit/kapitel/de/03_messsystem_prtart.tex:1115-1121`) und bisher **auf
RAM-Frequenz beschraenkt, nie auf Messwerte generalisiert.**

### 2.1 DIE LEITER

Kurzlegende der Spalte "heute": *Zelle* = was in der CSV-Zelle steht; *unterscheidbar von* =
wovon der Leser diesen Zustand am Ist **nicht** trennen kann.

| # | Zustand | Bedeutung, praezise | HEUTE ausgegeben als | SOLL ausgegeben als | Unterschieden vom Nachbarn durch |
|---|---|---|---|---|---|
| **1** | **gemessen** | Wert erhoben, Quelle live, Kontext gueltig | Die Zahl (`zelle(...)`, z.B. `:744-756`) | Die Zahl + `mess_geltung=voll` | `mess_geltung` = `voll` (nicht `ort_unbestimmt`, nicht `hochgerechnet`) |
| **2** | **echt 0** | Gemessen; **das Ergebnis IST null**. Ein Messwert, kein Fehlen | `0` -- **byte-identisch zu 4/5/7** im PMC-Block | `0` + `mess_geltung=voll` + Wert-Status `ok` | Nur durch den **per-Metrik-Status**: `0` mit `ok` vs. Marker bei 4/5. Heute unmoeglich |
| **3** | **nicht anwendbar (N/A)** | Die Groesse ergibt fuer **diese Konfiguration** keinen Sinn (kein Fehler) | `n/a` (`axis_error.hpp:147`), Log `nicht_anwendbar` (`:161`) | unveraendert `n/a`, Log `nicht_anwendbar` | Vom Nachbarn 4 **nur im Log**, in der Zelle gefaltet |
| **4** | **Quelle fehlt** | Der Zaehler **existiert auf dieser Hardware nicht** (ENOENT-Fall) | **`0`, mit `pmc_available=1`** -- s. §5 | `quelle_fehlt` in der **Wertzelle**, Log `quelle_nicht_verfuegbar` | Eigener Zell-Token statt `n/a`; von 2 durch Marker statt Zahl |
| **5** | **nicht erhoben** | Die Quelle war da, wurde aber **nicht gefragt** | `n/a` -- bewusst, `:793-800` (T6-Speicher) | `nicht_erhoben` (eigener Token) | Von 4 durch "Quelle da, Frage nicht gestellt"; heute in `n/a` mit 3 und 4 verschmolzen |
| **6** | **erhoben, aber unbestimmt** | **DER NEUE FALL.** Gemessen; der **Ort der Ausfuehrung** ist unbekannt, weil nicht gepinnt werden konnte | **Nichts.** 0 von 184 Spalten (s. §3.1) | **Die Zahl** + `mess_geltung=ort_unbestimmt` + `mess_vorbehalt=<Code>` | Die Zahl steht da (nicht 4/5/7), aber `mess_geltung != voll` (nicht 1) |
| **6b** | **erhoben, hochgerechnet** | Wert liegt vor, ist aber **Multiplexing-Schaetzung** | **Nichts.** `scaled_` hat 0 Lesezugriffe | Die Zahl + `mess_geltung=hochgerechnet` | Wie 6, anderer Vorbehalts-Code |
| **6c** | **erhoben, Kontext ungueltig** | Gemessen, aber der Mess-Kontext traegt nicht (Kalt-Messung) | `two_phase_valid=0` (eigene Spalte, `:721`) | `mess_geltung=kontext_ungueltig`, Spalte bleibt zusaetzlich | Bereits heute unterscheidbar -- **das Vorbild** |
| **7** | **fehlgeschlagen** | Der Messversuch **brach ab** (OOM/Exception/Gate-Fail) | `failed` in **24 von 184** Spalten; die 9 PMC-Spalten tragen literale `0` | `failed` **zeilenweit**, wie `nicht_gebaut` es schon tut | Marker statt Zahl; von 4/5 durch "es wurde versucht und lief schief" |
| **8** | **gesperrt** (D1) | Baubar, aber auf dieser Maschine **nicht zugelassen** -- nicht gemessen | `gesperrt` (`axis_error.hpp:175`) | unveraendert | D1 statt D2: die Entscheidung fiel **vor** der Messung |
| **9** | **nicht gebaut** (D1) | Es gibt **keine Binary** | `nicht_gebaut`, **175 von 184** Spalten | unveraendert (Referenz-Implementierung fuer 7) | Es gab nie etwas zu messen |

**Belegte Rand-Zahlen.** Die Spaltenzahl 184 und die Reichweiten 24/175/9 stammen aus der
compilierten Vorerhebung gegen `ex::lazy_csv_header()` / `ex::format_csv_row()` (literale Ausgabe
`HEADER_COLS=184` / `ROW_COLS=184`). **Ich habe davon den MECHANISMUS selbst nachgeprueft, nicht
neu gezaehlt:**

- Nur zwei Bloecke lesen `cell_failed`: `cache_engine_builder_iterator.hpp:632`
  (`} else if (cell_failed) { out += "failed;failed;failed;"; }`) und `:787-788`
  (`} else if (cell_failed) { out += "failed"; }`) -- das sind die 18 `op_*_{n,p50,p99}` und die
  6 `op_*_p999_ns`.
- Der zeilenweite Ersatz `zell_ersatz` (`:574-586`) greift **ausschliesslich** bei
  `NichtGebaut` / `SourceUnavailable` / `NotApplicable` -- `Failed` ist dort **nicht** gelistet.
- Die PMC-Zellen `:744-756` und `:777` gehen durch `zelle(...)`, also **nicht** durch die
  `cell_failed`-Kaskade. In einer `failed`-Zeile rendern sie `std::to_string(0)`.

**Die Doktrin ist damit im PMC-Block nicht erfuellt.** `perm_runner.hpp:174` behauptet verbatim
`// genullter POD -> CSV rendert "failed" (nicht 0)`. Fuer die 24 op-Spalten stimmt das. Fuer die
9 PMC-Spalten und die Observer-Zaehler **stimmt es nicht** -- dort steht die stille Null, die
`axis_error.hpp:141-142` ausdruecklich verbietet:

> "Unbekannt -> "failed" (**sicherer Default: NIE eine stille Null, "Messung nie als Nullen"**)."

### 2.2 Was die Leiter mit den vorhandenen Enums macht

**Nichts wird ersetzt.** `SampleStatus` bleibt die Achse A/B, unveraendert und weiter
compile-hart gegen die D1-Vokabeln verwacht (`axis_error.hpp:311-333`). Die Leiter **ergaenzt**
zwei Dinge:

1. **Achse B feiner:** die Zell-Faltung `NotApplicable`/`SourceUnavailable` -> beide `"n/a"`
   (`axis_error.hpp:147-148`) wird aufgetrennt, weil genau diese Faltung den ENOENT-Fall
   verschwinden laesst. Der Log unterscheidet bereits (`:161-165`
   `nicht_anwendbar` / `quelle_nicht_verfuegbar`) -- die Zelle soll nachziehen. Zustand 5
   ("nicht erhoben") bekommt einen eigenen Wert, statt weiter unter `SourceUnavailable` zu
   reisen wie heute bei `:796` (T6-Speicher).
2. **Achse C neu, nach dem RAM-Vorbild:** eine **geordnete** Geltungs-Stufe (kleiner = hoeheres
   Vertrauen), strukturell **getrennt** vom Zustand -- exakt die Begruendung aus
   `ram_frequency_reading.hpp:69-71`: *"NIMMT NUR eine Provenienz an: der Zustand NichtErhoben ist
   hier strukturell nicht ausdrueckbar, weil er kein Vertrauen beschreibt."*

Vorgeschlagene Form (Namen zur Owner-Abnahme, s. §8/W-2):

```
enum class MessGeltung : std::uint8_t {   // Achse C -- nur fuer VORHANDENE Werte
    Voll              = 0, // gemessen, Ort bekannt, Kontext gueltig
    Hochgerechnet     = 1, // Multiplexing-Skalierung (scaled_)  -> Zustand 6b
    OrtUnbestimmt     = 2, // nicht gepinnt / Kerntyp unbekannt   -> Zustand 6   <== OWNER-KERN
    KontextUngueltig  = 3, // two_phase_valid=false u. a.         -> Zustand 6c
};
```

Der Fail-safe-Default gehoert **auf die unsicherste Stufe**, exakt nach dem Muster von
`system_axis.hpp:144-149` (`SampleStatus status = SampleStatus::SourceUnavailable;` mit der
Begruendung *"eine default-konstruierte, nie collectete Sample ist NIE gueltig [...] sonst laese
ein vergessener collect()-Aufruf als 'gueltige Messung mit dem Wert 0'"*). Fuer die Geltung heisst
das: Default **nicht** `Voll`, sondern `OrtUnbestimmt` -- solange niemand nachgewiesen hat, dass
gepinnt wurde, ist der Ort unbekannt. **Das ist am Ist die Wahrheit fuer 100 % aller Zeilen** (§4).

---

## 3. Wo die Warnung erscheint

> Eine Warnung, die nur im Log steht, erreicht die Auswertung nicht.
> Eine, die in jeder Zelle steht, ist Rauschen.

### 3.1 Was der Plan vorsieht -- und wo er schweigt

| Traeger | Was der Plan sagt | Beleg | Verdikt |
|---|---|---|---|
| **CSV-Zelle** | Marker statt Zahl bei `failed`/`n/a`/`gesperrt`/`nicht_gebaut` | `LEDGER:1550`, `axis_error.hpp:141-151` | **Vorgesehen, TEIL gebaut** |
| **Eigene Spalte** | -- kein Plan-Eintrag fuer eine Warn-Spalte -- | s. Nenner unten | **PLAN SCHWEIGT** |
| **Log** | "neben der CSV **aggregierter** Log" (Doktrin) + Planer-WARNUNGEN ins Log/CLI-Shell | `LEDGER:1550`, `LEDGER:3310` | **Vorgesehen, TEIL gebaut** |
| **Stempel** | Achsen + Versionen als Kurzform-Legende; **kein Warnungs-Feld** | `LEDGER:3122`; `cache_engine_builder_iterator.hpp:933,973-981` (`resume-v6|build=...|series=...`) | **Bewusst kein Traeger** |
| **xlsx-Legenden-/INFO-Sheet** | Inhalt = "Sysinfo der testenden Maschine + verwendete Haupt-Achsen" | `docs/sessions/20260726-SESSION-achsen-neuordnung-lager-baeume-xlsx-regressionen.md:93-97`; `LEDGER:5949` | **Ort existiert, Warnung nicht vorgesehen** |
| **Thesis-Anhang** | `sec:measurements:limitations` + auto-generierte Longtable, Zeile 1 = PMC | `thesis/diplomarbeit/anhang/de/A_measurements.tex:282-286`; `Code/04_csv_to_latex/csv_to_latex.cpp:951,957-958` | **Vorgesehen und gebaut, aber hartkodiert** |

**Der einzige Ort, an dem der Plan das Wort WARNUNG explizit vergibt**, ist der Planer-Log --
`LEDGER:3310` verbatim:

> "Verlangt die XML Achsen, die physisch als System-Achsen-Algorithmen nicht existieren (z.B.
> AVX512-Flags), **schreibt der Planer WARNUNGEN ins Log bzw. auf die spaetere CLI-Shell (R3/#34)
> -- kein Vorfilter, keine stille Auslassung.**"

Gekoppelt mit `LEDGER:2492` ("**NUR maschinenseitig mit WARNUNG (Fehlerklasse
HardwareErweiterungFehlt, es wird weitergemessen), NIE als stiller Profil-Filter**") ergibt das
die **Richtung**, die der Owner-KERN fortschreibt: *ausgeben + warnen, nie filtern*. Aber sie
endet am Log.

**NICHT-GEFUNDEN, mit Nenner und Gegenprobe** (aus der Vorerhebung, Suchmethode nachvollzogen):
Von **184** Header-Spalten enthaelt **0** die Zeichenfolge `warn`/`caveat`/`vorbehalt`.
Gegenprobe an derselben Pruefung: `valid -> JA` (`two_phase_valid`), `avail -> JA`
(`pmc_available`) -- die Suche findet, wenn es etwas gibt. `/usr/bin/grep -rli "Ort der Ausf"
docs/` -> **0**, Gegenprobe `/usr/bin/grep -rli "Warnung" docs/` -> **574 Dateien**.

**Und der "aggregierte Log neben der CSV" existiert als Datei nicht.** Der CSV-Schreiber oeffnet
nur die CSV (`profile_facade/profile_run_entry.hpp:555-560`); die klassifizierten Meldungen gehen
auf `std::cerr` (`harness/perm_runner.hpp:176-179`, `:349-351`) und werden vom generierten
CI-Code nach `$LOGDIR/perm<N>_mess.log` umgeleitet
(`builder/experiment_tree/experiment_plan_director.hpp:1466-1472`). Das ist eine
**Prozess-Ausgabe-Umleitung**, keine der CSV zugeordnete Fehler-Aggregation.

### 3.2 Vorschlag: die kleinste ehrliche Form

Fuenf Stuecke, sonst nichts. Jedes traegt genau eine Aufgabe:

**(F-1) Die Wertzelle traegt den Marker -- auch im PMC-Block.**
Kein neuer Mechanismus: die Zellen `:744-756`/`:777` gehen heute durch `zelle(...)` und damit nur
durch `zell_ersatz`. Sie brauchen einen **per-Metrik-Status** statt des zeilenweiten
`pmc_available`. Begruendung am KERN: `pmc_available=1` ist heute wahr, sobald **irgendein**
Zaehler geliefert hat (`linux_perf_pmc_source.hpp:320` `c.available = any;`) -- und `any` wird von
L1D gesetzt (`:282`), waehrend L3 nie geoeffnet wurde. **Ein Bit fuer sieben Felder kann die
Unterscheidung strukturell nicht tragen** (`pmc_source.hpp:19-28`).

**(F-2) `failed` wirkt zeilenweit, wie `nicht_gebaut` es schon tut.**
Ein-Zeilen-Aenderung an der Kaskade `:574-579`: `Failed` in dieselbe `zell_ersatz`-Logik heben,
mit der bereits dokumentierten Vorrang-Ordnung (`:571`: *"VORRANG: (a) vor (b) vor gesperrt vor
failed"*). **Ausnahme unveraendert**: die 9 Identitaets-/Lauf-Tag-Spalten, die
`tests/unit/test_fk1_nicht_gebaut_marker.cpp:114-118` als Menge fuehrt.

**(F-3) ZWEI additive END-Append-Spalten fuer Achse C -- nicht mehr.**

| Spalte | Inhalt | Warum genau diese Form |
|---|---|---|
| `mess_geltung` | ein Token aus `MessGeltung` (`voll`/`hochgerechnet`/`ort_unbestimmt`/`kontext_ungueltig`) | **Maschinenlesbar filterbar.** Eine Auswertung kann `WHERE mess_geltung='voll'` fahren, ohne Prosa zu parsen |
| `mess_vorbehalt` | kompakte Code-Liste, `-` wenn keiner (z.B. `pin_nicht_moeglich,kern_typ_unbekannt`) | **Der Grund.** Ohne ihn ist die Stufe nicht handlungsfaehig; als Liste, weil Vorbehalte sich haeufen |

Das ist **eine Spalte pro Zeile, nicht pro Metrik** -- deshalb kein Rauschen. Es ist genau das
Muster, das `two_phase_valid` und `quality_flag` bereits etabliert haben. Und es ist
**END-Append**, also durch die bestehende Doktrin gedeckt,
`cache_engine_builder_iterator.hpp:496-497` verbatim:

> "Alle vier Bloecke sind END-Appends nach exakt dem Muster von series/PMC/fairness\_mode: keine
> bestehende Spalte wird umbenannt oder verschoben, alte CSVs lesen sie header-getrieben
> leer/n-a (Datenerhaltung)."

**(F-4) Der aggregierte Log als DATEI neben der CSV** -- `result.log` neben `result.csv`, im
selben Verzeichnis, geschrieben vom selben Schreiber (`profile_run_entry.hpp:555-560`). Das ist
die fehlende Haelfte der Doktrin; sie ist woertlich verlangt ("**neben der CSV** aggregierter
Log") und heute nicht vorhanden. Zeilenform: die bereits gebaute klassifizierte Form aus
`builder/pruef_dock/dock_error_classification.hpp:112`
(`"Mess-Fehler[<klassen_etikett>] modul=<name> transport=<roher_status_name> zelle=failed"`),
erweitert um Vorbehalte statt nur Fehler. **stderr bleibt zusaetzlich** -- der Log ersetzt es
nicht, er aggregiert.

**(F-5) Das xlsx-INFO-Sheet bekommt einen VORBEHALTS-BLOCK -- abgeleitet, nie Quelle.**
Der Plan sieht dort "Sysinfo + Haupt-Achsen" vor
(`20260726-SESSION-...xlsx-regressionen.md:93-97`) und der Owner-KERN 06.08. macht das
Legenden-/Info-Sheet zur **Stempel-Erkennungsquelle** (`LEDGER:5949`). Ein
Vorbehalts-Block ist dort die **Zusammenfassung** der `mess_geltung`-Spalte ueber alle Zeilen des
Blatts ("N von M Zeilen: ort_unbestimmt"). **Nie umgekehrt**: die Wahrheit steht in der Zeile,
das Blatt zaehlt nur.

**Was ausdruecklich KEIN Traeger wird: der Stempel.** Der Resume-Stempel
(`cache_engine_builder_iterator.hpp:933,973-981`) und das Provenienz-Manifest
(`builder/provenance_manifest.hpp:74-95`, 16 Felder: `compiler_id`, `compiler_version`,
`cxx_flags`, `isa_built_for`, `isa_ran_on`, `cpu_*`, `cache_line_bytes`, `allocators`,
4x `git_sha_*`) tragen **Identitaet und Konfiguration**, kein Urteil ueber einen Lauf. Ein
Vorbehalt ist ein Lauf-Ergebnis und gehoert in die Zeile. *(Abgrenzung: `pe_policy` -- **worauf
gepinnt werden SOLLTE** -- ist Konfiguration und gehoert nach dem Schwesterdokument sehr wohl in
Stempel + Spalte; `mess_geltung` -- **ob es geklappt hat** -- ist Ergebnis und gehoert nur in die
Spalte.)*

---

## 4. Die Pinning-Faehigkeitspruefung

### 4.1 Der Ist-Stand: der Aktuator existiert und ist stumm

`libs/cache_engine/builder/measurement/thread_pinning.hpp` (105 Zeilen, von mir vollstaendig
gelesen). Der Linux-Zweig, `:52-64`:

```
        if (core >= static_cast<unsigned>(CPU_SETSIZE)) return;
        cpu_set_t previous{};
        if (::sched_getaffinity(0, sizeof(previous), &previous) != 0) return;
        cpu_set_t target{};
        CPU_ZERO(&target);
        CPU_SET(core, &target);
        if (::sched_setaffinity(0, sizeof(target), &target) != 0) return;
        previous_mask_ = previous;
        active_        = true;
```

**Drei getrennte Fehlerursachen, ein einziger stummer Ausgang.** Die einzige Aussage nach aussen
ist `active()` (`:38`) -- ein `bool`, das "Core-Index zu gross", "Maske nicht lesbar", "Setzen
abgelehnt" und "gar nicht versucht (`NoPinPolicy`, `:96-98`)" zu **einem** `false` verschmilzt.
Kein `errno`, kein Log, keine Fehlerklasse. **Und keine Rueckpruefung**: nach
`sched_setaffinity` wird die Maske nicht erneut gelesen.

**Der Test kann bereits, was der Produktionscode nicht kann** --
`tests/unit/test_ap13_thread_pinning.cpp:171` (Vorab-Faehigkeitspruefung
`if (!mask_contains_core(*before, 0)) { GTEST_SKIP() ... }`) und `:177-179` (Rueckpruefung durch
erneutes `current_thread_affinity_mask()` + `mask_is_only_core`). Die Mechanik ist geschrieben und
**nie in den Aktuator gewandert**.

**Null Produktions-Konsumenten im Messpfad.** `/usr/bin/grep` ueber alle tracked ce-Dateien:
`sched_setaffinity` -> 33 Treffer-Dateien, **32 davon in `ext/`** (vendored), genau eine im
Eigencode = `thread_pinning.hpp`. Der einzige Nicht-Test-Konsument ist
`apps/f15_compare/main.cpp:225-226`, und er meldet **nur den Erfolg**:

```
    auto measurement_pin = pin_core.has_value() ? bld::CorePinPolicy{*pin_core}.pin() : bld::NoPinPolicy{}.pin();
    if (measurement_pin.active()) { std::cout << "AP-13 Mess-Thread auf Core " << *pin_core << " gepinnt.\n"; }
```

**Es gibt kein `else`.** Wurde `--pin-core=N` angefordert und schlug fehl, sagt das Programm
nichts und misst weiter -- exakt der vom Owner ausgeschlossene Zustand. Beide `.gitlab-ci.yml`
enthalten **0** Treffer fuer `taskset|numactl|pin-core|sched_setaffinity|cpuset` (Gegenprobe an
derselben Datei: `perf_event_paranoid` trifft, `ce/.gitlab-ci.yml:93`).

**Und der Ort der Ausfuehrung wird nirgends festgehalten**: `ran_on_core_type` -> **0** Treffer im
Eigencode (Nenner 5501 tracked), `sched_getcpu` -> 0, `Cpus_allowed` -> 0, `/proc/self/status` ->
0. Gegenproben derselben Mechanik treffen (`/sys/devices/system/cpu` -> 5 Dateien).

> **Daraus folgt die unbequemste Zeile dieses Dokuments:** die Owner-Aussage "der Ort der
> Ausfuehrung ist nicht bekannt" ist am Ist **kein Sonderfall bei fehlendem Pinning -- sie ist der
> Normalfall aller Messungen.** Der Ort ist in **184 von 184** Spalten unbekannt und in
> **0 von 184** als unbekannt deklariert.

### 4.2 Wie zur Laufzeit geprueft wird -- beide Owner-Bedingungen

Unter Linux gibt es **keine CPUID-Abfrage fuer Affinitaet**; "CPU kann" und "Kernel reicht durch"
sind nicht per Instruktion trennbar. Der einzig belastbare Weg ist dreistufig, und **Stufe 3 ist
die entscheidende**:

| Stufe | Frage | Aufruf | Was ein Fehlschlag bedeutet |
|---|---|---|---|
| **P-1** | *Was darf ich ueberhaupt?* | `sched_getaffinity(0, ...)` -> ererbte Maske; `CPU_COUNT` = reale Wahlmenge | Schlaegt er fehl, reicht der **Kernel** gar nichts durch -> Owner-Bedingung 2 verletzt. *(Der Aktuator ruft das heute schon auf, `:56` -- verwirft das Ergebnis aber als Faehigkeitsaussage und nutzt es nur als Restore-Wert.)* |
| **P-2** | *Ist der Ziel-Core drin und online?* | `CPU_ISSET(core, &previous)` **vorab** (wie `test_ap13_thread_pinning.cpp:171`) + `/sys/devices/system/cpu/cpu<N>/online` | Ein Core ausserhalb der ererbten Maske ist unter cgroup-`cpuset` auf CI-Runnern der **Regelfall**, nicht die Ausnahme |
| **P-3** | *Hat es GEWIRKT?* | `sched_setaffinity` -> **erneut** `sched_getaffinity` -> Maske exakt `{core}`? | **Ohne diese Rueckpruefung ist die Aussage wertlos** -- s. 4.3 |
| **P-4** | *Welcher TYP ist der Core?* | CPUID Leaf `0x1A` (Hybrid Information) bzw. sysfs-Core-Typ | Nur mit P-4 ist der Ort **benannt**, nicht bloss **fixiert**. Heute ungelesen: `cpuid_probe.hpp` liest Leaves 0, 1, 7, 0x80000002-4; `cpuid_platform_probe.hpp:38-39` verbatim: *"AP-13: Topologie/Pinning bleibt bewusst ungesetzt (has_hybrid_cores, cpu_core_atom_perf_separation, preferred_pinning_policy)."* |

**Der Ort dieser Pruefung ist bereits gebaut und braucht keinen neuen:** die
Hardware-Erkennungs-Factory `include/cache_engine/measurement/hardware_probe_factory.hpp`
(515 Zeilen), Zell-Wahl ueber ISA x OS im Typ (`:106-107`), mit Totalitaets-Wache (`:264`),
ehrlicher Nicht-Implementierung je Zelle (`has_native_probe()`, `not_implemented_reason()`,
`:122/148/179`) und einem **Praezedenzfall fuer genau diesen Anbau**, `:33-39` verbatim:

> "Seit OD-10-RT haengt neben der RAM-Kette eine zweite Erhebung an dieser Factory: die
> numa/page-Probe [...] die Aussage 'auf dieser Plattform liegt der Zugang so' gehoert genau einmal
> in den Bestand. Ein zweiter, paralleler Zell-Raum haette dieselbe Plattform-Zuordnung ein zweites
> Mal behauptet -- und zwei Behauptungen ueber dieselbe Sache driften."

Eine `PinningCapabilityProbe<OsAxis>` ist dort der **dritte Anbau nach exakt dem OD-10-RT-Muster**;
`numa_page_probe_linux.hpp` ist die fertige Schablone (`std::expected<..., HardwareProbeErrorClass>`
mit `QuelleFehlt`/`QuelleKorrupt`). **Einschraenkung, die nicht uebergangen werden darf:**
`hardware_probe_factory.hpp:331-336` -- die Zelle ist heute Default-belegt (*"Heute stehen hier die
Defaults der Achsen (linux + prod1-Klasse) -- beweglich, kein Pin. In P5 setzt der PLANER die
Zelle"*). Eine Pinning-Pruefung dort erbt diese offene Naht.

### 4.3 Faelle, in denen der Pinning-Versuch **scheinbar gelingt, aber nicht wirkt**

Das ist der Grund fuer P-3 -- und fuer die Einsicht, dass "gepinnt" **keine binaere Wahrheit** ist.

| Fall | Was passiert | Faengt P-3 es? |
|---|---|---|
| **cgroup-v2 `cpuset.cpus`** | `sched_setaffinity` kehrt **erfolgreich** zurueck, waehrend der Kernel die Maske gegen das cpuset schneidet. Wird das cpuset spaeter geaendert, wird die Affinitaet **ohne Benachrichtigung** neu geschnitten -- der Pin loest sich **mitten im Lauf** | Teilweise: den Schnitt ja, die spaetere Aenderung **nein** -> Rueckpruefung auch **nach** dem Fenster noetig |
| **CPU-Hotplug / offline Core** | Core in `possible`, nicht in `online` -> `EINVAL` erst beim Setzen | Ja (P-2 mit sysfs faengt es frueher) |
| **Virtualisierung** | vCPU-Nummer stabil, darunterliegende physische CPU nicht. Der Pin **gelingt**, die Zaehler-Semantik bleibt unbestimmt | **NEIN -- hier hilft keine Pruefung, nur die Warnung** |
| **Hybrid-CPU ohne 0x1A** | Pin auf Core 7 gelingt; niemand weiss, ob Core 7 P oder E ist. **Das ist der Ist-Zustand** (§4.1) | Nein -- braucht P-4 |
| **Mehr-Thread-Pruefling** | `sched_setaffinity(0, ...)` pinnt **nur den aufrufenden Thread**. Ein Tier mit eigener Concurrency-Achse laesst Arbeit auf ungepinnten Threads laufen. Symmetrisch: `perf_event_open(..., pid=0, ...)` (`linux_perf_pmc_source.hpp:114`) zaehlt ebenfalls nur den aufrufenden Thread -- die Misses der Kind-Threads landen **weder im Pin noch im Zaehler** | Nein -- eigener Vorbehalts-Code noetig |

**Konsequenz fuer die Formulierung des Ergebnisses:** belastbar sind nur **drei getrennte
Aussagen** -- *durfte ich* (P-1/P-2), *hat der Aufruf gemeldet* (rc), *steht es nach Rueckpruefung
noch so da* (P-3). Der Owner-KERN verlangt die Warnung, sobald eine davon fehlt; die
Virtualisierungs- und cpuset-Faelle zeigen, dass **auch bei "alle drei gruen" ein Restvorbehalt
bleibt, solange der Core-TYP unbekannt ist** (P-4).

### 4.4 Wo im Ablauf, und wie das Ergebnis in die Zeile kommt

**Das Mess-Fenster** -- `harness/perm_runner.hpp:206-214` (gelesen):

```
206:    if (pmc != nullptr) pmc->begin();
207:    auto const t0 = std::chrono::steady_clock::now();
...
213:    auto const t1 = std::chrono::steady_clock::now();
214:    if (pmc != nullptr) r.pmc = pmc->end();
```

Der Pin muss **vor Z.206** stehen und **nach Z.214** rueckgeprueft werden -- nach dem bereits
dokumentierten Muster von `:204-205` (*"PMC begin() UNMITTELBAR VOR t0, end() UNMITTELBAR NACH t1
-> das Counter-Delta deckt exakt den getimten Batch"*).

**Aber die PMC-Quelle entsteht frueher.** `cache_engine_builder_iterator.hpp:2585-2586`:

```
    std::vector<CellOutcome> outcomes                 = collect_ordered<CellOutcome>(
        builds.size(), cfg.measure_parallelism, [] { return make_pmc_source(); },
```

Die Ctx-Factory laeuft **einmal je Mess-Worker** (`:2037-2038` verbatim: *"der PMC-Source wird PRO
Mess-Worker einmal erzeugt [...] NICHT je Op/Binary und NICHT geteilt"*), und der
`LinuxPerfPmcSource`-Konstruktor oeffnet dort **alle fds** (`linux_perf_pmc_source.hpp:217-234`).

> **Reihenfolge-Auflage, die der Bau loesen muss:** wird der Pin **nach** der fd-Oeffnung gesetzt,
> sind die Counter fuer einen anderen Ausfuehrungskontext geoeffnet worden als den, in dem
> gemessen wird. **Empfehlung: der Pin gehoert in dieselbe Ctx-Factory, VOR `make_pmc_source()`**,
> und der `ScopedThreadPin` muss so lange leben wie der Worker-Ctx -- also mit in den Ctx-Typ.

**Der Traeger zur Zeile existiert und ist kostenfrei.** `PermResult` (`perm_runner.hpp:113-151`)
haelt bereits **drei** host-seitige Geltungs-Felder -- `two_phase_valid` (`:136`),
`sample_status` (`:141`), `conformance_passed` (`:147`) -- mit der entscheidenden Eigenschaft,
`:140` verbatim:

> "Reist host-seitig (wie two\_phase\_valid/conformance\_passed), **NICHT im 175-Feld-Wire-Format ->
> Round-Trip/golden unveraendert**."

Ein Pinning-/Geltungs-Feld ist damit **ABI-neutral und golden-neutral** und folgt einem dreifach
etablierten Praezedenzfall. Der Weg in die Zeile ist eine Feld-fuer-Feld-Kopie,
`cache_engine_builder_iterator.hpp:2450-2452` (`row.two_phase_valid = pr.two_phase_valid;`
`row.sample_status = pr.sample_status;` `row.pmc = pr.pmc;`) -> `format_csv_row(row)` (`:2463`).

---

## 5. Der ENOENT-Fall als Praezedenz

### 5.1 Die Kette, Schritt fuer Schritt am Objekt

Der neu gelandete errno-Kanal (`linux_perf_pmc_source.hpp:115-123`, Commit `22e17f57`) macht den
Zustand **erstmals sichtbar** -- auf `stderr`:

```
        if (r < 0) {
            int const eno = errno; // SOFORT sichern -- fprintf/strerror koennen errno selbst ueberschreiben.
            std::fprintf(stderr,
                         "[PMC-DIAG] perf_event_open fehlgeschlagen: event=%s type=%u config=%llu "
                         "errno=%d (%s)\n", ...);
```

Die belegte Ausgabe auf einem prod1-Modell (Ryzen 9 9950X3D), zitiert nach
`docs/plaene/20260806-PLAN-hybrid-architektur-pmc-achsen-zuordnung.md:269-271`:

> "`[PMC-DIAG] perf_event_open fehlgeschlagen: event=cache_misses_l3_ll type=3 config=65538
> errno=2 (No such file or directory)` -- ein echter, bisher unsichtbarer **ENOENT auf dem
> LL-Counter**, den es vorher schon gab, der aber nie einen Fehlercode zeigte."

**Was daraus in der CSV wird -- Kette am Objekt nachgelesen:**

1. `c_ll_.open(..., "cache_misses_l3_ll")` schlaegt fehl (`:224-227`) -> `[PMC-DIAG]` nach stderr,
   Rueckgabe `false`.
2. `ll_ok_ = false`.
3. `ready_ = l1d_ok_ || ll_ok_ || dtlb_ok_` -> **true**, weil L1D offen ist (`:234`).
4. In `end()` wird der `if (ll_ok_)`-Block (`:286-294`) uebersprungen -> `c.cache_misses_l3`
   bleibt **0**.
5. `any = true` (von L1D, `:282`) -> `c.available = any;` -> **`true`** (`:320`).
6. CSV: `pmc_cache_misses_l3=0` **bei** `pmc_available=1` (`:748`, `:756`).

> **"Zaehler existiert nicht in dieser Kodierung" und "gemessen und exakt 0" erzeugen
> BYTE-IDENTISCHE CSV-Zellen.**

Der Header der Datei benennt die Falle sogar selbst, `linux_perf_pmc_source.hpp:16-17`:

> `// branch_misses wird von KEINER PMC-Quelle befuellt (offener Posten M-3a). Diese honest-0-Spalten sind im`
> `// Anhang als solche zu fuehren, nicht als gemessen.`

-- die Unterscheidung ist heute an einen **Prosa-Anhang delegiert, nicht an die Daten.** Und die
Zurueckhaltung ist bewusst und dokumentiert, `:99-102`: *"das Verschweigen des errno in den
RUECKGABEWERT bleibt bewusst so (kein erfundener Wert je Fehlerklasse in den Messdaten) -- neu ist
NUR eine Sichtbarkeits-Zeile auf stderr."* **Das war am 06.08. richtig und wird durch den
Owner-KERN teilweise ueberholt: die Unbestimmtheits-Aussage muss in die Ergebniszeile.**

### 5.2 Warum das **derselbe** Fehlertyp ist wie der Pinning-Fall

| | Pinning-Fall (Owner-KERN) | ENOENT-Fall (`cache_misses_l3_ll`) |
|---|---|---|
| Was gemessen wurde | Eine echte Zahl | **Nichts** |
| Was in der Zelle steht | Die echte Zahl | `0` |
| Was die Zelle **behauptet** | "gemessen, gilt" | "gemessen, und es waren null" |
| Was wahr ist | "gemessen, Geltung unbestimmt" | "es gibt diesen Zaehler hier nicht" |
| Wo die Wahrheit heute steht | **nirgends** | `stderr` |
| Fehlertyp | **Ein Wert behauptet etwas anderes, als er ist** | **dito** |

Beide brauchen **dieselbe Loesung in zwei Haelften**:

- Der ENOENT-Fall braucht **Achse B feiner**: er ist `SourceUnavailable` -- Zustand 4 der Leiter --
  und muss als **Marker in der Wertzelle** erscheinen, nicht als Zahl. Das Vokabular existiert
  bereits (`axis_error.hpp:80` / Log `quelle_nicht_verfuegbar`, `:163`); es fehlt nur der **Weg
  von der PMC-Quelle in den Status** -- heute setzt **kein einziger** PMC-, Pinning- oder
  Hardware-Zustand `SampleStatus` (die einzigen zwei Produzenten von `Failed` sind
  `perm_runner.hpp:173` und `:346`).
- Der Pinning-Fall braucht **Achse C**: `mess_geltung=ort_unbestimmt`, Wert bleibt stehen.

**Die gemeinsame Wurzel ist ein Datenmodell-Defekt, nicht ein Diagnose-Defekt:** `PmcCounters`
(`pmc_source.hpp:19-28`) hat **ein** `bool available` fuer **sieben** Zaehlerfelder. Solange das so
ist, kann keine Diagnose der Welt die Unterscheidung in die Zeile bringen.

**Und dieselbe Klasse trifft `scaled_`** (`linux_perf_pmc_source.hpp:346`, 3 Schreib-, 0
Lesezugriffe): "dieser Wert ist eine hochgerechnete Schaetzung" ist korrekt erhoben und **stumm**.
Drei Faelle, ein Muster.

### 5.3 Was der Anlassfall NICHT mehr ist (Superseded-Vermerk)

Die Beobachtung "`m3v2_pmc_smoke` misst ein LEERES Fenster" ist seit **`2b5ecd29`** (heute 22:10)
**behoben** -- `tests/unit/thesis_tiere/m3v2_pmc_smoke.cpp:62-69` klammert jetzt echtes
Pointer-Chasing (32 MiB, `kN = 1u << 22`). Die Commit-Nachricht traegt die Empirie verbatim:

> "Auf AMD 'bestand' derselbe Test nur zufaellig ueber den Syscall-Overhead selbst (34-53
> L1-Misses, 5-6 dTLB -- Rauschgrenze, kein Bestehen). 13 Traces: 7/7 AMD nonzero (Zufall), 6/6
> Intel exakt null (deterministisch)."

**Der ENOENT-Befund bleibt davon unberuehrt** -- er sitzt im `open()`, nicht im Messfenster. Aber
die Wachen-Kritik ist praeziser zu fassen: `m3v2_pmc_smoke.cpp:109-110` wertet weiterhin
`counters_all_zero` als Teil des Erfolgskriteriums, und `LEDGER:5265-5272` haelt die zweite Wache
fest (`linux_perf_pmc_smoke.cpp:58-63`: `"SMOKE_SKIP (no PMC access - honest available=0)"` ->
**Exit 0**), mit dem Ledger-Urteil verbatim: *"Die Wache ist nicht defekt -- sie beantwortet eine
andere Frage als die, um die es geht."*

---

## 6. Was das fuer die Thesis heisst

### 6.1 Der Traeger existiert und ist gebaut

- `thesis/diplomarbeit/anhang/de/A_measurements.tex:282-286`:
  `\section{Limitierungen}\label{sec:measurements:limitations}` -- Tabelle `tab:le:limitierung`
  fuehrt "alle nicht-gefixten Vorbehalte der Messreihen auf, damit **kein Befund still verfaellt**;
  Zeile~1 betrifft die fehlende PMC-Kernmetrik (Cache-Misses)".
- Erzeuger: `Code/04_csv_to_latex/csv_to_latex.cpp:951` `write_limitations_longtable`, Caption
  `:960` (*"Ehrliche Limitierungen: nicht-gefixte Vorbehalte (kein Befund verfaellt still)"*),
  Steuer-Kommentar `:958` (*"EINE longtable, je Zeile EIN nicht-gefixter Vorbehalt. Zeile 1 =
  Cache-Misses/PMC (Kernmetrik)."*).
- Ausgabe-Ist: `thesis/diplomarbeit/anhang/de/tabellen/le_limitierung.tex`, **36 Zeilen Datei /
  15 Tabellenzeilen**. Zeile 1 (`:20`) = *"Cache-Misses (Kernmetrik): L1/L2/L3 + dTLB + Coherence
  + Energy = 0 / nicht erhoben"*; Zeile 4 (`:23`) = *"Honest-0 inaktiver Sub-Features gepinnter
  Strategien"*.

### 6.2 Die Fliesstext-Doktrin sagt es bereits -- und ist am Ist nicht gedeckt

`thesis/diplomarbeit/kapitel/de/03_messsystem_prtart.tex:1036-1041` (gelesen):

> "die *honest-0-Doktrin* [...] Wo ein Wert nicht wirklich erhoben werden kann --- eine Organ-Achse
> ohne echten Laufzeit-Parameter, **ein Zaehler ohne Hardware-Zugriff**, eine Mess-Quelle, die auf
> der Plattform nicht existiert ---, meldet das System *ehrlich ungueltig oder leer* statt eines
> plausiblen Phantomwerts."

und `:1122-1124`:

> "**Nicht Erhobenes erhaelt ein ausdrueckliches n/a-Zeichen, nie eine Null in der Wert-Spalte**
> (honest-0-Doktrin [...]); vier Fehlerklassen trennen fehlende, unlesbare, korrupte und unbekannt
> formatierte Quellen, und **eine korrupte Quelle degradiert nie still zur naechsten Stufe**."

> **Betroffene Stelle, benannt:** `pmc_cache_misses_l3=0` bei `pmc_available=1` (§5.1) ist
> **exakt** "ein Zaehler ohne Hardware-Zugriff", der **eine Null in der Wert-Spalte** traegt. Der
> Thesis-Satz beschreibt heute eine Eigenschaft, die der Code an dieser Stelle nicht hat. Die
> Reparatur ist F-1 (§3.2) -- **nicht** eine Abschwaechung des Satzes.

Das naechste Analogon zum Owner-KERN steht ebenfalls schon in der Arbeit, `:1115-1121` -- die
Provenienz-Stufen: *"Eine niedrigere Stufe darf eine hoehere nur mit mitwandernder Kennzeichnung
verdraengen --- sonst stuende eine deklarierte Nennrate in der Ergebnis-Tabelle, waehrend die
Maschine womoeglich schneller faehrt: **schlimmer als ehrlich deklariert**."* Der Text fuer
`mess_geltung` ist damit im Prinzip bereits geschrieben; er muss nur von RAM-Frequenz auf
Messwerte gehoben werden.

### 6.3 Was der Anhang **nicht** darf, und was fehlt

**Der Anhang darf nicht-tragende Werte nicht als "gemessen" fuehren.** Konkret drei Punkte:

1. **Fehlende Limitierungs-Zeile fuer Pinning/Hybrid.** Nenner: 15 Zeilen in `le_limitierung.tex`,
   **hartkodiert** im Generator (`csv_to_latex.cpp:976-1135`, `struct Row { caveat; status; }` +
   `rows.push_back(...)`, von mir bei `:977-999` gelesen). Vorerhebungs-Zaehlung:
   `/usr/bin/grep -icE "pinn|affinit|p-core|e-core|hybrid"` -> 14 Treffer, **alle** betreffen
   *Achsen*-Pinning ("15 gepinnte Achsen", `:989/997`) oder Muster-Etiketten; **null** betreffen
   Thread-/Core-Pinning. Gleiches Ergebnis im Diagramm-Writer
   (`Code/05_diagram_generator/diagram_generator.cpp` -> 0).
2. **Fehlende Zeile fuer den ENOENT-Zustand.** Zeile 1 sagt heute "= 0 / nicht erhoben" und nennt
   als Grund "NullPmcSource, available=false" (`le_limitierung.tex:20`). Der ENOENT-Fall ist ein
   **anderer** Grund (Quelle gebaut, Zaehler existiert nicht) und braucht eine eigene Zeile.
3. **Der Kanal ist nicht datengetrieben.** Solange die Zeilen im Generator stehen, kann eine
   Messung keinen Vorbehalt in die Arbeit tragen. **Vorschlag:** `write_limitations_longtable`
   liest die neue `mess_vorbehalt`-Spalte, aggregiert die Codes ueber die CSV und emittiert je
   auftretendem Code **eine** Zeile mit Nennung des Anteils ("N von M Messzeilen"). Die
   hartkodierten Zeilen bleiben als Sockel -- additiv, kein Ersatz.

**Kein Fussnoten-/Spalten-Plan in der Thesis** (Vorerhebung, Gegenprobe: `footnote` in
Anhang A / Kapitel 03/05 zu Messwert-Vorbehalten = keine Treffer). Die Ausweisung laeuft
ausschliesslich ueber (a) `n/a` in der Wertspalte, (b) die `le_limitierung`-Longtable,
(c) `sec:limitations`. **Das ist ausreichend -- es fehlt nur der Inhalt, nicht die Form.**

**Offener Owner-Posten, der hier haengt** (`LEDGER:5298-5300`, heute):

> "**I-PMC-2 BLEIBT OFFEN, und das begrenzt den Anhang:** auch **mit** Flag bleiben L3, L2,
> coherence und energy auf 0 [...] **Der Anhang kann also selbst im besten Fall nur L1D + dTLB
> zeigen** -- das gehoert **vor Phase 6 entschieden**, nicht nach der Messung entdeckt."

Der ENOENT-Befund ist die **Erklaerung** dieses Postens, nicht ein neuer: L3 ist nicht "0", L3 ist
in dieser Kodierung nicht vorhanden.

---

## 7. Bau-Umfang und Reihenfolge

### 7.1 Kostenklassen (Definition uebernommen, nicht neu erfunden)

`docs/plaene/20260806-PLAN-messkette-ceb-observabletier.md:670-674`, gelesen:

| Klasse | Beruehrt | CEB | Tier-Binaries | Kosten |
|---|---|---|---|---|
| **CEB-ONLY** | Treiber-Compile-Graph (`comdare-messung-driver`) | 1 | **0** | ~77 s |
| **TIER** | `perm_mess_defines()` / `perm_compile_flags()` | 1 | 524.288 | ~34,4 h |
| **FINGERPRINT** | Preimage von `anatomy_fingerprint_hex` (8 Glieder) | 1 | die bereits GEBAUTEN | heute **0 h** (Bestand = 0), nach dem 1. Batch 34,4 h **+ Entwertung aller Messdaten** |

### 7.2 Einordnung der Pakete dieses Dokuments

| Paket | Klasse | Begruendung am Objekt |
|---|---|---|
| **W-a** `failed` zeilenweit (F-2) | **CEB-ONLY** | Reiner Renderer, `cache_engine_builder_iterator.hpp:574-586` -- Treiber-Code |
| **W-b** Per-Metrik-PMC-Status (F-1) | **CEB-ONLY** | `pmc_source.hpp` + `linux_perf_pmc_source.hpp` sind Host-/Treiber-Code (`i_measurement_source.hpp:3-6`) |
| **W-c** `mess_geltung` + `mess_vorbehalt` (F-3) | **CEB-ONLY**, **schema-wirksam** | END-Append, kein Define. Aber: Zeilen vor/nach der Aenderung tragen **andere Spalten-Semantik** |
| **W-d** `result.log` neben der CSV (F-4) | **CEB-ONLY** | `profile_run_entry.hpp:555-560` -- reiner Schreiber |
| **W-e** Pinning-Faehigkeitsprobe P-1..P-4 + Ctx-Pin (§4) | **CEB-ONLY** | Factory + `thread_pinning.hpp` + `collect_ordered`-Ctx sind Treiber-Code |
| **W-f** Auflage: Geltung/Vorbehalt **nie** ins Tier-Preimage | **FINGERPRINT (Auflage, baut nichts)** | s. unten |
| **W-g** Thesis: datengetriebene Limitierungs-Zeilen (§6.3) | **ausserhalb ce** (`Code/04_csv_to_latex`) | Konsumiert die CSV |

**Die gute Nachricht, klar gesagt: nichts davon ist Klasse TIER.** Kein Tier-Neubau, keine 34,4 h.
Der Grund ist strukturell: PMC, Pinning und Zell-Rendering leben host-seitig, und
`PermResult`-Felder reisen **nicht im 175-Feld-Wire-Format** (`perm_runner.hpp:140`).

**Das Preimage bleibt unberuehrt -- und das muss schriftlich festgehalten werden.** Die Glieder
sind `{Format, Organ, System, MESSUNG, Sub-Achsen, Toolchain, bvset, Overlay}`
(`abi/anatomy_fingerprint.hpp:462-472`, Ordnung als EINE Quelle `:422`). Ein **Geltungs-Vorbehalt
ist ein Lauf-Ergebnis, kein Bau-Merkmal** -- kaeme er ins Preimage, wuerde dieselbe Binary je nach
Tagesform der Maschine einen anderen Fingerprint tragen, und das Lager wuerde bei jedem
Pinning-Ausfall eine neue Identitaet erfinden. **W-f ist deckungsgleich mit der Auflage H-e des
Schwesterdokuments** (`...hybrid-architektur...:866,881`).

### 7.3 Reihenfolge -- und was VOR dem ersten Batch stehen muss

Die harte Regel, `...messkette...:684-689` verbatim: *"Das Fenster schliesst mit dem ersten
`.fingerprint`, den `provision_core` schreibt -- und das tut auch ein reiner
`provision_only`-Bau"*, und `:745`: *"[...] einen Datenbruch erzeugt und deshalb **vor dem Beginn
der ZU BEHALTENDEN Messung** stehen muss."*

| Stufe | Was | Warum jetzt / warum spaeter |
|---|---|---|
| **T0 -- heute, 0 h Bau** | **W-f**: Auflage schriftlich (Geltung/Vorbehalt nie ins Preimage) | Kostet heute 0 h, nach dem 1. Batch 34,4 h. Deckungsgleich mit H-e |
| **T1 -- VOR dem ersten zu behaltenden Batch** | **W-a**, **W-b**, **W-c**, **W-d** | **Semantik-Bruch:** eine Zeile ohne `mess_geltung` ist nicht "geltung=voll", sondern "unbekannt". Werden Zeilen vorher erhoben, tragen sie **andere Semantik** als spaetere, und keine spaetere Auswertung kann das reparieren -- die Information wurde nie erhoben. **W-b zusaetzlich:** eine `0` aus einem ENOENT-Lauf ist nachtraeglich **nicht** von einer echten 0 zu unterscheiden |
| **T2 -- vor der Voll-Messung** | **W-e** (Pinning-Probe + Ctx-Pin) | Braucht T1 (die Spalten), sonst hat das Ergebnis keinen Traeger. ~77 s Bau je Welle |
| **T3 -- nach der ersten Messung** | **W-g** (Thesis-Kanal) | Konsumiert Daten, die es vorher nicht gibt |

**Die praezise Begruendung, warum T1 nicht warten darf** -- in einem Satz: *nach dem ersten Batch
ist die Frage "traegt diese Zahl?" fuer die bereits erhobenen Zeilen **unbeantwortbar**, weil die
Antwort nie irgendwo geschrieben wurde; sie waere dann nur noch pauschal fuer die ganze Datei
nachtragbar -- also genau die "stille Auslassung", die `LEDGER:3310` verbietet.*

---

## 8. Offene Owner-Fragen -- je mit Empfehlung

### W-1 -- Traegt die **Wertzelle** den Marker, oder eine Nachbarspalte?
Zwei Formen sind moeglich: (a) `pmc_cache_misses_l3` rendert `quelle_fehlt` statt `0`;
(b) die Zelle bleibt `0` und eine Nachbarspalte sagt es.
**Empfehlung: (a) fuer ABWESENHEIT (Achse A/B), (b) fuer GELTUNG (Achse C).** Begruendung:
`axis_error.hpp:141-142` fordert woertlich "NIE eine stille Null" -- eine `0`, die nichts bedeutet,
darf nicht stehen bleiben. Umgekehrt ist beim Owner-Fall die Zahl **echt** und muss stehen bleiben
(K-1); dort ist die Nachbarspalte die einzige ehrliche Form.
**Nebenwirkung, benannt:** (a) macht die PMC-Spalten von "immer numerisch" zu "numerisch oder
Token". Betroffen ist jeder nachgelagerte Parser; die CSV traegt aber bereits heute `n/a` in
vielen Spalten und wird header-getrieben gelesen (`:493`).

### W-2 -- **Eine** Geltungs-Spalte oder **zwei** (Stufe + Vorbehalts-Codes)?
**Empfehlung: zwei.** Eine Stufe allein ist filterbar, aber nicht handlungsfaehig ("warum
unbestimmt?"); eine Code-Liste allein ist nicht sortierbar. Das RAM-Vorbild trennt aus genau
diesem Grund `RamFrequencyProvenance` von `RamReadingState`
(`ram_frequency_reading.hpp:53-67`). Kosten: 2 statt 1 END-Append-Spalte.

### W-3 -- Ist "nicht gepinnt" ein **Vorbehalt** oder ein **Fehler** (Messung verwerfen)?
**Empfehlung: Vorbehalt.** Der KERN sagt es ausdruecklich ("muss die PMC Werte **tatsaechlich**
ausgeben"). `failed` waere eine Regression gegen K-1.
**Aber mit einer Schaerfung, die vorgelegt werden muss:** auf einer **Hybrid**-Maschine mit
unbekanntem Kerntyp ist der Vorbehalt nicht nur eine Anmerkung, sondern betrifft die
Zaehler-*Semantik* selbst. **Optionale Verschaerfung zur Owner-Wahl:** fuer die als **Kernmetrik**
deklarierten PMC-Spalten (`LEDGER:6042`, V-08) koennte auf einer Hybrid-Maschine ohne Pin
zusaetzlich die Aufnahme in die Thesis-Auswertung gesperrt werden (Wert bleibt in der CSV, faellt
aus den Diagrammen). **Meine Empfehlung: NEIN** -- eine zweite, versteckte Filterregel widerspricht
`LEDGER:3310` ("kein Vorfilter"); besser ist eine sichtbare Limitierungs-Zeile.

### W-4 -- Wird der Zell-Token `n/a` in `nicht_anwendbar` / `quelle_fehlt` / `nicht_erhoben` **aufgetrennt**?
Heute faltet `sample_status_token` zwei Zustaende in `"n/a"` (`axis_error.hpp:147-148`); der Log
trennt bereits (`:161-165`).
**Empfehlung: JA, jetzt auftrennen.** Der ENOENT-Fall ist **genau** diese Unterscheidung, und das
Fenster ist offen (Fingerprint-Bestand = 0, `...messkette...:678`). Alt-CSVs sind Archiv-Bestand
(Memory `reference_alt_mess_csv_archiv_struktur_modernisierung`) und werden header-getrieben
gelesen. **Kosten:** die `static_assert`-Disjunktheitswachen (`axis_error.hpp:311-333`,
`:519-536`) und die Count-Single-Sources (`kSampleStatusCount`) muessen mitgezogen werden -- die
Datei verlangt das ausdruecklich selbst.

### W-5 -- Der aggregierte Log: **Datei neben der CSV** oder Spalte?
**Empfehlung: Datei** (`result.log` neben `result.csv`). Die Doktrin sagt woertlich "**neben der
CSV** aggregierter Log" (`LEDGER:1550`), und eine Freitext-Begruendung gehoert nicht in eine
Zelle. Die **Codes** stehen in `mess_vorbehalt`, der **Volltext** im Log; Verknuepfung ueber
`binary_id` + `setting_label`.

### W-6 -- Der Anhangs-Umfang PMC
**Bereits als Owner-Vorlage offen**, `LEDGER:5432-5435`: *"(1) das Flag in die dynamische Kette
als Invariante [...] (2) die Wache so drehen, dass 'Quelle nicht gebaut' ein Fehler ist und nicht
ein Skip; (3) der Anhangs-Umfang angesichts I-PMC-2/3 (nur L1D+dTLB)."*
**Empfehlung zu (3): den Umfang jetzt ehrlich auf L1D + dTLB festlegen** und L2/L3/coherence/energy
als Limitierungs-Zeilen fuehren -- mit dem **neuen** Grund aus §5 (ENOENT, nicht "0"). Der
ENOENT-Befund entscheidet (3) nicht, er **praezisiert** es.

### W-7 -- Der belegte Widerspruch zum 05.07.-Entscheid
`LEDGER:598` haelt verbatim fest: **"perm_runner-Pinning vom User live verworfen (Pinning nur
f15)"** (im selben Eintrag: *"AUFGESCHOBEN: P/E-Core-Auto-Erkennung (CPUID 0x1A ...)"*). Der
Owner-KERN vom 06.08. verlangt Pinning **genau dort** (CEB startet dieselbe Tier-Binary einmal
E-Core-, einmal P-Core-gepinnt).
**Empfehlung: der heutige KERN gilt** (spaetere Aussage schlaegt fruehere) -- **aber die Umkehr
muss quittiert werden, nicht still passieren** (Memory
`feedback_user_kern_beschreibung_ist_immer_gesetz...`). Zusaetzlich haengt daran der Riegel
`tests/unit/test_cpuid_probe.cpp:62-64` (G-270a), der auf prod2 rot wird, sobald die Probe ehrlich
erkennt.

### W-8 -- Wo genau wird gepinnt: **Worker-Ctx** oder **Mess-Fenster**?
Der Pin muss vor `pmc->begin()` liegen (`perm_runner.hpp:206`), die fds werden aber schon in
`make_pmc_source()` geoeffnet (`cache_engine_builder_iterator.hpp:2586`).
**Empfehlung: der Pin gehoert in die Ctx-Factory, VOR `make_pmc_source()`**, und lebt als Teil des
Worker-Ctx. Sonst sind Counter und Messung fuer verschiedene Kontexte konfiguriert. **Owner-Frage
daran:** ob der Pin dann fuer die **gesamte** Worker-Lebensdauer gilt (inkl. Bau-/Ladephasen) --
**Empfehlung: ja**, das ist die einfachere und die ehrlichere Aussage.

### W-9 -- Der Mehr-Thread-Fall
`sched_setaffinity(0, ...)` pinnt nur den aufrufenden Thread; `perf_event_open(..., pid=0, ...)`
(`linux_perf_pmc_source.hpp:114`) zaehlt nur den aufrufenden Thread. Ein Pruefling mit eigener
Concurrency-Achse laesst Arbeit auf Threads laufen, die **weder gepinnt noch gezaehlt** werden.
**Empfehlung: eigener Vorbehalts-Code `mehr_thread_pruefling`**, gesetzt wenn die Zeile eine
Concurrency-Auspraegung != seriell traegt. Das ist keine neue Erhebung -- die Achsen-Belegung steht
bereits in der Zeile.

---

## 9. Zusammenfassung in einem Bild

```
   EIN MESSWERT                          heute                      soll
   -----------------------------------------------------------------------------------
   A  Steht eine Zahl da?                Zahl | Marker              unveraendert
   B  Wenn nicht -- warum?               n/a (2 Gruende gefaltet)   3 Token getrennt
                                         failed (nur 24/184)        failed zeilenweit
                                         gesperrt / nicht_gebaut    unveraendert
   C  Wenn ja -- traegt sie?             NICHTS als System          mess_geltung
                                         (2 ad-hoc-Spalten,         + mess_vorbehalt
                                          1 stummes Feld)           (2 END-Append-Spalten)

   PMC-BLOCK heute:  l3=0  bei  available=1        <- ENOENT sieht aus wie "gemessen 0"
   PMC-BLOCK soll :  l3=quelle_fehlt               <- Zustand 4, nicht Zustand 2

   PINNING heute  :  0 von 184 Spalten sagen, wo gelaufen wurde
   PINNING soll   :  Zahl bleibt stehen + mess_geltung=ort_unbestimmt   <- OWNER-KERN

   FINGERPRINT    :  UNBERUEHRT. Geltung ist Lauf-Ergebnis, nie Bau-Merkmal.
```

---

## 10. Belegte Dateien (absolute Pfade)

**ce, Arbeitsbaum `/home/comdare/wt-landung` @ `2b5ecd29`** (alle selbst gelesen):
- `libs/cache_engine/include/cache_engine/measurement/axis_error.hpp`
- `libs/cache_engine/include/cache_engine/measurement/system_axis.hpp`
- `libs/cache_engine/include/cache_engine/measurement/ram_frequency_reading.hpp`
- `libs/cache_engine/include/cache_engine/measurement/machine_identity.hpp`
- `libs/cache_engine/include/cache_engine/abi/anatomy_fingerprint.hpp`
- `libs/cache_engine/builder/measurement/thread_pinning.hpp`
- `libs/cache_engine/builder/linux_perf_pmc_source.hpp`
- `libs/cache_engine/builder/experiment_tree/cache_engine_builder_iterator.hpp`
- `libs/cache_engine/harness/perm_runner.hpp`
- `libs/cache_engine/profile_facade/profile_run_entry.hpp`
- `tests/unit/thesis_tiere/m3v2_pmc_smoke.cpp`

**super `/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine`:**
- `docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md` (Z. 524, 555, 598, 1549-1554, 1577-1580,
  2492, 2913, 3310, 5298-5300, 5432-5435, 6042)
- `docs/plaene/20260806-PLAN-hybrid-architektur-pmc-achsen-zuordnung.md`
- `docs/plaene/20260806-PLAN-messkette-ceb-observabletier.md`
- `docs/sessions/20260726-SESSION-achsen-neuordnung-lager-baeume-xlsx-regressionen.md`
- `Code/04_csv_to_latex/csv_to_latex.cpp`
- `thesis/diplomarbeit/anhang/de/A_measurements.tex`
- `thesis/diplomarbeit/anhang/de/tabellen/le_limitierung.tex`
- `thesis/diplomarbeit/kapitel/de/03_messsystem_prtart.tex`

**Memory:** `~/.claude/projects/-home-comdare/memory/feedback_measurement_failure_visibility_csv_failed_not_null_plus_log.md`

**Nicht selbst nachgezaehlt, uebernommen und als uebernommen markiert:** die Spaltenzahl 184 und
die Reichweiten 24 / 175 / 9 (compilierte Vorerhebung). **Selbst nachgeprueft** wurde der
Mechanismus, der diese Zahlen erzeugt (`cache_engine_builder_iterator.hpp:574-586`, `:632`,
`:744-756`, `:777`, `:787-788`).
