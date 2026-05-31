# Z.3 — Soll-UML Diplomarbeit/Code/ (messung_driver Outer-Loop + Tool-Chain)

> ⚠️ **SUPERSEDED (2026-05-31):** Überholter Planungs-/Architektur-Stand (axis-zentrische Restruktur F.2, Plugin-Prüfling-Modell, DLL-F15-Pipeline, sezierte Organe). IST-treue Single-Source-of-Truth: `comdare-cache-engine/docs/sessions/architektur-ziele-offene-punkte-ledger.md` + `…/20260531-e2e-abnahme-audit-und-entscheidungen.md`. Niemals löschen — nur Banner.

**Stand:** 2026-05-18 (Z.3)
**Vorgaenger:** `Y3_diplomarbeit_code_ist_kartografie.md`
**Konsequenz:** V32+ messung_driver-Erweiterung + Tool-Chain-Integration

> Soll-UML fuer Subsystem 1 (Outer-Loop). Mermaid inline.

---

## §1 messung_driver Master-Klassen-Diagramm (V32+ Soll)

```mermaid
classDiagram
    class MessungDriver {
        <<main.cpp>>
        +int main(int argc, char** argv)
        -load_config(path: string) : XmlConfig
        -select_mode(mode_str: string) : MessreihenMode
        -run_messreihe(config, mode) : MeasurementBuffer
    }

    class XmlConfig {
        +messreihen_ : vector~Messreihe~
        +mode_ : MessreihenMode
        +dataset_source_ : DatasetSource
    }

    class MessreihenMode {
        <<Enum>>
        Defined  %% Standard fuer Manuskript-Plots
        Full  %% Vollstaendiger Permutations-Sweep
        FullSampled  %% Stichprobe ueber Full-Mode
    }

    class IDatasetLoader {
        <<Concept V32+>>
        +load_workload(name: string) : Workload
    }

    class HttpYcsbDatasetLoader {
        <<V32+ fuer Debian-Pod #109>>
        +base_url_ : string
        +load_workload(name) : Workload
        -http_get(url) : string
    }

    class LocalYcsbDatasetLoader {
        <<Fallback wenn kein Pod>>
        +load_workload(name) : Workload
    }

    class CacheEngineBuilderInvoker {
        <<wrapper um Subsystem 2>>
        +invoke(config, dataset) : MeasurementBuffer
    }

    class IPlatformPreCheck {
        <<NEU V32+>>
        +pre_check(host) : SupportedAxes
        +filter_messreihe(messreihe, supported_axes) : Messreihe
    }

    MessungDriver --> XmlConfig
    MessungDriver --> MessreihenMode
    MessungDriver --> IDatasetLoader
    MessungDriver --> CacheEngineBuilderInvoker
    MessungDriver --> IPlatformPreCheck
    IDatasetLoader <|.. HttpYcsbDatasetLoader
    IDatasetLoader <|.. LocalYcsbDatasetLoader
```

---

## §2 Tool-Chain Sequence-Diagramm (Phase 7 → thesis-Anhang)

```mermaid
sequenceDiagram
    participant User
    participant MD as messung_driver
    participant CEB as CacheEngineBuilder
    participant Bin as binary_to_csv
    participant Csv as csv_to_latex
    participant Dia as diagram_generator
    participant LaTeX as latex_to_pdf
    participant Thesis as thesis/main.pdf

    User->>MD: ./messung_driver --config=config_a.xml --mode=defined
    MD->>CEB: build_and_run(config, dataset)
    CEB-->>MD: results.bin (binary PermutationResult-Records)

    MD->>Bin: binary_to_csv results.bin -> results.csv
    Bin-->>MD: results.csv

    MD->>Csv: csv_to_latex results.csv -> results.tex
    Csv-->>MD: results.tex (tabular)

    MD->>Dia: diagram_generator results.bin -> plots/*.tex
    Dia-->>MD: plots/throughput_by_workload.tex etc.

    Note over MD,Thesis: User integriert via \input{} in thesis/chapters/
    User->>LaTeX: pdflatex thesis/main.tex
    LaTeX->>Thesis: thesis/main.pdf (~30 Seiten nach S-Phase)
```

---

## §3 Tool-Klassen-Diagramme

### §3.1 binary_to_csv

```mermaid
classDiagram
    class BinaryToCsv {
        +run(input_path: string, output_path: string) : int
        -read_permutation_result(stream) : PermutationResult
        -write_csv_row(row, stream)
    }

    class PermutationResult {
        +permutation_id : uint128_t
        +workload_used : Workload
        +throughput_ops_sec : double
        +latency_p99_ns : uint64_t
        +cache_misses : uint64_t
        +memory_footprint_bytes : uint64_t
        +H1_clu_improvement : double  %% siehe measurement/hypothesis_metrics
        +H2_layout_choice : LayoutChoice
        +H3_inline_external_decision : ValueHandleDecision
    }

    BinaryToCsv ..> PermutationResult
```

### §3.2 csv_to_latex

```mermaid
classDiagram
    class CsvToLatex {
        +run(input_path: string, output_path: string) : int
        -read_csv_header(stream) : vector~string~
        -read_csv_row(stream) : vector~string~
        -write_tabular_header(headers, stream)
        -write_tabular_row(row, stream)
    }
```

### §3.3 diagram_generator (V22.1 plot_by_workload)

```mermaid
classDiagram
    class DiagramGenerator {
        +run(input_path: string, output_dir: string) : int
        +plot_by_workload(results, output_path)
        +plot_throughput_vs_axis(results, axis_id, output_path)
        +plot_cache_miss_breakdown(results, output_path)
        -tikz_emit_axis(axis: TikzAxis, data: vector~Point~)
    }

    class TikzAxis {
        +x_label : string
        +y_label : string
        +a4_aware : bool = true  %% V22.1
    }

    DiagramGenerator ..> TikzAxis
```

### §3.4 sample_data_generator (V21.3, wird durch reale Daten ersetzt)

```mermaid
classDiagram
    class SampleDataGenerator {
        <<Standalone fuer Sample-Plots in thesis>>
        +generate(seed: uint64_t, n_records: size_t) : vector~PermutationResult~
        -generate_plausible_throughput(workload) : double
        -generate_plausible_latency(workload) : uint64_t
    }
```

---

## §4 V32+ messung_driver Erweiterung (Q.1 + #109)

```mermaid
sequenceDiagram
    participant User
    participant MD as messung_driver V32+
    participant Probe as IPlatformProbe (CE-Service)
    participant Filter as IPlatformPreCheck (V32+ NEU)
    participant Pod as Debian-Pod (#109) ycsb-data-provider
    participant CEB as CacheEngineBuilder

    User->>MD: ./messung_driver --config=config_a.xml
    MD->>Probe: discover_host()
    Probe-->>MD: PlatformSnapshot (SIMD-Support, NUMA-Nodes, ...)

    MD->>Filter: filter_supported_axes(messreihe, host)
    Filter-->>MD: SupportedAxes (z.B. AVX2 statt AVX-512 wenn nicht verfuegbar)

    MD->>Pod: http://ycsb-data-provider:8080/workloada-run.txt
    Pod-->>MD: YCSB-Trace

    MD->>CEB: build(filtered_messreihe, ycsb_workload)
    Note over CEB: Pipeline Phase 1-7 (siehe Z.4)
    CEB-->>MD: MeasurementBuffer
```

---

## §5 V32+ Klassen-Hierarchie (komplett)

```mermaid
classDiagram
    class MessungDriverV32 {
        +main(argc, argv) : int
        -platform_probe_ : IPlatformProbe&  %% NEU V32
        -pre_check_ : IPlatformPreCheck
        -dataset_loader_ : IDatasetLoader
        -invoker_ : CacheEngineBuilderInvoker
        -aggregator_ : ResultAggregator
    }

    class ResultAggregator {
        +collect(result: PermutationResult)
        +emit_csv(path)
        +emit_json(path)
        +emit_binary(path)
    }

    MessungDriverV32 --> IPlatformProbe
    MessungDriverV32 --> IPlatformPreCheck
    MessungDriverV32 --> IDatasetLoader
    MessungDriverV32 --> CacheEngineBuilderInvoker
    MessungDriverV32 --> ResultAggregator
```

---

## §6 drawio-Tab-Vorschlag fuer Z.3

| drawio-Tab | Inhalt |
|---|---|
| `Z3-MessungDriver-V32-Master` | Klassen-Diagramm Subsystem 1 mit allen V32+ Erweiterungen |
| `Z3-ToolChain-Pipeline` | Sequence vom Run-Beginn bis thesis-PDF |

---

## §7 Querverweise

- Y.3 Ist-Kartografie: `Y3_diplomarbeit_code_ist_kartografie.md`
- Q.1 Datasets-Plan: `../adapters/Q_PHASE_DATASETS_F_EXTRA_PLAN.md` §1
- I109 Debian-Pod: `../infra/I109_DEBIAN_POD_YCSB_DATA_PROVIDER.md`
- M-Modell Subsystem 1: `../architektur/10_schichten_modell_M.md` §2.1
- Z.1 cache-engine-Pendant: `Z1_soll_uml_cache_engine.md`

---

**Ende docs/uml_planning/Z3_soll_uml_diplomarbeit_code.md (Z.3 DONE).**
