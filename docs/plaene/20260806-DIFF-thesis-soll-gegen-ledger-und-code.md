# Die Diplomarbeit als Anforderung: was sie zusagt und was davon fehlt

**Stand:** 2026-08-06 · **Endtermin:** Di 15.09.2026 · **Modus:** READ-ONLY-Analyse, kein Edit am Code, kein Edit an der Thesis
**Korpora:**
- SOLL: `/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/thesis/diplomarbeit` (nur **eingebundene** Dateien, s. §0.3)
- IST-Code: `.../Code`, `.../Code/external/comdare-cache-engine`, `.../Code/external/comdare-prt-art`, beide `.gitlab-ci.yml`
- IST-Tracking: `docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md` (6.735 Zeilen), `docs/sessions/20260806-REGISTER-todo-konsolidierung-14-tage.md` (474 Zeilen)
- IST-Daten: `Code/measure_out_d03/e4_xml/measurements.csv`, `measurement/20260726-164259-d03-strukt-r-erstbeleg/measurements.csv`

Alle Suchen mit `/usr/bin/grep` (ugrep liefert bei manchen Mustern still 0). Jede Null-Aussage trägt Nenner **und** positive Gegenprobe im selben Suchraum.

---

## 0. Die Richtung

### 0.1 Die Thesis ist die Spezifikation, nicht die Dokumentation

Was in der Arbeit steht, ist keine Beschreibung des Gebauten, sondern eine **Zusage an Leser und Betreuer**. Ein Satz im Präsens Indikativ (»der Apparat misst …«, »ist implementiert«) ist eine Tatsachenbehauptung. Hält der Code sie nicht, ist das keine Ungenauigkeit — es ist eine **Falschaussage in der Abgabe**.

Die Projekt-Doktrin sagt dasselbe: das LaTeX-Design ist Primärquelle der Implementierung, nicht deren Nachbereitung.

### 0.2 Warum es dieses Dokument gibt

Die Thesis wurde bisher **nicht systematisch als Anforderungsquelle gegen Ledger und Code geprüft**. Der Ledger ist historisch gewachsen aus Bau-Aufgaben; er kennt keine Rückwärtsableitung aus dem Manuskript. Folge: es gibt Zusagen, die im PDF stehen, die niemand baut, und die niemand mehr auf dem Zettel hat — sie fallen erst bei der Verteidigung auf. Genau diese Klasse listet §2.

Für jede Lücke gilt: **zwei Wege sind zulässig — bauen ODER die Aussage in der Arbeit korrigieren. Aber einer muss gegangen werden.** Nichts tun heißt: die Arbeit behauptet etwas Unwahres.

### 0.3 Was überhaupt zählt (Struktur-Vorbedingung)

`diplomarbeit.tex:280-285` bindet **genau sechs** Kapitel ein, sprachaufgelöst über `\thesislang`:

```
\include{kapitel/\thesislang/01_einleitung}
\include{kapitel/\thesislang/02_suchbaeume_grundlagen}
\include{kapitel/\thesislang/03_messsystem_prtart}
\include{kapitel/\thesislang/04_implementierung}
\include{kapitel/\thesislang/05_evaluation}
\include{kapitel/\thesislang/06_fazit}
```

dazu `diplomarbeit.tex:288-295` die Anhänge A–F und über `zihpub.cls:267/883` die **gesetzte** Aufgabenstellung (`aufgabenstellung/{de,en}.tex`). `config/language.tex:11` setzt `\providecommand{\thesislang}{de}`.

`diplomarbeit.tex:278-279` sagt es wörtlich:

> „Habich-Restruktur 2026-06-29: 8->6 Kapitel (SKELETT). Die alten 01_..08_-Dateien bleiben als Inhalts-Quelle auf der Platte (un-included)"

**Nicht eingebunden und damit KEINE Zusage:** `01_introduction`, `02_fundamentals`, `03_state_of_the_art`, `04_concept_architecture`, `05_implementation`, `06_evaluation_methodology`, `07_results_evaluation`, `08_conclusion` — je DE und EN. Gegenprobe am Build-Trace (`.fls` beider Sprachen): nur die sechs oben genannten erscheinen als `INPUT`. Alle acht tragen seit `bdd1e16` bzw. früher einen Selbst-Marker, z. B. `kapitel/de/01_introduction.tex:1-4`:

> „% NICHT eingebunden (Stand 06.08.2026): diese Datei ist in diplomarbeit.tex nicht referenziert.
> % ACHTUNG, veralteter Achsen-Stand: dieser Text fuehrt noch die Neunzehner-Zaehlung"

**Falle im Verzeichnisnamen:** `kapitel/en/01_einleitung.tex` ist der **englische** Text unter deutschem Dateinamen. Die Sprache wählt das *Verzeichnis*, nicht der Dateiname. Wer `kapitel/en/01_introduction.tex` liest, liest Alt-Material. Ein früherer Falschbefund entstand genau daran.

Alles Folgende zitiert ausschließlich eingebundenen Text.

---

## 1. DIE FALSCHAUSSAGEN-GEFAHR

Positionen, bei denen die Arbeit etwas behauptet und der Code es nicht hält. Sortiert nach Schwere. Je Position: Zitat mit Fundstelle · Ist-Beleg · beide zulässigen Wege.

---

### F-01 · Talos als zweites Betriebssystem-Regime — existiert nirgends

**SOLL** · `anhang/de/E_architecture_decisions.tex:140-149` (ADR-12, EN paritätisch):
> „**jede Messung** unter zwei Betriebssystem-Regimes: einem immutablen Betriebssystem (Talos) […] und einem root-Linux mit vollem Hardware-Zähler-Zugriff (`perf`/MSR)"

Gestützt und verschärft durch `kapitel/de/05_evaluation.tex:83-89` / `en:83-89` und `kapitel/de/01_einleitung.tex:223-226` / `en:217-220`:
> „die beiden Produktionsmaschinen werden dafür unter zwei Betriebssystemen (immutables Talos und root-Linux mit vollem Hardware-Zähler-Zugriff) vermessen"

**IST** · `/usr/bin/grep -rlwi "talos" Code --include=*.hpp --include=*.cpp --include=*.txt --include=*.cmake --include=*.xml --include=*.yml` ohne Thesis-Spiegel und Fixtures → **Exit 1, null Treffer**. Gegenprobe mit demselben Verfahren: `perf_event_open` trifft real (`libs/cache_engine/builder/linux_perf_pmc_source.hpp`, `builder/pmc_source_factory.hpp`, `profile_facade/planner/experiment_plan_director.hpp`).
Die OS-Achse kennt drei Ausprägungen: `libs/cache_engine/include/cache_engine/measurement/operating_system_axis.hpp:76,83,89` = `LinuxOperatingSystem`, `WindowsOperatingSystem`, `MacosOperatingSystem`. **Talos ist kein Baustein.**
Daten: `measurements.csv`, Spalte `platform` (Feld 160), über alle 16 Datenzeilen **ein einziger Wert** `linux-x86_64`.
Ledger: **ein** Treffer, `LEDGER:791`, und der ist Infrastruktur, nicht Messung — „Offen (Infra-Folge …): Win2022/Win11-VM-Runner (RDP), **Talos/k8s-Runner** (kubectl via node7 …)". REGISTER: **0 Treffer**.

**VERDIKT: FEHLT.** Allquantor-Behauptung im Perfekt („jede Messung"), null Datenpunkte, null Bau-/CI-Spur, und **kein einziger** der 20 Limitierungs-Punkte in `06_fazit.tex:141-179` und `anhang/de/tabellen/le_limitierung.tex` entlastet sie.

**Wege:**
- **(a) Bauen:** Talos-Lane als vierten Baustein der OS-Achse + Runner + Mess-Strang. Realistischer Aufwand: mehrere Tage Infra, und die Cluster-Infra ist für diesen Agenten read-only.
- **(b) Aussage korrigieren:** ADR-12 auf ein Regime zurücknehmen (»root-Linux mit vollem Zähler-Zugriff; das immutable Regime ist Ausblick«), `05_evaluation.tex:83-89` und `01_einleitung.tex:223-226` gleichlautend abschwächen, Limitierungs-Punkt ergänzen. Aufwand: unter einer Stunde.
- **Empfehlung: (b).** Ein zweites OS-Regime ohne Daten ist teurer als sein Nutzen; die Aussage ist heute nachweislich falsch.

---

### F-02 · `flat_hash_map` als namentlich zugesagte Baseline — nicht vorhanden

**SOLL** · `aufgabenstellung/de.tex:113-114` / `en.tex:104-105` — **gesetzt** über `zihpub.cls:883`, also bindender Abgabetext:
> „vergleicht die Konfigurationen gegen etablierte Baselines, darunter eine nicht-baumartige Hash-Tabelle (`flat_hash_map`) als Gegenprobe innerhalb derselben Gattung."

**IST** · `/usr/bin/grep -rl "flat_hash_map" Code` → 10 Treffer, **keiner** ist Projektcode: 3× Thesis-Spiegel unter `Code/external/20260931-overleaf-diplomarbeit/`, 1× `comdare-prt-art/build/_deps/googletest-src/docs/gmock_cook_book.md`, 6× vendorter Fremdtest `ext/allocator/A06-tcmalloc/tcmalloc/testing/*`.
Gegenprobe: `SwissTable` trifft in `libs/cache_engine/axes/lookup/` fünf eigene Dateien — die Suche funktioniert, es gibt nur eine **eigene Re-Implementierung** statt der zugesagten Baseline: `axis_03a_search_algo_swisstable.hpp:4` „@family S22 SwissTableSearchAlgo", und `:12` sagt selbst „**AP-7b:** Weg-B-Organ (SwissTableOrgan) fuer den echten Mess-Pfad noch offen".
Ledger `flat_hash_map`: **0**. REGISTER: **0**.

Ergänzend zur Textlage: in **keiner** der zwölf gebundenen DE-Dateien (6 Kapitel + 6 Anhänge) kommt `flat_hash_map` vor. Es lebt nur in der gesetzten Aufgabenstellung und in totem Kapitelmaterial (`kapitel/de/02_fundamentals.tex:266`, `kapitel/de/03_state_of_the_art.tex:35` — beide nicht eingebunden).

**VERDIKT: FEHLT** (im Code) bzw. **ABGEWICHEN** (eigene SwissTable statt der namentlich genannten Bibliothek).

**Wege:**
- **(a) Bauen:** `absl::flat_hash_map` vendoren und als Baseline-Baustein registrieren. Die Achse ist offen (S22 existiert bereits als Muster), Aufwand ~1 Tag.
- **(b) Aussage korrigieren:** Die Aufgabenstellung ist der Text mit dem geringsten Änderungsspielraum — sie wurde dem Betreuer vorgelegt. Ersatzweise: die **eingebundenen Kapitel** nehmen die Gegenprobe namentlich auf und weisen aus, dass sie über eine eigene SwissTable-Reimplementierung (S22) und nicht über `absl::flat_hash_map` erfolgt.
- **Empfehlung: (b) mit Textaufnahme**, denn (a) löst die Bindung nur, wenn die Baseline auch *gemessen* wird — und das hängt an der Voll-Messung (§4). Owner-Entscheid, s. §8/O-2.

---

### F-03 · `docs/quality_audit` und die H2-Definition — Pfad zeigt ins Leere, Verfahren ist ein anderes

**SOLL** · `kapitel/de/05_evaluation.tex:14-16` / `en:14-16`:
> „über **sieben Bewertungs-Achsen** (Stil, Tests, Dokumentation, Wartbarkeit, Pflege-Status, Lizenz, Build-System; **Skala 1--5**, `docs/quality_audit`)"

**IST** · `find … -type d -name quality_audit` über den gesamten Abgabe-Verbund → **kein Treffer**. Einziger Fundort auf der Platte: `/home/comdare/Projekte/Research/_ce-scratch-split-20260707/docs/quality_audit/HABICH_H2_CODE_QUALITY_2026_05_13.md` — ein **Scratch-Split vom 07.07.**, in keinem der drei Abgabe-Repos.
Das Dokument selbst existiert allerdings in der Abgabe unter anderem Pfad: `Code/external/comdare-cache-engine/docs/audits/HABICH_H2_CODE_QUALITY_2026_05_13.md`.
Implementiert ist ein **anderes Verfahren**: `libs/cache_engine/algorithm_profiles/sota/sota_h2_scores.xml:2-9` — „AUTO-GENERATED by `apps/h2_score_akte_tool` … gewichtete **cppcheck**-Befunddichte pro kLOC", Werte **unbeschränkt** (`score="1.900"` … `score="12.349"`), **eine** Dimension, keine 1–5-Skala, keine der sieben genannten Achsen. `grep -rn "Wartbarkeit\|maintainability"` über CE ohne `ext/` → **0**.
Ledger: `LEDGER:1034` bucht den Punkt ohne Pfadprüfung — „H2-Qualitäts-Score erstmals im Text definiert (code-verifiziert: quality_audit-Doku 7 Achsen Skala 1–5 + is_original)". **Kein TODO zur Pfadkorrektur.**

**VERDIKT: ABGEWICHEN.** Zwei getrennte Defekte: (i) der zitierte Pfad existiert nicht, (ii) das beschriebene Verfahren ist nicht das implementierte.

**Wege:**
- **(a) Bauen:** `docs/quality_audit/` in `probst-diplomarbeit-cache-engine` anlegen, das 7-Achsen-Audit dorthin ziehen, das `h2_score_akte_tool` auf die 7 Achsen erweitern. Aufwand: 0,5 Tage für (i), mehrere Tage für (ii).
- **(b) Aussage korrigieren:** Pfad auf `docs/audits/HABICH_H2_CODE_QUALITY_2026_05_13.md` richtigstellen und die Score-Definition auf das implementierte Verfahren umschreiben (»gewichtete statische Befunddichte pro kLOC, erhoben über `apps/h2_score_akte_tool`«), das 7-Achsen-Audit als *qualitative Ergänzung* führen.
- **Empfehlung: (b) für (ii), (a) für (i).** Der Pfad ist billig zu heilen; das Verfahren umzubauen lohnt vor der Abgabe nicht.

---

### F-04 · PMC-Limitierung ist in Gegenrichtung falsch

**SOLL** · `anhang/de/tabellen/le_limitierung.tex:20` (Limitierung Nr. 1 der Arbeit):
> „**Cache-Misses (Kernmetrik):** L1/L2/L3 + dTLB + Coherence + Energy = **0 / nicht erhoben** … **NullPmcSource, `available=false`**"

Gleichlautend `kapitel/de/06_fazit.tex:157-162` („ist default-abgeschaltet; in der bisherigen Smoke-Reihe stehen die Hardware-Spalten auf null"), `kapitel/de/03_messsystem_prtart.tex:1050-1053` („noch nicht erhoben"), `anhang/de/A_measurements.tex:11-14` („Cache-Misses L1--L3 derzeit 0/nicht erhoben").

**IST** · `Code/measure_out_d03/e4_xml/measurements.csv`, Datenzeile 2, Endfelder:
```
… ;4096;linux-x86_64;m3v2-smoke;-;0;756895968;0;0;2225379;0;0;1;10000;-;-
```
Spalten laut Kopf: 164 `pmc_cache_misses_l1` = **756 895 968**, 167 `pmc_dtlb_misses` = **2 225 379**, 170 `pmc_available` = **1**. Byte-identisch im Archiv `measurement/20260726-164259-d03-strukt-r-erstbeleg/measurements.csv`.
Der Erheber ist real: `libs/cache_engine/builder/linux_perf_pmc_source.hpp:211-216` öffnet exakt drei generische Zähler (`PERF_COUNT_HW_CACHE_L1D`, `_LL`, `_DTLB`, je `OP_READ/RESULT_MISS`), Fabrik `builder/pmc_source_factory.hpp:33`.

**VERDIKT: ABGEWICHEN.** Die Arbeit spricht sich ihre stärkste tatsächlich vorhandene Messgröße selbst ab. Korrekt wäre: **L1D und dTLB sind erhoben, `available=true`; L2, L3, Kohärenz und Energie sind strukturell 0, weil kein portabler generischer Zähler existiert** — genau das sagt der Code an `linux_perf_pmc_source.hpp:203-204` selbst („KEIN portabler generischer Counter → bleibt 0 (kein RAW-Rateversuch)").

**Wege:**
- **(a) Bauen:** entfällt — es ist bereits gebaut.
- **(b) Aussage korrigieren:** Limitierung 1 in `le_limitierung.tex:20`, `06_fazit.tex:157-162`, `03_messsystem_prtart.tex:1050-1053` und `A_measurements.tex:11-14` auf die Vier-Wege-Differenzierung umschreiben. Aufwand: unter einer Stunde, vier Fundstellen je Sprache.
- **Empfehlung: (b), mit Vorrang.** Das ist eine Aussage, die den eigenen Beitrag kleiner macht als er ist — sie kostet in der Verteidigung.

---

### F-05 · PRT-ART überschreibt sechs Slots — im Code ist es einer

**SOLL** · `kapitel/de/01_einleitung.tex:204-211` / `en:199-206`:
> „im Mess-Apparat überschreibt der Prüfling **sechs Slots** --- die Build-Achse Seitentyp sowie Pfadkompression (Redirect), pfadorientiertes Prefetch, OLC-Nebenläufigkeit, Telemetrie und den ChainRef-Value-Handle-Slot ---, während MultiLevel-Layout, Pool-Allokator und Serialisierung im Mess-Pfad derzeit über den Cache-Engine-Standard laufen"

Wortgleich in `kapitel/de/03_messsystem_prtart.tex:1340` und in der Bildunterschrift `:1375` / `en:1316`, `:1351`:
> „Der Prüfling überschreibt im Mess-Apparat sechs Slots […] und bezieht die übrigen **vierzehn** Organ-Achsen über den Compile-Time-Fallback"

**IST** · `libs/cache_engine/compositions/prt_art_reference.hpp:60-90`. `PrtArtComposition` unterscheidet sich von `ArtComposition` in **genau einer** Achse — der Kommentar `:59-60` sagt es selbst:
> „= ArtComposition mit path_compression = PrtArtPathCompressionOrgan (Redirect/Patricia statt None)."

Die drei namentlich als überschrieben zugesagten Slots sind literal **Cache-Engine-Standard**:
- `:71` `using prefetch = prefetch::axis_07_prefetch::NonePrefetch;` — kein pfadorientiertes Bundle-Prefetch
- `:75` `using value_handle = value_handle::axis_14_value_handle::InlineValueHandle;` — kein ChainRef
- `:72` `using concurrency = concurrency::axis_08_concurrency::OlcOptimisticConcurrency;` — CE-Baustein, nicht PRT-ART-OLC

Der Merge-Pfad bestätigt es: `compositions/prt_art_merge_reference.hpp:82-101` reicht **17 von 18** Achsen unverändert vom Host durch (`using prefetch = typename Host::prefetch;` …), nur `:85` ersetzt `path_compression`. Der Dateikopf `:6` sagt: „Stufe2_PrueflingReplace → PRT-ART ERSETZT **einen** Slot".

**VERDIKT: ABGEWICHEN — 1 statt 6.** Das ist die präziseste Zusage des Einleitungskapitels und zugleich die, die am weitesten vom Ist abweicht. Sie steht an **drei** Stellen je Sprache (Einleitung, Kap. 3 Fließtext, Kap. 3 Bildunterschrift) und ist damit schlecht zu relativieren.

**Wege:**
- **(a) Bauen:** PRT-ART-Prefetch-, ValueHandle- und OLC-Organ in die Mess-Komposition verdrahten. Das ist der Kern des Folgeschritts E6, den die Arbeit an `03_messsystem_prtart.tex:1344-1346` bereits für Pool-Allokator und MultiLevel-Layout benennt. Aufwand: mehrere Tage, berührt den Messpfad.
- **(b) Aussage korrigieren:** auf »überschreibt im Mess-Apparat den Pfadkompressions-Slot (Redirect); Prefetch, ValueHandle, OLC, Pool-Allokator, MultiLevel-Layout und Serialisierung laufen derzeit über den Cache-Engine-Standard, ihre Anbindung ist Folgeschritt E6« — die Arbeit hat für diese Formulierung bereits ein Muster.
- **Empfehlung: (a) für Prefetch und ValueHandle, (b) für den Rest.** Ohne PRT-ART-Prefetch und -ValueHandle im Messpfad kann Hypothese **H3** (`05_evaluation.tex:19-21`, „ValueHandle-Verteilung korreliert mit Page-Dichte") überhaupt nicht beantwortet werden — die Achse ist gepinnt. Siehe §4/M-05.

---

### F-06 · `resolve_baustein.hpp` als Compile-Time-Fallback der vierzehn Achsen — die Datei ist quarantäniert

**SOLL** · `kapitel/de/04_implementierung.tex:113-117` / `en:109-113`:
> „für die **vierzehn PRT-ART-Fallback-Achsen** zur Übersetzungszeit über `resolve_baustein.hpp` (Concept-geprüftes `if constexpr` über Tag-Spezialisierungen …) aufgelöst, sodass der Hot-Path weder `virtual`-Aufrufe noch Laufzeit-Switches enthält"

Gestützt `03_messsystem_prtart.tex:1336` / `en:1312`: „über einen Compile-Time-Fallback (`resolve_baustein.hpp`) auf die Cache-Engine-Standardbausteine zurückgreift".

**IST** · Die Datei existiert — als stillgelegter Test-Artefakt. `libs/cache_engine/include/cache_engine/abi/resolve_baustein.hpp:1-4`:
> „**§23-QUARANTAENE (2026-07-18): variant-basierter Cluster -> fuer statische/Organ-Achsen VERBOTEN** (Runtime-Overhead + Code-Bloat, §23). **NICHT in den Live-Codegen-Pfad verdrahten**; der Live-Weg sind monomorphe CRTP+Concept-Achsen."

und `:6-11`:
> „**TEST-ONLY** (Marker 2026-07-17 F6) … Konsumiert **AUSSCHLIESSLICH** von tests/unit/test_abi_interface.cpp … **KEIN Lib-/App-Konsument** (repo-weiter grep verifiziert …)"

Zusätzlich deckt sie laut `:22-23` **elf** Achsen ab, nicht vierzehn.
**Nenner + Gegenprobe:** `grep -rl resolve_baustein Code --include=*.hpp --include=*.cpp --include=*.txt` → 5 Treffer, davon **0 in `libs/` oder `apps/`** (2 clusterintern, 3 in `tests/`). Kontrollmuster `module_abi_v1.hpp` → **28** Lib-/App-Konsumenten.

**VERDIKT: ABGEWICHEN.** Der Mechanismus existiert, aber unter einem anderen Namen und mit einer anderen Technik: monomorphe CRTP-Kompositionen (`compositions/*.hpp`), nicht der `variant`-Cluster. Die Aussage »der Hot-Path enthält keine Laufzeit-Switches« bleibt **wahr** — sie wird nur mit dem falschen Beleg geführt.

**Wege:**
- **(a) Bauen:** entfällt (die Quarantäne ist eine bewusste Architekturentscheidung, §23).
- **(b) Aussage korrigieren:** Beleg-Datei austauschen. Statt `resolve_baustein.hpp` die reale Mechanik nennen: `compositions/prt_art_reference.hpp` + `anatomy/composition_concept.hpp`, und den `variant`-Cluster als historische Elf-Achsen-Vorstufe ausweisen — was `03_messsystem_prtart.tex:804` / `en:795` an anderer Stelle bereits korrekt tut („der *literale* `std::variant` lebt nur im 11-Achsen-`baustein_variants`-Fallback").
- **Empfehlung: (b).** Reiner Beleg-Fix, eine Stelle je Sprache in Kap. 4, eine in Kap. 3.

---

### F-07 · Zwei der neun Ersatztext-Begründungen im Anhang sind sachlich falsch

Die Arbeit führt eine ausdrückliche Ehrlichkeits-Doktrin, `anhang/de/A_measurements.tex:77-88` (Änderung 2026-08-06, „honest-100%"): jeder fehlende `\InputIfFileExists`-Eintrag trägt einen eigenen Ersatztext, der benennt *was* fehlen würde und *warum*. Verifiziert: alle 29 fehlenden Darstellungen je Sprache tragen individuellen Text — es gibt keinen stillen Ausfall. **Zwei der Begründungen sind jedoch unwahr.**

**F-07a · `working_set_n`** · `anhang/de/A_measurements.tex:127-131`:
> „Sie liegt nicht vor: **keine der bisher vorliegenden Messreihen führt eine `working_set_n`-Spalte**, und ohne diese Spalte wird bewusst kein Stützpunkt erfunden."

**IST:** Die Spalte existiert. `measurements.csv`, Kopffeld **159** = `working_set_n`, Wert `4096` in **allen 16** Datenzeilen. Das Schema führt sie ausdrücklich: `libs/cache_engine/builder/experiment_tree/cache_engine_builder_iterator.hpp:468` — `h += "series;sweep_axis;working_set_n;platform;build_version;pruefling_type;quality_flag"`. Der eigene Test benennt den wahren Grund: `Code/05_diagram_generator/tests/test_05_diagram_generator_cached_fixtures.cpp:1091` — „entartete x-Achse: trägt der Korpus nur EINEN working_set_n (**d03: durchgaengig 4096**)".
**Korrekt wäre:** »die Spalte liegt vor, trägt aber nur einen einzigen Stützpunkt (4096); eine Kurve über *n* braucht mindestens drei.«

**F-07b · `linear_scan` als Referenz** · `anhang/de/A_measurements.tex:200-204`:
> „in den bisher vorliegenden Messreihen ist die Referenz-Ausprägung `search_algo`/`linear_scan` **nicht mitgemessen**, und ohne gemessene Referenz gibt es **keinen Nenner** für den Quotienten."

**IST:** `anhang/de/tabellen/bias_matrix_table.tex:14` — die Zeile `linear\_scan` trägt **21 gemessene Mediane**:
```
linear\_scan & 11506 & 23486 & 14487 & 17282 & 20557 & 48913 & 12990 & 30947 & 63537 & 96624 & 88800 & 14029 & 25348 & 168720 & 11385 & 31086 & 13001 & 11652 & 21425 & 166863 & 21763
```
und `anhang/de/tabellen/lc_surface_ns_per_op.tex:22` führt `linear\_scan` als eine der vier y-Achsen-Kategorien. **Beide Tabellen stehen im selben Anhang, im selben Kompilat, wenige Seiten vor dem Ersatztext.**

**Reichweite:** Diese Begründung trägt **12 fehlende Darstellungen je Sprache** (6× `lc_surface_ratio_*` + 6× `lc_normbar_*`, letztere „teilen den Nenner der Verhältnis-Matrizen", `A:227-246`), also **24 Ersatztexte in DE+EN**.

**VERDIKT: ABGEWICHEN.** Das ist die einzige Stelle, an der die »honest-100%«-Doktrin gegen sich selbst arbeitet: eine Ehrlichkeits-Konstruktion, die eine unwahre Tatsachenbehauptung transportiert.

**Wege:**
- **(a) Bauen:** den Anhang-Generator über den vorhandenen Korpus laufen lassen — bei `linear_scan` liegt der Nenner vor, die 12 Verhältnis-/Normbar-Darstellungen sind **heute erzeugbar**. Aufwand: ein Generator-Lauf, sofern die WIDE-Quelle noch existiert (siehe F-08).
- **(b) Aussage korrigieren:** beide Ersatztexte auf den wahren Grund umschreiben.
- **Empfehlung: (a) prüfen, dann (b).** Erst feststellen, ob der Generator die 12 Darstellungen aus dem Bestand erzeugt; wenn ja, ist die Lücke keine. Wenn nein, ist (b) Pflicht.

---

### F-08 · Die gelieferten Mess-Artefakte sind aus keinem Repo-Bestand reproduzierbar

**SOLL** · `anhang/de/A_measurements.tex:36-40`:
> die Anhang-Tabellen „werden aus dem WIDE-Schema (**volle 19-Achsen-Tupel** + op_\<art\>_p50-Spalten + `two_phase_valid`) erzeugt"

und `:44-49`: „**ausschließlich** die als `two_phase_valid` markierten Läufe".

**IST** · Der gesamte Abgabe-Verbund enthält **genau einen** echten Mess-Lauf. Gegenprobe: `find . -name "measurements.csv"` → 3 Treffer, davon 1 leer (`Code/build/y/e4_xml/measurements.csv`, 0 Zeilen) und 2 **byte-identisch** (`diff -q` bestätigt): `measurement/20260726-164259-d03-strukt-r-erstbeleg/` = `Code/measure_out_d03/e4_xml/`, **17 Zeilen = 1 Kopf + 16 Datenzeilen**, Commit `057ee3e5`, mtime 2026-07-26 16:38. `Code/_runs/` existiert nicht. `measurements.json` existiert auf der Platte **nirgends**.

Die WIDE-CSV, aus der Bias-Matrix (4×21), die sechs Latenz-Surfaces (5× 84 + 1× 76 Punkte) und die vier Exchange-Tabellen stammen, ist **nicht auffindbar**: `grep -rl "coco_p04_neg0" --include="*.csv" /home/comdare/Projekte/Research` → **Exit 1**. Gegenprobe: derselbe String trifft 19 Nicht-CSV-Dateien, u. a. `libs/cache_engine/algorithm_profiles/load_profiles/coco_p04_neg0.xml` — die Suche funktioniert.
Zusätzlich ist das genannte Schema **überholt**: das WIDE-Schema ist der 19-Achsen-Stand (`tests/unit/thesis_tiere/tier150_measurements.csv`, 5760 Zeilen, `binary_id` enthält `telemetry=`/`isa=`), der aktuelle `binary_id` hat **18 Segmente ohne telemetry/isa** (`libs/cache_engine/builder/experiment_tree/axis_path_serialization.hpp:40-43`).

**VERDIKT: UNBELEGBAR.** Die Ergebnisse sind committet, die Rohdaten fehlen, und mit dem heutigen Apparat wäre das genannte Schema nicht mehr erzeugbar.

**Wege:**
- **(a) Bauen:** die WIDE-Quelle wiederherstellen (Backup-Bestände prüfen, `Messdaten-Backup/`) oder den Lauf im **heutigen** Schema wiederholen und die Tabellen neu erzeugen.
- **(b) Aussage korrigieren:** `A:36-40` auf den tatsächlichen Erzeugungsstand umschreiben und die Herkunft der Tabellen (Lauf-Datum, Commit, Schema-Version) als Provenienz-Akte im Anhang ausweisen.
- **Empfehlung: (a) mit Frist, sonst (b).** Für eine Diplomarbeit ist die Nichtreproduzierbarkeit der eigenen Ergebnistabellen der teuerste Einzelposten in der Verteidigung. Doktrin »Messdaten nie löschen« gilt — die Rohdaten müssen im Backup liegen; sie zu finden hat Vorrang vor jeder Textänderung.

---

### F-09 · Anhang-Limitierung führt 19 Achsen, die Kapitel führen 18

**SOLL** · `anhang/de/tabellen/le_limitierung.tex:21`:
> „**15 gepinnte Achsen** = 0 Austauschbarkeits-Belege. Nur **4 Achsen** variieren. Gepinnt (je 1 Wert): cache_traversal, mapping, path_compression, allocator, concurrency, serialization, **telemetry**, value_handle, **isa**, index_organization, io_dispatch, migration_policy, filter, queuing_q1, queuing_q2"

15 + 4 = **19**.

**IST** · Kanonisch sind **18** Organ-Achsen: `libs/cache_engine/builder/experiment_tree/axis_path_serialization.hpp:40-43`, `std::array<std::string_view, 18> kCompositionAxisNames`, und `anatomy/composition_concept.hpp:66-70` `composition_organ_count::value = 18`. `telemetry` und `isa` sind **keine** Organ-Achsen (Mess- bzw. System-Realm); `persistence_target` — laut `anhang/de/D_building_block_matrix.tex:771` „mit der Achsen-Neuordnung als **achtzehnter** Organ-Slot hinzugekommen" — **fehlt in der Liste**.
Die eingebundenen Kapitel sagen einhellig 18: `kapitel/de/06_fazit.tex:35-38` „*Achtzehn* Organ-Haupt-Achsen in fester Slot-Reihenfolge T0--T17", `03_messsystem_prtart.tex:143`, `04_implementierung.tex:132,141-142`, `anhang/de/D:4`, `anhang/de/E:58`.

**VERDIKT: ABGEWICHEN.** Der Anhang widerspricht den Kapiteln **im selben PDF**. Bei einer Arbeit, deren Kernbeitrag die Achsen-Bibliothek ist, ist das der sichtbarste innere Widerspruch.

**Weg: (b), zwingend.** `le_limitierung.tex:21` auf den 18-Achsen-Stand ziehen: `telemetry` und `isa` streichen, `persistence_target` und `node_type`/`memory_layout` korrekt zuordnen, Zählung auf 18 = gepinnt + variiert korrigieren. Aufwand: unter einer Stunde, DE+EN.

---

### F-10 · »320 registrierte Tests« — stale und zweideutig

**SOLL** · `kapitel/de/04_implementierung.tex:434-436` / `en:427-429`:
> „Die volle Test-Suite --- im Stand dieser Arbeit **320 registrierte Tests** --- läuft ungekürzt *zweimal*, und abgenommen wird ausschließlich »0 failed«, ohne Ausnahmeliste."

**IST** · Quellstand: `/usr/bin/grep -rn "add_test(" --include=CMakeLists.txt` über CE ohne `ext/` und `_deps` → **280**; davon `tests/unit/CMakeLists.txt` allein **278**.
Ledger-Stand: `LEDGER:6642` — „…8c4c84b0, **Doppellauf 2x408/408** … W5/W3 = LANDEBEREIT @ff6560b9 …, **Gate 408**". Historie: `ctest 209/209` → `405/405` → **408**.
Konfigurierte Bau-Bäume weichen untereinander ab (318 / 331 / 407 / 582 je nach Konfiguration) — die Zahl ist **konfigurationsabhängig**, nicht invariant.

**Zusätzliche Falle:** Die **320** bezeichnet im Projekt etwas anderes — den materialisierbaren golden-Katalog. Sechs Zeilen später steht sie in derselben Thesis-Datei korrekt in dieser Bedeutung: `04_implementierung.tex:442` („320 materialisierbarer Katalog als Byte-Wache"), belegt durch `profile_facade/source_catalog.hpp:172-176` `static_assert(… golden_320_catalog == 320u)`. **Zwei verschiedene 320er auf einer Seite.**

**VERDIKT: ABGEWICHEN** (Stichtags-Drift) **+ mehrdeutig** (Zahlenkollision).

**Wege:**
- **(b) Aussage korrigieren:** entweder auf den Abgabestand nachziehen (dann: Zahl **beim letzten Bau vor Abgabe** setzen und als Stichtagswert kennzeichnen) oder die Zahl streichen und nur die Invariante behaupten (»die volle Suite läuft ungekürzt zweimal; abgenommen wird ausschließlich 0 failed«).
- **Empfehlung: Zahl streichen.** Eine Stichtagszahl, die bei jedem gelandeten Paket driftet, ist in einer Abgabe ein Selbstläufer-Defekt. Die Invariante trägt die Aussage allein.

---

### F-11 · `T11` statt `T10` für den ChainRef-Slot — innerer Widerspruch, beide Sprachen

**SOLL** · `kapitel/de/04_implementierung.tex:88-90` / `en:85-87`:
> „Erstere stellen den im Apparat überschriebenen ChainRef-Slot **(T11)**"

**IST** · Dieselbe Datei, Galerie `:162`: „**T10 Wert-Handle** … Chain-Ref"; `:163`: „**T11 Index-Org.**". Bildunterschrift `:105` sagt ebenfalls T10.
Code: `axis_path_serialization.hpp:40-43` — Index **10** = `value_handle`, Index **11** = `index_organization`.

**VERDIKT: ABGEWICHEN** (Tippfehler, aber in beiden Sprachen und gegen die eigene Galerie zwei Seiten weiter).

**Weg: (b).** Eine Zeichenänderung je Sprache.

---

### F-12 · Weitere Kardinalitäts-Abweichungen (kompakt)

| # | SOLL | IST | Verdikt |
|---|---|---|---|
| F-12a | `anhang/de/D:286` u. `:1371` „**25** konkrete Allocator-Wrapper" / „25 speicherverwaltungs-Strategien (A01--A21, A22a--A22c sowie A23)"; beide D-Tabellen führen 25 Zeilen | `libs/cache_engine/axes/alloc/axis_06_allocator_registry.hpp:78-98` — `AllVendors` listet **26**; Abschlusskommentar `:99` wörtlich „Allocator-Achse 6 KOMPLETT (**26 Vendor**: Batch 1-8 + R5.B Pool + P33 VAMPIR_NFP)". Der 26. (`VampirNfpAllocator`, `:98`) trägt keine A-Nummer | **ABGEWICHEN** (off-by-one A-Band ↔ Registry) |
| F-12b | `anhang/de/D:17` „**21** konkrete Suchalgorithmen … (S01--S21: 17 Basis-Bausteine … plus 4 opt-in per-K-k-ary-Wrapper)"; Tabelle `D:43-59` führt **17** Zeilen | `axes/lookup/axis_03a_search_algo_registry.hpp:54-88` führt **22**, Endeintrag `:87` `SwissTableSearchAlgo // S22`. **Drei Zahlen für dieselbe Achse: Code 22, Fließtext 21, Tabelle 17** | **ABGEWICHEN** |
| F-12c | `03_messsystem_prtart.tex:397-398` / `en:391`: die SwissTable „(als eigener Baustein **vorgesehen**)" | Sie ist **registriert**, Default-OFF: `axis_03a_search_algo_registry.hpp:30`, `:87`, `:133-134`; Klasse `axis_03a_search_algo_swisstable.hpp:76-78` | **ABGEWICHEN** (untertrieben) |
| F-12d | `03_messsystem_prtart.tex:353,366-379` / `en:348,360-373`: „**vierzehn** distinkte Lastprofile (**LP01--LP14**)" mit Op-Mix-Tabelle | `algorithm_profiles/load_profiles/*.xml`, literaler Output von `grep -rho 'lp_id="[^"]*"' \| sort \| uniq -c`: **10 distinkte** — LP01, LP04, LP05, LP06 (6×), LP08, LP09, LP10, LP11, LP12, LP14. **LP02, LP03, LP07, LP13 existieren nirgends** | **TEILWEISE** (10/14) |
| F-12e | `05_evaluation.tex:187-193`: der `messung_driver` schreibt unter `Code/_runs/<date>/<spec_id>/` die Dateien `measurements.csv`, `measurements.json` mit `op_count`, `total_cycles`, `bytes_allocated`, `bytes_in_use_peak`, Fragmentierung | Diese Spalten stehen in **Pipeline-Stufe 03**: `Code/03_binary_to_csv/binary_to_csv.cpp:56-59`. Die reale Treiber-CSV führt `n_ops;total_ns;ns_per_op;…;peak;bytes_alloc;bytes_in_use`, **keine** Fragmentierungs-Spalte; `_runs/` existiert nicht; `measurements.json` nirgends | **ABGEWICHEN** (Schema existiert, an anderer Stelle) |
| F-12f | `03_messsystem_prtart.tex:1153-1155` (E22): Fingerprint = „einem **SHA512 über die drei Realm-Zeilen**" | `include/cache_engine/abi/anatomy_fingerprint.hpp:463-471` — `anatomy_fingerprint_glieder(...)` liefert **acht** Glieder (`kAnatomyFingerprintFormat, organ, system, measurement, kSubAxisValuesetSegment, toolchain, bvset, overlay`); Hash `:585-594` SHA-512 | **ABGEWICHEN** (Präzision) |
| F-12g | `04_implementierung.tex:494-495`: Last-Rahmenwerk „genau ein Eintrag, **YCSB in Version 1.0.0**" | `measurement/measurement_framework_registry.hpp:45` → `"v1.0.0c"` — dreistellig **plus HW-Flag `c`** gemäß eigener Versions-Grammatik (`anhang D:1131-1138`) | **ABGEWICHEN** (Zitat ohne Flag) |
| F-12h | `04_implementierung.tex:586-588`: Kurvenanpassung „(`curve_fit.hpp`) … als **Skeleton**"; `03_messsystem:1481-1483` „erst der **Keim**" | Datei unter anderem Pfad und deutlich größer: `libs/cache_engine/builder/curve_fit/curve_fit.hpp`, **537 Zeilen**, Modell `:53`, Kleinste Quadrate `:61`, Residuen `:80-98`, natürlicher kubischer Spline `:116-180`; zusätzlich Fritsch-Carlson in `heuristik/axis_spline.hpp` | **ABGEWICHEN** (untertrieben) |
| F-12i | `04_implementierung.tex:455-457`: „die Grenze E3→E2 ist … **bereits** golden-getestet … die übrigen Harnesse sind als Abnahme-Definition … festgelegt" | Alle vier Harnesse existieren als Tests: `test_e4_contract_xml_to_axislevels.cpp`, `test_e3_contract_binary_id_bijektion.cpp`, `test_e3_contract_conformance_gate_wirksam.cpp`, `test_e2_contract_abi_vertrag.cpp`, `test_e1_contract_rc_konsum.cpp`. Ledger: „**Die SCHICHT-SEQUENZ E4→E3→E2→M→E1 ist KOMPLETT**" (`#221` via `3ddbb0d6`) | **ABGEWICHEN** (untertrieben) |
| F-12j | `anhang/de/D:1269`: „die **drei Modi existieren noch nicht als Typen** … Ein handgeschriebener Eintrag wäre ein Phantom (offener Punkt W2-B)" — gegen `anhang/de/E:109-117` ADR-9 („drei Auslieferungsvarianten") **im selben Kompilat** | `measurement/run_methodology_registry.hpp:37-45` — `enum class RunMethodology { Debug, Measure, Release, Compare }`, `kRunMethodologyCount = 4`, Registry `:74-77`. Der Header-Kopf `:3-4` benennt die Thesis-Stelle direkt: „Sie **TYPISIERT den offenen TODO**" | **ABGEWICHEN** (D ist überholt; ADR-9 hat recht) |

**Sammel-Empfehlung F-12:** durchgehend **(b)**, mit einer Ausnahme — F-12d (Lastprofile) ist ein echter Bau-Fehlbestand und gehört in §2/§4.

---

## 2. DIE UNSICHTBAREN POSTEN — als fertige Ledger-Einträge

Die folgenden Positionen sind in der Thesis zugesagt und im **Ledger und im TODO-REGISTER nicht vorhanden**. Sie sind niemandem zugeteilt. Formuliert als übernahmefertige Ledger-Zeilen im Format des bestehenden Ledgers.

> **Übernahme-Hinweis:** Blockkopie in `docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md` unter neuem Abschnitt »§63 THESIS-SOLL-ABGLEICH (06.08.)«. IDs `§63-T-*` sind frei — Gegenprobe: `/usr/bin/grep -c "§63-T-" LEDGER` → 0.

```markdown
## §63 THESIS-SOLL-ABGLEICH (Quelle: docs/plaene/20260806-DIFF-thesis-soll-gegen-ledger-und-code.md)

- **[§63-T-01]** ADR-12 „jede Messung unter zwei OS-Regimes (Talos + root-Linux)"
  (anhang/{de,en}/E_architecture_decisions.tex:140-149, gestuetzt 05_evaluation.tex:83-89,
  01_einleitung.tex:223-226) hat NULL Code-/CI-/Datenspur: `grep -rlwi talos Code ci .gitlab-ci.yml`
  = 0 (Gegenprobe perf_event_open trifft); OS-Achse kennt nur Linux/Windows/Macos
  (operating_system_axis.hpp:76,83,89); measurements.csv platform = 1 Wert linux-x86_64.
  ENTSCHEIDUNG NOETIG: Talos-Lane bauen ODER ADR-12 + 2 Kapitelstellen DE+EN zuruecknehmen.
  (OFFEN, KRITISCH, Owner-Entscheid O-1)

- **[§63-T-02]** flat_hash_map als namentlich gesetzte Baseline (aufgabenstellung/de.tex:113-114,
  en.tex:104-105, gesetzt via zihpub.cls:883) existiert nicht: `grep -rl flat_hash_map Code`
  = 0 Projekttreffer (nur ext/A06-tcmalloc, googletest-docs, Thesis-Spiegel). Vorhanden ist die
  eigene S22-SwissTable (axis_03a_search_algo_swisstable.hpp), deren Mess-Pfad-Organ laut :12
  offen ist (AP-7b). ENTSCHEIDUNG NOETIG: absl vendoren + registrieren ODER Gegenprobe in den
  gebundenen Kapiteln namentlich auf S22 umstellen. (OFFEN, KRITISCH, Owner-Entscheid O-2)

- **[§63-T-03]** H2-Definition im PDF beschreibt ein nicht implementiertes Verfahren:
  05_evaluation.tex:14-16 nennt 7 Bewertungs-Achsen, Skala 1-5, Pfad `docs/quality_audit`.
  Verzeichnis existiert in KEINEM der 3 Abgabe-Repos (find -type d = 0; einziger Fundort
  _ce-scratch-split-20260707). Implementiert ist gewichtete cppcheck-Befunddichte pro kLOC,
  unbeschraenkte Skala (algorithm_profiles/sota/sota_h2_scores.xml:2-9, apps/h2_score_akte_tool).
  Doku existiert unter docs/audits/HABICH_H2_CODE_QUALITY_2026_05_13.md.
  TODO: (i) Pfad im Text richtigstellen, (ii) Score-Definition auf das Ist umschreiben.
  (OFFEN, KRITISCH)

- **[§63-T-04]** PMC-Limitierung ist in GEGENRICHTUNG falsch: le_limitierung.tex:20,
  06_fazit.tex:157-162, 03_messsystem_prtart.tex:1050-1053, A_measurements.tex:11-14 behaupten
  „NullPmcSource, available=false, alles 0". Ist: measurements.csv Feld 164 pmc_cache_misses_l1 =
  756895968, Feld 167 pmc_dtlb_misses = 2225379, Feld 170 pmc_available = 1; Erheber real in
  linux_perf_pmc_source.hpp:211-216 (3 generische Zaehler). Nur L2/L3/Kohaerenz/Energie sind
  strukturell 0 (:203-204 „KEIN portabler generischer Counter").
  TODO: 4 Fundstellen je Sprache auf die Differenzierung umschreiben. (OFFEN, HOCH, billig)

- **[§63-T-05]** PRT-ART „ueberschreibt sechs Slots" (01_einleitung.tex:204-211,
  03_messsystem_prtart.tex:1340 + caption :1375, DE+EN) gegen Code: PrtArtComposition
  (compositions/prt_art_reference.hpp:60-90) weicht von ArtComposition in GENAU EINER Achse ab
  (path_compression). Namentlich zugesagt-aber-Standard: prefetch=NonePrefetch (:71),
  value_handle=InlineValueHandle (:75), concurrency=CE-OlcOptimisticConcurrency (:72).
  Merge-Pfad bestaetigt: prt_art_merge_reference.hpp:82-101 reicht 17/18 durch, Kopf :6
  „ERSETZT einen Slot". TODO: E6-Anbindung Prefetch+ValueHandle bauen (Voraussetzung fuer H3),
  Rest im Text zuruecknehmen. (OFFEN, HOCH)

- **[§63-T-06]** resolve_baustein.hpp als Beleg des 14-Achsen-Compile-Time-Fallbacks
  (04_implementierung.tex:113-117, 03_messsystem_prtart.tex:1336) ist §23-QUARANTAENE + TEST-ONLY
  (resolve_baustein.hpp:1-11) und deckt 11 statt 14 Achsen (:22-23). Nenner: 5 Treffer, 0 in
  libs/apps (Gegenprobe module_abi_v1.hpp = 28 Konsumenten). Aussage „kein Laufzeit-Switch im
  Hot-Path" bleibt WAHR, nur der Beleg ist falsch.
  TODO: Beleg auf compositions/*.hpp + anatomy/composition_concept.hpp umstellen. (OFFEN, MITTEL)

- **[§63-T-07]** Zwei Anhang-A-Ersatztexte sind sachlich falsch und brechen die honest-100%-Doktrin
  (A_measurements.tex:77-88): (a) :127-131 „keine Messreihe fuehrt eine working_set_n-Spalte" —
  Spalte existiert (measurements.csv Feld 159 = 4096 in allen 16 Zeilen; Schema
  cache_engine_builder_iterator.hpp:468); wahrer Grund = entartete x-Achse (eigener Test
  test_05_diagram_generator_cached_fixtures.cpp:1091). (b) :200-204 „Referenz linear_scan nicht
  mitgemessen, kein Nenner" — bias_matrix_table.tex:14 fuehrt linear_scan mit 21 Medianen,
  lc_surface_ns_per_op.tex:22 als y-Kategorie. (b) traegt 12 Darstellungen je Sprache.
  TODO: erst Generator-Lauf pruefen (die 12 sind evtl. heute erzeugbar), sonst Ersatztexte
  richtigstellen. (OFFEN, KRITISCH)

- **[§63-T-08]** Die gelieferten Anhang-Ergebnistabellen sind aus keinem Repo-Bestand
  reproduzierbar: nur EIN echter Mess-Lauf existiert (16 Datenzeilen, 057ee3e5, 2026-07-26);
  Code/_runs/ existiert nicht; measurements.json nirgends; die WIDE-Quelle der Bias-Matrix und
  der 6 Surfaces ist unauffindbar (`grep -rl coco_p04_neg0 --include=*.csv` = 0, Gegenprobe
  19 Nicht-CSV-Treffer). Zudem ist das in A:36-40 genannte WIDE-Schema der 19-Achsen-Stand,
  waehrend binary_id heute 18 Segmente ohne telemetry/isa fuehrt
  (axis_path_serialization.hpp:40-43). TODO: Rohdaten aus Messdaten-Backup/ zurueckholen
  (Doktrin: Messdaten nie loeschen) ODER Lauf im heutigen Schema wiederholen.
  (OFFEN, KRITISCH)

- **[§63-T-09]** le_limitierung.tex:21 fuehrt 15 gepinnte + 4 variierte = 19 Achsen, nennt
  telemetry und isa als Organ-Achsen und laesst persistence_target aus. Kanonisch sind 18
  (axis_path_serialization.hpp:40-43, composition_concept.hpp:66-70); alle gebundenen Kapitel
  sagen 18/T0-T17 (06_fazit.tex:35-38, 03_messsystem:143, 04_implementierung:132,141-142,
  anhang D:4, E:58). Innerer Widerspruch im selben PDF.
  TODO: Limitierungs-Tabelle auf 18 ziehen, DE+EN. (OFFEN, HOCH, billig)

- **[§63-T-10]** „320 registrierte Tests" (04_implementierung.tex:434-436) ist stale UND
  kollidiert mit dem golden-320-Katalog 6 Zeilen weiter (:442, source_catalog.hpp:172-176).
  Ist: 280 add_test in der Quelle, Ledger-Gate 408 (LEDGER:6642), Bau-Baeume 318/331/407/582.
  TODO: Zahl streichen, nur die Invariante („ungekuerzt zweimal, 0 failed") behaupten.
  (OFFEN, MITTEL)

- **[§63-T-11]** 04_implementierung.tex:88-90 nennt den ChainRef-Slot „(T11)"; Galerie :162 und
  Bildunterschrift :105 derselben Datei sagen T10, Code sagt Index 10 = value_handle,
  11 = index_organization (axis_path_serialization.hpp:40-43). DE+EN.
  TODO: eine Zeichenaenderung je Sprache. (OFFEN, NIEDRIG)

- **[§63-T-12]** LP01-LP14 (03_messsystem_prtart.tex:353,366-379) — nur 10 distinkte lp_id
  materialisiert: LP01,04,05,06,08,09,10,11,12,14. LP02, LP03, LP07, LP13 existieren nirgends
  (literaler Output `grep -rho 'lp_id="[^"]*"' | sort | uniq -c`).
  TODO: 4 Profile bauen ODER Tabelle auf 10 kuerzen. (OFFEN, MITTEL)

- **[§63-T-13]** Kardinalitaets-Drift ohne Posten: Allocator 25 (anhang D:286,:1371) vs. 26
  (axis_06_allocator_registry.hpp:78-99, VampirNfpAllocator ohne A-Nummer); Suchalgorithmen
  Code 22 (axis_03a_search_algo_registry.hpp:87 S22) vs. Fliesstext 21 (D:17) vs. Tabelle 17
  (D:43-59); SwissTable „vorgesehen" (03_messsystem:397-398) vs. registriert Default-OFF;
  Fingerprint „SHA512 ueber die drei Realm-Zeilen" (03_messsystem:1153-1155) vs. 8 Glieder
  (anatomy_fingerprint.hpp:463-471); YCSB „v1.0.0" (04_implementierung:494-495) vs. „v1.0.0c"
  (measurement_framework_registry.hpp:45); curve_fit „Skeleton" vs. 537 Zeilen unter
  builder/curve_fit/; Mess-Record-Spalten (05_evaluation:187-193) liegen in 03_binary_to_csv,
  nicht im Treiber-Output; run_methodology existiert als Typ (run_methodology_registry.hpp:37-45)
  entgegen anhang D:1269. TODO: Sammel-Textpass. (OFFEN, MITTEL)

- **[§63-T-14]** Die vierte Evaluations-Dimension (heuristischer Gegenbeweis,
  05_evaluation.tex:136-179) mit Entscheidungsregel :172-177 und Unsicherheitsband :158-160 hat
  im Ledger KEINEN eigenen Posten: `grep Unsicherheitsband|Bau-Variante|Beobachter-Overhead`
  = je 0 (Gegenprobe: Wallclock trifft 28x). Naechstliegend LEDGER:829 (Sammelstrang Task #2).
  03_messsystem:1514-1517 erklaert die Bau-Varianten-Matrix ehrlich fuer nicht existent — die
  DARAUS ABGELEITETE Entscheidungsregel in Kap. 5 steht aber in KEINER Limitierungs-Liste.
  TODO: Posten anlegen oder Dimension in 06_fazit.tex:141-179 als Limitierung aufnehmen.
  (OFFEN, HOCH)

- **[§63-T-15]** Drei Wallclock-Ebenen (03_messsystem_prtart.tex:1309-1312, Praesens-Indikativ)
  haben im Ledger 0 Treffer fuer „Wallclock-Ebene(n)" (Gegenprobe: „Wallclock" 28x). Existierend
  ist die Mess-Tooling-Registry mit 3 WERKZEUGEN (measurement_tooling_registry.hpp:38,47:
  wallclock/macro/micro) — nicht 3 Erhebungs-EBENEN. Die Achsen-Ebene existiert als
  seg_ns-Zeitnahme (anatomy/abi_adapter.hpp:645-680), ist aber ungefuellt (A:148-149 sagt es
  selbst). TODO: Formulierung entschaerfen oder Ebenen belegen. (OFFEN, HOCH)

- **[§63-T-16]** 17 Vertragsoperationen + Notify-Hooks als Folgeschritt (06_fazit.tex:101) —
  Ledger: „Vertragsoperation" 0, „siebzehn" 0. Ist: 5 Operationen
  (anatomy/idriveable_tier.hpp:46-58: tier_insert/lookup/erase/clear/size), Gate auf 5 Kern-Ops
  (pruef_dock/conformance_gate.hpp:10). Kopplung: 06_fazit.tex:91-93 macht die
  Plattform-Verifikation vom „std::map-Vertrag je Modul" abhaengig — MEHRDEUTIG, ob „Vertrag"
  die 5er-Teilmenge oder die 17 meint. TODO: Owner-Klaerung + Posten. (OFFEN, HOCH, O-4)

- **[§63-T-17]** Workload-Framework-Zusage der gesetzten Aufgabenstellung (de.tex:81-83,
  en.tex:74-76: „aller im Stand der Technik gefundenen Workload-Frameworks ueber alle
  verfuegbaren Workloads") — Ledger 0 Treffer fuer „Workload-Framework"/„Lastrahmenwerk"
  (Gegenprobe: YCSB trifft vielfach). Ist: genau EIN Eintrag, YCSB
  (04_implementierung.tex:494-495 gibt es selbst zu; load_framework baustein_count=1, anhang
  D:1247). LADDIS: 0 Repo-Treffer; CloudSuite/shbench/threadtest/Larson nur in
  libs/common/measurement/dataset_loader/README.md. TODO: als Grenze in die Arbeit aufnehmen.
  (OFFEN, HOCH)

- **[§63-T-18]** TA2 „Original Compiler Binary linking" (aufgabenstellung/de.tex:66-69) —
  Ledger 0 Treffer fuer „Original Compiler"/„Binary linking". Ledger widerspricht der Zusage
  fuer die Kern-Vier: LEDGER:612 „ALLE vier (ART/HOT/START/Wormhole) messen ueber CE-seitige
  Pool-Stores — Paper-Original-Code liegt NUR im disabled Wrapper-Body
  (COMDARE_A03A_IS_ORIGINAL_CODEGEN) und NICHT im Messpfad". Vendoring erfuellt (ext/traversal:
  8/8 Rang-1), Registrierung 5/8 (registry :58-64; :91-93 „P03 Masstree DEFERRED", „P04
  CoCo-trie deferred"). Teil-getrackt via REGISTER:425 (V-05-Rest #162, nur Zaehlbeleg).
  TODO: Re-Impl-Vermerk in die Arbeit, Original-Linking als Grenze. (OFFEN, HOCH)

- **[§63-T-19]** Die bias-freie Vollmatrix — in DREI gebundenen Kapiteln zugesagt
  (01_einleitung.tex:220-222, 02_suchbaeume_grundlagen.tex:409-411,
  03_messsystem_prtart.tex:539-543, 06_fazit.tex:67-69) — ist im REGISTER auf einen Doku-Vermerk
  abgestuft: REGISTER:415 „V-19 STRITTIG-Vermerke D5/D6/D7 … reine Doku-Vermerke, kein Bau:
  … #18 Goldener Coverage-Test". Ledger: nur LEDGER:383 (Task #18, „je Achse >=1 Config").
  Das ist der methodische Kern der Arbeit. TODO: Hochstufen oder Reichweite in der Arbeit
  begrenzen. (OFFEN, KRITISCH, O-5)

- **[§63-T-20]** Multi-Prueflings-Faehigkeit im Praesens zugesagt
  (03_messsystem_prtart.tex:1196-1198: „vergleicht … in einer einzigen Pipeline"), Code sagt
  future: permutation_engine.hpp:23 „Full-Join Multi-Pruefling (Stufe 3, future)", :236
  „vorbereitete API". Ledger: „Multi-Pruefling" 0 Treffer (Gegenprobe: Stufe3_FullJoin
  belegt, LEDGER:1540). TODO: Formulierung auf „vorbereitet" ziehen. (OFFEN, MITTEL)

- **[§63-T-21]** STALE-KORREKTUR: LEDGER:2926 „[§50-M-4] 19->17-Achsen-Nachzug … (kSegmentCount
  20->17 …) + Thesis-Text ‚neunzehn Achsen'/T-Nummern DE+EN (OFFEN, hoch)" zeigt auf die
  FALSCHE Zielzahl. Abgabestand ist 18 (06_fazit.tex:35-37, 04_implementierung.tex:173);
  derselbe Ledger stellt auf :6001 fest „die KOMPILIERTEN Kapitel sagen durchgaengig ‚achtzehn
  Organ-Achsen T0--T17' … Kein Abgabe-Defekt."; REGISTER V-03 fuehrt den Punkt als ERLEDIGT.
  Code: diagram_generator.hpp:264 kSegmentCount = kV3AxisCount + 1 = 19 (18 Organ + framework).
  Ausfuehrung wuerde eine REGRESSION erzeugen. TODO: Posten schliessen/umschreiben.
  (STALE, sofort)

- **[§63-T-22]** STALE-KORREKTUR: LEDGER:6211 „axis_inventory.tex … ist aber in KEINER .tex des
  Thesis-Repos eingebunden" — widerlegt: anhang/{de,en}/D_building_block_matrix.tex:1442
  `\InputIfFileExists{anhang/de/tabellen/axis_inventory.tex}`, Commit df54a2c (06.08. 19:34).
  TODO: Vermerk nachziehen. (STALE, sofort)

- **[§63-T-23]** best_binary_selector ist ERFUELLT (builder/best_binary_selector/, 1107 Zeilen,
  .cpp:313-394 Versand via copy_file -> shipped_dll + Manifest, CLI _main.cpp:21-27), ABER mit
  offener Datenkorrektheit: LEDGER:3027 „[§50-K-5] best_binary_selector ABI-Spiegel stale —
  kAbiMajor=5/„.A5." vs Host-ABI 6, schreibt falsche Provenienz". Solange das offen ist, traegt
  die Thesis-Zusage 01_einleitung.tex:227-233 ein falsches Provenienz-Etikett mit.
  TODO: §50-K-5 vor Abgabe schliessen. (OFFEN, MITTEL, bereits im Ledger — hier nur die
  Thesis-Kopplung vermerkt)
```

---

## 3. Die Zahlen

Jede prüfbare Zahl der eingebundenen Kapitel und Anhänge gegen ihren Beleg. Spalte »Art«: **gemessen** (aus Messdaten), **gerechnet/gebaut** (aus Code, `static_assert` oder Abzählung), **behauptet** (ohne auffindbaren Beleg).

### 3.1 Zahlen, die halten

| Zahl | Zusage | SOLL | IST-Beleg | Art |
|---|---|---|---|---|
| **18** | Organ-Achsen T0–T17 | `06_fazit.tex:35-38`, `03_messsystem:143`, `04_implementierung:132,141-142`, `anhang D:4` | `axis_path_serialization.hpp:40-43` (`std::array<…,18>`), `composition_concept.hpp:21-59,66-70` (18 Aliase erzwungen) | gebaut |
| **3** | System-Haupt-Achsen | `03_messsystem:973-975`, `04_implementierung:477-479` | `abi/system_axis_order.hpp:42-46` `kSystemAxisOrder{"target_isa","operating_system","external_utils"}` | gebaut |
| **3** | Abgangs-Wachen | `04_implementierung:481-485` | `system_axis_order.hpp:99-110`, drei `static_assert(!is_known_system_axis(…))` | gebaut |
| **2¹⁷ = 131072** | Binary-Identitäten je System-Permutation | `04_implementierung:437,440`, `05_evaluation:107`, `06_fazit:40`, `anhang E:27-39` | `profile_facade/source_catalog.hpp:139,172-176` `static_assert(catalog_axis_product<FullSourceCatalog>() == 131072u)` | gerechnet |
| **0x56F1B721C72DC10E** | CRC-64/ECMA-182-Anker | `04_implementierung:439` | `source_catalog.hpp:186,190` `kNewGolden131072Crc64`; literaler Werkzeug-Output | gerechnet |
| **320** | materialisierbarer golden-Katalog | `04_implementierung:442`, `06_fazit:150,183` | `source_catalog.hpp:172-176` `static_assert(… golden_320_catalog == 320u)`; Fixture `tests/unit/thesis_tiere/golden_fullpilot_320_binary_ids.txt` = 320 Nicht-Kommentarzeilen | gebaut |
| **16 = 9 + 7** | Mess-Kategorien / Regime-Teilung | `04_implementierung:509-514`, `03_messsystem:993-1002` | `measurement/measurement_category.hpp:32` `kMeasurementCategoryCount = 16`; `measurement/system_axis.hpp:101-134` `regime_mapping_is_complete()` + `static_assert`; `measurement_axis_registry.xml:8-24`: `regime_ordinal="0"` 9×, `="1"` 7× | gebaut |
| **3** | Collectors | `anhang D:1182` | `measurement_axis_registry.xml:25` `baustein_count="3"` | gebaut |
| **3** | Mess-Tooling-Einträge (wallclock/macro/micro) | `04_implementierung:496-497` | `measurement/measurement_tooling_registry.hpp:38,47` | gebaut |
| **4** | Mess-Registries | `04_implementierung:493-497` | `run_methodology_registry.hpp`, `measurement_framework_registry.hpp`, `writeback_method_registry.hpp`, `measurement_tooling_registry.hpp` | gebaut |
| **10 / 7** | Ereignis-Semantiken / beworbene PMC-Kanäle | `04_implementierung:529-531,538` | `measurement/i_measurement_source.hpp:24-34` (`Cycles=0 … EnergyUj=9`), `:148` | gebaut |
| **3** | generische perf-Zähler (L1D/LL/dTLB) | `05_evaluation:92-93` | `builder/linux_perf_pmc_source.hpp:211-216`, exakt drei `open()`; `:203-204` „kein RAW-Rateversuch" | gebaut |
| **23** | SIMD-Merkmale | `anhang D:964` | `measurement/simd_feature_flag.hpp:97,155` `std::array<…,23>` + `static_assert`; XML `system_axis_registry.xml:68` `count="23"` | gebaut |
| **< 200** | Zeilen DDR5-SPD-Parser | `04_implementierung:557-558` | `measurement/spd_ddr5_parser.hpp` = **141** Zeilen | gebaut |
| **7** | Ausgänge des HW-Verdikts | `04_implementierung:575-577` | `measurement/ram_identity_verdict.hpp:64-71`, genau sieben Enum-Werte | gebaut |
| **7** | Allokator-Pools (4+1+2) | `04_implementierung:26-28` | `comdare-prt-art/prt_art/include/prt_art/allocator/pool_set.hpp:15` `kPoolCount = 7` | gebaut |
| **30 (+3)** | SOTA-Profile / Profil-Dateien | `04_implementierung:22`, `anhang B:100-104`, `06_fazit:43-45` | `algorithm_profiles/sota/*.profile.xml` = 33, davon `olc`/`rcu`/`hazard_pointers` → 30 | gebaut |
| **10 / 12** | A- / P-Adapter über `ext/` | `anhang B:105-107` | `ext/allocator/` = A01,03,04,05,06,07,08,10,11,20; `ext/traversal/` = P01,02,03,04,05,06,07,10,20,25,29,30 | gebaut |
| **14** | Re-Implementierungen P11–P27 | `anhang B:136,175-177` | `comdare-prt-art/prt_art/legacy_reimpl/` = 14 Verzeichnisse | gebaut |
| **4096** | Batch-Größe je Meilenstein | `05_evaluation:132` | `profile_facade/planner/experiment_plan_director.hpp:641` `kGnBatchSlice = 4096` | gebaut |
| **6** | reale Datensätze mit Akte | `05_evaluation:34-35,51-66` | `Code/test_data_xml/{url,pizzachili_dna,protein,xml,tpcds-id,trec-terms}.test_data.xml`; z. B. `trec-terms…:24-28` `<checksum>0xccee239019e815a1</checksum><line_count>855665</line_count>`; verankert `tests/unit/test_25_kanon_dataset_akten.cpp:39-41` | gebaut |
| **43** | Smoke-Permutationen (27 + 16) | `05_evaluation:183-184`, `06_fazit:173-177` | `anhang/de/tabellen/cartesian_smoke43_table.tex` = exakt 43 Zeilen | gemessen |
| **4 × 21** | Bias-Matrix | `anhang A:45-49` | `bias_matrix_table.tex` = 4 Verfahren × 21 Lastprofile | gemessen |
| **5× 84 + 76** | Latenz-Surface-Punkte | `anhang A:59-64` | 6 Surface-Tabellen; `scan` 76 = 84 − 4 Algorithmen × 2 No-Op-Profile, deckungsgleich mit `le_limitierung.tex` Zeile 7 | gemessen |
| **8 / 11** | nummerierte Abbildungen / Tabellen im Anhang | Gegenprobe `.lof`/`.lot` DE+EN | A.1–A.8 und A.1–A.8 + F.1–F.3; Anhänge B/C/D/E erzeugen null nummerierte Floats (Longtables ohne `\caption`) | gebaut |

### 3.2 Zahlen, die nicht halten

| Zahl | SOLL | IST | Art | → |
|---|---|---|---|---|
| **6** überschriebene Slots | `01_einleitung:204-211`, `03_messsystem:1340,1375` | 1 (`prt_art_reference.hpp:60-90`) | behauptet | F-05 |
| **14** Fallback-Achsen via `resolve_baustein` | `04_implementierung:113-117` | 11, quarantäniert, test-only | behauptet | F-06 |
| **320** Tests | `04_implementierung:434-436` | 280 Quelle / 408 Ledger-Gate / 318–582 je Bau | behauptet | F-10 |
| **25** Allocator-Wrapper | `anhang D:286,1371` | 26 (`axis_06_allocator_registry.hpp:78-99`) | gebaut, Text falsch | F-12a |
| **21** Suchalgorithmen | `anhang D:17` (Tabelle: 17) | 22 (`axis_03a_search_algo_registry.hpp:87`) | gebaut, Text falsch | F-12b |
| **14** Lastprofile LP01–LP14 | `03_messsystem:353,366-379` | 10 distinkte `lp_id` | behauptet | F-12d |
| **3** Realm-Zeilen im SHA512 | `03_messsystem:1153-1155` | 8 Glieder (`anatomy_fingerprint.hpp:463-471`) | gebaut, Text ungenau | F-12f |
| **19** (15 + 4) Achsen | `le_limitierung.tex:21` | 18 | Alt-Stand | F-09 |
| **T11** ChainRef | `04_implementierung:88-90` | T10 | Tippfehler | F-11 |
| **4800 MT/s** RAM-Nennrate | `03_messsystem:1127-1128`, `04_implementierung:581` | im Text selbst als „wird ersetzt" markiert (`:580-583`) | behauptet + selbstrelativiert | — |

### 3.3 Zahlen ohne Datengrundlage — die Voll-Messung steht aus

| Zahl | SOLL | Datenlage heute |
|---|---|---|
| **2¹⁷ × 4 = 524.288** Binaries | `05_evaluation:105-112` (131072 Permutationen × 4 Bau-Varianten), `:132` = **128 Batches** | 8 distinkte `binary_id` × 2 Workloads = **16 Zeilen**. Erreichungsgrad **0,0015 %** der binary_ids. Ehrlich eingeräumt `06_fazit:147-149` |
| **3** Pflicht-Messreihen A/B/C | `05_evaluation:208-216`, `03_messsystem:1289-1299` | Konfiguration **erfüllt** (`Code/experiment_config/messreihen.xml:20-72`: `A_defined`, `A_full`, `B_CacheEngine_Perms`, `C_Merge_Alt_Neu`), Spalte `series` = `-` in **allen 16** Zeilen, ebenso `pruefling_type`, `fairness_mode` |
| **30** SOTA in A_full | `03_messsystem:1291-1293` | keine `series`-Daten; Profile existieren |
| **3** Wallclock-Ebenen | `03_messsystem:1309-1312` | `seg_*_ns`-Spalten im Schema (`cache_engine_builder_iterator.hpp:439-444`), aber ungefüllt; `A:148-149` sagt es selbst |
| **~100–1000** Tupel je Reihe | `03_messsystem:1328-1330` | 16 Zeilen gesamt |
| **jede tausendste** Permutation (Full-Sampled) | `03_messsystem:1330` | kein Full-Sampled-Lauf |
| **6** Bewertungs-Achsen-Score H2 je Verfahren | `05_evaluation:14-18` | Spalte `h2_code_quality_score` = `-` in **allen 16** Zeilen; von 33 `<code_quality>`-Einträgen tragen **22** `score="n/a"` → ≤11 numerische Scores |
| **p50/p95/p99** über HDR | `aufgabenstellung/de.tex:120`, `05_evaluation:121-122` | Histogramm existiert (`axes/telemetry_axis/axis_11_telemetry_latency_histogram.hpp:14-28`), Wiederholungsläufe fehlen |
| **2** Bau-Varianten-Differenz / Unsicherheitsband | `05_evaluation:152-160` | Bau-Varianten-Matrix laut `03_messsystem:1514-1517` „existiert nicht im heutigen Code" |
| **2** Maschinen × **2** OS | `01_einleitung:223-226`, `05_evaluation:78-89` | `platform` = ein Wert; Talos = 0 (F-01); Mess-Lanes einlanig AMD (`.gitlab-ci.yml:719,806` `tags: [prod, baremetal, amd]`) |

---

## 4. Was an der Voll-Messung hängt

**Grundsatz: was nicht gemessen wird, kann die Arbeit nicht behaupten.** Diese Liste bestimmt den Messumfang mit — und umgekehrt: wo eine Messung nicht mehr stattfindet, muss die zugehörige Aussage in §6 wandern.

### 4.1 Aussagen, die **nur** durch Messdaten belegbar sind

| # | SOLL | Was der Lauf liefern muss | Ohne Lauf |
|---|---|---|---|
| **M-01** | **FF0/RQ0** — „Wie stark verbessern […]" aktiv-messgetriebene gegen passiv-statische Varianten auf Hybrid-CPUs und Sapphire Rapids · `01_einleitung.tex:91-94` / `en:90-93` | Läufe auf mindestens zwei Mikroarchitekturen, je mit/ohne Telemetrie-Steuerung, mit Wall-Clock **und** PMC | keine Quantifizierung möglich; `06_fazit:22-24` sagt das bereits („lässt sich abschließend erst nach den End-to-End-Läufen je Plattform beziffern") |
| **M-02** | **FF3/RQ3** — Sieg-Urteil des Prüflings gegen 8 Rang-1 + Rang-2/3, belegt über „höhere Cache-Line-Auslastung, weniger LLC- und dTLB-Misses, geringere Branch-Kosten, kleinere heiße Suchpfade" bei Exact-/Prefix-Lookup und Prefix-Enumeration · `01_einleitung.tex:134-143` | Reihe A über ≥8 Rang-1-Profile; **LLC**, **dTLB** und **Branch-Misses** je Konfiguration. LLC und Branch sind heute strukturell 0 bzw. nicht verdrahtet (`05_evaluation:94-95`) | kein Sieg-Urteil; die vier genannten Belege sind zu 2/4 gar nicht erhebbar |
| **M-03** | **H1** — Page-Typ-Kosten unterscheiden sich systematisch nach Workload · `05_evaluation:10-12` | Variation über `node_type` **und** mindestens YCSB-A/C/E | Bestand: `sweep_axis` kennt genau **zwei** Werte (`search_algo`, `node_type`) über **zwei** Workloads → **TEILWEISE**, YCSB-E fehlt |
| **M-04** | **H2** — Qualitäts-Score „korreliert **messbar**" mit Durchsatz · `05_evaluation:17-18` | (i) Score je Verfahren — heute ≤11 von 33 numerisch, Spalte im CSV `-`; (ii) **Durchsatz** — Spalte existiert **gar nicht**, `05_evaluation:192-193` sagt „wird als Schema-Erweiterung des Records ergänzt"; (iii) genug Datenpunkte für eine Korrelation | **UNBELEGBAR.** Die einzige *statistische* Hypothese der Arbeit; keine ihrer drei Voraussetzungen liegt vor |
| **M-05** | **H3** — ValueHandle-Verteilung korreliert mit Page-Dichte · `05_evaluation:19-21` | Variation über `value_handle` — die Achse ist laut `le_limitierung.tex:21` **gepinnt**, und PRT-ART belegt sie im Messpfad mit `InlineValueHandle` (F-05) | **UNBELEGBAR** ohne E6-Anbindung des ChainRef-Organs. **Kopplung: M-05 hängt an F-05.** |
| **M-06** | Heuristischer **Gegenbeweis** als vierte Evaluations-Dimension, mit expliziter Entscheidungsregel · `05_evaluation:136-179`, insb. `:172-177` | Hybrid-Tier kompiliert sich selbst zur Tier-Binary; **drei** Bau-Varianten für die Beobachter-Overhead-Differenz; daraus Unsicherheitsband; beobachterfreier Neubau; zwei Vergleichsmengen | Bau-Varianten-Matrix existiert nicht (`03_messsystem:1514-1517`); Hybrid-Modus = `libs/cache_engine/hybrid/` enthält **nur** `README.md`. Und: **in keiner Limitierungs-Liste** → §2/§63-T-14 |
| **M-07** | **Achsen-Sensitivitätsanalyse** — „wird der Beitrag jeder Entwurfsentscheidung **erstmals** unter sonst gleichen Bedingungen separierbar und messbar zurechenbar" · `05_evaluation:230-238` | Reihe B als echter Achsen-Sweep. Ist: `messreihen.xml:48-56` sagt selbst „**Im aktuellen Skelett identisch zu A_full**" — kein Sweep | stärkste wissenschaftliche Behauptung beider Kapitel; kollidiert zusätzlich mit `06_fazit:176-177` („einzelne Effekte sind Apparat- statt Organ-Artefakte, ‚Beschattung'") |
| **M-08** | **Bias-freie Vollmatrix** — alle Lastprofile gegen alle Lebewesen · `01_einleitung:220-222`, `02_suchbaeume:409-411`, `03_messsystem:539-543`, `06_fazit:67-69` | 30 Profile × ≥14 Lastprofile × 3 Granularitäten × 3 Reihen | die Bias-Matrix im Anhang (4 × 21) ist ein Teilbeleg; ein Teil-Lauf entwertet die Bias-Freiheits-Behauptung, die der methodische Kern ist |
| **M-09** | **Plattform-kalibrierte Schwellwerte** — „werden mit den realen Läufen festgelegt" · `06_fazit:93-94`; Verifikations-Kriterium `01_einleitung:113-114` | reale Läufe je Plattform | ohne Läufe gilt **keine** Plattform als verifiziert |
| **M-10** | **Empfehlung von Standard-Konfigurationen je Workload-Klasse** aus der Rangbildung über drei Granularitäten · `05_evaluation:241-242` | Rangbildung über alle drei Granularitäten | `06_fazit:206-208` entlastet bereits teilweise („zunächst manuell abgeleitet") |
| **M-11** | Literatur-Widerspruch **1 vs. bis 16** Cache-Lines wird **nachgemessen**, nicht übernommen · `01_einleitung:119-122`, `06_fazit:77-80` | achsen-isolierte Knotengrößen-Variation | nicht im heutigen Sweep-Umfang |
| **M-12** | Kanonischer Mess-Record verspricht L2/L3/Kohärenz/Energie als Spalten · `05_evaluation:189-193` | strukturell nicht erhebbar (kein portabler generischer Zähler, `linux_perf_pmc_source.hpp:203-204`) | die Ehrlichkeits-Doktrin (`05_evaluation:96-97`) rettet es *textlich*, verlangt aber, dass der CSV-Writer diese Spalten als »nicht implementiert« und **nicht als 0** ausgibt — heute schreibt er literal `0` (`cache_engine_builder_iterator.hpp:744-777`), die Ehrlichkeit trägt allein `pmc_available` |

### 4.2 Der Messumfang, der sich daraus ergibt

Wenn die Arbeit M-01 bis M-11 behaupten soll, muss der Lauf mindestens tragen:

1. **Reihe A** über ≥8 Rang-1-Profile, mit `series`-Spalte gefüllt (heute `-`) — trägt M-02, M-08.
2. **Reihe B als echter Achsen-Sweep**, nicht als A_full-Klon (`messreihen.xml:48-56` ändern) — trägt M-07, und ohne sie ist die stärkste Aussage der Arbeit unbelegt.
3. **≥3 Stützpunkte `working_set_n`** statt des einen 4096 — trägt die drei `ld_sweep_*`-Darstellungen und heilt F-07a.
4. **`value_handle` entpinnt** und PRT-ART-ChainRef im Messpfad — trägt M-05/H3. Ohne diesen Schritt ist H3 zu streichen.
5. **Durchsatz-Spalte im Record** — trägt M-04/H2. Ohne sie ist H2 zu streichen.
6. **≥2 Wiederholungsläufe je Konfiguration** mit HDR-Perzentilen — trägt `05_evaluation:121-122` und `aufgabenstellung/de.tex:129-132`.
7. **YCSB-E im Workload-Satz** — trägt H1 vollständig (heute nur A/C).

Alles darüber hinaus (2¹⁷ × 4, Full-Sampled, zweites OS, zweite Maschinen-Lane) ist bis zum 15.09. nicht erreichbar und gehört nach §6/§7.

---

## 5. Abweichungen DE gegen EN

**Jede Sprachfassung ist für sich eine Abgabe.** Geprüft wurden alle sechs eingebundenen Kapitel und alle sechs Anhänge in beiden Sprachen.

### 5.1 Befund: es gibt praktisch keine inhaltliche Divergenz

| Prüfbereich | Ergebnis |
|---|---|
| `01_einleitung` | Zahlen-Paritätsprüfung mit Gegenprobe: `achtzehn/eighteen` 1:1, `acht/eight` 3:3, `vier/four` 3:3, `sechs/six` 1:1, `zehn/ten` 1:1, `Dreißig/Thirty` 1:1, `drei*/three*` 11:11 nach Auflösung der Komposita (`drei` 9 + `dreigeteilter` 1 + `dreischichtige` 1 ↔ `three` 9 + `three-part` 1 + `three-layer` 1). **Keine numerische Divergenz.** Drei zunächst gemeldete Divergenzen waren Artefakte des Suchmusters (`ß`, deutsche Komposita) und sind mit Nenner widerlegt |
| `03_messsystem_prtart` | Alle Zahl-Tokens (`2^{17}`, `131072`, `4800`, `110~`, `33~`, `23~`, `25`, `sechzehn/sixteen`, `neun/nine`, `sieben/seven`, `100--1000`) identisch, in derselben Reihenfolge. Einzige Abweichung terminologisch-kosmetisch: DE „Gegenprobe" (`de:395,457`) ↔ EN „counter-check" im Fließtext, aber „control" im Galerie-Kasten (`en:450`: `{\tiny Hash (control)}`) |
| `04_implementierung` | Numerische Token-Profile deckungsgleich (`30~SOTA`, `320`×2, `131072`, `2^{17}`, `82 Bit`, `50 Bit`, `21`, `25`×3, `14`×2, `16`×6, `10`×5 in beiden). Ausgeschriebene Zahlwörter: achtzehn/eighteen 8, sieben/seven 8, vierzehn/fourteen 3, sechzehn/sixteen 2, elf/eleven 1, zweihundert/hundred 1 |
| `05_evaluation` + `06_fazit` | Strukturell deckungsgleich: `05` je 2 Sections / 6 Items / 5 Labels / 25 Refs; `06` je 3 Sections / 6 Paragraphs / 7 Items / 4 Labels / 39 Refs. **0 undefinierte Referenzen** in `diplomarbeit-de.log` und `-en.log` — alle 64 `\ref` beider Kapitel lösen auf |
| Anhänge A–F | Section-Zahlen identisch (A 10/10, B 3/3, D 31/31, F 3/3), Glossar **47/47** Einträge (Schlüssel deckungsgleich, nur alphabetisch umsortiert), ADRs **12/12**, `.lof`/`.lot` identisch. Zahlen-Diff über alle sechs Anhänge ergab **ausschließlich Lokalisierung** (Dezimalkomma/-punkt, `16.896`↔`16,896` CUDA-Kerne, Datumsformat) |
| Fehlende Anhang-Darstellungen | Die 29 fehlenden `\InputIfFileExists`-Ziele fehlen **symmetrisch** in beiden Sprachen (29 MISS / 0 OK je Sprache) |

### 5.2 Die einzige systematische Abweichung — gewollt

DE führt die Forschungsfragen als **FF0–FF4**, EN als **RQ0–RQ4**. Das ist Lokalisierung, kein Befund.

### 5.3 Was **kein** DE/EN-Befund ist, obwohl es so aussieht

- `de/06_evaluation_methodology.tex:23` „PRT-ART **4+2**-Pool" ↔ `en/06_…:23` „PRT-ART 4+2 pool" — beide gegen das lebende „**4+1+2**". Das ist ein **Alt/Neu-Split**, kein Sprach-Split, und beide Dateien sind nicht eingebunden. Kontrollierte Gegenprobe: `4+2` steht **ausschließlich** in nicht eingebundenen Dateien (`01_introduction`, `04_concept_architecture`, `05_implementation`, `06_evaluation_methodology`); alle eingebundenen sagen `4+1+2`.
- `04_concept_architecture.tex:281` „neunzehn Hauptachsen (T0--T18)" gegen `06_fazit.tex:35` „Achtzehn […] T0--T17" — `04_concept_architecture` ist nicht eingebunden (`diplomarbeit.tex:283` bindet `04_implementierung` ein).
- `08_conclusion.tex:43-44` behauptete noch „mit **allen** `std::map`-Operationen und Notify-Hooks"; die lebende Fassung `06_fazit.tex:100-101` hat das korrekt auf die Teilmenge zurückgenommen. **Ein Reaktivieren der toten Datei würde den Falschbefund zurückholen.**

### 5.4 Latente Sprachfalle: doppelte Labels

`kapitel/de/04_implementierung.tex:1` und `kapitel/de/05_implementation.tex:5` tragen **beide** `\label{ch:impl}`; `04_implementierung.tex:12` und `05_implementation.tex:12` beide `\label{sec:repos}` (EN identisch). Solange `05_implementation` nicht eingebunden ist, harmlos — eine Reaktivierung ohne Umbenennung erzeugt sofort „multiply defined labels". **Vermerk für §63-T-13.**

**Fazit §5: Die beiden Sprachfassungen sagen dasselbe zu. Alle Befunde dieses Dokuments gelten für beide Abgaben gleichermaßen — und jede Textkorrektur ist doppelt auszuführen.**

---

## 6. Entlastungen

Was die Arbeit **ausdrücklich als Grenze benennt** und deshalb nicht gebaut werden muss. Diese Liste spart Arbeit — und sie ist Schutz: wo eine Grenze steht, ist eine Lücke kein Defekt.

### 6.1 Explizit als nicht implementiert deklariert

| # | Grenze | Fundstelle (DE / EN) | Zitat |
|---|---|---|---|
| E-01 | GPU außerhalb des Umfangs; Schreibparallelität und Optimierer-Integration optional | `aufgabenstellung/de.tex:134-141` / `en.tex:123-130` | „beschränkt sich dabei aber auf leseparallele Verfahren mit serialisiertem Schreiben (multi-read, single-write). Die GPU liegt vorerst außerhalb des Umfangs" |
| E-02 | PRT-ART ist **kein vollständiger Algorithmus** | `aufgabenstellung/de.tex:49-53` / `en.tex:45-49`, gleichlautend `01_einleitung.tex:44-46` | „nur einige neue Aspekte […] und keinen vollständigen Algorithmus" · „eine abstrakte, unvollständige Ansammlung neuartiger Suchalgorithmus-Bestandteile" |
| E-03 | Automatisierte Heuristik-Bestimmung = **Ausblick** | `02_suchbaeume:505-508` / `en:488-491`, `01_einleitung:227-233` | „die *automatisierte* Bestimmung von $h$ selbst […] ist Zielsetzung und Ausblick dieser Arbeit" · „die heuristik-gesteuerte Vollautomatisierung bleibt Ausblick" |
| E-04 | Räumliche Strukturen und „Exoten" außerhalb des Umfangs | `02_suchbaeume:66-73` / `en:65-70`; Korpus-Grenze `03_messsystem:25` | „liegen außerhalb des Umfangs" · „die räumliche Such-Klasse fehlt ganz" |
| E-05 | Hashing nur als **Vergleichsgröße**, nicht als Beitrag | `02_suchbaeume:64-66` / `en:63-65` | SwissTable/Cuckoo „treten dieser Arbeit als nicht-baumartige Vergleichsgröße zur Seite" |
| E-06 | Drei PRT-ART-Schichten laufen im Messpfad auf CE-Standard | `01_einleitung:209-211`, `03_messsystem:1344-1346` / `en:1319-1322` | „laufen im Mess-Pfad derzeit über den Cache-Engine-Standard (Anbindung als Folgeschritt~E6)" |
| E-07 | T8↔Store **nicht verdrahtet** | `03_messsystem:709-710` / `en:700-701` | „Die Kopplung der Nebenläufigkeit~(T8) an den Store ist im Code (noch) nicht verdrahtet (gepunktet)." |
| E-08 | CAS-Latenz nur **deklariert**, nicht gemessen | `03_messsystem:1094-1096` / `en:1077-1080` | „ein rein *deklariertes* Glied […] die Arbeit weist das aus, statt einen Messwert vorzutäuschen" |
| E-09 | ML-gestützte Auswahl = zukünftige Arbeit | `03_messsystem:1424` / `en:1402` | „bleibt zukünftiger Arbeit vorbehalten" |
| E-10 | **Filterkette nicht implementiert** | `03_messsystem:1502-1503` / `en:1476-1477` | „Diese Kette ist im heutigen Code nicht umgesetzt; sie wird als Konzept festgehalten" |
| E-11 | **Bau-Varianten-Matrix und vierter Schritt existieren nicht** | `03_messsystem:1514-1517` / `en:1488-1491` | „Weder die Bau-Varianten-Matrix noch der komplementäre vierte Schritt existieren im heutigen Code" |
| E-12 | Nur **Modus 1** (Mess-Modus) ist heutiger Betrieb | `03_messsystem:1430-1432` / `en:1408-1409` | „die Modi zwei bis vier sind das erklärte Ziel dieser Arbeit" · Beleg: `libs/cache_engine/hybrid/` enthält nur `README.md` |
| E-13 | Messkurven-Typsystem: nur „**Keim**" | `03_messsystem:1481-1483` / `en:1456-1457` | „erst der Keim --- eine Kurvenanpassung über eine Achse und eine x-Dimension" |
| E-14 | **Gesamtbilanz** vollzogen/ausstehend | `03_messsystem:1519-1522` / `en:1493-1496` | „noch ausstehend sind die vollständigen Messläufe; Ziel sind Auswertungs-, Arbeits- und Hybrid-Modus, das volle Messkurven-Typsystem, die Filterkette und die Messfehler-Kontrolle" |
| E-15 | Fremd-Frameworks (TPC/SOSD/SPEC/CloudSuite/Allokator-Suiten) **nicht realisiert** | `03_messsystem:326-327` / `en:321-322` | „die noch nicht im eigenen Mess-Apparat realisierten Frameworks […] werden über einen *Datensatz-Lader* angebunden" |
| E-16 | Kein eigenes PMC-Tooling | `04_implementierung:498` / `en:489-490` | „Ein eigenes PMC-Tooling existiert nicht: Die Zähler-Instrumentierung steckt im Mikro-Tooling." |
| E-17 | Speicher-Fußabdruck, Fill-Buffer, IPC/CPI bleiben ungültig | `04_implementierung:547-550` / `en:536-540` | „bleiben ungültig, bis eine echte Peak-Spalte beziehungsweise eine Hardware-Quelle existiert" |
| E-18 | Windows/macOS = ehrliche **Nur-Deklarations-Zellen** | `04_implementierung:571-573` / `en:560-562` | „nicht implementierte Zellen (Windows, macOS) sind ehrliche Nur-Deklarations-Zellen" |
| E-19 | Pool-/Prefetch-/Layout-Komponenten im Prüfling = **Deskriptor-Skelette** | `04_implementierung:31-34` / `en:30-33` | „derzeit Deskriptor-Skelette ohne echte Speicheranbindung" |
| E-20 | Planer und Builder teilen **eine** Binary | `04_implementierung:287-288`, `03_messsystem:1187-1189` | „das ist ehrlich dokumentiert, kein Schein-Split" · Beleg: `apps/experiment_planner` mit Subkommandos `validate`/`plan`/`tier` |
| E-21 | **xlsx-Writer nicht gebaut** | `06_fazit:170-172` / `en:164-166` | „ist noch nicht gebaut" · Gegenprobe: `grep -rl xlsx Code --include=*.hpp/*.cpp/CMakeLists.txt` → 3 Treffer, alle nur Etiketten |
| E-22 | **Paper-Isolations-Modus nicht gebaut** | `06_fazit:88-91` / `en:86-88` | „ist dagegen nicht gebaut und bleibt Ausblick" |
| E-23 | **Passungs-Stempel ist Entwurf** | `06_fazit:130-135`, `anhang C:84-86` | „dieses Konzept ist im Stand dieser Arbeit Entwurf, nicht gebaut" |
| E-24 | Voll-Bau + 320er-Abgabemessung **nicht gefahren**; E2E-Läufe aus | `06_fazit:147-153` / `en:143-149` | „ist noch nicht gefahren, ebenso wenig die Abgabe-Messung über den kleinen materialisierbaren 320er-Katalog" |
| E-25 | Ergebniskapitel „aktuell **methodisch**"; Smoke ersetzt die Pflichtreihen nicht | `06_fazit:154-156` / `en:150-152` | „konkrete Messungen folgen […] ersetzt die Pflicht-Messreihen aber nicht" |
| E-26 | Modul-Body-Lücken: PRT-ART-**Prüfling-Stub**, honest-0 Storage-/Prefetch-Achsen | `06_fazit:142-146` / `en:138-142` | „als Lücken bleiben der PRT-ART-Prüfling-Stub sowie die ehrlich auf null gesetzten Storage-/Prefetch-Achsen der Pool-Familien offen" |
| E-27 | HW-Erkennung nur **Stufe 1+2**; Verdrahtung/Rückschrieb/Roundtrip offen | `06_fazit:163-169` / `en:158-163` | „ausstehend sind die Verdrahtung in Runner und Prüf-Dock, der additive Ergebnis-Rückschrieb…" |
| E-28 | **„Beschattung"**: einzelne Effekte sind Apparat- statt Organ-Artefakte | `06_fazit:176-177` / `en:170-172` | Wichtig: entlastet die Smoke-Reihe, **kollidiert aber** mit M-07 („erstmals unter sonst gleichen Bedingungen separierbar") |
| E-29 | 17 Vertragsoperationen = **Folgeschritt** | `06_fazit:100-101` / `en:98` | Beleg: `pruef_dock/conformance_gate.hpp:10` „Heute auf den 5 Kern-Ops" |
| E-30 | Wall-Clock **nicht bit-reproduzierbar**; Timer-Overhead nicht kalibriert; Prefetch misst Pseudo-Adressen; memory_layout-Effekt teils sub-noise; Entwurfs-Etiketten ohne Mess-Einfluss | `le_limitierung.tex:24,33,28,30,34` | „Seed steuert Keys (deterministisch), NICHT das CPU-Timing" · „Es findet KEINE Leer-Schleifen-Kalibrierung statt" · „kein echter Speicher-Prefetch" · „‚hybrider Visitor' (real ein Memento, kein `accept()`/Host-Besuch)" |
| E-31 | Herkunfts-Eingeständnis: Achsen-Architektur aus Vorarbeit des Autors übernommen | `01_einleitung:179-181` / `en:174-176` | „der Beitrag dieser Arbeit ist seine Übertragung auf cache-bewusste Suchstrukturen und seine mess-orientierte Realisierung" — **entlastet den Neuheitsanspruch** |
| E-32 | Keine gemessene `std::map`-Leistungsserie, weil `std::map` das **Konformitäts-Orakel** ist | `anhang A:184-190` | „damit ein Korrektheits-, kein Leistungs-Datenpunkt" |
| E-33 | Bewusst **kein** Box-Plot, weil nur zwei Perzentile gemessen | `anhang A:163-167` | „wird bewusst kein Box-Plot mit interpolierten Quartilen gezeichnet" |
| E-34 | Drei Mess-Modi „existieren noch nicht als Typen" (**überholt**, s. F-12j) | `anhang D:1269` | Achtung: diese Grenze ist im Code **eingelöst** und damit selbst korrekturbedürftig |
| E-35 | Power-ISA und RISC-V beschrieben, **nicht freigeschaltet** | `anhang D:882` | „im heutigen Bau-Angebot aber nicht freigeschaltet" |
| E-36 | Nur **10 von 16** Mess-Kategorien einem Werkzeug zugeordnet | `anhang D:1182` | „die übrigen sind […] noch keinem Werkzeug zugeordnet" |
| E-37 | Workload-Clustering **bewusst offen** | `03_messsystem:1440-1441` / `en:1417-1418` | „ist bewusst offen gelassen und Gegenstand weiterer Untersuchung" |
| E-38 | Graph-Gattung: **Unterklassen offen** | `03_messsystem:766` / `en:758` | „eigener Organsatz \\ Unterklassen offen" |
| E-39 | Mess-Lauf materialisiert nur **gedeckelte spärliche Teilmenge** | `03_messsystem:1237-1239` / `en:1216-1218` | trägt die Deckelung gegenüber „alle erdenklichen Permutationen" — **aber nur im Kapitel, nicht in der gesetzten Aufgabenstellung**, s. §8/O-3 |
| E-40 | Ersatztext-Doktrin für fehlende Abbildungen (honest-100 %) | `anhang A:77-88` | „JEDER `\InputIfFileExists`-Eintrag trägt seinen EIGENEN Ersatztext" — verifiziert: 29/29 tragen individuellen Text. **Ausnahme: zwei Texte sind sachlich falsch, F-07** |

### 6.2 Was diese Liste **nicht** entlastet

Vier Bereiche liegen außerhalb jeder Grenze und sind deshalb heute reine Falschaussage:
- **Talos / zweites OS-Regime** (F-01) — kein Limitierungs-Punkt nennt es.
- **`flat_hash_map`** (F-02) — in der gesetzten Aufgabenstellung, ohne Rücknahme.
- **Sechs überschriebene Slots** (F-05) — die Arbeit entlastet *drei* Schichten, nicht die sechs Slots.
- **Vierte Evaluations-Dimension** (M-06) — in keiner Limitierungs-Liste, obwohl ihre Voraussetzung (Bau-Varianten-Matrix) über E-11 ausdrücklich als nicht existent deklariert ist.

---

## 7. Die sechs Freitage

Endtermin **Di 15.09.2026**. Von heute (Do 06.08.) bis dahin liegen genau **sechs Freitage**: 07.08. · 14.08. · 21.08. · 28.08. · 04.09. · 11.09.

Zuordnung nach zwei Kriterien: (1) Textkorrekturen zuerst, weil sie billig sind und Falschaussagen sofort tilgen; (2) Bauposten nur, wo sie eine Hypothese tragen, die sonst gestrichen werden muss.

### Freitag 1 — 07.08. · „Falschaussagen tilgen, Kosten null"

Reine Textpässe, DE+EN, kein Codebau. Nach Abschluss enthält die Arbeit keine Aussage mehr, die durch das *heutige* Repo widerlegt wird.

| Posten | Aufwand | Warum jetzt |
|---|---|---|
| §63-T-04 PMC-Limitierung differenzieren (4 Stellen/Sprache) | < 1 h | Arbeit spricht sich vorhandene Messgröße ab |
| §63-T-09 `le_limitierung.tex:21` auf 18 Achsen | < 1 h | innerer Widerspruch im PDF |
| §63-T-11 T11 → T10 | Minuten | |
| §63-T-10 „320 Tests" streichen | Minuten | Zahlenkollision auf einer Seite |
| §63-T-13 Sammel-Textpass Kardinalitäten (25→26, 21/17→22, SwissTable, SHA512, YCSB-Version, curve_fit-Pfad, Mess-Record-Ort, run_methodology) | 2–3 h | |
| §63-T-06 `resolve_baustein` → `compositions/*.hpp` als Beleg | 1 h | |
| §63-T-21 / §63-T-22 zwei stale Ledger-Zeilen schließen | Minuten | §63-T-21 würde bei Ausführung eine Regression erzeugen |
| §63-T-07 **Generator-Lauf prüfen** (sind die 12 Ratio-/Normbar-Darstellungen aus dem Bestand erzeugbar?) | 2 h | entscheidet, ob F-07b Bau oder Text ist |

### Freitag 2 — 14.08. · „Rohdaten und Datenschema"

| Posten | Aufwand | Warum jetzt |
|---|---|---|
| §63-T-08 **WIDE-Rohdaten aus `Messdaten-Backup/` zurückholen** oder Wiederholungslauf im heutigen Schema | 1–2 Tage | Ohne diesen Schritt sind die Anhang-Tabellen der Abgabe nicht reproduzierbar. **Höchste Priorität nach den Textpässen.** Doktrin: Messdaten nie löschen — sie müssen im Backup liegen |
| §63-T-07 Ersatztexte richtigstellen (falls Generator-Lauf negativ) | 1 h | |
| **Durchsatz-Spalte** in den Mess-Record (`cache_engine_builder_iterator.hpp`) | 0,5 Tag | Voraussetzung für H2 (M-04). Ohne sie ist H2 zu streichen — Owner-Entscheid O-6 |
| §63-T-03 `docs/quality_audit`-Pfad heilen + H2-Definition auf cppcheck-Verfahren umschreiben | 0,5 Tag | |

### Freitag 3 — 21.08. · „Messreihe B wird ein echter Sweep"

| Posten | Aufwand | Warum jetzt |
|---|---|---|
| `messreihen.xml:48-56` — Reihe B von A_full-Klon auf **echten Achsen-Sweep** umstellen | 1 Tag | Trägt M-07, die stärkste wissenschaftliche Aussage der Arbeit. Ohne sie ist `05_evaluation:230-238` unbelegt |
| **≥3 Stützpunkte `working_set_n`** in die Sweep-Definition | 0,5 Tag | Trägt die 3 `ld_sweep_*`-Darstellungen, heilt F-07a endgültig |
| **YCSB-E** in den Workload-Satz | 0,5 Tag | Trägt H1 vollständig (M-03) |
| §63-T-12 LP02/LP03/LP07/LP13 bauen **oder** Tabelle auf 10 kürzen | 0,5–1 Tag | Owner-Entscheid O-7 |

### Freitag 4 — 28.08. · „PRT-ART in den Messpfad (E6-Teil)"

| Posten | Aufwand | Warum jetzt |
|---|---|---|
| §63-T-05 **PRT-ART-Prefetch- und ChainRef-ValueHandle-Organ** in `PrtArtComposition` verdrahten | 2–3 Tage | Ohne ChainRef ist **H3 unbelegbar** (M-05) und muss gestrichen werden. Ohne Prefetch trägt die Sechs-Slot-Zusage nicht |
| Restliche Sechs-Slot-Aussage im Text auf das Erreichte ziehen | 1 h | |
| §63-T-02 Entscheidung `flat_hash_map` umsetzen (Weg nach O-2) | 0,5–1 Tag | |

**Ab hier: Schnitt.** Was bis 28.08. nicht steht, wird zur Grenze, nicht zum Bau.

### Freitag 5 — 04.09. · „Der Abgabe-Messlauf"

| Posten | Aufwand |
|---|---|
| **320er-Katalog-Lauf** über Reihe A (≥8 Rang-1) und Reihe B (Achsen-Sweep), ≥2 Wiederholungen, HDR-Perzentile, PMC an | 2–3 Tage Rechenzeit, batchweise à 4096 |
| Auswertungskette: `binary_to_csv` → `csv_to_latex` → `diagram_generator` → Anhang-Generator | 0,5 Tag |
| Prüfen, welche der 29 fehlenden Darstellungen der Lauf schließt | 0,5 Tag |

### Freitag 6 — 11.09. · „Text an die Daten, Grenzen ziehen, einfrieren"

| Posten | Aufwand |
|---|---|
| Zahlen im Text auf den Abgabestand ziehen (Testzahl gestrichen, Katalog-Umfang, Lauf-Datum, Commit-Hashes je Baseline) | 0,5 Tag |
| **Limitierungs-Kapitel schließen**: alle unter §7.7 gelisteten Grenzen als Punkte in `06_fazit.tex:141-179` und `le_limitierung.tex` aufnehmen, DE+EN | 1 Tag |
| Schlussdurchlauf DE+EN, `.blg` alphadin, 0 undefinierte Referenzen | 0,5 Tag |

**Puffer 12.–14.09.** Kein Bau mehr.

### 7.7 Was **nicht mehr schaffbar** ist und als Grenze in die Arbeit gehört

Diese Posten sind bis zum 15.09. nicht erreichbar. Sie müssen als Limitierung formuliert werden — nicht als stille Auslassung.

| Posten | Warum nicht schaffbar | Formulierungsvorschlag für das Limitierungs-Kapitel |
|---|---|---|
| **Talos / zweites OS-Regime** (F-01) | Infra read-only für diesen Agenten, Installation auf zwei Produktionsmaschinen | „Die Erhebung erfolgt unter einem root-Linux mit vollem Hardware-Zähler-Zugriff. Das zweite, immutable Betriebssystem-Regime (Talos) ist konzipiert, aber im Rahmen dieser Arbeit nicht erhoben; ADR-12 beschreibt insoweit ein Zielbild." |
| **Zweite Maschinen-Lane (Intel)** im Messstrang | CI-Mess-Jobs sind einlanig `tags: [prod, baremetal, amd]` (`.gitlab-ci.yml:719,806`); das Zähler-Gate ist zweilanig (`ce .gitlab-ci.yml:52,147-157`), der Mess-Strang nicht | „Der Zähler-Nachweis erfolgt zweilanig (AMD und Intel, beide Pflicht ohne `allow_failure`); der Mess-Strang selbst läuft im Stand dieser Arbeit einlanig auf der AMD-Produktionsmaschine." |
| **2¹⁷ × 4 = 524.288 Binaries** | 128 Batches à 4096 | bereits als Grenze vorhanden (`06_fazit:147-149`) — nur präzisieren: gefahren wurde der 320er-Katalog |
| **Vierte Evaluations-Dimension / heuristischer Gegenbeweis** (M-06) | Bau-Varianten-Matrix existiert nicht (E-11), Hybrid-Modus = nur README | **fehlt bislang in jeder Limitierungs-Liste** — muss ergänzt werden: „Die vierte Evaluations-Dimension setzt eine Bau-Varianten-Matrix voraus, die im heutigen Code nicht existiert (Abschnitt …); die Entscheidungsregel ist damit als Methodik formuliert, nicht als vollzogenes Verfahren." |
| **H2-Korrelation**, falls die Durchsatz-Spalte nicht bis Freitag 2 steht | drei fehlende Voraussetzungen | H2 aus der Hypothesen-Liste streichen oder auf „qualitative Einordnung" zurücknehmen — **Owner-Entscheid O-6** |
| **Original Compiler Binary linking** (§63-T-18) | acht fremde Codebasen gegen den eigenen Bau zu linken ist der teuerste Einzelposten; Ledger:612 bestätigt, dass die Kern-Vier über CE-Pool-Stores messen | „Die Rekonstruktion erfolgt als registrierte Re-Implementierung gegen das jeweilige Original; das Linken gegen die Original-Binaries der Veröffentlichungen ist außerhalb des Umfangs. Für ART, HOT, START und Wormhole liegt der Original-Code im deaktivierten Wrapper-Body vor und ist nicht Teil des Mess-Pfades." |
| **Alle Workload-Frameworks** (§63-T-17) | ein registriertes Rahmenwerk (YCSB) | „Als Last-Rahmenwerk ist YCSB registriert; die übrigen im Stand der Technik gefundenen Rahmenwerke werden über einen Datensatz-Lader angebunden, nicht als eigenes Rahmenwerk geführt." — teilweise vorhanden (E-15), aber **nicht gegen die gesetzte Aufgabenstellung gestellt** |
| **Bias-freie Vollmatrix in voller Kardinalität** (M-08, §63-T-19) | 30 × 14 × 3 × 3 | Reichweite benennen: „Die Vollmatrix wird über den 320er-Katalog gegen alle registrierten Lastprofile gefahren; die Ausdehnung auf den vollen Permutationsraum bleibt Ausblick." **Owner-Entscheid O-5** |
| **17 Vertragsoperationen** (§63-T-16) | 5 implementiert | bereits Grenze (E-29), aber die Kopplung an die Plattform-Verifikation (`06_fazit:91-93`) ist mehrdeutig — **Owner-Entscheid O-4** |
| **Multi-Prüflings-Pipeline** (§63-T-20) | Code sagt „future" | Präsens auf „vorbereitet" ziehen |
| **Drei Wallclock-Ebenen** (§63-T-15) | `seg_*_ns` ungefüllt | Präsens auf das Erreichte ziehen oder als Zielbild markieren |

---

## 8. Offene Fragen an den Owner

Je Frage: die beiden zulässigen Wege, meine Empfehlung, und was die Wahl kostet. **Wo »bauen« und »Aussage abschwächen« beide vertretbar sind, gehört die Wahl dem Owner.**

---

**O-1 · Talos (F-01, §63-T-01)**
Bauen oder zurücknehmen?
- (a) Talos-Lane bauen: mehrere Tage Infra auf zwei Produktionsmaschinen, Cluster ist für diesen Agenten read-only. Nutzen: ADR-12 hält.
- (b) ADR-12 + zwei Kapitelstellen je Sprache zurücknehmen: < 1 h. Kosten: die Arbeit verliert die Aussage »Produktiv-Einsatz gespiegelt«.
- **Empfehlung: (b).** Die Aussage steht heute im Perfekt und ist nachweislich unwahr; das Risiko in der Verteidigung übersteigt den Nutzen der Aussage bei weitem.

**O-2 · `flat_hash_map` (F-02, §63-T-02)**
Die Bindung steht in der **gesetzten Aufgabenstellung** — dem Text mit dem geringsten Änderungsspielraum.
- (a) `absl::flat_hash_map` vendoren + registrieren (~1 Tag) und **messen** (hängt an Freitag 5).
- (b) In den gebundenen Kapiteln die Gegenprobe namentlich auf die eigene S22-SwissTable umstellen und die Abweichung ausweisen.
- (c) Beides: bauen **und** die Abweichung erklären, falls die Messung nicht mehr in den Lauf passt.
- **Empfehlung: (c).** Der Baustein ist billig; die Messung ist der Engpass. Ein registrierter, aber ungemessener Baustein plus ehrliche Notiz ist besser als beides fehlend.

**O-3 · „alle erdenklichen Binary-Permutationen" (§63-T-12-Umfeld, E-39)**
`aufgabenstellung/de.tex:74-75` sagt es **ohne jede Einschränkung**; `03_messsystem:1237-1239` gesteht die Deckelung ein — aber im Kapitel, nicht in der gesetzten Aufgabenstellung.
- (a) Die Deckelung in einem gebundenen Kapitel ausdrücklich gegen den Aufgabenstellungs-Wortlaut stellen (»die Aufgabenstellung formuliert den vollen Produktraum; materialisiert wird eine gedeckelte, kanonisch definierte Teilmenge von 2¹⁷ Identitäten je System-Permutation, davon der 320er-Katalog«).
- (b) Nichts tun und auf `:1237-1239` vertrauen.
- **Empfehlung: (a).** Der Betreuer liest die Aufgabenstellung als Zusage; sie unwidersprochen stehen zu lassen ist die riskantere Variante.

**O-4 · Was heißt »der `std::map`-Vertrag« in `06_fazit.tex:91-93`? (§63-T-16)**
> „Als erfolgreich verifiziert gilt eine Plattform erst, wenn das Konformitäts-Gatter den `std::map`-Vertrag je Modul bestätigt."
**Diese Formulierung ist mehrdeutig.** Meint »Vertrag« die heute geprüfte 5er-Kernteilmenge (`conformance_gate.hpp:10`) oder die 17 Vertragsoperationen aus `:101`? Bei der zweiten Lesart kann **heute keine Plattform als verifiziert gelten**.
- **Empfehlung:** Formulierung eindeutig machen — »den Kern-Vertrag (Einfügen, Suchen, Löschen, Leeren, Größe)« — und die 17 als Folgeschritt daneben stehen lassen. Das ist eine Präzisierung, keine Abschwächung.

**O-5 · Die bias-freie Vollmatrix (§63-T-19)**
Sie ist in **drei** gebundenen Kapiteln zugesagt und im REGISTER auf »reine Doku-Vermerke, kein Bau« abgestuft (`REGISTER:415`).
- (a) Hochstufen: Vollmatrix über den 320er-Katalog gegen alle registrierten Lastprofile fahren (Freitag 5).
- (b) Reichweite in der Arbeit begrenzen.
- **Empfehlung: (a), begrenzt.** Die Bias-Freiheit ist der methodische Kern; ohne sie verliert die Arbeit ihr stärkstes Unterscheidungsmerkmal gegenüber den Einzelveröffentlichungen. Aber sie muss nicht über 2¹⁷ laufen — über den 320er-Katalog gegen alle Lastprofile ist sie belegt und formulierbar.

**O-6 · Hypothese H2 (M-04, F-03)**
H2 braucht (i) den Score, (ii) eine Durchsatz-Spalte, die es **nicht gibt**, (iii) genug Datenpunkte. Und ihre Definition beschreibt ein nicht implementiertes Verfahren.
- (a) Durchsatz-Spalte bauen (Freitag 2), Score-Definition auf cppcheck umschreiben, H2 messen.
- (b) H2 aus der Hypothesen-Liste streichen oder auf eine qualitative Einordnung zurücknehmen.
- **Empfehlung: (a), mit Abbruchkriterium.** Wenn die Durchsatz-Spalte nicht bis Freitag 3 steht, dann (b). H2 ist die einzige *statistische* Hypothese; eine unbelegte statistische Aussage ist teurer als eine fehlende.

**O-7 · Vier fehlende Lastprofile LP02/LP03/LP07/LP13 (§63-T-12)**
- (a) Vier Profil-XML bauen (~0,5–1 Tag), Tabelle bleibt.
- (b) Tabelle `03_messsystem:366-379` auf 10 kürzen und die Nummerierung schließen.
- **Empfehlung: (a).** Profile sind XML, kein Code; die Tabelle mit exakten Op-Mixes zu kürzen kostet mehr Text als die Profile zu bauen.

**O-8 · PRT-ART-Slots (F-05, §63-T-05)**
- (a) Prefetch **und** ChainRef verdrahten (2–3 Tage, Freitag 4). Trägt H3.
- (b) Nur ChainRef (trägt H3, lässt die Prefetch-Zusage fallen).
- (c) Beides fallenlassen, Text auf einen Slot zurücknehmen — dann **H3 streichen**.
- **Empfehlung: (b) als Minimum, (a) wenn Freitag 4 hält.** ChainRef ist die Voraussetzung von H3; Prefetch trägt »nur« die Sechs-Slot-Zusage, die auch textlich heilbar ist.

**O-9 · WIDE-Rohdaten (F-08, §63-T-08)**
Wie weit soll die Suche gehen, bevor auf Wiederholungslauf umgeschaltet wird?
- **Empfehlung: ein Tag Suche in `Messdaten-Backup/` und `measurement/`, dann Umschalten.** Die Doktrin »Messdaten nie löschen« lässt erwarten, dass sie da sind. Ein Wiederholungslauf im heutigen 18-Achsen-Schema wäre sauberer, macht aber die bereits committeten Anhang-Tabellen ungültig — also entweder alles neu oder alles gefunden, nicht gemischt.

**O-10 · Der Schnittpunkt (Freitag 4, 28.08.)**
Ab wann wird nicht mehr gebaut, sondern nur noch als Grenze formuliert? Ich schlage **28.08.** vor: danach bleiben zwei Freitage für Messlauf und Textschluss plus drei Tage Puffer.
- **Empfehlung: bestätigen oder verschieben.** Wenn der Schnitt später liegt, entfällt der Puffer — bei einer Abgabe mit zwei Sprachfassungen ist das die riskanteste Einsparung.

---

## Nenner dieses Dokuments

- **SOLL-Korpus geprüft:** 12 eingebundene Kapitel-Dateien (DE+EN), 12 eingebundene Anhang-Dateien, 2 Aufgabenstellungs-Dateien, `diplomarbeit.tex`, `config/language.tex`, 48 Tabellen-Dateien unter `anhang/{de,en}/tabellen/`, Gegenprobe an `diplomarbeit-{de,en}.fls` und `-.log`. Nicht als Zusage gewertet: 16 nicht eingebundene Alt-Kapitel (DE+EN), Einbindungsstatus je über `.fls` **und** Selbst-Marker doppelt belegt.
- **IST-Korpus geprüft:** `Code/external/comdare-cache-engine/libs/**`, `apps/**`, `tools/**`, `tests/unit/CMakeLists.txt`, `ext/{traversal,allocator}` (Verzeichnisebene), `Code/0[1-9]_*`, `Code/experiment_config`, `Code/test_data_xml`, `Code/measure_out_d03`, `measurement/`, `comdare-prt-art/prt_art/**` (genannte Header), beide `.gitlab-ci.yml`.
- **Tracking geprüft:** LEDGER 6.735 Zeilen, REGISTER 474 Zeilen.
- **Positionen:** 12 Falschaussage-Positionen (F-01…F-12 mit 10 Unterpunkten in F-12) · 23 Ledger-Einträge (§63-T-01…23) · 45 geprüfte Zahlen (25 halten, 10 nicht, 10 ohne Datengrundlage) · 12 messdatenabhängige Aussagen (M-01…M-12) · 40 Entlastungen (E-01…E-40) · 10 Owner-Fragen (O-1…O-10).
- **Grep-Disziplin:** durchgehend `/usr/bin/grep`. Jede Null-Aussage (Talos, `flat_hash_map`, `quality_audit`, `resolve_baustein` in libs/apps, `coco_p04_neg0` in CSV, LP02/03/07/13, LADDIS, `xlsx`-Writer) mit Nenner **und** positivem Kontrollmuster im selben Suchraum belegt.
- **Nicht geprüft:** `docs/termine/` (auftragsgemäß ausgeklammert — der Widerspruchs-Abgleich Thesis ↔ Termin steht damit aus); `ext/`-Fremdquellen inhaltlich; `comdare-prt-art` über die genannten Header hinaus; die inhaltliche Vollständigkeit der drei EN-Alt-Kapitel (nur Nicht-Einbindung verifiziert).
- **Mehrdeutig und als solche ausgewiesen:** `06_fazit.tex:91-93` (»der `std::map`-Vertrag«, O-4); `aufgabenstellung/de.tex:74-75` (»alle erdenklichen Binary-Permutationen«, O-3); `03_messsystem:1486-1488` (Kurven-Zusage im Indikativ innerhalb eines als Zielbild markierten Abschnitts).
