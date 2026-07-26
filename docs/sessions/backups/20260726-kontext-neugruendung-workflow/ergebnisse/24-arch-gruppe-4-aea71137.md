# ARCHITEKTUR-LESEBERICHT — 20 Dateien, vollständig gelesen
Wurzel: `/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/docs/architektur/`
Alle Anker unten sind `datei:zeile` relativ zu diesem Verzeichnis. Keine Secrets zitiert (nur Env-Variablen-*Namen*, keine Werte).

---

# (a) DATEI-FÜR-DATEI

## 1. `01_REV_Historie.md` (234 Z., Stand 2026-05-15, K-C.2) — KEIN Superseded-Banner
Versions-Diff über 7 Architektur-Iterationen REV3→REV7.7.
- **Bindende Konfliktregel:** „spaeter > frueher" (`:9`).
- REV3 (`:31-55`): Drei-Ebenen-Wurzel `IExecutingEngine` → Säule A (Suchalgorithmus-DS) → Säule B (CacheEngine/Plattform). Trennungs-Prinzip: Ebene 2 kennt CPU/Cache **nicht** direkt, konsumiert nur `ICacheStrategy` (`:57-60`).
- REV4 (`:64-76`): drawio-Regeln (keine `"` in value-Attributen; orthogonalEdgeStyle) — ASCII-Doktrin-Vorläufer.
- REV5 (`:83-97`): 12 Review-Korrekturen K02–K12; K10 = 8 Hybrid-Auflösungen; K12 = F15 Cross-Matrix.
- **REV6-Korrektur 2026-05-12 (User-Direktive, `:115-128`):** PRT-ART ist **ADDITIV**, ersetzt NICHT die 6 Seitentypen aus Termin 4. Cache-Engine permutiert ALLE Seitentypen; PRT-ART nutzt intern nur 2 Node-Typen (Redirect + B+).
- REV7 (`:132-149`): Custom-Allokation als **Basisdisziplin** (vergessen worden, nachzuziehen); ABI-stabiles C++23-Modul-Interface Drei-Schichten (`execution_engine → search_engine → prt_art`); CacheEngineBuilder als **eigenständiges Programm** mit XML-Konfiguration (`:145`).
- REV7.1 (`:157`): `status_t` errno-style (0=ok, >0=error); Schreib-/IO-Ops returnen IMMER int; API-Arität 1/2/N → vector/map/map<K,tuple>.
- REV7.6 (`:169-173`): **Drei-Repo-Layer** — `Diplomarbeit/Code/` = WAS+Auswertung, `comdare-prt-art` = Prüfling, `comdare-cache-engine` = WIE+Werkzeuge.
- **Invariante (`:222`):** Original-Quellen UNVERÄNDERT, „niemals Doku löschen".
- Offen: K-H.10 JPG-Export (User-Aktion), REV7-drawio.

## 2. `03_konzepte_saeule_a.md` (151 Z.) — **SUPERSEDED 2026-05-31** (`:3`)
Banner: überholter Planungsstand (axis-zentrische Restruktur F.2, Plugin-Prüfling-Modell, DLL-F15-Pipeline). SSoT = ce-Ledger + `20260531-e2e-abnahme-audit`. „Niemals löschen — nur Banner."
- **4-Ebenen-Strategie-Hierarchie** (`:35-40`): A `ISearchPagesStrategyPattern` (1/IFanout) → B `ISearchPagesStrategy` (N) → C `ISearchPageStrategy` (M) → D `IStrategyCommand` (K).
- **29 ICacheStrategy-Familien F1–F29** (`:50-80`), vollständige Tabelle mit Paper-Zuordnung (P01 ART … P33 VAMPIR).
- **Kern-Invariante (`:48`, `:104-106`):** Die 29 Familien sind **orthogonal** zu klassischen Familien (Trie/B+/Hybrid) — letztere sind nur „Lektüre-Gruppierungen".
- Hybrid-Konvention (`:88-94`): jede „hybride" Strategie wird in atomare Commands zerlegt und unter `HybridCompositionCommand` rekomponiert; atomare Commands sind einzeln testbar/permutierbar.
- PRT-ART-Mapping (`:125-136`): 2 Node-Typen, 4 Suchtypen, `ValueHandle::{Inline,External,ChainRef}`, 4+2 Allokator-Pools.

## 3. `04_konzepte_saeule_b.md` (158 Z.) — **SUPERSEDED 2026-05-31** (`:3`)
- **Architektur-Korrektur-Runde 3** (`:29-53`): KEINE CPU-spezifischen Klassen (`RyzenX3DProbe`, `IntelHybridProbe`, `X3DAwareFactory` …) — stattdessen generische `IPlatformProbe` + `IPlatformPropertyClassifier` mit Auto-Discovery. Mapping-Tabelle falsch→richtig `:45-52`.
- **Auto-Discovery-Pflichtkette 5 Schritte** (`:56-66`): Discover (CPUID/sysfs/hwloc) → Measure (Mikrobenchmark) → Classify (Properties) → Publish → Bind. Leitsatz: *„plattform-agnostisch im Code, plattform-konkret im Verhalten"*.
- **Block AO Production-Plattform** (`:74-89`): AMD Ryzen 9 9950X3D (asym. L3 96+32 MiB) + Intel i9-14900KS (8P+16E; Pflicht `cpu_core/*` vs `cpu_atom/*` perf-Counter trennen).
- 28 Säule-B-Concept-Klassen (`:101-113`), NUMA/TLB/HW-Counter/NVRAM/6-Flavor-RCU (`:120-124`), ~80 Heuristiken (`:128-132`).

## 4. `06_er_modell.md` (179 Z.) — **SUPERSEDED 2026-05-31** (`:3`)
- 5 Entitäten: `ExperimentRun` / `MeasurementRecord` / `DatasetMetadata` / `PermutationFlags` / `BuildArtefakt` (`:62-131`).
- **PermutationFlags = 9 Banken** je `uint64_t` (Page/Node/Traversal/ValueHandle/MemoryLayout/Allocator/Prefetch/Concurrency/Isa, `:108-118`) — ADR F10-K.
- Persistierung (`:147-157`): In-Memory (ADR F5 `InMemoryMeasurementBuffer`) → Binary Dump → CSV → LaTeX. Pipeline `binary_to_csv` → `csv_to_latex` → `build_thesis.sh`.
- Kardinalitäten `:136-141` (Run→Record 1:N; Build→Flags N:1).

## 5. `08_drawio_export.md` (162 Z.) — KEIN Superseded-Banner
- Tab-Struktur REV6 = 32 Tabs (`:8-25`), REV4-Trennung K01-K06 / U01-U06 / MX1 (`:27-30`).
- **Notations-Konvention hart** (`:62-81`): keine deutschen und keine ASCII-Anführungszeichen in drawio-value-Attributen (XML-Parser-Fehler); fester Edge-Style; Farbcode K=hellblau / U=hellgrün / MX=hellgelb.
- Status K-H (`:92-108`): K-H.1–K-H.X ✅ DONE, **K-H.10 JPG-Export ⏳ pending (USER-Aktion, drawio-CLI nötig)**. Total 45 Tabs.
- **Konsolidierungs-Strategie (`:110-114`):** 40 alte Tabs inhaltlich UNVERÄNDERT, nur Banner; neue Tabs tragen V31-Inhalt; Trace-Tab als Brücke.

## 6. `09_taxonomien.md` (106 Z.) — **SUPERSEDED 2026-05-31** (`:3`)
- Zwei orthogonale Taxonomien (`:13-18`): Cache-Strategien (29 F1-F29, Doc 11) ⊥ Algorithmus-Strategien (4-Ebenen + 17 Hybrid-Commands, Doc 12). **REV K3.3-Beschluss 2026-05-10.**
- 8 Hybrid-Auflösungen (`:30-39`), 17 HybridCompositionCommands (`:58-70`).
- **F15 = Kern-Forschungs-Ziel** (`:80`): Cross-Algorithmus-Permutationen (Trie-Page + B+-Layout + LOUDS-Encoding + Hot-Path-Heuristik) sind durch die Orthogonalität *architekturell vorgesehen*.
- **Lizenz-/NOTICE-Direktive II 2026-05-14 (`:88-91`), zitiert:** „Da wir alle Algorithmus-Bestandteile zerschneiden, entsteht für alle Permutations-Achsen ein neues Werk. Das gilt für alle Lizenztypen." → legitimiert die 22 V31-Adapter mit `COMDARE_HAVE_<X>`.

## 7. `10_schichten_modell_M.md` (296 Z., Stand 2026-05-18 + Nachträge 07-09/07-15)
Die konfliktreichste Datei — enthält drei übereinandergelegte Wahrheiten.
- **§0 KRITISCHE KORREKTUR AA.2** (`:10-50`): CEB orchestriert **BEIDE** ExecutionEngines parallel (EE-A = CacheEngine, EE-B = PRT-ART, gleichwertig); Command-Pattern zum Performance-Vergleich; CEB = Test-Treiber mit ICommand-Hierarchie. Erklärt §2.1 („CE = Werkzeug-Bibliothek") explizit zum **Design-Fehler** (`:33`).
- §1 Kernsatz User-verbatim 2026-05-18 (`:56`) — **bidirektional symmetrisch**: CE bindet Prüfling ein UND Prüfling nutzt CE zur Selbstoptimierung.
- §2 4-Subsystem-Modell (`:64-101`): messung_driver → CEB → CacheEngine ↔ Prüfling. §2.1 Rollen/Ownership `:105-110`; §4 CEB(Executable) vs CE(Library) `:192-202`.
- §5 **Phasen 1-7** (`:210-222`): DISCOVER/MEASURE/CLASSIFY/PUBLISH/BIND/EXECUTE/COMPARE; Owner-Tabelle; Phase 6 ist die einzige mit aktivem Prüfling.
- §6 Multi-Prüfling via `register_engine()` (`:228-240`).
- **§9 S↔E-KREUZ-MAP (autoritativ, Nachtrag 2026-07-09, `:269-280`):** S1↔E4, S2↔E3, S3↔E2 (verschoben: Library vs DLL), S4↔E1 (verschoben: Messobjekt vs Laufzeit-Mechanismus). Merksätze: S zählt 1→4, E zählt 4→1, **dieselbe physische Reihenfolge invers nummeriert**; Spur-S (S1–S9) ist ein DRITTER Scope; DD-A..DD-E und §13.9-Gate-E1/E2/E3 wieder andere „E"-Achsen.
- **Nachträge 2026-07-15 (`:288-296`) = Deprecation-Vermerke:**
  - **R6 (`:292`):** Laufzeit-Service-Injektion im Hot-Path (`lookup()` ruft `telemetry.notify_*`/`get_prefetch_strategy`/`get_heuristic_for`) ist **unzulässig** → compile-time-Komposition CRTP+Concept. Virtuelle `IExecutingEngine`/`ISearchEngine` im Hot-Path verboten.
  - **R5 (`:293`):** prt-art ist ein **SEPARATER Prüfling**, NICHT „ExecutionEngine B gleichwertig". Das EE-A/EE-B-Modell aus §0.1/§0.4 ist überholt; §2.1 „Werkzeug-Bibliothek" ist die *korrekte* Sicht — d.h. §0.3 hat das Richtige verworfen.
  - **R11 (`:294`):** `register_engine()`-Laufzeitmuster überholt → compile-time `PrueflingSlot`-Substitution in GENAU EINE Achse + 3-Stufen-Join (`pruefling_merge.hpp`).
  - **R4 (`:295`):** DISCOVER/CLASSIFY/PUBLISH sind **kanonisch nicht mehr vorgesehen**; CEB = zentrales XML-config-getriebenes C++-Experiment-Framework.
  - R7 (`:296`): §9 ist die kanonische Disambiguierungsstelle.

## 8. `12_queuing_topic_achsen_eigenschaften.md` (254 Z., V41.F.6.1 Pilot 2026-05-26)
- **2 Achsen mit Cartesian-Product** (`:13-19`): `axis_q1_queuing` (Buffer-Strategy, WAS) 4/13 Pilot · `axis_q2_queuing` (Flush-Policy, WANN) 3/5. Pilot 4×3=12, Vollausbau 13×5=65.
- **Einordnungs-Korrektur 2026-06-03 (`:21-30`):** `queuing` ist ein **Topic** = kein Interface/keine Gattung. Q1/Q2 sind **Pflicht-Achsen (Organe)** derselben Lebewesen-Unterklasse — **nicht optional**: ein nicht-pufferndes Lebewesen wählt `NoBuffer`/`LazyFlush`, es lässt die Achse NICHT weg (**Durchreich statt Weglassen**).
- Concepts + Pflicht-Properties (`:38-74`, `:116-139`): `topic_tag`/`axis_tag`/`family_id`, `is_thread_safe`, `is_bounded`, `ProgressGuarantee`, Mess-API `snapshot_t`/`observer_t` unter `STATISTICS=ON`.
- Edge-Cases als Invarianten (`:102-109`, `:156-161`): `BoundedRing{0}` wirft `std::invalid_argument`; `should_flush(fill, cap=0)` → NoFlush; 9 Buffer-Größen inkl. Nicht-Power-of-2.
- **Naming-Regel verbindlich** (`:226-229`): `axis_<ID>_<topic-name>/` (NICHT thema-name), Namespace `comdare::cache_engine::<topic>::axis_<ID>_<topic-name>`.
- Offen: **Cross-Constraints (`:184-196`) heute NICHT enforced** (Q-EPOCH+F-EAGER invalid; Q-COW+F-ADAPTIVE invalid; Q-NONE nur F-LAZY). Implementation via `mp_filter`.
- 81/81 Tests grün; TYPED_TEST skaliert automatisch (`:243-245`).

## 9. `16_E1_E4_KONSOLIDIERUNG_DOSSIER.md` (280 Z., **GENEHMIGT 2026-07-09**) — autoritative E-Konsolidierung
- **Quellen-Hierarchie bindend (`:17`):** Doc 30 §8.0 > IST-Ledger > e2e-Abnahme > Code > CE/34 > Einzel-Docs 15–33 > Thesis-Basis 00–14 (SUPERSEDED). `SUP/02_aktueller_master_REV7_7.md` mit Alt-Vokabular **3-Säulen/F1–F29/S1–S30/11-Bausteine/IExecutingEngine** = **Bruchlinie 1** (`:19`).
- **A.2 3-Ebenen-Anatomie** (`:23-36`): Gattung (3: SearchAlgorithm/Container/Graph) → Lebewesen-Unterklasse (5, Slots 19/15/11/13/7) → Achse=Organ (19, **keine optional**) → Sub-Achse (~279). `AdHocComposition<T0..T18>`, `static_assert sizeof...==19`, keine Defaults. `Lebewesen ≡ SearchAlgorithm`, EINE Hierarchie.
- **A.3 E1–E4-Maschinerie** (`:38-63`): E4 XML → E3 Permutations-B+-Baum pro Gattung (Gate-1: `binary_count()==∏ mp_size==PermutationEngine::count()==137.594.142.720.000`, nie materialisiert ~21 GB) → E2 Tier-Binaries compile-time (`COMDARE_DEFINE_ANATOMY_MODULE_ADHOC(<19 FQ>)` → SHARED-DLL) → E1 RC-Laufzeit (`ComdareResourceControlV1`, 5 Felder). **E0 = Querschnitt, NICHT Pipeline.** Zwei-Phasen-Op-Schleife PFLICHT (save→warmup→rollback→measure).
- **A.4 Mess-Architektur** (`:65-72`): 3 Dimensionen (Wall-Clock · `observe_all()→axis_stats[19][8]` · **Achsen-Vergleich gegen std::map entscheidet die Achsen-Güte, NICHT die Latenz**); 2 Pfade A/B; der Mess-„Visitor" ist **kein Visitor, sondern flacher memcpy-POD-Pull** `IObservableTier::tier_observe`; 3 orthogonale Profile BUILD ⊥ LASTPROFIL ⊥ COMPILE-RELEASE; PRT-ART-3-Stufen-Join + **Regel der abstrakt-leeren Achse**.
- **A.5 Der eine echte Defekt** (`:76`): `search_organ_`-Monolith **beschattet** node_type/memory_layout → Achsen-Differenzen teils **Apparat-Artefakt statt Forschungssignal** (mission-kritisch, #188).
- **B.1 Bruch-Chronik** (`:84-93`): 28.06. ORIGIN → 02.07. BRUCH 1 (Spur S/P ersetzt E) → 03.07. BRUCH 2 (§10 degradiert E0-E4) → 06.07. Namenskollision → 08.07. Manifestation (#31 als E2 gebaut).
- **B.2 Namenskollision + Auflösung** (`:98-111`): E1–E4 kanonisch behalten; **E-A..E-E → DD-A..DD-E umbenennen**; S1–S4 behalten + kreuz-mappen. I.2 (`:225-233`) präzisiert: die „E"-Kollision ist **VIERFACH** (+ §13.9-Gate-E1/E2/E3, + E2-Sidecar).
- **B.5 F7-Neufassung Kernsatz** (`:124`): **M = compile-time (E0) · W/Datasets = E4-XML + E1-Laufzeit / E3-Permutation (NICHT compile-time-statisch) · A/B/C × Micro/Makro/Gesamt = E4-Auswertung.** §54-T2-Nachtrag `:126` revidiert: Micro/Makro/Gesamt ist **Mess-Tooling-HAUPT-Achse** (Bau-Auffächerung `ceb:build:[a,b,c]`), nicht bloß Auswertung.
- Teil C Audit (`:134-141`): 13 ebenen-richtig · 8 teilweise · **1 schein-erledigt-ebenen-falsch (#31)**. Massen-Schein nicht belegt.
- Teil D (`:145-164`): #31-Fehlbau `workload_matrix.hpp:105` (36 Zellen compile-time, misst nichts); korrekte Verortung W→E4/E1, D→E3, M→E0; **G2 = forward `git revert` von `88738285`+`4d8aedce`, keine History-Rewrite**.
- Teil E Roadmap (`:170-181`), Teil F Direktiven/TABU (`:186-191`), Teil G Verifikation (`:197-201`), Teil H Freigabe (`:206-209`).
- **I.4 V32-Fork-Wahrheit** (`:249-257`): `comdare_experiment` (config_a/b/c) = **toter Code**; V32-Orchestrator **nicht verdrahtet** (`execute_messreihe:81-85` Stub); realer Pfad = viertes Ad-hoc-Format `<comdare_messreihen>` per Regex; Workload hartkodiert `main.cpp:483`. Doppeltes Gate R1/R2 = **User-GO nötig, kein Blind-Bau**.
- Nachträge 07-15 (`:265-274`): R1 Fork ÜBERFORMT durch unified-experiment-Modell (2 Registries + 1 Experiment-XML + v32→Strategy); R2 3-Stufen-Join = 3 XML-Phasen; **R9 (`:271`): „ABI-Major 3" ist stale → ABI-Major 4**.
- §59-Querverweis (`:280`): 3-Stufen-Join jetzt KERN — ① CE allein ② je Prüfling `replace` (alt. `merge`) ③ `fulljoin`; Ist-Code katalog-verdrahtet auf EINEN Prüfling/EINEN Slot.

## 10. `17_E4_XML_VOLLVISION_ROADMAP.md` (99 Z., Planungs-Dossier 2026-07-09)
- **User-Vision bindend (`:7`):** Die XML ist die **autoritative Bauanleitung des gesamten Versuchsaufbaus**; der CEB liest sie zu seiner Laufzeit und lässt Tier-Binaries kompilieren. Workload = eigene Bibliothek-Kategorie.
- **Zentraler Befund (`:11`):** #229-Maschinerie ist **~80% gebaut**, aber „eingesperrt im `tests/unit/thesis_tiere/`-Harness" und auf golden-320 begrenzt. → **kein Neubau, sondern Andocken + Entkoppeln + Auffüllen**.
- **B.1 drei getrennte Bau-/Mess-Systeme** (`:17-27`): System 1 `messung_driver` (lädt VORGEBAUTE Plugins, kein Compile), System 2 `ExperimentDriver` (ALT, 4-Faktoren-Kreuz, `cmake` via `std::system`, Regex-Parser), **System 3 = der echte 19-Achsen-Anatomie-Bau (existiert, golden-getestet, TEST-ONLY)** mit 7-gliedriger Kette (`m3v2_study.profile.xml` → `parse_thesis_profile` → `build_axis_levels` → `StaticBinaryView` → `BuildOrchestrator::provision_all` → `adhoc_emitter` → `run_profile`).
- **Drei Blocker für #229** (`:29-32`): (1) kein Produktiv-App dockt an (=#230), (2) Achsen-Limits **hartkodiert** `CatalogAxes<4,4,5,4>=320`, (3) String→Typ nur pilot-abgedeckt.
- B.2 (`:34-38`): Soll 13-Framework-Katalog → 14 kanonische Lastprofile LP01–LP14; Ist nur YCSB A–F, **0/14 LP**, 2/~8 Loader, Dataset-Parser-Bruch.
- B.3 (`:40-45`): „Mess-Achse" **dreifach belegt**; `<measurement_categories>`-XML-Element = **0 Treffer**.
- C.1–C.3 Architektur-Entscheidungen zur Bestätigung (`:49-51`): Workload-Bibliothek als **Laufzeit**-Bibliothek in `measurement-all`, NICHT compile-time-Insel (= der revertierte #31-Fehlbau).
- Roadmap 8 Phasen (`:55-64`), Sofort-Block Phase 1+2 (`:66`).
- **Freeze aufgehoben** (`:72`): main.cpp-V31.F-Freeze für E4-XML-Verdrahtung per User-GO 09.07.
- Nachträge (`:82-93`): R9 (in-Doc-Phasennummern-Diskrepanz C.3:51 „Phase 3" vs Tabelle :60 „Phase 4"); R1 m3v2 additiv **deprecaten** zugunsten 2-Registry-Architektur; R11 fehlende prt-art-Phase; **R10 (`:92`): Doc erfasst nur Mess-Modus 2 — Wall-Clock, std::map-Vergleich und xml→pdf-Kette fehlen doc-weit.**

## 11. `18_MESS_METHODIK_ACHSEN_OPTIMIERUNG_KONSOLIDIERT.md` (156 Z., 2026-07-09)
- **Leitsatz (`:9`):** Mess-Achsen und ihre Effekte werden **erforscht, nicht erfunden**. Ziel = **mehrdimensionale statische Heuristik-Kurven**, nicht Rohmessung.
- **A.1 ZWEI distinkte Achsen-Systeme (bindend, `:19-28`):** Organ-Achsen (Tier-Binary, „Organe", ~19, permutierbar, Wurzel `AdHocComposition`, E2/E3) vs **System-Achsen (Mess-System, „Blut", durchdringend, NICHT Gattungen, nicht austauschbar, IMMER präsent bei Messung, eigene abstrakte Wurzel `SystemAxis`/`IMeasurementSource`, E0-Querschnitt, NICHT im Baum)**.
- A.2 (`:34-38`): jede Organ-Achse hat eine Optimierungs-Eigenschaft Min/Max einer messbaren Größe — per deep research zu ermitteln. **Ersetzt die #221-„Effekt-Erfindung".**
- A.3 (`:42`): Wirkungsweise je Achse = **GoF-Strategy** hinter dem System-Achsen-Observer-Interface, zero-cost compile-time.
- A.5 (`:50`): E4→E0 strikt interface-orientiert.
- **B.1/B.2 = Lehren aus zwei Reverts als bindende Design-Constraints** (`:56-70`): C1 super-Sub-Build (~15 Adapter-Targets + `COMDARE_FACADE_PERM_INCLUDES`), C2 Harness-Sicherungen (`platform_override`, `min_free_gb`, 0-Profile-Hard-Abort, top-level try/catch); **8 CONFIRMED Mess-Bugs**: Budget nur beim `insert` gaten nie in `rebuild_`; `insert()`-Rückgabe prüfen; DEG in benannte Schema-Spalte routen (sonst nie in der CSV); pro Mess-Punkt echtes Reset (kein `if(X!=0)`-Latch); kein Signal-Cross-Talk; `restore_statistics` darf probe-Counter nicht nullen; **honest-0 statt faken**; vollständige Kopplung oder ehrlicher „n/a".
- **B.3 (`:73`):** lokale ctest + golden-Roundtrip sind **unzureichend** (nur Happy-Path). Pflicht: adversarialer max-Effort-code-review + Edge-Case-Tests (reused-Tier-Reset, budget<live-set, Rollback-Erhalt, **CSV-Named-Column-Sichtbarkeit statt in-process-POD**, super-Sub-Build).
- Teil C Roadmap M0→M1→M2→2′→1′→E4′ (`:79-89`).
- **Teil F M0-BEFUND (`:110-131`):** genau **5 RC-steuerbare Achsen** (T7 prefetch verdrahtet+verifiziert; T6 allocator, T8 concurrency, T1 cache_traversal, T11 value_handle = Setter fehlen); **14 honest-0-Achsen** (T0,T2,T3,T4,T5,T9,T10,T12–T18) — **kein Defekt, nicht verdrahten**; F.3: die Autotuning-Kurve existiert prototypisch als `cacheline_policy_selector.hpp`; **F.4: T6/T18/T5 sind multi-objektiv → Pareto-Punkt, kein Einzelextremum; Objective explizit machen.**
- Nachträge (`:143-150`): R9 Registry-`mp_list` als TABU ergänzen (golden-320 = `mp_take_c<Enabled,4>` = 4×4×5×4); R8 honest-100% Katalog-DLL statt `PrtArtHashBackend`-Surrogat; R10 die 3 kanonischen Mess-Modi.

## 12. `19_SCHICHTEN_FERTIGSTELLUNG_E4_E1_INTERFACE_VERTRAEGE.md` (90 Z., 2026-07-09 abends)
- **User-Direktive (`:3`):** *„jede dieser Schichten mit sauberen Interfaces nacheinander separat fertigstellen und getrennt testen können. Das System ist für multiple Ebenen gleichzeitig zu groß."* Fehlerklasse beider Reverts: **Increments, die mehrere E-Ebenen gleichzeitig berührten** (`:7`).
- **Design-Quelle (`:9`):** die Diplomarbeit-LaTeX ist die Quelle der Idee jeder Implementierung; jeder Increment zitiert Thesis-Anker.
- **Teil A Interface-Verträge-Tabelle (`:15-21`)** — die zentrale Vertrags-Landkarte:
  - E4→E3: XML → `ThesisProfile` → `AxisLevel[]`; **4 RC-POD-Felder ohne XML-Eingang**.
  - E3→E2: `StaticBinaryView`/binary_id → 1 DLL je Permutation; **Limits hartkodiert**.
  - E2→E1: `IResourceControllableTier` + POD `ComdareResourceControlV1` (5 Felder); **Tier-Seite konsumiert nur `prefetch_distance`**, 4 Felder = Phantom; **Vertrag VOR #221 EINFRIEREN**.
  - E1→E4 Rückkanal: `tier_observe`, `kV3AxisSchema` (**ABI-Major 4**) → WIDE-CSV → csv-to-latex.
  - M: Wurzel fehlt.
- **Bindend (`:23`):** System-Achsen (M) berühren NIE binary_id/E3-Permutation; Organ-Achsen-Effekte nie mit Mess-Instrumenten vermischen.
- Teil B DoD je Schicht + **Contract-Tests gegen Fakes der Nachbar-Ebene** (`:27-34`); compile-time-Fakes via Templates/Concepts, kein Runtime-Switch.
- **Teil D Sequenz bindend (`:51`): E4 → E3 → E2 → M → E1 → [CMD-2/#215/#156] → E0.** Konfliktauflösung gegen ORIGIN-§14 (`:53`) und gegen Dossier 18 Teil C (`:54`); **Vorrang-Regel: neueste USER-Aussage gewinnt** (`:55`).
- **Teil G Betriebsregime-Vision (`:62-75`), bindend:** E4 = abstrakteste Ebene = Anwender-Sicht; E1/E0 = präziseste Detailimplementierung. **Vier Modi: Messmodus → Auswertungsmodus (Workload-CLUSTER, Cluster-Verfahren per deep research) → Arbeitsmodus (Tier-Binaries hot im RAM, Hot-Switch der Binary unter der Haube am ABI-stabilen Interface) → Hybrid-Modus (10.07., DAS ZIEL DER DIPLOMARBEIT).** Kernstück: **Die Heuristik-Optimierungs-Achse ist eine EIGENE SYSTEMACHSE**, übernimmt per Metaprogrammierung die Gattung ihrer Tier-Binaries, hat ein **Arbeits-Dock**, wird selbst zu einer Tier-Binary kompiliert und reicht Befehle per Metaprogrammierungs-Command-Pattern an ihre statisch zugewiesenen echten Tier-Binaries weiter.
- **Ziel-Klarstellung (`:73`):** beste Rekombination UND bestes Einzel-Binary bestimmen (besonders **Cache-Line-Awareness**), beide **produktionsfähig bereitstellen**; alle 4 Phasen müssen in E4 **automatisch dokumentiert** werden (CSV→LaTeX→PDF-Kette ausdehnen).
- **Architektur-Konsequenz (`:75`):** Hot-Switch nur an der **ABI-Grenze** (DLL-Wechsel) — **kein Runtime-Switch IM Tier**; das ist der einzige erlaubte dynamische Ladepunkt.
- Nachträge (`:87-90`): R1 zwei Registries; R2 EINE 3-Phasen-Experiment-XML (Companion-Test `test_v32_messreihe_antrieb`); **R4: CEB baut Tier-Binaries C++-orchestriert zur Laufzeit, NICHT via CMake (Performance)**; R10 xml→pdf-Kette 01–09 + honest-empty `\InputIfFileExists`.

## 13. `20260717-konstruktionslogik-durchdringung-F12III-DESIGN-VORLAGE.md` (221 Z., 2026-07-17)
Design-Grundlage für **EINEN koordinierten ABI-Bruch 4→5**.
- **TABU-Hinweis (`:8`):** ABI-Major 4→5 und Golden-Byte-Ordnung sind TABU; Vollzug nur mit **koordiniertem 4→5-GO**.
- §1 (`:16-27`): vier Struktur-Verschiebungen brechen dieselbe ABI-Grenze → gemeinsam: **F12(iii)** Telemetrie als CEB-System-Achse · **F1b** Set-Ebene-1-Promotion · **F2** `ISetTier`+`SetDock` · **#37** Scheduling als compile-time System-Achse (ersetzt verwaiste Runtime-vtable `ISchedulingStrategy`, `:90-96`).
- **§2 mit eingebauter Selbstkorrektur (`:60-71`):** der Absatz war selbst-widersprüchlich („behält `[19][8]`" vs „POD-Layout-Bruch"); **maßgeblich ist die Korrektur**: `axis_stats[18][8]`+`seg_ns[18]`, `kV3AxisCount==18`, Version 6, **sizeof 1416→1344 (Δ −72)**; T10 = value_handle; telemetry wandert ins H-10-Sidecar.
- **§4 Grenz-Landkarte (`:100-122`):** **Prüf-Dock ist KEINE ABI-Grenze.** ABI-Grenze = gattungs-eigenes Antriebs-Sub-Interface (vtable-stabil) + flacher POD (memcpy-fähig). 5 Grenzen: Modul-Symbol (4 Pflicht-Symbole + Magic + Major) · Antrieb (`IDriveableTier` immer, dann `IObservableTier`/`IScannableTier`/`ISetTier`) · Settings (`ComdareResourceControlV1`, POD, 6× uint64) · Ergebnis (`ComdareTierObserverSnapshot`) · Metadaten (H-10-Sidecar). **Frei umbaubar:** `IPruefDock`, `AnatomyPermutationDriver`, `BuildOrchestrator`, `registry_to_axis_levels`, gesamte CRTP+Concept-Kompositionslogik.
- **§5 golden zerlegt (`:125-158`):** was `golden_fullpilot_320` exakt ist (`CatalogAxes<4,4,5,4>`, 4 variiert / 15 gepinnt, alle in EINER Gattung, jeder Pfad fix `isa=isa_amd64` + `telemetry=telemetry_leaf_only_counter`); drei orthogonale Brüche; **Regenerierungs-Plan messdaten-erhaltend**: alte Fixtures + Mess-CSV/PDF als `…_abi4` **unangetastet einfrieren**, Konventions-**Erweiterung statt Ersatz**, EINMALIGE Neu-Materialisierung je Gattung, Gate umhängen.
- §6 Kopf-Frameworks je Gattung (`:162-185`): nur SearchAlgorithm fertig; **View bleibt UNTER Container** (kein eigenes Ebene-1), Zoologie „Pflanze"; Doktrin: jede Gattung compile-time-monomorphisiert, **vtable existiert nur an der Modul-ABI-Grenze, 1× je Modul kalt via `dynamic_cast`**.
- §7 Increment-Schnitt (`:189-221`): **INC-0** DLL-Load-Fix Option B (ABI-4-kompatibel, kein GO nötig, sofort autonom) → **INC-1** System-Achsen-Reflektion abspalten + H-7-Compiler-Kopplung + H-10-Sidecar → **INC-2** koordinierter Bruch (braucht GO) → **INC-3** Golden-Neu-Materialisierung → **INC-4** restliche Gattungs-Frameworks (V42). Jeder Increment endet CI-grün + messfähig; nur punktuelle Refactorings, **kein Parallelstruktur-Bau**.

## 14. `20260717-xml-ci-automatisierung-ERKLAERUNG-XML-CI-AUTOMATISIERUNG.md` (241 Z.)
- **Kernbotschaft (`:11`):** Die prod2-Rötung ist **kein** XML→CI-Generierungs-Versagen (die gibt es nicht) und **kein** Infra-Block, sondern ein **latenter CMake-Quoting-Fallstrick** in handgeschriebenem CMake.
- **§1 drei Codegen-Klassen (`:19-74`):** Klasse A (XML als Input: `permutation_axes.xml`→codegen_cli nur bei `-DCOMDARE_BUILD_PERMUTATIONS=ON` default OFF; **`m3v2_study.profile.xml`→`catalog_codegen.cmake` = das EINZIGE echte XML→Header-Build-Codegen-Vorbild**), Klasse B (kein XML, Typraum-Enumeration, per Design nicht-fatal WARNING+SKIP), Klasse C (XML als **Output** + Roundtrip-Gate `test_axis_registry_roundtrip` byte-diff). **Es gibt keinen Pfeil von irgendeiner XML zur `.gitlab-ci.yml`** (`:74`).
- §2 CI-Struktur (`:80-109`): CE+SUPER inkludieren dasselbe Template `comdare/cluster/ci-templates@development`; **SUPER = Orchestrator** mit `strategy:depend`; `measure:*` rules-gated **INERT** → **CI-Grün ≠ Messung**. **`allow_failure: true` nur bei `build:arm64-smoke` (CE:124) und `is_original:relock` (CE:360)** — alles andere HART.
- **§2.3 Runner-Roulette (`:105-109`):** nur `pmc:amd`/`pmc:intel` sind ISA-gepinnt; alle anderen `[baremetal]`-Jobs matchen **beide** Runner nicht-deterministisch; jeder Job zieht `tests/unit/CMakeLists.txt` komplett ins Configure → ein Configure-Defekt trifft **alle** identisch.
- §3 Wurzel (`:117-152`): `check_cxx_source_runs` liefert bei rc≠0 **LEEREN String** (nicht FALSE); ungequotetes `${COMDARE_HOST_RUNS_AVX512F}` kollabiert → 3-Parameter-Funktion bekommt 2 Args → `Function invoked with incorrect arguments`. prod1 (Zen5) grün / prod2 (i9-14900KS, AVX-512 **fused off**) rot — **derselbe Quellcode, nur anderer Host**. AVX2-Zeilen haben denselben latenten Bug, feuern nur nie.
- §3.3 (`:154-160`): Bau-INC-2c ist **nicht** Ursache (Commit 8175c802 vom 10.07.); die vorige Pipeline starb an echtem Infra-Block.
- **§3.5 Fix (`:168-176`):** 4 Zeilen quoten (`:3301/:3307/:3332/:3335`); golden-neutral, kein ABI-Bruch, **keine CT→RT-Degradierung**.
- **§4 (`:180-210`): XML→CI-Generierung ist eindeutig SOLL.** Soll-Architektur F5-Planer-Codegen: `comdare_experiment_planner` → `ExperimentPlanDirector::construct(IPlanBuilder&)` (EIN Director, EIN Walk, Template Method je PhaseStep, CoR `selection_filter_chain`) → **CMakeGraphBuilder + CiYamlBuilder aus DEMSELBEN Walk** = Synchronie strukturell garantiert. grep-verifiziert **0 Treffer** = nicht gebaut. **Der Fix zieht F5 NICHT vor.**
- **§5.1 verletzte Anforderungen (`:218-226`):** honest-100%/kein Schein-Grün (grünes prod1 bei rotem prod2 = verbotenes Schein-Grün, Intel-Hälfte von FF0 unbewiesen); CI UND standalone messfähig; Verifikations-Kadenz; **Dual-Verifikations-Bikonditional**; 5 HARTE Gates rot; AMD/Intel-Doktrin nicht erfüllt für Gate-Jobs.
- **§5.2 Modus-a-Trennschnitt (`:228`):** Modus a gilt **NUR** bei baremetal-Runner-Block (Infra stuck/timeout). Reproduzierbarer Configure-Defekt → **Modus a greift NICHT** → Fix, nicht Deferral.
- §5.3 Schritte 1–4 (`:233-240`); Merksatz `:242`.

## 15. `20260719-achsen-nachschlagewerk-INC2D-DELTA-NACHTRAG.md` (229 Z.) — **die aktuellste Zahlen-Wahrheit**
- Additiv zum NW1-Original (INC-2c, 18 Slots, ABI-5); **bei Widerspruch gilt der Nachtrag** (`:7`). Live verifiziert gegen ce HEAD `a9c433d0`.
- **(B) Kanon-Zählung (`:21-31`):** System-Konfig **6→7 Haupt** (+3 Wurzeln; NEU `TargetIsaSystemAxis`, ersetzt nichts) · Organ **18→17** (T0..T16) · Gattung **3/5 unverändert** · Genus-Slots **17-11-13-9-5** (SA/Adapter/Set/Sequence/View) · Mess-Dimensionen 3 · **Mess-Kategorien 16** · System-Mess-Kollektoren 3 · **Observer-POD 17×8, sizeof 1272, Version 7, ABI-6, Magic `.A6.`** · Build-Schicht 7→9.
- C.1 (`:47-56`): drei Bau-Treiber jetzt (Erweiterungshardware/simd, Compiler opt_level/atomic128, Target-ISA); **flache `ExtensionHardwareSystemAxis` DEPRECATED (F-SIMD)**, aktiver Familien-Knoten `extension_hardware` **FEHLT** → `SimdSubAxis::parent_axis_label()` zeigt auf verwaisten Knoten → **Audit G2/E-4 OFFEN**. Sidecar-Suffix-Kette IST: `+ext=+cxx=+opt=+ceb=<maj>.<min>[+target=]`, `+opt=` **immer** emittiert, Default O3.
- C.2 (`:58-89`): **Slot-Shift** T0–T10 unverändert, alter T11 (isa) entfernt, alle ≥T12 um −1. Vollständige neue Slot-Tabelle mit golden-Faktoren (4/1/1/1/4/5/1/4/1/1/1/1/1/1/1/1/1). Varianten-Summe 127→**123 Strategien**.
- C.3 (`:91-103`): stale `k*SlotCount`-Konstanten (15/11/7/13) bestehen fort, **Diff jetzt +2 (telemetry+isa)**; aktiver stale `static_assert` in `test_d9_set.cpp:38`; **Audit L4/G8 OFFEN**. Belastbar NUR struct-internes `slot_count`.
- C.5/C.7 (`:122`, `:147-149`): Registry-XML seit `a9c433d0` auf 17 regeneriert → **XML = Ist = Code**; string-ID-System **kanonisch**, numerische IDs + GROSS-Aliasse = **Legacy, speisen NICHTS**.
- **C.6 (`:132`) NEW-GOLDEN-ALL-AXES:** `FullSourceCatalog = CatalogAxes<2,…,2> = 2^17 = 131.072` (Referenz, lazy, **NIE materialisiert**); alte 320-Semantik heißt jetzt **`golden_320_catalog`**; TABU-Objekt umbenannt; NEU TABU-artig **`kNewGolden131072Crc64 = 0xF1C1F26A1232073B`**.
- **C.7 Zähl-Fallen (`:143-152`):** Merksatz „**16 vs 17 vs 8** NIE verwechseln" (Kategorien / Observer-Achsen / Feld-Slots); Doppel-Shift 19→18→17 mit fortbestehenden stale „19"-Kommentaren; **axes26-T-Nummern ≠ Slot-T-Nummern**; Falle (I) verschärft: `all_axes_binary_count()` multipliziert `T10_telemetry` UND `T12_isa` mit → **Matrix-, keine binary_id-Zählung**; Rename→`all_axes_matrix_count` = Audit V7/P4 OFFEN.
- (D) Neue Mechaniken (`:158-171`): **`algo_version` je Organ-Variante Concept-erzwungen** (#50) + Weiterleitung in exakt 11 `Observable*`-Hüllen; `axis_variant_version_table`/`compose_algo_signature`; **`perm.algos`-Sidecar strikt getrennt von `.version`**; **#51 artifact_cache** (MinIO + measure-drop, **inert-by-default**, env-getrieben — Env-Variablen-Namen `COMDARE_MINIO_*`/`COMDARE_MEASUREMENT_DROP_URL`, Credentials via `MC_HOST_<alias>`); `+ceb=`-Sidecar; `all_axes_golden.profile.xml` (Materialisierung OFFEN, #49 nicht fertig); CRC64-Anker.
- **(E) Planer-/Resolver-Modell (`:174-188`):** §27 Registry = **ANGEBOT**, Anwender-XML = **ANZEIGE**, dazwischen **Resolve/Link-Stufe (.pom-Modell)**; unregistriert = **harter Validierungsfehler**; Andockpunkt `validate_profile.hpp`, **KEIN Parallel-Validator**. §28: **DREI art-spezifische Registries** (Organ existiert; **System-Registry und Mess-Registry fehlen als XML**). **Planer-Kopf ist LÜCKE** (kein benanntes Executable; imperative opt×simd-Schleife = heutiges Dock).
- (G) Adversariale Verifikation (`:210-229`): 94 Zeilen geprüft, 7 korrigiert; Register-E-1/E-2 als **stale widerlegt**; **`static_assert(sizeof==1272)` fehlt noch = Quick-Win L3 offen**.

## 16. `20260719-simd-flag-signaturen-REFERENZ.md` (219 Z.)
Quellen-belegtes Referenzdokument, live gegen prod1 verifiziert.
- **§0 Unterstrich-Falle (`:10-18`):** cpuinfo-Namen sind **nicht** einheitlich — `avx512vbmi` OHNE, `avx512_vbmi2` MIT Unterstrich. Merkregel + vollständige Zweiteilung. Wer per String parst, muss das exakt übernehmen.
- §1 vollständige AVX-512-Subset-Tabelle mit CPUID-Bit / cpuinfo / GCC-Flag / Fähigkeit (`:26-45`); EVEX/VEX-Begleiter GFNI/VAES/VPCLMULQDQ (`:50-54`).
- §2 AVX/AVX2/FMA/F16C + skalare Begleiter; **Falle: LZCNT zeigt Linux als `abm`** (`:76`); 256-bit-VEX-Neuzugänge AVX-VNNI (`:81`).
- §3 SSE-Historie; **`sse3` heißt in cpuinfo `pni`** (`:96`); „AVX128" = VEX.128-Formen, kein eigenes Flag (`:102`).
- **§4 Cluster-Matrix (`:108-123`):** prod1 Zen 5 = VOLLES AVX-512 mit nativem 512-bit-Datenpfad, **kein Frequenz-Malus**; prod2 i9-14900KS = **fused off**; Odroid-H4 Gracemont = keins. **Der einzige AVX-512-Träger im Cluster ist prod1** → prod2/Odroid brauchen 256-bit-VEX-Rückfallpfad.
- §5 Sinnhaftigkeits-Matrix Organ-Achse ↔ Flag-Klasse mit Konfidenz-Markierung [solide]/[spekulativ] (`:131-142`); **prefetch-Achse ist SIMD-orthogonal** („nicht anwendbar"); VL ist Querschnitt-Enabler.
- **§6 Deklarations-Format (`:148-197`):** zwei getrennte Belange — (a) Maschinen-Signatur 1:1 aus cpuinfo, (b) Organ-Anforderung im `<values>`-ANGEBOT-Stil mit `required="all"` (hart, sonst Variante fällt weg) / `optional` (schaltet schnelleren Pfad frei, nicht bau-verhindernd). Jedes `<flag>` trägt **beide** Namen (`cpuinfo=` + `gcc=`). cpuinfo-Flag ist bereits OS-enabled → **keine separate XCR0-Prüfung nötig**. Zukunft: AVX10 additiv als `<isa-level>`.

## 17. `2026-07-20-cache-engine-architektur-in-eigenen-worten.md` (209 Z.) — **die aktuellste Gesamtsicht**
Terminologie nach §54-T1..T7; **bei Konflikt mit älterem Vokabular gilt dieses Dokument bzw. §54/§55** (`:3`); der **UPDATE-Abschnitt 2026-07-22 schlägt die Abschnitte 1–17** (`:5`).
- §1 (`:11-13`): „Cache-Engine" führt in die Irre — das Artefakt ist ein **Experiment-System, das Experiment IST die XML**. Raum ~10^14, nie materialisiert. Idealziel #229.
- **§2 dreistufige Kette + Hybrid (`:19-29`):** Planer (Mess) → CEB (System) → Tier-Binary (Organ) → Hybrid-Binary (4. Glied, **Abgabe-Pflicht**). **Planer existiert als Executable noch nicht — der größte offene Bau-Block.**
- **§3 Haupt vs. Unter (`:33-42`):** ein Prinzip an allen drei Vertragspunkten — **Haupt = compile-time-statisch (eigenes Binary + Stempel), Unter = dynamisch, an die nächste Stufe delegiert.** Vollständige Tabelle.
- **§4 (`:46-51`):** Es gibt **KEINE „Achsen-Gattungen"**. Achsen sind nach TYP organisiert: `AxisKind = {organ, system_measurement, system_config}`, **kein `genus`-Enumerator** (literal bestätigt). **„Gattung" bezeichnet ausschließlich das Tier-Binary-INTERFACE.** Die zwei Ebenen dürfen nie vermischt werden.
- §5 (`:55`): **Permutations-Baum existiert je Achsen-TYP** (Organ-/System-/Mess-Baum); Zerlege-Achse ist `AxisKind`, nicht die Gattung.
- **§6 (`:61-67`):** einkompilierter Achsen-Satz = freigegebene System-Achsen ∪ 17 Organ-Achsen, alle gestempelt; **`binary_id` = 17-Organ-Kern**, System-Achsen im build_version-Sidecar → binary_id bleibt host-portabel. **Zwei Stempel-Ebenen (§57):** CEB = Mess; Tier = System × Organ. §58: Planer 1 Stempel `X.Y.Z`; CEB = Array je Mess-Haupt-Algorithmus; Tier = **zwei separate Arrays**; **nur Haupt-Achsen werden gestempelt, Unter-Achsen fließen ungestempelt durch**; erst die **Mess-CSV trägt den voll-permutativen Stempel**. Freigabe-Prinzip Organ ≤ System (Huge-Pages-Beispiel).
- §7 (`:73-78`): **Meta-Meta-Achsen** — statische Hardware-Haupt-Achse als **Manager** über ein statisches Achsen-ARRAY; Freigabe per **Command-Pattern**; **zweischichtige Kern-Permutation (Existenz an/aus + Wert)**, Existenz-Wahl compile-time; **Achsen-Zahl wächst dynamisch je Maschine**. Stand: erst EIN Familien-Knoten (SIMD) — **Lücke, kein Verstoß**.
- §8 (`:82-90`): die 3 Achsen-Typen im Detail; **Konformitäts-Residue:** `plan_legend.hpp` fächert `[a,b,c]` heute aus `measurement_categories` statt aus dem Tooling auf (§47/S4-Umbau).
- **§9 Legenden-Kette (`:94-100`):** `ceb:build:[a,b,c]` (Mess) / `tier:build:[d,e,f][g,h,i]:chunk<k>` (System × Organ) / `measure:[a,b,c][d,e,f][g,h,i]` **`when: manual`, gegatet, Mess-Exklusivität (nur eine CEB misst gleichzeitig, Bau darf parallel)**. **Ist-Code-Regress: `plan_legend.hpp:109` emittiert noch `[a,b,c][d,e,f]`** → GO-pflichtiger TODO.
- §10 (`:106-109`): SearchAlgorithm voll (17 Achsen, 9 real getrieben, 8 Schichten); Set/Sequence/Adapter/View = Skelette (je 1 Organ). **Cross-Genus-JOIN typ-unmöglich**, aber **Cross-Genus-Komposition-als-Sub-Organ über gemeinsames `OrganConcept` erlaubt**. Locking/Concurrency = echte offene Achse (S-7).
- §11 (`:113-117`): 3 Dimensionen, 2 Pfade, 3 orthogonale Profile; **Fehler nie als Nullen — „failed" + Log**; zwei Auswertungs-**Views** (Referenz-vs-Prüfling / Build-über-Build-Regression Welch-t + Holm); **binary_id-Reinheit tragend** (Tags/Compiler/ISA/OS nur Ordner/Sidecar/Spalten).
- **§12 (`:121-123`):** **golden N = 2^17 = 131072 = der einzige legitime Ganz-System-Beweis** (CRC64 `0xF1C1F26A1232073B`), **new-golden ist Bau-Pflicht**; **golden-320 ist nur eine Byte-Wache** (13/17 gepinnt). Max-Kontrast-Selektion = GO-pflichtiger Fork; 4 Sweep-Stützpunkte {2^14,2^17,2^20,2^23}; Voll-Messlauf mehrtägig, **hart USER-GO-gegated**.
- §13 (`:127-134`): Hybrid-Binary, Break-Even-Splines, 3 Mechaniken; **Paper-/SOTA müssen real gemessen werden (nie als Spiegel)**; CoR-Filterkette auf dem Resolver.
- **§14 Metaprogrammierungs-Doktrin (`:138`):** alles auf dem Hot-Path compile-time, **kein vtable, kein Runtime-Switch, kein `std::variant`** — **eine einzige eng begrenzte Ausnahme** im Hybrid (variant nur als dynamischer Träger abweichender Unter-Prüf-Dock-Verträge, per Abstract-Factory; Haupt-Observer-Kommunikation bleibt statisch). Nur benannte Lehrbuch-Patterns. **Fehlerklassen sind Pflicht** über alle Achsen→Unter-Achsen→Algorithmen.
- **§15 Storage (`:142`):** **asynchron** in MinIO: Planer-Binary, CEBs, Tier-Binaries, CSV-Messergebnisse. **git-Push und Mess-Rückschrieb-Sink bleiben synchron/blockierend** (Storage-Naht-Doktrin: I/O-Contention verfälscht Messwerte). Ebene B = dev-MinIO, Ebene C = prod-NFS. **Allokator-Messung muss isoliert sein — DLL linkt ihren Allokator selbst** (Host-Export-Ansatz verworfen).
- §17 **DER KERN §59 (`:150-169`):** **Default = ALLES messen; die XML wirkt als negatives Blacklisting.** Drei Mess-Stufen: ① CE allein ② je Prüfling Default `replace` (alt. `merge`) ③ kombiniert `fulljoin`. XML steuert Messmodi, per-Achse merge/replace, *welcher* Prüfling (`identity="self"` = `"CacheEngine"`), per-Achse Algorithmus-Whitelist, `<template>` mit `restrict`/`extend` (**Obergrenze bleibt das Registry-ANGEBOT**). **Keine neue Maschine, sondern Verallgemeinerung** — `pruefling_merge.hpp` `MergeAxis` existiert, ist nur katalog-verdrahtet auf `prt_art`/`path_compression`. **Dritter Tier-Stempel = Merge-Kombination**; **ce-only-golden bleibt byte-identisch** (Merges = rein additiver id-Satz).
- **UPDATE 2026-07-22 (`:173-203`):** **U2/§61** — Debug = Multi-Maschine parallel bauen+messen; Messung = parallel bauen, **sequentiell messen** (sequentiell heißt IMMER nur das Messen, nie der Bau); Release = ohne Mess-Einrichtung + Wallclock-Beweis; Modi bauen **stufenweise** aufeinander auf; **Debug ist Dual-Compile** (parallel cmake-Debug UND -Release, getestet nur mit Debug, nur Release fließt weiter); Reuse-Schlüssel = **`+bt` = cmake-Compile-Typ, nie der Modus**; **`<run_methodology>` exactly-one, Validator hart auf beiden Ausführungspfaden**.
  **U3/§62** — **Der Planer ist anspruchslos**: jede Maschine baut denselben Planer gegen die **eine, für alle identische XML**; **keine Runner-Tag-Vorfilterung** (amd/intel-Lanes = Interim); fehlende System-Achsen → **Warnungen statt stiller Filterung**; Koordination ausschließlich über **MinIO-Cache**: lockbare Sync-Datei mit 3-Stufen-Dedup, Batch-Reservierungen als Versprechen mit **Release-Pflicht** + Fortschritts-Testat + Lease/Timeout; **live Cache-Sync = Betriebs-Voraussetzung, keine Optimierung**. Vierter Modus **COMPARE**; **CI erst fertig, wenn die XML auf jeder gewünschten Maschine ausgewertet wurde**. **Replay ist schichtweise gekeyt** (`[a,b,c]`→CEB, `[d,e,f]`→Tier, Messwerte `[d,e,f]×[g,h,i]` **plus Hardware-Identität**), **Sharing dagegen rein stempel-gekeyt — zwei verschiedene Schlüssel**. Zwei **neue statische Haupt-System-Achsen**: RAM-Frequenz+CAS-Latenz (CL×2000/MT-Rate) und exakte CPU-Fabrikation (libcpuid/cpu_features/decode-dimms, #49). **Batch-Job-Prinzip: Job-Anzahl O(konstant), nie O(Binaries)**; Bau CEB-intern als Runtime-Batch; **GTest-Prüfstand je gebautem Tier am Prüfdock vor der Messung**; Planer instrumentiert die CEB per XML.

## 18. `20_HEURISTIK_MESSKURVEN_TYPSYSTEM_UND_FILTERKETTE.md` (150 Z., User-Vision 10.07.)
- **A Monolith-Doktrin (`:11-15`):** cache-engine wird als **Monolith fertiggestellt**; Zergliederung in die comdare-Matrix ist ein EIGENER, späterer Schritt; **kein Increment darf die Monolith-Fertigstellung an Modul-Grenzen aufhalten.**
- **B Messkurven-Typsystem wörtlich (`:22-28`):** `tree<axis compile/dynamic, map<workload-framework, map<workload-type, map<workload-size, map<operation_type, map<axis_observer_type, tuple<observer_special_compare_property_type, time>>>>>>>`. Ergebnis = **multidimensionale Custom-Datenbank**. Kardinalitäts-Auftrag: in Klassen und Hierarchien einteilen (`:37-39`).
- **C (`:44-45`):** Filterkette = **Chain of Responsibility (GoF), strikt im CacheEngineBuilder-Bereich**, für die **Kontrolle der Tier-Binary-GENERIERUNG**.
- **D (`:49-57`):** 3-Varianten-Observer-Einbau (alle Tiere+Hybrid / nur Heuristik-Tier / keins) zur **Erkennung des Messfehlers durch Messinstanzen**; 4. Schritt: untergebene Heuristik-Tiere **komplementär OHNE Benchmarks/Observer** neu bauen, Vergleich rein an Wall-Clock; **der Paper-Vergleich geht vor**.
- E IST-Diff (`:61-70`): CoR **Slice 1 ✅ gebaut** (`selection_filter_chain.hpp` + ResumeFilter); Messkurven-Typsystem nur Skeleton `curve_fit.hpp`; **tree<axis>-WURZEL GATED wegen Null-Consumer-Trap**; 3-Varianten-Einbau fehlt (heute HART `COMDARE_MEASUREMENT_ON=1` an alle Kompilate).
- **G Kardinalitäts-Synthese (`:82-107`):** Tabelle HEUTE/PLAN/GATED je Typsystem-Ebene; **Warnung: die Literalzahl 137.594.142.720.000 ist ein Flag-Snapshot vom 02.06. — gültig ist nur die Produkt-Identität `binary_count()==Π mp_size(Enabled_i)`**; drei Kardinalitäts-Klassen KK-1 compile-time-fix / KK-2 profil-gebunden / KK-3 runtime-frei.
- **H 7 offene User-Forks (`:109-120`)** — blockieren die map<>-Ebenen (workload-type-Kanon, „Beschaffenheit", workload-size-Semantik, operation_type-Kanon, framework-Ebenen, Tuple-Erweiterung, Sonderstatus-Trio T2/T10/T1). **Laut `:144` sind sie inzwischen ALLE in Doc 21 entschieden; §H bleibt als Historie.**
- **I bindende Constraint (`:122-141`):** `axis_binding_registry` wurde gebaut, adversarial reviewt und **VERWORFEN** (Doppelquelle zu `profile_to_tree.hpp:68-87`, toter cross-layer-Include, null Produktions-Konsumenten). **Eine compile-time-Achsen-Klassifikation ist erst gerechtfertigt mit (a) echtem Konsumenten UND (b) Contract-Test gegen `build_axis_levels`' `is_static`-Ausgabe** — sonst drift-anfällige Zweitkopie.

## 19. `22_CI_INTERAKTIVE_DIPLOMARBEIT_ANHANG_AUTOMATION.md` (170 Z., 2026-07-11)
- **Auftrag (`:3-6`):** eine XML-Einstellung → gesamte Kette → dynamisch ausgewertete Diplomarbeit-Evaluation. **Vehikel = saubere C++23-Teil-Anwendung (kein Python/.ps1, keine Behelfswege).**
- A.1 (`:17-27`): **nur `A_measurements` ist aus der Messquelle automatisierbar** (11/12 Tabellen); B/E leere Stubs; C/D/F bewusst handgepflegt.
- **A.2 Behelfsweg-Lücke (`:31-40`):** die 12 `\input` sind `% AUTO-GENERATED`, aber **einmalig statisch committet**; **kein CMake/CI-Target** schreibt nach `anhang/<lang>/tabellen/`; einzige Verdrahtung = **zwei Windows-only PowerShell-Skripte**; **Schema-Bruch**: 16-Spalten-Legacy vs 175-WIDE.
- A.3 (`:44-53`): **Darstellungslogik ist zu ~80% da**; Lücke = Orchestrierung/Verdrahtung; **kein high-Perf-Kandidat** (Groß-Parsen `parse_wide_csv` ist schon C++).
- **Teil B (`:59-97`):** zwei Rahmen-Befunde — **alle `pmc_*`-Spalten sind 0 (NullPmcSource) → jede Cache-Miss-Darstellung ist bis #26 honest-empty, NICHT bauen**; der Log-Linear-Fit existiert, wird nirgends visualisiert = größter ungenutzter Hebel. Feld-belegtes Mapping Datentyp→Darstellung (`:65-73`, u.a. **ECDF statt Box-Plot mit erfundenen Quartilen**). **Gravierender Ist-Defekt: `lc_surface_*` nutzt LINEARE viridis über 33…235805 ns → sättigt → Fix P6 log-Farbskala** (`:80`). P1–P6 priorisiert (`:91-97`).
- **Teil C (`:104-130`):** C++23-App `Code/06_appendix_generator`, linkt `comdare::csv_to_latex` + `comdare::diagram_generator` **IN-PROCESS (kein .exe-Spawn)**; **Akzeptanz: `git diff --stat = 0` gegen die committeten `.tex`** (byte-identische Reproduktion als Regressionsnetz), DANN erst Verbesserungen. Schema-Brücke WIDE→Permutations-Tabelle statt tote 16-Spalten-Quelle am Leben halten.
- Teil D Roadmap Inc 1–6 + P1 (`:136-144`); Teil E C++23-Ersetzungs-TODOs (`:152-157`, u.a. `format_tex.py` → C++23 mit **UTF-8-Codepoint-Zählung** für Umlaute; `codegen.sh` → CLI über bestehende `CodegenEngine`).
- Nachträge (`:168-170`): **R10 — die „Code/06_*"-Nummerierung kollidiert mit der real vergebenen Stufe 06 = latex_to_pdf**; korrekt ist appendix_generator = **Stufe 08**, tex_formatter = **09**. R10 honest-empty `\InputIfFileExists` Pflicht; R8 reale Katalog-DLL statt Surrogat.

---

# (b) QUERSCHNITT — HARTE DIREKTIVEN & VERBOTE

### B1. Metaprogrammierung / Hot-Path
1. **Compile-time only im Hot-Path**: Templates / `if constexpr` / Concepts / CRTP. **Kein Runtime-Switch, keine vtable** (16:187, 17:70, 19:32, 10:292, F12III:96/:184).
2. **Kein `std::variant`** — einzige eng begrenzte Ausnahme: Hybrid-Binary als dynamischer Träger abweichender **Unter**-Prüf-Dock-Verträge per Abstract-Factory; Haupt-Observer-Kommunikation bleibt statisch (07-20:138, :128).
3. **vtable existiert ausschließlich an der Modul-ABI-Grenze**, 1× je Modul kalt via `dynamic_cast` gezogen (F12III:184-185).
4. **Keine Per-Operation-CE-Service-Injektion** im `lookup()/insert()/scan()` (10:292, R6).
5. **Nur benannte Lehrbuch-Patterns** (GoF), zero-cost (18:42, 07-20:138).
6. **Keine CT→RT-Degradierung** — Fixes müssen das compile-time-Gate erhalten (xml-ci:176).
7. **`PrueflingSlot` = compile-time-Substitution in GENAU EINE Achse, NIE hart verdrahtet** (16:273, 10:294).

### B2. Achsen / Identität / Struktur
8. **Achsen sind TYPEN (organ / system_measurement / system_config), es gibt KEINE „Achsen-Gattungen"; „Gattung" = ausschließlich das Tier-Binary-Interface.** Nie vermischen (07-20:46-51).
9. **`binary_id` = nur die 17 Organ-Achsen.** System-Achsen dürfen NIE binary_id/E3-Permutation berühren; sie leben im Sidecar (18:104, 19:23, 07-20:63).
10. **Keine Achse ist optional** — „Durchreich statt Weglassen" (16:29, 12:21-30, 12:80).
11. **Organ vs System nie mischen** — eigene abstrakte Wurzel („Blut") für System-Achsen (18:19-30, F12III:55).
12. **System gibt frei, Organ setzt durch; Organ-Nutzung ≤ System-Freigabe** (07-20:67, :187).
13. **Cross-Genus-JOIN ist typ-unmöglich**; erlaubt ist nur Cross-Genus-Komposition-als-Sub-Organ über `OrganConcept` (07-20:107).
14. **Haupt = compile-time-statisch (gestempelt), Unter = runtime, delegiert** — an allen drei Vertragspunkten (07-20:33-42).
15. Naming-Regel Achsen-Verzeichnisse: `axis_<ID>_<topic-name>/`, nicht thema-name (12:226-229).
16. **`algo_version` je Organ-Varianten-Klasse ist Concept-erzwungene Pflicht** (INC2D:160).

### B3. TABU (nur mit explizitem, koordiniertem GO)
17. `permutation_axes.xml` · `golden_fullpilot_320` (heute `golden_320_catalog`) · POD `sizeof` (1416→1344→1272) · `GenusBindingTraits` · **ABI-MAJOR** · conformance-Oracle · Registry-`mp_list` · **`kNewGolden131072Crc64 = 0xF1C1F26A1232073B`** (16:189, 17:71, 18:104/:143, F12III:8, INC2D:138).
18. **Kein ABI-Bump ohne separates GO**; der 4→5 (und 5→6) ist EIN koordinierter Bruch, nicht vier kleine (F12III:8/:16-27).
19. `golden-Roundtrip == 320` ist **Pflicht-Gate**, wo golden berührt wird (17:71).
20. **golden-320 ist nur Byte-Wache; der einzige legitime Ganz-System-Beweis ist 2^17 = 131072** (07-20:121). **new-golden ist Bau-Pflicht.**

### B4. Messung / Ehrlichkeit
21. **honest-0 > Phantom**: nie einen Achsen-Effekt faken, um ein Signal zu erzeugen (18:105).
22. **honest-100%, kein Schein-Grün**; reale Katalog-DLLs, nie das `std::unordered_map`-Surrogat (18:145, 22:170).
23. **honest-empty**: pmc-Darstellungen bis #26 NICHT bauen; `\InputIfFileExists` statt hartem `\input` (22:97, :169).
24. **Fehler nie als Nullen** — CSV-Zelle trägt `failed` + Log (07-20:113).
25. **Achsen-Vergleich gegen std::map entscheidet die Achsen-Güte, NICHT die Latenz** (16:67).
26. **Zwei-Phasen-Op-Schleife PFLICHT**: save → op-warmup → rollback → op-measure (16:61).
27. **Effekte werden erforscht, nicht erfunden** (18:9, :38).
28. **Mess-Exklusivität**: nur EINE CEB misst gleichzeitig; der Bau darf parallel laufen. „Sequentiell" bezieht sich IMMER nur aufs Messen, nie auf den Bau (07-20:98, :191).
29. **Paper-/SOTA-Algorithmen müssen real gemessen werden, nie als Spiegel geführt**; der Paper-Vergleich geht vor (07-20:132, 20:57).
30. Die 8 B.2-Mess-Constraints (Store-Invariante, Rückgabe prüfen, benannte CSV-Spalte, echtes Reset, kein Cross-Talk, Rollback-Erhalt, honest-0, vollständige Kopplung) — 18:63-70.

### B5. Prozess / Verifikation / Doku
31. **Doku nie löschen — nur Banner/Deprecation, additive Nachträge** (01:222, 03:3, F12III:9, alle „Nachtraege"-Blöcke).
32. **Messdaten nie löschen; Backups additiv** (`…_abi4`/`_abi5` einfrieren, F12III:146-149).
33. **Verifikations-Kadenz je Increment**: fresh-context-Kartierung `datei:zeile` → manuelle Umsetzung → **adversarialer max-Effort-Review** → Mojibake-grep `'Ã|â€'==0` → clang-format-22 `--dry-run --Werror==0` → **doppelt-literal (g++-16-Build + eigener Lauf)** → **super-Sub-Build (nicht nur Standalone-ce)** → golden-Roundtrip==320 wo berührt → granularer Commit (**nie `git add -A`**) → beide Remotes → **CI STRIKT GRÜN vor der nächsten Aufgabe** (16:190, 17:73, 18:103).
34. **Lokale ctest + golden-Roundtrip sind unzureichend** — Edge-Case-Tests Pflicht (18:73).
35. **Eine Schicht nach der anderen; jede mit eingefrorenem Interface-Vertrag + eigenem Fake-basierten Contract-Test + eigener DoD** (19:7, :51).
36. **Increments, die mehrere E-Ebenen gleichzeitig berühren, sind die belegte Fehlerklasse** (19:7).
37. **Vertrags-Freeze VOR der Implementierung** (E2→E1 vor #221, 19:19/:33).
38. **Modus a (Aufweichen) NUR bei baremetal-Runner-Block (Infra stuck/timeout)** — reproduzierbare Code-/Configure-Defekte: **Fix, nicht Deferral** (xml-ci:228).
39. **Dual-Verifikations-Bikonditional**: grüne Pipeline ⟺ grüne lokale Tests (xml-ci:223).
40. **Kein Blind-Bau bei offenen User-Gates** (R1/R2, 234-V, CMD-2, HELD-Kette) — 16:257, 19:80.
41. **Kein Parallelstruktur-Bau; nur punktuelle Refactorings; erst Projektstruktur-Analyse** (F12III:220-221, xml-ci:240).
42. **Kein Python/.ps1 in der Kette; keine Behelfswege; der sauberste, nicht der einfachste Weg** (22:6, :159).
43. **`git revert` forward, keine History-Rewrite** (16:164).
44. **Registry = ANGEBOT, Anwender-XML = ANZEIGE, dazwischen Resolve/Link; unregistriert = harter Validierungsfehler; KEIN Parallel-Validator** (INC2D:176).
45. **`<run_methodology>` exactly-one, Validator hart auf BEIDEN Ausführungspfaden** (07-20:191).
46. **Fehlerklassen sind Pflicht** über alle Achsen → Unter-Achsen → Algorithmen; der Planer kennt Klassen statt hart abzubrechen (07-20:138).
47. Bau-Weg-Trennung: **Job-Anzahl O(konstant), nie O(Binaries)**; GTest-Prüfstand je Tier VOR der Messung (07-20:199).
48. **Synchron bleibt: git-Push + Mess-Rückschrieb-Sink. Asynchron: MinIO-Cache.** I/O-Contention während der Messung verfälscht Messwerte (07-20:142).
49. Allokator-Messung isoliert — **DLL linkt ihren Allokator selbst** (07-20:142).
50. drawio: keine Anführungszeichen in value-Attributen, orthogonale Edges, Farbkonvention (01:69-70, 08:62-81).
51. cpuinfo-Flag-Strings **exakt** übernehmen (Unterstrich-Falle, `pni`, `abm`) — SIMD-REFERENZ:10-18, :76, :96.
52. Jede ungequotete `${VAR}` als CMake-Positions-Argument aus einer `check_cxx_source_runs`-Probe ist eine Zeitbombe (xml-ci:242).
53. Cluster-Realität als harte Randbedingung: **prod1 ist der einzige AVX-512-Träger** (SIMD-REFERENZ:123).
54. **Monolith zuerst** — kein Increment darf die cache-engine-Fertigstellung an Modul-Grenzen aufhalten (20:11-15).
55. **`git diff --stat = 0`** als Regressionsnetz vor jeder Darstellungs-Verbesserung (22:113).

---

# (c) WIDERSPRÜCHE ZWISCHEN DEN DATEIEN

## C1. Achsen-Zahl / POD / ABI — vierfach divergent (schwerwiegendste Klasse)
| Größe | Doc 16/17/18/19 (07-09) | F12III INC-2c (07-17) | INC-2d + 07-20-Doc (07-19/20) |
|---|---|---|---|
| Organ-Achsen | **19** (T0–T18) | **18** | **17** (T0–T16) |
| `kV3AxisCount` | 19 | 18 | 17 |
| Snapshot-`sizeof` | 1416 | **1344** | **1272** |
| Snapshot-Version | — | 6 | **7** |
| ABI-Major | **3** (16:69) / **4** (19:20, 16:189) | **4→5** | **6**, Magic `.A6.` |
| golden | 320 (`CatalogAxes<4,4,5,4>`) | 320, Umbau geplant | **2^17=131072**, 320 = `golden_320_catalog` |
| Genus-Slots | 19/15/11/13/7 (16:28) | — | **17/11/13/9/5** |

**Auflösung:** INC-2d + `2026-07-20`-Doc gelten. **Innerhalb** von Doc 16 ist der Widerspruch bereits benannt (R9, 16:271: „ABI-Major 3 … stale → 4"), aber die *Zahl* 19/1416 steht in 16/17/18/19 überall unkorrigiert. Alle `T<n>`-Referenzen in 16/17/18/19 (z.B. Doc 18 F.1/F.2 „T6/T8/T1/T11", „14 honest-0 T0..T18") benutzen die **alte** Nummerierung — INC2D:62 dokumentiert den Slot-Shift, INC2D:145 warnt explizit „axes26-T-Nummern ≠ neue Slot-T-Nummern". **Jede T-Referenz aus 16–19 muss vor Gebrauch umgerechnet werden.**

## C2. Rolle von CacheEngine und PRT-ART — dreifach widersprüchlich, in sich zirkulär
- `10:56` / `10:105-110` / `10:192-202`: CE = **Werkzeug-Bibliothek**, PRT-ART = registrierter Prüfling.
- `10:10-50` (§0, AA.2, 2026-05-18 „KRITISCHE KORREKTUR"): das sei ein **Design-Fehler** — CE ist **ExecutionEngine A**, PRT-ART **gleichwertige EE B**, CEB orchestriert beide per Command-Pattern.
- `10:293` (R5, 2026-07-15): das EE-A/EE-B-Modell ist **überholt**; prt-art ist ein **separater Prüfling**; und ausgerechnet **„die §2.1-Rahmung ‚Werkzeug-Bibliothek' ist die R4/R5-konsistente Sicht, während die §0.3-Verwerfung genau dieser Formulierung der überholte Irrtum ist."**
→ Die Datei verwirft ihre eigene Korrektur. **Gültig: §2.1-Sicht + R4/R5.** Restreibung explizit notiert in `10:296` (§9 Z.277 nennt S3 weiterhin „Werkzeug-Bibliothek", nicht mit AA.2 abgeglichen).

## C3. Phasen 1-7 (DISCOVER…COMPARE) vs. kanonische CEB-Rolle
- `10:210-222` + `04:56-66`: 7-Phasen-Pipeline mit Auto-Discovery als CEB-Kern („PIKA-ähnliches Plattform-Ausmess-System").
- `10:295` (R4): **„nur die Auto-Discovery-Phasen DISCOVER/CLASSIFY/PUBLISH sind kanonisch nicht mehr vorgesehen"**; CEB = XML-config-getriebenes Experiment-Framework.
→ Damit ist die gesamte Säule-B-Auto-Discovery-Doktrin (`04_konzepte_saeule_b.md` §3, ohnehin SUPERSEDED-gebannert) faktisch obsolet, das Dokument sagt es aber nicht selbst.

## C4. Wer baut die Tier-Binaries — CMake vs. C++-orchestriert
- `17:19`: System 2 `ExperimentDriver` ruft `cmake` zur Laufzeit via `std::system`.
- `17:25`: `BuildOrchestrator::provision_all` = realer `cl`-Subprozess (Thesis-„Pfad B").
- `19:89` (R4): **„baut die Tier-Binaries C++-orchestriert zur Laufzeit (NICHT via CMake, aus Performance-Gründen)"**; `17:88` (R4): der cmake-Laufzeit-Compile-Pfad ist **final deprecated**.
- `07-20:199`: Bau läuft **CEB-intern als Runtime-Batch**.
→ Auflösung eindeutig zugunsten C++-orchestriert; die Beschreibung in 17 B.1 bleibt als IST-Kartierung stehen.

## C5. System-Achsen: „nicht im Baum" vs. „eigener Baum je Achsen-Typ"
- `18:28`/`18:50`/`19:21`: System-Achsen = **E0-Querschnitt, NICHT im Permutationsbaum**.
- `07-20:55`: **„Der Permutations-Baum existiert je Achsen-Typ (§54-T4): ein Organ-Baum, ein System-Baum, ein Mess-Baum."**
- `INC2D:49`: System-Achsen sind **bau-treibend** (march-Flags, opt_level, Cross-Triple).
→ Kein echter Konflikt in der *Invariante* (System-Achsen berühren die binary_id nicht), aber die Formulierung „nicht im Baum" aus 18/19 ist durch §54-T4 überholt. Wer 18/19 wörtlich liest, verpasst den System-Baum.

## C6. Mess-Kategorien: passive Spalten vs. Haupt-Achse
- `16:153` + `18:23`: Achse M = **„Reine Spalten-Projektion, nie `mp_product`-Lauffaktor"**; Micro/Makro/Gesamt = E4-Auswertungs-Dimension.
- `16:126`/`16:154` (§54-T2-Nachtrag) + `07-20:87-90`: **Micro/Makro/Gesamt IST die Mess-Tooling-HAUPT-Achse = Bau-Auffächerung** (`ceb:build:[a,b,c]`); die 16 categories sind eine **Planer-Unter-Achse mit Registry-Angebot**, „keine passiven Spalten".
→ In-Doc reconciled, aber der ursprüngliche Kernsatz `16:124` steht unverändert daneben. **Ist-Code-Residue bestätigt den Konflikt real:** `plan_legend.hpp` fächert `[a,b,c]` heute noch aus `measurement_categories` auf (`07-20:90`).

## C7. Legenden-Emission — Doku vs. Ist-Code
`07-20:97`: **„Ist-Code-Regress: `plan_legend.hpp:109` emittiert heute noch `[a,b,c][d,e,f]:chunk<k>` statt `[d,e,f][g,h,i]`"** — GO-pflichtiger TODO. Das ist ein aktiver Widerspruch Vertrag↔Code, nicht nur Doku↔Doku.

## C8. Abarbeitungs-Reihenfolge — drei konkurrierende Sequenzen
- ORIGIN §14: „E2→E1 zuerst" (Daten-Wirksamkeit).
- `18:79-89`: M0 → M1 → M2 → 2′(#221) → 1′(#230) → E4′.
- `19:51`: **E4 → E3 → E2 → M → E1 → … → E0** (bindend).
→ Explizit aufgelöst in `19:53-55`: Contract-Tests entkoppeln; **Vorrang-Regel „neueste USER-Aussage gewinnt"**. Zusätzlich überlagert durch `07-20`/§61-§63 (Modi-Stufenleiter je Maschine).

## C9. Der V32-Fork — dreimal anders gerahmt
- `16:209` (Teil H): Empfehlung **„V32 aktivieren"**.
- `16:251-257` (I.4): Rahmung war falsch — `comdare_experiment` ist toter Code, V32-Orchestrator ist ein No-Op; **Option A (empfohlen)** = `<comdare_messreihen>` erweitern; Option B = V32 wiederbeleben. **Doppel-Gate R1/R2 = User-GO.**
- `16:265` (R1) + `17:84` (R1): der ganze Fork ist **ÜBERFORMT** durch das unified-experiment-Modell (2 Registries + 1 Experiment-XML + v32→**Strategy**) — V32 wird **nicht verworfen, sondern als Strategy weitergeführt**.
→ Drei Antworten in einer Datei; gültig ist R1/R2.

## C10. Doc 17 interne Phasen-Nummer-Diskrepanz
`17:51` (C.3) sagt „**Phase 3** löst `CatalogAxes<4,4,5,4>`", die Roadmap-Tabelle `17:60` führt die Limits-Entkopplung als **Phase 4** (Phase 3 = #188 Achsen-Uniformität). Explizit notiert in `17:82`, aber nicht behoben.

## C11. Doc 22 Stufen-Nummerierung kollidiert mit der realen Kette
`22:105`/`22:156` schreiben `Code/06_appendix_generator` und `Code/06_tex_formatter`; **Stufe 06 ist real `latex_to_pdf`**. Korrekt: appendix_generator = **08**, tex_formatter = **09** (`22:168`). **Risiko: fehlgeleitete CMake/CI-Verdrahtung.**

## C12. Gattungs-Ebene-1: 3 vs. 4
- `16:27` + `INC2D:25`: **3** Ebene-1-Gattungen (SearchAlgorithm/Container/Graph), „unverändert".
- `F12III:26`/`:173`: **F1b = Set-Promotion auf Ebene 1** → map/container/set/graph (4), Teil des 4→5-Bruchs.
→ F1b ist **nicht vollzogen** (INC-2d hat isa herausgelöst, nicht Set promoted). F12III beschreibt einen Plan, keinen Zustand — leicht als Ist misszulesen.

## C13. Superseded-Banner inkonsistent gesetzt
`03`, `04`, `06`, `09` tragen den SUPERSEDED-Banner (2026-05-31); **`01_REV_Historie.md` und `08_drawio_export.md` desselben Jahrgangs und derselben Begriffswelt tragen keinen** — obwohl `16:19` das gesamte REV7.7-Vokabular (3-Säulen / F1–F29 / S1–S30 / 11-Bausteine-Achsen / `IExecutingEngine`) als **Bruchlinie 1 / SUPERSEDED** einstuft. Wer 01/08 ohne 16 liest, hält das Alt-Vokabular für gültig.

## C14. Doc 12 (queuing) benutzt superseded-Vokabular
`12:21-30` argumentiert mit „Lebewesen-Unterklasse", „Gattungs-Interface", „3-Ebenen-Modell" (Stand 2026-06-03). Nach `07-20:46-51` (§54-T1/T4) gibt es **keine Achsen-Gattungen** und keinen `genus`-Enumerator; Achsen sind nach Typ organisiert. Die *Sachaussage* (Q1/Q2 sind Pflicht-Organe derselben Komposition, Durchreich statt Weglassen) bleibt korrekt und ist heute T15/T16.

## C15. „Erstimplementierung = Codex" vs. Projekt-Memory
`16:190`, `18:102`, `19:60` schreiben verbindlich: **Erstimpl. IMMER Codex (gpt-5.5/xhigh, danger-full-access), Claude = Review.** Das kollidiert mit der Direktive „selbst implementieren ab 2026-07-10, Codex abgelöst". Ebenso `18:103` „Co-Authored-By: Claude Opus 4.8". **Die drei Dossiers sind an dieser Stelle datiert-stale.**

## C16. Permutationsraum-Literalzahl
`16:6`/`16:49` nennen **137.594.142.720.000** als Gate-1-Sollwert; `20:94-96` warnt ausdrücklich: **das ist ein Flag-Snapshot vom 02.06.; gültig ist nur die Produkt-Identität `binary_count()==Π mp_size(Enabled_i)`, nie die Literalzahl.** `07-20:13` weicht auf „Größenordnung 10^14" aus. → Die Literalzahl darf nicht als Gate hartkodiert werden.

## C17. golden-320 als Beweis vs. als Byte-Wache
`16:198`, `17:57/71`, `18:103`, `19:30` führen `golden-Roundtrip==320` als **das** Abnahme-/Regressions-Gate. `07-20:121` stuft golden-320 auf **„nur eine Byte-Wache (13/17 gepinnt)"** herab; **„nur die Voll-Konfiguration 2^17 ist Beweis"**. → Gate-Semantik bleibt, Beweis-Semantik ist entzogen. Wer 16–19 liest, überschätzt die Aussagekraft von 320.

## C18. Kleinere Reibungen
- `12:184-196`: Cross-Constraints dokumentiert, aber **„heute noch nicht enforced"** — d.h. der Permutationsraum enthält bekannt-invalide Kombinationen (Q-EPOCH+F-EAGER etc.).
- `INC2D:102`: `k*SlotCount`-Konstanten (15/11/7/13) und ein **aktiver** stale `static_assert` in `test_d9_set.cpp:38` widersprechen den belastbaren 17/11/13/9/5 — **Audit L4/G8 offen**.
- `INC2D:50`: `SimdSubAxis::parent_axis_label()=="extension_hardware"` zeigt auf einen **verwaisten** Knoten (die einzige Klasse mit diesem Label ist die deprecatete) — **Audit G2/E-4 offen**.
- `INC2D:111`: `static_assert(sizeof==1272)` **fehlt** (nur Kommentar) — Quick-Win L3 offen.
- `INC2D:150`: `all_axes_binary_count()` multipliziert System-Achsen mit → irreführender Name, Rename-Audit V7/P4 offen.
- `20:144`: die 7 §H-Forks sind laut Verweis in **Doc 21** alle entschieden — **Doc 21 war nicht Teil dieses Leseauftrags** und ist die nächste Lücke im Bild.
- `20:64`: tree<axis>-WURZEL ist **GATED (Null-Consumer-Trap)** — steht der in `20:22-35` geforderten Typsystem-Vision entgegen, bis ein echter Konsument existiert (#156-daten-gated).
- `16:280`, `17:99`, `18:156`: alle drei Dossiers verweisen für die *volle* Fassung auf **Ledger §59** — die Dossiers sind an dieser Stelle bewusst unvollständig.

---

**Nicht in den gelesenen Dateien enthalten, aber wiederholt als autoritativ referenziert (Lücken für den Architekten):** `docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md` (§10.1, §15.1, §27/§28, §47, §54-T1..T7, §55–§63), `21_SESSION_PLAN_TYPSYSTEM_ACHSEN_ENTSCHEIDUNGEN.md`, `20260717-achsen-nachschlagewerk-ACHSEN-NACHSCHLAGEWERK.md` (NW1-Original), `KONSTRUKTIONSLOGIK.md`, `docs/plaene/20260716-experiment-planer-codegen-design-DOSSIER.md`, `docs/plaene/20260719-planer-ceb-tier-topdown-BAUPLAN.md`, `CE/34_KONSOLIDIERTER_MASTER_IST_STAND.md`, `SUP/14_achsen_komposition_organ_metapher.md`.

Selbstcheck: ASCII-only geprüft — dieses Dokument enthält bewusst deutsche Umlaute/§ (Zitate aus den Quellen), aber keine `─`/`—`-Trennlinien in Code-/Kommentar-Kontexten.