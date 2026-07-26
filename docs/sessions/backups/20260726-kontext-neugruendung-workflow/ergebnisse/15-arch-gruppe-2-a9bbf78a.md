# ARCHITEKTUR-BRIEFING (6 Dateien, vollstaendig gelesen)

Basis-Pfad aller Anker: `/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/docs/architektur/`
Code-Anker in KONSTRUKTIONSLOGIK sind relativ zu `Code/external/comdare-cache-engine/libs/cache_engine/`.

---

## (a) DATEI-ZUSAMMENFASSUNGEN

### 1. `11_konzept_achsen_extension_visitor_pattern.md` (1907 Z., Stand 2026-05-25/26 + Nachtraege 2026-07-15)
Status im Kopf: "SKIZZE zur User-Abstimmung (V41.F.6.1)" — de facto aber das Grunddokument des Achsen-/Prueflings-Erweiterungs-Patterns, mit inline eingetragenen User-Antworten (die verbindlich sind) und additiven E2E-Re-Audit-Nachtraegen am Ende.

Bindende Vertraege / Entscheidungen:
- **5 zusammenwirkende Patterns** (§2, Z.20-195): A Concepts pro Achse (C++23), B CRTP-Basis, C Permutations-Visitor (Compile-Time-Fold), D Namespace-Slot mit Compile-Time-Fallback, E CacheEngineBuilder Pre-Compile-Permutations-Generator (kartesisches Produkt).
- **Frage 1 beantwortet: MIX** — CRTP-Basis, deren `Derived` per Concept-Constraint abgesichert ist; pro Hierarchie-Ebene (Topic + Achse) eigene Concepts (Z.73-75, §3.6 Z.445-503, §7 Z.557).
- **RQ-1 (Z.319-321):** Topic-Concept (breit) UND Achsen-Concept (eng, leitet ab). "Jeder Ordner und Unterordner hat genau EIN File fuer die Definition aller concepts des Ordner-Suchraums."
- **Frage 2 / §3.5 (Z.157-160, 364-436, §7 Z.558): 3-Stufen-Modell** — Stufe 1 = cache-engine-only; Stufe 2 = Pruefling EINZELN, "ERSETZT pro Achse mit Compile-Time-Fallback" (leere Pruefling-Achse ⇒ vollstaendige Uebernahme der CE-Varianten dieser Achse); Stufe 3 = Full Join, non-redundant, MULTIPLE Prueflinge parallel. Mapping zu Messreihen A/B/C (Z.438-442) ist laut Nachtrag R11 nur noch Doku-Hygiene.
- **Pruefling != Pruefling-Binary** (User, Z.394): Pruefling = komplettes Achsen-Kompendium/eigenes Projekt; je Pruefling entstehen ZEHNTAUSENDE Rekombinations-Binaries, jede in eigenem Experiment gemessen (CEB als Orchestrator). Der Pruefling liefert ein Messprofil in der Dimensionalitaet der Achsenzahl.
- **Hierarchie (§3, Z.199-297):** KEIN separates `axes/`-Verzeichnis; Topics enthalten Achsen direkt; mind. 1 Achse je Topic; achsenfreie Hilfsfunktionen nach `src/` (global, parallel zu `topics/`).
- **§11.1 (Z.622-673): echte C++23-Modules VERWORFEN** (erzwingen `import`-Kopplung). Kanonische Mechanik = INTERFACE-Target + `INTERFACE_COMDARE_CE_PRUEFLING_HEADERS` + `configure_file`-Master-Header `prueflinge_includes.hpp` + concept-Detection auf Namespace-Inhalt.
- **§11.7.A (Z.889-909): FINALE 15-Topic-Liste** (allocator, concurrency, traversal, nodes, memory_layout, prefetch, telemetry, serialization, value_handle, queuing[ex value_buffer], hardware, search_engine, io, migration, filter) + Scheduling als Sub-Achse je Topic (W3, Z.712-732), nicht als eigene Achse. §11.7.B/C = finale `src/`-Liste + vollstaendiges Migrations-Mapping der 12 Subsysteme/8 Concurrency-Disziplinen/14 Allokator-Familien.
- **§11.2 (Z.675-708): Achse `queuing`** 13 Strategien × 6 Groessen = 78, ~38 nach Constraint-Filter; Cross-Constraints als `requires`-Klauseln (Buffer × Allocator).
- **§11.4 (Z.734-782): 3-Schichten-Vererbung** CacheEngine → execution_engine → search_engine → prt_art, mit Pflichtregel: SearchEngine darf NIE direkt CacheEngine-Bausteine konsumieren, ExecutionEngine kennt keine Such-Patterns.
- **§13 (Z.1155-1267): Pilot allocator/axis_06 LIVE** — Naming-Konvention (§13.2 Z.1184-1195, verbindlich), 3-Schichten-Concept-Architektur (§13.3), Parallel-Concepts `AllocatorStrategy` (PMR-konform) UND `CacheEnginePermutationStrategy` (axis_tag/family_id/name/is_thread_safe/…) + 6 Sub-Refinements (§13.4 Z.1220-1241), CMake-Flag `COMDARE_CE_ENABLE_STATISTICS` fuer messoverhead-freie Production-Binaries (§13.5).
- **§14/§15 Roadmap-Erweiterungen (Z.1284-1892):** adapters/+ext/ mergen in `axis_NN/vendors/<vendor>/` (§14.3); tools/ → modules/-Submodules (§14.4); Mess-Strategien selbst als CMake-waehlbare Achse (§14.5); benchmarks/ → `modules/comdare-measurement` hinter Facade-Kette Diplomarbeit→CE-Facade→Measurement-Facade (§15.1); zentralisierte CMake-Flags statt `#ifdef COMDARE_HAVE_*` (§15.2, Stufe 1+2 LIVE §15.8 Z.1741-1747); `iterable_aspect_t` als optionaler Runtime-Aspekt je Achsen-Variante (§15.5 Z.1595-1623); constexpr `TopicConfigSet` + CEB als separate C++-App, nicht CMake-Script (§15.7 Z.1631-1737); **min-1-Algorithmus je Achse als mp11-`static_assert`** (§15.9 Z.1761-1789); CEB setzt USE-Flags per CLI (§15.10); mp11 hat KEIN 10-Template-Limit, 23 Vendor unproblematisch (§15.11).
- **§14.8 (Z.1447-1494) Sonderfall concurrency:** SIMD-Sub-Achsen statisch, uebrige concurrency-Sub-Achsen HYBRID dynamisch via `std::variant` + Runtime-Threshold-Iteration; `[[no-runtime-switch]]` dort explizit aufgehoben, weil Switch nur zwischen Messreihen liegt. Gilt weiter fuer allocator/layout/prefetch.

Invarianten (§9, Z.601-608): kein dynamischer Switch (nur `if constexpr`/Variant-Tuple), keine virtuellen Funktionen im Hot-Path, kein `std::variant` im Hot-Path, keine Runtime-Registrierung, Concept-Verletzung bricht den Build.

Offene Punkte: §15.8 (Z.1749-1759) `observer_t`/`observer()`-Concept-Constraint ist TEMPORAER AUSKOMMENTIERT (TODO-Marker) — Observer-Konzept bleibt Pflicht-Architektur, Reaktivierung mit Wrapper-Update ausstehend. §12 (Z.1085-1151) W4-Liste vergessener Features (P0: H1/H2/H3 als Mess-Achse, V1-V4 Engine-Choice-Multiplikation, IPlatformProbe Auto-Discovery; D.1 IExecutingEngine-Wurzel, D.2 Multi-Pruefling-Full-Join, D.3 POD-ABI-Modul-Interface).

Nachtraege 2026-07-15 (Z.1894-1907, additiv, korrigieren den Haupttext):
- R11 (Z.1898): 3-Stufen-Join inhaltlich deckungsgleich mit `pruefling_merge.hpp`, nur Terminologie angleichen.
- **R4 (Z.1900): Der Per-Permutation-CMake-Aufruf aus §15.7/§15.10 ist ALT** — kanonisch ist C++-orchestrierter Build (`BuildOrchestrator::provision_all`); CMake nur noch fuer das ce-Basis-Target (Doc 17 System 3).
- R1/R5 (Z.1902-1905): `TopicConfigSet`/mp_list wird aus **zwei Registry-XMLs gleichen Schemas** (ce-SOTA + prt-art) gespeist (Pre-Build-Codegen); der Namespace-Slot bleibt der Compile-Time-Substitutionsmechanismus in genau EINE Achse. Die RQ-6-Aussage "Registry muss durch das Namespace-System ersetzt werden" (Z.348) ist ausdruecklich als missverstaendlich zu korrigieren.
- **R9 (Z.1906): Kanonisch sind 19 statische Hauptachsen (T0-T18), NICHT 14.** golden-320 = `mp_take_c<Enabled,4>` (4×4×5×4). TABU-Liste: Registry-mp_list, golden-320, POD `sizeof==1416`, `ABI-MAJOR==4`, `GenusBindingTraits`, `golden_fullpilot_320`.

---

### 2. `TIER-AUFLOESUNG-AUDIT-UND-MAPPING-PLAN.md` (419 Z., 2026-06-15 + Nachtraege 2026-07-15)
Status: "AUTORITATIVE GRUNDLAGE" fuer die Begriffsaufloesung; zugleich die beste Architektur-Landkarte im Bestand.

Bindende Begriffs-Ordnung:
- **Verantwortlichkeits-Kette (§1, Z.27-50):** Bibliothek (cache-engine UND PRT-ART, beide **keine** Lebewesen) → Permutations-Lebewesen/Rekombination (ein Punkt im Entwurfsraum) → ②Subject (ABI, Modul=Subject/Host=Observer) → Host (Prueф-Dock/CEB: treiben, messen, mappen, persistieren). **Symmetrie:** beide Bibliotheken erzeugen Lebewesen und treiben sie ueber dieselbe ②Subject-ABI (Z.39-41).
- **4 „Tier"-Cluster (§2, Z.56-71):** ① Lebewesen/Anatomie · ② Subject/Mess-Schicht · ③ Band/Cache-Ebene · ④ Rang/SOTA-Reifegrad.
- **Zentrale Invariante (Z.63-68, code-belegt `idriveable_tier.hpp:6`): „Anatomy-ABI ⊥ Observer-Tier-Schnittstelle"** — ①Aufbau und ②Messung sind orthogonal; `IObservableTier` haengt NICHT an `IAnatomyBase` (`observable_tier.hpp:22`), wird per `dynamic_cast` separat abgefragt; verbunden einzig im `SetAbiAdapter`.
- **②=Subject, NICHT „Probe"** (Z.69-71, 85-88): „probe"(EN) ist reserviert fuer Pruefling; ein gemessenes ganzes Lebewesen heisst „Permutations-Lebewesen/Rekombination", nie „Probe".

Architektur-Landkarte (§4, code-verifiziert):
- **4 Konzept-Ebenen (§4.1, Z.108-122):** Gattung (`AnatomyGattung`, **3**: SearchAlgorithm/Container/Graph) → Lebewesen-Unterklasse (`AnatomyGenus`, **5**: SearchAlgorithm/Set/Sequence/Adapter/View) → Achse=Organ (**19** fuer SearchAlgorithm) → Sub-Achse=Organ-Bestandteil (~57-279). Achsen-Saetze je Genus (`genus_binding_traits.hpp`): 19/15/11/13/7. Cross-Genus-Permutation type-mathematisch unmoeglich ⇒ 5 getrennte Anatomien/Compositions/Observer/PermutationEngines; **nur SearchAlgorithm ist voll gebaut**.
- **§4.2 (Z.124-133): Andere Gattung ⇔ grundlegend anderer Basis-Achsen-Satz.** Hash-Map ist KEINE eigene Gattung, sondern `search_algo`-Auspraegung mit limitiertem Subset — Gegenteil waere „queuing-Kategorienfehler".
- **§4.3 (Z.136-148): `topics/` ≠ `axes/`** — Doppel-Verzeichnisbaum (bewusste Migration V41.F.2): `topics/<name>/axis_NN_*/` = duenne **Forwarding-Stubs** → `axes/<kurzname>/` = echte Implementierung. Single-Source der Achsenliste: `axes/axis_centric_namespaces.hpp`. Autoritative Zahl **19 = `observable_tier.hpp::kV3AxisCount`** (T0..T18 = `seg_ns[19]`). **Konsequenz: Sub-Achsen-Header existieren teils in BEIDEN Baeumen — beide nachziehen.** Sub-Achsen code-gezaehlt: 74 Tags + 54 Concepts + 151 Wrapper ≈ 279.
- **§4.4 (Z.150-187) Aufbau-Seite ⊥ Mess-Seite:** Bibliothek → `XxxComposition` (compile-time Typ-Liste, traegt Identitaet, keine Logik) → `XxxAnatomy<Composition>` (Lebewesen in-process) → Achse/Sub-Achse. **Eine nicht zutreffende Achse wird NIE weggelassen, sondern mit `None`-Durchreich-Organ belegt** (Z.163-164). Mess-Seite: `IXxxSubject` + `XxxAbiAdapter` (einzige Bruecke) + Host. `IDriveableSubject` IMMER einkompiliert (traegt `std::map`-Konformitaets-Gate + Last), `IObservableSubject`/`IRollbackableSubject` NUR bei `COMDARE_MEASUREMENT_ON`. Snapshot = flacher, komposition-UNABHAENGIGER POD (`axis_stats[19][8]` + `seg_ns[19]` + Meta), memcpy-faehig.
- **§4.5 (Z.189-204):** prt-art = 8 Bausteinschichten L1-L8; `CacheTier` ist KEINE eigene Hierarchie, sondern Sub-Achse der memory_layout-Achse (Cluster ③ Band).

Mapping-Plan (§5, Z.207-247) + Fallstricke (§6, Z.250-265): vollstaendige alt→neu-Identifier-Tabelle (`I*Tier`→`I*Subject`, `tier_*`→`subject_*`, `ComdareTierObserverSnapshot`→`ComdareSubjectObserverSnapshot`, `CacheTier`→`MemoryBand`, `tier_subclass`→`organism_subclass`). **§6.6: Umbenennung ist ABI-BRECHEND → Host + alle Prueflings-DLLs synchron + ABI-Major-Bump 3→4.**

Status: Doku-Umstellung **HARD-DONE** (§10 Z.400): A/B/C/D/E abgeschlossen; **verbleibend NUR Implementierungs-Agent**: `AnatomyGenus`-Enum (#90) + `IObservableTier`→`IObservableSubject`/`tier_*`→`subject_*` Code-Rename.

Nachtraege (Z.410-419): R11 bestaetigt das 3-Stufen-Join-Modell (kein Konflikt); **R6 (Z.416) praezisiert bindend: die Formulierung „`std::variant`-Bausteine" in §3.1 ist irrefuehrend** — Selektion ist compile-time via `mp_list`/CRTP/`std::conditional_t`; `pruefling_merge.hpp:99-124` nutzt KEIN `std::variant`, `permutation_strategy_concept.hpp:10-11` verbietet Runtime-Tag/`std::variant`; nur W/D-Dispatch ist bewusst runtime. R1 (Z.418): der Organ-Katalog je Achse ist als **zwei Registry-XMLs** formalisiert (nicht in der Experiment-XML).

---

### 3. `20260717-konstruktionslogik-durchdringung-KONSTRUKTIONSLOGIK.md` (377 Z., Stand 2026-07-17)
Selbstbeschreibung (Z.4-5): "ENTSCHEIDET NICHT neu, sondern kartiert das Modell gegen den Ist-Code (datei:zeile) und markiert jedes Delta". Das ist die aktuellste, code-belegte Ist-Analyse — hoechste Autoritaet fuer den IST-Zustand.

- **§0 (Z.14-27): DREI Achsen-Begriffe, nie vermischen** — (1) **Organ-Achse** (compile-time Strategy-Wrapper, permutiert `binary_id`, Wurzel `topics::AxisBase`, `topics/axis_base.hpp:52-79`) — realisiert; (2) **Mess-System-Achse „Blut"** (`measurement::SystemAxis<Derived>`, `include/cache_engine/measurement/system_axis.hpp:147-180`, golden-neutral) — realisiert; (3) **CEB-System-Achse** (Modell: compile-time-statisch, UEBER den Tier-Binaries) — **verstreut, offenes Delta**.
- **§1 (Z.31-66): Organ-Achsen-Vertrag** = CRTP-Basis mit **drei** `static_assert`-Concepts im protected-Ctor (Bsp. `axes/prefetch_axis/axis_07_prefetch_strategy_base.hpp:11-18`) + `topics::AxisBase` (`get_compiler()`/`is_original_module()`) validiert durch `AxisBaseConcept` (`axis_base.hpp:90-94`) + Permutations-Vertrag `axis_tag`/`family_id`/`name()`/`enabled`. **19 Slots T0..T18 in `AdHocComposition`** (`anatomy/composition_factory.hpp:49-74`); kanonische Namen/Reihenfolge `kCompositionAxisNames` (`builder/experiment_tree/axis_path_serialization.hpp:30-34`): search_algo, cache_traversal, mapping, path_compression, node_type, memory_layout, allocator, prefetch, concurrency, serialization, telemetry, value_handle, isa, index_organization, io_dispatch, migration_policy, filter, queuing_q1, queuing_q2. **Der serialisierte Achsenpfad IST der `binary_id`** (`axis_path_serialization.hpp:44-60`); `static_assert(sizeof...(Vs)==19)` (`composition_factory.hpp:87-109`). Genau EINE Binary je kartesischem Punkt.
- **§2 (Z.70-97): Allokatoren = Algorithmen der axis_06** — Wrapper IST die Wahl; `AllVendors = mp_list<…>` 26 Eintraege (`axis_06_allocator_registry.hpp:78-100`), `EnabledVendors = mp_filter<…>` (Z.117); An/Aus compile-time (`static constexpr bool enabled = flags::mimalloc_enabled`), Vendor-Header ueber EINEN Shim mit Forward-Stubs, **kein `#ifdef` im Wrapper** (W6-Pattern).
- **§3 (Z.101-128): Gattungen** — Ebene1 `AnatomyGattung` NUR 3; Ebene2 `AnatomyGenus` 5; `GenusBindingTraits<G>` liefert slot_count/axis_names/CompositionFor/AnatomyFor (19/13/15/11/7). `IAnatomyBase : IExecutionEngine` traegt **bewusst KEINE Treib-/Mess-Methoden** (vtable-Layout stabil). **DELTA:** User-Modell will `map/container/set/graph` auf Ebene 1 (Set eigenstaendig) — Code hat Set als Genus unter Container ⇒ **koordinierter ABI-4→5-Schritt F1b**. Vokabular-Bruecke: User-„Gattung" == Code-`AnatomyGenus` (Ebene 2).
- **§4 (Z.132-193): Prueф-Dock-ABI-Vertrag, DREI Teile** — Befehl + Settings + Ergebnis-Rueckkanal. (4a) `IPruefDock` ist KEINE ABI-Grenze (lebt im Builder, eine vtable, nicht Hot-Path); ABI-Grenze = gattungs-eigenes Antriebs-Sub-Interface + flacher POD. **Bindende Reihenfolge `import → GATE → messen`** (`pruef_dock.hpp:74-79`); `accepts` matcht ueber die im Modul deklarierte Gattung, **nicht** ueber Dateinamen. (4c) Settings-POD `ComdareResourceControlV1` (6× uint64, Sentinel 0 = Default), `IResourceControllableTier` **IMMER verfuegbar, auch Messung-AUS**; apply klammert an Caps und reicht via `if constexpr (requires{ organ_.set_runtime_*() })` durch. (4d) `tier_observe(ComdareTierObserverSnapshot*)`: **`sizeof==1416`, `alignof==8`**, standard_layout + trivially_copyable; Spalten-Vertrag `kV3AxisSchema[19]` als Single-Source Schreiber↔CSV. (4e) Loader: `dlopen(RTLD_NOW|RTLD_LOCAL)`, 4 Pflicht-Symbole, Magic `".A4."`, Major-Match + Minor≤, **ABI-Major = 4**; Destruktor ruft `comdare_destroy_anatomy` VOR `dlclose` (gleicher Heap).
- **§4f (Z.185-193): 4 Luecken** — zwei parallele Treib-Pfade (CEB-Iterator umgeht `IPruefDock`, `:750-756`); RC ist organ-scoped statt system-scoped; nur 1 von 3 Gattungs-Docks (`SearchAlgorithmDock`); ABI-Major noch 4.
- **§5 (Z.197-209):** Compile-time-Haupt-Achse (T0..T18) + dynamische Runtime-Unter-Achse (`IResourceControllableTier`, host-getrieben, geklammert auf min(tier-caps, env_limits)); `run_lazy_static_then_dynamic` (`cache_engine_builder_iterator.hpp:668-819`).
- **§6 (Z.213-243): Kernbefund — Ist FLACH, Ziel GESCHICHTET.** `registry_to_axis_levels.hpp::build_all_axis_levels` (Z.81) reflektiert **26 Achsen als eine flache `std::vector<AxisLevel>`**; einzige Zweiteilung ist `is_static` vs. dynamisch (Organ-Zweiteilung, keine System/Organ-Schichtung). Deltas je System-Achse: telemetry permutiert `binary_id` statt System-Achse zu sein; **`make_gpp_compile_fn` hat KEIN `-march`/`-mavx` (Z.474-483) → Binaries faktisch immer generisch `-O2`, H-7 nicht realisiert**; **`ISchedulingStrategy` ist RUNTIME-VTABLE und NIRGENDS konsumiert** (`include/cache_engine/concepts/scheduling_strategy.hpp:37-46`) = doppeltes Delta (verwaist + verletzt `no_runtime_switch`). Sauber realisiert: dynamische System-Unter-Achsen via Prueф-Dock. Andockpunkte: `build_system_axis_levels()` abspalten (Organ vs System NIE mischen); `-march` ueber die injizierte `CompileFn` (`build_orchestrator.hpp:115`); **Governor/Prefetcher (H-8) bleiben Tier-Binary-Achse, NICHT System-Achse**.
- **§7 (Z.247-270):** Es gibt heute KEINEN „Experiment-Planer-Dock"; die reale Naht ist `run_experiment_profile` (`profile_facade/experiment_run_entry.hpp:93`) → `LazyRunConfig` → `run_lazy_static_then_dynamic`. **Der ANATOMY-MAJOR 4→5 reitet an dieser Naht.**
- **§8 (Z.274-291):** Versionierung vorhanden (`BuildVariantDefinitionV1`, Kohaerenz-Guard, `.version`-Sidecar, Provenance-Manifest). Delta H-10: Manifest ist **global statt per-Binary**; AVX10-Feld fehlt.
- **§9 (Z.295-372): DLL-Load-Bruch (F1), begruendete Empfehlung Option B.** Zwei Wege: CMake-`add_library(SHARED)` (`tools/permutation_codegen/codegen.cmake:584,607-632`) linkt das Vendor-Archiv → funktioniert; Laufzeit-`make_gpp_compile_fn` (`build_orchestrator.hpp:466-489`) schreibt `.rsp` **ohne jedes `-l`/Archiv**, `BuildJob` hat **keinen Link-Input-Kanal** → `dlopen(RTLD_NOW)` scheitert mit `undefined symbol: mi_malloc_aligned`. Das ist der Produktions-Golden-Pfad. **Option A (Host `-rdynamic`) ist an FUENF Stellen doktrin-widrig** (bricht Allokator-als-Achse durch prozessweit geteilte Arenas ⇒ Kreuz-Kontamination; bricht Destroy-Vertrag; schmuggelt verdeckte globale Symbol-Abhaengigkeit ins ABI ⇒ Widerspruch zu vendor→faithful→self-contained; macht H-10-Metadaten unwahr; koppelt statisches Dispatch an Runtime-Symbol-Resolution). **Option B = DLL self-linkt ihren Allokator**; Fix = `link_libs`-Kanal durch `make_gpp_compile_fn`/`BuildJob` + Fassade backt `$<TARGET_FILE:comdare::vendor_*>` analog den Includes.
- **NACHTRAG (Z.374-377, autoritative User-Schaerfung): Experiment-Dock (Planer↔CEB) ist EINDIMENSIONAL** (Planer steuert die von ihm kompilierte CEB, KEIN Rueckkanal); **Prueф-Dock (CEB↔Tier-Binary) ist BIDIREKTIONAL**; **Ergebnis-Rueckschrieb laeuft NICHT ueber das Experiment-Dock** — die CEB schreibt selbst an das in der XML angegebene Ziel (`measurement/<YYYYMMDD-HHMMSS>/`, Write-Token, Loop-Schutz).

---

### 4. `11_axes_vs_strategies_disambiguation.md` (348 Z., Stand 2026-05-18 + Nachtrag 2026-07-15)
Zweck: Anti-Vermischungs-Master fuer **4 unabhaengige Konzept-Ebenen**, die in den 44 REV7-drawio-Tabs sprachlich kollabierten.

- **Ebene I** Bausteine-Achsen = Algorithmus-Permutations-Dimensionen (§2.1, Z.29-59; Liste Z.36-57 mit **13 Hauptachsen** inkl. 3.A/3.B/3.M und 6.1-6.5, plus NEU 12 Hardware / 13 Scheduling).
- **Ebene II** CE-Sub-Engines C1-C12 = CE-INTERNAL Services mit Atom-Zahlen (§2.2, Z.67-81).
- **Ebene III** Cache-Strategien F1-F29 = Implementations der Sub-Engines (§2.3, Z.89-97).
- **Ebene IV** Such-Engine-Familien S1-S30 = Implementations der Algorithmus-Achsen (§2.4, Z.105-112).
- **§3 (Z.120-141) Tatsachen-Tabelle** Achse × (S/C/F) — welche Achse welche Ebene konsumiert. Beobachtung: Achsen 12+13 brauchen noch S-Familien.
- **§4/§5 (Z.149-186):** 10 typische Verwechslungen + Ebenen-Zuordnung je K-Tab, jeweils mit „FALSCH"-Gegenbeispiel.
- **§10 R.1-R.10 (Z.220-323):** Detail-Klarstellungen. Wichtig: **R.9 V1-V4 = Meta-Achse ENGINE-CHOICE-DIMENSION** (V1 No-CE-Baseline / V2 static / V3 kalibriert / V4 adaptiv) = 4-fache Build-Multiplikation und **DER zentrale Vergleichsmechanismus der F15-Forschungsmission**; **R.10** F15-Familie (Ebene III) ≠ F15-Mission (Meta-Forschungsziel); **R.5** PRT-ART Typ A/B/C/D = Sub-Permutation auf Achse 2 (bzw. Dimension D10), keine eigene Achse; **R.6** die 4+2-Pools sind 7 INSTANZEN einer Strategie, nicht 7 Allokatoren.
- **§8 (Z.208-216) Eigentums-Regel:** PRT-ART implementiert Ebene IV und KONSUMIERT Ebene II ueber Service-API; **PRT-ART ist NICHT verantwortlich fuer Ebene II oder III — das ist CE-Eigentum.**
- **Nachtrag R9 (Z.347-348):** Die 13-Hauptachsen-Zaehlung (§2.1) und „alle 13 Algorithmus-Achsen" (§8) sind **durch die kanonische 19-Achsen-Anatomie ersetzt**; Ebene-I-Bausteine leben kanonisch in den 2 Registry-XMLs. **Die 4-Ebenen-Disambiguierung selbst bleibt inhaltlich gueltig** — nur Achsenzahl und Pre-19-Vokabular werden nachgezogen.

---

### 5. `05_uml_klassen.md` (305 Z., Stand 2026-05-15)
**KOPF-BANNER (Z.3) — SUPERSEDED (2026-05-31):** ueberholter Planungsstand (axis-zentrische Restruktur F.2, Plugin-Pruefling-Modell, DLL-F15-Pipeline, sezierte Organe). IST-treue Single-Source: `comdare-cache-engine/docs/ledger-sections/architektur-ziele-offene-punkte-ledger.md` + `…/20260531-e2e-abnahme-audit-und-entscheidungen.md`. **Niemals loeschen — nur Banner.**

Historischer Inhalt (nur als Herkunftsnachweis der ADR-Nummern verwenden):
- §2 Search-Engine-Concepts IPage/IRootPage/IFanout/INode/ISearchPage(+Structure/Interpreter)/ICachePage/ICacheStrategy(Visitor)/ITraversal/IValueHandle/IMemoryLayout/IAllocator/IPrefetch, Achsen 1-7 (Z.33-57). **F8: ValueHandle als `std::variant` + Concept-Constraint** (Z.29) — heute doktrin-widrig.
- §3 (Z.63-122): **CacheEngine als Heap-Singleton IM Builder-Prozess (F1/F12-K)**, `call_once`, Observer-Push mit Lambda-Tree-Filter (F2), `IDecisionLambdaTree` pro Baustein (F-EXTRA-6). 8 Concurrency-Disziplinen (Z.99-107) + 3 Mechaniken; **Hazard Pointers in REV4 ENTFERNT, RCU bevorzugt** (Z.112). 6 TelemetryStrategy-Familien mit PerNodeCounter als explizites Multi-Core-Anti-Pattern (Z.114-120).
- §4 Measurement als `constexpr`-Spezialisierung pro (Kategorie × AlgorithmDetail), `requires HasMeasurement<C,A>`; F11 Continuous fuer Builder / Sampled 1:N fuer Production (Z.126-148).
- §5 Hardware/ISA: `IPlatformProbe`, **Flag-System nach CPUID-Vorbild, 9 Banken, Bit-Position statt opaker perm_id (F10-K)**, `match_filter` per Bit-AND (Z.169-182).
- §6 CacheEngineBuilder als Orchestrator mit **Phasen 1-7** (enumerate → codegen → compile → load → run → measure → export, Z.203-219) — dieses Phasenmodell lebt konzeptuell im heutigen `BuildOrchestrator`/CEB-Iterator weiter.
- §7 Persistence: **F5 eigener `InMemoryMeasurementBuffer`, KEINE externe DB, Disk-Dump am Ende** (Binary → CSV → LaTeX-Kette, Z.240-272).
- **F-EXTRA-1 (Z.28, 199): Compiler-Layering — Hauptcompiler IMMER C++23; Bausteine-Internals mit ihrem Original-Compiler kompiliert und statisch gelinkt.** (Direkter Vorlaeufer der heutigen Compiler-Achse und der Option-B-Self-Link-Entscheidung.)

---

### 6. `21_SESSION_PLAN_TYPSYSTEM_ACHSEN_ENTSCHEIDUNGEN.md` (287 Z., Stand 10.-15.07.2026)
Selbstbeschreibung (Z.9-10): **„bindender Bauplan" fuer die E4′-/Arbeitsmodus-/Hybrid-Strecke; ersetzt das „orthogonal compile/dynamic"-Bild aus Doc 20 §I durch das Layer-/Haupt-Unter-Achsen-Modell.** Rahmung: CI gruen + messfaehig ⇒ **nur PUNKTUELLE Refactorings, kein Greenfield** (Z.6). Stand ce `c022ce05` (ctest 199/199).

- **§A autoritatives Modell (Z.16-36):** (1) Experiment-Baum = **B+-Baum, LAYER-sortiert**, jede Achse ein Layer; SPREAD einer Node = alle Variationen EINER Achse, **ENTWEDER statisch ODER dynamisch — die beiden fallen NIE zusammen**. (2) **Wurzel = System-Achsen == Meta-Achsen** (inkl. telemetry + Mess-System), reichen Workloads per **Visitor** durch, mit **Strategy** in den Visitoren. (3) Prozess-Dimension (bauen→messen→auswerten→Hybrid) = **Builder ueber State**. (4) **Decorator ueber das Visitor-Objekt** loggt den Tier-Binary-Wahl-State (Stack). (5) **EIN Concept fuer alle Achsen; eine Unter-Achse ist eine VOLL-Achse** unter der compile-time-Haupt-Achse — der frueher so genannte „Laufzeit-Skalar" (RC-POD-Feld) IST eine Unter-Achse. (7) **ZIEL = MAXIMALE UTILIZATION:** jedes Achsen-Interface muss in ALLEN anderen (nicht-System-)Achsen echt verlinkt+angewandt sein; honest-0/no-op = **Utilization-Luecke**.
- **§B 7 Fork-Entscheidungen, alle getroffen (Z.44-50):** H1 Workload-Frameworks/Workloads/Ops/Ablaeufe als generische Klassen + Strategy vereint (13 Frameworks, 14 Lastprofile LP01-LP14, OP-1..6); framework×workload = statischer Layer, operation/sequence = dynamischer Layer. H2 Beschaffenheit in den Workload-Typ ENCODIERT (dynamische Achsen duerfen multiple Parameter covern). H3 workload-size = map ueber Cache-Regime-Werte (maschinenrelativ). H4 **alle `std::map`-Huellen-Interfaces werden gemessen, variadisch metaprogrammiert, orientiert an std C++23; BEIDE (Runner-Op-Set UND XSD) werden geaendert.** H5 13-Framework-Registry als Vokabular. H6 **Pareto-Front** statt Einzel-Objective; Blatt = `tuple<property,time,objective_tag>` + Front-Menge. H7 **alle 19 Slots strukturell intakt; Haupt-/Unter-Achsen auf EINEM Concept; telemetry ist Meta==System-Achse an der WURZEL, nicht Organ-Slot** — via Layer-Hierarchie, nicht durch Slot-Entfernung.
- **§C fehlende Unter-Achsen (Z.56-76):** (K) **Klassifikations-Tag-Kollaps in JEDER der ~22 Haupt-Achsen** — alle `*_tag`-Structs (PG1-3 … FS1-4) sind leere Tags mit genau einem Anhaenger, kein Konsument ⇒ das kartesische Sub-Produkt ist kollabiert. Fix: je Tag-Dimension echte `StaticAxisVariants`-Sub-Liste + Kreuzprodukt; einziges real gekreuztes Vorbild `topic_hardware_config_set.hpp:41-59`. (S) RC-POD-Skalare erst **2/5 echt**: `pool_budget_bytes` ECHT, `inline_threshold_bytes` ECHT, `prefetch_distance` PARTIAL (nur family_id==1, nur unter `COMDARE_MEASUREMENT_ON`), `batch_size` NO-OP (+ Namens-Drift axis_03a↔03b), `thread_count` NO-OP (kein `std::thread/jthread`).
- **§D Utilization-Luecken + Schichtung (Z.81-115):** 16 Achsen honest-0; drei Hebel — (A) SIMD-Dispatch in alle `*_scan`-Kerne, (B) Allocator-Adapter in die 11 Pool-Organe + 4 Shapes, (C) Hot-Path-Hebung von prefetch/concurrency/migration. **Achsen-Interface-Graph ist ein DAG, keine echten Include-Zyklen.** Bindende **Schichtung L0-L5** (Z.98-105): L0 HW-Deskriptoren → L1 Primitiv-Provider (memory_layout, allocator) → L2 Form-Deskriptoren → L3 Strukturen → L4 Zugriff/Policy → **L5 System/Root: telemetry + Mess-Apparat, Visitor ueber alles darunter, nur PULL**. **Telemetry-Fehlplatzierung ist bindend fuer H7:** telemetry ist heute faelschlich Organ-Slot T10 und wird von unten per AUFWAERTS-Push getrieben (`record_node_touch`) — muss aus den 19 heraus, per generischem `ObservableAxis`-Snapshot **pullen**, nie selbst gemessene Zeile sein (einzige latente Zyklus-Stelle) ⇒ **ABI-/Schema-Bruch mit Schema-Version, ZULETZT (Phase 6)**.
- **§E HW-Prefetcher (Z.121-144):** vier entkoppelte Formen; groesste Luecke **eytzinger wirbt mit Prefetch, prefetcht aber nicht** (`axis_03a_search_algo_eytzinger.hpp:70,76`) — der `2·k`-Voraus-Prefetch IST laut Khuong/Morin der gesamte Layout-Vorteil. Design: **Prefetch-Grad als ZWEI getrennte Unter-Achsen** — statische SW-Prefetch-SHAPE (NTTP-Mixin) + dynamische `prefetch_distance` (RC-Skalar); hw_prefetcher bleibt System-/Wurzel-Unter-Achse (MSR-Toggle um den Lauf). Vier Zirkularitaets-Sperren (Z.141-143).
- **§F Bau-Reihenfolge L0→L5 (Z.149-173):** Phase 0 Provider-Fundament (0.1 SIMD ✅ ce `8175c802`), Phase 1 Tag-Spreads, Phase 2 Prefetch-Unter-Achse, Phase 3 Hot-Path-Hebung, Phase 4 Skalar-Unter-Achsen, Phase 5 page_type, **Phase 6 telemetry-Root-Umbau zuletzt**. Jede Stufe = EIN Kadenz-Increment (Dossier → Selbst-Impl → adversarialer Review + Backup → doppelt-literal g++-16 → granulare Commits beide Remotes → CI strikt gruen).
- **§F.1 Re-Diagnose (Z.175-197):** Die Audit-Rahmung „Organe lesen `cache_line_size` aus axis_12" ist **widerlegt** — `cache_line_size()` ist **intrinsische Layout-Semantik** (packed_bitmap→8, aos_strict→1), aus axis_12 gespeist wuerde sie das Layout zerstoeren; `CacheLineAlignedMemoryLayout` ist konkrete Klasse in `AllLayouts = mp_list` ⇒ Templatisieren braeche die Permutations-Enumeration = **TABU**; axis_12 wird bereits korrekt auf Build-Variant-Ebene konsumiert. Rest (NUMA/Page→allocator) ist Neu-Verdrahtung, thesis-under-specified ⇒ **design-gated/GO-pflichtig**.
- **§F.2 Re-Diagnose Allocator-Adapter (Z.199-228):** Der Implementierungsversuch bricht an `abi_adapter.hpp:2176` — die **Zwei-Phasen-Op-Messung COW-kopiert das Such-Organ**; geloeschte Copy/Move ⇒ COW nicht konstruierbar, rebindender Copy-Ctor ⇒ **Stats-Doppelzaehlung, T6 korrumpiert**. Sauber nur mit **Tier-Level-Strategie-Besitz** = neue Architektur-Entscheidung ⇒ **GO-pflichtig**, Versuch vollstaendig revertiert. **Meta-Befund:** KEINES der verbleibenden Phase-0-Items ist ein punktuelles Refactoring; Phase 0.1 war das einzige sauber+GO-freie Item auf x86-prod1. **Hebel-A-Rest reklassifiziert als Fehldiagnose:** die `*_scan`-Kerne sind bewusst **strided Mess-Kerne, deren Zugriffsmuster DAS Achsen-Signal IST** — SIMD wuerde das Signal korrumpieren; kodifiziert als Interface-Freeze-Guard `tests/unit/test_striktheit_scan_kernel_purity.cpp`.
- **Nachtrag GO 3 (Z.243-263):** R1 gebaut (`comdare_apply_simd_extension_flags` + consteval-Kohaerenz-Guard + ADDITIVES `…_CHECKED`-Makro, Legacy-Makro und Golden-Pfad **byte-unveraendert**); R2 bewusst NICHT gebaut; R3 NEON/RVV offen (HW-/INFRA-gated). **golden-320/POD-1416/ABI-4/`permutation_axes.xml`/Codegen-Kanal byte-unberuehrt.**
- **§G (Z.269-279):** Realer Kurven-Fit + Voll-Messlauf = DATA-gated (#156/#215, mehrtaegig, **nie aktiv pollen**); arm64/gcc-15.3 = INFRA-gated; P/E-Core = HW-gated (prod2-RMA ~Sep). **Naechster Increment OFFEN** — Empfehlung: naechste Phase erst Ist-verifizieren, bevor sie als „punktuell" eingeplant wird.
- **Nachtrag R5 (Z.287):** Multi-Allocator-Permutation gehoert korrekt in die PRT_ART-/extension-Schicht; golden-320 permutiert die Allocator-Achse NICHT (allocator=std_malloc ×320); der 3-Stufen-Join via `PrueflingSlot` ist die kuenftige Mechanik dafuer; **`PrueflingSlot` nie hart verdrahtet**.

---

## (b) QUERSCHNITT — HARTE DIREKTIVEN UND VERBOTE

**Metaprogrammierung / Dispatch**
1. Compile-time-only Hot-Path: **CRTP + Concept-Guard, kein vtable, keine virtuelle Funktion im Hot-Path** (11_konzept §9 Z.601-608; KONSTRUKTIONSLOGIK Z.9-10, §1).
2. **Kein Runtime-Switch, keine Runtime-Registrierung, kein `std::variant` im Hot-Path**; Selektion via `mp_list`/`std::conditional_t`/`if constexpr` (11_konzept §9; TIER-Nachtrag R6 Z.416: `permutation_strategy_concept.hpp:10-11` verbietet Runtime-Tag/`std::variant`).
   → EINZIGE dokumentierte Ausnahme: 11_konzept §14.8 (concurrency-Thresholds, Switch nur zwischen Messreihen) — siehe Widerspruch W5.
3. **Concept-Verletzung MUSS den Build brechen** (`static_assert`/`requires`), nie Runtime-Check.
4. Pro Hierarchie-Ebene eigene Concepts; **genau EIN Concept-File pro Ordner/Unterordner**; Achsen-Concept leitet vom Topic-Concept ab (11_konzept RQ-1 Z.319-321).
5. **Mindestens 1 Algorithmus je Achse**, mp11-`static_assert`; CEB muss Achsen-Vollstaendigkeit VOR dem Build validieren (11_konzept §15.9 Z.1761-1789).
6. **Eine Achse wird NIE weggelassen** — nicht zutreffende Achsen bekommen ein konkretes `None`-Durchreich-Organ (TIER §4.4 Z.163-164).
7. **EIN Concept fuer Haupt- UND Unter-Achsen; eine Unter-Achse ist eine VOLL-Achse** (Doc 21 §A.5).
8. **Statisch und dynamisch fallen in einem Node-Spread NIE zusammen** (Doc 21 §A.1).

**Achsen-/System-Trennung**
9. **Organ-Achse, Mess-System-Achse und CEB-System-Achse NIE vermischen** (KONSTRUKTIONSLOGIK §0); System-Achsen brauchen eigene abstrakte Wurzel, getrennte Reflektion (`build_system_axis_levels()`).
10. **Anatomy-ABI ⊥ Observer/Subject-Schnittstelle** — Aufbau und Messung orthogonal, verbunden nur im AbiAdapter (TIER §2/§4.4; `idriveable_tier.hpp:6`).
11. **Meta-Achsen == System-Achsen == Wurzel**, Visitor + Strategy, nur **PULL** nach unten, nie Aufwaerts-Push (Doc 21 §A.2, §D L5).
12. **Governor/Prefetcher bleiben Tier-Binary-Achse, keine System-Achse** (KONSTRUKTIONSLOGIK §6).
13. **Cross-Genus-Permutation ist unmoeglich** — 5 getrennte Anatomien/Compositions/Observer/PermutationEngines (TIER §4.1).
14. **Eigene Gattung nur bei grundlegend anderem Basis-Achsen-Satz** — sonst Kategorienfehler (TIER §4.2).

**Prueфling / Bibliothek**
15. **cache-engine ist die Basis, prt-art die Ableitung** — erst nach CE migrieren, dann ableiten; prt-art hat NICHT die Hauptrolle (11_konzept §1, RQ-6 Z.348).
16. **cache-engine UND PRT-ART sind beide Bibliotheken, keine Lebewesen** (TIER §1, Fallstrick 5).
17. **Stufe-2-Regel: Pruefling ERSETZT pro Achse (kein Append), leere Achse ⇒ vollstaendiger Compile-Time-Fallback auf CE-Varianten**; Substitution in **genau EINE Achse**; `PrueflingSlot` **nie hart verdrahtet** (11_konzept §3.5; TIER-Nachtrag R11; Doc 21 Nachtrag R5).
18. **PRT-ART implementiert Ebene IV und konsumiert Ebene II — Ebene II/III sind CE-Eigentum** (11_axes §8).

**ABI / Mess-Vertrag**
19. **ABI-Major = 4**, Magic `".A4."`, 4 Pflicht-Symbole, Major-Match + Minor≤; `destroy` VOR `dlclose` (gleicher Heap) (KONSTRUKTIONSLOGIK §4e).
20. **Snapshot-POD flach, komposition-unabhaengig, memcpy-faehig; `sizeof==1416`, `alignof==8`; `axis_stats[19][8]` + `seg_ns[19]`; `kV3AxisSchema[19]` ist Single-Source Schreiber↔CSV** (KONSTRUKTIONSLOGIK §4d).
21. **Bindende Reihenfolge am Prueф-Dock: `import → GATE (std::map-Konformitaet) → messen`**; `accepts` matcht ueber die im Modul deklarierte Gattung, nie ueber Dateinamen (KONSTRUKTIONSLOGIK §4a).
22. **`IDriveableSubject` + `IResourceControllableTier` IMMER einkompiliert, auch Messung-AUS; `IObservableSubject` nur bei `COMDARE_MEASUREMENT_ON`** (TIER §4.4; KONSTRUKTIONSLOGIK §4c).
23. `dynamic_cast` genau 1× kalt je Modul, **nie im Hot-Loop** (TIER §4.4).
24. **Experiment-Dock eindimensional (Planer→CEB, kein Rueckkanal); Prueф-Dock bidirektional; Ergebnis-Rueckschrieb NICHT ueber das Experiment-Dock** (KONSTRUKTIONSLOGIK Nachtrag Z.374-377).
25. **`tier_*`→`subject_*`-Rename ist ABI-brechend** ⇒ Host + alle Prueflings-DLLs synchron + Major-Bump (TIER §6.6).

**Build / Vendoring**
26. **Vendoring-Doktrin: vendor → faithful → self-contained.** DLL self-linkt ihren Allokator (**Option B**); Host-`-rdynamic`/globale Symbol-Exposition ist verboten (KONSTRUKTIONSLOGIK §9).
27. **Kein CMake-Aufruf pro Permutation** — C++-orchestrierter Build (`BuildOrchestrator`); CMake nur fuer das ce-Basis-Target (11_konzept Nachtrag R4 Z.1900).
28. **Kein `#ifdef COMDARE_HAVE_*` in Wrapper-Klassen** — EIN Vendor-Shim mit Forward-Stubs + `static constexpr enabled` + `if constexpr` (W6-Pattern; 11_konzept §15.2/§15.8; KONSTRUKTIONSLOGIK §2).
29. **Hauptcompiler IMMER C++23; Bausteine-Internals mit Original-Compiler kompiliert und statisch gelinkt** (F-EXTRA-1, 05_uml Z.28/199).
30. **Registry-XML: ZWEI Registries gleichen Schemas (ce-SOTA + prt-art) + EINE referenzierende Experiment-XML**; constexpr-Sets aus Pre-Build-Codegen, nicht handkodiert (11_konzept Nachtraege R1/R5).

**TABU / Prozess**
31. **TABU ohne koordiniertes GO:** golden-320, `permutation_axes.xml`, POD-1416, ABI-Major 4, `GenusBindingTraits`, Registry-`mp_list`, `golden_fullpilot_320`, Codegen-Kanal (11_konzept R9 Z.1906; Doc 21 §F.1 Punkt 2, GO-3-Nachtrag).
32. **Doku nie loeschen — nur Banner/Deprecation** (05_uml Z.3; alle Nachtrag-Bloecke: "Originaltext bleibt unveraendert"); **Messdaten nie loeschen, ABI darf brechen** (Doc 21 §D).
33. **Neue Architektur-Entscheidung ⇒ anhalten, GO einholen** (Doc 21 §F.2, §G) — Ledger §0.
34. **Nie global „Tier" ersetzen**; erst Cluster ①-④ zuordnen; `TIER3` (ZIH) nie anfassen; Bio-Beinamen bleiben; Verifikation case-sensitive `\bTier` UND case-insensitive (TIER §5 Grundregel, §6, §10).
35. **Doppel-Verzeichnisbaum `topics/`(Stubs) + `axes/`(Impl): Sub-Achsen-Header in BEIDEN Baeumen nachziehen** (TIER §4.3, §6.8).
36. **Utilization-Pflicht:** honest-0/no-op ist ein Defekt (Utilization-Luecke), nicht ein akzeptabler Zustand (Doc 21 §A.7).
37. **Mess-Kern-Reinheit:** die `*_scan`-Kerne sind strided Mess-Kerne, deren Zugriffsmuster das Achsen-Signal IST — nicht „optimieren"/SIMD-isieren (Doc 21 §F.2 Meta-Befund + Freeze-Guard-Test).
38. **DATA-gated Messlaeufe nie aktiv pollen** (Doc 21 §G).
39. **Nur punktuelle Refactorings, kein Greenfield, CI strikt gruen je Increment**; Kadenz Dossier → Impl → adversarialer Review + Backup → doppelt-literale Verifikation → granulare Commits beide Remotes (Doc 21 Kopf + §F).

---

## (c) WIDERSPRUECHE ZWISCHEN (UND IN) DEN DATEIEN

**W1 — Achsen-Anzahl (der groesste Streuwert).**
13 (11_axes §2.1 Z.35-57 und §8 Z.210) · 14 (11_konzept Z.168, 188, 509) · 15 Topics (11_konzept §11.7.A) · 17 Topics/19 Achsen (TIER §4.3) · 19 T0-T18 (KONSTRUKTIONSLOGIK §1 Z.44-49) · 26 flache AxisLevels (KONSTRUKTIONSLOGIK §6 Z.216) · ~22 Haupt-Achsen (Doc 21 §C Z.57) · 29 Achsen (Doc 21 Kopf Z.5).
Aufloesung laut Nachtraegen: **kanonisch 19 statische Hauptachsen T0-T18 = `kV3AxisCount` / `kCompositionAxisNames`**; 11_axes-13 und 11_konzept-14 sind ausdruecklich als ueberholt markiert (11_axes Nachtrag R9 Z.347; 11_konzept Nachtrag R9 Z.1906). Die 26/22/29 sind andere Zaehlraeume (Registry-AxisLevels inkl. dynamischer + Build-only-Achsen bzw. Research-Zaehlung) und werden nirgends gegeneinander abgeglichen — **ungeloest**.

**W2 — Welche 19? TIER §4.3 vs. `kCompositionAxisNames`.**
TIER §4.3 (Z.139-143) gruppiert die 19 als traversal 3 / nodes 3 (page_type, path_compression, node_type) / hardware 3 (isa, simd_ext, general_hw) / queuing 2 und nennt „+3 Build-Achsen ⇒ historische 22". Die Code-Liste (KONSTRUKTIONSLOGIK Z.46-49) enthaelt **weder page_type noch simd_extension noch general_hardware**, dafuer index_organization, io_dispatch, migration_policy, filter. Zusaetzlich geht die Topic-Arithmetik in §4.3 nicht auf (17 Topics mit 4 Mehrfach-Topics ergibt 24, nicht 19). **Verbindlich ist die Code-Liste; TIER §4.3 ist an dieser Stelle unpraezise.**

**W3 — `topics/` mit Achsen direkt vs. Doppelbaum `topics/`+`axes/`.**
11_konzept §3 (Z.201) und §7 (Z.559): "**KEIN separates `axes/`-Verzeichnis**, Topics enthalten Achsen direkt". TIER §4.3 (Z.136-139) und alle Code-Anker in KONSTRUKTIONSLOGIK (`axes/prefetch_axis/…`, `axes/alloc/…`, `axes/axis_centric_namespaces.hpp`) belegen das Gegenteil: **`axes/` ist die echte Implementierung, `topics/` sind Forwarding-Stubs** (bewusste Migration V41.F.2). Der IST-Stand hat die 11_konzept-Entscheidung ueberholt; 11_konzept traegt dafuer **keinen** Deprecation-Banner.

**W4 — Pruefling-Slot: Ordner-Existenz und Namensgebung (dateiintern in 11_konzept).**
§3/§3.5/§7 (Z.303-311, 405, 585) fuehren `optional_prt_art_impl/` + `default_variants/` als Verzeichnisse; die User-Kommentare Z.313 („heisst am besten einfach `prt_art_impl` und ist Teil des prt-art-Projektes") und **RQ-9 Z.360 („Daher existiert weder `default_variants` noch `optional_prt_art_impl`. Es gibt die Cache Engine und den prt-art. Sonst nichts.")** widersprechen dem direkt; §11.8 Z.977-984 folgt der User-Antwort, §7 Z.585 und die RQ-9-Kurzform Z.576 („Ja, pro Sub-Achse eigene Slots (Vollausbau)") widersprechen ihr erneut. **Verbindlich ist die User-Antwort RQ-9/Z.313.**

**W5 — `std::variant` / Runtime-Switch.**
11_konzept §9 (Z.605) verbietet `std::variant` im Hot-Path; §14.8 (Z.1447-1494) erlaubt es explizit fuer 6 concurrency-Sub-Achsen und **hebt `[[no-runtime-switch]]` dort auf**; TIER-Nachtrag R6 (Z.416) und `permutation_strategy_concept.hpp:10-11` verbieten Runtime-Tag/`std::variant` generell; KONSTRUKTIONSLOGIK §6 (Z.227) wertet eine Runtime-vtable (`ISchedulingStrategy`) als Doktrin-Verletzung; Doc 21 §A.1 laesst dynamische Layer zu, aber als **eigene Achsen-Layer** (RC-POD), nicht als Variant-Switch. **Ungeloest:** ob §14.8 noch gilt oder durch das RC-POD-/Unter-Achsen-Modell abgeloest ist. Deutliche Tendenz: abgeloest (Doc 21 §A.5 nennt den „Laufzeit-Skalar" ausdruecklich eine Unter-Achse), aber nirgends explizit deprecatet.

**W6 — telemetry: Organ-Achse vs. System-Wurzel.**
11_konzept §11.7.A: telemetry = Topic mit Organ-Achse axis_11. TIER §4.3/§4.4: telemetry ist Teil der 19 und im POD `axis_stats[19]` verankert (Invariante). KONSTRUKTIONSLOGIK §6: telemetry ist heute Organ-Slot T10, **Modell verlangt CEB-System-Achse**. Doc 21 H7 + §D: telemetry muss **aus den 19 heraus** an die Wurzel — bewusster ABI-/Schema-Bruch, Phase 6. Zusaetzlich **dateiintern in Doc 21**: H7 sagt „Alle 19 Slots strukturell intakt … nicht durch Slot-Entfernung", §D sagt „telemetry aus den 19 heraus und ueber `axis_stats[19]` gehoben" — nur aufloesbar, wenn „intakt" sich auf die Layer-Platzierung, nicht auf die Slot-Zahl bezieht. **Kollidiert direkt mit der TABU-Liste (POD-1416/`kV3AxisCount`) und ist deshalb GO-/Schema-Versions-pflichtig.**

**W7 — Scheduling: drei unvereinbare Verortungen.**
11_axes §2.1: eigene Hauptachse 13 SCHEDULING-STRATEGY. 11_konzept W3/§11.7.A: **zerlegt in 7 Sub-Achsen je Topic, kein eigenes Subsystem, `c11_scheduler_engine` aufgeloest** (Z.946). KONSTRUKTIONSLOGIK §6: Scheduling soll **CEB-System-Achse, compile-time statisch** werden; Ist = verwaiste Runtime-vtable. In `kCompositionAxisNames` kommt Scheduling gar nicht vor. **Ungeloest.**

**W8 — Measurement: Achse oder Infrastruktur.**
11_axes §2.1 listet „10 MEASUREMENT" als Ebene-I-Achse (und §3 Z.138 ordnet ihr C5/F26-F29 zu). 11_konzept RQ-5 (Z.343): Messung ist **keine** Achse der Suchalgorithmus-Permutation, sondern Experimentier-Struktur/CEB-Domaene (`src/`, ggf. `comdare-measurement`-Submodul). §14.5 (Z.1384-1403) macht die Mess-**Strategie** dann doch wieder zu einem Permutationsfaktor (CMake-waehlbar). Doc 21 stellt das Mess-System an die Wurzel (System-Achse). **Drei Lesarten; die 11_axes-Lesart ist die aelteste und faktisch ueberholt.**

**W9 — Hardware/ISA: Achse vs. Build-Variant.**
11_konzept: Topic `hardware` mit axis_09 ISA + axis_12 general_hardware (+ axis_topologie). `kCompositionAxisNames` kennt nur `isa`; simd_extension/general_hardware sind `DefinitionOnly`-Build-Achsen NEBEN der Komposition (KONSTRUKTIONSLOGIK §6 Z.226). Doc 21 §F.1 widerlegt zusaetzlich die Annahme, Organe muessten `cache_line_size` aus axis_12 lesen. **Aufloesung: hardware ist teils Organ-Achse (isa), teils Build-Achse — 11_konzept unterscheidet das nicht.**

**W10 — CEB-Bau-Mechanik: CMake pro Permutation vs. C++-Orchestrierung.**
11_konzept §15.7/§15.10 (Z.1712-1822) spezifiziert `std::system("cmake -B build/perm_<hash> …")` je Permutation. Nachtrag R4 (Z.1900) markiert genau das als ALT/doktrin-widrig. KONSTRUKTIONSLOGIK §9 zeigt, dass **beide Pfade real existieren** und dass der doktrin-konforme (Laufzeit-`make_gpp_compile_fn`) genau derjenige ist, der **kaputt** ist (kein Link-Kanal), waehrend der ALTE CMake-Pfad funktioniert. **Aktiver, unaufgeloester Bruch — Fix = Option B.**

**W11 — 05_uml_klassen ist durchgaengig gegenlaeufig zur heutigen Doktrin.**
CacheEngine als **Singleton** mit `call_once` (Z.74-86) vs. heutige Composition/Anatomy/AbiAdapter-Architektur ohne prozessweiten Singleton; **`std::variant`-ValueHandle (F8, Z.29)** vs. Variant-Verbot; Observer-**Push** (F2) vs. Doc-21-Pflicht „nur PULL"; `IDecisionLambdaTree` pro Baustein vs. compile-time-Strategy. Formal durch den SUPERSEDED-Banner (Z.3) entschaerft, aber die Datei wird an mehreren Stellen (11_konzept §11.4, RQ-5 Z.343 „bitte praezise die drawio Detail UML nachlesen") noch als Referenz zitiert ⇒ **Zitier-Falle**.

**W12 — 3-Schichten-Vererbung vs. Ist-Architektur.**
11_konzept §11.4 (Z.738-759): `CacheEngine ← execution_engine ← search_engine ← prt_art` mit Pflicht-Durchreichung. KONSTRUKTIONSLOGIK kennt statt dessen `IAnatomyBase : IExecutionEngine` + Composition/Anatomy/AbiAdapter und `SearchAlgorithmAnatomy<Composition>`; eine `search_engine`-Erbschicht ueber `execution_engine` taucht nicht auf. **Nicht abgeglichen** (vgl. auch 11_konzept §12 D.1 „IExecutingEngine-Wurzel fehlt").

**W13 — Prueфling als „Lebewesen" (dateiintern TIER).**
§1 (Z.34-41) + Fallstrick 5 (Z.258): PRT-ART ist eine **Bibliothek, kein Lebewesen**. §3.1 (Z.77) + Anhang 6 (Z.289-290): „Prueфling = PRT-ART, ein **abstraktes Lebewesen**". Auflösbar (Bibliothek als Katalog vs. Prueфling als abstrakte Achsen-Belegung), aber sprachlich kollidierend — bei Zitaten praezisieren.

**W14 — Doku-Status vs. Realitaet: „SKIZZE" mit bindenden Entscheidungen.**
11_konzept traegt Kopf-Status „SKIZZE zur User-Abstimmung", enthaelt aber die verbindlichen User-Antworten zu Fragen 1-4 und RQ-1..RQ-15 sowie die finale Topic-Liste. Doc 21 nennt sich „bindender Bauplan" und ersetzt Teile von Doc 20. TIER nennt sich „AUTORITATIVE GRUNDLAGE". KONSTRUKTIONSLOGIK nennt sich explizit nicht-entscheidend, ist aber die einzige code-verifizierte Ist-Quelle. **Praktische Rangfolge fuer Konflikte: (1) User-Direktive/Ledger, (2) KONSTRUKTIONSLOGIK fuer IST + Code-Anker, (3) Doc 21 fuer den Bauplan/Zielbild, (4) TIER fuer Begriffe/Landkarte, (5) 11_konzept fuer Pattern-Herkunft, (6) 11_axes fuer Ebenen-Disambiguierung, (7) 05_uml nur historisch.**