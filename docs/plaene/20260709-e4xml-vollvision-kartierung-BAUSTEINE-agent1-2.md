# E4-XML-Vollvision — Kartierungs-Bausteine (Agenten 1+2), 2026-07-09

> Read-only Explore-Kartierungen gegen Thesis-LaTeX (`thesis/diplomarbeit/kapitel/de/`) + Code-Ist.
> Grundlage für das strategische Roadmap-Dossier. Agent 3 (CEB-XML-Bauorchestrierung) folgt.
> Wurzeln: super = probst-diplomarbeit-cache-engine, ce = super/Code/external/comdare-cache-engine,
> mod = /home/comdare/Projekte/Modules/comdare-measurement-all.

## BAUSTEIN 1 — Framework × Workload-Bibliothek

### Soll (Thesis) — Abstraktion, NICHT dutzende Binaries
- **13 Framework-Katalog** `tab:wl-frameworks` (`03_messsystem_prtart.tex:248-270` = `03_state_of_the_art.tex:344-366`): YCSB, SOSD, TPC-C/DS, Real-String-Korpora, RocksDB, SPEC CPU, CloudSuite, IBM DB2, mimalloc-bench, Larson/threadtest/shbench, LADDIS, AggSum/Memory-Stream, Custom-Micro.
- **Abstraktions-Herz:** Frameworks → **14 kanonische Lastprofile LP01–LP14** (gemeinsames uint64-Op-Modell: Insert/Lookup/Erase/Scan/RMW), `tab:lp-catalog` (`03_messsystem_prtart.tex:272-304`). Jedes LP = Op-Mix-5-Tupel + Verteilung + neg% + abgeleitete Papers.
- **Workload als dynamische Achse / „als Instanzen"** (`03_state_of_the_art.tex:325`, `03_messsystem_prtart.tex:238`).
- **Lader-Anbindung statt Eigenimpl:** TPC/SOSD/SPEC/CloudSuite/Allok. über Datensatz-Lader (`03_state_of_the_art.tex:340-342`).
- **30 SOTA-Profile × `expected_workload`** (`tab:sota-profiles`, `03_messsystem_prtart.tex:314-356`); **Workload-Routing** (`06_evaluation_methodology.tex:68-80`); **6-Kanon** (`tab:datasets`, `06:87-102`); **3 Granularitäten** Micro/Makro/Gesamt (`06:26-37`).

### Ist (Code)
- Workload-Enums: 3 parallele Orte, ALLE nur YCSB A–F: `cmd::WorkloadKind` (`builder/commands/workload.hpp:18-28`), `YcsbWorkload` (`test_infra/workload_generator/...:22-29`), Driver-Welt (`builder/workload_driver/workload_config.hpp:26-34`). Profil-Tokens `workload_profiles.hpp:23-35` = A–F/IH/LH/OP1-6 — alles YCSB-abgeleitet.
- **Framework-/LP-Katalog: existiert NICHT** (grep LP01-14/cloudsuite/spec_cpu/tpcc/threadtest/laddis = 0). „mimalloc" nur als Allokator-ACHSE, nicht als Workload.
- Dataset-Loader: nur **2 von ~8**: `sosd_uint64_loader.hpp`, `string_corpus_loader.hpp` (`common/measurement/dataset_loader/`). TPC/SPEC/CloudSuite/mimalloc-bench = kein Code.
- **6-Kanon deckungsgleich** (`Code/test_data_xml/{url,pizzachili_dna,protein,xml,tpcds-id,trec-terms}.test_data.xml`), 4/6 akten-verifiziert (`test_25_kanon_dataset_akten.cpp:37-53`).
- **Bruch:** ce-Builder-Parser liest `builder/example_configs/test_data_sets.xml` (Root `<comdare>`, 3 Einträge) — NICHT an den 6-Kanon `*.test_data.xml` verdrahtet.
- #31-compile-time-Matrix REVERTIERT (G2 `8c73ef7c`); `builder/measurement_matrix/` = leeres Skelett.
- measurement-all-Zelle `comdare-workloads` (baseline_2, `mod/comdare-baseline_2-workloads/`): YCSB-only, `dataset/`-Registry **LEER** (keine konkreten Loader migriert).

### Lücke + Empfehlung
- ~11/13 Frameworks ohne Code · 0/14 LP-Profile · ~6 Framework-Loader fehlen · Struktur existiert nicht.
- **Architektur-Klärung (zur User-Bestätigung):** „eigene Bibliothek-Kategorie IN der cache-engine" = **Laufzeit-Workload-Bibliothek in `measurement-all/comdare-workloads`** (die die ce KONSUMIERT), NICHT compile-time-Insel in der ce-Library (= der revertierte #31-Fehlbau). Achse W = E4-XML-definiert + E1-Laufzeit (`is_static=false`, `DynamicVariableNode`), keine Binary-Identität (`15_F7...md:7-16`).
- **Dreiteilung:** (1) `comdare-workloads` BESITZT Framework×LP×Dataset (Framework-Registry/13 + 14-LP-Katalog + konkrete Loader + 6-Kanon-Akten); (2) ce KONSUMIERT via Runtime-`AxisLevel`{workload} + ABI-Descriptor (`comdare_workload_descriptor_v1`, `abi/module_abi_v1.hpp:19-27`) + `run_workload_profile` (`workload_driver/workload_orchestrator.hpp:65`); (3) E4-XML WÄHLT Instanzen. Anschluss = gated Schritt 13.
- Stimulus-Pfad: `discover_load_profiles` → String-`AxisLevel{workload,is_static=false}` → `perm_runner::run_workload_perm` → Registry/`profile_by_name` → `run_workload_profile`. Einziger Framework-Eintritt heute: `load_or_generate_ycsb(loader_source,...)` (`dataset_loader.hpp:106-116`).

## BAUSTEIN 2 — Paralleles Achsen-Messsystem

### Zentrale Klärung: „Mess-Achse" ist DREIFACH belegt
1. **19 Algorithmus-Achsen** (T0-T18) = das, wogegen gemessen wird.
2. **Per-Achsen-Observer** = Beobachter-Sicht der 19 selbst (`axis_stats[19][8]`, achsen-EIGENE Zähler) — NICHT das parallele System.
3. **Mess-Kategorien-Taxonomie** (CLU, Cache-Miss L1/L2/L3, dTLB, Branch, IPC/CPI, Latenz, Durchsatz, Energie) = **DAS gesuchte „parallele Achsen-Messsystem"** (Gütekriterien, für JEDES Lebewesen erhoben, orthogonal zu den 19).

### Soll (Thesis)
- **9 Mess-Kategorien** (`03_messsystem_prtart.tex:382-385`) + Zweiteilung observer-/zeit-basiert vs. zählerbasiert/PMC (`:384-386`).
- **Zwei-Regime-Orthogonalität:** PMC-Kategorien nur root-Linux (perf/MSR); observer/zeit-basierte unter beiden Regimen; Hybrid-CPU cpu_core/cpu_atom (`06_evaluation_methodology.tex:110-126`).
- **EINE Beobachter-Schnittstelle über alle 19 Organe** (`IObservableTier`, `04_concept_architecture.tex:220-221`; `03:416,430-431`).
- 3 Granularitäten über gemeinsames Kategorie-Interface (`03:497-503`). **Thesis = flacher Kategorie-Katalog, KEINE Mess-Achsen-Hierarchie.**

### Ist (Code) — fragmentiert
- `MeasurementCategory`-Enum (**16 Kategorien**, `measurement_category.hpp:9-26`) — DA, aber **ISOLIERT** (nur `thread_arena`/`in_memory_measurement_buffer` konsumieren; NICHT pruef_dock/perm_runner/abi_adapter).
- `Measure<Cat,Detail>` (orthogonale 2D-Matrix Kategorie×Algo, `measure.hpp:23`) — da als Typ, **~leer** (2 Spezialisierungen).
- `MeasurementRecord` (32-Byte, `category`+`algo_detail`, `measurement_record.hpp:11-21`).
- `IPmcSource`+`PmcCounters` (7 HW-Counter, ehrliches `available`, `pmc_source.hpp:19-48`) + `LinuxPerfPmcSource` + Factory — da, real, aber **schmal**.
- `ObserverAggregate<19>` + `kV3AxisSchema` + `IObservableTier::tier_observe` (I1-konsolidiert, `observable_tier.hpp:66-183`).
- `ComdareMeasurementSnapshotV1` (16+6-POD, `measurement_snapshot.hpp:34-66`) = Landeplatz.
- Klassifikationen: `AxisOperability` (`axis_operability_classification.hpp:20-53`), `AxisObserverKind` (`axis_observer_classification.hpp:26-79`).

### Was FEHLT + XML-Anschluss
1. **Vereinheitlichte `IMeasurementSource`** (vendor-neutral, Event-Auswahl, Capability) — FEHLT (nur Plan `20260531-mess-abstraktion-cross-platform-architektur-plan.md:81-135`). Real nur schmales `IPmcSource`.
2. **Mess-Achsen-Registry/Enable/Permutation** (erstklassig, parallel zu den 19) — FEHLT (kein Pendant zu `axis_*_registry.hpp`).
3. **Verdrahtung der Taxonomie in die Pipeline** — FEHLT (F1-Skelett entkoppelt).
4. **Mess-Kategorie-Profil als 4. orthogonale XML-Dimension** — FEHLT (heute nur 3 Profile: Build ⊥ Last ⊥ Compile-Release).
5. **XML-Auswahl der Mess-Kategorie/-Quelle je Experiment** — FEHLT (**0 XML-Treffer** für `<measurement>/<metrics>/<pmc>/<category>` in `algorithm_profiles/`). Heute: feste POD-Spalten + Compile-Flags (`COMDARE_MEASUREMENT_ON`, `COMDARE_ENABLE_PMC`) + OS-Regime.
- **SOLL-Anschluss:** additives `<measurement_categories>` (analog `<runtime_dynamic>`) → Parser → `CacheEngineConfig` → Prüf-Dock injiziert `IMeasurementSource` → `read_delta()` in POD-Spalten. = 4. orthogonale Mess-Kategorie-Dimension.

### Kern-Erkenntnis
Das parallele Mess-System ist **konzeptionell in der Thesis** (Kategorie-Katalog + observer/PMC-Zweiteilung + Zwei-Regime-Orthogonalität) und **im Code in Bruchstücken** (Taxonomie-Enum, PMC-Quelle, POD, Klassifikationen), aber **nirgends zu einem erstklassigen, XML-getriebenen, enumerierbaren Achsensystem mit gemeinsamer Wurzel-Abstraktion (`IMeasurementSource`) zusammengeführt** = die offene Integrations-Achse.
