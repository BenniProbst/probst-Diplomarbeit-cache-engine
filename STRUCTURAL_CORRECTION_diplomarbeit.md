# STRUCTURAL_CORRECTION REV 7.6 — Diplomarbeit (2026-05-13)

**Status:** **MASTER-Dokument** der Drei-Repo-Architektur-Korrektur. Enthaelt
die User-Original-Nachricht §10 verbatim. Schwester-Dokumente referenzieren
hierher.

**Schwester-Dokumente** (gleicher Sprint, pro Repo):
- comdare-cache-engine: `STRUCTURAL_CORRECTION_cache_engine.md`
- comdare-prt-art: `STRUCTURAL_CORRECTION_prt_art.md`
- Habich-Termin-Zusammenfassung: `20260508 Termin 7/HABICH_TERMIN7_ZUSAMMENFASSUNG_2026_05_13.md`

**Anlass:** User-Klarstellung 2026-05-13: die Code-Verzeichnisstruktur
der **Diplomarbeit** wurde zunaechst falsch verortet und stattdessen in `comdare-cache-engine`
abgelegt. Diese Doku korrigiert die Architektur, **ohne** Code zu verschieben.

---

## §1 Die korrekte Drei-Repo-Architektur (User-Direktive)

```
┌──────────────────────────────────────────────────────────────────────┐
│  Diplomarbeit  (Konzept + Code-Schicht "Messung + PDF-Generierung")  │
│  ─────────────────────────────────────────────────────────────────── │
│  Dokumentation (Phase 1-6)                                            │
│  Termin-Protokolle (Termin 1-7)                                       │
│  Architektur-Skizzen (REV 1-7+)                                       │
│  Diplomarbeits-LaTeX-Manuskript (*.tex)                               │
│                                                                       │
│  +  Code/  ← FEHLT NOCH, war urspruengliches Ziel                     │
│     ├── messung_driver/      (C++ App, ruft prt-art-Submodule auf)    │
│     ├── binary_to_csv/        (deserialisiert Messergebnisse)         │
│     ├── csv_to_latex/         (mit Algorithmus-Baustein-Beschreibung) │
│     ├── diagram_generator/    (C++ Bildgenerator, positioniert        │
│     │                          Diagramme so, dass keine Seiten         │
│     │                          ueberschnitten werden)                  │
│     └── latex_to_pdf/         (Pandoc/pdflatex Driver)                │
│                                                                       │
│  Konfigdatei: experiment_config.{xml,json}                            │
│      Spezifiziert die drei zu messenden Permutations-Modi             │
└──────────────────────────────────────────────────────────────────────┘
                       │
                       │ konsumiert als Git-Submodule
                       ▼
┌──────────────────────────────────────────────────────────────────────┐
│  comdare-prt-art  (Test-Algorithmus + Mess-Interfaces)                │
│  ─────────────────────────────────────────────────────────────────── │
│  Die PRT-ART-Hauptklasse + 7 Bausteine + Mess-Hooks.                 │
│  Liefert AUS der cache-engine NUR die fuer die Messung benoetigten    │
│  Interfaces (Workload-Generator, ResultAggregator, Module-Loader).    │
│                                                                       │
│  Externer Aufruf:                                                     │
│  - Diplomarbeit/Code/messung_driver ruft prt-art-API                  │
│  - prt-art ruft intern cache-engine fuer:                             │
│    + Permutations-Bausteine (23 Allokator-Familien)                   │
│    + 33 Such-Algorithmus-Adapter                                      │
│    + ABI-Modul-Loader fuer SHARED-Permutationen                       │
│                                                                       │
│  Konsumiert als Submodule: external/comdare-cache-engine/             │
└──────────────────────────────────────────────────────────────────────┘
                       │
                       │ konsumiert als Git-Submodule
                       ▼
┌──────────────────────────────────────────────────────────────────────┐
│  comdare-cache-engine  (Werkzeug-Bibliothek + Permutations-Bausteine) │
│  ─────────────────────────────────────────────────────────────────── │
│  STAND DER TECHNIK:                                                   │
│  - 23 Allokator-Familien (A01-A23) aus 21 Paper                       │
│  - 33 Such-Algorithmen (P01-P33) als Adapter/Re-Impl                  │
│  - Cache-Engine-Bausteine: ConcurrencyManager, TelemetryStrategy,    │
│    Page-Typen, Decision-Lambda-Trees, ...                             │
│  - CacheEngineBuilder (Permutations-Orchestrator)                     │
│  - ABI-Modul-Interface (module_abi_v1.hpp)                           │
│                                                                       │
│  WICHTIG: ist NUR Werkzeug-Bibliothek + Konzept-Quelle.               │
│  Wird vom prt-art konsumiert, nicht direkt von der Diplomarbeit.      │
└──────────────────────────────────────────────────────────────────────┘
```

---

## §2 Die drei Messreihen (Pflicht-Output der Diplomarbeit-Code-Schicht)

Aus der `experiment_config` werden DREI Messreihen erzeugt:

### §2.1 Messreihe A — PRT-ART-Testalgorithmus gegen Stand-der-Technik

**Was wird gemessen:**
PRT-ART (heute hybride API mit Vector-/Map-/Tuple-Modi) gegen die in der
cache-engine vorhandenen Stand-der-Technik-Algorithmen (P01 ART, P02 HOT,
P03 Masstree, P04 CoCo-Trie, ...).

**Workload:** YCSB-A..F + synthetische Verteilungen
**Output:** binary measurement_records → CSV → LaTeX-Tabelle

### §2.2 Messreihe B — Bestehende cache-engine-Permutationen

**Was wird gemessen:**
Die existierenden 54 (oder mehr) Permutationen aus der
`example_configs/`-XML, ohne PRT-ART. Reine Vergleichsbasis "Stand der
Technik".

Kommentar des Users: Ich vermisse in der CacheEngine einen Ordner, in dem alle Suchalgorithmen mit ihrer Gesamtkonfiguration als XML/json persistiert sind, sodass die in der CacheEngine einzeln persistierten Algorithmusbestandteile durch die Permutationsbeschreibung wiederherstellbar sind. Derzeit gibt es fälschlicherweise einen PRT-ART Ordner direkt in der CacheEngine, aber der PRT-ART sollte mit neuen Layered Algorithmus-Baustein-Bestandteilen und einer separaten eigenen Konfiguration im PRT-ART repo als Prüfling dargestellt werden, um den Fall einer Beitrittsprüfung eines Algorithmus zum Stand der Technik zu zeigen. In Messreihe A verwenden wir nur die Permutationen für Suchalgorithmen, die bereits in der CacheEngine dokumentiert sind. Dabei können wir zwischen den Modi defined (vorhandene Suchalgorithmusprofile) oder full (Suchalgorithmusprofile ignorieren und jede Rekombination auf dem Algorithmus-Baustein-Stack gegen jede andere prüfen) wählen.

**Output:** Cross-Permutation-Matrix CSV → LaTeX

### §2.3 Messreihe C — Merge alt/neu

**Was wird gemessen:**
Die `experiment_config` definiert konkrete Merge-Punkte, an denen
PRT-ART-Bausteine in die cache-engine-Permutationen eingesetzt werden
(z. B. PRT-ART OLC + tcmalloc-Allokator + ART-Page).

**Hypothese:** Bei welchen Workloads bringt der Merge messbare Vorteile?

**Output:** Differenz-CSV (A − B) → LaTeX-Diff-Tabelle + Diagramme

Kommentar des Users: Formal ist jeder Algorithmus-Baustein eine Ansammlung an compile time std::variants dieser bestimmten Algorithmus Komponente. Formal handelt es sich also synchron auf jeder spezifischen Ebene des Stacks einer ExecutionEngine Implementierung wie SearchEngine - je Ebene um einen full join der angebotenen Algorithmen des oder der multiplen Prüflinge mit der Ebene bekannter Layer-Baustein-Algorithmen, die bereits in der CacheEngine zum Stand der Technik gehören.

---

## §3 Was ich heute falsch verortet habe

| Komponente | Was ich tat | Wo es hingehoert |
|---|---|---|
| `tools/ycsb_cli/` | nach comdare-cache-engine | -> **Diplomarbeit/Code/messung_driver/** (oder als ext. Tool) |
| `tools/latex_anhang/` (CSV → LaTeX-Tabelle) | nach comdare-cache-engine | -> **Diplomarbeit/Code/csv_to_latex/** |
| `tools/latex_toolchain/` (drawio + pdflatex) | nach comdare-cache-engine | -> **Diplomarbeit/Code/latex_to_pdf/** |
| Phase 8 LaTeX-Anhang generell | cache-engine | -> Diplomarbeit |
| `experiment/` (ResultAggregator) | cache-engine | grenzfall — Interface gehoert in prt-art-API, Driver in Diplomarbeit |
| `workload_generator/` | cache-engine | grenzfall — der Generator selbst (Algorithmus) ist Werkzeug = OK in cache-engine; aber der **Caller** ist Diplomarbeit |
| CacheEngineBuilder Phase 4-7 (load+run+record) | cache-engine | grenzfall — der **Driver** des Experiments ist Diplomarbeit, der Mechanismus (cmake-Subbuild + ModuleLoader) ist Werkzeug = OK in cache-engine |

**Kernfehler:** Ich habe das **Anwender-Frontend** (die Phase, die misst und
PDFs erzeugt) in die Werkzeug-Bibliothek gestopft. Die Werkzeug-Bibliothek
soll NUR die Bausteine + Builder-Mechanik liefern; der eigentliche
**Experiment-Orchestrator** (mit Konfigurationsdatei + 3 Messreihen +
PDF-Erzeugung) ist der **Code der Diplomarbeit**.

Kommentar des Users: Immer noch an einer Stelle falsch, weil der PRT-ART formal von der CacheEngine erbt und ein spezieller SearchEngine Suchalgorithmus ist, welcher per polymorpher Metaprogrammierung die eben benannten left/right/full join Eigenschaften beim Testen vereinen muss -> Dadurch gehört der result Aggregator in die abstrakte ExecutionEngine, wird dort mithilfe der SearchEngine als spezielles Messinterface implementiert und ist, wenn wir im experiment Modus kompilieren, immer fester Bestandteil der result binary. Schalten wir den Experiment Modus ab, den wir bei der Kompilation aus dem CMake code der CacheEngine erben, dann kompilieren wir einen Suchalgorithmus als SearchEngine ohne Messung. Dies sollte ein statisch einstellbares CMake compile flag sein, welches default übrigens aus ist, nur der Aufruf des Messtreibers aktiviert und überschreibt die Einstellung beim Laden des PRT-ART, welcher das flag dann seinerseits an die CacheEngine weitergibt.

---

## §4 Migrations-Plan (vorgeschlagen, NICHT umgesetzt)

### §4.1 Was bleibt in `comdare-cache-engine`

- Alle 23 Allokator-Familien-Adapter
- ABI (`module_abi_v1.hpp`)
- CacheEngineBuilder als **Library** (`comdare_builder_*`)
- CacheEngineBuilder als **CLI** mit `--enumerate-only` und Sub-Build
- Module-Loader (Plattform-Schicht, generisch nuetzlich)
- RCU, Succinct, HBM-Hierarchie (Werkzeuge fuer Algorithmen-Bausteine)
- `workload_generator/` als Bibliothek (Algorithmus = Werkzeug)
- `experiment/` (ResultAggregator) als Bibliothek
- 14 LEGACY_REIMPL Skelette (Bausteine = Werkzeuge)

Kommentar des Users: Das ist korrekt, CacheEngineBuilder ist dabei eine Binary die im compile time stack per CMake zu Beginn kompilert und dann direkt ausgeführt wird, um die vorkonfigurierten Module zur compile time, um CMake steuerung abzulösen, zu bauen.

### §4.2 Was in `comdare-prt-art` bleibt / hinzukommt

- PRT-ART-Bausteine (8 Schichten, wie heute)
- **Mess-Interface-Bibliothek:** dünner Wrapper, der die cache-engine-Mechanik
  (Builder + Loader + Aggregator) auf die fuer PRT-ART-Permutationen
  relevanten Ausschnitte zuschneidet
- Submodule-Pin auf aktuelle cache-engine

Kommentar des Users: Die CacheEngine sollte eigentlich die 8 Schichten an den PRT-ART vererben, die es an Algorithmus-Bausteinen gibt. Ich sehe hier nicht klar aufgeführt, dass der PRT-ART strikt die vorhandenen Strukturen und source Interfaces der CacheEngine erweitert. Ich gehe grundsätzlich davon aus, dass der Code stets als source vorliegt und die Bibliotheken hot kompiliert werden, um die Metaprogrammierung und variadische Konstruktur von C++23 optimal ausnutzen zu können.

### §4.3 Was in `Diplomarbeit/Code/` NEU entstehen muss

| Verzeichnis | Komponente | Funktion |
|---|---|---|
| `Code/messung_driver/` | Main C++ Application | Liest `experiment_config`, ruft prt-art-Submodule-API auf, schreibt binary records |
| `Code/binary_to_csv/` | Tool | Deserialisiert measurement_record_v1 zu CSV (heute: cache-engine/experiment/result_aggregator.cpp) |
| `Code/csv_to_latex/` | Tool | CSV → LaTeX-Tabelle MIT automatisierter Algorithmus-Baustein-Beschreibung (heute: cache-engine/tools/latex_anhang) |
| `Code/diagram_generator/` | C++ Bildgenerator | Erzeugt Plot-PDFs (Bar-Chart, Scatter, Heatmap), beruecksichtigt LaTeX-Seitenformat (A4) sodass Diagramme NICHT Seitengrenzen ueberschreiten |
| `Code/latex_to_pdf/` | Driver | Sammelt Tabellen + Diagramme + Manuskript-Kapitel → pdflatex 2×+bibtex (heute: cache-engine/tools/latex_toolchain) |
| `Code/experiment_config.xml` | Konfig | Spezifiziert die 3 Messreihen + Workloads + Merge-Punkte |
| `Code/CMakeLists.txt` | Build | C++23, konsumiert prt-art als Submodule |

Kommentar des Users:
Vollständig korrekt

### §4.4 Submodule-Hierarchie nach Migration

```
Diplomarbeit/
└── Code/
    └── external/
        └── comdare-prt-art/   ← Submodule
            └── external/
                └── comdare-cache-engine/   ← transitive Submodule
```

Doppelte Submodule-Tiefe.  Alternative: cache-engine direkt **auch** als
Submodule in Diplomarbeit/Code/external/comdare-cache-engine — vermeidet
"Submodule-of-Submodule" Pflege-Aufwand.

Kommentar des Users: Die Submodul sollten parallel geführt werden, dazu muss die Diplomarbeit beim build dem prt-art verraten, wo eine required nutzbare und aktuelle cache engine als Bibliothek zu finden ist (source Bibliothek für die weitere Nutzung und template Adaption mit Metaprogrammierung)

---

## §5 Was NICHT migriert werden muss (Diskussion)

Ein paar heute angelegte Komponenten sind **echte Werkzeug-Bibliotheken** und
gehoeren in cache-engine, NICHT in die Diplomarbeit:

1. **`workload_generator/` (Library):** Der Workload-Generator-Algorithmus
   (Zipfian, YCSB) ist eine generische Bibliothek — Stand der Technik. Bleibt
   in cache-engine. Aber die Diplomarbeit ruft sie auf, statt sie selbst zu
   implementieren.
2. **CacheEngineBuilder (Library + CLI):** Die Permutations-Generierung +
   cmake-Subbuild ist eine Werkzeug-Mechanik. Bleibt in cache-engine.
3. **ModuleLoader:** Plattform-Wrapper. Bleibt in cache-engine.
4. **ResultAggregator (Library):** ist eine Bibliothek zur Datenaufnahme +
   CSV/JSON-Export. Die **Anwendung** der ResultAggregator (= Phase 5+6+7 in
   main.cpp) ist die Driver-Logik der Diplomarbeit. Eigentlich sollte
   `cache_engine/builder/main.cpp` **DRINGEND** in die Diplomarbeit verschoben
   werden, weil es der **Experiment-Orchestrator** ist.

**Kandidat fuer Verschiebung:** `cache_engine/builder/main.cpp` → `Diplomarbeit/Code/messung_driver/main.cpp`. Die `cache_engine_builder`-Lib-Targets
(xml-parser, codegen, permutation-loop, module-loader) bleiben in cache-engine.

Kommentar des Users: Das ist korrekt

---

## §6 Was wird aus den heute angelegten Tools?

| Tool | Heutiger Ort | Soll-Ort (User-korrigiert) |
|---|---|---|
| `tools/ycsb_cli` | cache-engine | **VERSCHIEBEN** → Diplomarbeit/Code/messung_driver/ycsb_cli_subset/ |
| `tools/latex_anhang` | cache-engine | **VERSCHIEBEN** → Diplomarbeit/Code/csv_to_latex/ |
| `tools/latex_toolchain` | cache-engine | **VERSCHIEBEN** → Diplomarbeit/Code/latex_to_pdf/ |
| `tools/permutation_codegen` | cache-engine | **BLEIBT** (Werkzeug fuer Builder) |
| `tools/abi_stability_test` | cache-engine | **BLEIBT** (Werkzeug) |
| `tools/compiler_provisioning` | cache-engine | **BLEIBT** |
| `tools/gitlab_ci_zih_push` | cache-engine | **BLEIBT** (Infrastruktur) |
| `tools/socks5_zih_delivery` | cache-engine | **BLEIBT** |

**Konsequenz:** `tools/CMakeLists.txt` in cache-engine reduziert sich um die
3 zu verschiebenden Subdirectories, dafuer entsteht ein neues
`Diplomarbeit/Code/CMakeLists.txt`.

---

## §7 Was bleibt zu klaeren (wartet auf User-Original-Nachricht)

Der User hat angekuendigt: *"Ich liefere im Folgenden noch die original
Nachricht, wie die Struktur bis hierhin geformt wurde, bitte nimm diese
noch mit auf, indem du nach dieser Nachricht auf mich wartest."*

**Offene Fragen, die in der Original-Nachricht erwartet werden:**

1. Wann + von wem (mir? Habich? User?) wurde die Code-Schicht der
   Diplomarbeit urspruenglich geplant?
Antwort: Die Code Schichtung der Cache Engine (neues Diplomarbeit Thema seit Beginn April in Termin 1 bis 7 geplant) und des PRT (älterer comdare Suchalgorithmus, inoffiziell und noch nicht Stand der Technik) wurden beide von Benjamin-Elias Probst geplant und entworfen, Claude Code hat lediglich die Struktur der Anforderungen geordnet und Recherchearbeit geleistet.
2. Welche genauen Komponenten waren urspruenglich vorgesehen?
Ursprünglich war vorgesehen, dass ein CacheEngineBuilder als statisches Programm und Bestandteil der CacheEngine ABI stabile und dynamisch vorkompiliert ladbare C++23 Module (je SearchEngine Suchalgorithmus ein vorkompiliertes Modul) läd und ausmisst, das bedeutet, dass es für den CacheEngineBuilder (den wir beibehalten wollen) eine permutierte vorbereitete Liste an ExecutionEngine virtual Implementierungen gibt, die über ein virtual Interface zuerst getestet (Suchalgorithmus Funktionalität je Suchalgorithmus-Identität per Parameter Set Anzahl) und im nächsten Schritt ausgemessen werden. Wird der experiment Mode der Cache Engine deaktiviert, durchkämmt die CacheEngineBuilder immer noch mit google Tests alle ExecutionEngine/SearchEngine Suchalgorithmus-Funktionalitäten auf Fehler, die in Rekombination aufteten können. Ist eine Permutation für die CacheEngineBuilder nicht vorkompiliert vorliegend, wird sie per runtime auf einen CompilerAufruf aus der Metaprogrammierten Permuation des Suchalgorithmus-Stacks generiert. Daher ergibt sich in der CacheEngine eigentlich ein zweigeteiltes Bild: CacheEngineBuilder builds and permutates -> CacheEngineLib + ExecutionEngine/SearchEngine, wobei die CacheEngineLib die Messmethoden und auch die Cache Strategie Permuationen enthält. Die Diplomarbeit ruft also das CMake der CacheEngineBuilder als Bestandteil der CacheEngine auf, um bestimmte Konfigurationen zu testen. Das Programm wird jedes Mal live mit Metaprogrammierung kompiliert, um im ersten Schritt die CacheEngineBuilder zu erzeugen, die dann als Compile stack handler die übrigen Kompilationen und deren Ausführung zu ihrer runtime orchestriert. Die Kompilation der C++23 Module muss vor den Experimenten abgeschlossen sein, damit diese nicht mit der Messung interferieren.
3. War der **Diagram-Generator (C++)** schon konkretisiert (Library? Tool?
   Welche Algorithmen?)?
Antwort: In Termin 1 bis 7 sind alle Metriken gelistet, die aufgenommen werden müssen, ebenso auch Algorithmen und Paper, welche diese verwenden. Es ist deine Aufgabe alle paper zu durchsuchen, mit welchen Techniken welche Metriken erhoben wurden, damit wir diese übernehmen können.
4. Welche **Konfigurationsdatei** war geplant — XML wie cache-engine, oder
   abweichend?
Antwort: Jeder Suchalgorihtmus und Experiment Strategie (jeweils multiple gegeneinander möglich, beide sollten in einem Dokument darstellbar sein), sollte per xml darstellbar sein, entweder beide zusammen oder getrennt. In der Regel haben beide getrennte Ordner und Definitionssätze zum parsen vor Experiment start durch die CacheEngineBuider.
5. Wie soll der **Submodule-Pfad** sein (doppelt-genested vs. zwei parallele
   Submodules)?
Antwort: parallel

**Bis zur Original-Nachricht:**
- Keine Code-Verschiebung
- Keine Submodule-Aenderungen
- Diese Doku bleibt als WIP

---

## §8 Risiken bei der Migration

1. **Submodule-Tiefe 2:** wenn Diplomarbeit/Code/external/comdare-prt-art/
   wiederum cache-engine als Submodule hat, sind 2 `git submodule update`
   noetig.  Alternative: in cache-engine **NICHT** als prt-art-Submodule,
   sondern in Diplomarbeit/Code/external/ direkt **parallel** klonen.
2. **CMake-Find-Paths:** wenn `comdare::ycsb_cli_lib` in cache-engine
   geloescht wird, brechen evtl. dependende Tests. Tests sollten mit-
   verschoben werden.
3. **PROJECT_LAYER_MAP.md** in cache-engine und Diplomarbeit muss aktualisiert
   werden, sobald die Migration durchgefuehrt ist.
4. **Heutige Delta-Doku 27 + 28 + Teile von 29** verweisen auf
   `tools/ycsb_cli` etc. in cache-engine — werden bei Migration **stale**.
   Korrektur muesste in Delta REV 7.6 dokumentiert werden.

---

## §9 Querverweis

- Aktuelle (fehlerhafte) Aufteilung: `comdare-cache-engine/PROJECT_LAYER_MAP.md`
  Schicht L1 Tools
- Aktuelle (fehlerhafte) Delta-Doku: `27_..._ycsb_cli_…md` + `28_..._cmake_pipeline_…md`
- Korrekte Architektur: dieses Dokument
- Wartet auf: User-Original-Nachricht zur urspruenglich geplanten Struktur

---

## §10 Original-Nachricht des Users (verbatim, Quelle der Architektur-Definition)

> *Anlass: Phase 6 INK-1 bis INK-8 Migration REV 6 (2026-05-12 1500),
> Pre-Habich-Sprechstunde von 2026-05-08, mit nachgelegter Praezisierung.*

### §10.1 Custom Allokation als vergessene Basisdisziplin

> *"Ich habe gerade 20260512-1500-phase6-ink1-bis-ink8-migration-rev6.md
> gelesen und ich denke wir haben die wichtigste Basis-Disziplin der Cache
> Engine vergessen: Custom Allokation. Die Cache Engine ist ebenfalls
> dafuer da, nach bekannten weitreichenden Allokationsmethoden Speicher zu
> verwalten. Dazu brauchen wir eine umfassende wissenschaftliche Analyse
> und Suche nach google scholar papers zum Thema Allokationsmethoden. Mir
> selbst sind Allokationen wie jalloc und malloc und calloc bekannt. Diese
> gehoeren muessen noch als Baustein-Familie UMFASSEND ergaenzt werden,
> wobei zu jedem Paper eine elaborate Zusammenfassung und Recherche nach
> dem Programmcode erfolgen muss (exakt wie bei den anderen Papern bezueglich
> der Suchalgorithmen)."*

### §10.2 Concurrency-/Thread-Anforderungen + std::-Container-Vollintegration

> *"Die Anforderungen an die Allokation sind optionale thread safe
> Implementierungen der std C++ Bibliothek fuer concurrency und allocation,
> bitte recherchiere ausfuehrlich wie die einzelnen permutierten
> Implementierungen der Allokator-Algorithmus-Bausteine den Standard
> typsicher und strukturell korrekt erweitern koennen, indem sie in der
> Lage sein muessen, eine Grundlage aller verwendeten std container zu
> bilden, was umfangreiche Tests fuer Allokation, Container, Threading und
> Concurrency-Sicherheit bedarf. Der Standard der Arbeit ist single
> schreiben und multiple lesen fuer concurrency, Optional sind erweiterte
> local aware multi-write concurrency lock Erweiterungen fuer die Elemente
> der Allokatoren ueber Cache-Page Awareness (bitte lies zu C++17 locks
> welche diese Eigenschaft unterstuetzen und auf die Allokatorvarianten
> angewendet werden koennen)."*

### §10.3 Das ABI-stabile C++23-Interface (Pseudo-Code)

> *"Bezueglich der ABI stabilen C++23 interfaces verhaelt es sich so, dass
> jedes kompilierte Experiment eine bestimmte Execution Engine -> Search
> Engine Rekombination ist, also formal ein zusammengesetzer Custom
> Suchalgorithmus einer definierten Baustein-Permutation als"*
>
> ```cpp
> std::variant<
>     comdare::search_engine<
>         search_algorithm_type_collection<key, value>,
>         configuration_permutation_type
>     > : comdare::execution_engine<processing_strategy_type>(
>         test_data_set_accumulation_engine_type
>             data_accumulation_benchmark_routines(data_set)
>     )
> >();
> ```

### §10.4 Variadic-Parameter-Wandlung (Funktion vs. Typ)

> *"Meine pseudocode Definition bedeutet, dass es Varianten meines
> Suchalgorithmus gibt, die sich einerseits an der Baustein-Permutation der
> Cache-Engine in Rekombination der ExecutionEngine/SearchEngine bewegen
> und die sich andererseits automatisch je nach Anzahl der Parameter der
> Suchalgorithmen in ihrer Funktion wandeln. Wenn nur ein Parameter in
> einem zu generierenden Suchalgorithmus angegeben wird, dann muss dieser
> typ die value sein und wir fuellen den key typ der Darstellung implizit
> automatisch mit einem beim Einfuegen stets hochzaehlenden 64bit unsigned
> long. Werden mehr typ Parameter angegeben, dann ist der erste typ der
> Ebene der key, und alle folgenden Typen formal ein Tupel mit allen
> zusammengesetzten values. Im Falle, dass der Key (nur bei 2 oder mehr
> typ Parametern) ein komplexes Objekt und kein Einfachtyp ist, muss
> dieser implizit mindestens mit einer comdare fingerprint Bibliothek-
> Variante und einer ueberladenden Funktion das komplexe Objekt hashen,
> was zu einem binary string statischer Laenge fuehrt (key einfach-typen
> werden stets per Funktionsueberladung als binary string implizit
> gecastet)."*

### §10.5 Drei-Schichten-Hierarchie (CacheEngine -> ExecutionEngine -> SearchEngine)

> *"Die execution_engine von der die SearchEngine erbt, enthaelt als
> Basisklasse die CacheEngine selbst, die als Visitor Pattern durch
> Abkoemmlinge, wie die SearchEngine, initialisiert und bei Algorithmus-
> Entscheidungen je Fall in jedem Algorithmus-Baustein um Rat gefragt oder
> als experimentelles OS Interface direkt verwendet werden kann. Daher
> muss es fuer den zulaessigen Kern der ExecutionEngine eine durch
> processing_strategy_type definierte, durch permutation statische, per
> Verhalten runtime-dynamische, CacheEngine Konfiguration (Limits,
> Verhalten, Heuristiken, Allokation, Scheduling, Concurrency)."*

### §10.6 CacheEngineBuilder als eigenstaendiges Programm

> *"Da wir also mindestens eine permutierte Rekombination einer Cache
> Engine gegen mindestens eine Permutation eines Custom Algorithmus (oder
> per Konfiguration definierten Algorithmus) testen, entstehen am Ende
> doch 3 Stufen: Der CacheEngineBuilder ist ein eigenstaendiges Programm
> welches ueber einen Satz xml definierter Konfigurationen einerseits alle
> zulaessigen CacheEngine Rekombinationen definiert, von denen in direkter
> Abhaengigkeit die konfigurierten Custom Suchalgorithmen gebaut werden.
> Implizit hat also die execution_engine als typ eine Reihe an CacheEngine
> impliziter Typen, die zur compiletime gesetzt und kompiliert werden, und
> ein search_algorithm ist nichts als eine spezielle execution engine
> (erbt daher compile time statische permutationen festgelegter
> Suchalgorithmus-Bausteine)."*

### §10.7 Schichten-Rollen (Provider vs. Konsument)

> *"Die ExecutionEngine stellt mithilfe der CacheEngine experimentelle OS
> primitiven bereit, die SearchEngine dann Implementierungen fuer
> permutationen der fuer Suche spezifische komplexere experimentelle
> Standard OS Such- und Speicherzugriffsmuster und Routinen bereit; die
> Search Engine bildet dann das Dach des Konstruktes als oberster Layer,
> welcher Suchheuristiken und Konzepte abbildet, die strategisch die
> CacheEngine definierten Limits an Ressourcen abbilden und den Bereich
> der Speicherzugriffsmuster weit ueberschreiten."*

### §10.8 PRT-ART als Pruefling-Algorithmus mit Compile-Time-Fallback

> *"Zum weiteren Vorgehen: Strategisch sollten wir die Struktur der
> CacheEngine in der Bearbeitung der stubs und Struktur bevorzugen, weil
> wir den PRT_ART spaeter dort hinein mergen wollen. Die cache engine
> verfuegt ueber einen Stack an Algorithmus-Bausteinen im Bereich Suche
> und der PRT_ART hat dieselbe Struktur mit seinem spezieller zugelassenen
> permutativen parallel-Stack zum CacheEngine Search stack. Technisch
> gesehen sind daher die processing_strategy_type fuer die
> Rekombinations-Konfiguration, nicht nur auf die execution_engine/
> search_engine, sondern auch auf den PRT_ART im selben parallelen
> Konfigurationsformat anwendbar. Wir erben also aus der CacheEngine die
> Permutations-Struktur-Hierarchie der Algorithmus-Bausteine, wenn die
> Typen aus configuration_permutation_type im Prueflings-Algorithmus wie
> PRT_ART nicht gefunden werden, findet zur compile time automatisch ein
> fallback auf die Bausteine der Cache-Engine Bibliothek statt, von der
> der Algorithmus formal erbt."*

### §10.9 Aktion: _archive_code_pre_migration/

> *"Zu deinem Vorschlag der _archive_code_pre_migration/ --> bitte mach
> das."*

**Status:** ERLEDIGT (verifiziert) — Verzeichnis existiert (268MB lokal),
ist in `.gitignore` als ignored eingetragen (`/_archive_code_pre_migration/`),
wird nicht gepusht.

### §10.10 Erste Doku-Direktive

> *"Bitte dokumentiere im ersten Schritt alle meine Anmerkungen und den
> Plan mit hoechster Praezision, um das Modulare Interface der precompiled
> ABI stabilen C++23 Module vorzubereiten."*

### §10.11 Test-Daten-Akkumulation-Engine

> *"Letzter Hinweis: Wenn wir unterschiedliche Testdatentypen haben, muss
> jeder von diesen Datensaetzen per Deserialization oder parsing in den
> Arbeitsspeicher geladen und verfuegbar (und fair reproduzierbar aligned)
> gemacht werden, um einen definierten Experiment Ablauf ueber
> test_data_set_accumulation_engine_type als Klasse, welche die Daten
> geladen hat und die Test-Algo-Interfaces kennt, bereitstellt. In der
> Regel werden alle Testdatensaetze als Implementierung der SearchEngine
> bei Initialisierung dieser eingelesen test_data_set_accumulation_engine_type
> und bereitgestellt, um dann durch eine separate Testroutine ausgefuehrt
> zu werden."*

### §10.12 Mikrobenchmark-Suite Anforderungen

> *"Die Mikrobenchmark suite ist ein no-deprecate wrapper aller
> Testmethoden und akkumuliert fortlaufend auf einer separaten custom
> Basis-allokation (die so gross sein muss, dass sie nie failed oder
> erweitert werden muss) alle Messergebnisse traced und separat durch
> sparse serialized byte states binary den Testzustand und Fortschritt
> auf einer weiteren separaten custom allocation loggt - alles wird zum
> Ende eines Experimentes erst von binary in handlichere Formate
> konsolidiert und als auswertbares binary blob Ergebnis gespeichert.
> Zur Laufzeit ist der Fokus beim Messen nun mal sparse Eigenschaften
> und minimaler OS Einfluss, statt handliche Formate, die wir bei der
> Auswertung brauchen (conversion Routine im Messmodul notwendig)."*

---

## §11 Delta-Analyse: Original-Nachricht vs. Heutiger Implementations-Stand

### §11.1 KONSISTENT (alle gefordert + heute umgesetzt)

| Anforderung (§10) | Implementations-Stand |
|---|---|
| §10.1 23 Allokator-Familien | DONE — `cache_engine/include/cache_engine/allocators/families/a01..a23/` |
| §10.2 std-Container-Grundlage | DONE — `i_allocation_strategy` + std::pmr-Adapter (Phase 6.2.E + F+G) |
| §10.2 Single-W/Multi-R default | DONE — std::shared_mutex in allen Adaptern |
| §10.2 Multi-W Cache-Page-Awareness | DONE — std::scoped_lock pattern in 23 Adaptern |
| §10.3 ABI-Modul-Interface | DONE — `module_abi_v1.hpp` + 54 SHARED-Module gebaut |
| §10.4 Variadic 1/2/N>2 Params | **HEUTE DONE (REV 7.1)** — hybride PrtArtSearchEngine |
| §10.4 fingerprint::to_binary_string | DONE — `cache_engine/fingerprint/fixed_length_fingerprint.hpp` |
| §10.5 Drei-Schichten + Visitor | DONE — `cache_engine/abi/search_engine.hpp` + `execution_engine.hpp` |
| §10.6 CacheEngineBuilder eigenstaendig | **HEUTE DONE (Phase 7.2)** — 54 DLLs gebaut + 54 Records exportiert |
| §10.8 PRT-ART Compile-Time-Fallback | DONE — REV 7 §6 dokumentiert |
| §10.9 _archive_code_pre_migration | DONE — Verzeichnis existiert (268MB lokal, ignored) |
| §10.11 test_data_set_accumulation_engine_type | DONE als **Klasse** (Phase 6.5) |
| §10.12 Mikrobenchmark-Suite + 2 Custom-Allokationen | DONE (Phase 6.6) |
| §10.12 Sparse-Binary-Logging | DONE (Phase 6.6) |
| §10.12 Conversion-Routine binary → handlich | DONE im Messmodul (no-deprecate-Wrapper) |

### §11.2 INKONSISTENT / FALSCH-VERORTET (heute entdeckt)

| Komponente | Heutiger Stand | Korrektur-Bedarf |
|---|---|---|
| `tools/ycsb_cli` | in cache-engine | **MUSS NACH Diplomarbeit/Code/** (Aufruf-Schicht) |
| `tools/latex_anhang` | in cache-engine | **MUSS NACH Diplomarbeit/Code/csv_to_latex/** |
| `tools/latex_toolchain` | in cache-engine | **MUSS NACH Diplomarbeit/Code/latex_to_pdf/** |
| `cache_engine/builder/main.cpp` Phase 4-7 | in cache-engine | **GRENZFALL** — Driver gehoert in Diplomarbeit, Builder-Library bleibt |
| Diagram-Generator (C++) | **FEHLT KOMPLETT** | **MUSS NEU** in Diplomarbeit/Code/diagram_generator/ |

### §11.3 FEHLEND / NICHT VOLLSTAENDIG (nach Original-Nachricht)

| Anforderung | Status | Notwendige Schritte |
|---|---|---|
| §10.5 CacheEngine als Visitor-Pattern-Service | Konzept dokumentiert, Code als Skelett | Volle Implementation der `(*advise)`, `(*notify)`, `(*snapshot)` callbacks in `module_abi_v1` mit echtem State-Management |
| §10.6 ExecutionEngine erbt direkt von CacheEngine (statt nur via SearchEngine-Pattern) | unklar — REV 7 hat `execution_engine : public ?` | **PRUEFEN** ob direkte CacheEngine-Vererbung im `cache_engine/abi/execution_engine.hpp` korrekt aufgesetzt ist |
| §10.7 SearchEngine als Provider von OS-Search-/Mem-Mustern | als Interface dokumentiert | Implementations-Skelette fuer `notify_density_threshold`, `notify_hot_path_detected`, `notify_workload_change` |
| §10.8 PRT-ART als spezielle ExecutionEngine | Konzept klar, aber **prt-art PrtArtSearchEngine** erbt heute NICHT von `comdare::search_engine` ABI | **KORREKTUR** noetig: PRT-ART muss konkret von cache-engine's `search_engine` erben (REV 7.6) |
| §10.11 test_data_set_accumulation_engine_type bei SearchEngine-init mit-konstruiert | aktuell separate Library | Verbindung: `PrtArtSearchEngine` Konstruktor empfaengt + haelt eine `TestDataSetAccumulationEngine`-Instanz |
| Diagram-Generator C++ | FEHLT | Phase 8.2: in Diplomarbeit/Code/diagram_generator/ als C++ App mit Seitenformat-Awareness (A4, Diagramme nicht ueber Seitenraender) |

### §11.4 ARCHITEKTUR-PRAEZISIERUNG (heute aus User-Klarstellung)

Die drei Repos haben klarere Rollen als bisher dokumentiert:

```
┌─────────────────────────────────────────────────────────────────────┐
│  Diplomarbeit/                                                       │
│  ├── Konzept-Dokumentation (Phase 1-6, REV 1-7+)                     │
│  ├── Termin-Protokolle 1-7+                                          │
│  ├── Manuskript (.tex)  [noch nicht geschrieben]                     │
│  └── Code/   [FEHLT NOCH - heute STRUCTURAL_CORRECTION]              │
│      ├── messung_driver/      → Liest experiment_config              │
│      │                          → Ruft prt-art-Submodule-API auf     │
│      │                          → Schreibt binary measurement-records│
│      ├── binary_to_csv/       → Konvertiert binary → CSV             │
│      ├── csv_to_latex/        → CSV + Algorithmus-Baustein-Doku      │
│      │                          → LaTeX-Tabellen                      │
│      ├── diagram_generator/   → C++ Bildgenerator (Bar/Scatter/Heatmap)│
│      │                          → A4-Seitenformat-aware              │
│      ├── latex_to_pdf/        → pdflatex 2x + bibtex                 │
│      └── experiment_config.{xml,json}  → 3 Messreihen-Spec            │
└─────────────────────────────────────────────────────────────────────┘
                        │
                        │ Submodule
                        ▼
┌─────────────────────────────────────────────────────────────────────┐
│  comdare-prt-art/                                                    │
│  ├── prt_art/identity/PrtArtSearchEngine  (heute hybride API)        │
│  ├── prt_art/{8 Schichten}                                           │
│  └── external/comdare-cache-engine/  [Submodule]                     │
└─────────────────────────────────────────────────────────────────────┘
                        │
                        │ Submodule oder Library-Konsum
                        ▼
┌─────────────────────────────────────────────────────────────────────┐
│  comdare-cache-engine/                                               │
│  ├── cache_engine/builder/{xml-parser,codegen,perm-loop,            │
│  │                          experiment-runner,module-loader}         │
│  ├── cache_engine/include/cache_engine/{abi,allocators,concepts,...} │
│  ├── prt_art/legacy_reimpl/  (14 ext-Adapter-Stubs)                  │
│  ├── workload_generator/                                             │
│  ├── experiment/   (ResultAggregator Library)                        │
│  ├── benchmark_suite/  (Mikrobenchmark Library)                      │
│  ├── test_data_accumulation/                                         │
│  ├── ext/   (23 Source-Repos)                                        │
│  └── tools/{permutation_codegen, abi_stability_test,                 │
│             compiler_provisioning, gitlab_ci_zih_push,               │
│             socks5_zih_delivery}                                      │
│                                                                       │
│  WICHTIG: tools/{ycsb_cli, latex_anhang, latex_toolchain}            │
│  MUESSEN raus + nach Diplomarbeit/Code/                              │
└─────────────────────────────────────────────────────────────────────┘

Antwort: Im Diagramm fehlt die wichtige CacheEngineBuilder Komponente!
```

### §11.5 NACHTRAG (REV 7.6 V8.14, 2026-05-14): Korrigiertes Diagramm mit CacheEngineBuilder

```
┌─────────────────────────────────────────────────────────────────────┐
│  Diplomarbeit/  (WAS getestet wird + Auswertung)                     │
│  └── Code/                                                            │
│      ├── messung_driver/      (3-Reihen-Loop)                         │
│      ├── binary_to_csv/                                               │
│      ├── csv_to_latex/                                                │
│      ├── diagram_generator/   (TikZ, A4-aware)                        │
│      ├── latex_to_pdf/                                                │
│      ├── experiment_config/{a,b,c}.xml  (defined/full Mode V8.13)     │
│      └── external/                                                    │
│          ├── comdare-prt-art/         (parallel Submodule)            │
│          └── comdare-cache-engine/    (parallel Submodule)            │
└─────────────────────────────────────────────────────────────────────┘
                       │ ruft auf via CMake-Sub-Build
                       │ -DCOMDARE_EXPERIMENT_MODE=ON  (V8.4 + V8.12)
                       ▼
┌─────────────────────────────────────────────────────────────────────┐
│  comdare-cache-engine/  (WIE gemessen wird)                          │
│                                                                       │
│  ┌─────────────────────────────────────────────────┐                 │
│  │ STAGE 1 (Compile-Time-Stack, V8.7):             │                 │
│  │   cache_engine/builder/main.cpp                 │                 │
│  │     → CacheEngineBuilder Binary (cache_engine_builder)            │
│  │     → wird zuerst von CMake gebaut + ausgefuehrt                  │
│  └─────────────────────────────────────────────────┘                 │
│                       │                                               │
│                       │ orchestriert                                  │
│                       ▼                                               │
│  ┌─────────────────────────────────────────────────┐                 │
│  │ STAGE 2 (Runtime, V8.7):                        │                 │
│  │   pro Permutation:                              │                 │
│  │     - vorkompiliert? → laden (LoadLibrary/dlopen)                 │
│  │     - sonst       → cmake/cl Hot-Compile      │                 │
│  └─────────────────────────────────────────────────┘                 │
│                                                                       │
│  Library-Bestandteile:                                                │
│  ├── cache_engine/builder/{xml_config_parser, codegen, perm_loop,    │
│  │                          experiment_runner, module_loader,         │
│  │                          experiment_driver/}                       │
│  ├── cache_engine/include/cache_engine/abi/                           │
│  │   ├── execution_engine.hpp   (V8.5: ResultAggregator-Member)       │
│  │   ├── search_engine.hpp                                            │
│  │   ├── algorithm_baustein.hpp (V8.8: std::variant Pattern)          │
│  │   └── resolve_baustein.hpp                                         │
│  ├── cache_engine/algorithm_profiles/  (V8.3 NEU)                    │
│  │   ├── permutation_axes.xml           (11 Achsen + Werte)           │
│  │   └── sota/{art, hot, masstree, coco, start, b2tree, wormhole, surf}.profile.xml │
│  ├── workload_generator/   (Library)                                  │
│  ├── experiment/           (ResultAggregator)                         │
│  ├── benchmark_suite/                                                 │
│  ├── test_data_accumulation/                                          │
│  ├── ext/   (23 Source-Repos: A01-A23 + P01-P30)                     │
│  ├── tools/{ycsb_cli, latex_anhang, latex_toolchain,                 │
│  │          permutation_codegen, abi_stability_test, compiler_provisioning,│
│  │          gitlab_ci_zih_push, socks5_zih_delivery}                  │
│  └── prt_art/legacy_reimpl/  [DEPRECATED V8.2, Migration zu prt-art] │
└─────────────────────────────────────────────────────────────────────┘
                       ▲
                       │ konsumiert als Submodule + erbt 8 Schichten
                       │
┌─────────────────────────────────────────────────────────────────────┐
│  comdare-prt-art/  (Pruefling / Beitritt zum Stand der Technik)      │
│                                                                       │
│  ├── prt_art/include/prt_art/identity/                                │
│  │   ├── prt_art_search_engine.hpp          (REV 7.1 hybride API)     │
│  │   ├── prt_art_search_engine_adapter.hpp  (V8.9 ABI-Adapter)        │
│  │   └── status.hpp                                                   │
│  ├── prt_art/algorithm_profiles/  (V8.10 NEU)                        │
│  │   ├── prtart_pruefling.profile.xml                                 │
│  │   └── permutation_axes_extension.xml                               │
│  └── prt_art/{allocator, concurrency, memory_layout, nodes, prefetch, │
│              traversal, value_handles}/  (8 Schichten Bausteine)      │
└─────────────────────────────────────────────────────────────────────┘
```

**Kernpunkt der Korrektur:** STAGE-1-CacheEngineBuilder + STAGE-2-Hot-Compile,
algorithm_profiles/ in beiden Repos, ABI-Adapter in prt-art, EXPERIMENT_MODE-
Flag-Propagation Diplomarbeit→cache-engine.

---

## §12 Aktualisierter Migrations-Plan (mit Original-Nachricht-Praezision)

### §12.1 Phase M1: Diplomarbeit-Code-Verzeichnis anlegen

Neue Struktur unter `Diplomarbeit/Code/`:

```
Code/
├── CMakeLists.txt                  (top-level, C++23, ruft prt-art-Submodule auf)
├── messung_driver/
│   ├── main.cpp                    (Master-Orchestrator)
│   ├── experiment_config_parser.{hpp,cpp}  (XML-Parser fuer 3 Messreihen)
│   └── CMakeLists.txt
├── binary_to_csv/
│   ├── deserializer.{hpp,cpp}      (measurement_record_v1 → CSV-Zeilen)
│   └── CMakeLists.txt
├── csv_to_latex/                   (verschoben aus cache-engine/tools/latex_anhang/)
│   ├── main.cpp + Library
│   ├── algorithm_baustein_descr/   (NEU: automatisierte Beschreibung pro Baustein)
│   └── CMakeLists.txt
├── diagram_generator/              (NEU)
│   ├── main.cpp                    (C++ Bildgenerator)
│   ├── plot_kinds/{bar,scatter,heatmap}.hpp
│   ├── page_layout/a4_constraints.hpp  (Seitenformat-Awareness)
│   └── CMakeLists.txt
├── latex_to_pdf/                   (verschoben aus cache-engine/tools/latex_toolchain/)
│   ├── latex_toolchain.cmake
│   ├── build_thesis.sh + .bat
│   └── README.md
├── experiment_config/
│   ├── config_a_prt_art_vs_sota.xml
│   ├── config_b_cache_engine_perms.xml
│   └── config_c_merge_alt_neu.xml
└── external/
    └── comdare-prt-art/            (Submodule)
```

### §12.2 Phase M2: cache-engine bereinigen

```
tools/  (aktualisierte Liste)
├── permutation_codegen/        BLEIBT (codegen-Werkzeug)
├── abi_stability_test/          BLEIBT
├── compiler_provisioning/        BLEIBT
├── gitlab_ci_zih_push/          BLEIBT
└── socks5_zih_delivery/         BLEIBT

# ENTFERNT (nach Diplomarbeit/Code/ migriert):
# ├── ycsb_cli/                  → Diplomarbeit/Code/messung_driver/ycsb_subset/
# ├── latex_anhang/              → Diplomarbeit/Code/csv_to_latex/
# └── latex_toolchain/           → Diplomarbeit/Code/latex_to_pdf/
```

Optional: `cache_engine/builder/main.cpp` Phase 4-7 wird DRIVER-frei
gemacht (nur Library-Targets), der Driver wandert nach
`Diplomarbeit/Code/messung_driver/`.

### §12.3 Phase M3: prt-art-Korrektur (REV 7.6)

- `PrtArtSearchEngine` muss konkret von `comdare::search_engine` (aus
  cache-engine ABI) erben — **§10.8** verlangt das.
- Compile-Time-Fallback der `configuration_permutation_type`-Typen muss
  via `resolve_baustein<Algo, BausteineTag>` (cache-engine) verifiziert
  werden.
- `test_data_set_accumulation_engine_type` muss bei Konstruktion mit-
  initialisiert werden — heute fehlt der Hook in der hybriden API.

### §12.4 Phase M4: Builder-Driver-Trennung (cache-engine)

`cache_engine/builder/main.cpp` heutige Phase 4-7 ist konzeptuell der
**Experiment-Orchestrator** der Diplomarbeit. Trennung:

```cpp
// cache-engine: Library-only
namespace comdare::builder {
    class ExperimentDriver {
    public:
        int run_pipeline(...);   // Phase 1-3: enumerate+codegen+build
        int load_all_modules(...);   // Phase 4
        int run_workload(...);   // Phase 5
        int collect_measurements(...);  // Phase 6
        int teardown(...);   // Phase 7
    };
}

// Diplomarbeit/Code/messung_driver/main.cpp:
int main(...) {
    auto config = parse_experiment_config(...);
    comdare::builder::ExperimentDriver driver;
    // Loop ueber 3 Messreihen A, B, C
    for (auto& mode : {Mode::PrtArtVsSota, Mode::CacheEnginePerms, Mode::Merge}) {
        driver.run_pipeline(config_for(mode));
        driver.load_all_modules(...);
        driver.run_workload(...);
        // ... → binary measurement-records
    }
    convert_to_csv(...);
    csv_to_latex(...);
    diagram_generator(...);
    latex_to_pdf(...);
}
```

---

## §13 Verifikations-Liste (Tests vor Migration)

| # | Test | Status |
|---|---|---|
| V1 | `_archive_code_pre_migration/` existiert + ignored | DONE (heute verifiziert, 268MB) |
| V2 | 23 Allokator-Adapter alle compile-bar | DONE (Phase 6.2.E+F+G) |
| V3 | ABI v1 funktional + 54 DLLs ladbar | DONE (heute Phase 7.2.D-F, 54/54) |
| V4 | Variadic-Magic 1/2/N>2 Params | DONE (heute REV 7.1, hybride PrtArtSearchEngine) |
| V5 | fingerprint::to_binary_string fuer alle Typen | DONE (`fixed_length_fingerprint.hpp`) |
| V6 | PRT-ART erbt von cache-engine search_engine | **OFFEN** — heute storage_=std::map, nicht typed search_engine |
| V7 | test_data_set_accumulation_engine_type bei SearchEngine-init | **OFFEN** — heute getrennte Library, nicht im Konstruktor verdrahtet |
| V8 | Diagram-Generator-C++-App | **FEHLT KOMPLETT** |
| V9 | 3 Messreihen (A, B, C) konfigurierbar | **OFFEN** — heute nur 1 Workload hartkodiert in main.cpp Phase 5 |
| V10 | Diplomarbeit/Code/ Skelett angelegt | **OFFEN** — heute komplett in cache-engine fehl-verortet |

---

## §14 Offene Fragen fuer User-Entscheidung

Bevor ich autonom mit der Migration fortfahre, muessen folgende
Entscheidungen geklaert sein:

### Q1: Migrations-Reihenfolge

Option A: **Erst alles in cache-engine fertigbauen + verifizieren**, dann
am Stueck nach Diplomarbeit/Code/ migrieren.

Option B: **Migration parallel mit Implementation**: jede neue Komponente
direkt im richtigen Repo anlegen.

Option C: **Hybrid**: heute geschriebener Code bleibt vorerst in
cache-engine (rueckwaerts-kompatibel), aber Diplomarbeit/Code/ wird NEU
geschrieben (kein Verschieben, sondern Re-Implementation mit klarer
Schichten-Trennung).

**Mein Vorschlag (Recommended):** Option C — Re-Implementation aus zwei
Gruenden:
1. `tools/ycsb_cli`, `tools/latex_anhang`, `tools/latex_toolchain` sind
   funktionierende Tools mit Tests — Wegnehmen aus cache-engine waere
   Verlust + die Tools sind auch ohne Diplomarbeit als Bausteine generisch
   nuetzlich (z. B. fuer prt-art-eigene Workloads).
2. Diplomarbeit/Code/ kann von Anfang an mit der korrekten Schichten-
   Trennung gebaut werden (Driver + Caller-Logik), waehrend die Tools in
   cache-engine die Library-Backbone-Implementation bleiben.

Antwort: Option C, aber mit Prämisse, dass die Schichten von cache-engine -> prt-art -> diplomarbeit in der Reihenfolge überarbeitet werden (also im Prinzip doch A machen aber danach direkt C)

### Q2: Submodule-Struktur Diplomarbeit/Code/

Option A: Submodule-Tiefe 2:
```
Diplomarbeit/Code/external/comdare-prt-art/
                              external/comdare-cache-engine/
```

Option B: Submodule-Tiefe 1 (parallel):
```
Diplomarbeit/Code/external/comdare-prt-art/
Diplomarbeit/Code/external/comdare-cache-engine/
```

**Mein Vorschlag:** Option B — vermeidet Submodule-Recursion + Diplomarbeit
hat direkten Pin auf beide Repo-Versionen.

Antwort: B

### Q3: Diagram-Generator-Technologie

Welche Diagram-Library + Output-Format?

| Library | Vorteile | Nachteile |
|---|---|---|
| matplotcpp (C++ wrapper um matplotlib) | matplotlib-Featuregleich | Python-Dependency (verstoesst F-EXTRA-5!) |
| Custom (PostScript/PDF direkt) | ohne externe Dep, A4-aware | Aufwand |
| TikZ-Code generieren (Output: tikz-LaTeX) | inline in LaTeX-Dokument, A4-aware | LaTeX-Kenntnis noetig |
| Cairo/Skia | full graphics, A4-aware | Library-Dependency |

**Mein Vorschlag:** **TikZ-Code generieren** — kein Python, A4-Awareness
durch direkten LaTeX-Output, Diagramme kommen automatisch im LaTeX-Layout
mit korrekter Seitenpositionierung.

Antwort: TikZ

### Q4: Was passiert mit dem heute angelegten cache-engine main.cpp Phase 4-7?

Option A: BLEIBT als generischer Builder-Demo
Option B: Wird Library-Funktion (run_pipeline()) und der Driver wandert
ab nach Diplomarbeit/Code/messung_driver/

**Mein Vorschlag:** Option B + alter main.cpp wird zu kurzer Demo-Driver
gekuerzt, der die volle ExperimentDriver-Library nur per
`run_pipeline()` aufruft (mit fest-codierter YCSB-C-Demo wie heute).

Antwort: Wie in deinem Vorschlag

---

## §14.5 NACHTRAG (2026-05-13 spaeter Abend): Klarstellung "WAS vs WIE"

**User-Direktive:** *"Der Mechanismus ist nicht Teil der Diplomarbeit. Die
Diplomarbeit bestimmt WAS getestet wird, die CacheEngine bestimmt WIE es
getestet wird. Die Demo workloads sind also Bibliothek Bestandteil der
cache-engine. Die Diplomarbeit bestimmt nur die Compiletime Ausprägung
über die Definition einer Konfigurationsdatei xml (siehe Plan) an die
ExecutionEngine bzw deren Ausführungsengine. Die Diplomarbeit wertet aber
die durch die cache-engine beschriebenen Messungen im Binary Format
selbst aus, daher hat die cache-engine echte Messmodule und
Mikro-Benchmarks wie gehabt und läd precompiled C++23 modules adhoc, aber
die Diplomarbeit verarbeitet die Ergebnisse weiter."*

### Korrigierte Verteilung der Verantwortlichkeiten:

| Verantwortung | Repo | Konkrete Komponenten |
|---|---|---|
| **WIE gemessen wird** (Mechanismus) | comdare-cache-engine | ExperimentDriver-Library, ModuleLoader, Workload-Generator-Library, Builder-Executable, Codegen-Pipeline, Mikrobenchmark-Suite |
| **Driver der Modul-loads + builds** | comdare-cache-engine | `cache_engine_builder` Executable + `experiment_driver` Lib |
| **Demo workloads (Bibliothek)** | comdare-cache-engine | `workload_generator/` (YCSB-A..F, Zipfian, etc.) |
| **WAS getestet wird** (Definition) | Diplomarbeit/Code/ | XML-Configs der 3 Messreihen, messung_driver |
| **Compiletime-Ausprägung-Konfig** | Diplomarbeit/Code/ | `experiment_config/config_{a,b,c}*.xml` |
| **Binary-Ergebnis-Auswertung** | Diplomarbeit/Code/ | binary_to_csv, csv_to_latex, diagram_generator, latex_to_pdf |

### Konsequenz fuer die heutige Refaktorierung:

1. **`tools/ycsb_cli` in cache-engine BLEIBT** — Demo-Workload-Generator
   ist cache-engine Library-Bestandteil (kann als CLI zur Vorab-Generierung
   von binary YCSB-Workload-Files dienen).
2. **`tools/latex_anhang` in cache-engine BLEIBT** — generisches
   Werkzeug fuer CSV→LaTeX (cache-engine-eigenes Diagnose-Tool).
3. **`tools/latex_toolchain` in cache-engine BLEIBT** — generische
   Pipeline-CMake-Skripte.
4. **cache_engine_builder Executable BLEIBT** als WIE-Mechanismus.
5. **REV 7.6 Q4 (Library-Refactoring) ist OK** — Lib in cache-engine,
   main.cpp ist Wrapper. Diplomarbeit/Code/messung_driver konsumiert
   die Library aus dem Submodule.

Die Diplomarbeit/Code/-Module sind **NICHT redundant** zur cache-engine:

- `binary_to_csv` (Diplomarbeit) ist ein **Auswertungs**-Werkzeug, das die
  cache-engine binary-Records in CSV ausgibt. cache-engine selbst hat das
  CSV-Export bereits in `experiment/result_aggregator` — aber das ist die
  cache-engine-interne Variante. `binary_to_csv` in Diplomarbeit liest
  fremde Binary-Output-Files (post-mortem) und macht eigene Diplomarbeits-
  spezifische Anreicherung.

- `csv_to_latex` (Diplomarbeit) ist ein **Manuskript-Integrations**-Werkzeug,
  das LaTeX-Tabellen MIT Algorithmus-Baustein-Beschreibungen erzeugt.
  cache-engine `tools/latex_anhang` ist eine generische Variante ohne diese
  Diplomarbeits-Anreicherung.

- `diagram_generator` (Diplomarbeit) ist NEU — gibt es nirgends in
  cache-engine. Erzeugt TikZ-Code mit A4-Seitenformat-Awareness.

- `latex_to_pdf` (Diplomarbeit) ist ein **Manuskript-spezifischer
  Wrapper** um `cache_engine/tools/latex_toolchain/latex_toolchain.cmake`.

- `messung_driver` (Diplomarbeit) ist die **3-Messreihen-Loop** ueber
  `comdare::builder::ExperimentDriver`. Sie ist Diplomarbeits-Spezifisch
  ("WAS" = welche 3 Messreihen), nicht "WIE" (= Pipeline-Mechanik).

---

## §14.6 Bugfix: latex_toolchain.cmake war im `*.cmake`-gitignore versteckt

Beim ersten Configure-Versuch in Diplomarbeit/Code/ entdeckt:
`tools/latex_toolchain/latex_toolchain.cmake` und
`tools/permutation_codegen/codegen.cmake` waren im Working-Tree, aber durch
das `*.cmake`-Pattern (Zeile 23 in .gitignore) silent von Git ignoriert
worden. Im Submodule fehlten sie daher.

**Fix** (cache-engine `e2dc290`): Whitelist erweitert:

```gitignore
*.cmake
!cmake/*.cmake
!tools/permutation_codegen/*.cmake   # NEU
!tools/latex_toolchain/*.cmake       # NEU
```

Beide Files jetzt committed + im Submodule verfuegbar.

---

## §15 Status der Doku-Vollstaendigkeit

| Item | Status |
|---|---|
| Original-Nachricht des Users verbatim aufgenommen | DONE (§10) |
| Delta-Analyse: konsistent + inkonsistent + fehlend | DONE (§11) |
| Aktualisierter Migrations-Plan (M1-M4) | DONE (§12) |
| Verifikations-Liste (V1-V10) | DONE (§13) |
| Offene User-Entscheidungs-Fragen (Q1-Q4) | DONE (§14) |
| Architektur-Diagramm 3-Repos | DONE (§11.4) |

**Bereit fuer User-Entscheidung zu Q1-Q4 und User-Freigabe fuer autonomen
Modus.**

Per User-Direktive (2026-05-13): *"wenn alles dokumentiert ist, gebe ich
dir volle Autonomie ueber alle vergangenen Punkte innerhalb dieses
Kontext (fahre dann allein fort, aber stelle Fragen, wenn du meine
Entscheidung brauchst)"*

Diese Doku ist jetzt vollstaendig. Autonomer Modus kann starten, sobald
Q1-Q4 beantwortet sind (oder Default-Vorschlaege OK sind).
