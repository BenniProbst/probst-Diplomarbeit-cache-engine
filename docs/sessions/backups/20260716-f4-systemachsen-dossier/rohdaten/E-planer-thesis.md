# STRANG E — Rohdaten: Experiment-Baum-Filter für die CEB-Stufe, Anwendungs-Landschaft („dritte Anwendung"), Thesis-Soll

> Erhoben 2026-07-16, read-only-Kartierung (außer dieser Datei). Pfadkürzel:
> `SUPER` = `/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/Code`,
> `CE` = `SUPER/external/comdare-cache-engine`,
> `THESIS` = `/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/thesis/diplomarbeit`,
> `DOCS` = `/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/docs`.
> USER-Konzept-Anker (wörtlich verankert): `DOCS/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md:368` (F3i/F4/F5-Klärung, „dritte Anwendung", Compiler-Systemachse, Voll-Vergleich, „alt gegen neu") und `:370` (Entscheidungsrunde 2, F1 XML-Programmier-Bibliothek, F6 CI-Interpreter + Live-Feature-Tracking).

---

## TEIL 1 — Der „Filter für die Stufe der CEB": Ist-Verortung im experiment_tree

### 1.1 Der Experiment-Baum (Planungs-Resultat, lazy)

- `CE/libs/cache_engine/builder/experiment_tree/experiment_tree.hpp:2` — KF-9 „Experiment-Permutations-/Kompositions-Präfixbaum (Experiment-Manager der Cache-Engine-Bibliothek)".
- Benennungs-Ehrlichkeit: KEIN textbook-B+-Baum, sondern achsen-geschichteter Präfixbaum; „B+-Baum"-Name historisch/aspirational (`experiment_tree.hpp:4-10`). Der User-Begriff „Experiment-B+-Baum" meint exakt diese Struktur.
- Materialisierungs-Modell: Gesamtbaum NIE voll materialisiert; `binary_count()` = ∏ rein arithmetisch; immer nur EIN Pfad Wurzel→Blatt lazy (mixed-radix Odometer) (`experiment_tree.hpp:14-25`).
- `struct BinarySpec` (`experiment_tree.hpp:223`): statische Eigenschaften EINER zu kompilierenden Tier-Binary — `binary_id` (serialisierter Static-Pfad), `pinned_signature`, `(achse,wert)`-Liste.
- `class StaticBinaryView` (`experiment_tree.hpp:235`): lazy indizierte Sicht auf den statischen Teilbaum; `operator[](i)` dekodiert on-demand genau EINE BinarySpec; `flat_index(tuple)` = mixed-radix-Enkodierung (`experiment_tree.hpp:259`); erzeugt aus dem Baum via `static_binary_view()` (`experiment_tree.hpp:458`).

### 1.2 BuildSelection = die endliche Selektions-Stufe (S0–S3)

- `CE/libs/cache_engine/builder/experiment_tree/coverage_selection.hpp:25-30` — `struct BuildSelection { std::vector<std::size_t> indices; std::string provenance; }`: „die EINE endliche, gewählte Index-Liste in den statischen Teilbaum"; Provenance-Audit „kein stilles Truncaten" (`:24`).
- Drei orthogonale Reduktionsstufen S1 BUILD-PROFIL ⊥ S2 Coverage-Sampling ⊥ S3 explizit/pinned (`coverage_selection.hpp:10-11`); Selektoren: `select_full` (S0, `:37`), `select_one_wise` (S2, `:53`), `select_explicit` (S3a, `:66`), `select_by_pinned_signature` (S3b, `:76`).
- Konsum: `BuildOrchestrator::provision_all(view, selection, stats)` baut NUR die selektierten View-Indizes, O(K) (`CE/libs/cache_engine/builder/build_orchestrator/build_orchestrator.hpp:195-198`; Voll-View-Overload `:191`).
- Pipeline-Kette wörtlich: „StaticBinaryView (lazy, ∏) → BuildSelection (endliche K Indizes) → je Binary: MeasureFn(binary_id) → result_ingest → ExperimentTree-NodeValue (sparse)" (`CE/libs/cache_engine/builder/experiment_tree/e2e_pipeline.hpp:4-5`).

### 1.3 DER FILTER: CoR-Filterkette (Doc 20 §C, ce-Commit 076b71cf)

- SOLL (User-Vision 10.07., autoritativ): „Die Auswertungen ergeben automatisch eine Filterkette; das Pattern Chain of Responsibility wird strikt im CacheEngineBuilder-Bereich für die Kontrolle der Tier-Binary-GENERIERUNG umgesetzt (Auswertung → Filter → welche Permutationen werden als Nächstes gebaut/verworfen)" (`DOCS/architektur/20_HEURISTIK_MESSKURVEN_TYPSYSTEM_UND_FILTERKETTE.md:41-45`).
- IST (Slice 1, ce `076b71cf`, 2026-07-11, CI-grün): `CE/libs/cache_engine/builder/experiment_tree/selection_filter_chain.hpp` —
  - Selbstbeschreibung: „S4 (mess-getriebene Reduktionsstufe): Chain of Responsibility (GoF) im CacheEngineBuilder fuer die Kontrolle der Tier-Binary-GENERIERUNG (Doc 20 §C). Schliesst die heute fehlende Feedback-Kante Auswertung (best_binary_selector) -> Generierung (build_orchestrator provision_all)" (`selection_filter_chain.hpp:2-6`).
  - `struct FilterVerdict { Pass | Reject | PassToNext }` + Survive-Regel „überlebt ⇔ Kette liefert KEIN Reject" (`:32-39`).
  - `struct PermutationCandidate { view_index; binary_id; optional<MeasurementRow> row; }` — `binary_id` als 19-Achsen-Join-Schlüssel Auswertung↔Generierung (`:42-46`).
  - Abstrakter `FilterHandler` mit successor-Link + `dispatch` (`:49-69`).
  - EIN Kern-Handler `ResumeFilter`: bereits `two_phase_valid` gemessene Permutation → Reject aus dem Bau-Set (Resume KF-16b + Mess-Ehrlichkeit Doc 20 §D); nicht-duplikativ zum DLL-Cache-Skip des Orchestrators (`:71-83`).
  - Runner `run_selection_filter_chain(candidates, ordered, upstream_provenance) → BuildSelection` mit Provenance-Fortschreibung `…|filtered:cor` (`:87-101`).
  - Cold-path-Legitimation: läuft zwischen Mess-Runde und nächstem provision_all, NICHT im gemessenen Hot-Path (`:10-13`).
- Commit-Beleg: ce `076b71cf` „feat(builder): E4′ §C — CoR-Filterkette (GoF) im CEB: Auswertung→Generierung-Feedback-Kante … Slice 1 (rein additiv, header-only, kein Produktions-Code beruehrt)" (git show, ce-Repo).

### 1.4 KERNBEFUND: Der Filter existiert, ist aber NICHT in die CEB-Stufe verdrahtet

- `run_selection_filter_chain`/`ResumeFilter` hat GENAU EINEN Konsumenten: den Unit-Test `CE/tests/unit/test_d15_selection_filter_chain.cpp` (`:59/:66/:73/:78`; ctest-Registrierung `CE/tests/unit/CMakeLists.txt:1515`). grep über `CE/libs` + `CE/apps` = 0 Produktions-Treffer.
- Der offizielle E4-Pfad selektiert HEUTE ausschließlich per `select_explicit` OHNE Filterketten-Glied dazwischen: `CE/libs/cache_engine/profile_facade/profile_runner.hpp:238/:268` und `CE/libs/cache_engine/profile_facade/profile_run_entry.hpp:314/:341/:397` (SOTA-Pass = einwertiger Baum + `select_explicit({0})`).
- D.h.: die Feedback-Kante Auswertung→Generierung ist als Baustein gebaut und bewiesen (test_d15), aber die CEB-Stufe (BuildSelection → provision_all im run_profile-Unterbau) ruft sie nie auf. Gated-Rest laut Doc 20 §E: PaperComparison (§D-Schritt-4, data-gated: keine Paper-Wall-Clock-Referenz) + Pareto/Dominanz (braucht Messkurven-Typsystem) — „additiv als weitere Kettenglieder" (`DOCS/architektur/20_…FILTERKETTE.md:66`).
- Einordnung ans USER-Konzept (Ledger `:368`): „Der Experiment-B+-Baum ist ein Resultat der PLANUNG des Gesamtsystems, hat aber einen Filter für die Stufe der CacheEngineBuilder und der durch ihn zu bauenden und am Prüfdock zu messenden Tier-Binaries" — der Ist-Baustein `selection_filter_chain.hpp` IST exakt dieser Filter (gleiche Richtung: kontrolliert, welche Tier-Binaries die CEB-Stufe baut/misst), Status = Slice 1 unverdrahtet + 2 gated-Glieder fehlend.
- Nächst-liegender Andockpunkt (bereits kartiert, Fork-A-Dossier): die Pass-Schleife `run_lazy_static_then_dynamic(<tree>, sel, a.compile, …)` (`profile_run_entry.hpp:328/:355/:413`; Iterator `CE/…/experiment_tree/cache_engine_builder_iterator.hpp:666` „sel liefert die endlichen View-Indizes") — dort müsste `sel` künftig durch die CoR-Kette (Kandidaten = Selektion + MeasurementRow-Join über binary_id) laufen, bevor `provision_all` baut.

---

## TEIL 2 — Anwendungs-Landschaft heute + Lücke „Experiment-Planer mit XML-Interpreter" (dritte Anwendung)

### 2.1 Executables im CacheEngine-Repo (`CE/apps/CMakeLists.txt:6-30`, „hier nur die main.cpp-Wrapper" `:1-4`)

| App | Rolle (Selbstauskunft) | Beleg |
|---|---|---|
| `cache_engine_builder` | CEB-CLI = dünner Wrapper um `comdare::builder::ExperimentDriver`-Library (Phase-1-7-Pipeline); Selbstauskunft: „This Builder is the cache-engine-Demo-Driver. The real Experiment-Orchestrator (3 Messreihen A/B/C) lives in Diplomarbeit/Code/messung_driver/" | `CE/apps/cache_engine_builder/main.cpp:2-12` u. `:84-86` |
| `perm_runner` | „der lokale Cluster-Mess-Runner je Binary … lädt EINE perm-DLL via AnatomyModuleLoader … emittiert EINE result_ingest-Zeile" = das Prüfdock-Executable je Tier-Binary | `CE/apps/perm_runner/main.cpp:1-7` |
| `f15_compare` | CLI-Treiber F15-Messlauf über materialisierte Permutations-DLLs (Welch + Holm-FWER gegen Baseline) | `CE/apps/f15_compare/main.cpp:2-9` |
| `adhoc_emitter` | emittiert je Permutation eines Pilot-Raums ein kompilierbares Permutations-Modul-.cpp (Configure-Time, 2-Pass) | `CE/apps/adhoc_emitter/main.cpp:1-6` |
| `anatomy_codegen_tool` | CMake-Composition-Snippet-Codegen | `CE/apps/anatomy_codegen_tool/main.cpp:2-7` |
| `catalog_codegen_tool` | Thesis-Profil → generierter Source-Katalog-Header | `CE/apps/catalog_codegen_tool/main.cpp:1-2` |
| `permutation_codegen_tool` | C++23-Port von codegen.cmake (Default-Backend `cpp` seit GO-2) | `CE/apps/permutation_codegen_tool/main.cpp:2-10` |
| `is_original_validator` | Pre-Build SHA256-Original-Body-Validierung | `CE/apps/is_original_validator/main.cpp:1-6` |
| `h2_score_akte_tool` | Generator der tool-berechneten H2-Code-Qualitäts-Akte (sota_h2_scores.xml) | `CE/apps/h2_score_akte_tool/main.cpp:1-3` |

- CEB-als-Lib: `CE/libs/cache_engine/builder/experiment_driver/experiment_driver.hpp:2-7` — „ExperimentDriver — Library-Refactoring der Phase 1-7 Pipeline … Der Driver (von Diplomarbeit/Code/messung_driver/main.cpp) ruft die Methoden in der richtigen Reihenfolge auf."

### 2.2 Executables im Super-Repo (Auswertungs-Pipeline, `SUPER/`)

- `02_messung_driver` = der E4-HOST: „Master-Orchestrator fuer die 3 Pflicht-Messreihen A/B/C … konsumiert comdare::builder::ExperimentDriver" (`SUPER/02_messung_driver/main.cpp:4-12`); E4-Alleinweg im Block `main.cpp:561-632` („E4-XML ist der DEFAULT-/ALLEINWEG", Zitat kartiert in `DOCS/sessions/backups/20260716-fork-a-bruecken-dossier/DOSSIER-ENTWURF.md:15`), Aufruf `run_profile_facade(pa)` (`main.cpp:611` lt. Dossier `:15`).
- Stufen 01/03/04/05/06/07/08/09 = eigenständige Pipeline-CLIs (sample_data_generator, binary_to_csv, csv_to_latex, diagram_generator, latex_to_pdf, tier_binary_report, appendix_generator, tex_formatter) — je `main_cli.cpp`/`main.cpp` + Lib (Verzeichnis-Listing `SUPER/01…09`).

### 2.3 Wo die XML-Interpretation heute lebt — und was als „dritte Anwendung" FEHLT

- Der Experiment-XML-PARSER ist bereits ein ce-Modul, aber KEINE Anwendung: `parse_experiment_profile` (`CE/libs/common/serialization/xml_config_parser/xml_config_parser.hpp:323`), Structs `ExperimentPhase`/`ExperimentProfile` (`:268/:288`), Validat `validate_experiment_profile` (`CE/libs/cache_engine/profile_facade/validate_profile.hpp:444ff`, lt. Fork-A-Dossier `:31`).
- Die AUSFÜHRUNG der Experiment-XML ist heute die (per Fork A deprecatete) v32-Parallelstrecke im messung_driver (in-process, doppelt gegatet; `DOSSIER-ENTWURF.md:31`), SOLL = dünne Brücke über den offiziellen E4-Pfad (`DOSSIER-ENTWURF.md:33-56`).
- Die PLANUNGS-Bausteine (Experiment-Baum, StaticBinaryView, BuildSelection, CoR-Filter, Repetition-Plan, SLURM-Launcher) sind ausnahmslos Header in `CE/libs/cache_engine/builder/experiment_tree/` (Verzeichnis-Listing) — es gibt KEIN Executable, dessen Aufgabe „Experiment planen" ist.
- ⇒ LÜCKE (die „NEUE DRITTE ANWENDUNG", Ledger `:368`): ein eigenes App-Level-Programm „Experiment-Planer mit XML-Interpreter" existiert nicht. Lesart der Zählung nach dem M-Modell der Thesis (zwei tragende Anwendungen heute): (1) `messung_driver` = WAS (`THESIS/kapitel/de/03_messsystem_prtart.tex:393-394` u. `:412`), (2) `CacheEngineBuilder` = WIE („autonomes Plattform-Ausmess-System", `03_…tex:395-396` u. `:414`); der Planer/Interpreter wäre die dritte. (Die Codegen-/Validator-CLIs sind Werkzeuge, keine Framework-Anwendungen; perm_runner ist das Mess-Organ der CEB-Stufe.)
- SOLL-Funktionsumfang der dritten Anwendung aus den User-Direktiven:
  - F1 (Ledger `:370`): „die Cache Engine stellt als Framework eine BIBLIOTHEK bereit, welche per XML-Config die ‚Programmierung' von Experimenten UND deren Auswertung erlaubt" — inkl. wählbarer Auswertung/Veröffentlichung/Speicherort je Experiment (`<phases>` 1..unbounded).
  - F6 (Ledger `:370`): „die XML der Diplomarbeit steuert dynamisch die Programmierung der CI über einen INTERPRETER; wir können live anhand der XML mitverfolgen, welche Teile der GESAMTEN CacheEngine zu jeder Zeit gerade durchgeführt werden; JEDES einzelne Feature der Cache Engine muss in XML unterstützt sein und je Aufgabenschritt in der CI automatisch getrackt sein."
  - F3i(1) Compiler-Systemachse (Ledger `:368`): „in der XML muss es möglich sein, sowohl den CacheEngineBuilder als auch JEDE einzelne Tier-Binary-Permutation entweder mit gcc oder mit clang zu bauen". IST-Gegenbefund: der EINE Compile-Injektionspunkt des offiziellen Pfads ist `make_gpp_compile_fn(…, cxx_compiler())` mit `cxx_compiler()` = env `COMDARE_CXX` sonst hart `"g++-16"` (`CE/libs/cache_engine/profile_facade/profile_run_facade.cpp:95-98`; Injektion `:150` lt. Dossier `:17`) — EIN globaler Compiler je Lauf, KEINE per-Tier-Permutation-Achse, keine XML-Steuerung, kein clang-Zweig; die Compilerwahl des CEB selbst liegt ausschließlich beim äußeren CMake-Toolchain-Setup.
  - Planung „nach einer Strategie" (Ledger `:368`): Strategy-Anker existiert bereits als INC-E-Familie `PhaseStrategyFor<S>`/CRTP (`SUPER/02_messung_driver/experiment_phase_strategy.hpp:70-138`, lt. Dossier `:62` wiederverwendbar) sowie die 16-Kategorien-System-Mess-Achsen-Registry als „Blut" (`CE/libs/cache_engine/include/cache_engine/measurement/measurement_axis_registry.hpp:2-3/:31`).
- Abgrenzung (Doppelbau-Verbot, Memory `feedback_vor_aufgaben_erst_projektstruktur_analyse` + Fork A): die dritte Anwendung darf KEINE neue Parallelstrecke werden — sie muss den EINEN offiziellen Pfad (run_profile-Unterbau → BuildOrchestrator → AnatomyModuleLoader → Prüfdock → offizielle CSV) als Unterbau konsumieren (`DOSSIER-ENTWURF.md:11/:35`), dabei die heute unverdrahtete CoR-Filterkette (Teil 1.4) als ihre Selektions-Stufe verdrahten.

---

## TEIL 3 — Thesis-Soll (kapitel/de 03+05+06 + Aufgabenstellung): Compiler / Debug-Mess-Release / 2-OS / ISA / Voll-Vergleich

### 3.1 Compiler-Vergleich — heute NICHT als Achse formuliert, sondern als KONSTANTE

- Aufgabenstellung: „Compiler, Flags, ISA-Pfad, Allokator sowie Commit-Hash jeder Baseline werden protokolliert" (`THESIS/aufgabenstellung/de.tex:116`) — Compiler = Protokoll-Metadatum, keine Vergleichsdimension.
- Evaluation identisch: „für jede Fremdbibliothek werden Compiler, Flags, ISA-Pfad, Allokator und Commit-Hash mitgeloggt" (`THESIS/kapitel/de/05_evaluation.tex:81-82`).
- Fazit bindet die Fairness sogar AN Compiler-Konstanz: „unter identischer Compiler- und Flag-Basis auf Hybrid-CPUs und Sapphire-Rapids gegenübergestellt" (`THESIS/kapitel/de/06_fazit.tex:14`); FF4: Laufzeit-Selektion „ohne die gemeinsame Compiler- und Flag-Basis zu verletzen", Binaries tragen `get_compiler()`-Kennung (`06_fazit.tex:53-59`).
- ⇒ DELTA zum User-Konzept F3i(1) (Ledger `:368`): die NEUE Compiler-SYSTEMACHSE (XML wählt gcc ODER clang für den CEB selbst UND je Tier-Binary-Permutation) ist im Thesis-Soll nirgends formuliert; die heutige Formulierung („identische Compiler- und Flag-Basis") müsste zu „Compiler als kontrollierte, protokollierte Permutations-Dimension" fortgeschrieben werden (Fairness bleibt: Vergleiche INNERHALB einer Compiler-Belegung, Achsen-Vergleich ÜBER Belegungen).

### 3.2 Debug-/Mess-/Release-Varianten — in der Aufgabenstellung verankert

- „Die systemoptimierte Binary lässt sich dabei wahlweise mit oder ohne Mess-Observer übersetzen --- als Debug-, Mess- oder Release-Variante." (`THESIS/aufgabenstellung/de.tex:128-129`).
- Korrespondierendes Architektur-SOLL: 3-Varianten-Observer-Einbau (alle+Hybrid / nur Heuristik-Tier / keiner) + komplementärer 4. Schritt Wall-Clock-only, Paper-Vergleich vor Pareto (`DOCS/architektur/20_…FILTERKETTE.md:47-57`); IST = „fehlt — Defines heute HART an alle Tier-Kompilate" (`:67`), Mess-Defines hart im Compile-Injektionspunkt (`profile_run_facade.cpp:71-73` lt. Dossier `:17`).
- FF2 trennt bereits Produktiv-Modus (Messung aus, kein Overhead) vom Experiment-Modus (`THESIS/kapitel/de/06_fazit.tex:30-34`).

### 3.3 Zwei Betriebssystem-Regimes — im Messplan verankert

- „Auf den Produktions-Zielmaschinen wird zudem jede Messung unter zwei Betriebssystem-Regimes erhoben …: Ein immutables Betriebssystem (Talos) spiegelt den Produktiv-Einsatz …; ein root-Linux mit vollem Hardware-Zähler-Zugriff (perf/MSR) macht … die zählerbasierten Mess-Kategorien … überhaupt erst zugänglich. Die zeit- und observer-basierten Kategorien laufen unter beiden Regimes identisch" (`THESIS/kapitel/de/05_evaluation.tex:67-74`).
- „die Betriebssystem-Dimension ist über die zwei Mess-Regimes aus Kapitel eval bereits im Messplan verankert" (`THESIS/kapitel/de/06_fazit.tex:61-62`).

### 3.4 ISA-Dimensionen — als Compile-Time-Achse T12 + Build-SIMD formuliert

- T12 ISA: „Vendor-Spec x86-64/AArch64/Power/RISC-V (+ SIMD) … Ziel-ISA als Compile-Time-Achse" (`THESIS/kapitel/de/03_messsystem_prtart.tex:80`); Sub-Achsen IS1-IS3 (`:120`); Build-Achse simd_extension SE1-SE3 „SSE2/AVX2/AVX-512/NEON/SVE2/RVV; GPU: CUDA" (`:129`); Fließtext (`:193-194`).
- Plattform-Matrix: je Plattform Scalar-, AVX2- und (Barnard) AVX-512-Build; P-/E-Cores getrennt; `IPlatformProbe` meldet lauffähige Achsen-Teilmenge (`05_evaluation.tex:61-67`).
- FF1-Teilfrage: „Cache-Update-/Cache-Line-Füllverhalten unter allein variierter ISA-/SIMD-Achse ist methodisch beantwortet — die ISA-Achse (T12) ist bei sonst achsen-konstanter Struktur isoliert permutierbar; die empirische Antwort folgt" (`06_fazit.tex:25-28`); FF4: „plattform-spezifische Achsen (ISA, Hardware-Konstanten) werden zur Übersetzungszeit fixiert" (`06_fazit.tex:53-55`).

### 3.5 Voll-Vergleich + „alt gegen neu" — heutige Formulierungen vs. F3i(2)/(3)

- Aufgabenstellung Teilaufgabe 5: 3 Pflicht-Messreihen (A Prüfling vs. SdT, B systematische Variation, C Merge/Regression alt gegen neu) × 3 Granularitäten; Gesamt-Benchmarking = „YCSB-ähnliche Lastprofile … über jede Rekombination der Entwurfsbestandteile" (`THESIS/aufgabenstellung/de.tex:75-84`).
- Drei-Stufen-Prüfung des Builders: Stufe 1 (nur Cache-Engine, Standard je Achse), Stufe 2 (nur Prüfling), Stufe 3 (Full Join, nicht-redundant); „der vorliegende Mess-Lauf materialisiert davon eine spärliche, gedeckelte Teilmenge" (`03_messsystem_prtart.tex:437-443`); Zuordnung Stufen→Messreihen (nicht 1:1): Stufe1+2 → A, Stufe3-Full-Join → B, „build-übergreifend: alt gegen neu derselben Konfiguration → C" (`:465-470` + Tabelle `:479-482`).
- Evaluation: Reihe B „gespeist aus dem Full Join der Stufe 3", Reihe C „Merge/Regression alt gegen neu, build-übergreifend" (`05_evaluation.tex:103-106`); Kern = Achsen-Sensitivitätsanalyse (welche Achse trägt die meiste Varianz; Rangbildung über 3 Granularitäten → Standard-Konfig je Workload-Klasse) (`:114-124`).
- ⇒ DELTA zum User-Konzept (Ledger `:368`):
  1. **Voll-Vergleich F3i(2)** („jede Tier-Binary unter Last gegen ALLE anderen — welche Achsen-Permutationen unter welchen Datenlasten mit welchen COMPILERN auf welchen ISA+OS am besten laufen"): das Cross-Produkt Permutation × Datenlast × ISA × OS ist im Thesis-Soll vorhanden (3.3/3.4 + Sensitivitätsanalyse), die COMPILER-Dimension fehlt vollständig (3.1); die All-gegen-alle-Rangbildung ist als Sensitivitäts-/Rang-Analyse formuliert, nicht als expliziter paarweiser Voll-Vergleich.
  2. **„alt gegen neu" F3i(3)**: Thesis-C definiert „alt gegen neu" als build-/versions-übergreifende REGRESSION derselben Konfiguration (`03:482/:488-489`); der User definiert es NEU als „bestehenden Stand der Technik gegen einen Prüfling neuer Techniken … für alle genannten Ketten", JE der 3 Stufen (keine 4. Stufe) — d.h. die SdT-vs-Prüfling-Semantik (heute Reihe A / Stufen-Mechanik `stufe_to_reihe`, `CE/libs/cache_engine/profile_facade/sota_catalog.hpp:80-85` lt. Dossier `:29`) soll als eigene Vergleichs-Kategorie mit Unterkategorien JE STUFE ausgeführt werden; die Thesis-Formulierung von Reihe C ist dazu nicht deckungsgleich und muss geschärft werden.
  3. **Systemachsen-Trennung (F4)**: die Thesis führt Scheduling/Hardware heute als „zwei übergreifende Strategie-Achsen … die Hardware-Strategie und die Scheduling-Strategie" nur DESKRIPTIV je Paper (`03_messsystem_prtart.tex:194-197` + Tab. hw-sched `:204-219`, mit thread-per-core/work-stealing/hybrid(P-/E-Kerne)-Profilen); NUMA steckt in T6-Sub-Achsen („Thread-Lokalität/NUMA-Affinität", `:155`), Locking in T8 (`:76`). Als eigenständige PFLICHT-SYSTEMACHSEN „NEBEN den Mess-System-Achsen" (16-Kategorien-Registry, `measurement_axis_registry.hpp:2-3`) existieren Scheduling/Hardware/NUMA/Locking weder im Thesis-Text noch im CEB — deckungsgleich mit dem User-Verdikt „sind TODO; das Konzept ist Pflicht und kaputt".
- Stützstelle für „Systemachsen liegen IN der CEB": die Thesis nennt den CacheEngineBuilder „ein autonomes Plattform-Ausmess-System" (`03_messsystem_prtart.tex:395-396`) — die Plattform-/System-Seite ist ihm bereits konzeptionell zugeordnet; die Gattungs-Achsen werden von ihm in die Tier-Binaries EINKOMPILIERT (BUILD-Kasten `:414-415`, „baut alle Tier-Binaries je Konfig").

---

## Querverweise / Rohdaten-Herkunft

- Fork-A-Brücken-Kartierung (offizieller Pfad end-to-end, alle Anker live verifiziert): `DOCS/sessions/backups/20260716-fork-a-bruecken-dossier/DOSSIER-ENTWURF.md`.
- Doc 20 (Filterkette/Typsystem/IST-Diff): `DOCS/architektur/20_HEURISTIK_MESSKURVEN_TYPSYSTEM_UND_FILTERKETTE.md`.
- User-Wortlaute: Ledger `:368` (F3i/F4/F5) + `:370` (F1-F12 Runde 2) in `DOCS/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md`.
- TABU/golden: nichts berührt; diese Datei ist der einzige Schreibzugriff dieses Strangs.
