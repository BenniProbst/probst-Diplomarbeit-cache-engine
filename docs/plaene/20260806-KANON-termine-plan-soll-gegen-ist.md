# Der Termin-Kanon: was die Betreuer-Dokumente festlegen und was davon fehlt

**Erstellt:** 2026-08-06 · **Quelle:** `docs/termine/` (11 Termine, 309 Dateien) gegen Ist-Stand
super `18a0bdf3` / ce `90bca126` · **Modus:** READ-ONLY erhoben, kein Edit an Quellen oder Code.

**Fundstellen-Konvention.** `.docx` -> `[Pnnnn]` = laufende `w:p`-Nummer in `word/document.xml`
(bzw. `[pNN]`/`[tblN.rM]` wo der lesende Agent so gezaehlt hat; die Notation ist je Termin im
Kopf des jeweiligen Abschnitts genannt). `.pptx` -> `slideN.xml:pNNN` = laufender `a:p`-Index.
`.md`/`.txt` -> Zeilennummer. Code -> `Pfad:Zeile`.

**Werkzeug-Auflagen, die beim Nachpruefen gelten.**
- `grep` leitet auf dieser Maschine auf ugrep um und kann still 0 liefern. Immer `/usr/bin/grep`.
- Jede Null braucht Nenner **und** Positivkontrolle. Alle Nullen unten tragen beides.
- `.docx`/`.pptx` sind ZIP-Archive: `unzip -p "<datei>" word/document.xml` bzw.
  `ppt/slides/slide*.xml`, dann Tags entfernen. Vor-Extraktionen liegen **nur** unter
  `20260508 Termin 7/_extracted_text/` und `.../_rev5_extractions/` — fuer T1-T6 und T8-T11
  muss selbst extrahiert werden.
- Falle: `find -not -path "*/build*"` schluckt auch `libs/cache_engine/**builder**/`. Wer so
  sucht, haelt gebaute PMC-Bausteine faelschlich fuer Null.

---

## 0. Warum es dieses Dokument gibt

Ehrlich und kurz: der Termin-Korpus ist die **Primaerquelle** der Arbeit und wurde ueber eine
ganze Arbeitssession nicht geoeffnet. Die Folge war ein Tag mit drei falschen
Ursachenvermutungen zu einem roten CI-Job, der als Infrastrukturproblem behandelt und mit einer
Cluster-Aenderung beantwortet werden sollte — waehrend die Antwort seit dem **09.04.2026** und
**12.04.2026** in den Terminen 3 und 4 steht:

> „**Hybrid-Regel lokal:** P- und E-Cores werden **nicht zusammenaggregiert**. perf dokumentiert
> dafuer **getrennte PMUs cpu_core und cpu_atom**; gruppierte Events ueber beide PMUs werden
> vermieden."
> — `20260409 Termin 3/20260409_PRT_ART_Benchmark_und_Datensatzplan_Termin3_final.docx [p016]`

> „Wie stark verbessern aktive, explizite cache-aware Layout-, Seitentyp- und
> Value-Ablageentscheidungen die Leistung trie-basierter Suchbaeume gegenueber passiven,
> statischen Layouts **auf Hybrid-CPUs und Sapphire-Rapids-Systemen**?"
> — `20260412 Termin 4/20260412_PRT_ART_Scope_Freeze_Termin4_final.docx [P9]` (Forschungsfrage)

Der Plan hat die Fehlerklasse benannt (T3 Risikotabelle `[p077]`: „Hybrid-CPU-Zaehler werden
falsch aggregiert"), den Baustein entworfen (`Domaenenmodell_PRT_ART.txt` Z. 441-447:
`HybridCorePinning` mit `pin_thread(core_class:{Performance|Efficient})` und
`measure_per_class()`) und den Verzeichnis-Slot vorgesehen. **Gebaut wurde er nicht.**

Dieses Dokument ist der Index, damit das nicht wieder passiert. Es ersetzt nicht das Lesen der
Termine — es sagt, **wo** man nachschlaegt und **was dort bindend steht**.

**Ein struktureller Erzeuger der Luecke, den man sofort sehen sollte:** der als Wegweiser
gedachte `docs/termine/INDEX.md` traegt `**Stand:** 2026-05-15 (K-B.1 Refresh, Termin 8)`
(Z. 3) und listet Termine 1-8. Treffer fuer „Termin 9|Termin 10|Termin 11" = **0** bei Nenner
174 Zeilen; Positivkontrolle „Termin 8" = **4**. Wer dem INDEX folgt, liest die drei juengsten
und damit geltenden Termine systematisch nicht. **Der INDEX ist defekt und muss nachgezogen
werden** (hier READ-ONLY nicht korrigiert; Vorschlag in §7, Frage O-6).

---

## 1. Der Korpus — was wo liegt

**Basis:** `/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/docs/termine/`
**Nenner (verifiziert `find . -type f | wc -l`): 309 Dateien.**
Typverteilung: 117 `.md` · 80 `.txt` · 61 `.jpg` · 27 `.docx` · 11 `.pptx` · 8 `.drawio` · 5 `.py`.
**270 der 309 Dateien (87 %) liegen allein in Termin 7.**

| Termin | Ordner | Dateien | Was er festlegt | Tragende Dateien |
|---|---|---|---|---|
| **T1** | `20260330 Termin 1/` | 3 | Exposé, 4 Forschungsfragen, Hypothesen H1-H4, **4-Ebenen-Pflichtmetrik**, Datensatzliste, Leseliste L1-L16 | `20260326 Expose_...docx`; `20260330 Literatur_und_Arbeitsplanung_...docx`; `20260330 PRT_ART_Technische_Skizze_...docx` |
| **T2** | `20260330 Termin 2/` (Inhalt datiert **05.04.**) | 3 | **Architektur-Freeze** (Wiederholungstermin), 5 Seitentypen, ValueHandle, **Invarianten I1-I6**, 5 Risiken, Ursprung des Begriffs „Cache-Engine" | `20260405_Arbeitsaufstellung_...docx`; `20260405_PRT_ART_Architekturentscheidungen_...docx`; `20260405_..._Praesentation_final.pptx` |
| **T3** | `20260409 Termin 3/` | 3 | **Mess- und Datensatzplan**: 2 Pflichtplattformen, **Hybrid-Regel**, 8 Pflicht-Messachsen, 6 Pflichtdatensaetze, Fairnessregeln, 5 Wiederholungen | `20260409_PRT_ART_Benchmark_und_Datensatzplan_...docx` (**das Regelwerk**); `20260409_Arbeitsaufstellung_...docx`; `..._Praesentation_final.pptx` |
| **T4** | `20260412 Termin 4/` | 4 | **SCOPE-FREEZE**: finale Forschungsfrage, H1-H4, 4 Schichten A-D, 6 Seitentypen mit Prio, Prioritaetsbloecke P0-P3+OPT, WP1-WP6 | `20260412_PRT_ART_Scope_Freeze_...docx`; `20260412_Arbeitsaufstellung_...docx`; `Aktive Cache-Engine fuer trie-basierte In-Memory-Indizes_...docx` (414 Absaetze, inhaltsreichste Datei); `..._Praesentation_final.pptx` |
| **T5** | `20260412 Termin 5/` | 4 | Forschungslandkarte, **Designregeln R1-R6**, Sprachauflagen („nicht Cache direkt verwalten"). **Friert nichts ein** | `20260416_PRT_ART_Ausarbeitung_Termin5_nachgezogen_final.docx` (**juengste, geltende T5-Fassung**); `20260412_..._Forschungslandkarte_...docx`; `20260412_Arbeitsaufstellung_...docx`; `..._Praesentation_final.pptx` |
| **T6** | `20260416 Termin 6/` | 3 | **Verifikationsstrategie**: 9 Pflichtplattformen, 5 ISA-Pfade, 3 Verifikationsmodi, Messstack je OS, **Auswertungsregel D1xD3xD2xD4** | `20260416_PRT_ART_Termin6_Scope_Freeze_final.docx`; `20260416_Arbeitsaufstellung_...docx`; `..._Praesentation_final.pptx` |
| **T7** | `20260508 Termin 7/` | **270** | **Erster Termin mit echtem Betreuer-Wortlaut** (H1-H6), ADRs F1-F15, Domaenenmodell, UML+ER (Phase5), 33-Paper-Recherche | `Habich_Feedback_2026_05_08.txt` (454 Z.); `Architekturentscheidungen_F1_F15.txt` (975 Z.); `Domaenenmodell_PRT_ART.txt` / `_v3` / `_v4_DELTA`; `Phase5_UML_Detail/00_`-`13_`, `20_`-`30_`; `phase5_uml_detail_REV7.drawio` (54 Tabs) |
| **T8** | `20260515 Termin 8/` | 9 | Drei-Repo-Doktrin, `libs/`-Layout „Option C+", Architekt-Direktive II (Lizenz), 22 Adapter, MessreihenMode | `Arbeitsplan_Termin8.md`; `Arbeitsergebnis_Termin8.md`; `Praesentation_Termin8.md/.pptx`; **`_archive_chatgpt/`** (3 Dateien, s. §5-W6) |
| **T9** | `20260529 Termin 9/` | 3 | **Achsen-Goldstandard (7 Bestandteile)**, Anatomy/ABI, Risikotabelle, **3 Rede-Verbote**, Akzeptanzkriterium | `20260529_PRT_ART_Arbeitsergebnis_...docx`; `20260529_Arbeitsaufstellung_...docx`; `..._Praesentation_final.pptx` (Slides 7/8 tragen P0/P1/P2 und das Akzeptanzkriterium — **nur dort**) |
| **T10** | `20260605 Termin 10/` | 3 | **Achsen-Delegations-Audit** (Fehlerklasse), NodeChunkedStore, V2-POD offen, `result_ingest`-Felder | `20260605_PRT_ART_Arbeitsergebnis_...docx`; `20260605_Arbeitsaufstellung_...docx`; `..._Praesentation_final.pptx` (Kardinalitaeten A_defined/A_full nur dort) |
| **T11** | `20260618 Termin 11/` (Inhalt datiert **19.06.**) | 3 | **Juengste geltende Fassung**: FF0, 132/128 Seiten, P0-P4, **M1-M5 mit Definition of Done**, 13 Limitierungen, „Rang statt Tier" | `20260619_Arbeitsergebnis_Vorstellungstermin_Habich.docx`; `20260619_Arbeitsaufstellung_...docx`; `20260619_..._Praesentation.pptx` |

**Quellenlage-Warnung, die man kennen muss.** In **T1-T6 und T8-T11 gibt es keinen einzigen
protokollierten Betreuer-Wortlaut.** Alle Dokumente sind vom Studenten verfasste Vorlagen
(`docProps/app.xml`: `python-docx` bzw. `python-pptx`; `cp:lastModifiedBy` = „Benjamin-Elias
Probst"). Was Habich verlangt oder abgelehnt hat, ist dort nur **indirekt** fassbar. Wortlaut
gibt es an genau zwei Stellen: **T7 `Habich_Feedback_2026_05_08.txt`** (Auflagen H1-H6) und
**T11 `tbl17.r6`** („Textliche Glaettung Kapitel 1-3 **nach Habich-Feedback** ... Begrifflichkeit:
Lebewesen/Organ/Achse, **Rang statt Tier**"). Alles andere im Korpus ist **Selbstverpflichtung
des Kandidaten** — sie ist deshalb nicht weniger bindend (sie wurde dem Betreuer vorgelegt),
aber sie ist nicht „Habich hat gesagt".

**Zwei Datums-Fallen im Korpus.** (a) Ordner `20260330 Termin 2` enthaelt Dateien mit
`20260405` im Namen, `docProps/core.xml` sagt `created 2026-04-05`, `modified 2026-04-09`.
**Es gilt die Datei.** (b) Ordner `20260618 Termin 11` enthaelt `20260619_*`-Dateien mit
`[p2] Termin am 19.06.2026`; Datei-mtime 18.06. 19:25/21:02 = **Vorabend-Vorbereitung**, kein
Nachher-Protokoll. Gleiches Muster in T10 (Ordner 05.06., mtime 04.06. 21:47).

---

## 2. DIE BINDENDEN FESTLEGUNGEN

Dies ist der Kern. Was hier steht, ist Pflicht — mit Zitat und Fundstelle. Wo etwas nur nach
Pflicht klingt, ist es als **[KEINE PFLICHT]** oder **[SELBSTAUFLAGE]** gekennzeichnet.

### 2.1 Forschungsfrage — drei Fassungen, eine gilt

| Fassung | Wortlaut | Fundstelle | Status |
|---|---|---|---|
| **A (geltend)** | „Wie stark verbessern aktive, explizite cache-aware Layout-, Seitentyp- und Value-Ablageentscheidungen die Leistung trie-basierter Suchbaeume gegenueber passiven, statischen Layouts **auf Hybrid-CPUs und Sapphire-Rapids-Systemen**?" | T4 `Scope_Freeze [P9]`; wortgleich T4 `Praesentation slide1:P4` | **GILT** — Freeze-Dokument + dem Betreuer gezeigte Fassung; spaetester mtime `2026-04-18T16:24` |
| B | „... gegenueber passiven, statischen Layouts **auf moderner CPU-Hardware**?" | T4 `Arbeitsaufstellung [P8]` (mtime `2026-04-13T06:15`) | ueberholt |
| C | „Wie stark verbessern aktive, **messgetriebene** Cache-Entscheidungen — bezogen auf Seitentyp, Layout, Value-Ablage und Prefetching — ... **auf unterschiedlichen CPU-Plattformen**?" | T5 `Landkarte [P111]`, dort selbst als **„sinngemaess"** markiert | Paraphrase, kein Freeze (T5 friert nichts ein, `Arbeitsaufstellung T5 [P61]`) |

**Aktuellste Zuspitzung, T11 (19.06.):** „**FF0: Verbessern aktive, messgetriebene
cache-bewusste Entscheidungen die Leistung gegenueber passiv-statischen Varianten?**"
(`Praesentation slide2:P6`). T11 nennt Hybrid/Sapphire **nicht** — es spricht ueber
Plattformen ueberhaupt nicht mehr konkret (Nullbefund §2.3). **Das ist keine Aufhebung.**
Nach der Chronologieregel („ein spaeterer Termin kann einen frueheren ueberholen") gilt: T11
hat den Plattformterm **nicht widersprochen, sondern nur nicht wiederholt** — die T4-Fassung
bleibt bindend. Die Thesis fuehrt sie auch weiter:
`thesis/diplomarbeit/kapitel/de/01_einleitung.tex:91-95` — „... auf unterschiedlichen
CPU-Plattformen (**Hybrid-CPUs, Sapphire Rapids**)?"

Die Thesis fuehrt zusaetzlich **FF0-FF4** (`T11 Arbeitsergebnis [p7]`: „Kapitel 1: ... **FF0-FF4**
und Beitraege sind formuliert"). **Nur FF0 ist im Termin-Korpus ausformuliert**; FF1-FF4 stehen
dort nicht — sie sind Thesis-Eigenleistung und im Korpus nicht nachpruefbar.

### 2.2 Hypothesen — zwei Saetze, beide bindend

**T1-Satz (Literatur- und Arbeitsplanung, `[P0009]`-`[P0012]`), woertlich:**
- **H1**: „Der Nutzen von PRT-ART muss gegenueber anderen einschlaegigen Algorithmen **primaer
  ueber geringere Cache-, TLB- und Branch-Kosten nachgewiesen werden, nicht ueber asymptotische
  Neuheit**."
- **H2**: „**Es gibt keine universell beste lokale Seitendarstellung**; die beste Wahl haengt von
  lokaler Dichte, Praefixstruktur, Zugriffsmix, Anwendungsdatensatz und Zielarchitektur ab."
- **H3**: „Die staerksten Zieloperationen sind Exact Lookup, Prefix Lookup (complete oder
  incomplete multi target) und Prefix Enumeration; **globale lange Range-Scans sind nicht der
  primaere Dominanzanspruch**."
- **H4**: „**Auch die Ordnungs-/Sortierpolitik ist nicht universell optimal**; unsortierte,
  lokal sortierte und global lexikographische Modi tauschen Punkt-Suche gegen
  Range-/Enumerationsfaehigkeit aus."

**T4-Satz (Scope-Freeze `[P11]`-`[P14]`), woertlich — dieser ist der eingefrorene:**
- **H1**: „Eine aktive Cache-Engine verbessert **Cache Line Utilization, Footprint und Laufzeit**
  gegenueber statischen Layouts."
- **H2**: „Dense-, Sparse- und Multilevel-Seiten gewinnen abhaengig von **Datensatz, ISA,
  Core-Typ und Ordnungsmodus** unterschiedlich."
- **H3**: „Die Grenze zwischen Inline-Value und ValueHandle ist architektur- und
  workloadabhaengig und **muss aktiv gewaehlt werden**."
- **H4**: „Online-Umlagerung und explizites Prefetching helfen **nur dann**, wenn Seitentyp,
  Wertablage und Affinity **gemeinsam** modelliert werden."

Die T4-Hypothesen sind eingefroren; die T1-Hypothesen sind nicht widerrufen und stehen
zusaetzlich (T4 wiederholt sie nicht — nach der Fassungsregel bleibt T1 fuer sie massgeblich).

### 2.3 Pflichtplattformen — zwei Ebenen, beide unwiderrufen

**T3-Ebene (09.04.), `Arbeitsaufstellung [p008]`:**
> „**Zwei Pflichtplattformen:** lokales Hybrid-System (Intel Core i7-1270P laut Nutzerangabe,
> P- und E-Cores separat) und **ZIH Barnard (Sapphire Rapids, AVX-512-faehig)**."

Konkretisiert `Benchmarkplan [p012]/[p013]`: lokal „Single P, Single E, All-P, All-E; perf
cpu_core/* und cpu_atom/* getrennt"; Barnard „2x Intel Xeon Platinum 8470, Sapphire Rapids,
AVX-512-faehig, 512 GiB RAM ... Batchlaeufe via Slurm".

**T4 bestaetigt (`Scope_Freeze [P76]`, [P78]):** „Pflichtplattformen: lokales
Alder-Lake-P-System und Barnard/Sapphire Rapids." · „Auf Barnard sind perf/PAPI/PIKA-konforme
Messpfade und **Slurm-Batch-Laeufe Pflicht**; ... **exklusive Jobs mit no_monitoring**."

**T6-Ebene (16.04.), `Arbeitsaufstellung Z. 11-13` — Erweiterung auf 9 Plattformen:**
> „Pflichtplattformen lokal: VisionFive 2, Raspberry Pi 5, Mac mini M1, ODROID-H4 Ultra,
> **i7-1270P**, i9-14900KS, Ryzen 9 9950X3D2; der alte Intel-Mac-mini nur nach exakter
> CPU-Erkennung." · „Pflichtplattformen am ZIH: **Barnard (Sapphire Rapids) und Grace Hopper
> GH200**; Capella wird als interessanter AMD-Server-Zusatz vorbereitet."
> „Pflicht-ISA-Pfade: **scalar, x86_avx2, x86_avx512 (wenn verfuegbar), arm_neon, arm_sve2**."

**T10/T11 sagen nichts mehr dazu.** Nullbefund mit Nenner: ueber 345 inhaltstragende Zeilen aus
6 T10/T11-Dateien: `Sapphire` = 0, `cpu_core`/`cpu_atom` = 0/0, `P-Core`/`E-Core`/`Pinning` = 0,
`Barnard` = 0; einziger `Hybrid`-Treffer ist „**Hybrid API** Vector/Map/Tuple"
(`T11 Praes. slide8:p3`). Positivkontrollen im selben Lauf: `PMC` = 15, `Achsen` = 31.
T11 sagt nur noch abstrakt (`tbl13.r6`): „Lokale Entwicklungsplattform plus **ZIH**/
Hardware-Counter-Pfade vorgesehen." **Damit gelten T3/T4/T6 unwidersprochen fort.**

### 2.4 Messregeln — die harte Liste

| Regel | Woertlich | Fundstelle |
|---|---|---|
| **HYBRID-REGEL** | „P- und E-Cores werden **nicht zusammenaggregiert**. perf dokumentiert dafuer getrennte PMUs **cpu_core** und **cpu_atom**; gruppierte Events ueber beide PMUs werden vermieden." | T3 `Benchmarkplan [p016]`, T3 `Arbeitsaufstellung [p019]` (eigener Kasten), T6-Praes. Folie 4 („**nie als ein homogener CPU-Block**"), T4 `[P77]`, T4 `WP3` |
| **Wiederholungen** | „**fuenf Laeufe pro Konfiguration.** Rohwerte bleiben getrennt" | T3 `[p013]`, T3 `[p054]`, T4 `WP5`, T6-AA `Z. 16` |
| **Histogramm-Regel** | „Perzentile werden **nicht gemittelt**. Je Lauf werden HDR-Histogramme persistiert" | T3 `[p065]` |
| **Wiederholungsregel** | „fuenf Laeufe werden **nebeneinander** berichtet. **Abweichungen zwischen Lauf 1-5 sind Teil der Aussage und werden nicht weggemittelt.**" | T3 `[p066]` |
| **Cache-Line-Regel** | „Advisor modelliert standardmaessig 64-Byte-Cache-Lines; diese Groesse darf fuer die Analyse verwendet werden, **ersetzt aber nicht die Hardware-Discovery und den expliziten Plattformbezug im Algorithmus**." | T3 `[p067]`; Wurzel: T2 `Arbeitsaufstellung [P0060]` „**keine statischen Architekturannahmen als allgemeine Regel. Stattdessen Hardware-Discovery**" |
| **Auswertungs-Dimension** | „fuenf Rohlaeufe, keine Mittelung von Perzentilen, **getrennte Ausweisung nach Plattform, Core-Typ, ISA und Cache-Engine-Modus**" | T6-AA `Z. 16` (= D1 x D3 x D2 x D4, in T7 REV5 §12.3 als Reporting-Pflicht durchgezogen) |
| **Erfolgskriterium (UND, kein ODER)** | „erfolgreich verifiziert, wenn die Cache-Engine ... konsistent bessere Entscheidungen erzeugt als der statische Modus **und** die Verbesserungen **gleichzeitig** in End-to-End-Latenz **sowie** in Miss-/CLU-/Footprint-Metriken sichtbar werden." | T6-SF `Z. 12`; ergaenzend T4 `[P244]` „**CLU hoch (signifikant) und Footprint runter (signifikant) bei gleicher/geringerer Latenz**" |
| **Ausgabeformat** | „**Roh-CSV/JSON je Lauf, HDR-Histogramme separat, kein Mitteln von Latenzperzentilen**" | T3 `[p054]` |
| **Reproduzierbarkeits-Stempel** | „Ein Plattformlauf mit CSV/JSON/TikZ/PDF und **dokumentiertem Commit/Compiler/Seed**" | T11 `tbl25.r2` (M1-DoD); ergaenzend T3 `[p073]` „Compiler, Flags, ISA-Pfad, Allocator und Commit-Hash jeder Fremdbibliothek werden mitgeloggt" |
| **Datensatz-Akte (9 Felder)** | „Jeder Datensatz erhaelt eine **Akte**: Originalquelle, Downloadskript, Pruefsumme, Zeilenanzahl, Bytevolumen, Vorverarbeitung, Sortierzustand, Payload-Generator und **Seed-Regel**" | T3 `[p031]` |
| **Fairness** | „jeder Vergleich trennt einen gemeinsamen Minimalmodus (**externe Payload/Handle, keine PRT-ART-Spezialtricks**) von einem PRT-ART-Native-Modus" · „fehlende Prefix-/Range-Faehigkeit ... bleibt **N/A**, wird nicht 'repariert'" | T3 `[p069]`, `[p072]`, `[p044]` |
| **Mess-Record-Layout** | `struct alignas(32) MeasurementRecord { ... uint8_t cpu_class; // 0=core 1=atom ... uint8_t telemetry_strategy; uint32_t sampling_n; ... }` + `static_assert(sizeof==32)` | T7 `Phase5_UML_Detail/06_uml_persistence.md Z. 52-63`; ER-Feld `MeasurementRecord.cpu_class VARCHAR(8) -- "core"|"atom"` in `07_er_model.md Z. 108-109`; CSV-Schema `Z. 258-260` |

**Vier Pflichtmetrik-Ebenen (T1 `[P0119-TAB]`-`[P0131-TAB]`) — die am leichtesten vergessene ist Ebene 2:**
1. **Lookup/CRUD**: „Throughput; **p50/p95/p99**; Build-Zeit; Insert/Update/Delete; Fehlzugriffe;
   Prefix Enumeration ... **Tail-Latenzen sind explizit relevant.**"
2. **Speicher**: „**Bytes pro Key; Poolgroessen getrennt nach Suchseiten, Redirects und Values;
   Tombstones; Konsolidierungskosten**" — Begruendung woertlich: „**Ohne saubere Speicherbilanz
   bleibt der Layout-Anspruch unglaubwuerdig.**"
3. **CPU-Counter**: „cycles; instructions; **IPC**; branches; **branch-misses**; L1D-/LLC-/dTLB-misses"
4. **Cache-Modell**: „**Cache Line Utilization; modellierte Misses; Advisor Memory Access
   Patterns**"

**Die 8 Pflicht-Messachsen (T3 `[p047]`-`[p054]`):**
9 Operationen („Bulk build, exact hit, exact miss, **prefix hit, prefix miss, prefix
enumeration**, insert, update, delete") · 6 YCSB-Mischungen A-F · 3 Ordnungsmodi (unsortiert,
lokal geordnet, lexikographisch) · 2 Value-Modi (inline, external handle) · 3 ISA-Modi ·
**5 Core-Modi (Single P, Single E, All-P, All-E, Barnard homogeneous)** · 5 Wiederholungen ·
2 Plattformen.

> **Verlustpfad, aktenkundig:** Die **Core-Modus-Achse fehlt in beiden Kurzformeln** desselben
> Termins — T3 `[p012]` („Ordnung, Inline-Grenze, Seitentyp-Scheduler, ISA-Modus, Plattform und
> Workload") und T3 `Praes. slide4:par026` („Plattform x ISA x Ordnungsmodus x Value-Modus x
> Workload x Datensatz"). **Massgeblich ist die detailliertere Pflichttabelle `[p053]`.** Wer
> die Achsen aus der Folie abzaehlt, verliert die P-/E-Core-Achse. Genau dieser Verlust ist
> heute im Code eingetreten (§3, D-02).

**Pflichtdatensaetze (T3 `[p011]`, T4 `[P242]`, T11 `tbl13.r5` — dreifach bestaetigt):**
„alle sechs CoCo-trie-Datensaetze (**url, dna, tpcds-id, trec-terms, protein, xml**) werden als
Kernportfolio gesetzt."

**Policy-Ablation (T4 `[P242]`, Experiment 5) — die Kausalitaetsbedingung:**
> „**Policy-Ablation: Cache-Engine Off (Baseline PRT-ART), nur Page-Type-Selection, nur
> Prefetch, nur Relocation, Full Engine; Ziel: Kausaler Nachweis 'active > passive'.**"
Flankiert von T6-SF `Z. 9-11`: drei Verifikationsmodi (passiv/statisch · Warm-up-kalibriert ·
online adaptiv).

### 2.5 Achsen

| Quelle | Zahl | Woertlich |
|---|---|---|
| T7 `Bausteine_Matrix.txt` | 11 | Achse 11 TELEMETRY-COLLECTION-STRATEGY neu 2026-05-09 (Kuehn) |
| T7 `Domaenenmodell_v3 §2` | 10 | inkl. Achse 10 Measurement |
| T7 `REV7.drawio` N-Phase (18.05.) | **14 + ~30 Sub-Achsen** | „Vor N-Phase: 11 Hauptachsen, ~85 Bausteine, ~5,5 Mrd. Permutationen, **50 bit** / Nach: **14 Hauptachsen, ~120 Bausteine, ~100 Mrd.+, 82 bit**" — **existiert nur im drawio, kein `.md`-Pendant** |
| T9 `Arbeitsergebnis [p31]` | **22 Topic-Achsen / 324 Header** | „page_type, path_compression, search_algo, cache_traversal, mapping, node_type, memory_layout, allocator, prefetch, concurrency, serialization, telemetry, value_handle, hardware, ISA, SIMD, queuing, IO, migration und filter" (20 genannt + „u. a.") |
| T11 `tbl9.r4` / `tbl13.r2` | **19 Achsen + 3 Build-Achsen** | „19 Suchalgorithmus-Achsen plus Build-Achsen und Allokator-Korpus im Anhang D" |

**Geltende Fassung: T11 (19+3).** Der Ist-Stand fuehrt 18 Organ-Achsen (§3, D-13) — die
Abweichung ist zu erklaeren, nicht wegzulassen.

**DER ACHSEN-GOLDSTANDARD (T9 `Arbeitsergebnis [p32]`) — 7 Pflichtbestandteile, woertlich:**
> „Der juengste Goldstandard orientiert sich an **axis_06_allocator** und verlangt **Registry,
> StrategyBase, ConfigSet, Flags, Wrappers, Concept-Conformance und CMake-Integration**."

Diese Liste steht in **keinem** spaeteren Dokument des Korpus vollstaendig. Wer heute eine Achse
baut oder abnimmt, prueft gegen diese sieben Punkte.

### 2.6 Bausteine — Namen, die entworfen wurden

| Baustein | Definition (woertlich) | Fundstelle |
|---|---|---|
| **`HybridCorePinning`** | `+ pin_thread(thread_id: TID, core_class: { Performance \| Efficient })` · `+ measure_per_class() -> { p_core: Counters, e_core: Counters }` · „ROLLE: trennt Messungen auf Hybrid-CPUs (Intel P/E, Apple M1)" | T7 `Domaenenmodell_PRT_ART.txt Z. 441-447`; Verzeichnis-Slot `hardware_isa/hybrid_core_pinning/` in v1 `Z. 591`, v2 `Z. 945`, v3 `Z. 705` |
| **5 Seitentypen** | „Redirect-Page, Dense-Byte-Page (ART-artig), Extended Dense Page (START-artig), Sparse Patricia Page (HOT-artig) und PRT-Custom-Cache-Page" | T2 `Arbeitsaufstellung [P0056]`; T4 erweitert auf **6** mit Prio: Redirect **P0**, Dense Byte **P0**, Multilevel Dense **P1**, Sparse Patricia **P0/P1**, **Decision-/Span-Page (B²-tree) P2**, Custom Aligned Page **P2** (`Scope_Freeze [P32]`-`[P55]`) |
| **ValueHandle** | `Inline` („wenn ein zusaetzlicher Pointer teurer waere als das direkte Mitlesen aus **derselben Cache-Line**") · `External` (Standardpfad) · `ChainRef` („**explizit vertagte Erweiterung**") | T2 `Architekturentscheidungen [P0038]`-`[P0040]`; T4 `[P59]`: „**ValueHandle ist Kernbestandteil des Systems und keine spaetere Verzierung**" |
| **Cache-Engine E/A** | **Eingaben (abschliessend):** lokale Dichte/Fanout · Praefixentropie · erwartete beruehrte Cache-Lines/Pages pro Lookup · Key-/Value-Groesse + Inline-Eignung · ISA-/HW-Profil. **Ausgaben (abschliessend):** Seitentyp · Alignment · lokale Ordnung · Inline-vs.-Pointer-Value · Reorganisation von Node-Gruppen | T2 `Architekturentscheidungen [P0034]`/`[P0035]`; T2 `Praes. slide4:p038`: „welche Eingaben die Cache-Engine sehen darf, welche Ausgaben sie aendern darf" |
| **`NodeChunkedStore`** | „node-wirksamer Store ... Node4, Node16, Node48 und Node256 erzeugen unterschiedliche Chunk-/Allokationszaehler gemaess ihrer Kapazitaet"; `allocation_count ~ ceil(n / node_capacity)` | T10 `Arbeitsergebnis [p26]`, `Praes. slide7:p7` |
| **`NullPmcSource`** | Null-Object fuer die PMC-Quelle, wenn Counter nicht erhoben sind | T11 `Arbeitsergebnis [p18]` |
| **`CacheEngineMode`** | `{ HEURISTIC_STATIC, INFORMED_KALIBRIERT, AUTOMATIC_ADAPTIVE }` | T7 `Phase5_UML_Detail/02_uml_cache_engine.md §9`; ER-Feld `ExperimentRun.mode` in `07_er_model.md Z. 86` |
| **`IntelHybridProbe`** | `+ perf_event_separation() : bool ' cpu_core/* vs cpu_atom/*`; `CoreLayout { p_core_ids, e_core_ids }` | T7 `04_uml_hardware_isa.md Z. 149-157`, `Z. 40-41` |

**Wichtige Korrektur zu plattformspezifischen Klassen (T7 `10_korrektur_...md` K3.2, 10.05.):**
> „**Die Cache-Engine darf KEINE plattform-spezifischen Klassen tragen.**"
Re-Mapping: `RyzenX3DProbe` -> Property `has_asymmetric_l3` · `IntelHybridProbe` -> Property
`has_hybrid_cores` · `X3DVCachePinningHeuristic` -> `LargestL3CcdPinningHeuristic` ·
`IntelHybridPCoreRoutingHeuristic` -> `HotPathOnHighIpcCoreHeuristic`. Neu:
`measure_pinning_effects()` — „**probiert ALLE moeglichen Pinning-Varianten + misst**".
**Diese Korrektur ist bindend und schlaegt `13_saeule_b §10.1/§10.2`.**

### 2.7 Invarianten I1-I6 (T2 `Architekturentscheidungen [P0050-TAB]`-`[P0060-TAB]`)

Der eigentliche Abnahmevertrag — maschinell pruefbar:

| ID | Woertlich | Status heute |
|---|---|---|
| **I1** | „Jeder Lookup traversiert **ausschliesslich Navigationsknoten** bis zu einem terminalen Knoten oder Miss." | nicht geprueft (dieser Auftrag) |
| **I2** | „Ein terminaler Knoten besitzt **genau ein ValueHandle**; Payload ist standardmaessig extern, optional inline." | nicht geprueft |
| **I3** | „Redirect-Knoten komprimieren eindeutige Restpfade, **ersetzen aber keine echte Mehrfachverzweigung**." | nicht geprueft |
| **I4** | „Lokale Seitencodierung darf variieren, **solange die Ordnungsrelation der rohen Byte-Keys nicht verletzt wird**." | nicht geprueft |
| **I5** | „Seitentyp-Umschaltungen sind **explizite Policy-Entscheidungen**; **feste universelle Schwellwerte werden nicht behauptet**." | strukturell erfuellt (Achsen-Architektur) |
| **I6** | „Concurrency bleibt im Kernumfang auf spaetere Erweiterung begrenzt; Termin 2 fokussiert Single-Thread und Read-Scaling-Vorbereitung." | **praezisiert/aufgehoben** durch T7 REV6 §5.23 („Concurrency ist **NICHT** auf spaetere Erweiterung begrenzt ... Read **und Write**"). **Gegen-Fassung T6-SF §5: „Kein Multiwriter als Pflichtkern".** Betreuer-Fassung (T6) ist die abgabeverbindliche — siehe §5-W3 |

**I1-I4 sind heute nicht als Testfamilie ueber die Seitentyp-Kombinationen gefahren** — das ist
ein offener Punkt, kein Befund dieses Auftrags (nicht verifiziert).

### 2.8 Prioritaetsbloecke — drei Generationen, T11 gilt

**T4 (12.04.), `Arbeitsaufstellung [P19]`-`[P38]`:**
- **P0** „Erster lauffaehiger Kern": Datenpfad, Plain-Byte-Keys, Trie-Huelle, Redirect,
  Dense-ART-Seite, Sparse-HOT-Seite, terminale Knoten mit ValueHandle, externer Payload,
  Scalar-Pfad, lokaler perf-Messpfad — **Pflicht**
- **P1** „Forschungs-Kern": Cache-Engine v1, START-Multilevel-Seiten,
  Inline-vs-Handle-Umschaltung, **drei Ordnungsmodi**, **getrennte P-/E-Core-Messung**,
  Barnard-AVX-512-Pfad, Wrapper fuer Baselines — **Pflicht**
- **P2**: B²-artige Decision-/Span-Suche, PRT-Custom-Seite, **Online-Umlagerung**,
  Page-/Pool-Affinity, Code-/Daten-Prefetch-Regeln, erste Kostenmodelle — **Pflicht**
- **P3**: Fingerprint-Overlays, volle Permutationslaeufe, Seitengroessen-Sweeps —
  „Pflicht, aber nachrangig"
- **OPT**: „**Multiples multithreaded Schreiben**" — **die einzige optionale Komponente**
- Cut-Regel `[P57]`: „**P0 und P1 bleiben unantastbar**"

**T9 (29.05.), `Praes. slide7`:** P0 Build-/Submodule-/Include-Konsistenz · P1 vertikaler Pfad
Workload -> PRT-ART-Modul -> Messdatensatz -> Export · P2 „**Erst danach** Achsen-Vollausbau".

**T11 (19.06.), `tbl17.r2`-`r6` — GELTEND:**
- **P0**: „Eine reale Plattform waehlen und den vollstaendigen Messpfad einmal geschlossen
  fahren." DoD: „Ein Satz **echter** CSV/JSON/TikZ/PDF-Artefakte, **nicht nur Demo/Smoke**."
- **P1**: „PMC/Hardware-Counter-Anbindung klaeren." DoD: „Mindestens ein Lauf mit L1/L2/LLC
  oder begruendeter Fallback."
- **P2**: „Kapitel 7 von Platzhalterlogik auf erste echte Ergebnisdarstellung heben."
- **P3**: „Anhang B Code-Struktur auf Deutsch vollstaendig ausfuellen. Keine TODO-Stelle."
- **P4**: „Textliche Glaettung Kapitel 1-3 **nach Habich-Feedback**. Begrifflichkeit:
  Lebewesen/Organ/Achse, **Rang statt Tier**."

**MEILENSTEINE M1-M5 mit Definition of Done (T11 `tbl25.r2`-`r6`) — die haerteste Liste:**
- **M1** „Ein echter End-to-End-Lauf": „Ein Plattformlauf mit CSV/JSON/TikZ/PDF und
  **dokumentiertem Commit/Compiler/Seed**."
- **M2** „PMC-Anbindung oder begruendeter Fallback": „**Die Forschungsfrage ist cache-zentriert;
  ohne Counter bleibt es indirekt.**" DoD: „Mindestens eine Metrikklasse L1/L2/LLC/dTLB
  **oder ein klar dokumentiertes Gate**." — **Schweigen ist keine der beiden erlaubten Optionen.**
- **M3** Anhang B fuellen · **M4** Kapitel 7 aktualisieren („Ergebnisse nicht uebertreiben, aber
  erste Messreihe interpretieren") · **M5** „EN aus DE synchronisieren. **DE fuehrt derzeit.
  EN darf nicht auseinanderlaufen.**"

**AKZEPTANZKRITERIUM (T9 `Praes. slide8`) — existiert nur in der pptx:**
> „**Akzeptanzkriterium: Ein Workload erzeugt ueber CEB ein PRT-ART-Ergebnisartefakt, das in
> CSV/LaTeX/TikZ/PDF landet.**" · „Nicht noch mehr Achsen sammeln, bevor der Kernpfad laeuft.
> Nicht alle Baselines gleichzeitig erzwingen; **zuerst PRT-ART-E2E, dann SOTA-Wrapper**."

### 2.9 Arbeitspakete

- **T3 AP1-AP6**: AP1 Datensatzkatalog · AP2 Baseline-Katalog · AP3 Benchmark-Harness ·
  **AP4 Plattformskripte („lokales Pinning (P/E getrennt)", Slurm, Compiler-/ISA-Matrix,
  perf- und Advisor-Profile)** · AP5 Fairnessregeln · AP6 Termin-4-Uebergabe
- **T4 WP1-WP6**: WP1 Kernindex · WP2 Cache-Engine · **WP3 Plattformpfade („Scalar, AVX2 und
  AVX-512; **getrennte Messung von cpu_core und cpu_atom auf Hybrid-Systemen**")** ·
  WP4 Baseline-Wrapper · **WP5 Benchmark-Harness („fuenf Rohlaeufe, keine Mittelung der
  Perzentile, vollstaendige Artefaktablage")** · WP6 Permutations-/Auswertungsschicht
- **T6 AP1-AP7**: AP1 Plattformmatrix P0 · AP2 Kalibrierungs-Mikrobenchmarks P0 ·
  AP3 Suchworkloads/Datensaetze P0 · AP4 Messstack je Plattform P0 · AP5 Verifikationslogik
  passiv/Warm-up/online P1 · AP6 ZIH-Queue-Strategie P1 · AP7 bedingte Plattformen P2

### 2.10 Scope-Grenzen — was ausdruecklich NICHT gebaut wird

| Grenze | Fundstelle |
|---|---|
| „**GPU, vollstaendige DBMS-Integration und generische SIMD-Arbeit ausserhalb des Suchbaumkerns bleiben Nicht-Ziele.**" | T4 `Scope_Freeze [P82]` |
| „Der einzige optional markierte Block ist **multiples multithreaded Schreiben**." | T4 `[P83]`, `Arbeitsaufstellung [P37]` |
| „**Keine erzwungene Neuimplementierung fremder Algorithmen**; Baselines werden ueber Originalprojekte und Wrapper angebunden." · „**Kein Multiwriter als Pflichtkern.**" · keine GPU-Kerneloptimierung · keine Instruction-Cache-Volltheorie | T6-SF `§5` |
| „Der Architektur-Freeze muss bewusst **unterkomplex** bleiben: Lieber drei saubere Kernfragen beantworten als zehn lose Features ankuendigen." | T2 `Arbeitsaufstellung [P0085]` |
| **T5-Designregeln R1-R6** (Sprachauflagen): R1 „Control Plane, **nicht** vollwertiger 'Kernel'" · R2 „**universelle Schwellwerte sind nicht** wissenschaftlich begruendbar" · R3 Seitenfamilie „**als messgetrieben ausgewaehlte Familie**" · R4 „Inline vs. Handle ist ein **First-Class-Thema**" · R5 „**zuerst messen, dann aktivieren. 'Mehr Prefetch' ist kein Forschungsbeitrag.**" · R6 Code-Page-Optimierung „**sollte nicht die Hauptbegruendung tragen**" | T5 `Landkarte [P98]`-`[P109]` |
| „**Nicht 'Cache direkt verwalten' behaupten**" | T5 `Praes. slide1:P29` |
| **Drei Rede-Verbote** (T9 `Arbeitsaufstellung [p67]`-`[p69]`): nicht behaupten, dass alle 35.000+ Permutationen **experimentreif** sind · nicht behaupten, dass fremde Algorithmen als **Original-Baselines belastbar eingebunden** sind · nicht behaupten, dass PRT-ART als **finaler schneller Suchindex fertig** ist | T9 |

### 2.11 Betreuer-Auflagen H1-H6 (T7, 08.05.) — der einzige protokollierte Wortlaut

| ID | Auflage | Fundstelle |
|---|---|---|
| **H1** | „eine **maximal-detaillierte** Software-Architektur-UML mit allen Klassen + **ER-Modell** + Verbindungen + Relationen + Assoziationen — **'das volle Programm'**", inkl. „ER-Modell fuer persistente Datenstrukturen (auch In-Memory-Buffer-Schema!)" und „Constraints (OCL-aehnlich)" | `Habich_Feedback_2026_05_08.txt Z. 22-32` |
| **H2** | Code-Qualitaets-Bewertung pro Bausteine-Quelle; Pflicht-Artefakt `BAUSTEIN_BEWERTUNG.md` mit Quelle-Commit-Hash, Sterne-Bewertung, „**Habich-Sign-Off: ausstehend \| erteilt am YYYY-MM-DD**". „Bei Zerstueckelung muss der Originalcode teilweise aequivalent geupdated werden (**NUR wenn unbedingt noetig**) ... **um die Vergleichbarkeit der Ergebnisse zu wahren**." | `Z. 50-78` |
| **H3** | LaTeX-Toolchain mit dynamischer Diagramm-Compile; Textbaustein `\PRTARTPlot{dataset=..., isa=..., metric=..., baseline=..., compare=...}` — „**NUR im Appendix-Bereich**" | `Z. 93-117` |
| **H4** | „Die Diplomarbeit ... ist **GETRENNT** von der CacheEngine-Library. **Die CacheEngine ist ein Werkzeug, die Diplomarbeit ist die Anwendung.**" | `Z. 137-139` |
| **H5** | CacheEngine als ABI-stabiler Production-Container; „Optimal-Wahl wird **ABI-stabil geladen + ueber std::map<>-aehnliches Interface in Produktion verfuegbar**"; Test-Setup als „**Verifikations-Suite mitgeliefert (ohne Mess-Aktivierung)**" | `Z. 176-195` |
| **H6** | **KEIN PYTHON** in der Buildchain (Talos-OS-Kompatibilitaet) — „ein einfaches shell skript synchron in bat und sh reicht auch aus" | `Z. 210-216`; schlaegt F-EXTRA-5 und Domaenenmodell v4 D-4 (`codegen.py`) |

**F-EXTRA-8 + Habich-Log (T7 `Architekturentscheidungen_F1_F15.txt Z. 897-933`):** pro
Permutation Bit-Identitaets-, Funktions- und Strukturpruefung; bei Abweichung ein Log fuer
Habich mit Bausteinname, Compiler-Version, Bit-Diff, Beweis der Source-Identitaet und
Ursachen-Hypothese — „**Habich entscheidet, ob Abweichung akzeptabel oder Re-Implementation
noetig**". ER-Feld `BuildArtefact.habich_log_path` existiert dafuer (`07_er_model.md Z. 186`).

**F15 — der Forschungskern (`Z. 464-493`), woertlich:**
> „Es geht **NICHT nur** um den Vergleich gesamter Algorithmen! ... Wir muessen die Algorithmen
> **IN BAUSTEINE NACH DEM DOMAENENMODELL zerlegen**, sodass jeder Algorithmus-Baustein EINZELN
> testweise gegen einen anderen aus **JEDEM BELIEBIGEN anderen Algorithmus** ausgetauscht
> werden kann."

---

## 3. DAS DIFF — was fehlt

Sortiert nach Abgabe-Tragfaehigkeit. **Ist-Basis:** super `18a0bdf3`, ce `90bca126`.
**Nenner der Messdatenlage:** es existieren im gesamten Repo **genau zwei** persistierte
Mess-CSV —
`measurement/20260726-164259-d03-strukt-r-erstbeleg/measurements.csv` (**17 Zeilen = 16
Datenzeilen**, verifiziert `wc -l`) und
`docs/sessions/backups/20260805-.../all19_pilot.csv` (4 Zeilen, `pmc_available=0`).
Gegenprobe `find . -name "measurements.csv" -not -path "*/build*"` = 2 Treffer.
Der CSV-Header (`;`-separiert, 163 Felder) ist verifiziert; die Feldliste unten ist daraus.

### 3.1 ABGABE-KRITISCH — ohne diese Position traegt die Arbeit nicht

**D-01 · Kein einziges PRT-ART- oder SOTA-Messergebnis existiert.**
- *Plan-Soll:* T9 `Praes. slide8`: „Akzeptanzkriterium: Ein Workload erzeugt ueber CEB ein
  **PRT-ART-Ergebnisartefakt**, das in CSV/LaTeX/TikZ/PDF landet." · T10 `Praes. slide3:p9/p10`:
  „A_defined: PRT-ART gegen **8 Rang-1-SOTA-Profile**" / „A_full: gegen alle **30 SOTA-Profile**"
  · T11 `tbl13.r3` Messreihe A.
- *Ist:* `/usr/bin/grep -c "prt_art" measurement/20260726-.../measurements.csv` = **0**
  (Gegenprobe: `search_algo` als Header-Feld vorhanden, 16 Datenzeilen existieren). Alle 16
  Zeilen sind reine Cache-Engine-Achsen-Permutationen; Spalte `pruefling_type` = `-`.
  Das Manuskript sagt es selbst: `thesis/.../05_evaluation.tex:182-186` — „Methodik und
  Auswertungs-Pipeline ... auf **Beispieldaten** verifiziert ... die vollstaendigen Laeufe der
  Pflicht-Messreihen auf den Zielplattformen **stehen aus**"; Z. 177: „Die Messdaten dieser
  Dimension **stehen aus**".
- *Verdikt:* **FEHLT.** *Zu tun:* Ein Lauf mit `<sota_series>` ueber die 6 gebauten
  Lebewesen + Pruefling, persistiert, mit Stempel (D-08).

**D-02 · Hybrid-Term der Forschungsfrage: nicht gebaut, per Test auf `false` zementiert.**
- *Plan-Soll:* T4 `[P9]` (Term der Forschungsfrage) · T3 `[p016]` Hybrid-Regel · T3 `[p077]`
  Risiko + Gegenmassnahme · T4 `[P77]`/`WP3` · T6-Praes. Folie 4 · Baustein `HybridCorePinning`
  (T7 Domaenenmodell `Z. 441-447`).
- *Ist:* `/usr/bin/grep -rl "cpu_atom" Code/external/comdare-cache-engine/libs` = **0 Dateien**.
  Gegenprobe `cpu_core` = **2 Treffer**, beide nur Feldname und Sperrkommentar:
  - `libs/cache_engine/include/cache_engine/platform/i_platform_probe.hpp:20`
    `bool cpu_core_atom_perf_separation = false;`
  - `libs/cache_engine/include/cache_engine/platform_probe/cpuid_platform_probe.hpp:38-39`
    `// AP-13: Topologie/Pinning bleibt bewusst ungesetzt (has_hybrid_cores,`
    `// cpu_core_atom_perf_separation, preferred_pinning_policy).`
  Tests schreiben den Zustand fest: `tests/unit/test_cpuid_probe.cpp:63` und
  `tests/unit/test_platform_concepts.cpp:38` je `EXPECT_FALSE(props.cpu_core_atom_perf_separation)`.
  `libs/common/platform/hybrid_core_pinning/` = `.gitkeep` + `CMakeLists.txt:2` „Skelett
  (Phase 4.B) — **keine Implementation**". Der CSV-Header traegt **kein** `cpu_class`
  (verifiziert an der 163-Feld-Liste).
- *Verdikt:* **FEHLT.** Zusaetzlich: die reale PMC-Quelle aggregiert so, wie T3 verbietet —
  `libs/cache_engine/builder/linux_perf_pmc_source.hpp` oeffnet generische
  `PERF_TYPE_HW_CACHE`-Counter ohne PMU-Wahl (kein `/sys/devices/cpu_core/type`).
  *Zu tun:* PMU-Typ aus sysfs lesen, zwei Counter-Saetze, `cpu_class` in den Record und die CSV.

**D-03 · Prefix-Lookup und Prefix-Enumeration existieren nirgends.**
- *Plan-Soll:* T1 Exposé `[P0015]` (Forschungsfrage 3) · T1-H3 `[P0011]` („**die staerksten
  Zieloperationen**") · T3 `[p047]` (9 Operationen inkl. prefix hit/miss/enumeration).
- *Ist:* `libs/test_infra/workload_generator/.../workload_generator.hpp:38-45`:
  `enum class OperationKind { Read, Update, Insert, Scan, ReadModifyWrite, Erase }` —
  **kein Prefix**. `PrefixScan` existiert genau einmal als unbenutzter Enum-Wert:
  `libs/cache_engine/include/cache_engine/concepts/request_context.hpp:12`
  (Gegenprobe `/usr/bin/grep -rn "PrefixScan" libs apps tools` = **1 Treffer, der
  Deklarationsort selbst**). CSV-Ops: `insert/lookup/erase/clear/scan/rmw`.
- *Verdikt:* **FEHLT.** *Zu tun:* `PrefixLookup`/`PrefixEnumerate` in `OperationKind`,
  Workload-Generator und Mess-POD. Ohne sie beantwortet kein Lauf die woertliche Zieloperation.

**D-04 · Ablationsstufe „Cache-Engine Off" ist keine Mess-Dimension.**
- *Plan-Soll:* T4 `[P242]` Exp. 5 (5 Ablationsstufen, „**Kausaler Nachweis 'active > passive'**")
  · T6-SF `Z. 9-12` (3 Verifikationsmodi, Erfolg nur gegen den statischen Modus).
- *Ist:* Typ vorhanden —
  `libs/cache_engine/include/cache_engine/concepts/cache_engine_mode.hpp` mit
  `{BASELINE_NO_ENGINE, HEURISTIC_STATIC, INFORMED_KALIBRIERT, AUTOMATIC_ADAPTIVE}` —
  aber **keine CSV-Spalte**, nicht in `kCompositionAxisNames`, kein XSD-Element.
  Gegenprobe `ablation|PolicyAblation` in `libs` = 0.
- *Verdikt:* **TEILWEISE** (Typ ja, Messachse nein). *Zu tun:* Modus als Dimension in
  XSD + Profil + CSV; mindestens die Stufen `BASELINE_NO_ENGINE` und `Full` fahren.

**D-05 · Seitentyp permutiert nicht — `page_type` ist build-only.**
- *Plan-Soll:* T4 `[P32]`-`[P55]` (6 Klassen mit Prio) · **T4-H2** („Dense-, Sparse- und
  Multilevel-Seiten gewinnen abhaengig von Datensatz, ISA, Core-Typ und Ordnungsmodus
  unterschiedlich") · Thesis-eigene H1 (`05_evaluation.tex:10-12`).
- *Ist:* 6 Typen implementiert (`libs/cache_engine/topics/nodes/axis_01_page_type/`), aber:
  `libs/cache_engine/builder/experiment_tree/registry_to_axis_levels.hpp:7` — „die uebrigen
  5 Registry-Achsen = **3 build-only-Achsen (page_type/01**, simd_extension/09b,
  general_hardware)"; `:144` „build-only-/System-Achsen (**binary_id-orthogonal**)".
  Der CSV-Header traegt **keine** `seg_page_type_ns`-Spalte (verifiziert: die 18 `seg_*`-Felder
  sind search_algo, cache_traversal, mapping, path_compression, node_type, memory_layout,
  allocator, prefetch, concurrency, serialization, value_handle, index_organization,
  io_dispatch, migration_policy, filter, queuing_q1, queuing_q2, persistence_target).
- *Verdikt:* **ABGEWICHEN.** *Zu tun:* `page_type` in die permutierende Achsenmenge heben.
  **Groesster Einzelhebel im ganzen Diff** — entsperrt Thesis-H1 und T4-H2 zugleich.

**D-06 · Die sechs Pflichtdatensaetze werden nicht gemessen.**
- *Plan-Soll:* T3 `[p011]` (dreifach bestaetigt in T4 `[P242]`, T11 `tbl13.r5`).
- *Ist:* Akten liegen (`Code/test_data_xml/*.test_data.xml`, 5/6 mit echter Pruefsumme; `xml`
  = honest-0, `size_bytes 0`). **Der Messpfad konsumiert sie nicht:**
  `libs/common/serialization/xml_config_parser/xml_config_parser.hpp:178-181` woertlich —
  „Fehlt `<datasets>` => Liste leer = heutiges Verhalten (**synthetischer YCSB-Generator**)
  byte-identisch. Der **Loader-MESS-Konsum** ... ist der **dokumentierte offene Folge-Schritt**".
  Gemessene Keys sind Zufallszahlen im 8-Bit-Raum:
  `libs/cache_engine/anatomy/abi_adapter.hpp:636/649` `std::mt19937_64 rng{seed}` ->
  `algo.lookup(static_cast<K>(rng() & 0xFFu))`. Golden fuehrt nur 2-3 Akten
  (`all_axes_golden.profile.xml:118-123`: url, sosd_books_200M).
  **Zugleich behauptet das Manuskript** (`05_evaluation.tex:33-37`) reale String-Datensaetze
  als Datengrundlage.
- *Verdikt:* **TEILWEISE — und die Manuskript-Aussage ist nicht gedeckt.** *Zu tun:*
  `load_or_generate_ycsb` an die Akten binden; oder die Manuskript-Aussage entschaerfen.

**D-07 · PRT-ART als Pruefling ist von ART nur durch eine Achse unterschieden.**
- *Plan-Soll:* T4 `[P58]` Value-Pfad, `[P59]` „ValueHandle ist Kernbestandteil ... keine
  spaetere Verzierung" · T9/T10/T11 P1 „vertikaler PRT-ART-Pfad schliessen".
- *Ist:* `libs/cache_engine/compositions/prt_art_reference.hpp:5-11` — „PRT-ART = ...
  **identisch zu ArtComposition** ... ABER mit dem REDIRECT-Organ in der
  path_compression-Achse" => Unterschied in **1 von 18 Achsen**.
  Alle Thesis-Profile deklarieren `<tier id="prt_art" profile_ref="../sota/art.profile.xml"`
  (`all_axes_golden.profile.xml:23`) — ein `prt_art.profile.xml` existiert nicht.
  Der reale PRT-ART-Code (`comdare-prt-art/prt_art/include/prt_art/nodes/redirect_node.hpp`,
  `value_handle/*`, `allocator/pool_set.hpp`) wird von keiner ce-Datei im Messpfad inkludiert;
  `prt_art_search_engine.hpp:383` nutzt weiter `std::map<binary_key_t, storage_value_t>`;
  das Codegen-Template ist quarantaeniert
  (`prt_art/codegen/templates/prtart_body.hpp.template:14-18` „**ALT-PFAD — NICHT Teil des
  Mess-Pfads**").
- *Verdikt:* **ABGEWICHEN.** *Zu tun:* Owner-Entscheid noetig (§7, Frage O-2) — entweder
  Vertikalisierung oder ausdrueckliche Umrahmung als „Pruefling = Kompositionspunkt".

### 3.2 HOCH — Kernaussage nicht belegbar

**D-08 · Reproduzierbarkeits-Stempel fehlt am Artefakt.** T11 `tbl25.r2` verlangt
„dokumentiertem **Commit/Compiler/Seed**". Der CSV-Header traegt `platform` und
`build_version` (Wert `m3v2-smoke`), aber **kein** `commit`, `compiler`, `seed`, `isa`
(verifiziert an der Feldliste). Der Messordner enthaelt nur `measurements.csv` + `per_binary/`,
kein Manifest. Mechanik existiert ungenutzt (`abi/toolchain_stamp_glied.hpp`,
`builder/ceb_version_stamp.hpp`). **TEILWEISE.** *Billig zu schliessen.*

**D-09 · Wiederholungen: Plan 5, Profile 3, real 1.** T3 `[p013]`/`[p066]`, T4 `WP5`,
T6 `Z. 16` verlangen dreifach **fuenf**. Verifiziert: **alle** Thesis-Profile tragen
`<repetitions count="3" .../>` (`all_axes_golden.profile.xml:160`, `base_pilot:63`,
`cacheline_study:110`, `fb_numa_page_study:75`, `ff2_node_width_study:62`,
`m3_golden_coverage:124`, `m3v2_sota_pilot:83`, `m3v2_study:148`); Smoke-Profile `count="1"`;
`count="5"` kommt in **keinem** Profil vor. Im realen Artefakt: `repetition` = 0 in allen 16
Zeilen. **ABGEWICHEN.** *Zu tun:* Owner-Entscheid E3 (3) gegen Plan (5) klaeren, §5-W1.

**D-10 · Zweite Pflichtplattform fehlt vollstaendig.** T3 `[p008]`, T4 `[P76]`/`[P78]`.
Verifiziert: `/usr/bin/grep -ci "barnard|slurm|zih" .gitlab-ci.yml` = **0**
(Gegenprobe `prod` = 14). Der Messjob laeuft auf einem AMD-Runner (`tags: [prod, baremetal,
amd]`, `.gitlab-ci.yml:719`/`:806`). **FEHLT.** *Zu tun:* entweder ein ZIH-Zugang, oder eine
ausdrueckliche Grenze in der Arbeit (§6).

**D-11 · Branch-Kosten haben keine Quelle.** T1 `[P0016]`/`[P0075]`/`[P0128-TAB]`,
T3 `[p052]`. Ist: `libs/cache_engine/builder/linux_perf_pmc_source.hpp:16` woertlich —
„**branch_misses wird von KEINER PMC-Quelle befuellt (offener Posten M-3a)**". Der CSV-Header
hat keine Branch-Spalte (`pmc_*` = l1, l2, l3, dtlb, coherence_invalidations, energy,
available). **FEHLT.**

**D-12 · Drei Ordnungsmodi existieren nicht.** T1-H4 `[P0012]`, T3 `[p050]`, T4-P1 `[P25]`
(„drei Ordnungsmodi" ist **P1-Pflicht**), T4-H2 nennt Ordnungsmodus als Bedingungsvariable.
Ist: keine Ordnungs-/Sortierachse unter den 18 (Achsenliste s. D-05); Gegenprobe
`ordering_mode|OrderingMode|locally_sorted|lexikograph` = 0 Achsen-Treffer. **FEHLT.**
*Anmerkung:* T4 nennt „drei Ordnungsmodi" als Pflicht, benennt sie aber nirgends —
die Definition muss aus T3 `[p050]` kommen.

**D-13 · Achsenzahl: vier unvereinbare Staende.** T11 sagt 19+3; Code fuehrt 18 Organ-Achsen
(`axis_path_serialization.hpp:39-42`, verifiziert am CSV-Header); `topics/` hat 28
`axis_*`-Verzeichnisse; `permutation_axes.xml` deklariert 11; T9 sagte 22.
**ABGEWICHEN** — jede Zahlenangabe in der Thesis braucht die Ebene dazu.

**D-14 · SOTA: 6 statt 8 Rang-1-Lebewesen.** Thesis FF3 (`01_einleitung.tex:134-137`) nennt
acht (ART, HOT, Masstree, CoCo-Trie, START, B²-Baum, Wormhole, SuRF). Verifiziert:
`libs/cache_engine/profile_facade/sota_catalog.hpp:272` —
`if (sn == "art" || sn == "hot" || sn == "wormhole" || sn == "surf" || sn == "masstree" ||
sn == "start")`, Kommentar `:267` „Wir nehmen die **ersten 6** (CE-Reimpl)".
**CoCo-Trie und B²-Baum fehlen als Lebewesen**, obwohl `sota/coco_trie.profile.xml` und
`sota/b2tree.profile.xml` existieren. **TEILWEISE (6/8).**

**D-15 · Baselines sind Reimplementierungen, nicht Original-Wrapper.** T3 `[p043]`
(„Fremdalgorithmen werden **nicht neu implementiert**"), T4 `[P80]`, T6-SF `§5`.
Ist: alle SOTA-Adapter `option(COMDARE_HAVE_<X> ... **OFF**)`; gemessene „SOTA" sind
ce-Achsen-Rekompositionen (`sota_catalog.hpp:267` „CE-Reimpl"). Die Thesis rahmt das ueber FF1
um. Die T9-Rueckfrage dazu („Wie strikt soll der Nachweis 'Original-Implementierungen nur als
Wrapper' bereits vor den ersten internen Messungen gefordert werden?", `Arbeitsaufstellung
[p64]`) ist im Korpus **unbeantwortet**. **ABGEWICHEN (bewusst, dokumentiert).**

**D-16 · H1/H2/H3-Auswertungsfelder ohne Erzeuger.**
`libs/cache_engine/builder/commands/execution_result.hpp:34-36` deklariert
`H1_clu_improvement`, `H2_layout_score`, `H3_inline_external_ratio`. Gelesen in
`compare_engine_command.hpp:51-56`, ausgegeben in `result_aggregator.hpp:94-127` — **gesetzt
nur im Test** (`builder/commands/tests/test_commands.cpp:92`). `h1_clu_validated()` prueft
dauerhaft gegen 0.0. **FEHLT (toter Pfad).**

**D-17 · Mess-Validitaet der einzigen realen PMC-Daten ist ungeklaert.**
In `measurements.csv` steht in einer Zeile `total_ns = 46.015.934` (46 ms) bei
`pmc_cache_misses_l1 = 1.169.857.296`. Bei ~4 GHz sind das ~1,8e8 Zyklen => **>6 L1D-Misses
pro Zyklus** — physikalisch unmoeglich. Zugleich `pmc_cache_misses_l3 = 0` in **allen** Zeilen
trotz `pmc_available = 1`, obwohl der LL-Counter geoeffnet wird
(`linux_perf_pmc_source.hpp:213-214`). L2/coherence sind ehrlich 0 (nie geoeffnet, `:13`).
**BEFUND — vor jedem mehrtaegigen Voll-Lauf zu klaeren.** Der Owner-KERN „eigenes Messverfahren
verdaechtigen" greift hier direkt.

### 3.3 MITTEL

**D-18 · Fairness-Modus deklariert, nicht wirksam.** T3 `[p069]`. Ist: `fairness_mode` ist
CSV-Spalte und Metadaten-Tag (`sota_catalog.hpp:453-457`: „**REINE Reihen-Metadaten** ...
NICHT Teil der binary_id ... **DATEN-gated**"); Wert `-` in allen 16 Zeilen; kein produktives
Profil setzt `fairness=`. **TEILWEISE.** *Billig: ein Attribut.*

**D-19 · p95 fehlt, HDR ohne Konsument.** T1 `[P0122-TAB]`, T3 `[p054]`/`[p065]`. CSV fuehrt je
Operation **p50 und p99**, **kein p95** (verifiziert an der Feldliste); `LATENCY_P95` ist als
Kategorie deklariert. `libs/common/measurement/hdr_histogram_wrapper/latency_hdr_histogram.hpp`
ist vendored und unit-getestet, hat aber ausser dem Test keinen Konsumenten. **TEILWEISE.**

**D-20 · CLU und Footprint: kein Advisor, kein ausgewiesener Wert.** T1 `[P0131-TAB]`,
T3 `[p017]`, T4 `[P244]`, T6-SF `Z. 12`. Ist: `libs/common/measurement/advisor_wrapper/` =
`CMakeLists.txt:2` „Skelett (Phase 4.B) — keine Implementation". CLU wird strukturell
modelliert (`anatomy/observable_tier.hpp:82` „CLU = field_bytes/(cache_lines*line_bytes)"); die
Rohgroessen stehen als `stat_memory_layout_field_bytes` / `stat_memory_layout_cache_lines` in
der CSV => **CLU ist ableitbar**, aber es gibt keine CLU- und keine Footprint-Spalte.
**ABGEWICHEN (ehrliches Surrogat statt Advisor)** — muss als solches in der Methodik stehen.

**D-21 · Speicherbilanz unvollstaendig.** T1 `[P0125-TAB]` („**Ohne saubere Speicherbilanz
bleibt der Layout-Anspruch unglaubwuerdig**"). CSV hat `peak`, `bytes_alloc`, `bytes_in_use`,
`alloc_cnt`, `dealloc_cnt`, `fail` + `stat_allocator_*` — aber **keine Normierung auf Key**
(kein `bytes_per_key`), keine getrennten Poolgroessen nach Suchseiten/Redirects/Values, keine
Fragmentierung/Konsolidierungskosten. **TEILWEISE.**

**D-22 · ISA: 2 von 3 x86-Pfaden, 0 von 2 ARM.** T3 `[p009]`, T4 `[P76]`, T6 `Z. 13`.
Golden permutiert `simd { no_extension, avx2 }`; AVX-512 ausdruecklich weggelassen
(`experiment_golden_kern.xml`, Kommentar „avx512 ist nicht universell und bleibt draussen") —
obwohl prod1 als `amd_zen5_avx512` registriert ist. ARM-Pfade sind `allow_failure`.
**TEILWEISE.**

**D-23 · Messreihe B ist im eigenen Kommentar ein Duplikat von A.**
`Code/experiment_config/messreihen.xml`, `<messreihe id="B_CacheEngine_Perms">`: „Im aktuellen
Skelett **identisch zu A_full**". **ABGEWICHEN.**

**D-24 · Achsen-Goldstandard: 7 Bestandteile, real erfuellt 2-3.** T9 `[p32]`. Ueber 28
Achsen-Verzeichnisse: Registry 28/28 · StrategyBase 23/28 · Concepts 26/28 · **ConfigSet 0/28**
· Flags 8/28 · **Wrappers 0/28** · **axis-lokale CMakeLists 0/28**. Auch die Referenzachse
`axis_06_allocator` hat weder ConfigSet noch Flags noch Wrapper. **TEILWEISE.**

**D-25 · 12 Sub-Engines C01-C12: Interfaces ohne Implementierung.** T7
`02_uml_cache_engine.md`, `extract_comdare_audit.md`. Ist: `libs/cache_engine/subsystems/`
enthaelt c01..c12 mit je einem `i_*.hpp`; Zaehler konkreter Ableitungen ueber `libs apps tests`
= **0 fuer alle zwoelf**. Teile des Verhaltens leben unter anderem Namen in
`libs/cache_engine/axes/*` (prefetch/migration/allocator/telemetry/filter) — **ohne Gegenstueck
bleiben C02 Pinning, C04 Coherence, C10 Topologie**. **TEILWEISE.**

**D-26 · Thesis-H2 beschreibt nicht, was der Code liefert.** Thesis
`05_evaluation.tex:13-18` verspricht ein „Qualitaets-Audit ueber **sieben** Bewertungs-Achsen
(Stil, Tests, Dokumentation, Wartbarkeit, Pflege-Status, Lizenz, Build-System; Skala 1-5,
`docs/quality_audit`)". Ist: `sota_h2_scores.xml` = **eine** Zahl, „gewichtete
**cppcheck**-Befunddichte pro kLOC"; `docs/quality_audit` existiert nicht (`find -type d -name
quality_audit` = 0, Gegenprobe `docs/audits` existiert); CSV-Spalte `h2_code_quality_score` =
`-` in allen 16 Zeilen. **ABGEWICHEN.**

**D-27 · Pseudo-Prefetch unveraendert.** T11 `[p20]` sagt selbst: „darf **nicht als echter
Speicher-Prefetch verkauft werden**". Ist:
`libs/cache_engine/axes/prefetch_axis/axis_07_prefetch_path_oriented_impl.hpp Z. 11-15` —
interpretiert die ersten 8 Byte eines Schluessels als uint64-**Adresse**. Kein
`__builtin_prefetch` auf realem Speicher. **ABGEWICHEN, deklariert** — der Vorbehalt muss in
Kapitel 7 stehen bleiben.

### 3.4 NIEDRIG

**D-28 · `libs/search_engine/` = 8 leere Skelett-Ordner** (je nur `CMakeLists.txt` mit „Skelett
(Phase 4.B) — keine Implementation"); der Inhalt lebt real in `libs/cache_engine/topics|axes/`.
**Namensdrift, nicht Fehlen** — aber ein Auditor zaehlt hier Luft.

**D-29 · `num_p_cores`/`num_e_cores` sind tote Deklarationen.**
`Code/02_messung_driver/hardware_filter.hpp:40-41` — repo-weiter Treffer fuer beide: genau
diese 2 Zeilen. Symptom von D-02.

**D-30 · EN-Kapitel sind stale.** DE sagt „achtzehn Organ-Achsen"
(`01_einleitung.tex:191`), EN noch „neunzehn" (`01_introduction.tex:111,115,137,173`;
`02_fundamentals.tex:274,414,435`) — die Dateikoepfe vermerken die Divergenz selbst. Verstoss
gegen **M5** („DE fuehrt derzeit. EN darf nicht auseinanderlaufen").

**D-31 · „Rang statt Tier" — ERFUELLT im Manuskript.** `01_einleitung.tex:134-138` nutzt
durchgaengig „Rang-1/2/3". Verbleibende „Tier"-Treffer in Kap. 3 sind das deutsche Wort
(`Tier-Binary`, `Saeugetier`) und konform zur Metapher. **Kein Handlungsbedarf am Text.**
Im Code bleibt `Tier` (nicht von der Auflage betroffen, die Kapitel 1-3 nennt).

### 3.5 Was ich als ERFUELLT verifiziert habe (damit es nicht doppelt gebaut wird)

- **Seitentyp-Familie 5/6** implementiert (`topics/nodes/axis_01_page_type/`: `_redirect`,
  `_dense_byte`, `_extended_dense`, `_sparse_patricia`, `_custom_cache`) — der sechste heisst
  `_bplus` und ist laut Kopfzeile Masstree-Familie, nicht die B²-Decision/Span-Seite.
- **ValueHandle Inline/External/ChainRef** vorhanden (`topics/value_handle/axis_14_value_handle/`).
- **Flag-System mit 10 Baenken** inkl. `telemetry_bank`
  (`include/cache_engine/concepts/permutation_flags.hpp:4`).
- **32-Byte-Mess-POD exakt wie T7 geplant**, inkl. Feldern `cpu_class`, `telemetry_strategy`,
  `sampling_n` — nur ohne Erzeuger (D-02).
- **Anatomy/ABI-Saeule** real (`SearchAlgorithmAnatomy`, `AnatomyModuleLoader`,
  `COMDARE_DEFINE_ANATOMY_MODULE`).
- **Welch-Test** in der Builder-Saeule (T9 `[p34]` gefordert).
- **PMC deutlich weiter als der Plan-Stand von T11:** `LinuxPerfPmcSource` real
  (`perf_event_open`), Factory, `NullPmcSource` als ehrlicher Fallback; im Artefakt
  `pmc_available = 1` in 16/16 Zeilen, L1 und dTLB mit Werten. **T11s „NullPmcSource / nicht
  erhoben" ist ueberholt** (siehe §5-W2). Rest-Mangel: Hybrid-PMU (D-02), L2/L3 (D-17),
  Branch (D-11).
- **Keine Mittelung, Rohwerte getrennt** (`builder/experiment_tree/repetition_plan.hpp:45-47`:
  „EINE Zeile je Wiederholung (separat, NIE aggregiert)"; alle Profile `interpolate="false"`).
- **YCSB A-F** als Lastprofile vorhanden und im Golden deklariert.
- **Datensatz-Akte mit 9 Feldern** mechanisch erzeugt (FNV-1a-64-Pruefsumme, `line_count`).
- **Mess-Tooling als EINE vereinte CEB** ueber `{wallclock, macro, micro}`
  (`experiment_golden_kern.xml`, mit Regressionsvermerk zur frueheren Aufspaltung).
- **`MessreihenMode`** vorhanden (`defined|full|full_sampled`) — T8s Regel „Defined fuer
  Manuskript, Full nur Cluster" ist abbildbar.

---

## 4. Die vorhergesagten Risiken — und welche eingetreten sind

Der Plan fuehrt drei Risiko-Tabellen (T2, T3, T9) plus Prosa-Risiken in T4/T7/T11.
**Das ist die teuerste Kategorie: jemand hat es gewusst und die Gegenmassnahme wurde nicht
gebaut.**

| Risiko (woertlich) | Quelle | Gegenmassnahme (woertlich) | Eingetreten? |
|---|---|---|---|
| „**Hybrid-CPU-Zaehler werden falsch aggregiert**" | T3 `[p077]` | „**strikte Trennung cpu_core/cpu_atom; JSON-Ausgabe aus perf**" | **JA, voll.** D-02: Gegenmassnahme nicht gebaut, Feld per Test auf `false` zementiert. Der rote CI-Job vom 06.08. ist die Manifestation. |
| „**Schwellwerte kippen je CPU**" / „Architekturabhaengigkeit" | T2 `[P0071-TAB]` | „**Hardwareprofile und Messkalibrierung statt universeller Konstanten**" | **teilweise abgewendet** — Achsen-Architektur erfuellt I5 strukturell; aber ohne zweite Plattform (D-10) ist die Kalibrierung nicht belegt. |
| „**Zu viele Achsen vor erster Messung**" (Bewertung **hoch**) | T9 `Arbeitsergebnis [p82]` | „**Goldstandard auf wenige Achsen anwenden, erste Messung vor Vollausbau erzwingen**" | **JA.** 28 Achsen-Verzeichnisse, Goldstandard 2-3 von 7 erfuellt (D-24), und noch immer keine PRT-ART/SOTA-Messung (D-01). |
| „**Framework-Breite ueberholt PRT-ART-Kern**" (**hoch**) | T9 `[p68]` | „Vertikalen PRT-ART-End-to-End-Pfad priorisieren" | **JA.** D-07: Pruefling ist ART + 1 Achse; der reale PRT-ART-Code ist nicht im Messpfad. |
| „**Submodule-/Include-Pfad-Drift**" (**hoch**) | T9 `[p70]` | „Cache-Engine-Layout und PRT-ART-CMake synchronisieren" | **JA, aktenkundig ueber zwei Termine.** T8 meldete „9 hardcodierte Pfade aktualisiert"; T9 stellte 14 Tage spaeter fest, dass prt-art noch auf `cache_engine/include` statt `libs/cache_engine/include` zeigt. |
| „**External FetchContent erschwert Reproduzierbarkeit**" | T9 `[p74]` | „**Lokale Vendor-/Third-Party-Caches** oder dokumentierte Bootstrap-Schritte" | **abgewendet** — die heutige Vendoring-Doktrin (`vendor -> faithful -> selfcontained`) hat hier ihren dokumentierten Ursprung. |
| „**inline vs. external macht Vergleiche unfair**" | T3 `[p079]` | „Common-Denominator- und Native-Modus **strikt trennen**" | **JA.** D-18: Mechanik da, in keinem produktiven Profil gesetzt. |
| „alte oder schwer baubare Referenzimplementierungen" | T3 `[p076]` | „frueher **Build-Screening-Katalog**; Alternativpfad pro Baseline" | **JA.** D-15: alle Adapter default-OFF, gemessen wird CE-Reimpl. |
| „**Permutationsmatrix wird zu gross fuer ad-hoc Interpretation**" | T3 `[p078]` | „Kernmatrix vs. Erweiterungsmatrix; Nachtlaeufe und Batch-Auswertung" | **abgewendet** — `MessreihenMode` + `defined/full` sind gebaut. |
| „**Framework-Explosion** (zu viele kombinierbare Features)" | T2 `[P0068-TAB]` | „Kern auf **fuenf Seitentypen, ValueHandle, Ordnungsmodus und Cache-Engine** begrenzen" | **JA** — 28 Achsen-Verzeichnisse, 18 permutierende, ~120 Bausteine (T7 N-Phase). Zugleich fehlt der genannte Ordnungsmodus (D-12). |
| „**Telemetrie-Overhead durch Cacheline-Ping-Pong**" (Kuehn-Mail) | T7 `Kuehn_Erkenntnisse Z. 24-34`: „**Naive Pro-Knoten-Histogramm-Implementierung ist UNBRAUCHBAR fuer parallele Workloads**" | `LeafOnlyCounter`, `RetroactiveAggregation`, `LeafOnlySampledCounter<N>`, `NotInTopLevels`-Constraint | **nicht geprueft** in diesem Auftrag — Achse 11 existiert; ob das Constraint compile-time greift, ist offen. |
| „**Grosse Knoten auf Intel-STRONG-Prefetch: Slowdown 0.4-1x**" | T7 `13_saeule_b Z. 543` | „auf i9-14900KS muessen **kleine Knoten (<1 KiB) bevorzugt** werden" | **nicht eingetreten, weil nicht gemessen** — die Warnung wird relevant, sobald D-02/D-10 geschlossen sind. |
| „**'gruene' Messung an Mock-Modulen**" (`op_count=0` ist Mock-Verhalten) | T7 REV7.5 `29_... Z. 150-153` | ehrliche Kennzeichnung | **teilweise eingetreten** — der einzige Messbeleg traegt `build_version = m3v2-smoke`; das Manuskript nennt ihn korrekt „Smoke". |
| „**codegen.py verletzt H6/F-EXTRA-5**" | T7 `extract_comdare_audit Z. 257/297` | CMake + `codegen.sh`/`codegen.bat` | **nicht in diesem Auftrag verifiziert** — der heutige Kanon „Kein Python in der Buildchain" deckt sich mit H6; Nachpruefung offen. |
| „**Apparate-Konfundierung** bei node_type und memory_layout (Q2-Schritt-4)" | T11 `[p21]`; Vorlaeufer T10 `[p23]` Achsen-Delegations-Audit | „jedes Organ uniform durch die Organ-Interfaces" · V2-POD | **JA, offen.** T10 `[tbl24.r4]` fuehrt „V1-POD ohne node-Felder — **V2-POD offen**" und `slide7:p9` „**Offen: Suchmetriken muessen ebenfalls aus demselben delegierenden Store kommen**". Nie als erledigt gemeldet. |

**Die Bilanz:** Von 15 vorhergesagten Risiken sind **8 nachweislich eingetreten**, 4 abgewendet,
3 nicht pruefbar. Alle acht eingetretenen hatten eine benannte Gegenmassnahme.

---

## 5. Widersprueche Plan gegen spaetere Notizen

Der Plan ist Primaerquelle. Ich benenne die Widersprueche — ich entscheide sie nicht.

**W1 · Wiederholungen: Plan 5, Owner-Entscheid 3, real 1.**
Plan: T3 `[p013]`, T3 `[p066]`, T4 `WP5`, T6-AA `Z. 16` — **dreimal uebereinstimmend fuenf**.
Session-Entscheid E3 (Owner, 16.07., Ledger `:534`): „Per Planung sind **3 Wiederholungen** je
Messkonstellation PFLICHT." Alle Profile fuehren `count="3"`; der einzige Beleg hat
`repetition = 0`. **Die Abweichung ist bewusst getroffen und dokumentiert — aber sie muss im
Methodikkapitel als Abweichung vom Plan benannt werden**, sonst ist sie eine stille
Unterschreitung.

**W2 · PMC-Stand: Plan/Ledger/Anhang sagen drei verschiedene Dinge, alle drei sind heute falsch.**
- T11 `[p18]` (19.06.): „L1/L2/L3-, dTLB- und Kohaerenz-Metriken sind ... als nicht erhoben /
  **NullPmcSource** markiert."
- Ledger `:68`: „Reale Cache-Misses/PMC bleiben **honest-0 bis #26**."
- Anhang-Limitierung 1: „NullPmcSource, available=false".
- **Die CSV vom 26.07. widerlegt alle drei:** `pmc_available = 1`, L1 und dTLB mit realen
  Werten. **Der Anhang ist gegenueber der Messung 20 Tage stale.** Zugleich ist L3 = 0 trotz
  geoeffnetem Counter (D-17) — die Wahrheit liegt zwischen den Fassungen, keine ist korrekt.

**W3 · Multiwriter: T6 (Betreuer-Scope) gegen REV6 (Architekten-Praezisierung).**
T6-SF `§5`: „**Kein Multiwriter als Pflichtkern**; Schreibparallelitaet bleibt nachgelagert" —
deckungsgleich mit T4 „OPT". T7 REV6 `§5.23` (11.05.): „Concurrency ist **NICHT** auf spaetere
Erweiterung begrenzt. PRT-ART unterstuetzt Multi-Threading fuer Read **und Write**."
**BEFUND:** T6 ist Betreuer-Scope, REV6 ist Architekten-Praezisierung. Fuer die Abgabe ist die
Betreuer-Fassung verbindlich; die Praezisierung darf nicht dazu fuehren, dass Multiwriter zur
Pflicht wird und den Kern verwaessert (T4 `[P48]`: „Diese Themen duerfen die
Cache-Engine-Frage nicht verdraengen").

**W4 · Online-Umlagerung: T4 Pflicht, T5 „bewusst sekundaer".**
T4 `Scope_Freeze [P71]`: „Die Cache-Engine **darf live Pages umbauen und verschieben**. Dieses
Verhalten ist **nicht Optional, sondern Teil des Forschungsbeitrags**." T5 `Praes. slide6:P12`
stuft „**aggressive** Online-Umlagerung" als „bewusst sekundaer" ein.
**Aufloesung (Wortlaut-genau):** T5 sagt *aggressive*, nicht Online-Umlagerung schlechthin;
T4 ordnet sie ohnehin bei **P2** ein, nicht P0/P1. **Online-Relocation bleibt Pflicht (P2),
aggressive Varianten bleiben sekundaer.**

**W5 · Sekundaerquelle widerspricht Primaerquelle bei der Core-Modus-Achse.**
`20260508 Termin 7/Phase5_UML_Detail/_rev5_extractions/extract_termin3_4.md` schreibt:
„Termin 4 ergaenzt **Core-Typ** und **Wiederholung** als zusaetzliche Mess-Achsen." — **Falsch.**
Beide stehen bereits in der T3-Pflichttabelle `[p053]`/`[p054]`. **Die Core-Modus-Achse ist
seit dem 09.04.2026 Pflicht, nicht erst seit T4.** Die 97.200-Konfigurationen-Rechnung derselben
Datei ist ebenfalls eine Ableitung eines spaeteren Agenten, kein T3-Zitat (T3-Primaerzahlen
ergeben 81.000).

**W6 · T8 etikettiert die einzigen reproduzierten Zahlen als „inhaltlich falsch".**
`Arbeitsplan_Termin8.md:6`: „ChatGPT-Vorab-Versuch: in `_archive_chatgpt/` archiviert (war
inhaltlich falsch)". Das Archiv enthaelt jedoch (a) die einzigen lokal reproduzierten Zahlen
des Termins (54 enumerierte Permutationen, 109 generierte Dateien, Smoke `rc=0/size=1/
val=answer`), (b) den Frueh-Befund „**Compile-time ISA summary im Minimalbuild — scalar-only —
muss fuer echte Messlaeufe geschaerft werden**", und (c) exakt die Priorisierung, die T9 zwei
Wochen spaeter offiziell beschliesst. **Das Etikett ist irrefuehrend und darf beim
Gap-Abgleich nicht als Ausschlussgrund gelten.**

**W7 · Achsenzahl-Kette ohne gemeinsamen Nenner.** T7-drawio 14 · T9 22 · T11 19+3 · Code 18 ·
`topics/` 28 · `permutation_axes.xml` 11. **Kein Dokument definiert, welche Ebene gemeint ist.**
Jede Zahlennennung in der Thesis muss die Ebene mitfuehren.

**W8 · Nicht im Ledger getrackt.** Gegenprobe ueber den Ledger (Nenner 6735 Zeilen,
Positivkontrollen `CLU`=270, `Adapter`=141, `Hybrid`=107): `Ordnungsmod` = **0** ·
`Common-Denominator` = **0** · `Ablation` = **0** · `Relocation` = **0** · `Prefix-Lookup` =
**0** · `art.profile.xml` = **0**. **Sechs Plan-Pflichten sind im Arbeits-Ledger nicht als
Punkt vorhanden** — sie koennen dort also auch nicht abgearbeitet werden.

**W9 · `docs/termine/INDEX.md` ist der mechanische Erzeuger der Luecke** (§0). Stand 15.05.,
Termine 9/10/11 fehlen (0 Treffer bei Nenner 174 Zeilen, Positivkontrolle „Termin 8" = 4).

---

## 6. Was daraus fuer die sechs verbleibenden Freitage folgt

**Annahme laut Auftrag:** Endtermin **15.09.2026**, woechentliche Lieferung freitags.
Verbleibende Freitage ab heute (Do, 06.08.): **07.08. · 14.08. · 21.08. · 28.08. · 04.09. ·
11.09.** = **6 Lieferungen**, danach 4 Restkalendertage bis zum 15.09.
*(Unsicherheit, bitte bestaetigen: das Gedaechtnis fuehrt zusaetzlich eine aeltere Frist-Historie
„Abgabe Fr 08.08., Trigger Do 07.08." — siehe §7, Frage O-1.)*

**Ordnungsprinzip.** Die Reihenfolge folgt T11 P0>P1>P2 und dem T9-Satz „**erste Messung vor
Vollausbau erzwingen**". Nicht mehr Achsen — erst der Beweis.

| Freitag | Plan-Pflicht | Diff-Position | Warum genau jetzt |
|---|---|---|---|
| **07.08.** | **Mess-Validitaet klaeren** + **Stempel** | D-17, D-08 | T11 M1-DoD („Commit/Compiler/Seed"). **Vor** jedem mehrtaegigen Lauf: die L1-Zahlen sind physikalisch unmoeglich; ein Voll-Lauf mit demselben Zaehler produziert 131.072 unbrauchbare Zeilen. Owner-KERN „eigenes Messverfahren verdaechtigen". |
| **14.08.** | **Hybrid-Lane** | D-02 (+D-29) | Der Term der Forschungsfrage. PMU-Typ aus `/sys/devices/cpu_core/type` + `cpu_atom/type`, zwei Counter-Saetze, `cpu_class` in Record und CSV, zweite CI-Lane auf einem Intel-Hybrid-Runner. **Wenn keine Hybrid-Maschine verfuegbar ist: dokumentiertes Gate nach T11 M2 statt Schweigen.** |
| **21.08.** | **Vertikaler Beweis-Schnitt: PRT-ART + SOTA messen** | D-01, D-07 | T9-Akzeptanzkriterium. Ein Lauf, der eine PRT-ART-Zeile und mindestens 6 SOTA-Zeilen in die CSV und von dort in Kapitel 7 bringt. Reihenfolge laut T9: „zuerst PRT-ART-E2E, dann SOTA-Wrapper". |
| **28.08.** | **`page_type` permutieren** + **Ablation `BASELINE_NO_ENGINE`** | D-05, D-04 | Groesster Hebel: entsperrt T4-H2 **und** Thesis-H1. Die Off-Stufe ist die einzige Bedingung, unter der FF0 kausal beantwortbar ist (T4 `[P242]`). |
| **04.09.** | **Billige Deklarationen + Datensatz-Konsum** | D-18, D-09, D-06, D-19 | `fairness=` in die produktiven Profile (ein Attribut) · `count="5"` oder dokumentierte Abweichung · `<datasets>` an den Loader binden (Akten liegen fertig) · p95 in den Export. Alle Bausteine dahinter sind gebaut. |
| **11.09.** | **Kapitel 7 + Anhang + EN-Sync + Limitierungsliste** | D-30, D-26, D-20, D-27 | T11 M4 („Ergebnisse nicht uebertreiben, aber erste Messreihe interpretieren"), M5 („EN darf nicht auseinanderlaufen"), M3 (Anhang B ohne TODO). Limitierungen aktualisieren — der Anhang ist heute 20 Tage stale (W2). |

### Was nicht mehr schaffbar ist und ausdruecklich als Grenze in die Arbeit muss

Das ist keine Kapitulation, sondern die Auflage aus T10 `[p21]`/`[p22]`: „Der aktuelle
Fortschritt wird **ehrlich** kommuniziert ... Die entdeckte Methodik-Luecke wird **nicht
versteckt**, sondern als wissenschaftlich korrekter Audit-Befund eingeordnet." Und T11
`Praes. slide7:p2`: „Diese Punkte **nicht verstecken** — aktiv als wissenschaftliche Sorgfalt
zeigen."

| Nicht mehr schaffbar | Plan-Fundstelle | Wie es in die Arbeit gehoert |
|---|---|---|
| **ZIH Barnard / Sapphire Rapids als zweite Pflichtplattform** (D-10) | T3 `[p008]`, T4 `[P76]`/`[P78]` | Als **Scope-Grenze mit Begruendung** (kein Zugang/keine Zeit fuer Slurm-Integration) im Methodikkapitel; der Plattformterm der Forschungsfrage ist dann auf die lokal verfuegbaren Klassen einzuschraenken — **explizit, nicht stillschweigend**. |
| **9 Pflichtplattformen aus T6** (VisionFive 2, Pi 5, M1, ODROID, GH200 …) | T6-AA `Z. 11-12` | Als **vorbereitete, nicht eingeloeste Matrix** ausweisen; T6 war Verifikationsstrategie, keine Abgabepflicht — **[SELBSTAUFLAGE]**, nicht Betreuer-Auflage. |
| **Original-Baselines als Wrapper** (D-15) | T3 `[p043]`, T6-SF `§5` | Die Umrahmung ueber FF1 („Profil-Konfigurationen") ist bereits im Manuskript — sie muss aber **die Abweichung vom Plan explizit nennen** und die T9-Rueckfrage (`[p64]`) als unbeantwortet kennzeichnen. |
| **Drei Ordnungsmodi** (D-12) | T4 P1-Pflicht | **T1-H4 ist damit nicht pruefbar** und muss als nicht bearbeitete Hypothese benannt werden. Alternativ: H4 aus dem Hypothesensatz der Arbeit streichen — Owner-Entscheid (§7, O-4). |
| **Prefix-Operationen** (D-03) | T1-H3, T3 `[p047]` | Wenn 21.08. nicht reicht: **FF3/H3 ausdruecklich auf Exact-Operationen einschraenken** und den Prefix-Anspruch als Ausblick fuehren. Das ist ein Eingriff in den Dominanzanspruch der Arbeit — Owner-Entscheid noetig. |
| **Intel Advisor / CLU nach Plan** (D-20) | T1 `[P0131-TAB]`, T4 `[P244]` | Das strukturelle CLU-Surrogat (`field_bytes/(cache_lines*line_bytes)`) ist verteidigbar, **muss aber als Surrogat benannt werden** und darf nicht als Advisor-CLU auftreten. |
| **Vollfaktor-Permutationslauf** | T4 `Praes. slide1:P29` „Vollfaktor-Laeufe bleiben Pflichtziel" | T8s Regel gilt: „**MessreihenMode::Defined fuer Manuskript-Plots, Full-Mode nur fuer ZIH-Cluster-Laeufe**" (`Arbeitsplan_Termin8.md:204`). Ohne ZIH entfaellt Full — als Grenze benennen. |

**Die drei Rede-Verbote aus T9 `[p67]`-`[p69]` gelten bis zur Abgabe unveraendert** und sind
beim Schreiben von Kapitel 7/8 woertlich zu befolgen.

---

## 7. Offene Fragen an den Owner

Je mit Empfehlung. Alle sechs sind entscheidungsreif — ich entscheide sie nicht.

**O-1 · Welche Frist gilt?** Der Auftrag nennt **15.09.2026** mit woechentlicher Lieferung; das
Projektgedaechtnis fuehrt zusaetzlich eine Historie „Abgabe Fr 08.08., Trigger Do 07.08."
*Empfehlung:* 15.09. bestaetigen oder korrigieren — §6 haengt vollstaendig daran. Ohne
Bestaetigung ist die Wochenplanung ungueltig.

**O-2 · PRT-ART: vertikalisieren oder umrahmen?** Ist-Stand: der Pruefling unterscheidet sich
von ART in **einer** von 18 Achsen (D-07); der reale PRT-ART-Code ist nicht im Messpfad.
*Empfehlung:* **umrahmen, nicht vertikalisieren.** Die Vertikalisierung ist in 6 Wochen neben
allem anderen nicht sicher zu schaffen, und T11 hat die Arbeit bereits als „**Framework-Arbeit**"
neu gefasst („PRT-ART ist der Pruefling, nicht der einzige Beitrag", `Praes. slide2:p7`). Die
Umrahmung muss dann aber **explizit** sagen, dass der Pruefling ein Kompositionspunkt im
Entwurfsraum ist und nicht die in T4 entworfene Vollimplementierung.

**O-3 · Hybrid-Lane: Maschine oder Gate?** Wenn keine Intel-Hybrid-Maschine mit PMC-Zugang
freigegeben werden kann, verlangt T11 M2 ausdruecklich „ein **klar dokumentiertes Gate**".
*Empfehlung:* eine Woche (14.08.) fuer den Versuch reservieren; wenn er scheitert, **am selben
Freitag das Gate schreiben** — mit Nennung der Maschine, des fehlenden Zugangs und der Folge
fuer den Plattformterm der Forschungsfrage. Schweigen ist laut M2 keine der erlaubten Optionen.

**O-4 · T1-H4 (Ordnungspolitik): bearbeiten oder streichen?** Die Achse existiert nicht (D-12),
sie ist T4-P1-Pflicht, und T4-H2 braucht sie als Bedingungsvariable.
*Empfehlung:* **als nicht bearbeitete Hypothese ausweisen**, nicht streichen — Streichen wuerde
den Hypothesensatz gegenueber T1 stillschweigend veraendern. T4-H2 ist dann auf die
verbleibenden drei Bedingungsvariablen einzuschraenken, davon sind nach D-05/D-02/D-06 heute
**null** erfuellt.

**O-5 · Wiederholungen 3 oder 5?** Plan sagt dreimal 5 (W1), Owner-Entscheid E3 sagt 3, real
gefahren wurde 1. *Empfehlung:* bei **3** bleiben (Zeitbudget), aber die Abweichung im
Methodikkapitel mit Verweis auf T3 `[p013]` benennen — und mindestens **3 tatsaechlich fahren**;
`repetition = 0` in allen Zeilen erfuellt auch den Owner-Entscheid nicht.

**O-6 · Darf `docs/termine/INDEX.md` nachgezogen werden?** Der Index endet bei Termin 8 und ist
damit der mechanische Erzeuger der heutigen Luecke (W9). Er ist als „Pflicht-Pre-Read"
deklariert. *Empfehlung:* **ja, additiv** — Termine 9/10/11 als Zeilen ergaenzen, Stand-Datum
hochziehen, **nichts loeschen** (Doku-Doktrin „nie loeschen, nur deprecaten"). Hier READ-ONLY
nicht ausgefuehrt.

**O-7 (nachrangig) · Soll `_archive_chatgpt/` umetikettiert werden?** Das Etikett „war
inhaltlich falsch" verdeckt die einzigen reproduzierten Zahlen des Termins 8 (W6).
*Empfehlung:* eine Zeile in `Arbeitsplan_Termin8.md` ergaenzen, die den Befund-Wert festhaelt —
oder, falls Termindokumente unantastbar sind, den Hinweis hier in §5-W6 als Fundstelle
genuegen lassen.

---

## Anhang: Was ich NICHT geprueft habe

Ehrlichkeit ueber den Nenner dieses Dokuments:
- **Invarianten I1-I4** (T2) sind hier **nicht** am Code verifiziert — sie stehen in §2.7 als
  Vertrag, nicht als Befund.
- **T7-Auflagen H1 (UML-Vollstaendigkeit), H3 (LaTeX-Toolchain), H5 (Production-Container)**
  sind nicht gegen den Ist-Stand geprueft.
- **F-EXTRA-8 / Habich-Log** (Bit-Identitaet nach Modul-Splitting) ist nicht geprueft.
- **`codegen.py` gegen H6** ist nicht neu verifiziert (letzter Stand: T7-Audit meldet Verstoss).
- **Kuehn-Gegenmassnahmen** (Achse 11, `NotInTopLevels`) sind nicht geprueft.
- Die **61 `.jpg` in Termin 7** wurden nur gezaehlt, nicht gelesen; die 5 im drawio REV7
  gefundenen Nach-Termin-7-Beschluesse (N-Phase 14 Achsen, AA.2, AA.3, O-Phase, R.12) haben
  **kein `.md`-Pendant im Terminordner** und verweisen auf Master-Dokumente ausserhalb.
- Die **Thesis-Kapitel 2-4, 6, 8** sind nicht gegen den Plan geprueft; §3 stuetzt sich fuer die
  Thesis auf Kapitel 1 und 5 sowie die Anhangstabellen.

Wer eine dieser Positionen braucht, muss sie selbst erheben — **nicht raten.**
