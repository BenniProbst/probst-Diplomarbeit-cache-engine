# DOSSIER 17 — E4-XML-Vollvision: Strategische Roadmap (#229)

> **Status:** Planungs-Dossier zur Freigabe (2026-07-09). Synthese aus der User-Vision 09.07. ([[feedback_e4_xml_autoritative_bauanleitung_ceb_orchestriert]]) + drei Thesis-verankerten Explore-Kartierungen (Backup `docs/sessions/backups/20260709-e4xml-vollvision-kartierung/`). Baut auf `16_E1_E4_KONSOLIDIERUNG_DOSSIER.md` (genehmigt). Belege `datei:zeile`; Thesis = `thesis/diplomarbeit/kapitel/de/`, ce = `Code/external/comdare-cache-engine`, mod = `/home/comdare/Projekte/Modules/comdare-measurement-all`.

> ---
>
> ## ⚠️ STAND 2026-08-07: DIESES DOSSIER IST IN SEINEN BELEGSTELLEN VERALTET
>
> **Der Inhalt (Vision, Phasen-Schnitt, Gate-Denken) gilt weiter. Die `datei:zeile`-Belege und der
> Fortschritts-Stand nicht.** Dieses Dossier hat am 07.08. nachweislich einen Fehlbefund erzeugt:
> ein Prüf-Agent las die Phase-4-Zeile, suchte an den genannten Pfaden, fand dort nichts Produktives
> und meldete „nicht verdrahtet" — obwohl die Kette seit Wochen geschlossen ist. **Wer hier liest,
> muss zuerst den Ist-Stand am Code prüfen.**
>
> **Was sich seit dem 09.07. geändert hat:**
> | Aussage im Dossier | Ist-Stand 07.08. | Beleg |
> |---|---|---|
> | „ABI-MAJOR==4" (TABU-Zeile) | **8** (Minor bereits auf 1) | `anatomy_module_abi_v1_decl.hpp:89` |
> | „eingesperrt im `tests/unit/thesis_tiere/`-Harness" | nach `libs/cache_engine/profile_facade/` **gehoben** („P0-Hebung") | `cmake/catalog_codegen.cmake:71` |
> | `CatalogAxes<4,4,5,4>` = 320 | **18 Achsen**; `FullSourceCatalog` = 2^17 = 131.072 (golden-REFERENZ), `golden_320_catalog` = benannter Alias (messdaten-erhaltend) | `source_catalog.hpp:139-144` |
> | `main.cpp:513-521` (Andockpunkt Phase 1) | existiert nicht mehr; produktiver Aufrufer ist **super** `Code/02_messung_driver/main.cpp:1256`/`:1351` | dort |
> | `source_catalog.hpp:83-116` (Andockpunkt Phase 4) | Zeilen verschoben, Datei umgezogen | `libs/cache_engine/profile_facade/source_catalog.hpp` |
>
> **Phasen-Vollzug (am Objekt geprüft, 07.08.):** Phase 1 **erledigt** · Phase 2 **erledigt** (5 statt 4
> RC-Pfade) · Phase 3 **erledigt** (null lebende `search_organ_`-Deklarationen) · Phase 4 **erledigt
> und härter gebaut als geplant** (s.u.) · Phasen 5–8 unverändert offen.
>
> **Phase 4 im Detail — die Kette ist geschlossen:**
> 1. `libs/cache_engine/profile_facade/profile_run_entry.hpp:29` inkludiert `generated_source_catalog.hpp`
>    („Basis-320-Quelle") — die **produktive Fassade** konsumiert den generierten Katalog.
> 2. `libs/cache_engine/profile_facade/CMakeLists.txt:120-121` hängt `comdare_attach_generated_catalog`
>    an **`comdare_profile_run_facade`** — die Bibliothek, nicht ein Test-Target. (Der Aufruf steht in
>    einem `cmake_language(DEFER ...)`; **eine naive Suche nach dem Funktionsnamen in `tests/` findet
>    ihn nicht** — genau daran ist der Fehlbefund entstanden.)
> 3. `super/Code/02_messung_driver/CMakeLists.txt:30` linkt `comdare::profile_run_facade`; `:48` macht
>    ihr Fehlen zum `FATAL_ERROR`.
>
> **Über den Plan hinaus gebaut:** `source_catalog.hpp:192-212` trägt den **GN-2/§26.6-Guard**, der die
> Entkopplung **compile-time erzwingt** statt sie zu konventionieren —
> `kMaxMaterializableCatalogCardinality = 4096`, zwei `static_assert`s schließen die 2^17-Vollform
> aus und lassen die 320-Basis zu. Damit ist auch das Risiko „Compile-Explosion" der
> Limits-Entkopplungs-Analyse (§3) geschlossen. **Eine Anhebung der 4096-Grenze braucht einen
> Compile-Feasibility-Bauplan — „KEIN stilles Hochdrehen" (`:203`).**
>
> **Die zugehörige Analyse** `docs/audits/20260710-schicht-e3-impl-LIMITS-ENTKOPPLUNG-ANALYSE.md` ist
> aus demselben Grund historisch: ihre Pfade zeigen durchgehend auf `tests/unit/thesis_tiere/`.
> Ihr **Gate-Plan §4** ist inhaltlich erfüllt (Stufen 1–3 mit adversarialem Review am 10.07.,
> Stufen 4–6 im Bestand).
>
> **Namensraum-Warnung:** die Phasen 1–8 dieses Dossiers sind **NICHT** die Phasen 1–7 des
> `20260803-FAHRPLAN-gesamtkette-wellen-phasen.md` und **NICHT** die Phasen aus Dossier 16
> (`16_E1_E4_KONSOLIDIERUNG_DOSSIER.md:197-199`, dort ist „Phase 4" = #31). Drei getrennte
> Zählkreise. Sprachregelung: **„XML-Phase n"** (dieses Dossier) · **„Fahrplan-Phase n"** ·
> Dossier-16-Phasen (historisch).
>
> ---

## TEIL A — DIE VISION & DER ZENTRALE STRATEGISCHE BEFUND

**User-Vision (09.07., bindend):** Die XML ist die **autoritative Bauanleitung des gesamten Versuchsaufbaus**. Sie treibt (1) die **Limits der 19 statischen Hauptachsen** → welche Tier-Binaries entstehen (E3/E2), (2) deren **dynamische Unter-Achs-Konfigurationen** (RC-Laufzeit, E1), (3) **gegen ein paralleles Achsen-Messsystem** (separate System-Achsen mit eigenen Abstractions, M). Der **CacheEngineBuilder liest die XML zu seiner Laufzeit und lässt die Tier-Binaries kompilieren / orchestriert ihren Aufbau** (E4→E3→E2). Workload = **eigene Bibliothek-Kategorie** (dutzende Frameworks × Workloads, nicht YcsbWorkload A–F).

Das ist **#229 in Vollform** — die ZIEL-Invariante ist thesis- und dossier-verankert (`docs/sessions/20260628-KONTEXT-DOSSIER-…md:399`): *„die Diplomarbeit ändert NUR die XML (Ebene 4) — die Mess-Pipeline (CacheEngineBuilder) übernimmt den Rest vollautomatisch (compile → XML-Interpret → Tier-Binaries → RC-Config → Messauswertung)."*

**DER ZENTRALE BEFUND (ändert die gesamte Strategie):** Die #229-Maschinerie ist **bereits zu ~80 % gebaut**. Die volle Kette läuft real und golden-getestet — **aber eingesperrt im `tests/unit/thesis_tiere/`-Harness und auf den hartkodierten golden-320-Typraum begrenzt.** Die Roadmap ist deshalb **kein Neubau, sondern Andocken + Entkoppeln + Auffüllen**. Das ist die gute Nachricht und die Leitlinie aller Phasen.

## TEIL B — KARTIERUNG: SOLL (THESIS) vs. IST (CODE)

### B.1 Die XML-autoritative CEB-Bauorchestrierung (der Kern) — „gebaut, aber nicht angedockt"

**Drei getrennte, nicht vereinigte Bau-/Mess-Systeme:**
- **System 1 — `messung_driver` (produktiver Lauf, super `Code/02_messung_driver/main.cpp:218-408`):** lädt **VORGEBAUTE** Plugins aus `perm/` und microbenchmarkt sie — kein Compile, keine XML-Enumeration, keine 19 Achsen. Danach A/B/C via `ExperimentDriver` (`:447-535`). Die erwarteten `cache_engine_permutations.xml`/`search_algorithm_permutations.xml`/`allocator_permutations.xml`/`test_data_sets.xml` (`:151-164`) **existieren nicht** (Schema-Mismatch — vorhanden sind `config_a/b/c.xml` `<comdare_experiment>` + `messreihen.xml`).
- **System 2 — `ExperimentDriver` (Pfad A, ALT, `ce libs/cache_engine/builder/experiment_driver/experiment_driver.cpp:93-137`):** `XmlConfigParser::parse(config_dir)` → **~4-Faktoren-Kreuzprodukt** (`:113-118`), **KEINE 19-Achsen-Anatomie**. `phase3_compile` (`:266-295`) ruft `cmake` zur Laufzeit via `std::system` — Runtime-Compile, aber über die **alte** `CodegenEngine`, nicht die Anatomie. Parser = Regex-Skelett (`xml_config_parser.cpp:1-2`). `apps/cache_engine_builder/main.cpp` = dünner Wrapper darum.
- **System 3 — der 19-Achsen-Anatomie-Bau (EXISTIERT, vollständig, TEST-ONLY):** die vom User beschriebene Kette, real + golden-getestet:
  1. **Autoritative XML** `ce …/algorithm_profiles/thesis_profiles/m3v2_study.profile.xml`: `<base_tiers>`, `<permute_axes>` mit **allen 19 Slots T0–T18** (`:38-72`, 4 variiert / 15 gepinnt), `<axis_sweeps>`, `<sota_series_set>`, `<compile_dims>` (`:128-131`), `<runtime_dynamic>` (`:135-138`, thread_count/hw_prefetcher), `<run_options cap="320">` (`:145`), `<modes>`, `<static_axes>`.
  2. **Parser** `parse_thesis_profile` (`xml_config_parser.cpp:199-296`) → `ThesisProfile`.
  3. **XML → 19 Achsen-Limits** `profile_to_tree.hpp:25-89` `build_axis_levels`: `permute_axes` → **statische** `AxisLevel` (Binary-Identität); `runtime_dynamic` → **dynamische** Ebenen (verändern binary_id nicht).
  4. **`StaticBinaryView`** (lazy mixed-radix Odometer, `experiment_tree.hpp:235-324`, `binary_count()` = ∏ arithmetisch) → **`BuildSelection` S1/S2/S3** (`coverage_selection.hpp:37-89`: full / 1-wise / explicit-pinned).
  5. **`BuildOrchestrator::provision_all`** (`build_orchestrator.hpp:171-349`): multithreaded, RAM-Admission, resumierbar, realer `cl`-Subprozess = Thesis-„Pfad B" (`04_implementierung.tex:150-158`).
  6. **1 DLL je Permutation** `adhoc_emitter.hpp:83-108`: `COMDARE_DEFINE_ANATOMY_MODULE_ADHOC(<19 FQ-Achsen>)`.
  7. **Eintritt läuft real** `run_lazy_150.cpp:108-284` → `run_profile` (`profile_run_entry.hpp:104-172`). (run_lazy_150.cpp geloescht 2026-07-11; Eintritt heute profile_facade/profile_run_entry.hpp)

**Die drei Blocker für #229:**
1. **Kein Produktiv-App dockt an** (größte Lücke, = **#230**). `run_profile` wird nur von Test-Harness + Lib-Primitiven referenziert; `messung_driver` triggert es NICHT (obwohl `profile_run_entry.hpp:2-4` genau das behauptet).
2. **Achsen-Limits hartkodiert** statt XML-getrieben: `source_catalog.hpp:83-116` `CatalogAxes<4,4,5,4>=320` fest; XML-`permute_axes` muss byte-genau zur `mp_take_c`-Golden-Reihenfolge passen (`golden_fullpilot_320_binary_ids.txt`). Die XML kann heute nur **innerhalb** golden-320 treiben.
3. **String→Typ nur pilot-abgedeckt** (`pilot_source_map.hpp:2-17`, kein Runtime-Switch, hartkodierte Engine, umbrella-schwer/test-scoped).

### B.2 Framework × Workload-Bibliothek — „YCSB-only, Struktur fehlt"

- **Soll (Thesis):** 13-Framework-Katalog (`tab:wl-frameworks`, `03_messsystem_prtart.tex:248-270`) → destilliert zu **14 kanonischen Lastprofilen LP01–LP14** (uint64-Op-Modell, `tab:lp-catalog`, `:272-304`) + 30 SOTA-Profile mit `expected_workload` + 6-Kanon + 3 Granularitäten. **Abstraktion, nicht dutzende Binaries.**
- **Ist:** nur YCSB A–F (3 parallele Enum-Orte); **0/14 LP-Profile**; **2/~8 Loader** (sosd_uint64, string_corpus); 6-Kanon deckungsgleich (4/6 akten-verifiziert); measurement-all-Zelle `comdare-workloads` YCSB-only mit **leerer** Loader-Registry; Dataset-Parser-Bruch (`test_data_sets.xml` 3 Einträge ↔ `*.test_data.xml` 6-Kanon nicht verdrahtet).
- Volldetails: Backup `BAUSTEINE-agent1-2.md` (Baustein 1).

### B.3 Paralleles Achsen-Messsystem — „fragmentiert, nicht zusammengeführt"

- **Klärung:** „Mess-Achse" ist dreifach belegt; die Vision zielt auf die **Mess-Kategorien-Taxonomie** (CLU, Cache-Miss L1/L2/L3, dTLB, Branch, IPC/CPI, Latenz, Durchsatz, Energie), orthogonal zu den 19 Algorithmus-Achsen.
- **Soll (Thesis):** 9-Kategorien-Katalog + observer/PMC-Zweiteilung + Zwei-Regime-Orthogonalität (`03_messsystem_prtart.tex:382-386`, `06_evaluation_methodology.tex:110-126`).
- **Ist:** `MeasurementCategory`-Enum (16, **isoliert**), `Measure<Cat,Detail>` (~leer), `IPmcSource` (7 Counter, schmal), `ComdareMeasurementSnapshotV1` (16+6-POD), `ObserverAggregate<19>`/`kV3AxisSchema`. **Fehlt:** vereinheitlichte `IMeasurementSource`, Mess-Achsen-Registry, Pipeline-Verdrahtung, **`<measurement_categories>`-XML-Element (0 Treffer)**.
- Volldetails: Backup `BAUSTEINE-agent1-2.md` (Baustein 2).

## TEIL C — ARCHITEKTUR-ENTSCHEIDUNGEN (zur User-Bestätigung)

- **C.1 — „Bibliothek-Kategorie IN der cache-engine":** wird als **Laufzeit-Workload-Bibliothek in `measurement-all/comdare-workloads`** realisiert, die die ce **konsumiert** (Runtime-`AxisLevel`{workload,`is_static=false`} + ABI-Descriptor `comdare_workload_descriptor_v1`), **NICHT** als compile-time-Insel in der ce-Library — Letzteres war der eben revertierte #31-Fehlbau. Empfehlung: **bestätigen** (thesis- + G2-konform). *Falls du bewusst eine ce-interne compile-time-Kategorie meinst, bitte melden — das würde den G2-Revert-Grund berühren.*
- **C.2 — „dutzende Frameworks × Workloads":** thesis-konform als **13-Framework-Katalog (Daten/Doku) + 14-LP-Achse (gefahren) + Loader-Anbindung**, nicht als dutzende einzeln implementierte Benchmark-Binaries. Empfehlung: **bestätigen**.
- **C.3 — Achsen-Limits-Entkopplung berührt golden:** Phase 3 (unten) löst `CatalogAxes<4,4,5,4>` von der Hartkodierung. Das ist der heikelste Schritt (golden_fullpilot_320 + ABI). Vorgehen: **golden-Roundtrip als Regressionsgate bleibt**, Entkopplung additiv/default-golden-erhaltend; **kein ABI-Bump ohne separates GO**.

## TEIL D — STRATEGISCHE ROADMAP (geordnet nach kritischem Pfad + Abhängigkeiten)

| Phase | Inhalt | #-Nummer | Kern-Andockpunkt | Gate |
|---|---|---|---|---|
| **1 Produktiv-Andockung** | ✅ VOLLZOGEN (07.08. am Objekt geprüft; Aufrufer in super, nicht ce apps/) —  `run_profile` aus Test-Harness in produktive Lib/App heben; `messung_driver` ruft es statt/neben `ExperimentDriver` → die #229-Kette läuft produktiv (auf golden-320) | **#230** | `profile_run_entry.hpp:104` → `main.cpp:513-521` | ctest + golden-Roundtrip==320 |
| **2 RC-Dynamik-Vollendung** | ✅ VOLLZOGEN (5 statt 4 RC-Pfade, `abi_adapter.hpp:437-498`) —  4 fehlende RC-Setter; `runtime_dynamic`-XML-Achsen (thread_count/hw_prefetcher) real an `ComdareResourceControlV1` verdrahten; Hard-Gate vor #156 (Phantom-Zeilen) | **#221** | `abi_adapter.hpp:239`, `experiment_tree.hpp:136-155` | RC-Konsum-Test |
| **3 Achsen-Uniformität** | ✅ VOLLZOGEN (null lebende `search_organ_`-Deklarationen) —  `search_organ_`-Monolith tilgen → Lebewesen routen uniform durch node_type/memory_layout (Apparat-Artefakt vs. Signal) | **#188** | `CE/34:156-164`, ce Dossier §17 | ctest je Familie |
| **4 Limits-Entkopplung** | ✅ VOLLZOGEN + GN-2-Guard darüber hinaus —  `CatalogAxes<4,4,5,4>` → aus `ThesisProfile.permute_axes` ableiten; XML treibt die Limits WIRKLICH (nicht nur innerhalb golden-320); `adhoc_emitter`-PilotEngine → XML-Achsenliste | **#229-Kern** | `source_catalog.hpp:83-116`, `apps/adhoc_emitter/main.cpp:139` | golden-Roundtrip als Gate (C.3) |
| **5 Framework×Workload-Bibliothek** | `comdare-workloads` (measurement-all): Framework-Registry (13) + 14-LP-Katalog + konkrete Loader (TPC/SPEC/CloudSuite/mimalloc-bench) + 6-Kanon-Akten; Dataset-Parser-Bruch heilen | **#31/F7** | `dataset_loader.hpp:59-85`, `15_F7…md` | measurement-all gated Schritt 13 |
| **6 Paralleles Mess-System** | vereinheitlichte `IMeasurementSource` (vendor-neutral) + `<measurement_categories>`-XML + Verdrahtung Prüf-Dock → POD (4. orthogonale Dimension) | neu (M) | `20260531-mess-abstraktion…:81-135`, `SCHEMA.md` | ctest + PMC-honest-0 |
| **7 Parser-/Gating-Konsolidierung** | `XmlConfigParser`-Vereinheitlichung (2 Reader → 1), `COMDARE_EXPERIMENT_MODE` verdrahten, 4-Datei-Schema bereinigen, `#223` E3-Gate re-verifizieren | #223 | `xml_config_parser.cpp:70-296` | Gate-Regression |
| **8 Voll-Lauf** | 320-DLL-Neubau + XML-getriebener Voll-Messlauf | #215 → #156/#162 | Pipeline 286 | **gated/mehrtägig, Cluster** |

**Sofort-Block-Empfehlung:** **Phase 1 (#230)** ist der größte Hebel (Maschinerie ist da, Freeze-GO erteilt) → dann **Phase 2 (#221)** (vom User bestätigt). Phase 3–7 als geordnete Increments; Phase 8 gated. **Phase 1 + 2 sind non-gated** (golden-neutral, additiv, Freeze-GO liegt vor).

## TEIL E — KADENZ · GATES · DIREKTIVEN

- **Metaprogrammierung:** compile-time only im Hot-Path (kein Runtime-Switch — `pilot_source_map` bestätigt: String→Typ nur compile-time); die Achsen bleiben CRTP+Concept; W/D/M bewusst runtime (E4/E1) = korrekte Grenze.
- **TABU ohne separates GO:** `permutation_axes.xml`, `golden_fullpilot_320`, POD `sizeof`, `GenusBindingTraits`, ABI-MAJOR. **[STAND 07.08.: ABI-MAJOR ist 8, nicht 4 — der hier genannte Wert 4 ist der Stand vom 09.07.]** Phase 4 (Limits-Entkopplung) berührt den golden-Raum → golden-Roundtrip==320 als Pflicht-Gate, kein ABI-Bump ohne GO. **[STAND 07.08.: Phase 4 ist VOLLZOGEN; die Entkopplung ist zusätzlich compile-time durch den GN-2/§26.6-Guard erzwungen.]**
- **Freeze:** main.cpp-V31.F-Freeze für die E4-XML-Verdrahtung **aufgehoben** (User-GO 09.07.).
- **Verifikation je Increment:** fresh-context-Kartierung → manuelle Umsetzung → Voll-Review → Mojibake-grep==0 → clang-format-dry-run==0 → doppelt-literal (g++-16 + eigener Lauf) → golden-Roundtrip==320 wo berührt → granularer Commit (nie `git add -A`) → beide Remotes → CI STRIKT GRÜN.
- **Backups:** jeder Analyse-Lauf → `docs/sessions/backups/` (fortlaufend).

*Nach Freigabe: dieses Dossier wird die autoritative E4-XML-Roadmap; Umsetzung phasenweise, je eigener Increment mit CI-Gate.*

## Nachtraege — E2E-Re-Audit 2026-07-15 (Ausrichtung an §0-GOAL-V5 / erweiterte A-H-Architektur)

> Additive Ausrichtungs-Vermerke; der Originaltext oben bleibt unveraendert (Doku nie loeschen).

- **[R9 · Anker docs/architektur/17_E4_XML_VOLLVISION_ROADMAP.md:71]** Keine inhaltliche Änderung nötig — das R9-TABU (golden-320, POD sizeof, ABI-MAJOR==4, GenusBindingTraits, permutation_axes.xml) ist gewahrt, inklusive golden-Roundtrip==320 als Pflicht-Gate gerade bei der heikelsten Phase 4 (Limits-Entkopplung). Optionale additive Präzisierung: POD sizeof==1416 explizit statt nur „POD sizeof" benennen; die doc-interne Phasen-Nummern-Diskrepanz (C.3 :51 „Phase 3 löst CatalogAxes" vs. Roadmap-Tabelle :60, die die Limits-Entkopplung als Phase 4 führt) berührt R9 nicht, ließe sich bei der Klarstellung aber mitglätten.  
  *(Bezug: R9-TABU golden-320/POD/ABI-4/GenusBindingTraits/permutation_axes.xml gewahrt, golden-Roundtrip==320 als Pflicht-Gate der Phase 4.)*
- **[R1 · Anker docs/architektur/17_E4_XML_VOLLVISION_ROADMAP.md:18]** Additiv festhalten: Die kanonische ZWEI-Registry-Architektur (ce-Registry SOTA + prt-art-Registry, identisches Schema) ist die alleinige Ablage der Bausteine je Achse — sie liegen AUSSCHLIESSLICH dort. Das bisher als autoritativ geführte m3v2_study.profile.xml sowie das Alt-4-Datei-Schema (config_a/b/c.xml + messreihen.xml) additiv als Vorläufer deprecaten (nicht löschen). Phase 7 (Parser-Konsolidierung) darauf umlenken — nicht nur „2 Reader → 1", sondern hin zu R3 (Parser = Modul in ce xml_config_parser + v32→Strategy-Pattern) und R2 (EINE Experiment-XML referenziert die 2 Registries, listet selbst keine Bausteine).  
  *(Bezug: Doc kennt nur eine autoritative Profil-XML, nicht die 2-Registry-Architektur — R1 unabgedeckt.)*
- **[R2 · Anker docs/architektur/17_E4_XML_VOLLVISION_ROADMAP.md:7]** Additiv die Ziel-Struktur dokumentieren, die der (R2-konformen) Vision in :7 konkrete Form gibt: EINE Diplomarbeit-Experiment-XML als 3-Phasen-Prüf-Vorlage (Phase 1 prt-art / Phase 2 cache-engine / Phase 3 3-Stufen-Join), die die Registries referenziert, KEINE Bausteine listet und Familie A (comdare_thesis_profile) mit Familie C (messreihe_v32) vereint; das getrennte Alt-Schema (config_a/b/c + messreihen) additiv deprecaten. Der Vermerk gehört sachlich in TEIL B/D (IST-Kartierung + Phase-7-Schritt „4-Datei-Schema bereinigen"), mit Querverweis auf Ledger §15.1–15.2 / INC-C-H als ablösende Unified-Experiment-XML-Architektur.  
  *(Bezug: :7 ist die R2-konforme Vision; die konkrete 3-Phasen-Ziel-XML + Familien-Vereinigung A+C fehlt doc-weit.)*
- **[R4 · Anker docs/architektur/17_E4_XML_VOLLVISION_ROADMAP.md:25]** Additiv CEB explizit als das zentrale C++-Experiment-Framework benennen, das ALLE XML-Parser hält, Prüfdock + Messsystem trägt und die Diplomarbeit-Code-Generatoren (PDF/Excel) optional als Bibliothek aufnehmen kann; den System-2-cmake-Laufzeit-Compile-Pfad final als deprecated markieren. Sparsam umsetzen als Deprecation-/Querverweis-Zeiger von Dossier 17 auf Ledger §15.1 (dort liegt die autoritative, bindende CEB-zentral-Formulierung von R4), statt die volle Architektur hier zu wiederholen.  
  *(Bezug: cl-Subprozess-Orchestrierung ist R4-konform, aber CEB als Gesamtkonsolidierung im Roadmap-Ziel nicht formuliert.)*
- **[R11 · Anker docs/architektur/17_E4_XML_VOLLVISION_ROADMAP.md:55]** Additiv eine eigene Roadmap-Phase „prt-art-Andockung + 3-Stufen-Join" aufnehmen: Stufe 1 (CE-Permutationen, comdare_perms_ce) / Stufe 2 (Prüfling ersetzt, comdare_perms_<pruefling> mit Fallback) / Stufe 3 (A join B), Regel der abstrakt-leeren Achse mit compile-time-Substitution des PrueflingSlot in genau EINE Achse und Reuse ALLER CE-Algorithmen, plus prt-art-Registry-XML nach R1b, durchweg gegen SOTA getestet. Keine der acht bestehenden TEIL-D-Phasen adressiert prt-art als separaten Prüfling (R5).  
  *(Bezug: Roadmap deckt weder den 3-Stufen-Join aus pruefling_merge.hpp noch prt-art als eigenen Prüfling ab.)*
- **[R10 · Anker docs/architektur/17_E4_XML_VOLLVISION_ROADMAP.md:42]** Additiv die drei kanonischen Mess-Modi in Phase 6 vollständig aufnehmen: (1) Lebewesen-Wall-Clock, (2) Per-Achsen-Observer (bereits erfasst), (3) Achsen-Vergleich gegen std::map (entscheidet die Achsen-Güte), dazu Makro/Mikro je Achse und die xml→pdf-Kette (Code 01–09, \InputIfFileExists honest-empty) für die Thesis-Anhänge. Es ist eine Vollständigkeitslücke der Phase 6 dieses Planungs-Dossiers (Primärquelle spezifiziert die 3 Modi vollständig, :43 referenziert sie, Modus 3 über :18 teils erreichbar) — nicht droppbar, weil xml→pdf-Kette und Makro/Mikro-Granularität doc-weit gänzlich fehlen.  
  *(Bezug: Doc erfasst nur Modus 2; Wall-Clock, std::map-Vergleich und xml→pdf-Kette fehlen.)*

---

### → §59 KERN-Mess-Schema (2026-07-20)

> Additiver Querverweis (kein Duplikat). Die E4-XML-Vollvision dieses Roadmap-Dossiers ist die KERN-Mess-Schema-Steuerung (Ledger §59): die XML wirkt als **negatives Blacklisting** auf die Voll-Whitelist und steuert Messmodi · per-Achse `merge`/`replace` · *welcher* Prüfling (Variablenname ODER statisch `"CacheEngine"`) · per-Achse Algorithmus-Whitelist · ODER Template laden (`mode=full`; benanntes `<template>` additiv) + je Achse `restrict`/`extend`. Die hier geforderte „prt-art als eigener Prüfling"-Roadmap-Phase generalisiert sich zu beliebigen Prüflingen (Paper-als-Prüfling = post-v3). Volle Fassung: **Ledger §59**.
